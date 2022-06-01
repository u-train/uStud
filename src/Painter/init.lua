local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local Packages = script.Parent.Packages
local Roact = require(Packages.Roact)
local StudioComponents = require(Packages.StudioComponents)

local Common = script.Parent.Common
local LabelledInput = require(Common.LabelledInput)
local ColorInput = require(Common.ColorInput)
local ToolWrapper = require(Common.ToolWrapper)

local GetRaycastResultFromMouse = require(Common.GetRaycastResultFromMouse)

local PainterMouseControl = require(script.MouseController)

--[=[
	@class Painter
	Paint things, I liked how it came out. Mostly...

	Here's the hotkeys:
	- `Z` to sample primary color.
	- `X` to sample secondary color.
	- `C` to toggle secondary only.
	- `R` to increase brush diameter by 1.
	- `F` to decrease brush diameter by 1.

	Here's some facts:
	- Brush diameter cannot be less than 0.

	This is how the menu look like:

	![Painter's menu](/uStud/rendered/painter.png)
]=]
local Painter = Roact.Component:extend("Painter")

local actionNames = {
	increaseBrushDiameter = "increaseBrushDiameter",
	decreaseBrushDiameter = "decreaseBrushDiameter",
	toggleSecondaryOnly = "toggleSecondaryOnly",
	samplePrimaryColor = "samplePrimaryColor",
	sampleSecondaryColor = "SampleSecondaryColorColor",
}

--[=[
	@within Painter
	@interface Props
	.root Instance
	.rootChanged (string) -> nil
	.HeightOffset number
	.HeightOffsetChanged (number) -> nil
]=]
--[=[
	Initalize state and bind hotkeys.
]=]
function Painter:init()
	self:setState({
		primaryColor = Color3.fromRGB(163, 162, 165),
		secondaryColor = Color3.fromRGB(163, 162, 165),
		brushDiameter = 2,
		secondaryOnly = false,
	})

	self:bindHotkeys()
end

--[=[
	To unbind hotkeys.
]=]
function Painter:willUnmount()
	for _, actionName in next, actionNames do
		ContextActionService:UnbindAction(actionName)
	end
end

--[=[
	Render.
	@return RoactTree
]=]
function Painter:render()
	return Roact.createElement(ToolWrapper, {
		title = "Painter",
		root = self.props.root,
		rootChanged = self.props.rootChanged,
	}, {
		PrimaryColor = Roact.createElement(ColorInput, {
			color = self.state.primaryColor,
			label = "Primary",
			size = UDim2.new(1, 0, 0, 30),
			layoutOrder = 1,
			onColorChanged = function(newColor)
				self:setState({
					primaryColor = newColor,
				})
			end,
		}),
		SecondaryColor = Roact.createElement(ColorInput, {
			color = self.state.secondaryColor,
			label = "Secondary",
			size = UDim2.new(1, 0, 0, 30),
			layoutOrder = 2,
			onColorChanged = function(newColor)
				self:setState({
					secondaryColor = newColor,
				})
			end,
		}),
		BrushDiameter = Roact.createElement(LabelledInput, {
			value = self.state.brushDiameter,
			size = UDim2.new(1, 0, 0, 25),
			label = "Brush Radius",
			layoutOrder = 3,
			onValueChanged = function(text)
				local newInterval = tonumber(text)

				if newInterval == nil then
					return
				end

				self:setState({
					brushDiameter = newInterval,
				})
			end,
		}),
		ToggleSecondaryOnly = Roact.createElement(StudioComponents.Button, {
			Text = self.state.secondaryOnly and "Painting studs with matching secondary color only"
				or "Painting any studs",
			Size = UDim2.new(1, 0, 0, 25),
			OnActivated = function()
				self:setState({
					secondaryOnly = not self.state.secondaryOnly,
				})
			end,
			LayoutOrder = 4,
		}),
		PainterMouseControl = Roact.createElement(PainterMouseControl, {
			root = self.props.root,
			primaryColor = self.state.primaryColor,
			brushDiameter = self.state.brushDiameter,
			secondaryColor = self.state.secondaryColor,
			secondaryOnly = self.state.secondaryOnly,
		}),
	})
end

--[=[
	Bind hotkeys.
]=]
function Painter:bindHotkeys()
	ContextActionService:BindAction(actionNames.samplePrimaryColor, function(_, state)
		if state ~= Enum.UserInputState.Begin then
			return
		end

		local result = GetRaycastResultFromMouse(UserInputService:GetMouseLocation(), self.props.root)

		if result == nil then
			return
		end

		local HitInstance = result.Instance

		if HitInstance:IsA("BasePart") then
			self:setState({
				primaryColor = (HitInstance :: BasePart).Color,
			})
		end
	end, false, Enum.KeyCode.Z)

	ContextActionService:BindAction(actionNames.sampleSecondaryColor, function(_, state)
		if state ~= Enum.UserInputState.Begin then
			return
		end

		local result = GetRaycastResultFromMouse(UserInputService:GetMouseLocation(), self.props.root)

		if result == nil then
			return
		end

		local HitInstance = result.Instance

		if HitInstance:IsA("BasePart") then
			self:setState({
				secondaryColor = (HitInstance :: BasePart).Color,
			})
		end
	end, false, Enum.KeyCode.X)

	ContextActionService:BindAction(actionNames.toggleSecondaryOnly, function(_, state)
		if state ~= Enum.UserInputState.Begin then
			return
		end

		self:setState({ secondaryOnly = not self.state.secondaryOnly })
	end, false, Enum.KeyCode.C)

	ContextActionService:BindAction(actionNames.increaseBrushDiameter, function(_, state)
		if state ~= Enum.UserInputState.Begin then
			return
		end

		self:setState({ brushDiameter = math.max(self.state.brushDiameter + 1, 0) })
	end, false, Enum.KeyCode.R)

	ContextActionService:BindAction(actionNames.decreaseBrushDiameter, function(_, state)
		if state ~= Enum.UserInputState.Begin then
			return
		end

		self:setState({ brushDiameter = math.max(self.state.brushDiameter - 1, 0) })
	end, false, Enum.KeyCode.F)
end

return Painter
