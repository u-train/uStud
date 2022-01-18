local Packages = script.Parent.Packages
local Roact = require(Packages.Roact)
local RoactRouter = require(Packages.RoactRouter)
local StudioComponents = require(Packages.StudioComponents)

--[=[
	@class Menu
	It's a menu, I don't know what you expect. It does use RoactRouter to push
	a selection onto history. It gets history via `withRouter`. So, this will
	require a router context.
]=]

--[=[
	@within Menu
	@interface
	.Size UDim2
	.Position UDim2
	.Selections { string }
]=]
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
