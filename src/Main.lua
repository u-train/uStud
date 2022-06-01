return function(_)
	local Roact = require(script.Parent.Packages.Roact)
	local App = require(script.Parent.App)
	local Settings = require(script.Parent.Settings)
	local SettingsContext = require(script.Parent.Common.SettingsContext)

	local Module = {}

	Module.loaded = function(widget)
		Module.roactHandle = Roact.mount(
			Roact.createElement(SettingsContext.Provider, { value = Settings }, {
				App = Roact.createElement(App, {
					active = false,
					defaultRootPath = Settings.get("DefaultEditingIn"),
					heightOffset = Settings.get("HeightOffset"),
				}),
			}),
			widget
		)
	end

	Module.activated = function()
		Roact.update(
			Module.roactHandle,
			Roact.createElement(SettingsContext.Provider, { value = Settings }, {
				App = Roact.createElement(App, {
					active = true,
					defaultRootPath = Settings.get("DefaultEditingIn"),
					heightOffset = Settings.get("HeightOffset"),
				}),
			})
		)
	end

	Module.deactivated = function()
		Roact.update(
			Module.roactHandle,
			Roact.createElement(SettingsContext.Provider, { value = Settings }, {
				App = Roact.createElement(App, {
					active = false,
					defaultRootPath = Settings.get("DefaultEditingIn"),
					heightOffset = Settings.get("HeightOffset"),
				}),
			})
		)
	end

	Module.unloaded = function()
		Roact.unmount(Module.roactHandle)
	end

	return Module
end
