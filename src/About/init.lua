local Packages = script.Parent.Packages
local Roact = require(Packages.Roact)
local StudioComponents = require(Packages.StudioComponents)
local RoactRouter = require(Packages.RoactRouter)
local Common = script.Parent.Common
local Topbar = require(Common.Topbar)

--[=[
	@class About
	About page that has contributors listed and link to the source code.

	It may be worth coupling the Topbar with RoactRouter.
]=]

local function About(_)
	return Roact.createFragment({
		Topbar = RoactRouter.withRouter(function(routerInfo)
			return Roact.createElement(Topbar, {
				title = "About",
				showReturnBack = true,
				size = UDim2.new(1, 0, 0, 25),
				onReturn = function()
					routerInfo.history:goBack()
				end,
			})
		end),
		Container = Roact.createElement(StudioComponents.ScrollFrame, {
			Size = UDim2.new(1, 0, 1, -25),
			Position = UDim2.new(0, 0, 0, 25),
		}, {
			Statement = Roact.createElement(StudioComponents.Label, {
				Size = UDim2.fromScale(1, 1),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Text = "Created by utrain\n"
					.. "Source code is available at github.com/u-train/uStud\n"
					.. "Thanks for those who helped test the tool:\n"
					.. "Eorethe and ticobear"
			})
		})
	})
end

return About
