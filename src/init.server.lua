local Maid = require(script.Packages.Maid)
local Interface = require(script.Main)(plugin)

--[[
	What happens when button is pressed
		-> if plugin is active
			Close widget
			Disconnect events
			Destroy gui
		-> if plugin inactive
			activate plugin
			open widget
			mount gui
			connect events
	What happens studio unloads it
		-> if plugin is active
			Do above when button is pressed
		Delete the toolbar
		Delete the widget
		Delete the Button
]]

--[[
	init.server.lua should be a bootstrapper for uStud
	It expects the following interface
		t.loaded()
		t.activated(mouse)
		t.deactivated()
		t.unloaded()
]]

local PluginMaid = Maid.new()
local Active = false

local Toolbar = PluginMaid:GiveTask(plugin:CreateToolbar("uStud"))

local Button = PluginMaid:GiveTask(
	Toolbar:CreateButton("ActivatePlugin", "Start uStud", "http://www.roblox.com/asset/?id=118532704")
)

local WidgetArgs = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 250, 300, 220, 220)

local Widget = PluginMaid:GiveTask(plugin:CreateDockWidgetPluginGui("uStud Control Panel", WidgetArgs)) :: DockWidgetPluginGui

Widget.Enabled = false
Widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Widget.Title = "uStud Panel"

Widget:BindToClose(function()
	plugin:Deactivate()
end)

local function Unloading()
	plugin:Deactivate()
	Interface.Unloaded()
	PluginMaid:Cleanup()
end

local function Deactivating()
	if Active == false then
		return
	end

	Active = false
	Widget.Enabled = false
	Interface.Deactivated(plugin:GetMouse())
end

local function Activating()
	if Active == true then
		return
	end

	Active = true
	plugin:Activate(true)
	Interface.Activated(plugin:GetMouse(), Widget)
	Widget.Enabled = true
end

PluginMaid:GiveTask(Button.Click:Connect(function()
	if Active then
		plugin:Deactivate()
	else
		Activating()
	end
end))

PluginMaid:GiveTask(plugin.Deactivation:Connect(Deactivating))

PluginMaid:GiveTask(plugin.Unloading:Connect(Unloading))

Interface.Loaded(Widget)
