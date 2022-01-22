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
	.Size UDim2
	.Position UDim2
	.Color Color3
	.OnColorChanged (Color3) -> nil
	.Label string
]=]

local Packages = script.Parent.Parent.Packages
local Roact = require(Packages.Roact) :: Roact
local StudioComponents = require(Packages.StudioComponents)

local ColorSlider = require(script.Parent.ColorSlider)
local TextColorInput = require(script.Parent.TextColorInput)

return function(props)
	return Roact.createElement("Frame", {
		Size = props.Size,
		Position = props.Position,
		BackgroundTransparency = 1
	}, {
		Label = Roact.createElement(StudioComponents.Label, {
			Text = props.Label,
			Size = UDim2.new(0, 90, 1, 0),
			Position = UDim2.new(0, 10, 0, 0)
		}),
		Swab = Roact.createElement("Frame", {
			BackgroundColor3 = props.Color,
			Size = UDim2.new(0, 10, 1, 0),
		}),
		Text = Roact.createElement(TextColorInput, {
			position = UDim2.new(0, 100, 0, 0),
			size = UDim2.new(1, -100, 0.5, 0),
			color = props.Color,
			label = props.Label,
			onColorChanged = props.OnColorChanged,
		}),
		Slider = Roact.createElement(ColorSlider, {
			Size = UDim2.new(1, -100, 0.5, 0),
			Position = UDim2.new(0, 100, 0.5, 0),
			Color = props.Color,
			OnColorChanged = props.OnColorChanged,
		}),
	})
end
