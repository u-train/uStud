--[=[
	@class FolderContextComponent
	Provides a folder which is a container to put brushes for example for the
	tools.
]=]

local Roact = require(script.Parent.Parent.Packages.Roact) :: Roact
local FolderContext = Roact.createContext()

local FolderContextComponent = Roact.Component:extend("FolderContextComponent")

--[=[

]=]
function FolderContextComponent:init()
	self.Folder = Instance.new("Folder")
	self.Folder.Name = "uStudContainer"
	self.Folder.Archivable = false
	self.Folder.Parent = workspace
end

--[=[

]=]
function FolderContextComponent:willUnmount()
	self.Folder:Destroy()
end

--[=[

]=]
function FolderContextComponent:render()
	return Roact.createElement(FolderContext.Provider, {
		value = self.Folder,
	}, self.props[Roact.Children])
end

--[=[
	@within FolderContextComponent
	@function WithFolder
	@param render (Folder) -> RoactTree
]=]
FolderContextComponent.WithFolder = function(render)
	return Roact.createElement(FolderContext.Consumer, {
		render = render,
	})
end

--[=[
	@within FolderContextComponent
	@prop FolderContext Context
]=]
FolderContextComponent.Context = FolderContext

return FolderContextComponent
