local Roact = require(script.Parent.Parent.Parent.Packages.Roact)
local Slider = require(script.Parent.Slider)

local createColorSequenceForSaturation = function(color)
	local hue, saturation, _ = color:ToHSV()

	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, saturation, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, saturation, 1)),
	})
end

return function(props)
	local hue, saturation, value = props.color:ToHSV()

	return Roact.createElement(Slider, {
		position = props.position,
		size = props.size,
		value = value,
		onValueChanged = function(newValue)
			props.onValueChanged(Color3.fromHSV(hue, saturation, newValue))
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
