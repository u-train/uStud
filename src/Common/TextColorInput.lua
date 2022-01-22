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

local formatColor = function(Input)
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
local createColorChannelChangedFactory = function(props)
	return function(channel)
		return function(text)
			local newNumber = tonumber(text)
			if newNumber == nil then
				return
			end

			local newColor = {
				props.color.R,
				props.color.G,
				props.color.B,
			}

			newColor[channel] = newNumber / 255
			props.onColorChanged(Color3.new(unpack(newColor)))
		end
	end
end

return function(props)
	local children = {}
	local givenColorChannelChanged = createColorChannelChangedFactory(props)

	for key, color in next, Colors do
		children[color] = Roact.createElement(ControlledInput, {
			value = formatColor(props.color[color]),
			onValueChanged = givenColorChannelChanged(key),
			size = UDim2.new(1 / 3, 0, 1, 0),
			position = UDim2.new(
				1 / 3 * (key - 1),
				0,
				0,
				0
			),
		})
	end

	return Roact.createElement("Frame", {
		Size = props.size,
		Position = props.position,
		BackgroundTransparency = 1
	}, children)
end
