--[=[
	@class LabelledInput
	A component which wraps a ControlledInput and puts a label next to it.

	![LabelledInput rendered](/uStud/rendered/labelledInput.png)
]=]

--[=[
	@within LabelledInput
	@interface Props
	.size UDim2
	.position UDim2
	.textWidth number
	.onValueChanged (string) -> nil
	.label string
	.layoutOrder number
]=]

local Roact = require(script.Parent.Parent.Packages.Roact)
local StudioComponents = require(script.Parent.Parent.Packages.StudioComponents)
local ControlledInput = require(script.Parent.ControlledInput)

return function(props)
	return Roact.createElement(StudioComponents.Background, {
		Size = props.size,
		Position = props.position,
		LayoutOrder = props.layoutOrder
	}, {
		Label = Roact.createElement(StudioComponents.Label, {
			Size = UDim2.new(0, props.textWidth or 100, 1, 0),
			Text = props.label,
		}),
		Input = Roact.createElement(ControlledInput, {
			value = props.value,
			onValueChanged = props.onValueChanged,
			size = UDim2.new(1, -(props.textWidth or 100), 1, 0),
			position = UDim2.new(0, props.textWidth or 100, 0, 0),
		}),
	})
end
