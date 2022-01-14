local Roact = require(script.Parent.Parent.Libraries.Roact) :: Roact
local ColorInputComponent = require(script.Parent.ColorInput)

local HelperComponent = Roact.Component:extend("Helper")

function HelperComponent:init()
	self:setState({
		Color = Color3.fromHSV(0.417475, 0.530927, 0.760784),
	})
end

function HelperComponent:render()
	return Roact.createFragment({
		Slider = Roact.createElement(ColorInputComponent, {
			Size = UDim2.new(1, -4, 0, 30),
			Position = UDim2.new(0, 2, 0.5, -25 / 2),
			Color = self.state.Color,
			Label = "Color",
			OnColorChanged = function(Color)
				self:setState({
					Color = Color,
				})
			end,
		})
	})
end

return function(Parent)
	local Handle = Roact.mount(Roact.createElement(HelperComponent, {}), Parent)
	return function()
		Roact.unmount(Handle)
	end
end