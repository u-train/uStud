local Roact = require(script.Parent.Libraries.Roact)
local StudderComponent = require(script.Parent.Studder)
local LabelledInputComponent = require(script.Parent.Common.LabelledInput)
local TopBarComponent = require(script.Parent.Common.Topbar)
local MenuComponent = require(script.Parent.Menu)

local App = Roact.Component:extend("App")
local MODES = {
	Studding = 1,
	"Studding",
	-- Filling = 2,
	-- "Filling",
	-- Splice = 3,
	-- "Splice",
	-- Merge = 4,
	-- "Merge"
}

local MODES_TO_COMPONENT = {
	StudderComponent
}

function App:init()
	self:setState({
		Mode = MODES.Studding,
		EditingIn = workspace:FindFirstChild("Studs") or workspace
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
						local SelectedInstance = game; do
							for
								ChildName in ("." .. Text):gmatch("%.([%w%d]+)")
							do
								local NextInstance =
									SelectedInstance:FindFirstChild(ChildName)
								if NextInstance then
									SelectedInstance = NextInstance
								else
									break
								end
							end
						end

						self:setState({
							EditingIn = SelectedInstance
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