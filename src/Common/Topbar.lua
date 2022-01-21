--[=[
	@class Topbar
	Creates a topbar with a title and optionally a return back button.

	![Image of topbar](/uStud/rendered/topbar.png)
]=]

--[=[
	@within Topbar
	@interface Props
	.Size UDim2
	.Position UDim2
	.OnReturn () -> ()
	.Title string
]=]

local Packages = script.Parent.Parent.Packages
local Roact = require(Packages.Roact)
local StudioComponents = require(Packages.StudioComponents)

return function(props)
	if props.ShowReturnBack then
		return Roact.createElement("Frame", {
			Position = props.Position,
			Size = props.Size,
			BackgroundTransparency = 1,
		}, {
			ReturnBack = Roact.createElement(StudioComponents.Button, {
				Size = UDim2.new(0, 25, 1, 0),
				Text = "<",
				OnActivated = function()
					props.OnReturn()
				end,
			}),
			Title = Roact.createElement(StudioComponents.Label, {
				Size = UDim2.new(1, -25, 1, 0),
				Position = UDim2.new(0, 25, 0, 0),
				TextSize = 16,
				Font = Enum.Font.SourceSansBold,
				Text = props.Title,
			}),
		})
	else
		return Roact.createElement(StudioComponents.Label, {
			Position = props.Position,
			Size = props.Size,
			Text = props.Title,
			TextSize = 16,
			Font = Enum.Font.SourceSansBold,
		})
	end
end
