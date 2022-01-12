local Roact = require(script.Parent.Parent.Parent.Libraries.Roact) :: Roact
local Round = require(script.Parent.Parent.Parent.Libraries.Round)

local SliderComponent = Roact.Component:extend("HueSlider")
SliderComponent.defaultProps = {
	Background = Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		ZIndex = -1,
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

function SliderComponent:init()
	self.MouseDown = false
	self.SliderRef = Roact.createRef()

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

function SliderComponent:render()
	return Roact.createElement("TextButton", {
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Size = self.props.Size,
		Position = self.props.Position,

		[Roact.Ref] = self.SliderRef,

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
		}),
	})
end

function SliderComponent:UpdateValueFromMousePosition(MousePosition)
	local Slider = self.SliderRef.current
	if Slider == nil then
		return
	end

	local RelativeMousePos = Vector2.new(MousePosition.X, MousePosition.Y) - Slider.AbsolutePosition
	local SliderLength = Slider.AbsoluteSize.X

	--Ensure it is within bounds and find it as percentage of axis
	local NewPercentage = math.clamp(RelativeMousePos.X, 0, SliderLength) / SliderLength
	local Diff = math.abs(self.props.MaxValue - self.props.MinValue)
	local NewValue = NewPercentage * Diff + self.props.MinValue

	self.props.OnValueChanged(Round(NewValue, self.props.Interval))
end

function SliderComponent:ConvertValueToPercentage(Value)
	local Diff = math.abs(self.props.MaxValue - self.props.MinValue)
	return (Value - self.props.MinValue) / Diff
end

return SliderComponent
