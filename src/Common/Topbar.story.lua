local Roact = require(script.Parent.Parent.Packages.Roact)
local Topbar = require(script.Parent.Topbar)

return function(Parent)
	local Handle = Roact.mount(
		Roact.createFragment({
			WithReturnBack = Roact.createElement(Topbar, {
				Title = "Check output.",
				Size = UDim2.new(0, 200, 0, 25),
				Position = UDim2.new(0, 0, 0, 0),
				ShowReturnBack = true,
				OnReturn = function()
					print("Returned!")
				end,
			}),
			WithoutReturnBack = Roact.createElement(Topbar, {
				Title = "Empty",
				Size = UDim2.new(0, 200, 0, 25),
				Position = UDim2.new(0, 0, 0, 25),
				ShowReturnBack = false,
			}),
		}),
		Parent
	)

	return function()
		Roact.unmount(Handle)
	end
end
