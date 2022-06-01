local Roact = require(script.Parent.Parent.Packages.Roact)
local SettingsContext = require(script.Parent.SettingsContext)

return function(render)
	return Roact.createElement(SettingsContext.Consumer, {
		render = render
	})
end
