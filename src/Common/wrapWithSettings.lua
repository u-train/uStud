local Roact = require(script.Parent.Parent.Packages.Roact)
local withSettings = require(script.Parent.withSettings)
local merge = require(script.Parent.merge)

return function(component)
	return function(props)
		return withSettings(function(settingsManager)
			return Roact.createElement(component, merge(props, { settingsManager = settingsManager }))
		end)
	end
end
