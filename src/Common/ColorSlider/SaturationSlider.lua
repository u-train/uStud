local Roact = require(script.Parent.Parent.Parent.Packages.Roact) :: Roact
local Slider = require(script.Parent.Slider)

local createColorSequenceForSaturation = function(color: Color3)
	local hue, _, value = color:ToHSV()

	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, 0, value)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, 1, value)),
	})
end

return function(props)
	local hue, saturation, value = props.color:ToHSV()

	return Roact.createElement(Slider, {
		position = props.position,
		size = props.size,
		value = saturation,
		onValueChanged = function(newValue)
			props.onSaturationChanged(Color3.fromHSV(hue, newValue, value))
		end,
		background = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			ZIndex = 1,
			Active = false,
		}, {
			UIGradient = Roact.createElement("UIGradient", {
				Color = createColorSequenceForSaturation(props.color),
			}),
		}),
	})
end
