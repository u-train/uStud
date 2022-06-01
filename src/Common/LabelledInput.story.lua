local Roact = require(script.Parent.Parent.Packages.Roact)
local LabelledInput = require(script.Parent.LabelledInput)

local Helper = Roact.Component:extend("Helper")

function Helper:init()
	self:setState({
		value = "",
	})
end

function Helper:render()
	return Roact.createFragment({
		Input = Roact.createElement(LabelledInput, {
			label = "Label",
			value = self.state.value,
			size = UDim2.new(1, 0, 0, 25),
			onValueChanged = function(value)
				self:setState({
					value = value
				})
			end,
		}),
		Text = Roact.createElement("TextLabel", {
			Text = self.state.value,
			Position = UDim2.new(0, 0, 0, 25),
			Size = UDim2.new(1, 0, 0, 25),
		})
	})
end

return function(Parent)
	local Handle = Roact.mount(
		Roact.createElement(Helper, {}),
		Parent
	)

	return function()
		Roact.unmount(Handle)
	end
end
