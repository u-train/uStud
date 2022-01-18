local Lexer = require(script.Lexer)
local EscapeFullName = require(script.EscapeFullName)

local SelectInstance = function(Root, Selection)
	local Tokens = Lexer(Selection)
	local Child = Root

	local Index = 1
	while #Tokens >= Index do
		local Identifier = Tokens[Index]
		local Seperator = Tokens[Index + 1]

		assert(Identifier.Type == "Identifier", "Expected Identifier, got " .. Identifier.Type .. " instead.")

		Child = assert(Child:FindFirstChild(Identifier.Value), ("Could not find child '%s'."):format(Child.Name))
		if Seperator == nil then
			return Child
		end

		assert(Seperator.Type == "Seperator", "Expected Identifier, got " .. Identifier.Type .. " instead.")

		Index += 2
	end

	return Child
end

return {
	Select = SelectInstance,
	EscapeFullName = EscapeFullName,
}
