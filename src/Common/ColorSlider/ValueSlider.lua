local Roact = require(script.Parent.Parent.Parent.Libraries.Roact) :: Roact
local SliderComponent = require(script.Parent.Slider)

local CreateColorSequenceForSaturation = function(Color: Color3)
	local Hue, Saturation, _ = Color:ToHSV()

	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(Hue, Saturation, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(Hue, Saturation, 1)),
	})
end

return function(Props)
	local H, S, V = Props.Color:ToHSV()

	return Roact.createElement(SliderComponent, {
		Position = Props.Position,
		Size = Props.Size,
		Value = V,
		OnValueChanged = function(NewValue)
			Props.OnValueChanged(Color3.fromHSV(H, S, NewValue))
		end,
		Background = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			ZIndex = 1,
			Active = false,
		}, {
			UIGradient = Roact.createElement("UIGradient", {
				Color = CreateColorSequenceForSaturation(Props.Color),
			}),
		}),
	})
end
