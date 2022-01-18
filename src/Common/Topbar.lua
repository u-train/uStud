local Packages = script.Parent.Parent.Packages
local Roact = require(Packages.Roact)
local RoactRouter = require(Packages.RoactRouter)
local StudioComponents = require(Packages.StudioComponents)

return function(Props)
	return RoactRouter.withRouter(function(RouterInfo)
		if Props.ShowReturnBack then
			return Roact.createElement("Frame", {
				Position = Props.Position,
				Size = Props.Size,
				BackgroundTransparency = 1
			}, {
				ReturnBack = Roact.createElement(StudioComponents.Button, {
					Size = UDim2.new(0, 25, 1, 0),
					Text = "<",
					OnActivated = function()
						RouterInfo.history:goBack()
					end,
				}),
				Title = Roact.createElement(StudioComponents.Label, {
					Size = UDim2.new(1, -25, 1, 0),
					Position = UDim2.new(0, 25, 0, 0),
					TextSize = 16,
					Font = Enum.Font.SourceSansBold,
					Text = Props.Title,
				}),
			})
		else
			return Roact.createElement(StudioComponents.Label, {
				Position = Props.Position,
				Size = Props.Size,
				Text = Props.Title,
			})
		end
	end)
end
