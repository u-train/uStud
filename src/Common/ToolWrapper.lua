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
				Title = props.title,
				ShowReturnBack = true,
				Size = UDim2.new(1, 0, 0, 25),
				OnReturn = function()
					routerInfo.history:goBack()
				end,
			}),
			View = Roact.createElement(StudioComponents.ScrollFrame, {
				Size = UDim2.new(1, 0, 1, -55),
				Position = UDim2.new(0, 0, 0, 25),
			}, props[Roact.Children]),
			Bottombar = Roact.createElement(LabelledInput, {
				Value = InstanceQuerier.EscapeFullName(props.root),
				Size = UDim2.new(1, 0, 0, 25),
				Position = UDim2.new(0, 0, 1, -25),
				Label = "Editing under",

				OnValueChanged = function(text)
					local success, value = pcall(InstanceQuerier.Select, game, text)

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
