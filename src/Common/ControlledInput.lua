--[=[
	@class ControlledInput
	Input but it's explicitly controlled by a binding. It also only updates
	properly whenever the user is out of focus. Additionally, the text is reset
	if the prop value hasn't changed.

	![ControlledInput rendered](/uStud/rendered/controlledInput.png)
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
	Initalize internal binding.
]=]
function ControlledInput:init()
	self.internalValue, self.updateInternalValue = Roact.createBinding(self.props.value)
end

--[=[
	Renders.
	@return RoactTree
]=]
function ControlledInput:render()
	return Roact.createElement(StudioComponents.TextInput, {
		Text = self.internalValue,
		Size = self.props.size or UDim2.new(1, 0, 0, 25),
		Position = self.props.position,
		LayoutOrder = self.props.layoutOrder,
		BorderSizePixel = self.props.borderSizePixel or 0,

		TextColor3 = self.props.textColor3,
		BackgroundColor3 = self.props.backgroundColor3,
		BorderColor3 = self.props.borderColor3,
		BorderMode = Enum.BorderMode.Inset,

		OnChanged = function(text)
			self.updateInternalValue(text)
		end,
		OnFocus = function()
			if self.props.clearTextOnFocus then
				self.updateInternalValue("")
			end
		end,
		OnFocusLost = function(_)
			local newText = self.internalValue:getValue()
			self.updateInternalValue(self.props.value)
			self.props.onValueChanged(newText)
		end,

		ClearTextOnFocus = false,
	})
end

--[=[
	Make sure to capture the lastest value.
]=]
function ControlledInput:willUpdate(nextProps)
	self.updateInternalValue(nextProps.value)
end

return ControlledInput
