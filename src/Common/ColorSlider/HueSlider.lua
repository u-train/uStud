local Roact = require(script.Parent.Parent.Parent.Packages.Roact) :: Roact
local Slider = require(script.Parent.Slider)

local CreateColorSequenceForHue = function(Color: Color3)
	local Sequence = {}
	local _, Saturation, Value = Color:ToHSV()

	for i = 0, 6 do
		table.insert(Sequence, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, Saturation, Value)))
	end

	return ColorSequence.new(Sequence)
end

return function(props)
	local H, S, V = props.Color:ToHSV()

	return Roact.createElement(Slider, {
		Position = props.Position,
		Size = props.Size,
		Value = H,
		OnValueChanged = function(NewValue)
			props.OnHueChanged(Color3.fromHSV(NewValue, S, V))
		end,
		Background = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			ZIndex = 1,
			Active = false,
		}, {
			UIGradient = Roact.createElement("UIGradient", {
				Color = CreateColorSequenceForHue(props.Color),
			}),
		}),
	})
end
