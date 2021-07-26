local Roact = require(script.Parent.Libraries.Roact)
local ControlledInputComponent = require(script.Parent.ControlledInput)

local FormatColor = function(Input)
	return ("%.1f"):format(tostring(Input))* 255
end

local Colors = {
	"R",
	"G",
	"B"
}

local CreateColorChannelInput = function(Props)
	return Roact.createElement(
		ControlledInputComponent,
		{
			Value = FormatColor(Props.ColorValue),
			OnValueChanged = Props.OnChannelChanged,
			Size = Props.Size,
			Position = Props.Position
		}
	)
end

local CreateColorChannelChanged = function(Props)
	return function(Channel)
		return function(Text)
			local NewNumber = tonumber(Text)
			if NewNumber == nil then
				return
			end

			local NewColor = {
				Props.Color.R,
				Props.Color.G,
				Props.Color.B
			}

			NewColor[Channel] = NewNumber / 255
			Props.OnColorChanged(
				Color3.new(
					unpack(
						NewColor
					)
				)
			)
		end
	end
end

return function(Props)
	local Children = {}
	local GivenColorChannelChanged = CreateColorChannelChanged(Props)
	for Key, Color in next, Colors do
		Children[Color] = CreateColorChannelInput {
			ColorValue = Props.Color[Color],
			OnChannelChanged = GivenColorChannelChanged(Key),
			Size = UDim2.new(1/3, -(Props.TextWidth or 100), 1, 0),
			Position = UDim2.new(1/3 * (Key - 1), (Props.TextWidth or 100), 0, 0),
		}
	end

	Children.Label = Roact.createElement(
		"TextLabel",
		{
			Text = Props.Label,
			Size = UDim2.new(0, Props.TextWidth or 100, 1, 0),
		}
	)

	return Roact.createElement(
		"Frame",
		{
			Size = Props.Size,
			Position = Props.Position,
		},
		Children
	)
end