return function(Parent)
	local Message = Instance.new("TextLabel")
	Message.Size = UDim2.new(1, 0, 1, 0)
	Message.Text = "This component uses RoactRouter, which means I do not want"
		.. " bother implementing the story for it."

	Message.Parent = Parent

	return function()
		Message:Destroy()
	end
end