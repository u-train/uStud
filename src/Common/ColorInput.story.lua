local Roact = require(script.Parent.Parent.Packages.Roact) :: Roact
local ColorInput = require(script.Parent.ColorInput)

local Helper = Roact.Component:extend("Helper")

function Helper:init()
	self:setState({
		Color = Color3.fromHSV(0.417475, 0.530927, 0.760784),
	})
end

function Helper:render()
	return Roact.createFragment({
		Slider = Roact.createElement(ColorInput, {
			Size = UDim2.new(1, -4, 0, 30),
			Position = UDim2.new(0, 2, 0.5, -25 / 2),
			Color = self.state.Color,
			Label = "Color",
			OnColorChanged = function(Color)
				self:setState({
					Color = Color,
				})
			end,
		}),
	})
end

return function(Parent)
	local Handle = Roact.mount(Roact.createElement(Helper, {}), Parent)
	return function()
		Roact.unmount(Handle)
	end
end
