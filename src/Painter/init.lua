local Roact = require(script.Parent.Libraries.Roact) :: Roact
local Common = script.Parent.Common
local ListLayoutComponent = require(Common.ListLayout)
local LabelledInputComponent = require(Common.LabelledInput)
local ColorInputComponent = require(Common.ColorInput)
-- local StudderMouseControl = require(script.MouseController)

local UserInputService = game:GetService("UserInputService")

local Painter = Roact.Component:extend("Painter")

function Painter:init()
	self:setState({
		PrimaryColor = Color3.new(1, 1, 1),
		SecondaryColor = Color3.new(1, 1, 1),
		BrushRadius = 2,
		SecondaryOnly = false,
	})
end

function Painter:render()
	return Roact.createElement(
		ListLayoutComponent,
		{
			Size = self.props.Size,
			Position = self.props.Position,
		},
		{
			PrimaryColor = Roact.createElement(
				ColorInputComponent,
				{
					Color = self.state.PrimaryColor,
					Label = "Primary",
					Size = UDim2.new(1, 0, 0, 25),
					OnColorchanged = function(NewColor)
						self:setState({
							PrimaryColor = NewColor
						})
					end
				}
			),
			SecondaryColor = Roact.createElement(
				ColorInputComponent,
				{
					Color = self.state.SecondaryColor,
					Label = "Secondary",
					Size = UDim2.new(1, 0, 0, 25),
					OnColorchanged = function(NewColor)
						self:setState({
							SecondaryColor = NewColor
						})
					end
				}
			),
			ToggleSecondaryOnly = Roact.createElement(
				"TextButton",
				{
					Text = "Toggle Secondary",
					BackgroundColor3 = self.state.SecondaryOnly
						and Color3.fromRGB(1148, 176, 149)
						or Color3.fromRGB(163, 162, 165),
					Size = UDim2.new(1, 0, 0, 25),
					[Roact.Event.MouseButton1Click] = function()
						self:setState({
							SecondaryOnly = not self.state.SecondaryOnly,
						})
					end
				}
			),
			BrushRadius = Roact.createElement(
				LabelledInputComponent,
				{
					Value = self.state.BrushRadius,
					Size = UDim2.new(1, 0, 0, 25),
					Label = "Brush Radius",

					OnValueChanged = function(Text)
						local NewInterval = tonumber(Text)

						if NewInterval == nil then
							return
						end

						self:setState({
							BrushRadius = NewInterval,
						})
					end
				}
			)
		}
	)
end

return Painter