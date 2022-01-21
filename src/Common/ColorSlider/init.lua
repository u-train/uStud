--[=[
	@class ColorSlider
	This component creates a HSV slider.

	![Rendered ColorSlidered](/uStud/rendered/colorSlider.png)
]=]

--[=[
	@within ColorSlider
	@interface Props
	.Size UDim2
	.Position UDim2
	.Color Color3
	.OnColorChanged (Color3) -> nil
]=]

local Roact = require(script.Parent.Parent.Packages.Roact) :: Roact
local HueSlider = require(script.HueSlider)
local SaturationSlider = require(script.SaturationSlider)
local ValueSlider = require(script.ValueSlider)

return function(props)
	return Roact.createElement("Frame", {
		Size = props.Size,
		Position = props.Position,
	}, {
		Hue = Roact.createElement(HueSlider, {
			Size = UDim2.fromScale(1 / 3, 1),
			Position = UDim2.fromScale(0, 0),
			Color = props.Color,
			OnHueChanged = props.OnColorChanged,
		}),
		Saturation = Roact.createElement(SaturationSlider, {
			Size = UDim2.fromScale(1 / 3, 1),
			Position = UDim2.fromScale(1 / 3, 0),
			OnSaturationChanged = props.OnColorChanged,
			Color = props.Color,
		}),
		Value = Roact.createElement(ValueSlider, {
			Size = UDim2.fromScale(1 / 3, 1),
			Position = UDim2.fromScale(2 / 3, 0),
			OnValueChanged = props.OnColorChanged,
			Color = props.Color,
		}),
	})
end
