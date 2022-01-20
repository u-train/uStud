--[=[
	@class FolderController
	Provides a folder which is a container to put brushes for example for the
	tools.
]=]

local Roact = require(script.Parent.Parent.Packages.Roact) :: Roact
local FolderContext = require(script.Parent.FolderContext)

local FolderController = Roact.Component:extend("FolderController")

--[=[

]=]
function FolderController:init()
	self.Folder = Instance.new("Folder")
	self.Folder.Name = "uStudContainer"
	self.Folder.Archivable = false
	self.Folder.Parent = workspace
end

--[=[

]=]
function FolderController:willUnmount()
	self.Folder:Destroy()
end

--[=[

]=]
function FolderController:render()
	return Roact.createElement(FolderContext.Provider, {
		value = self.Folder,
	}, self.props[Roact.Children])
end

--[=[
	@within FolderController
	@function WithFolder
	@param render (Folder) -> RoactTree
]=]
FolderController.WithFolder = function(render)
	return Roact.createElement(FolderContext.Consumer, {
		render = render,
	})
end

--[=[
	@within FolderController
	@prop FolderContext Context
]=]
FolderController.Context = FolderContext

return FolderController
