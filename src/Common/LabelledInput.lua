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

return function(Props)
	return Roact.createElement(StudioComponents.Background, {
		Size = Props.Size,
		Position = Props.Position,
	}, {
		Label = Roact.createElement(StudioComponents.Label, {
			Size = UDim2.new(0, Props.TextWidth or 100, 1, 0),
			Text = Props.Label,
		}),
		Input = Roact.createElement(ControlledInput, {
			Value = Props.Value,
			OnValueChanged = Props.OnValueChanged,
			Size = UDim2.new(1, -(Props.TextWidth or 100), 1, 0),
			Position = UDim2.new(0, Props.TextWidth or 100, 0, 0),
		}),
	})
end
