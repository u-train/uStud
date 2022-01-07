local Lexer = function(Input)
	local Tokens = {}

	local Index = 1

	while #Input > Index do
		local Character = Input:sub(Index, Index)

		if Character:match("%w") or Character:match("/") then
			local Identifier = {}

			while true do
				local MatchedCharacter = Input:sub(Index, Index)

				if MatchedCharacter == "" then
					break
				elseif MatchedCharacter:match("%.") then
					break
				elseif MatchedCharacter:match("%w") then
					table.insert(Identifier, MatchedCharacter)
					Index += 1
				elseif MatchedCharacter:match("/") then
					local Peek = Input:sub(Index + 1, Index + 1)
					if Peek:match("%.") then
						table.insert(Identifier, ".")
						Index += 2
					elseif Peek:match("/") then
						table.insert(Identifier, "/")
						Index += 2
					else
						table.insert(Identifier, "/")
						Index += 1
					end
				else
					error(
						"Unexpected character found while parsing an identifier '"
							.. string.format("%q", MatchedCharacter)
							.. "'."
					)
				end
			end

			table.insert(Tokens, {
				Type = "Identifier",
				Value = table.concat(Identifier),
			})
		elseif Character:match("%.") then
			table.insert(Tokens, {
				Type = "Seperator",
			})

			Index += 1
		end
	end

	return Tokens
end


return Lexer