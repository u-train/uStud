--[=[
	@class ToolWrapper
	A helper component which takes a tool and wraps it in a topbar and a input
	for EditingIn. Additionally, places the tool into a scrollframe.
]=]

--[=[
	@within ToolWrapper
	@interface Props
	.Title string
	.EditingIn Instance
	.EditingInChanged (Instance) -> nil
]=]

local Packages = script.Parent.Parent.Packages
local Roact = require(Packages.Roact)
local RoactRouter = require(Packages.RoactRouter)
local InstanceQuerier = require(Packages.InstanceQuerier)
local StudioComponents = require(Packages.StudioComponents)

local Common = script.Parent
local Topbar = require(Common.Topbar)
local LabelledInput = require(Common.LabelledInput)

return function(Props)
	return RoactRouter.withRouter(function(RouterInfo)
		return Roact.createFragment({
			Topbar = Roact.createElement(Topbar, {
				Title = Props.Title,
				ShowReturnBack = true,
				Size = UDim2.new(1, 0, 0, 25),
				OnReturn = function()
					RouterInfo.history:goBack()
				end,
			}),
			View = Roact.createElement(StudioComponents.ScrollFrame, {
				Size = UDim2.new(1, 0, 1, -55),
				Position = UDim2.new(0, 0, 0, 25),
			}, Props[Roact.Children]),
			Bottombar = Roact.createElement(LabelledInput, {
				Value = InstanceQuerier.EscapeFullName(Props.EditingIn),
				Size = UDim2.new(1, 0, 0, 25),
				Position = UDim2.new(0, 0, 1, -25),
				Label = "Editing In",

				OnValueChanged = function(Text)
					local Success, Value = pcall(InstanceQuerier.Select, game, Text)

					if Success then
						if Value == workspace or Value == game then
							return
						end
						Props.EditingInChanged(Value)
					end
				end,
			}),
		})
	end)
end
