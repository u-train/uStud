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
	.size UDim2
	.position UDim2
	.selections { { .name string, .route string} }
]=]
return function(props)
	return RoactRouter.withRouter(function(routerInfo)
		local renderedList = {}

		for index, selection in ipairs(props.selections) do
			renderedList[selection.name] = Roact.createElement(StudioComponents.Button, {
				Size = UDim2.new(1, 0, 0, 25),
				Text = selection.name,
				LayoutOrder = index,
				OnActivated = function()
					routerInfo.history:push(selection.path)
				end,
			})
		end
		return Roact.createElement(StudioComponents.ScrollFrame, {
			Size = props.size,
			Position = props.position,
		}, renderedList)
	end)
end
