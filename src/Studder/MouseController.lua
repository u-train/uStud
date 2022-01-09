local UserInputService = game:GetService("UserInputService")
local Roact = require(script.Parent.Parent.Libraries.Roact)
local Round = require(script.Parent.Parent.Libraries.Round)
-- local MAX_PART_SIZE = 100

local GetRaycastResultFromMouse = require(script.Parent.Parent.Libraries.GetRaycastResultFromMouse)

local function CreateStud(Props)
	local NewPart = Instance.new("Part")
	NewPart.Size = Vector3.new(
		Props.PartSize,
		Props.PartHeight,
		Props.PartSize
	)
	NewPart.Position = Props.Position
	NewPart.Color = Props.Color
	NewPart.TopSurface = Enum.SurfaceType.Smooth
	NewPart.BottomSurface = Enum.SurfaceType.Smooth
	NewPart.Anchored = true
	NewPart.Parent = Props.Parent
end

-- local function AngleBetweenTwoVectors(a, b)
-- 	return math.acos(a:Dot(b) / (a.Magnitude * b.Magnitude))
-- end

local StudderMouseControl = Roact.Component:extend("StudderMouseControl")

function StudderMouseControl:init()
	self.BaseplateRef = Roact.createRef()
	self.BrushRef = Roact.createRef()

	self.TargetPosition, self.UpdateTargetPosition = Roact.createBinding(
		Vector3.new(0,0,0)
	)

	self.MousePressed = false

	local OnMouseHit = function(InputObject)
		if self.BaseplateRef.current == nil then
			return
		end

		if self.props.EditingIn.Parent == nil then
			return
		end

		local Result = GetRaycastResultFromMouse(
			InputObject.Position,
			self.BaseplateRef.current
		)

		if Result == nil then
			-- TEMP: until I figure out how to do math, this will do to help
			-- correct position of the board.
			local NewPosition = workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1)
				+ Vector3.new(0, self.props.HeightOffset, 0)
			self.UpdateTargetPosition(
				Vector3.new(
					Round(NewPosition.X, self.props.SnappingInterval),
					self.props.HeightOffset - self.props.PartHeight / 2,
					Round(NewPosition.Z, self.props.SnappingInterval)
				)
			)
		else
			self.UpdateTargetPosition(
				Vector3.new(
					Round(Result.Position.X, self.props.SnappingInterval),
					self.props.HeightOffset - self.props.PartHeight / 2,
					Round(Result.Position.Z, self.props.SnappingInterval)
				)
			)
		end
		if not self.MousePressed then
			return
		end

		local IntersectingParts = self.BrushRef.current:GetTouchingParts()
		if self.props.Deleting then
			for _, IntersectingPart in next, IntersectingParts do
				IntersectingPart:Destroy()
			end
		else
			if #IntersectingParts > 0 then
				return
			end

			CreateStud({
				PartSize = self.props.PartSize,
				PartHeight = self.props.PartHeight,
				Color = self.props.PartColor,
				Parent = self.props.EditingIn,
				Position = self.TargetPosition:getValue()
			})
		end
	end

	self.OnMouseLeftUp = UserInputService.InputBegan:Connect(
		function(InputObject, Processed)
			if Processed then
				return
			end

			if Enum.UserInputType.MouseButton1 ~= InputObject.UserInputType then
				return
			end

			self.MousePressed = true
			OnMouseHit(InputObject)
		end
	)

	self.OnMouseLeftDown = UserInputService.InputEnded:Connect(
		function(InputObject, _)
			-- We'll ignore if it was processed or not. We want to immediately
			-- stop studding if they move the move cursor out of place.

			if Enum.UserInputType.MouseButton1 ~= InputObject.UserInputType then
				return
			end

			self.MousePressed = false
		end
	)

	self.OnMouseMoved = UserInputService.InputChanged:Connect(
		function(InputObject, Processed)
			if Processed then
				return
			end

			if Enum.UserInputType.MouseMovement ~= InputObject.UserInputType then
				return
			end

			OnMouseHit(InputObject)
		end
	)
end

function StudderMouseControl:willUnmount()
	self.MousePressed = false
	self.OnMouseLeftUp:Disconnect()
	self.OnMouseLeftDown:Disconnect()
	self.OnMouseMoved:Disconnect()
end

function StudderMouseControl:render()
	local CanvasSize = self.props.PartSize * 10

	return Roact.createElement(
		Roact.Portal,
		{
			target = workspace
		},
		{
			BaseCanvas = Roact.createElement(
				"Part",
				{
					[Roact.Ref] = self.BaseplateRef,
					Size = Vector3.new(
						CanvasSize,
						1,
						CanvasSize
					),
					Position = self.TargetPosition:map(
						function(v)
							return v * Vector3.new(1, 0, 1) + Vector3.new(self.props.PartSize/2, self.props.HeightOffset - 0.5, self.props.PartSize/2)
						end
					),
					Anchored = true,
					CanCollide = false,
					Transparency = 1,
				},
				{
					Grid = Roact.createElement(
						"Texture",
						{
							Texture = "http://www.roblox.com/asset/?id=6601217742",
							StudsPerTileU = self.props.SnappingInterval,
							StudsPerTileV = self.props.SnappingInterval,
							Face = Enum.NormalId.Top,
						}
					),
					Background = Roact.createElement(
						"Texture",
						{
							Texture = "http://www.roblox.com/asset/?id=241685484",
							Transparency = 0.8,
							StudsPerTileU = 1,
							StudsPerTileV = 1,
							Face = Enum.NormalId.Top
						}
					)
				}
			),
			Brush = Roact.createElement(
				"Part",
				{
					[Roact.Ref] = self.BrushRef,
					Anchored = true,
					CanCollide = true,
					Transparency = 0.5,
					Size = Vector3.new(
						self.props.PartSize,
						self.props.PartHeight,
						self.props.PartSize
					),
					Position = self.TargetPosition
				}
			)
		}
	)
end

return StudderMouseControl