local Roact = require(script.Parent.Libraries.Roact)
local ListLayoutComponent = require(script.Parent.ListLayout)

local App = Roact.Component:extend("App")

function App:init()
    self:setState({
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
        ListLayoutComponent,
        {
			Size = UDim2.fromScale(1, 1)
		},
        {
            Roact.createElement(
                "TextLabel",
                {
                    Text = "Hello world",
                    Size = UDim2.new(1, 0, 0, 25)
                }
            ),
        }
    )
end

return App