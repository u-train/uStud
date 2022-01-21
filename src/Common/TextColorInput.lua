--[=[
	@class TextColorInput
	A component which allows a user to type in RGB values. There are three text
	boxes for the respective channels. The value for each channel can range from
	0 to 255, with 0.1 precision. In the future, this component will support
	putting custom channels and custom types.
	![Image of component rendered](/uStud/rendered/textColorInput.png)
]=]

--[=[
	@within TextColorInput
	@interface Props
	.Size UDim2
	.Position UDim2
	.OnColorChanged (Color3) -> nil
	.Color Color3
	.Channels { Channel } -- Not yet implemented
]=]

--[=[
	@within TextColorInput

	Haven't been implemented yet.
	@interface Channel
	.Name string
	.Min number
	.Max number
	.Precision number
]=]

local Packages = script.Parent.Parent.Packages
local Roact = require(Packages.Roact)

local ControlledInput = require(script.Parent.ControlledInput)

local FormatColor = function(Input)
	return ("%.1f"):format(Input * 255)
end

-- TODO: Put in as a default. Read docs for explaination.
local Colors = {
	"R",
	"G",
	"B",
}

--[=[
	@within TextColorInput

	Returns a function which given a channel will create the event handler
	for when that channel changes.
	@function CreateColorChannelChangedFactory
	@param Props Props
	@return (Channel: string) -> (Text: string) -> nil
]=]
local CreateColorChannelChangedFactory = function(Props)
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
	local GivenColorChannelChanged = CreateColorChannelChangedFactory(Props)

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
