local Maid = require(script.Packages.Maid)
local Interface = require(script.Main)(plugin)

--[=[
	@class Bootstrapper
	Essentially bootstraps this plugin with clean-up and loads `Main.lua`.
	It expects the following interface from `Main.lua`:

	- Interface.Loaded(Widget)
	- Interface.Activated(Mouse, Widget)
	- Interface.Deactivated(Mouse)
	- Interface.Unloaded()
]=]

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

--[=[
	@function Unloading
	@within Bootstrapper
	Called when the plugin is being unloaded.
]=]
local function Unloading()
	plugin:Deactivate()
	Interface.Unloaded()
	PluginMaid:Cleanup()
end

--[=[
	@function Deactivating
	@within Bootstrapper
	Called when the plugin is being deactivated. If it's already deactivated, it
	will do nothing. If it's deactivating, it will disable the widget and invoke
	the handle.
]=]
local function Deactivating()
	if Active == false then
		return
	end

	Active = false
	Widget.Enabled = false
	Interface.Deactivated(plugin:GetMouse())
end

--[=[
	@function Activating
	@within Bootstrapper
	Called when the plugin is being activated. If it's already active, it will
	do nothing. If it's activating, it will call the plugin activate method, and
	pass the mouse and widget to the handle.
]=]
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
