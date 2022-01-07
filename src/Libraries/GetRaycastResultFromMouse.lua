local GetRaycastResultFromMouse = function(MousePosition, Container)
	local Camera = workspace.CurrentCamera

	local NewUnitRay = Camera:ViewportPointToRay(MousePosition.X, MousePosition.Y, 0)

	local TargetRaycastParam = RaycastParams.new()
	TargetRaycastParam.FilterType = Enum.RaycastFilterType.Whitelist
	TargetRaycastParam.FilterDescendantsInstances = { Container }

	return workspace:Raycast(NewUnitRay.Origin, NewUnitRay.Direction * 2048, TargetRaycastParam)
end

return GetRaycastResultFromMouse