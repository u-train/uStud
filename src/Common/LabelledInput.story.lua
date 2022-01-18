local Roact = require(script.Parent.Parent.Packages.Roact) :: Roact
local LabelledInput = require(script.Parent.LabelledInput)

local Helper = Roact.Component:extend("Helper")

function Helper:init()
	self:setState({
		Value = "",
	})
end

function Helper:render()
	return Roact.createFragment({
		Input = Roact.createElement(LabelledInput, {
			Label = "Label",
			Value = self.state.Value,
			Size = UDim2.new(1, 0, 0, 25),
			OnValueChanged = function(Value)
				self:setState({
					Value = Value
				})
			end,
		}),
		Text = Roact.createElement("TextLabel", {
			Text = self.state.Value,
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
