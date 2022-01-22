local Roact = require(script.Parent.Parent.Parent.Packages.Roact) :: Roact
local Slider = require(script.Parent.Slider)

local Helper = Roact.Component:extend("Helper")

function Helper:init()
	self:setState({
		value = 0,
	})
end

function Helper:render()
	return Roact.createFragment({
		Slider = Roact.createElement(Slider, {
			size = UDim2.new(1, -5, 0, 25),
			position = UDim2.new(0, 0, 0.5, -25 / 2),
			value = self.state.value,
			minValue = 0,
			maxValue = 100,
			interval = 0.1,
			onValueChanged = function(newValue)
				self:setState({
					value = newValue,
				})
			end,
		}),
		Text = Roact.createElement("TextBox", {
			Text = string.format("%0.1f", self.state.value),
			Size = UDim2.new(1, 0, 0, 25),
			Position = UDim2.new(0, 0, 0, 0),
		}),
	})
end

return function(parent)
	local handle = Roact.mount(Roact.createElement(Helper, {}), parent)

	return function()
		Roact.unmount(handle)
	end
end
