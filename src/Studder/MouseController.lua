local ServerScriptService = game:GetService("ServerScriptService")
local UserInputService = game:GetService("UserInputService")
local Roact = require(script.Parent.Parent.Libraries.Roact)

local MAX_PART_SIZE = 2048

local GetRaycastResultFromMouse = function(MousePosition, Baseplate)
	local Camera = workspace.CurrentCamera

	local NewUnitRay = Camera:ViewportPointToRay(MousePosition.X, MousePosition.Y, MousePosition.Z)

	local TargetRaycastParam = RaycastParams.new()
	TargetRaycastParam.FilterType = Enum.RaycastFilterType.Whitelist
	TargetRaycastParam.FilterDescendantsInstances = { Baseplate }

	return workspace:Raycast(
		NewUnitRay.Origin,
		NewUnitRay.Direction * 2048,
		TargetRaycastParam
	)
end

local function RoundMidway(Value, Interval)
	Interval = Interval or 1
	local AbsValue = math.abs(Value)
	local Low = AbsValue - math.fmod(AbsValue, Interval)
	return (Low + Interval / 2) * math.sign(Value)
end

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

local StudderMouseControl = Roact.Component:extend("StudderMouseControl")

function StudderMouseControl:init()
	self.BaseplateRef = Roact.createRef()
	self.BrushRef = Roact.createRef()
	self.TargetPosition, self.UpdateTargetPosition = Roact.createBinding(
		Vector3.new(0, 0, 0)
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
			return
		end

		self.UpdateTargetPosition(
			Vector3.new(
				RoundMidway(Result.Position.X, self.props.SnappingInterval),
				self.props.HeightOffset - self.props.PartHeight / 2,
				RoundMidway(Result.Position.Z, self.props.SnappingInterval)
			)
		)

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
	local RoundedSize = math.floor(
		MAX_PART_SIZE / self.props.PartSize
	) * self.props.PartSize

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
						RoundedSize,
						1,
						RoundedSize
					),
					Position = Vector3.new(0, self.props.HeightOffset - 0.5, 0),
					Anchored = true,
					CanCollide = false,
					Transparency = 1,
				},
				{
					Texture = Roact.createElement(
						"Texture",
						{
							Texture = "http://www.roblox.com/asset/?id=6601217742",
							StudsPerTileU = self.props.SnappingInterval,
							StudsPerTileV = self.props.SnappingInterval,
							Face = Enum.NormalId.Top,
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