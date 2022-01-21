--[=[
	@class LabelledInput
	A component which wraps a ControlledInput and puts a label next to it.

	![LabelledInput rendered](/uStud/rendered/labelledInput.png)
]=]

--[=[
	@within LabelledInput
	@interface Props
	.Size UDim2
	.Position UDim2
	.TextWidth number
	.OnValueChanged (string) -> nil
	.Label string
]=]

local Roact = require(script.Parent.Parent.Packages.Roact)
local StudioComponents = require(script.Parent.Parent.Packages.StudioComponents)
local ControlledInput = require(script.Parent.ControlledInput)

return function(props)
	return Roact.createElement(StudioComponents.Background, {
		Size = props.Size,
		Position = props.Position,
	}, {
		Label = Roact.createElement(StudioComponents.Label, {
			Size = UDim2.new(0, props.TextWidth or 100, 1, 0),
			Text = props.Label,
		}),
		Input = Roact.createElement(ControlledInput, {
			Value = props.Value,
			OnValueChanged = props.OnValueChanged,
			Size = UDim2.new(1, -(props.TextWidth or 100), 1, 0),
			Position = UDim2.new(0, props.TextWidth or 100, 0, 0),
		}),
	})
end
