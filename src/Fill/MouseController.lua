local Packages = script.Parent.Parent.Packages
local Roact = require(Packages.Roact)
local StudioComponents = require(Packages.StudioComponents)

local Common = script.Parent.Parent.Common

local MouseController = Roact.Component:extend("FillMouseController")

function MouseController:init()

end

function MouseController:render()

end

return MouseController
