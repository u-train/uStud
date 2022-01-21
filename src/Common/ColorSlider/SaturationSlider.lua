local Roact = require(script.Parent.Parent.Parent.Packages.Roact) :: Roact
local Slider = require(script.Parent.Slider)

local CreateColorSequenceForSaturation = function(Color: Color3)
	local Hue, _, Value = Color:ToHSV()

	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(Hue, 0, Value)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(Hue, 1, Value)),
	})
end

return function(props)
	local H, S, V = props.Color:ToHSV()

	return Roact.createElement(Slider, {
		Position = props.Position,
		Size = props.Size,
		Value = S,
		OnValueChanged = function(NewValue)
			props.OnSaturationChanged(Color3.fromHSV(H, NewValue, V))
		end,
		Background = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			ZIndex = 1,
			Active = false,
		}, {
			UIGradient = Roact.createElement("UIGradient", {
				Color = CreateColorSequenceForSaturation(props.Color),
			}),
		}),
	})
end
