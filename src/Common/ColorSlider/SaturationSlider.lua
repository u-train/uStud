local Roact = require(script.Parent.Parent.Parent.Libraries.Roact) :: Roact
local SliderComponent = require(script.Parent.Slider)

local CreateColorSequenceForSaturation = function(Color: Color3)
	local Hue, _, Value = Color:ToHSV()

	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(Hue, 0, Value)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(Hue, 1, Value))
	})
end

return function(Props)
	local H, S, V = Props.Color:ToHSV()

	return Roact.createElement(SliderComponent, {
		Position = Props.Position,
		Size = Props.Size,
		Value = S,
		OnValueChanged = function(NewValue)
			Props.OnSaturationChanged(Color3.fromHSV(H, NewValue, V))
		end,
		Background = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			ZIndex = 0,
			Active = false,
		}, {
			UIGradient = Roact.createElement("UIGradient", {
				Color = CreateColorSequenceForSaturation(Props.Color),
			}),
		}),
	})
end
