local Roact = require(script.Parent.Parent.Parent.Packages.Roact) :: Roact
local Round = require(script.Parent.Parent.Parent.Common.Round)

--[=[
	@class Slider
	Makes a basic slider component. TODO: Document
]=]
local Slider = Roact.Component:extend("HueSlider")
Slider.defaultProps = {
	background = Roact.createElement("Frame", {
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
	minValue = 0,
	interval = 0.001,
	maxValue = 1,
}

--[=[
	Initalized state along with the input handlers.
]=]
function Slider:init()
	self.mouseDown = false
	self.inputCaptureRef = Roact.createRef()

	self.onInputBegan = function(_, input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		self.mouseDown = true
		self:updateValueFromMousePosition(input.Position)
	end

	self.onInputEnded = function(_, input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		self.mouseDown = false
	end

	self.onInputChanged = function(_, input)
		if not self.mouseDown then
			return
		end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		self:updateValueFromMousePosition(input.Position)
	end
end

--[=[
	Renders component.
	@return RoactTree
]=]
function Slider:render()
	return Roact.createElement("TextButton", {
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		ZIndex = 100,
		Size = self.props.size,
		Position = self.props.position,

		[Roact.Ref] = self.inputCaptureRef,

		[Roact.Event.InputBegan] = self.onInputBegan,
		[Roact.Event.InputChanged] = self.onInputChanged,
		[Roact.Event.InputEnded] = self.onInputEnded,
	}, {
		Container = Roact.createElement("Frame", {
			BackgroundTransparency = 1,

			Size = UDim2.new(1, -4, 1, 0),
			Position = UDim2.new(0, 2, 0, 0),
			Active = false,
		}, {
			Bar = Roact.createElement("Frame", {
				Size = UDim2.new(0, 4, 1, -4),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(self:convertValueToPercentage(self.props.value), 0, 0, 2),
				Active = false,
				ZIndex = 10,
				BorderSizePixel = 1,
				BorderMode = Enum.BorderMode.Inset,
			}),
		}),
		Background = self.props.background,
	})
end

--[=[
	Called whenever the mouse position changes.
]=]
function Slider:updateValueFromMousePosition(mousePosition)
	local inputCapture = self.inputCaptureRef.current
	if inputCapture == nil then
		return
	end

	local relativeMousePos = Vector2.new(mousePosition.X, mousePosition.Y) - inputCapture.AbsolutePosition
	local sliderLength = inputCapture.AbsoluteSize.X

	--Ensure it is within bounds and find it as percentage of axis
	local newPercentage = math.clamp(relativeMousePos.X, 0, sliderLength) / sliderLength
	local diff = math.abs(self.props.maxValue - self.props.minValue)
	local newValue = newPercentage * diff + self.props.minValue

	self.props.onValueChanged(Round(newValue, self.props.interval))
end

--[=[
	Takes a value and converst it to a normalized percentage.
]=]
function Slider:convertValueToPercentage(Value)
	local Diff = math.abs(self.props.maxValue - self.props.minValue)
	return (Value - self.props.minValue) / Diff
end

return Slider
