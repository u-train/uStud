local Roact = require(script.Parent.Libraries.Roact)
local ListLayout = require(script.Parent.Common.ListLayout)

return function(Props)
	local RenderedList = {}

	for _, Selection in ipairs(Props.Selections) do
		RenderedList[Selection] = Roact.createElement(
			"TextButton",
			{
				Size = UDim2.new(1, 0, 0, 25),
				Text = Selection,
				[Roact.Event.MouseButton1Click] = function()
					Props.OnSelection(Selection)
				end
			}
		)
	end
	return Roact.createElement(
		ListLayout,
		{
			Size = Props.Size,
			Position = Props.Position,
			Padding = UDim.new(0, 0),
		},
		RenderedList
	)
end