return function(Parent)
	local Message = Instance.new("TextLabel")
	Message.Size = UDim2.new(1, 0, 1, 0)
	Message.Text = "This component's story hasn't been implemented yet."

	Message.Parent = Parent

	return function()
		Message:Destroy()
	end
end
