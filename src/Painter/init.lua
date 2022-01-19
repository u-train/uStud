local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local Packages = script.Parent.Packages
local Roact = require(Packages.Roact) :: Roact
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
]=]
local Painter = Roact.Component:extend("Painter")

local ActionNames = {
	IncreaseBrushDiameter = "IncreaseBrushDiameter",
	DecreaseBrushDiameter = "DecreaseBrushDiameter",
	ToggleSecondaryOnly = "ToggleSecondaryOnly",
	SamplePrimaryColor = "SamplePrimaryColor",
	SampleSecondaryColor = "SampleSecondaryColorColor",
}

--[=[
	@within Painter
	@interface Props
	.EditingIn Instance
	.EditingInChanged (string) -> nil
	.HeightOffset number
	.HeightOffsetChanged (number) -> nil
]=]
--[=[

]=]
function Painter:init()
	self:setState({
		PrimaryColor = Color3.fromRGB(163, 162, 165),
		SecondaryColor = Color3.fromRGB(163, 162, 165),
		BrushDiameter = 2,
		SecondaryOnly = false,
	})

	self:BindHotkeys()
end

--[=[

]=]
function Painter:willUnmount()
	for _, ActionName in next, ActionNames do
		ContextActionService:UnbindAction(ActionName)
	end
end

--[=[

]=]
function Painter:render()
	return Roact.createElement(ToolWrapper, {
		Title = "Painter",
		EditingIn = self.props.EditingIn,
		EditingInChanged = self.props.EditingInChanged,
	}, {

		PrimaryColor = Roact.createElement(ColorInput, {
			Color = self.state.PrimaryColor,
			Label = "Primary",
			Size = UDim2.new(1, 0, 0, 30),
			OnColorChanged = function(NewColor)
				self:setState({
					PrimaryColor = NewColor,
				})
			end,
		}),
		SecondaryColor = Roact.createElement(ColorInput, {
			Color = self.state.SecondaryColor,
			Label = "Secondary",
			Size = UDim2.new(1, 0, 0, 30),
			OnColorChanged = function(NewColor)
				self:setState({
					SecondaryColor = NewColor,
				})
			end,
		}),
		BrushDiameter = Roact.createElement(LabelledInput, {
			Value = self.state.BrushDiameter,
			Size = UDim2.new(1, 0, 0, 25),
			Label = "Brush Radius",

			OnValueChanged = function(Text)
				local NewInterval = tonumber(Text)

				if NewInterval == nil then
					return
				end

				self:setState({
					BrushDiameter = NewInterval,
				})
			end,
		}),
		ToggleSecondaryOnly = Roact.createElement(StudioComponents.Button, {
			Text = self.state.SecondaryOnly and "Painting studs with matching secondary color only"
				or "Painting any studs",
			Size = UDim2.new(1, 0, 0, 25),
			OnActivated = function()
				self:setState({
					SecondaryOnly = not self.state.SecondaryOnly,
				})
			end,
		}),
		PainterMouseControl = Roact.createElement(PainterMouseControl, {
			EditingIn = self.props.EditingIn,
			PrimaryColor = self.state.PrimaryColor,
			BrushDiameter = self.state.BrushDiameter,
			SecondaryColor = self.state.SecondaryColor,
			SecondaryOnly = self.state.SecondaryOnly,
		}),
	})
end

--[=[

]=]
function Painter:BindHotkeys()
	ContextActionService:BindAction(ActionNames.SamplePrimaryColor, function(_, State)
		if State ~= Enum.UserInputState.Begin then
			return
		end

		local Result = GetRaycastResultFromMouse(UserInputService:GetMouseLocation(), self.props.EditingIn)

		if Result == nil then
			return
		end

		local HitInstance = Result.Instance

		if HitInstance:IsA("BasePart") then
			self:setState({
				PrimaryColor = (HitInstance :: BasePart).Color,
			})
		end
	end, false, Enum.KeyCode.Z)

	ContextActionService:BindAction(ActionNames.SampleSecondaryColor, function(_, State)
		if State ~= Enum.UserInputState.Begin then
			return
		end

		local Result = GetRaycastResultFromMouse(UserInputService:GetMouseLocation(), self.props.EditingIn)

		if Result == nil then
			return
		end

		local HitInstance = Result.Instance

		if HitInstance:IsA("BasePart") then
			self:setState({
				SecondaryColor = (HitInstance :: BasePart).Color,
			})
		end
	end, false, Enum.KeyCode.X)

	ContextActionService:BindAction(ActionNames.ToggleSecondaryOnly, function(_, State)
		if State ~= Enum.UserInputState.Begin then
			return
		end

		self:setState({ SecondaryOnly = not self.state.SecondaryOnly })
	end, false, Enum.KeyCode.C)

	ContextActionService:BindAction(ActionNames.IncreaseBrushDiameter, function(_, State)
		if State ~= Enum.UserInputState.Begin then
			return
		end

		self:setState({ BrushDiameter = math.max(self.state.BrushDiameter + 1, 0) })
	end, false, Enum.KeyCode.R)

	ContextActionService:BindAction(ActionNames.DecreaseBrushDiameter, function(_, State)
		if State ~= Enum.UserInputState.Begin then
			return
		end

		self:setState({ BrushDiameter = math.max(self.state.BrushDiameter - 1, 0) })
	end, false, Enum.KeyCode.F)
end

return Painter
