--[=[
	@class ControlledInput
	Input but it's explicitly controlled by a binding. It also only updates
	properly whenever the user is out of focus. Additionally, the text is reset
	if the prop value hasn't changed.

	![ControlledInput rendered](/rendered/controlledInput.png)
]=]

--[=[
	@within ControlledInput
	@interface Props
	.Size UDim2
	.Position UDim2
	.Value string
	.TextColor3 Color3
	.LayoutOrder number
	.BorderSizePixel number
	.BorderColor3 Color3
	.OnValueChanged (Text) -> nil
	.ClearTextOnFocus boolean
]=]

local Packages = script.Parent.Parent.Packages
local Roact = require(Packages.Roact)
local StudioComponents = require(Packages.StudioComponents)

local ControlledInput = Roact.Component:extend("ControlledInput")

--[=[

]=]
function ControlledInput:init()
	self.InternalValue, self.UpdateInternalValue = Roact.createBinding(self.props.Value)
end

--[=[

]=]
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
			local NewText = self.InternalValue:getValue()
			self.UpdateInternalValue(self.props.Value)
			self.props.OnValueChanged(NewText)
		end,

		ClearTextOnFocus = false,
	})
end

--[=[

]=]
function ControlledInput:willUpdate(NextProps)
	self.UpdateInternalValue(NextProps.Value)
end

return ControlledInput
