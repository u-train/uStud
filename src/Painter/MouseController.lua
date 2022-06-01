local Roact = require(script.Parent.Parent.Packages.Roact)
local UserInputService = game:GetService("UserInputService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

local Common = script.Parent.Parent.Common
local GetRaycastResultFromMouse = require(Common.GetRaycastResultFromMouse)
local FolderController = require(Common.FolderController)

local function createAdorn(Parent)
	local adorn = Instance.new("SelectionBox")
	adorn.Parent = Parent
	adorn.LineThickness = 0.05
	return adorn
end

--[=[
	@class PainterMouseControl
	Has the brush and is the mouse controller for the painter.

	TODO: Is there a better way of doing things with the adorns? Right now, it's
	hacky to say the least. Investigate.
]=]
local PainterMouseControl = Roact.Component:extend("PainterMouseControl")

--[=[
	Initalize refs, hook into UserInputService, and initalize adorns.
]=]
function PainterMouseControl:init()
	self.brushRef = Roact.createRef()
	self.brushPositionBinding, self.updateBrushPosition = Roact.createBinding(Vector3.new())
	self.adorns = {}
	self.adornContainer = Instance.new("Folder")
	self.adornContainer.Name = "AdornContainer"
	self.adornContainer.Parent = workspace

	self.isPainting = false

	self.inputBegan = UserInputService.InputBegan:Connect(function(input, processed)
		if Enum.UserInputType.MouseButton1 ~= input.UserInputType then
			return
		end

		if processed then
			return
		end

		if self.props.root.Parent == nil then
			return
		end

		self.isPainting = true
		self:updateAndPaintBrush(input)
	end)

	self.inputChanged = UserInputService.InputChanged:Connect(function(input, processed)
		if input.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		if processed then
			return
		end

		self:updateAndPaintBrush(input)
	end)

	self.inputEnded = UserInputService.InputEnded:Connect(function(input, _)
		if Enum.UserInputType.MouseButton1 ~= input.UserInputType then
			return
		end

		self.isPainting = false
		ChangeHistoryService:SetWaypoint("uStud.Paint")
	end)
end

--[=[
	Cleanup connections and adorns. Along with that, set state accordingly.
]=]
function PainterMouseControl:willUnmount()
	self.isPainting = false
	self.inputChanged:Disconnect()
	self.inputBegan:Disconnect()
	self.inputEnded:Disconnect()

	self.adorns = nil
	self.adornContainer:Destroy()
end

--[=[
	Render.
	@return RoactTree
]=]
function PainterMouseControl:render()
	return FolderController.withFolder(function(folder)
		return Roact.createElement(Roact.Portal, {
			target = folder,
		}, {
			Brush = Roact.createElement("Part", {
				[Roact.Ref] = self.brushRef,
				Anchored = true,
				CanCollide = true,
				Transparency = 0.8,
				Material = Enum.Material.Neon,

				Shape = Enum.PartType.Cylinder,
				Rotation = Vector3.new(0, 0, 90),
				Position = self.brushPositionBinding,
				Size = Vector3.new(0.4, self.props.brushDiameter, self.props.brushDiameter),
				Color = self.props.primaryColor,
			}),
		})
	end)
end

--[=[
	Uses the InputObject to update the paint brush's position. Additionally, if
	the user is holding the mouse down, will paint valid studs.
	@param input InputObject
]=]
function PainterMouseControl:updateAndPaintBrush(input)
	local raycastResults = GetRaycastResultFromMouse(input.Position, self.props.root)

	if raycastResults == nil then
		return
	end

	if raycastResults.Instance ~= self.brushRef.current then
		self.updateBrushPosition(raycastResults.Position)
	end

	self:updateAdorns()
	if self.isPainting then
		for _, Part in next, self:queryPaintableParts() do
			Part.Color = self.props.primaryColor
		end
	end
end

--[=[
	Update the adorns to what the brush is actually touching.
]=]
function PainterMouseControl:updateAdorns()
	local parts = self:queryPaintableParts()

	local difference = #parts - #self.adorns

	if difference < 0 then
		for i = 1, math.abs(difference) do
			local adorn = table.remove(self.adorns, i)
			if adorn then
				adorn:Destroy()
			end
		end
	elseif difference > 0 then
		for _ = 1, math.abs(difference) do
			table.insert(self.adorns, createAdorn(self.adornContainer))
		end
	end

	for key, adorn in next, self.adorns :: { [number]: PartAdornment } do
		adorn.Adornee = parts[key]
		adorn.Color3 = self.props.primaryColor
	end
end

--[=[
	Gets paintable parts from the brush that are valid.
	@return { Instance }
]=]
function PainterMouseControl:queryPaintableParts()
	local brush = self.brushRef.current
	local parts = {}

	if brush then
		for _, part in next, brush:GetTouchingParts() do
			if not part:IsDescendantOf(self.props.root) then
				continue
			end

			if self.props.secondaryOnly and self.props.secondaryColor ~= part.Color then
				continue
			end

			parts[#parts + 1] = part
		end
	end

	return parts
end

return PainterMouseControl
