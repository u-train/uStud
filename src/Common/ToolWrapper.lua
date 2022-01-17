local Roact = require(script.Parent.Parent.Packages.Roact)
local RoactRouter = require(script.Parent.Parent.Packages.RoactRouter)

local Common = script.Parent
local TopBar = require(Common.Topbar)
local LabelledInput = require(Common.LabelledInput)
local ListLayout = require(Common.ListLayout)

local InstanceSelector = require(Common.InstanceSelector)

return function(Props)
	return RoactRouter.withRouter(function(RouterInfo)
		return Roact.createFragment({
			TopBar = Roact.createElement(TopBar, {
				Title = Props.Title,
				ShowReturnBack = true,
				Size = UDim2.new(1, 0, 0, 25),
				OnReturn = function()
					RouterInfo.history:goBack()
				end,
			}),
			View = Roact.createElement(ListLayout, {
				Size = UDim2.new(1, 0, 1, -55),
				Position = UDim2.new(0, 0, 0, 25),
			}, Props[Roact.Children]),
			Bottombar = Roact.createElement(LabelledInput, {
				Value = InstanceSelector.EscapeFullName(Props.EditingIn),
				Size = UDim2.new(1, 0, 0, 25),
				Position = UDim2.new(0, 0, 1, -25),
				Label = "Editing In",

				OnValueChanged = function(Text)
					local Success, Value = pcall(InstanceSelector.Select, game, Text)

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
