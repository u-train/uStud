return function(plugin)
	local Roact = require(script.Parent.Packages.Roact)
	local App = require(script.Parent.App)
	local Settings = require(script.Parent.Settings)(plugin)

	local Module = {}

	Module.loaded = function(widget)
		Module.roactHandle = Roact.mount(
			Roact.createElement(App, {
				active = false,
				settingManager = Settings,
			}),
			widget
		)
	end

	Module.activated = function()
		Roact.update(
			Module.roactHandle,
			Roact.createElement(App, {
				active = true,
				settingManager = Settings,
			})
		)
	end

	Module.deactivated = function()
		Roact.update(
			Module.roactHandle,
			Roact.createElement(App, {
				active = false,
				settingManager = Settings,
			})
		)
	end

	Module.unloaded = function()
		Roact.unmount(Module.roactHandle)
	end

	return Module
end
