local Packages = script.Parent.Packages
local Roact = require(Packages.Roact) :: Roact
local RoactRouter = require(Packages.RoactRouter)
local InstanceQuerier = require(Packages.InstanceQuerier)
local StudioComponents = require(Packages.StudioComponents)

local Studder = require(script.Parent.Studder)
local Painter = require(script.Parent.Painter)
local Menu = require(script.Parent.Menu)

local Common = script.Parent.Common
local LabelledInput = require(Common.LabelledInput)
local Topbar = require(Common.Topbar)
local FolderContext = require(Common.FolderContext)

--[=[
	@within App
	@prop ROUTES { string }
	The list of avaliable routes. Currently, they are:
	- Studder
	- Painter
]=]
local ROUTES = {
	"Studder",
	"Painter",
}

--[=[
	@class App
	The root for this plugin.

	The app looks like this when Root is valid.

	![App when Root is valid.](/rendered/app.png)

	If it isn't valid, it will render this menu instead.

	![App when Root isn't valid.](/rendered/appUponInvalidEditingIn.png)

	TODO:
	1.	The way the component keeps track of "Root" is hacky. Streamline it
		by extracting the logic to figure out of the "Root is valid into a
		static function. In render, if it's invaild then set the state
		accordingly?
	2.	InstanceQuerier needs to be fixed up as well, not sure why I set it up
		the way I did. As soon I do, we'll get rid of the pcall.
	3.	Make it so that the menu upon a invaild Root is its own component.
]=]
local App = Roact.Component:extend("App")

--[=[
	@within App
	@interface Props
	.SettingManager Settings
	.Enabled boolean
]=]
function App:init()
	local Success, Value = pcall(InstanceQuerier.Select, game, self.props.SettingManager.Get("DefaultEditingIn"))

	local DefaultRoot = if Success then Value else nil

	self:HookOnTargetRootInstance(DefaultRoot)

	self:setState({
		Root = DefaultRoot,
		HeightOffset = self.props.SettingManager.Get("HeightOffset") or 1,
	})
end

--[=[
	It's here to make sure that before the component updates, the new location
	that the tool edits in is binded.
]=]
function App:willUpdate(_, IncomingState)
	self:HookOnTargetRootInstance(IncomingState.Root)
end

--[=[
	To disconnect the event keeping track of changes.
]=]
function App:willUnmount()
	if self.Event then
		self.Event:Disconnect()
		self.Event = nil
	end
end

--[=[
	Render.
	@return RoactTree
]=]
function App:render()
	if not self.props.Active then
		return
	end

	if self.state.Root == nil then
		return Roact.createElement(StudioComponents.Background, {}, {
			View = Roact.createElement(StudioComponents.Label, {
				Text = "Instance that was targetted to be edited in is no longer valid! This is because it is no longer a descendant of Workspace.",
				Size = UDim2.new(1, -20, 1, -30),
				Position = UDim2.new(0, 10, 0, 0),
				BorderSizePixel = 0,
				TextWrap = true,
			}),
			Bottombar = Roact.createElement(LabelledInput, {
				Value = "Workspace.",
				Size = UDim2.new(1, 0, 0, 25),
				Position = UDim2.new(0, 0, 1, -25),
				Label = "Editing under",

				OnValueChanged = function(Text)
					local Success, Value = pcall(InstanceQuerier.Select, game, Text)

					if Success then
						if Value == workspace or Value == game then
							return
						end

						self:setState({
							Root = Value,
						})
					end
				end,
			}),
		})
	end

	local ToolProps = {
		Root = self.state.Root,
		EditingInChanged = function(Value)
			self:setState({
				Root = Value,
			})
		end,
		HeightOffset = self.state.HeightOffset,
		HeightOffsetChanged = function(Value)
			self:setState({
				HeightOffset = Value,
			})
		end,
	}

	return Roact.createElement(FolderContext, { Value = self.Folder }, {
		Container = Roact.createElement(StudioComponents.Background, {}, {
			Router = Roact.createElement(RoactRouter.Router, {}, {
				Menu = Roact.createElement(RoactRouter.Route, {
					path = "/",
					render = function(RouterInfo) -- history, match, location
						return Roact.createFragment({
							Topbar = Roact.createElement(Topbar, {
								Title = "Menu",
								ShowReturnBack = false,
								Size = UDim2.new(1, 0, 0, 25),
							}),
							Menu = Roact.createElement(Menu, {
								Size = UDim2.new(1, 0, 1, -30),
								Position = UDim2.new(0, 0, 0, 30),
								Selections = ROUTES,
								History = RouterInfo.history,
							}),
						})
					end,
				}),
				Studder = Roact.createElement(RoactRouter.Route, {
					path = "Studder",
					render = function(_)
						return Roact.createElement(Studder, ToolProps)
					end,
				}),
				Painter = Roact.createElement(RoactRouter.Route, {
					path = "Painter",
					render = function(_)
						return Roact.createElement(Painter, ToolProps)
					end,
				}),
			}),
		}),
	})
end

--[=[
	Hooks onto target and ensures last target disconnects before doing so. Keeps
	track of target if it gets deparented.
	@param Root Instance?
]=]
function App:HookOnTargetRootInstance(Root)
	if self.Event and self.Event.Connected then
		self.Event:Disconnect()
		self.Event = nil
	end

	if Root == nil then
		return
	end

	self.Event = Root.AncestryChanged:Connect(function(_, Parent)
		if Parent == nil or (Parent and not Parent:IsDescendantOf(workspace)) then
			self:setState({
				Root = Roact.None,
			})

			if self.Event and self.Event.Connected then
				self.Event:Disconnect()
				self.Event = nil
			end
		end
	end)
end

return App
