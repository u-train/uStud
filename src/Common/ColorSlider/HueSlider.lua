local Roact = require(script.Parent.Parent.Parent.Libraries.Roact) :: Roact
local SliderComponent = require(script.Parent.Slider)

local CreateColorSequenceForHue = function(Color: Color3)
	local Sequence = {}
	local _, Saturation, Value = Color:ToHSV()

	for i = 0, 6 do
		table.insert(Sequence, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, Saturation, Value)))
	end

	return Sequence
end

return function(Props)
	local H, S, V = Props.Color:ToHSV()

	return Roact.createElement(SliderComponent, {
		Position = Props.Position,
		Size = Props.Size,
		Value = H,
		OnValueChanged = function(NewValue)
			Props.OnHueChanged(Color3.fromHSV(NewValue, S, V))
		end,
		Background = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			ZIndex = 0,
			Active = false,
		}, {
			UIGradient = Roact.createElement("UIGradient", {
				Color = ColorSequence.new(CreateColorSequenceForHue(Props.Color)),
			}),
		}),
	})
end
