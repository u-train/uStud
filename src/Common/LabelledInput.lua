local Roact = require(script.Parent.Parent.Packages.Roact)
local ControlledInput = require(script.Parent.ControlledInput)

return function(Props)
	return Roact.createElement("Frame", {
		Size = Props.Size,
		Position = Props.Position,
	}, {
		Label = Roact.createElement("TextLabel", {
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
