local Roact = require(script.Parent.Parent.Parent.Packages.Roact) :: Roact
local Slider = require(script.Parent.Slider)

local createColorSequenceForHue = function(color: Color3)
	local sequence = {}
	local _, saturation, value = color:ToHSV()

	for i = 0, 6 do
		table.insert(sequence, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, saturation, value)))
	end

	return ColorSequence.new(sequence)
end

return function(props)
	local hue, saturation, value = props.color:ToHSV()

	return Roact.createElement(Slider, {
		position = props.position,
		size = props.size,
		value = hue,
		onValueChanged = function(NewValue)
			props.onHueChanged(Color3.fromHSV(NewValue, saturation, value))
		end,
		background = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			ZIndex = 1,
			Active = false,
		}, {
			UIGradient = Roact.createElement("UIGradient", {
				Color = createColorSequenceForHue(props.color),
			}),
		}),
	})
end
