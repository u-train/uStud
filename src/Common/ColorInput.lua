--[=[
	@class ColorInput
	This component creates a labelled color input with the following:
	* A swab
	* RGB Text input
	* HSV Slider input

	![ColorInput rendered](/uStud/rendered/colorInput.png)
]=]

--[=[
	@within ColorInput
	@interface Props
	.size UDim2
	.position UDim2
	.color Color3
	.onColorChanged (Color3) -> nil
	.label string
]=]

local Packages = script.Parent.Parent.Packages
local Roact = require(Packages.Roact) :: Roact
local StudioComponents = require(Packages.StudioComponents)

local ColorSlider = require(script.Parent.ColorSlider)
local TextColorInput = require(script.Parent.TextColorInput)

return function(props)
	return Roact.createElement("Frame", {
		Size = props.size,
		Position = props.position,
		BackgroundTransparency = 1
	}, {
		Swab = Roact.createElement("Frame", {
			BackgroundColor3 = props.color,
			Size = UDim2.new(0, 10, 1, 0),
		}),
		Label = Roact.createElement(StudioComponents.Label, {
			Text = props.label,
			Size = UDim2.new(0, 90, 1, 0),
			Position = UDim2.new(0, 10, 0, 0)
		}),
		Text = Roact.createElement(TextColorInput, {
			position = UDim2.new(0, 100, 0, 0),
			size = UDim2.new(1, -100, 0.5, 0),
			color = props.color,
			label = props.label,
			onColorChanged = props.onColorChanged,
		}),
		Slider = Roact.createElement(ColorSlider, {
			size = UDim2.new(1, -100, 0.5, 0),
			position = UDim2.new(0, 100, 0.5, 0),
			color = props.color,
			onColorChanged = props.onColorChanged,
		}),
	})
end
