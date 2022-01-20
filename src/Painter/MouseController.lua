local Roact = require(script.Parent.Parent.Packages.Roact)
local UserInputService = game:GetService("UserInputService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

local Common = script.Parent.Parent.Common
local GetRaycastResultFromMouse = require(Common.GetRaycastResultFromMouse)
local FolderContext = require(Common.FolderContext)

local function CreateAdorn(Parent)
	local Adorn = Instance.new("SelectionBox")
	Adorn.Parent = Parent
	Adorn.LineThickness = 0.05
	return Adorn
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
	self.BrushRef = Roact.createRef()
	self.BrushPositionBinding, self.UpdateBrushPosition = Roact.createBinding(Vector3.new())
	self.Adorns = {}
	self.AdornContainer = Instance.new("Folder")
	self.AdornContainer.Name = "AdornContainer"
	self.AdornContainer.Parent = workspace

	self.IsPainting = false

	self.InputBegan = UserInputService.InputBegan:Connect(function(Input, Processed)
		if Enum.UserInputType.MouseButton1 ~= Input.UserInputType then
			return
		end

		if Processed then
			return
		end

		if self.props.Root.Parent == nil then
			return
		end

		self.IsPainting = true
		self:UpdateAndPaintBrush(Input)
	end)

	self.InputChanged = UserInputService.InputChanged:Connect(function(Input, Processed)
		if Input.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		if Processed then
			return
		end

		self:UpdateAndPaintBrush(Input)
	end)

	self.InputEnded = UserInputService.InputEnded:Connect(function(Input, _)
		if Enum.UserInputType.MouseButton1 ~= Input.UserInputType then
			return
		end

		self.IsPainting = false
		ChangeHistoryService:SetWaypoint("uStud.Paint")
	end)
end

--[=[
	Cleanup connections and adorns. Along with that, set state accordingly.
]=]
function PainterMouseControl:willUnmount()
	self.IsPainting = false
	self.InputChanged:Disconnect()
	self.InputBegan:Disconnect()
	self.InputEnded:Disconnect()

	self.Adorns = nil
	self.AdornContainer:Destroy()
end

--[=[
	Render.
	@return RoactTree
]=]
function PainterMouseControl:render()
	return FolderContext.WithFolder(function(Folder)
		return Roact.createElement(Roact.Portal, {
			target = Folder,
		}, {
			Brush = Roact.createElement("Part", {
				[Roact.Ref] = self.BrushRef,
				Anchored = true,
				CanCollide = true,
				Transparency = 0.8,
				Material = Enum.Material.Neon,

				Shape = Enum.PartType.Cylinder,
				Rotation = Vector3.new(0, 0, 90),
				Position = self.BrushPositionBinding,
				Size = Vector3.new(0.4, self.props.BrushDiameter, self.props.BrushDiameter),
				Color = self.props.PrimaryColor,
			}),
		})
	end)
end

--[=[
	Uses the InputObject to update the paint brush's position. Additionally, if
	the user is holding the mouse down, will paint valid studs.
	@param Input InputObject
]=]
function PainterMouseControl:UpdateAndPaintBrush(Input)
	local RaycastResults = GetRaycastResultFromMouse(Input.Position, self.props.Root)

	if RaycastResults == nil then
		return
	end

	if RaycastResults.Instance ~= self.BrushRef.current then
		self.UpdateBrushPosition(RaycastResults.Position)
	end

	self:UpdateAdorns()
	if self.IsPainting then
		for _, Part in next, self:QueryPaintableParts() do
			Part.Color = self.props.PrimaryColor
		end
	end
end

--[=[
	Update the adorns to what the brush is actually touching.
]=]
function PainterMouseControl:UpdateAdorns()
	local Parts = self:QueryPaintableParts()

	local Difference = #Parts - #self.Adorns

	if Difference < 0 then
		for i = 1, Difference do
			table.remove(self.Adorns, i):Destroy()
		end
	elseif Difference > 0 then
		for _ = 1, math.abs(Difference) do
			table.insert(self.Adorns, CreateAdorn(self.AdornContainer))
		end
	end

	for Key, Adorn in next, self.Adorns :: { [number]: PartAdornment } do
		Adorn.Adornee = Parts[Key]
		Adorn.Color3 = self.props.PrimaryColor
	end
end

--[=[
	Gets paintable parts from the brush that are valid.
	@return { Instance }
]=]
function PainterMouseControl:QueryPaintableParts()
	local Brush = self.BrushRef.current
	local Parts = {}

	if Brush then
		for _, Part in next, Brush:GetTouchingParts() do
			if not Part:IsDescendantOf(self.props.Root) then
				continue
			end

			if self.props.SecondaryOnly and self.props.SecondaryColor ~= Part.Color then
				continue
			end

			Parts[#Parts + 1] = Part
		end
	end

	return Parts
end

return PainterMouseControl
