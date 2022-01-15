local Roact = require(script.Parent.Parent.Libraries.Roact)
local ControlledInput = require(script.Parent.ControlledInput)

local ColorIsDark = function(Color)
	-- https://awik.io/determine-color-bright-dark-using-javascript/
	local R = Color.R * 255
	local G = Color.G * 255
	local B = Color.B * 255

	if math.sqrt(0.299 * R * R + 0.587 * G * G + 0.114 * B * B) > 127.5 then
		return false
	else
		return true
	end
end

local FormatColor = function(Input)
	return ("%.1f"):format(Input * 255)
end

local Colors = {
	"R",
	"G",
	"B",
}

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
				Props.Color.B,
			}

			NewColor[Channel] = NewNumber / 255
			Props.OnColorChanged(Color3.new(unpack(NewColor)))
		end
	end
end

return function(Props)
	local Children = {}
	local GivenColorChannelChanged = CreateColorChannelChanged(Props)

	for Key, Color in next, Colors do
		Children[Color] = Roact.createElement(ControlledInput, {
			Value = FormatColor(Props.Color[Color]),
			OnValueChanged = GivenColorChannelChanged(Key),
			Size = UDim2.new(1 / 3, -(Props.TextWidth or 100) / 3, 1, 0),
			Position = UDim2.new(
				1 / 3 * (Key - 1),
				(Props.TextWidth or 100) - (Props.TextWidth or 100) / 3 * (Key - 1),
				0,
				0
			),
		})
	end

	Children.Label = Roact.createElement("TextLabel", {
		Text = Props.Label,
		Size = UDim2.new(0, Props.TextWidth or 100, 1, 0),
		BackgroundColor3 = Props.Color,
		TextColor3 = ColorIsDark(Props.Color) and Color3.new(1, 1, 1) or Color3.new(0, 0, 0),
		BorderSizePixel = 1,
		ZIndex = 1,
	})

	return Roact.createElement("Frame", {
		Size = Props.Size,
		Position = Props.Position,
	}, Children)
end
