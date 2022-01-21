local Maid = require(script.Packages.Maid)
local Interface = require(script.Main)(plugin)

--[=[
	@class Bootstrapper
	Essentially bootstraps this plugin with clean-up and loads `Main.lua`.
	It expects the following interface from `Main.lua`:

	- Interface.loaded(Widget)
	- Interface.activated(Mouse, Widget)
	- Interface.deactivated(Mouse)
	- Interface.unloaded()
]=]
local Bootstrapper = {}
Bootstrapper.active = false

local pluginMaid = Maid.new()

local Toolbar = pluginMaid:GiveTask(plugin:CreateToolbar("uStud"))

local Button = pluginMaid:GiveTask(
	Toolbar:CreateButton("ActivatePlugin", "Start uStud", "http://www.roblox.com/asset/?id=118532704")
)

local widgetArgs = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 250, 300, 220, 220)

local widget = pluginMaid:GiveTask(plugin:CreateDockWidgetPluginGui("uStud Control Panel", widgetArgs)) :: DockWidgetPluginGui

widget.Enabled = false
widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
widget.Title = "uStud Panel"

widget:BindToClose(function()
	plugin:Deactivate()
end)

--[=[
	Called when the plugin is being unloaded.
]=]
function Bootstrapper.unloading()
	plugin:Deactivate()
	Interface.unloaded()
	pluginMaid:Cleanup()
end

--[=[
	Called when the plugin is being deactivated. If it's already deactivated, it
	will do nothing. If it's deactivating, it will disable the widget and invoke
	the handle.
]=]
function Bootstrapper.deactivating()
	if Bootstrapper.active == false then
		return
	end

	Bootstrapper.active = false
	widget.Enabled = false
	Interface.deactivated(plugin:GetMouse())
end

--[=[
	Called when the plugin is being activated. If it's already active, it will
	do nothing. If it's activating, it will call the plugin activate method, and
	pass the mouse and widget to the handle.
]=]
function Bootstrapper.activating()
	if Bootstrapper.active == true then
		return
	end

	Bootstrapper.active = true
	plugin:Activate(true)
	Interface.activated(plugin:GetMouse(), widget)
	widget.Enabled = true
end

pluginMaid:GiveTask(Button.Click:Connect(function()
	if Bootstrapper.active then
		plugin:Deactivate()
	else
		Bootstrapper.activating()
	end
end))

pluginMaid:GiveTask(plugin.Deactivation:Connect(Bootstrapper.deactivating))

pluginMaid:GiveTask(plugin.Unloading:Connect(Bootstrapper.unloading))

Interface.loaded(widget)
