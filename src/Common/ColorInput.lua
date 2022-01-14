local Roact = require(script.Parent.Parent.Libraries.Roact) :: Roact
local ColorSliderComponent = require(script.Parent.ColorSlider)
local TextColorInput = require(script.Parent.TextColorInput)

return function(Props)
	return Roact.createElement("Frame", {
		Size = Props.Size,
		Position = Props.Position,
	}, {
		Text = Roact.createElement(TextColorInput, {
			Color = Props.Color,
			Label = Props.Label,
			Size = UDim2.new(1, 0, 0.5, 0),
			OnColorChanged = Props.OnColorChanged
		}),
		Slider = Roact.createElement(ColorSliderComponent, {
			Size = UDim2.new(1, 0, 0.5, 0),
			Position = UDim2.new(0, 0, 0.5, 0),
			Color = Props.Color,
			OnColorChanged = Props.OnColorChanged
		}),
	})
end
