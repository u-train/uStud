--[=[
	@class Settings
	Interface for settings. Main purpose is to provide default settings and
	up-to-date settings.
]=]

--[=[
	@within Settings
	@interface PossibleSettings
	.DefaultEditingIn string
]=]

--[=[
	@within Settings
	@function Set
	@param SettingName string
	@param Value any
]=]

--[=[
	@within Settings
	@function Get
	@param SettingName string
	@return any
]=]

local Settings = {}
local plugin: Plugin = require(script.Parent.Plugin) :: Plugin
local prefix = "uStud.%s"

Settings.DefaultSettings = {
	DefaultEditingIn = "Workspace.Studs",
}

Settings.SessionSettings = {}

-- First time if not marked.
if plugin:GetSetting("uStud") == nil then
	for settingName, value in next, Settings.DefaultSettings do
		plugin:SetSetting(prefix:format(settingName), value)
	end

	plugin:SetSetting("uStud", true)
end

for settingName, _ in next, Settings.DefaultSettings do
	Settings.SessionSettings[settingName] = plugin:GetSetting(settingName) or Settings.DefaultSettings[settingName]
end

Settings.Get = function(settingName)
	return Settings.SessionSettings[settingName]
end

Settings.Set = function(settingName, value)
	Settings.SessionSettings[settingName] = value
	plugin:SetSetting(prefix:format(settingName), value)
end

return Settings
