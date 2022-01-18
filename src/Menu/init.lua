local Packages = script.Parent.Packages
local Roact = require(Packages.Roact)
local RoactRouter = require(Packages.RoactRouter)
local StudioComponents = require(Packages.StudioComponents)

return function(Props)
	return RoactRouter.withRouter(function(RouterInfo)
		local RenderedList = {}

		for _, Selection in ipairs(Props.Selections) do
			RenderedList[Selection] = Roact.createElement(StudioComponents.Button, {
				Size = UDim2.new(1, 0, 0, 25),
				Text = Selection,
				OnActivated = function()
					RouterInfo.history:push(Selection)
				end,
			})
		end
		return Roact.createElement(StudioComponents.ScrollFrame, {
			Size = Props.Size,
			Position = Props.Position,
		}, RenderedList)
	end)
end
