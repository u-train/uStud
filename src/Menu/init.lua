local Roact = require(script.Parent.Packages.Roact)
local RoactRouter = require(script.Parent.Packages.RoactRouter)

local ListLayout = require(script.Parent.Common.ListLayout)

return function(Props)
	return RoactRouter.withRouter(function(RouterInfo)
		local RenderedList = {}

		for _, Selection in ipairs(Props.Selections) do
			RenderedList[Selection] = Roact.createElement("TextButton", {
				Size = UDim2.new(1, 0, 0, 25),
				Text = Selection,
				[Roact.Event.MouseButton1Click] = function()
					RouterInfo.history:push(Selection)
				end,
			})
		end
		return Roact.createElement(ListLayout, {
			Size = Props.Size,
			Position = Props.Position,
			Padding = UDim.new(0, 0),
		}, RenderedList)
	end)
end
