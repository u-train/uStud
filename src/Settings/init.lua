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

local Settings = {
	DefaultEditingIn = "Workspace.Studs",
}

local Prefix = "uStud."

return function(plugin)
	if plugin:GetSetting("uStud") == nil then
		for settingName, value in next, Settings do
			plugin:SetSetting(Prefix .. settingName, value)
		end

		plugin:SetSetting("uStud", true)
	else
		for settingName, _ in next, Settings do
			Settings[settingName] = plugin:GetSetting(settingName) or Settings[settingName]
		end
	end

	return {
		Get = function(settingName)
			return Settings[settingName]
		end,
		Set = function(settingName, value)
			Settings[settingName] = value
			plugin:SetSetting(Prefix .. settingName, value)
		end,
	}
end
