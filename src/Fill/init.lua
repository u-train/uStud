local Packages = script.Parent.Packages
local Roact = require(Packages.Roact)
local StudioComponents = require(Packages.StudioComponents)

local Common = script.Parent.Common
local ToolWrapper = require(Common.ToolWrapper)
local LabelledInput = require(Common.LabelledInput)
local ColorInput = require(Common.ColorInput)
local SettingsContext = require(Common.SettingsContext)
local getContextValue = require(Common.getContextValue)

local MouseController = require(script.MouseController)

local Fill = Roact.Component:extend("Fill")

function Fill:init()
	local settingsManager = self:getSettings()

	self:setState({
		partSize = settingsManager.get("StudderDefaultPartSize"),
		partColor = settingsManager.get("StudderDefaultPartColor"),
		partHeight = settingsManager.get("StudderDefaultPartHeight"),
		heightOffset = settingsManager.get("StudderDefaultHeightOffset"),
	})
end

function Fill:render()
	return Roact.createElement(ToolWrapper, {
		title = "Fill",
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

		MouseController = Roact.createElement(MouseController, {
			partSize = self.state.partSize,
			partColor = self.state.partColor,
			partHeight = self.state.partHeight,
			heightOffset = self.state.heightOffset,
			root = self.props.root,
		}),
	})
end

function Fill:getSettings()
	return assert(getContextValue(self, SettingsContext), "Missing Settings context.")
end

return Fill
