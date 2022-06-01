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
	StudderGridTransparency = 0.8,
	StudderGridSize = 10,
	StudderGridColor = Color3.new(1, 1, 1),
	StudderPartTransparency = 0.5,
	StudderPartColor = Color3.fromRGB(0, 0, 0),
	StudderHighlightColor = Color3.fromRGB(0, 0, 0),
	StudderHighlightThickness = 0.02,
	StudderHighlightSurfaceTransparency = 1,

	StudderMaxSize = 200,
	StudderMinSize = 0.05,
	StudderMaxHeightOffset = 10,
	StudderMinHeightOffset = -10,
	StudderMaxHeight = 5,
	StudderMinHeight = 0.05,

	StudderDefaultPartSize = 1,
	StudderDefaultPartColor = Color3.fromRGB(163, 162, 165),
	StudderDefaultPartHeight = 1,

	PainterBrushTransparency = 0.8,
	PainterBrushThickness = 0.4,
	PainterDefaultPrimaryColor = Color3.fromRGB(163, 162, 165),
	PainterDefaultSecondaryColor = Color3.fromRGB(163, 162, 165),
	PainterDefaultBrushDiameter = 2,
	PainterDefaultSecondaryOnly = false,
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

Settings.get = function(settingName)
	return Settings.SessionSettings[settingName]
end

Settings.set = function(settingName, value)
	Settings.SessionSettings[settingName] = value
	plugin:SetSetting(prefix:format(settingName), value)
end



return Settings
