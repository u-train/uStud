local Roact = require(script.Parent.Parent.Libraries.Roact)

local ListLayout = Roact.Component:extend("ListLayout")

function ListLayout:init()
	self.SizeBinding, self.UpdateSizeBinding = Roact.createBinding(UDim2.new(self.props.Width, UDim.new(0, 0)))

	self.CanvasPosition, self.UpdateCanvasPosition = Roact.createBinding(Vector2.new(0, 0))
end

function ListLayout:render()
	return Roact.createElement("Frame", {
		Size = self.props.Size,
		Position = self.props.Position,
		AnchorPoint = self.props.AnchorPoint,
		Transparency = 1,
	}, {
		Roact.createElement("ScrollingFrame", {
			ScrollBarImageColor3 = self.props.ScrollBarImageColor3,
			BackgroundColor3 = self.props.BackgroundColor3,
			BorderSizePixel = self.props.BorderSizePixel,
			CanvasSize = self.SizeBinding,
			CanvasPosition = self.CanvasPosition,
			ScrollBarThickness = 6,

			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
			VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,

			[Roact.Change.CanvasPosition] = function(Rbx)
				self.UpdateCanvasPosition(Rbx.CanvasPosition)
			end,
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				Padding = self.props.Padding or UDim.new(0, 5),
				SortOrder = Enum.SortOrder.LayoutOrder,
				[Roact.Change.AbsoluteContentSize] = function(Rbx)
					self.UpdateSizeBinding(UDim2.new(self.props.Size.X, UDim.new(0, Rbx.AbsoluteContentSize.Y + 10)))
				end,
			}),
			Children = Roact.createFragment(self.props[Roact.Children]),
		}),
	})
end

return ListLayout
