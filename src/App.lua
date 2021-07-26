local Roact = require(script.Parent.Libraries.Roact)
local ListLayoutComponent = require(script.Parent.ListLayout)
local ControlledInputComponent = require(script.Parent.ControlledInput)
local ColorInputComponent = require(script.Parent.ColorInput)

local App = Roact.Component:extend("App")
local AppStates = {
    Menu = 0,
    Studding = 1,
    Painting = 2,
    Filling = 3,
}

function App:init()
    self:setState({
        Mode = AppStates.Studding, --TODO: add different modes. For now, there's
        -- only studding mode.

        Snapping = 1,
        PartSize = 1,
        PartColor = Color3.new(0.5, 0.5, 0.5),
        PartHeight = 1,
        HeightOffset = 0.5,

        Root = workspace:FindFirstChild("Studs"),
        EditingIn = workspace:FindFirstChild("Studs")
    })
end

function App:render()
    if not self.props.Active then
        return
    end

    return Roact.createElement(
        ListLuayoutComponent,
        {
			Size = UDim2.fromScale(1, 1)
		},
        {
            PartHeightInput = Roact.createElement(
                ControlledInputComponent,
                {
                    Value = self.state.PartHeight,
                    OnValueChanged = print,
                    Size = UDim2.new(1, 0, 0, 25)
                }
            ),
            Roact.createElement(
                ColorInputComponent,
                {
                    Color = self.state.PartColor,
                    Label = "Part Color",
                    Size = UDim2.new(1, 0, 0, 25),
                    OnColorChanged = function(NewColor)
                        print(NewColor)
                        self:setState({
                            PartColor = NewColor
                        })
                    end
                }
            )
        }
    )
end

return App