local Roact = require(script.Parent.Packages.roact)
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

local MODES_TO_ = {
	Studder,
	Painter,
}

function App:init()
	self:setState({
		EditingIn = InstanceSelector.Select(game, self.props.SettingManager.Get("DefaultEditingIn")) or warn(
			"Malformed default place to edit in. Fix in settings."
		) or workspace,
	})

	self.Folder = Instance.new("Folder")
	self.Folder.Name = "uStudContainer"
	self.Folder.Archivable = false
	self.Folder.Parent = workspace
end

function App:willUnmount()
	self.Folder:Destroy()
end

function App:render()
	if not self.props.Active then
		return
	end

	local Children

	if self.state.Mode == nil then
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
	else
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
			View = Roact.createElement(MODES_TO_[self.state.Mode], {
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
						-- Return back to when there's a way to handle the case.
						-- Essentially want to somehow communicate that it isn't
						-- a valid location.
						-- if Value == workspace then
						-- 	return
						-- end

						self:setState({
							EditingIn = Value,
						})
					end
				end,
			}),
		}
	end

	return Roact.createElement(FolderContext, { Value = self.Folder }, {
		Container = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
		}, Children),
	})
end

return App
