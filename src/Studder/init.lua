local Roact = require(script.Parent.Libraries.Roact)

local Common = script.Parent.Common
local ListLayoutComponent = require(Common.ListLayout)
local LabelledInputComponent = require(Common.LabelledInput)
local ColorInputComponent = require(Common.ColorInput)
local StudderMouseControl = require(script.MouseController)

local App = Roact.Component:extend("App")

local MaxSize = 200
local MinSize = 0.05
local MaxHeightOffset = 10
local MinHeightOffset = -10
local MaxHeight = 5
local MinHeight = 0.05

function App:init()
	self:setState({
		SnappingInterval = 1,
		PartSize = 1,
		PartColor = Color3.new(0.5, 0.5, 0.5),
		PartHeight = 1,
		HeightOffset = 0.5,
		Deleting = false,
	})
end

function App:render()
	return Roact.createElement(
		ListLayoutComponent,
		{
			Size = self.props.Size,
			Position = self.props.Position
		},
		{
			PartSizeInput = Roact.createElement(
				LabelledInputComponent,
				{
					Value = self.state.PartSize,
					Size = UDim2.new(1, 0, 0, 25),
					Label = "Part Size",

					OnValueChanged = function(Text)
						local NewSize = tonumber(Text)

						if NewSize == nil then
							return
						end

						NewSize = math.clamp(
							NewSize,
							MinSize,
							MaxSize
						)

						self:setState({
							PartSize = NewSize,
							SnappingInterval = NewSize,
						})
					end
				}
			),
			HeightOffsetInput = Roact.createElement(
				LabelledInputComponent,
				{
					Value = self.state.HeightOffset,
					Size = UDim2.new(1, 0, 0, 25),
					Label = "Height offset",

					OnValueChanged = function(Text)
						local NewValue = tonumber(Text)

						if NewValue == nil then
							return
						end

					   self:setState({
						   HeightOffset = math.clamp(
							   NewValue,
							   MinHeightOffset,
							   MaxHeightOffset
							)
					   })

					end,
				}
			),
			PartHeightInput = Roact.createElement(
				LabelledInputComponent,
				{
					Value = self.state.PartHeight,
					Size = UDim2.new(1, 0, 0, 25),
					Label = "Part Height",

					OnValueChanged = function(Text)
						local NewValue = tonumber(Text)

						if NewValue == nil then
							return
						end

					   NewValue = math.clamp(NewValue, MinHeight, MaxHeight)

					   self:setState({
						   PartHeight = NewValue
					   })

					end,
				}
			),
			SnappingInput = Roact.createElement(
				LabelledInputComponent,
				{
					Value = self.state.SnappingInterval,
					Size = UDim2.new(1, 0, 0, 25),
					Label = "Snapping Interval",

					OnValueChanged = function(Text)
						local NewInterval = tonumber(Text)

						if NewInterval == nil then
							return
						end

						self:setState({
							SnappingInterval = math.min(
								NewInterval,
								self.state.PartSize
							)
						})
					end
				}
			),
			ColorInput = Roact.createElement(
				ColorInputComponent,
				{
					Color = self.state.PartColor,
					Label = "Part Color",
					Size = UDim2.new(1, 0, 0, 25),
					OnColorChanged = function(NewColor)
						self:setState({
							PartColor = NewColor
						})
					end
				}
			),
			ToggleDelete = Roact.createElement(
				"TextButton",
				{
					Text = not self.state.Deleting
						and "Toggle to start deleting"
						or "Toggle to start placing",
					Size = UDim2.new(1, 0, 0, 25),
					[Roact.Event.MouseButton1Click] = function()
						self:setState({
							Deleting = not self.state.Deleting
						})
					end
				}
			),
			Roact.createElement(
				StudderMouseControl,
				{
					SnappingInterval = self.state.SnappingInterval,
					PartSize = self.state.PartSize,
					PartColor = self.state.PartColor,
					PartHeight = self.state.PartHeight,
					HeightOffset = self.state.HeightOffset,
					Deleting = self.state.Deleting,
					EditingIn = self.props.EditingIn,
				}
			)
		}
	)
end

return App