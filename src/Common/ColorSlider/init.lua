local Roact = require(script.Parent.Parent.Libraries.Roact) :: Roact
local HueSlider = require(script.HueSlider)
local SaturationSlider = require(script.SaturationSlider)
local ValueSlider = require(script.ValueSlider)

return function(Props)
	return Roact.createElement("Frame", {
		Size = Props.Size,
		Position = Props.Position,
	}, {
		Hue = Roact.createElement(HueSlider, {
			Size = UDim2.fromScale(1/3, 1),
			Position = UDim2.fromScale(0, 0),
			Color = Props.Color,
			OnHueChanged = Props.OnColorChanged,
		}),
		Saturation = Roact.createElement(SaturationSlider, {
			Size = UDim2.fromScale(1/3, 1),
			Position = UDim2.fromScale(1/3, 0),
			OnSaturationChanged = Props.OnColorChanged,
			Color = Props.Color
		}),
		Value = Roact.createElement(ValueSlider, {
			Size = UDim2.fromScale(1/3, 1),
			Position = UDim2.fromScale(2/3, 0),
			OnValueChanged = Props.OnColorChanged,
			Color = Props.Color
		})
	})
end