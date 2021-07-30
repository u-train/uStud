local Settings = {
	DefaultEditingIn = "Workspace.Studs"
}

local Prefix = "uStud."

return function(plugin)
	if plugin:GetSetting("uStud") == nil then
		for SettingName, Value in next, Settings do
			plugin:SetSetting(Prefix .. SettingName, Value)
		end

		plugin:SetSetting("uStud", true)
	else
		for SettingName, _ in next, Settings do
			Settings[SettingName] = plugin:GetSetting(SettingName)
				or Settings[SettingName]
		end
	end

	return {
		Get = function(SettingName)
			return Settings[SettingName]
		end,
		Set = function(SettingName, Value)
			Settings[SettingName] = Value
			plugin:SetSetting(Prefix .. SettingName, Value)
		end
	}
end