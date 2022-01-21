return function(Parent)
	local message = Instance.new("TextLabel")
	message.Size = UDim2.new(1, 0, 1, 0)
	message.Text = "This component uses RoactRouter, which means I do not want"
		.. " bother implementing the story for it."

	message.Parent = Parent

	return function()
		message:Destroy()
	end
end
