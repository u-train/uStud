local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Roact = require(script.Parent.Packages.roact) :: Roact
local Common = script.Parent.Common
local ListLayout = require(Common.ListLayout)
local LabelledInput = require(Common.LabelledInput)
local ColorInput = require(Common.ColorInput)
local GetRaycastResultFromMouse = require(script.Parent.Common.GetRaycastResultFromMouse)

local StudderMouseControl = require(script.MouseController)

local Painter = Roact.Component:extend("Painter")

local ActionNames = {
	IncreaseBrushDiameter = "IncreaseBrushDiameter",
	DecreaseBrushDiameter = "DecreaseBrushDiameter",
	ToggleSecondaryOnly = "ToggleSecondaryOnly",
	SamplePrimaryColor = "SamplePrimaryColor",
	SampleSecondaryColor = "SampleSecondaryColorColor",
}

function Painter:init()
	self:setState({
		PrimaryColor = Color3.fromRGB(163, 162, 165),
		SecondaryColor = Color3.fromRGB(163, 162, 165),
		BrushDiameter = 2,
		SecondaryOnly = false,
	})

	self:BindHotkeys()
end

function Painter:willUnmount()
	for _, ActionName in next, ActionNames do
		ContextActionService:UnbindAction(ActionName)
	end
end

function Painter:render()
	return Roact.createElement(ListLayout, {
		Size = self.props.Size,
		Position = self.props.Position,
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
		ToggleSecondaryOnly = Roact.createElement("TextButton", {
			Text = "Toggle Secondary",
			BackgroundColor3 = self.state.SecondaryOnly and Color3.fromRGB(1148, 176, 149) or Color3.fromRGB(
				163,
				162,
				165
			),
			Size = UDim2.new(1, 0, 0, 25),
			[Roact.Event.MouseButton1Click] = function()
				self:setState({
					SecondaryOnly = not self.state.SecondaryOnly,
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
		StudderMouseControl = Roact.createElement(StudderMouseControl, {
			EditingIn = self.props.EditingIn,
			PrimaryColor = self.state.PrimaryColor,
			BrushDiameter = self.state.BrushDiameter,
			SecondaryColor = self.state.SecondaryColor,
			SecondaryOnly = self.state.SecondaryOnly,
		}),
	})
end

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
