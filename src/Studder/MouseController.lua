local UserInputService = game:GetService("UserInputService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Roact = require(script.Parent.Parent.Packages.Roact) :: Roact
local FolderController = require(script.Parent.Parent.Common.FolderController)

-- This is to align the studs correctly.
local roundMidway = function(value, interval)
	interval = interval or 1
	local absValue = math.abs(value)
	local low = absValue - math.fmod(absValue, interval)
	return (low + interval / 2) * math.sign(value)
end

local function createStud(props)
	local newPart = Instance.new("Part")
	newPart.Size = Vector3.new(props.partSize, props.partHeight, props.partSize)
	newPart.Position = props.position
	newPart.Color = props.color
	newPart.TopSurface = Enum.SurfaceType.Smooth
	newPart.BottomSurface = Enum.SurfaceType.Smooth
	newPart.Anchored = true
	newPart.Parent = props.parent
end


--[=[
	@class StudderMouseControl
	Mouse controller for the studder. It also contains the canvas for the
	studder.
]=]
local StudderMouseControl = Roact.Component:extend("StudderMouseControl")

--[=[
	Creates the refs, create targetPosition binding, initalize some state, and
	also binds callbacks to UserInputService.
]=]
function StudderMouseControl:init()
	self.baseplateRef = Roact.createRef()
	self.brushRef = Roact.createRef()

	self.targetPosition, self.updateTargetPositionBinding = Roact.createBinding(Vector3.new(0, 0, 0))

	self.mousePressed = false

	self.onMouseLeftDown = UserInputService.InputBegan:Connect(function(inputObject, processed)
		if processed then
			return
		end

		if Enum.UserInputType.MouseButton1 ~= inputObject.UserInputType then
			return
		end

		self.mousePressed = true
		self:onHit()
	end)

	self.onMouseLeftUp = UserInputService.InputEnded:Connect(function(inputObject, _)
		-- We'll ignore if it was processed or not. We want to immediately
		-- stop studding if they move the move cursor out of place.

		if Enum.UserInputType.MouseButton1 ~= inputObject.UserInputType then
			return
		end

		ChangeHistoryService:SetWaypoint("uStud.StudsPlaced")
		self.mousePressed = false
	end)

	self.onMouseMoved = UserInputService.InputChanged:Connect(function(inputObject, processed)
		if processed then
			return
		end

		if Enum.UserInputType.MouseMovement ~= inputObject.UserInputType then
			return
		end

		self:onHit()
	end)
end

--[=[
	To disconnect event handlers and set state accordingly.
]=]
function StudderMouseControl:willUnmount()
	self.mousePressed = false
	self.onMouseLeftUp:Disconnect()
	self.onMouseLeftDown:Disconnect()
	self.onMouseMoved:Disconnect()
end

--[=[
	Renders.
	@return RoactTree
]=]
function StudderMouseControl:render()
	local canvasSize = self.props.partSize * 10
	-- On render, the partSize, SnappingInterval, or the HeightOffset could've
	-- of changed. Update to the binding to reflect this.
	self:updateTargetPosition()

	return FolderController.withFolder(function(folder)
		return Roact.createElement(Roact.Portal, {
			target = folder,
		}, {
			BaseCanvas = Roact.createElement("Part", {
				[Roact.Ref] = self.baseplateRef,
				Size = Vector3.new(canvasSize, 1, canvasSize),
				Position = self.targetPosition:map(function(v)
					return v * Vector3.new(1, 0, 1)
						+ Vector3.new(self.props.partSize / 2, self.props.heightOffset - 1.5, self.props.partSize / 2)
				end),
				Anchored = true,
				CanCollide = false,
				Transparency = 1,
			}, {
				Grid = Roact.createElement("Texture", {
					Texture = "http://www.roblox.com/asset/?id=6601217742",
					StudsPerTileU = self.props.snappingInterval,
					StudsPerTileV = self.props.snappingInterval,
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
				[Roact.Ref] = self.brushRef,
				Anchored = true,
				CanCollide = true,
				Transparency = 0.5,
				Size = Vector3.new(self.props.partSize, self.props.partHeight, self.props.partSize),
				Position = self.targetPosition,
			}, {
				Highlight = Roact.createElement("SelectionBox", {
					LineThickness = 0.04,
					Adornee = self.brushRef,
				}),
			}),
		})
	end)
end

--[=[
	Updates targetPosition binding on invoke using current state and the current
	mouse position provided by UserInputService.
]=]
function StudderMouseControl:updateTargetPosition()
	local mousePosition = UserInputService:GetMouseLocation()
	local newUnitRay = workspace.CurrentCamera:ViewportPointToRay(mousePosition.X, mousePosition.Y, 0)

	local worldMousePosition = newUnitRay.Origin
	local worldMouseDirection = newUnitRay.Direction

	-- Offset by down as the grid down by one for the canvas offset.
	local multiplyBy = math.abs((worldMousePosition.Y - (self.props.heightOffset - 1)) / worldMouseDirection.Y)

	local offset = multiplyBy * worldMouseDirection
	local newPosition = worldMousePosition + offset

	self.updateTargetPositionBinding(
		Vector3.new(
			roundMidway(newPosition.X, self.props.snappingInterval),
			self.props.heightOffset - self.props.partHeight / 2,
			roundMidway(newPosition.Z, self.props.snappingInterval)
		)
	)
end

--[=[
	Callback on hit. Verify that the require instances exist, update position,
	and if needed, place or delete studs.
]=]
function StudderMouseControl:onHit()
	if self.baseplateRef.current == nil then
		return
	end

	if self.props.root.Parent == nil then
		return
	end

	self:updateTargetPosition()

	if not self.mousePressed then
		return
	end

	local intersectingParts = self.brushRef.current:GetTouchingParts()
	if self.props.deleting then
		for _, intersectingPart: Instance in next, intersectingParts do
			if intersectingPart:IsDescendantOf(self.props.root) then
				intersectingPart:Destroy()
			end
		end
	else
		for _, intersectingPart: Instance in next, intersectingParts do
			if intersectingPart:IsDescendantOf(self.props.root) then
				return
			end
		end

		createStud({
			partSize = self.props.partSize,
			partHeight = self.props.partHeight,
			color = self.props.partColor,
			parent = self.props.root,
			position = self.targetPosition:getValue(),
		})
	end
end

return StudderMouseControl
