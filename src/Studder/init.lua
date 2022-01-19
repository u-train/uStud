local ContextActionService = game:GetService("ContextActionService")

local Roact = require(script.Parent.Packages.Roact)
local StudioComponents = require(script.Parent.Packages.StudioComponents)

local Common = script.Parent.Common
local LabelledInput = require(Common.LabelledInput)
local ColorInput = require(Common.ColorInput)
local ToolWrapper = require(Common.ToolWrapper)

local StudderMouseControl = require(script.MouseController)

--[=[
	@class Studder
	Tool for studding. It works quite well, to say the least.

	It has the following hotkeys:
	- `V` to multiply snapping interval by 2
	- `C` to divide snapping interval by 2
	- `Z` to multiply part size by 2
	- `X` to divide part size by 2
	- `R` to toggle deleting or inserting

	Some facts:
	- MaxSize = 200
	- MinSize = 0.05
	- MaxHeightOffset = 10
	- MinHeightOffset = -10
	- MaxHeight = 5
	- MinHeight = 0.05
]=]
local Studder = Roact.Component:extend("Studder")

local MaxSize = 200
local MinSize = 0.05
local MaxHeightOffset = 10
local MinHeightOffset = -10
local MaxHeight = 5
local MinHeight = 0.05

local ActionNames = {
	IncreasePartSize = "IncreasePartSize",
	DecreasePartSize = "DecreasePartSize",
	IncreaseSnappingInterval = "IncreaseSnappingInterval",
	DecreaseSnappingInterval = "DecreaseSnappingInterval",
	ToggleDelete = "ToggleDelete",
}

--[=[
	@within Studder
	@interface Props
	.EditingIn Instance
	.EditingInChanged (string) -> nil
	.HeightOffset number
	.HeightOffsetChanged (number) -> nil
]=]
--[=[

]=]
function Studder:init()
	self:setState({
		SnappingInterval = 1,
		PartSize = 1,
		PartColor = Color3.fromRGB(163, 162, 165),
		PartHeight = 1,
		Deleting = false,
	})

	self:BindHotkeys()
end

--[=[
function Studder:willUnmount()
	for _, ActionName in next, ActionNames do
		ContextActionService:UnbindAction(ActionName)
	end
end

--[=[

]=]
function Studder:render()
	return Roact.createElement(ToolWrapper, {
		Title = "Studder",
		EditingIn = self.props.EditingIn,
		EditingInChanged = self.props.EditingInChanged,
	}, {
		PartSizeInput = Roact.createElement(LabelledInput, {
			Value = self.state.PartSize,
			Size = UDim2.new(1, 0, 0, 25),
			Label = "Part Size",

			OnValueChanged = function(Text)
				local NewSize = tonumber(Text)

				if NewSize == nil then
					return
				end

				self:UpdatePartSize(NewSize)
			end,
		}),
		HeightOffsetInput = Roact.createElement(LabelledInput, {
			Value = self.props.HeightOffset,
			Size = UDim2.new(1, 0, 0, 25),
			Label = "Height offset",

			OnValueChanged = function(Text)
				local NewValue = tonumber(Text)

				if NewValue == nil then
					return
				end

				self.props.HeightOffsetChanged(math.clamp(NewValue, MinHeightOffset, MaxHeightOffset))
			end,
		}),
		PartHeightInput = Roact.createElement(LabelledInput, {
			Value = self.state.PartHeight,
			Size = UDim2.new(1, 0, 0, 25),
			Label = "Part Height",

			OnValueChanged = function(Text)
				local NewValue = tonumber(Text)

				if NewValue == nil then
					return
				end

				NewValue = math.clamp(NewValue, MinHeight, MaxHeight)

				self:setState({
					PartHeight = NewValue,
				})
			end,
		}),
		SnappingInput = Roact.createElement(LabelledInput, {
			Value = self.state.SnappingInterval,
			Size = UDim2.new(1, 0, 0, 25),
			Label = "Snapping Interval",

			OnValueChanged = function(Text)
				local NewInterval = tonumber(Text)

				if NewInterval == nil then
					return
				end

				self:setState({
					SnappingInterval = math.min(NewInterval, self.state.PartSize),
				})
			end,
		}),
		ColorInput = Roact.createElement(ColorInput, {
			Color = self.state.PartColor,
			Label = "Part Color",
			Size = UDim2.new(1, 0, 0, 30),
			OnColorChanged = function(NewColor)
				self:setState({
					PartColor = NewColor,
				})
			end,
		}),
		ToggleDelete = Roact.createElement(StudioComponents.Button, {
			Text = self.state.Deleting and "Currently deleting" or "Currently placing",
			Size = UDim2.new(1, 0, 0, 25),
			OnActivated = function()
				self:setState({
					Deleting = not self.state.Deleting,
				})
			end,
		}),
		Roact.createElement(StudderMouseControl, {
			SnappingInterval = self.state.SnappingInterval,
			PartSize = self.state.PartSize,
			PartColor = self.state.PartColor,
			PartHeight = self.state.PartHeight,
			HeightOffset = self.props.HeightOffset,
			Deleting = self.state.Deleting,
			EditingIn = self.props.EditingIn,
		}),
	})
end

--[=[

]=]
function Studder:UpdatePartSize(To)
	local NewPartSize = math.clamp(To, MinSize, MaxSize)

	self:setState({
		PartSize = NewPartSize,
		SnappingInterval = NewPartSize,
	})
end

--[=[

]=]
function Studder:UpdateSnappingInterval(To)
	self:setState({
		SnappingInterval = math.min(math.clamp(To, MinSize, MaxSize), self.state.PartSize),
	})
end

--[=[

]=]
function Studder:BindHotkeys()
	ContextActionService:BindAction(ActionNames.IncreaseSnappingInterval, function(_, State)
		if State ~= Enum.UserInputState.Begin then
			return
		end

		self:UpdateSnappingInterval(self.state.SnappingInterval * 2)
	end, false, Enum.KeyCode.V)

	ContextActionService:BindAction(ActionNames.DecreaseSnappingInterval, function(_, State)
		if State ~= Enum.UserInputState.Begin then
			return
		end

		self:UpdateSnappingInterval(self.state.SnappingInterval / 2)
	end, false, Enum.KeyCode.C)

	ContextActionService:BindAction(ActionNames.IncreasePartSize, function(_, State)
		if State ~= Enum.UserInputState.Begin then
			return
		end

		self:UpdatePartSize(self.state.PartSize * 2)
	end, false, Enum.KeyCode.Z)

	ContextActionService:BindAction(ActionNames.DecreasePartSize, function(_, State)
		if State ~= Enum.UserInputState.Begin then
			return
		end

		self:UpdatePartSize(self.state.PartSize / 2)
	end, false, Enum.KeyCode.X)

	ContextActionService:BindAction(ActionNames.ToggleDelete, function(_, State)
		if State ~= Enum.UserInputState.Begin then
			return
		end

		self:setState({ Deleting = not self.state.Deleting })
	end, false, Enum.KeyCode.R)
end

return Studder
