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
	- minSize = 0.05
	- maxHeightOffset = 10
	- minHeightOffset = -10
	- maxHeight = 5
	- minHeight = 0.05

	The menu for it looks like this:

	![Studder's menu](/uStud/rendered/studder.png)
]=]
local Studder = Roact.Component:extend("Studder")

local maxSize = 200
local minSize = 0.05
local maxHeightOffset = 10
local minHeightOffset = -10
local maxHeight = 5
local minHeight = 0.05

local actionNames = {
	increasePartSize = "increasePartSize",
	decreasePartSize = "decreasePartSize",
	increaseSnappingInterval = "increaseSnappingInterval",
	decreaseSnappingInterval = "decreaseSnappingInterval",
	toggleDelete = "toggleDelete",
}

--[=[
	@within Studder
	@interface Props
	.root Instance
	.editingInChanged (string) -> nil
	.heightOffset number
	.heightOffsetChanged (number) -> nil
]=]
--[=[
	Sets state and binds hotkeys.
]=]
function Studder:init()
	self:setState({
		snappingInterval = 1,
		partSize = 1,
		partColor = Color3.fromRGB(163, 162, 165),
		partHeight = 1,
		deleting = false,
	})

	self:bindHotkeys()
end

--[=[
	Here to unbind all the hotkeys.
]=]
function Studder:willUnmount()
	for _, actionName in next, actionNames do
		ContextActionService:UnbindAction(actionName)
	end
end

--[=[
	Render.
	@return RoactTree
]=]
function Studder:render()
	return Roact.createElement(ToolWrapper, {
		Title = "Studder",
		Root = self.props.root,
		EditingInChanged = self.props.editingInChanged,
	}, {
		partSizeInput = Roact.createElement(LabelledInput, {
			Value = self.state.partSize,
			Size = UDim2.new(1, 0, 0, 25),
			Label = "Part Size",

			OnValueChanged = function(text)
				local newSize = tonumber(text)

				if newSize == nil then
					return
				end

				self:updatePartSize(newSize)
			end,
		}),
		heightOffsetInput = Roact.createElement(LabelledInput, {
			Value = self.props.heightOffset,
			Size = UDim2.new(1, 0, 0, 25),
			Label = "Height offset",

			OnValueChanged = function(text)
				local newValue = tonumber(text)

				if newValue == nil then
					return
				end

				self.props.heightOffsetChanged(math.clamp(newValue, minHeightOffset, maxHeightOffset))
			end,
		}),
		partHeightInput = Roact.createElement(LabelledInput, {
			Value = self.state.partHeight,
			Size = UDim2.new(1, 0, 0, 25),
			Label = "Part Height",

			OnValueChanged = function(text)
				local newValue = tonumber(text)

				if newValue == nil then
					return
				end

				newValue = math.clamp(newValue, minHeight, maxHeight)

				self:setState({
					partHeight = newValue,
				})
			end,
		}),
		SnappingInput = Roact.createElement(LabelledInput, {
			Value = self.state.snappingInterval,
			Size = UDim2.new(1, 0, 0, 25),
			Label = "Snapping Interval",

			OnValueChanged = function(text)
				local newInterval = tonumber(text)

				if newInterval == nil then
					return
				end

				self:setState({
					snappingInterval = math.min(newInterval, self.state.partSize),
				})
			end,
		}),
		ColorInput = Roact.createElement(ColorInput, {
			Color = self.state.partColor,
			Label = "Part Color",
			Size = UDim2.new(1, 0, 0, 30),
			OnColorChanged = function(newColor)
				self:setState({
					partColor = newColor,
				})
			end,
		}),
		toggleDelete = Roact.createElement(StudioComponents.Button, {
			Text = self.state.deleting and "Currently deleting" or "Currently placing",
			Size = UDim2.new(1, 0, 0, 25),
			OnActivated = function()
				self:setState({
					deleting = not self.state.deleting,
				})
			end,
		}),
		Roact.createElement(StudderMouseControl, {
			snappingInterval = self.state.snappingInterval,
			partSize = self.state.partSize,
			partColor = self.state.partColor,
			partHeight = self.state.partHeight,
			heightOffset = self.props.heightOffset,
			deleting = self.state.deleting,
			root = self.props.root,
		}),
	})
end

--[=[
	Updates partSize, making sure it's bounded, with the given number.
	@param To number
]=]
function Studder:updatePartSize(to)
	local newPartSize = math.clamp(to, minSize, maxSize)

	self:setState({
		partSize = newPartSize,
		snappingInterval = newPartSize,
	})
end

--[=[
	Updates snappingInterval, making sure it's bounded, with the given number.
	@param To number
]=]
function Studder:updateSnappingInterval(to)
	self:setState({
		snappingInterval = math.min(math.clamp(to, minSize, maxSize), self.state.partSize),
	})
end

--[=[
	Binds hotkeys for the tool.
]=]
function Studder:bindHotkeys()
	ContextActionService:BindAction(actionNames.increaseSnappingInterval, function(_, state)
		if state ~= Enum.UserInputState.Begin then
			return
		end

		self:updateSnappingInterval(self.state.snappingInterval * 2)
	end, false, Enum.KeyCode.V)

	ContextActionService:BindAction(actionNames.decreaseSnappingInterval, function(_, state)
		if state ~= Enum.UserInputState.Begin then
			return
		end

		self:updateSnappingInterval(self.state.snappingInterval / 2)
	end, false, Enum.KeyCode.C)

	ContextActionService:BindAction(actionNames.increasePartSize, function(_, state)
		if state ~= Enum.UserInputState.Begin then
			return
		end

		self:updatePartSize(self.state.partSize * 2)
	end, false, Enum.KeyCode.Z)

	ContextActionService:BindAction(actionNames.decreasePartSize, function(_, state)
		if state ~= Enum.UserInputState.Begin then
			return
		end

		self:updatePartSize(self.state.partSize / 2)
	end, false, Enum.KeyCode.X)

	ContextActionService:BindAction(actionNames.toggleDelete, function(_, state)
		if state ~= Enum.UserInputState.Begin then
			return
		end

		self:setState({ deleting = not self.state.deleting })
	end, false, Enum.KeyCode.R)
end

return Studder
