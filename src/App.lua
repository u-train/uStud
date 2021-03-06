local Packages = script.Parent.Packages
local Roact = require(Packages.Roact)
local RoactRouter = require(Packages.RoactRouter)
local InstanceQuerier = require(Packages.InstanceQuerier)
local StudioComponents = require(Packages.StudioComponents)

local Studder = require(script.Parent.Studder)
local Painter = require(script.Parent.Painter)
local Menu = require(script.Parent.Menu)
local About = require(script.Parent.About)
local Fill = require(script.Parent.Fill)

local Common = script.Parent.Common
local LabelledInput = require(Common.LabelledInput)
local Topbar = require(Common.Topbar)
local FolderController = require(Common.FolderController)

--[=[
	@within App
	@prop ROUTES { string }
	The list of avaliable routes. Currently, they are:
	- Studder
	- Painter
	- About
]=]
local ROUTES = {
	{ name = "Studder", path = "/Studder" },
	{ name = "Painter", path = "/Painter" },
	{ name = "Fill", path = "/Fill" },
	{ name = "About", path = "/About" },
}

--[=[
	@class App
	The root for this plugin.

	The app looks like this when Root is valid.

	![App when Root is valid.](/uStud/rendered/app.png)

	If it isn't valid, it will render this menu instead.

	![App when Root isn't valid.](/uStud/rendered/appUponInvalidEditingIn.png)

	TODO:
	1.	The way the component keeps track of "Root" is hacky. Streamline it
		by extracting the logic to figure out of the "Root is valid into a
		static function. In render, if it's invaild then set the state
		accordingly?
	2.	Make it so that the menu upon a invaild Root is its own component.
]=]
local App = Roact.Component:extend("App")

--[=[
	@within App
	@interface Props
	.settingManager Settings
	.enabled boolean
]=]
function App:init()
	local success, value = InstanceQuerier.select(game, self.props.defaultRootPath)

	local defaultRoot = if success then value else nil

	self:hookOnTargetRootInstance(defaultRoot)

	self:setState({
		root = defaultRoot,
		heightOffset = self.props.heightOffset or 1,
	})
end

--[=[
	It's here to make sure that before the component updates, the new location
	that the tool edits in is binded.
]=]
function App:willUpdate(_, incomingState)
	self:hookOnTargetRootInstance(incomingState.root)
end

--[=[
	To disconnect the event keeping track of changes.
]=]
function App:willUnmount()
	if self.event then
		self.event:Disconnect()
		self.event = nil
	end
end

--[=[
	Render.
	@return RoactTree
]=]
function App:render()
	if not self.props.active then
		return
	end

	if self.state.root == nil then
		return Roact.createElement(StudioComponents.Background, {}, {
			View = Roact.createElement(StudioComponents.Label, {
				Text = "Instance that was targetted to be edited in is no longer valid! This is because it is no longer a descendant of Workspace.",
				Size = UDim2.new(1, -20, 1, -30),
				Position = UDim2.new(0, 10, 0, 0),
				BorderSizePixel = 0,
				TextWrap = true,
			}),
			Bottombar = Roact.createElement(LabelledInput, {
				value = "Workplace.",
				size = UDim2.new(1, 0, 0, 25),
				position = UDim2.new(0, 0, 1, -25),
				label = "Editing under",

				onValueChanged = function(text)
					local success, value = InstanceQuerier.select(game, text)

					if success then
						if value == workspace or value == game then
							self:setState({
								root = Roact.None,
							})
						else
							self:setState({
								root = value,
							})
						end
					end
				end,
			}),
		})
	end

	local toolProps = {
		root = self.state.root,
		rootChanged = function(value)
			self:setState({
				root = value,
			})
		end,
		heightOffset = self.state.heightOffset,
		heightOffsetChanged = function(value)
			self:setState({
				heightOffset = value,
			})
		end,
	}

	return Roact.createElement(FolderController, {}, {
		Container = Roact.createElement(StudioComponents.Background, {}, {
			Router = Roact.createElement(RoactRouter.Router, {}, {
				Menu = Roact.createElement(RoactRouter.Route, {
					path = "/",
					render = function(routerInfo)
						return Roact.createFragment({
							Topbar = Roact.createElement(Topbar, {
								title = "Menu",
								showReturnBack = false,
								size = UDim2.new(1, 0, 0, 25),
							}),
							Menu = Roact.createElement(Menu, {
								size = UDim2.new(1, 0, 1, -30),
								position = UDim2.new(0, 0, 0, 30),
								selections = ROUTES,
								history = routerInfo.history,
							}),
						})
					end,
					exact = true,
				}),
				Studder = Roact.createElement(RoactRouter.Route, {
					path = "/Studder",
					render = function(_)
						return Roact.createElement(Studder, toolProps)
					end,
				}),
				Painter = Roact.createElement(RoactRouter.Route, {
					path = "/Painter",
					render = function(_)
						return Roact.createElement(Painter, toolProps)
					end,
				}),
				About = Roact.createElement(RoactRouter.Route, {
					path = "/About",
					render = function(_)
						return Roact.createElement(About, {})
					end,
				}),
				Fill = Roact.createElement(RoactRouter.Route, {
					path = "/Fill",
					render = function(_)
						return Roact.createElement(Fill, toolProps)
					end,
				}),
			}),
		}),
	})
end

--[=[
	Hooks onto target and ensures last target disconnects before doing so. Keeps
	track of target if it gets deparented.
	@param root Instance?
]=]
function App:hookOnTargetRootInstance(root)
	if self.event and self.event.Connected then
		self.event:Disconnect()
		self.event = nil
	end

	if root == nil then
		return
	end

	self.event = root.AncestryChanged:Connect(function(_, parent)
		if parent == nil or (parent and not parent:IsDescendantOf(workspace)) then
			self:setState({
				root = Roact.None,
			})

			if self.event and self.event.Connected then
				self.event:Disconnect()
				self.event = nil
			end
		end
	end)
end

return App
