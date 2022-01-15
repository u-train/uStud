local ContextActionService = game:GetService("ContextActionService")

local Roact = require(script.Parent.Libraries.Roact)

local Common = script.Parent.Common
local ListLayout = require(Common.ListLayout)
local LabelledInput = require(Common.LabelledInput)
local ColorInput = require(Common.ColorInput)
local StudderMouseControl = require(script.MouseController)

local App = Roact.Component:extend("App")

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

function App:init()
	self:setState({
		SnappingInterval = 1,
		PartSize = 1,
		PartColor = Color3.new(0.5, 0.5, 0.5),
		PartHeight = 1,
		HeightOffset = 1,
		Deleting = false,
	})

	self:BindHotkeys()
end

function App:willUnmount()
	for _, ActionName in next, ActionNames do
		ContextActionService:UnbindAction(ActionName)
	end
end

function App:render()
	return Roact.createElement(ListLayout, {
		Size = self.props.Size,
		Position = self.props.Position,
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
			Value = self.state.HeightOffset,
			Size = UDim2.new(1, 0, 0, 25),
			Label = "Height offset",

			OnValueChanged = function(Text)
				local NewValue = tonumber(Text)

				if NewValue == nil then
					return
				end

				self:setState({
					HeightOffset = math.clamp(NewValue, MinHeightOffset, MaxHeightOffset),
				})
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
		ToggleDelete = Roact.createElement("TextButton", {
			Text = "Toggle Deleting",
			BackgroundColor3 = self.state.Deleting and Color3.fromRGB(233, 146, 146) or Color3.fromRGB(163, 162, 165),
			Size = UDim2.new(1, 0, 0, 25),
			[Roact.Event.MouseButton1Click] = function()
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
			HeightOffset = self.state.HeightOffset,
			Deleting = self.state.Deleting,
			EditingIn = self.props.EditingIn,
		}),
	})
end

function App:UpdatePartSize(To)
	local NewPartSize = math.clamp(To, MinSize, MaxSize)

	self:setState({
		PartSize = NewPartSize,
		SnappingInterval = NewPartSize,
	})
end

function App:UpdateSnappingInterval(To)
	self:setState({
		SnappingInterval = math.min(math.clamp(To, MinSize, MaxSize), self.state.PartSize),
	})
end

function App:BindHotkeys()
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

return App
