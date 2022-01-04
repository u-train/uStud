local Roact = require(script.Parent.Libraries.Roact)
local StudderComponent = require(script.Parent.Studder)
local PainterComponent = require(script.Parent.Painter)
local LabelledInputComponent = require(script.Parent.Common.LabelledInput)
local TopBarComponent = require(script.Parent.Common.Topbar)
local MenuComponent = require(script.Parent.Menu)

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

local MODES_TO_COMPONENT = {
	StudderComponent,
	PainterComponent
}

local SelectInstance = function(SelectedInstance, Selection)
	for ChildName in ("." .. Selection):gmatch("%.([%w%d]+)") do
		local NextInstance = SelectedInstance:FindFirstChild(ChildName)
		if NextInstance then
			SelectedInstance = NextInstance
		end
	end

	return SelectedInstance
end

function App:init()
	self:setState({
		Mode = MODES.Studding,
		EditingIn = SelectInstance(
			game,
			self.props.SettingManager.Get("DefaultEditingIn")
		) or warn("Malformed default place to edit in. Fix in settings.") or workspace
	})
end

function App:render()
	if not self.props.Active then
		return
	end

	local Children

	if self.state.Mode == nil then
		Children = {
			Topbar = Roact.createElement(
				TopBarComponent,
				{
					Title = "Menu",
					ShowReturnBack = false,
					Size = UDim2.new(1, 0, 0, 25)
				}
			),
			Menu = Roact.createElement(
				MenuComponent,
				{
					Size = UDim2.new(1, 0, 1, -30),
					Position = UDim2.new(0, 0, 0, 30),
					Selections = MODES,
					OnSelection = function(Selection)
						self:setState({
							Mode = MODES[Selection]
						})
					end
				}
			),
		}
	else
		Children = {
			Topbar = Roact.createElement(
				TopBarComponent,
				{
					Title = MODES[self.state.Mode],
					ShowReturnBack = true,
					Size = UDim2.new(1, 0, 0, 25),
					OnReturn = function()
						self:setState({
							Mode = Roact.None
						})
					end
				}
			),
			View = Roact.createElement(
				MODES_TO_COMPONENT[self.state.Mode],
				{
					EditingIn = self.state.EditingIn,
					Size = UDim2.new(1, 0, 1, -55),
					Position = UDim2.new(0, 0, 0, 25),
				}
			),
			Bottombar = Roact.createElement(
				LabelledInputComponent,
				{
					Value = self.state.EditingIn:GetFullName(),
					Size = UDim2.new(1, 0, 0, 25),
					Position = UDim2.new(0, 0, 1, -25),
					Label = "Editing In",

					OnValueChanged = function(Text)
						self:setState({
							EditingIn = SelectInstance(game, Text)

						})
					end
				}
			),
		}
	end

	return Roact.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(1, 1),
		},
		Children
	)
end

return App