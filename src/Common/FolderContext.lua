local Roact = require(script.Parent.Parent.Packages.roact) :: Roact
local FolderContext = Roact.createContext()

local FolderContextComponent = Roact.Component:extend("FolderContextComponent")

function FolderContextComponent:init()
	self:setState({
		Value = self.props.Value
	})
end

function FolderContextComponent:render()
	return Roact.createElement(FolderContext.Provider, {
		value = self.state.Value
	}, self.props[Roact.Children])
end

FolderContextComponent.WithFolder = function(render)
	return Roact.createElement(FolderContext.Consumer, {
		render = render,
	})
end

FolderContextComponent.Context = FolderContext

return FolderContextComponent