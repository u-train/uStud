local Packages = script.Parent.Parent.Packages
local Roact = require(Packages.Roact)

local ControlledInput = require(script.Parent.ControlledInput)

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
			Size = UDim2.new(1 / 3, 0, 1, 0),
			Position = UDim2.new(
				1 / 3 * (Key - 1),
				0,
				0,
				0
			),
		})
	end

	return Roact.createElement("Frame", {
		Size = Props.Size,
		Position = Props.Position,
		BackgroundTransparency = 1
	}, Children)
end
