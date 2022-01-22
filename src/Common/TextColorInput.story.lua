local Roact = require(script.Parent.Parent.Packages.Roact) :: Roact
local TextColorInput = require(script.Parent.TextColorInput)

local Helper = Roact.Component:extend("Helper")

function Helper:init()
	self:setState({
		color = Color3.fromHSV(0.417475, 0.530927, 0.760784),
	})
end

function Helper:render()
	return Roact.createFragment({
		Slider = Roact.createElement(TextColorInput, {
			size = UDim2.new(1, 0, 0, 25),
			position = UDim2.new(0, 0, 0.5, -25 / 2),
			color = self.state.color,
			onColorChanged = function(color)
				self:setState({
					color = color,
				})
			end,
		}),
		Swab = Roact.createElement("Frame", {
			BackgroundColor3 = self.state.color,
			Size = UDim2.new(0, 25, 0, 25),
			Position = UDim2.new(0, 0, 0, 0),
		}),
	})
end

return function(parent)
	local Handle = Roact.mount(Roact.createElement(Helper, {}), parent)
	return function()
		Roact.unmount(Handle)
	end
end
