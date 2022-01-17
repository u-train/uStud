local UserInputService = game:GetService("UserInputService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Roact = require(script.Parent.Parent.Packages.roact) :: Roact
local FolderContext = require(script.Parent.Parent.Common.FolderContext)

-- This is to align the studs correctly.
local RoundMidway = function(Value, Interval)
	Interval = Interval or 1
	local AbsValue = math.abs(Value)
	local Low = AbsValue - math.fmod(AbsValue, Interval)
	return (Low + Interval / 2) * math.sign(Value)
end

local function CreateStud(Props)
	local NewPart = Instance.new("Part")
	NewPart.Size = Vector3.new(Props.PartSize, Props.PartHeight, Props.PartSize)
	NewPart.Position = Props.Position
	NewPart.Color = Props.Color
	NewPart.TopSurface = Enum.SurfaceType.Smooth
	NewPart.BottomSurface = Enum.SurfaceType.Smooth
	NewPart.Anchored = true
	NewPart.Parent = Props.Parent
end

local StudderMouseControl = Roact.Component:extend("StudderMouseControl")

function StudderMouseControl:init()
	self.BaseplateRef = Roact.createRef()
	self.BrushRef = Roact.createRef()

	self.TargetPosition, self.UpdateTargetPositionBinding = Roact.createBinding(Vector3.new(0, 0, 0))

	self.MousePressed = false

	self.OnMouseLeftDown = UserInputService.InputBegan:Connect(function(InputObject, Processed)
		if Processed then
			return
		end

		if Enum.UserInputType.MouseButton1 ~= InputObject.UserInputType then
			return
		end

		self.MousePressed = true
		self:OnHit()
	end)

	self.OnMouseLeftUp = UserInputService.InputEnded:Connect(function(InputObject, _)
		-- We'll ignore if it was processed or not. We want to immediately
		-- stop studding if they move the move cursor out of place.

		if Enum.UserInputType.MouseButton1 ~= InputObject.UserInputType then
			return
		end

		ChangeHistoryService:SetWaypoint("uStud.StudsPlaced")
		self.MousePressed = false
	end)

	self.OnMouseMoved = UserInputService.InputChanged:Connect(function(InputObject, Processed)
		if Processed then
			return
		end

		if Enum.UserInputType.MouseMovement ~= InputObject.UserInputType then
			return
		end

		self:OnHit()
	end)
end

function StudderMouseControl:willUnmount()
	self.MousePressed = false
	self.OnMouseLeftUp:Disconnect()
	self.OnMouseLeftDown:Disconnect()
	self.OnMouseMoved:Disconnect()
end

function StudderMouseControl:render()
	local CanvasSize = self.props.PartSize * 10
	-- On render, the PartSize, SnappingInterval, or the HeightOffset could've
	--- of changed. Update to the binding to reflect this.
	self:UpdateTargetPosition()

	return FolderContext.WithFolder(function(Folder)
		return Roact.createElement(Roact.Portal, {
			target = Folder,
		}, {
			BaseCanvas = Roact.createElement("Part", {
				[Roact.Ref] = self.BaseplateRef,
				Size = Vector3.new(CanvasSize, 1, CanvasSize),
				Position = self.TargetPosition:map(function(v)
					return v * Vector3.new(1, 0, 1)
						+ Vector3.new(self.props.PartSize / 2, self.props.HeightOffset - 1.5, self.props.PartSize / 2)
				end),
				Anchored = true,
				CanCollide = false,
				Transparency = 1,
			}, {
				Grid = Roact.createElement("Texture", {
					Texture = "http://www.roblox.com/asset/?id=6601217742",
					StudsPerTileU = self.props.SnappingInterval,
					StudsPerTileV = self.props.SnappingInterval,
					Face = Enum.NormalId.Top,
					Archivable = false,
				}),
				Background = Roact.createElement("Texture", {
					Texture = "http://www.roblox.com/asset/?id=241685484",
					Transparency = 0.8,
					StudsPerTileU = 1,
					StudsPerTileV = 1,
					Face = Enum.NormalId.Top,
				}),
			}),
			Brush = Roact.createElement("Part", {
				[Roact.Ref] = self.BrushRef,
				Anchored = true,
				CanCollide = true,
				Transparency = 0.5,
				Size = Vector3.new(self.props.PartSize, self.props.PartHeight, self.props.PartSize),
				Position = self.TargetPosition,
			}, {
				Highlight = Roact.createElement("SelectionBox", {
					LineThickness = 0.04,
					Adornee = self.BrushRef,
				}),
			}),
		})
	end)
end

function StudderMouseControl:UpdateTargetPosition()
	local MousePosition = UserInputService:GetMouseLocation()
	local NewUnitRay = workspace.CurrentCamera:ViewportPointToRay(MousePosition.X, MousePosition.Y, 0)

	local WorldMousePosition = NewUnitRay.Origin
	local WorldMouseDirection = NewUnitRay.Direction

	-- Offset by down as the grid down by one for the canvas offset.
	local MultiplyBy = math.abs((WorldMousePosition.Y - (self.props.HeightOffset - 1)) / WorldMouseDirection.Y)

	local Offset = MultiplyBy * WorldMouseDirection
	local NewPosition = WorldMousePosition + Offset

	self.UpdateTargetPositionBinding(
		Vector3.new(
			RoundMidway(NewPosition.X, self.props.SnappingInterval),
			self.props.HeightOffset - self.props.PartHeight / 2,
			RoundMidway(NewPosition.Z, self.props.SnappingInterval)
		)
	)
end

function StudderMouseControl:OnHit()
	if self.BaseplateRef.current == nil then
		return
	end

	if self.props.EditingIn.Parent == nil then
		return
	end

	self:UpdateTargetPosition()

	if not self.MousePressed then
		return
	end

	local IntersectingParts = self.BrushRef.current:GetTouchingParts()
	if self.props.Deleting then
		for _, IntersectingPart: Instance in next, IntersectingParts do
			if IntersectingPart:IsDescendantOf(self.props.EditingIn) then
				IntersectingPart:Destroy()
			end
		end
	else
		for _, IntersectingPart: Instance in next, IntersectingParts do
			if IntersectingPart:IsDescendantOf(self.props.EditingIn) then
				return
			end
		end

		CreateStud({
			PartSize = self.props.PartSize,
			PartHeight = self.props.PartHeight,
			Color = self.props.PartColor,
			Parent = self.props.EditingIn,
			Position = self.TargetPosition:getValue(),
		})
	end
end

return StudderMouseControl
