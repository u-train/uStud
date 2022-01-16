local Roact = require(script.Parent.Parent.Libraries.Roact)
local UserInputService = game:GetService("UserInputService")

local GetRaycastResultFromMouse = require(script.Parent.Parent.Common.GetRaycastResultFromMouse)

local function CreateAdorn(Parent)
	local Adorn = Instance.new("SelectionBox")
	Adorn.Parent = Parent
	Adorn.LineThickness = 0.05
	return Adorn
end

local MouseController = Roact.Component:extend("MouseController")

function MouseController:init()
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

		if self.props.EditingIn.Parent == nil then
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
	end)
end

function MouseController:willUnmount()
	self.IsPainting = false
	self.InputChanged:Disconnect()
	self.InputBegan:Disconnect()
	self.InputEnded:Disconnect()

	self.Adorns = nil
	self.AdornContainer:Destroy()
end

function MouseController:render()
	return Roact.createElement(Roact.Portal, {
		target = workspace,
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
end

function MouseController:UpdateAndPaintBrush(Input)
	local RaycastResults = GetRaycastResultFromMouse(Input.Position, self.props.EditingIn)

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

function MouseController:UpdateAdorns()
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

function MouseController:QueryPaintableParts()
	local Brush = self.BrushRef.current
	local Parts = {}

	if Brush then
		for _, Part in next, Brush:GetTouchingParts() do
			if not Part:IsDescendantOf(self.props.EditingIn) then
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

return MouseController
