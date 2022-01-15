local Roact = require(script.Parent.Parent.Parent.Libraries.Roact) :: Roact
local ValueSlider = require(script.Parent.ValueSlider)

local Helper = Roact.Component:extend("Helper")

function Helper:init()
	self:setState({
		Color = Color3.fromHSV(0.417475, 0.530927, 0.760784),
	})
end

function Helper:render()
	return Roact.createFragment({
		Slider = Roact.createElement(ValueSlider, {
			Size = UDim2.new(1, 0, 0, 25),
			Position = UDim2.new(0, 0, 0.5, -25 / 2),
			Color = self.state.Color,
			OnValueChanged = function(Color)
				self:setState({
					Color = Color,
				})
			end,
		}),
		Swab = Roact.createElement("Frame", {
			BackgroundColor3 = self.state.Color,
			Size = UDim2.new(0, 25, 0, 25),
			Position = UDim2.new(0, 0, 0, 0),
		}),
	})
end

return function(Parent)
	local Handle = Roact.mount(Roact.createElement(Helper, {}), Parent)
	return function()
		Roact.unmount(Handle)
	end
end
