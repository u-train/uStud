local Roact = require(script.Parent.Packages.roact) :: Roact
local Studder = require(script.Parent.Studder)
local Painter = require(script.Parent.Painter)
local Menu = require(script.Parent.Menu)

local Common = script.Parent.Common
local InstanceSelector = require(Common.InstanceSelector)
local LabelledInput = require(Common.LabelledInput)
local TopBar = require(Common.Topbar)
local FolderContext = require(Common.FolderContext)

local App = Roact.Component:extend("App")
local MODES = {
	Studding = 1,
	"Studding",
	Painting = 2,
	"Painting",
	-- Filling = 2,
	-- "Filling",
	-- Splice = 3,
	-- "Splice",
	-- Merge = 4,
	-- "Merge"
}

local MODES_TO_COMPONENTS = {
	Studder,
	Painter,
}

function App:init()
	local DefaultEditingIn = InstanceSelector.Select(game, self.props.SettingManager.Get("DefaultEditingIn"))
	self:HookOnTargetEditingInstance(DefaultEditingIn)

	self:setState({
		EditingIn = DefaultEditingIn or warn(
			"Malformed default place to edit in. Fix in settings."
		),
	})
end

function App:willUpdate(_, IncomingState)
	self:HookOnTargetEditingInstance(IncomingState.EditingIn)
end

function App:willUnmount()
	self.Event:Disconnect()
	self.Event = nil
end

function App:render()
	if not self.props.Active then
		return
	end

	local Children

	if self.state.EditingIn == nil then
		Children = {
			View = Roact.createElement("TextLabel", {
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
					local Success, Value = pcall(InstanceSelector.Select, game, Text)

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
		}
	else
		if self.state.Mode then
			Children = {
				Topbar = Roact.createElement(TopBar, {
					Title = MODES[self.state.Mode],
					ShowReturnBack = true,
					Size = UDim2.new(1, 0, 0, 25),
					OnReturn = function()
						self:setState({
							Mode = Roact.None,
						})
					end,
				}),
				View = Roact.createElement(MODES_TO_COMPONENTS[self.state.Mode], {
					EditingIn = self.state.EditingIn,
					Size = UDim2.new(1, 0, 1, -55),
					Position = UDim2.new(0, 0, 0, 25),
				}),
				Bottombar = Roact.createElement(LabelledInput, {
					Value = InstanceSelector.EscapeFullName(self.state.EditingIn),
					Size = UDim2.new(1, 0, 0, 25),
					Position = UDim2.new(0, 0, 1, -25),
					Label = "Editing In",

					OnValueChanged = function(Text)
						local Success, Value = pcall(InstanceSelector.Select, game, Text)

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
			}
		else
			Children = {
				Topbar = Roact.createElement(TopBar, {
					Title = "Menu",
					ShowReturnBack = false,
					Size = UDim2.new(1, 0, 0, 25),
				}),
				Menu = Roact.createElement(Menu, {
					Size = UDim2.new(1, 0, 1, -30),
					Position = UDim2.new(0, 0, 0, 30),
					Selections = MODES,
					OnSelection = function(Selection)
						self:setState({
							Mode = MODES[Selection],
						})
					end,
				}),
			}
		end
	end

	return Roact.createElement(FolderContext, { Value = self.Folder }, {
		Container = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
		}, Children),
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
