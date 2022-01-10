local Roact = require(script.Parent.Parent.Libraries.Roact)

return function(Props)
	if Props.ShowReturnBack then
		return Roact.createElement("Frame", {
			Position = Props.Position,
			Size = Props.Size,
		}, {
			ReturnBack = Roact.createElement("TextButton", {
				Size = UDim2.new(0, 25, 1, 0),
				Text = "<",
				[Roact.Event.MouseButton1Click] = function()
					Props.OnReturn()
				end,
			}),
			Title = Roact.createElement("TextLabel", {
				Size = UDim2.new(1, -25, 1, 0),
				Position = UDim2.new(0, 25, 0, 0),
				Text = Props.Title,
			}),
		})
	else
		return Roact.createElement("TextLabel", {
			Position = Props.Position,
			Size = Props.Size,
			Text = Props.Title,
		})
	end
end
