return function(Value, Interval)
	local AbsoluteValue = math.abs(Value)
	local Low = AbsoluteValue - math.fmod(AbsoluteValue, Interval)
	local High = Low + Interval

	local RoundedAbsoluteValue = Low
	if High - AbsoluteValue <= AbsoluteValue - Low then
		RoundedAbsoluteValue = High
	end

	return math.sign(Value) * RoundedAbsoluteValue
end