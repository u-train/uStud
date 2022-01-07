local EscapeFullName = function(TargetInstance)
	local Tree = {}
	local FullName = {}

	repeat
		table.insert(Tree, TargetInstance)
		TargetInstance = TargetInstance.Parent
	until TargetInstance.Parent == nil

	for i = #Tree, 1, -1 do
		table.insert(FullName, (Tree[i].Name:gsub("/", "//"):gsub("%.", "/.")))
	end

	return table.concat(FullName, ".")
end

return EscapeFullName