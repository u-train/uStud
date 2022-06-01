return function(...)
	local destination = {}

	for _, source in next, {...} do
		for key, value in next, source do
			destination[key] = value
		end
	end

	return destination
end
