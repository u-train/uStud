local Roact = require(script.Parent.Parent.Packages.Roact) :: Roact
local ColorInput = require(script.Parent.ColorInput)

local Helper = Roact.Component:extend("Helper")

function Helper:init()
	self:setState({
		color = Color3.fromHSV(0.417475, 0.530927, 0.760784),
	})
end

function Helper:render()
	return Roact.createFragment({
		ColorInput = Roact.createElement(ColorInput, {
			size = UDim2.new(1, -4, 0, 30),
			position = UDim2.new(0, 2, 0.5, -25 / 2),
			color = self.state.color,
			label = "Color",
			onColorChanged = function(newColor)
				self:setState({
					color = newColor,
				})
			end,
		}),
	})
end

return function(parent)
	local handle = Roact.mount(Roact.createElement(Helper, {}), parent)
	return function()
		Roact.unmount(handle)
	end
end
