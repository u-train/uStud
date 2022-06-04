local UserInputService = game:GetService("UserInputService")
local Context = game:GetService("ContextActionService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

local Packages = script.Parent.Parent.Packages
local Roact = require(Packages.Roact)
local StudioComponents = require(Packages.StudioComponents)

local Common = script.Parent.Parent.Common
local FolderController = require(Common.FolderController)
local withSettings = require(Common.withSettings)

local MAX_ITERATIONS = 2000

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

local MouseController = Roact.Component:extend("FillMouseController")

function MouseController:init()
	self.baseplateRef = Roact.createRef()
	self.brushRef = Roact.createRef()

	self:setState({
		fillResult = {},
		previewing = false
	})

	self.targetPosition, self.updateTargetPositionBinding = Roact.createBinding(Vector3.new(0, 0, 0))

	self.onMouseLeftDown = UserInputService.InputBegan:Connect(function(inputObject, processed)

		if Enum.UserInputType.Keyboard == inputObject.UserInputType then
			if Enum.KeyCode.R == inputObject.KeyCode then
				self:getPositionsForFill()
				self:setState({ previewing = true })
			end
		elseif Enum.UserInputType.MouseButton1 == inputObject.UserInputType and not processed then
			self:getPositionsForFill()
			self:buildFilled()
			ChangeHistoryService:SetWaypoint("uStud.StudsFilled")
			self:getPositionsForFill()
		end
	end)

	self.onMouseLeftUp = UserInputService.InputEnded:Connect(function(inputObject, _)
		-- We'll ignore if it was processed or not. We want to immediately
		-- stop studding if they move the move cursor out of place.

		if Enum.UserInputType.Keyboard ~= inputObject.UserInputType then
			return
		end

		if Enum.KeyCode.R ~= inputObject.KeyCode then
			return
		end

		self:setState({ previewing = false })
	end)

	self.onMouseMoved = UserInputService.InputChanged:Connect(function(inputObject, processed)
		if processed then
			return
		end

		if Enum.UserInputType.MouseMovement ~= inputObject.UserInputType then
			return
		end

		self:updateTargetPosition()

		if not self.state.previewing then
			return
		end

		self:getPositionsForFill()
	end)
end

function MouseController:willUnmount()
	self.state.previewing = false
	self.onMouseLeftUp:Disconnect()
	self.onMouseLeftDown:Disconnect()
	self.onMouseMoved:Disconnect()
end

function MouseController:render()
	return withSettings(function(settingsManager)
		local partSize = Vector3.new(self.props.partSize, self.props.partHeight, self.props.partSize)

		local preview = {}

		if self.state.previewing then
			for _, pos in next, self.state.fillResult do
				table.insert(
					preview,
					Roact.createElement("Part", {
						Anchored = true,
						CanCollide = true,
						Material = Enum.Material.SmoothPlastic,
						Transparency = 0.8,
						Color = Color3.new(1, 0, 0),
						Size = partSize,
						Position = pos,
					})
				)
			end
		end

		return FolderController.withFolder(function(folder)
			return Roact.createElement(Roact.Portal, {
				target = folder,
			}, {
				Preview = Roact.createElement("Folder", {
					Name = "Preview",
				}, preview),
				Brush = Roact.createElement("Part", {
					[Roact.Ref] = self.brushRef,
					Anchored = true,
					CanCollide = true,
					Material = Enum.Material.SmoothPlastic,
					Transparency = settingsManager.get("StudderPartTransparency"),
					Color = settingsManager.get("StudderPartcolor"),
					Size = partSize,
					Position = self.targetPosition,
				}, {
					Highlight = Roact.createElement("SelectionBox", {
						LineThickness = settingsManager.get("StudderHighlightThickness"),
						SurfaceColor3 = settingsManager.get("StudderHighlightColor"),
						Color3 = settingsManager.get("StudderHighlightColor"),
						SurfaceTransparency = settingsManager.get("StudderHighlightSurfaceTransparency"),
						Adornee = self.brushRef,
					}),
				}),
			})
		end)
	end)
end

function MouseController:updateTargetPosition()
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

function MouseController:getPositionsForFill()
	if self.lastFilledPosition == self.targetPosition:getValue() then
		return
	end

	self.lastFilledPosition = self.targetPosition:getValue()

	local stack = {}
	local result = {}

	local iterations = 0

	local insertPositionIfValid = function(origin, offsetX, offsetZ)
		local pos = Vector3.new(
			origin.X + self.props.partSize * offsetX,
			origin.Y,
			origin.Z + self.props.partSize * offsetZ
		)

		local fuzz = Vector3.new(-0.01, -0.01, -0.01)

		if table.find(result, pos) then
			return
		end

		local params = OverlapParams.new()
		params.FilterDescendantsInstances = { self.props.root }
		params.FilterType = Enum.RaycastFilterType.Whitelist

		local parts = workspace:GetPartBoundsInBox(
			CFrame.new(pos),
			Vector3.new(self.props.partSize, self.props.partHeight, self.props.partSize) + fuzz,
			params
		)

		if #parts == 0 then
			table.insert(stack, pos)
			table.insert(result, pos)
		end
	end

	insertPositionIfValid(self.lastFilledPosition, 0, 0)

	while #stack > 0 and iterations <= MAX_ITERATIONS do
		local currentPosition = table.remove(stack, 1)
		iterations += 1

		insertPositionIfValid(currentPosition, 0, 1)
		insertPositionIfValid(currentPosition, 1, 0)

		insertPositionIfValid(currentPosition, 0, -1)
		insertPositionIfValid(currentPosition, -1, 0)
	end

	self:setState({
		fillResult = result,
	})
end

function MouseController:buildFilled()
	-- task.spawn(function()
	-- 	local i = 0

		for _, position in next, self.state.fillResult do
			-- i += 1
			createStud({
				position = position,
				partSize = self.props.partSize,
				partHeight = self.props.partHeight,
				color = self.props.partColor,
				parent = self.props.root,
			})
			-- if i >= 50 then
			-- 	task.wait()
			-- 	i = 0
			-- end
		end
	-- end)
end

return MouseController
