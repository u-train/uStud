return function(plugin)
	local Roact = require(script.Parent.Packages.Roact)
	local App = require(script.Parent.App)
	local Settings = require(script.Parent.Settings)(plugin)

	local Module = {}

	Module.Loaded = function(Widget)
		Module.RoactHandle = Roact.mount(
			Roact.createElement(App, {
				Active = false,
				SettingManager = Settings,
			}),
			Widget
		)
	end

	Module.Activated = function()
		Roact.update(
			Module.RoactHandle,
			Roact.createElement(App, {
				Active = true,
				SettingManager = Settings,
			})
		)
	end

	Module.Deactivated = function()
		Roact.update(
			Module.RoactHandle,
			Roact.createElement(App, {
				Active = false,
				SettingManager = Settings,
			})
		)
	end

	Module.Unloaded = function()
		Roact.unmount(Module.RoactHandle)
	end

	return Module
end
