local Roact = require(script.Parent.Parent.Parent.Packages.Roact) :: Roact
local Slider = require(script.Parent.Slider)

local CreateColorSequenceForSaturation = function(Color: Color3)
	local Hue, Saturation, _ = Color:ToHSV()

	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(Hue, Saturation, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(Hue, Saturation, 1)),
	})
end

return function(props)
	local H, S, V = props.Color:ToHSV()

	return Roact.createElement(Slider, {
		Position = props.Position,
		Size = props.Size,
		Value = V,
		OnValueChanged = function(NewValue)
			props.OnValueChanged(Color3.fromHSV(H, S, NewValue))
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
