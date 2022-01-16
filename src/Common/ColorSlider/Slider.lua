local Roact = require(script.Parent.Parent.Parent.Libraries.Roact) :: Roact
local Round = require(script.Parent.Parent.Parent.Common.Round)

local Slider = Roact.Component:extend("HueSlider")
Slider.defaultProps = {
	Background = Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		ZIndex = 1,
		Active = false,
	}, {
		Line = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 2),
			Position = UDim2.new(0, 0, 0.5, -1),
			BorderSizePixel = 0,
			BackgroundTransparency = 0.5,
			BackgroundColor3 = Color3.new(1, 1, 1),
			Active = false,
		}),
	}),
	MinValue = 0,
	Interval = 0.001,
	MaxValue = 1,
}

function Slider:init()
	self.MouseDown = false
	self.InputCaptureRef = Roact.createRef()

	self.OnInputBegan = function(_, Input)
		if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		self.MouseDown = true
		self:UpdateValueFromMousePosition(Input.Position)
	end

	self.OnInputEnded = function(_, Input)
		if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		self.MouseDown = false
	end

	self.OnInputChanged = function(_, Input)
		if not self.MouseDown then
			return
		end
		if Input.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		self:UpdateValueFromMousePosition(Input.Position)
	end
end

function Slider:render()
	return Roact.createElement("TextButton", {
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 0,
		Size = self.props.Size,
		Position = self.props.Position,

		[Roact.Ref] = self.InputCaptureRef,

		[Roact.Event.InputBegan] = self.OnInputBegan,
		[Roact.Event.InputChanged] = self.OnInputChanged,
		[Roact.Event.InputEnded] = self.OnInputEnded,
	}, {
		Background = self.props.Background,
		Bar = Roact.createElement("Frame", {
			Size = UDim2.new(0, 2, 1, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(self:ConvertValueToPercentage(self.props.Value), 0, 0, 0),
			Active = false,
			ZIndex = 2
		}),
	})
end

function Slider:UpdateValueFromMousePosition(MousePosition)
	local InputCapture = self.InputCaptureRef.current
	if InputCapture == nil then
		return
	end

	local RelativeMousePos = Vector2.new(MousePosition.X, MousePosition.Y) - InputCapture.AbsolutePosition
	local SliderLength = InputCapture.AbsoluteSize.X

	--Ensure it is within bounds and find it as percentage of axis
	local NewPercentage = math.clamp(RelativeMousePos.X, 0, SliderLength) / SliderLength
	local Diff = math.abs(self.props.MaxValue - self.props.MinValue)
	local NewValue = NewPercentage * Diff + self.props.MinValue

	self.props.OnValueChanged(Round(NewValue, self.props.Interval))
end

function Slider:ConvertValueToPercentage(Value)
	local Diff = math.abs(self.props.MaxValue - self.props.MinValue)
	return (Value - self.props.MinValue) / Diff
end

return Slider
