local Roact = require(script.Parent.Libraries.Roact)

local ControlledInput = Roact.Component:extend("ControlledInput")

function ControlledInput:init()
	self.InternalValue,
	self.UpdateInternalValue = Roact.createBinding(self.props.Value)
end

function ControlledInput:render()
	self.UpdateInternalValue(self.props.Value)
	return Roact.createElement(
		"TextBox",
		{
			Text = self.InternalValue,
			Size = self.props.Size or UDim2.new(1, 0, 0, 25),
			Position = self.props.Position,
			LayoutOrder = self.props.LayoutOrder or 0,
			BorderSizePixel = self.props.BorderSizePixel or 0,

			TextColor3 = self.props.TextColor3,
			BackgroundColor3 = self.props.BackgroundColor3,
			BorderColor3 = self.props.BorderColor3,
			BorderMode = Enum.BorderMode.Inset,

			[Roact.Change.Text] = function(Rbx)
				self.UpdateInternalValue(Rbx.Text)
			end,
			[Roact.Event.Focused] = function()
				if self.props.ClearTextOnFocus then
					self.UpdateInternalValue("")
				end
			end,
			[Roact.Event.FocusLost] = function(Rbx)
				self.props.OnValueChanged(Rbx.Text)
				Rbx.Text=self.props.Value
			end,

			ClearTextOnFocus = false,
		}
	)
end

return ControlledInput