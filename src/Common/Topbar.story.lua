local Roact = require(script.Parent.Parent.Packages.Roact)
local Topbar = require(script.Parent.Topbar)

return function(parent)
	local Handle = Roact.mount(
		Roact.createFragment({
			WithReturnBack = Roact.createElement(Topbar, {
				title = "Check output.",
				size = UDim2.new(0, 200, 0, 25),
				position = UDim2.new(0, 0, 0, 0),
				showReturnBack = true,
				onReturn = function()
					print("Returned!")
				end,
			}),
			WithoutReturnBack = Roact.createElement(Topbar, {
				title = "Empty",
				size = UDim2.new(0, 200, 0, 25),
				position = UDim2.new(0, 0, 0, 25),
				showReturnBack = false,
			}),
		}),
		parent
	)

	return function()
		Roact.unmount(Handle)
	end
end
