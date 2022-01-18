local Packages = script.Parent.Parent.Packages
local Roact = require(Packages.Roact)
local StudioComponents = require(Packages.StudioComponents)

local ControlledInput = Roact.Component:extend("ControlledInput")

function ControlledInput:init()
	self.InternalValue, self.UpdateInternalValue = Roact.createBinding(self.props.Value)
end

function ControlledInput:render()
	return Roact.createElement(StudioComponents.TextInput, {
		Text = self.InternalValue,
		Size = self.props.Size or UDim2.new(1, 0, 0, 25),
		Position = self.props.Position,
		LayoutOrder = self.props.LayoutOrder,
		BorderSizePixel = self.props.BorderSizePixel or 0,

		TextColor3 = self.props.TextColor3,
		BackgroundColor3 = self.props.BackgroundColor3,
		BorderColor3 = self.props.BorderColor3,
		BorderMode = Enum.BorderMode.Inset,

		OnChanged = function(Text)
			self.UpdateInternalValue(Text)
		end,
		OnFocus = function()
			if self.props.ClearTextOnFocus then
				self.UpdateInternalValue("")
			end
		end,
		OnFocusLost = function(_)
			self.props.OnValueChanged(self.InternalValue:getValue())
			self.UpdateInternalValue(self.props.Value)
		end,

		ClearTextOnFocus = false,
	})
end

function ControlledInput:willUpdate(NextProps)
	self.UpdateInternalValue(NextProps.Value)
end

return ControlledInput
