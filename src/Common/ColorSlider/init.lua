--[=[
	@class ColorSlider
	This component creates a HSV slider.

	![Rendered ColorSlidered](/uStud/rendered/colorSlider.png)
]=]

--[=[
	@within ColorSlider
	@interface Props
	.size UDim2
	.position UDim2
	.color Color3
	.onColorChanged (Color3) -> nil
]=]

local Roact = require(script.Parent.Parent.Packages.Roact) :: Roact
local HueSlider = require(script.HueSlider)
local SaturationSlider = require(script.SaturationSlider)
local ValueSlider = require(script.ValueSlider)

return function(props)
	return Roact.createElement("Frame", {
		Size = props.size,
		Position = props.position,
	}, {
		Hue = Roact.createElement(HueSlider, {
			size = UDim2.fromScale(1 / 3, 1),
			position = UDim2.fromScale(0, 0),
			color = props.color,
			onHueChanged = props.onColorChanged,
		}),
		Saturation = Roact.createElement(SaturationSlider, {
			size = UDim2.fromScale(1 / 3, 1),
			position = UDim2.fromScale(1 / 3, 0),
			color = props.color,
			onSaturationChanged = props.onColorChanged,
		}),
		Value = Roact.createElement(ValueSlider, {
			size = UDim2.fromScale(1 / 3, 1),
			position = UDim2.fromScale(2 / 3, 0),
			color = props.color,
			onValueChanged = props.onColorChanged,
		}),
	})
end
