--[=[
	@class GetContext
	GetContext
]=]

--[=[
	@within GetContext
	Got the method from: https://github.com/Kampfkarren/roact-hooks/blob/main/src/createUseContext.lua
	@function getContextValue
	@param self Roact.Component
	@param targetContext Roact.Context
	@return value
]=]

return function(self, targetContext)
	local contextValue = nil

	local fakeConsumer = setmetatable({
		props = {
			render = function(value)
				contextValue = value
			end,
		},
	}, {

		__index = self,
	})

	targetContext.Consumer.init(fakeConsumer)
	targetContext.Consumer.render(fakeConsumer)

	return contextValue
end
