local Roact = require(script.Parent.Parent.Packages.Roact)
local Settings = require(script.Parent.Parent.Settings)

local SettingsContext = Roact.createContext(Settings)

return SettingsContext
