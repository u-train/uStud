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

local ROUTES = {
	"Studder",
	"Painter",
}

--[=[
	@class App
	The root for this plugin.
]=]
local App = Roact.Component:extend("App")

--[=[
	@within App
	@interface Props
	.SettingManager Settings
]=]
function App:init()
	local Success, Value = pcall(InstanceQuerier.Select, game, self.props.SettingManager.Get("DefaultEditingIn"))

	local DefaultEditingIn = if Success then Value else nil

	self:HookOnTargetEditingInstance(DefaultEditingIn)

	self:setState({
		EditingIn = DefaultEditingIn,
		HeightOffset = self.props.SettingManager.Get("HeightOffset") or 1,
	})
end

function App:willUpdate(_, IncomingState)
	self:HookOnTargetEditingInstance(IncomingState.EditingIn)
end

function App:willUnmount()
	if self.Event then
		self.Event:Disconnect()
		self.Event = nil
	end
end

function App:render()
	if not self.props.Active then
		return
	end

	if self.state.EditingIn == nil then
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
				Label = "Editing In",

				OnValueChanged = function(Text)
					local Success, Value = pcall(InstanceQuerier.Select, game, Text)

					if Success then
						if Value == workspace or Value == game then
							return
						end

						self:setState({
							EditingIn = Value,
						})
					end
				end,
			}),
		})
	end

	local ToolProps = {
		EditingIn = self.state.EditingIn,
		EditingInChanged = function(Value)
			self:setState({
				EditingIn = Value,
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

function App:HookOnTargetEditingInstance(EditingIn: Instance)
	if self.Event and self.Event.Connected then
		self.Event:Disconnect()
		self.Event = nil
	end

	if EditingIn == nil then
		return
	end

	self.Event = EditingIn.AncestryChanged:Connect(function(_, Parent)
		if Parent == nil or (Parent and not Parent:IsDescendantOf(workspace)) then
			self:setState({
				EditingIn = Roact.None,
			})

			if self.Event and self.Event.Connected then
				self.Event:Disconnect()
				self.Event = nil
			end
		end
	end)
end

return App
