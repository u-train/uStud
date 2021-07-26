local Roact = require(script.Parent.Libraries.Roact)
local ListLayoutComponent = require(script.Parent.ListLayout)
local LabelledInputComponent = require(script.Parent.LabelledInput)
local ColorInputComponent = require(script.Parent.ColorInput)
local StudderMouseControl = require(script.Parent.StudderMouseControl)

local App = Roact.Component:extend("App")
local AppStates = {
	Menu = 0,
	Studding = 1,
	Painting = 2,
	Filling = 3,
}

local MaxHeightOffset = 10
local MinHeightOffset = -10
local MaxHeight = 5
local MinHeight = 0.05

function App:init()
	self:setState({
		Mode = AppStates.Studding, --TODO: add different modes. For now, there's
		-- only studding mode.

		SnappingInterval = 1,
		PartSize = 1,
		PartColor = Color3.new(0.5, 0.5, 0.5),
		PartHeight = 1,
		HeightOffset = 0.5,

		EditingIn = workspace:FindFirstChild("Studs") or workspace
	})
end

function App:render()
	if not self.props.Active then
		return
	end

	return Roact.createElement(
		ListLayoutComponent,
		{
			Size = UDim2.fromScale(1, 1)
		},
		{
			EditingInInput = Roact.createElement(
				LabelledInputComponent,
				{
					Value = self.state.EditingIn:GetFullName(),
					Size = UDim2.new(1, 0, 0, 25),
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
			Roact.createElement(
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
			Roact.createElement(
				StudderMouseControl,
				self.state
			)
		}
	)
end

return App