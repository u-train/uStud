local Roact = require(script.Parent.Parent.Parent.Libraries.Roact) :: Roact
local Slider = require(script.Parent.Slider)

local HelperComponent = Roact.Component:extend("Helper")

function HelperComponent:init()
	self:setState({
		Value = 0,
	})
end

function HelperComponent:render()
	return Roact.createFragment({
		Slider = Roact.createElement(Slider, {
			Size = UDim2.new(1, 0, 0, 25),
			Position = UDim2.new(0, 0, 0.5, -25 / 2),
			Value = self.state.Value,
			MinValue = 0,
			MaxValue = 100,
			Interval = 0.1,
			ValueChanged = function(NewValue)
				self:setState({
					Value = NewValue,
				})
			end,
		}),
		Text = Roact.createElement("TextBox", {
			Text = string.format("%0.1f", self.state.Value),
			Size = UDim2.new(1, 0, 0, 25),
			Position = UDim2.new(0, 0, 0, 0),
		}),
	})
end

return function(Parent)
	local Handle = Roact.mount(Roact.createElement(HelperComponent, {}), Parent)

	return function()
		Roact.unmount(Handle)
	end
end