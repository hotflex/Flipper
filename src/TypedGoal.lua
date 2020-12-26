local TypedGoal = {}
TypedGoal.__index = TypedGoal

function TypedGoal.new(goal, targetValue, ...)
	-- TODO: Maybe convert all arguments instead of just the first one? I think
	-- this might be a more stable solution, but it'd require recursive decomposition
	-- which seems rather hacky IMO
	
	return setmetatable({
		_goal = goal,
		_targetValue = targetValue,
		_arguments = { ... },
	}, TypedGoal)
end

function TypedGoal:getComponentGoals(composer)
	local components = composer:decompose(self._targetValue)

	local componentGoals = {}
	for component, value in pairs(components) do
		componentGoals[component] = self._goal.new(value, unpack(self._arguments))
	end

	return componentGoals
end

return TypedGoal