--[=[
	@class ToolWrapper
	A helper component which takes a tool and wraps it in a topbar and a input
	for Root. Additionally, places the tool into a scrollframe.
]=]

--[=[
	@within ToolWrapper
	@interface Props
	.Title string
	.Root Instance
	.rootChanged (Instance) -> nil
]=]

local Packages = script.Parent.Parent.Packages
local Roact = require(Packages.Roact)
local RoactRouter = require(Packages.RoactRouter)
local InstanceQuerier = require(Packages.InstanceQuerier)
local StudioComponents = require(Packages.StudioComponents)

local Common = script.Parent
local Topbar = require(Common.Topbar)
local LabelledInput = require(Common.LabelledInput)

return function(props)
	return RoactRouter.withRouter(function(routerInfo)
		return Roact.createFragment({
			Topbar = Roact.createElement(Topbar, {
				title = props.title,
				showReturnBack = true,
				size = UDim2.new(1, 0, 0, 25),
				onReturn = function()
					routerInfo.history:goBack()
				end,
			}),
			View = Roact.createElement(StudioComponents.ScrollFrame, {
				Size = UDim2.new(1, 0, 1, -55),
				Position = UDim2.new(0, 0, 0, 25),
			}, props[Roact.Children]),
			Bottombar = Roact.createElement(LabelledInput, {
				value = InstanceQuerier.escapeFullName(props.root),
				size = UDim2.new(1, 0, 0, 25),
				position = UDim2.new(0, 0, 1, -25),
				label = "Editing under",

				onValueChanged = function(text)
					local success, value = InstanceQuerier.select(game, text)

					if success then
						if value == workspace or value == game then
							return
						end
						props.rootChanged(value)
					end
				end,
			}),
		})
	end)
end
