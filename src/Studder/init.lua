local ContextActionService = game:GetService("ContextActionService")

local Roact = require(script.Parent.Packages.Roact)
local StudioComponents = require(script.Parent.Packages.StudioComponents)

local Common = script.Parent.Common
local LabelledInput = require(Common.LabelledInput)
local ColorInput = require(Common.ColorInput)
local ToolWrapper = require(Common.ToolWrapper)
local SettingsContext = require(Common.SettingsContext)
local getContextValue = require(Common.getContextValue)

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
	.rootChanged (string) -> nil
	.heightOffset number
	.heightOffsetChanged (number) -> nil
]=]
--[=[
	Sets state and binds hotkeys.
]=]
function Studder:init()
	local settingsManager = self:getSettings()

	self:setState({
		snappingInterval = settingsManager.get("StudderDefaultPartSize"),
		partSize = settingsManager.get("StudderDefaultPartSize"),
		partColor = settingsManager.get("StudderDefaultPartColor"),
		partHeight = settingsManager.get("StudderDefaultPartHeight"),
		partHeightOffset = settingsManager.get("StudderDefaultHeightOffset"),
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
		title = "Studder",
		root = self.props.root,
		rootChanged = self.props.rootChanged,
	}, {
		partSizeInput = Roact.createElement(LabelledInput, {
			value = self.state.partSize,
			size = UDim2.new(1, 0, 0, 25),
			label = "Part Size",

			onValueChanged = function(text)
				local newSize = tonumber(text)

				if newSize == nil then
					return
				end

				self:updatePartSize(newSize)
			end,
		}),
		heightOffsetInput = Roact.createElement(LabelledInput, {
			value = self.props.heightOffset,
			size = UDim2.new(1, 0, 0, 25),
			label = "Height offset",

			onValueChanged = function(text)
				local newValue = tonumber(text)

				if newValue == nil then
					return
				end

				self.props.heightOffsetChanged(
					math.clamp(
						newValue,
						self:getSettings().get("StudderMinHeightOffset"),
						self:getSettings().get("StudderMaxHeightOffset")
					)
				)
			end,
		}),
		partHeightInput = Roact.createElement(LabelledInput, {
			value = self.state.partHeight,
			size = UDim2.new(1, 0, 0, 25),
			label = "Part Height",

			onValueChanged = function(text)
				local newValue = tonumber(text)

				if newValue == nil then
					return
				end

				newValue = math.clamp(
					newValue,
					self:getSettings().get("StudderMinHeight"),
					self:getSettings().get("StudderMaxHeight")
				)

				self:setState({
					partHeight = newValue,
				})
			end,
		}),
		SnappingInput = Roact.createElement(LabelledInput, {
			value = self.state.snappingInterval,
			size = UDim2.new(1, 0, 0, 25),
			label = "Snapping Interval",

			onValueChanged = function(text)
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
			color = self.state.partColor,
			label = "Part Color",
			size = UDim2.new(1, 0, 0, 30),
			onColorChanged = function(newColor)
				self:setState({
					partColor = newColor,
				})
			end,
		}),
		ToggleDelete = Roact.createElement(StudioComponents.Button, {
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
	Fetches Settings from the context.
	@returns Settings
]=]

function Studder:getSettings()
	return assert(getContextValue(self, SettingsContext), "Missing Settings context.")
end


--[=[
	Updates partSize, making sure it's bounded, with the given number.
	@param To number
]=]
function Studder:updatePartSize(to)
	local newPartSize = math.clamp(
		to,
		self:getSettings().get("StudderMinSize"),
		self:getSettings().get("StudderMaxSize")
	)

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
		snappingInterval = math.min(
			math.clamp(
				to,
				self:getSettings().get("StudderMinSize"),
				self:getSettings().get("StudderMaxSize")
			),
			self.state.partSize
		),
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
