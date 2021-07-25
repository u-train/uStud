local Roact = require(script.Parent.Libraries.Roact)
local AppComponent = require(script.Parent.App)

local Module = {}

Module.Loaded = function(Widget)
	Module.RoactHandle = Roact.mount(
		Roact.createElement(
			AppComponent,
			{
				Active = false
			}
		),
		Widget
	)
end

Module.Activated = function()
	Roact.update(
		Module.RoactHandle,
		Roact.createElement(
			AppComponent,
			{
				Active = true
			}
		)
	)
end

Module.Deactivated = function()
	Roact.update(
		Module.RoactHandle,
		Roact.createElement(
			AppComponent,
			{
				Active = false
			}
		)
	)
end

Module.Unloaded = function()
	Roact.unmount(Module.RoactHandle)
end

return Module