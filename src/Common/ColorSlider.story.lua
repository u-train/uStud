local Roact = require(script.Parent.Parent.Libraries.Roact) :: Roact
local ColorSlider = require(script.Parent.ColorSlider)

local HelperComponent = Roact.Component:extend("Helper")

function HelperComponent:init()
	self:setState({
		Color = Color3.fromHSV(0.417475, 0.530927, 0.760784),
	})
end

function HelperComponent:render()
	return Roact.createFragment({
		Slider = Roact.createElement(ColorSlider, {
			Size = UDim2.new(1, -4, 0, 25),
			Position = UDim2.new(0, 2, 0.5, -25 / 2),
			Color = self.state.Color,
			OnColorChanged = function(Color)
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
	local Handle = Roact.mount(Roact.createElement(HelperComponent, {}), Parent)
	return function()
		Roact.unmount(Handle)
	end
end
