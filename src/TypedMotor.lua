local BaseMotor = require(script.Parent.BaseMotor)
local GroupMotor = require(script.Parent.GroupMotor)

-- For type checking only
local TypedGoal = require(script.Parent.TypedGoal)
local Composer = require(script.Parent.Composer)

local TypedMotor = setmetatable({}, BaseMotor)
TypedMotor.__index = TypedMotor

function TypedMotor.new(initialValue, composer, useImplicitConnections)
	assert(getmetatable(composer) == Composer, "Invalid argument #2: composer must be of type Flipper.Composer")
	assert(composer:accepts(initialValue), "Invalid argument #1: initialValue not accepted by composer")

	local self = setmetatable(BaseMotor.new(), TypedMotor)

	self._composer = composer

	if useImplicitConnections ~= nil then
		self._useImplicitConnections = useImplicitConnections
	else
		self._useImplicitConnections = true
	end

	local initialComponents = composer:decompose(initialValue)
	self._groupMotor = GroupMotor.new(initialComponents, false)

	return self
end

function TypedMotor:step(deltaTime)
	local complete = self._groupMotor:step(deltaTime)

	self.onStep:fire(self:getValue())

	if complete then
		if self._useImplicitConnections then
			self:stop()
		end

		self._complete = true
		self.onComplete:fire()
	end
end

function TypedMotor:getValue()
	local components = self._groupMotor:getValue()
	local value = self._composer:compose(components)
	return value
end

function TypedMotor:setGoal(typedGoal)
	assert(getmetatable(typedGoal) == TypedGoal, "Invalid argument #1: typedGoal must be of type Flipper.TypedGoal")

	local componentGoals = typedGoal:getComponentGoals(self._composer)
	self._groupMotor:setGoal(componentGoals)

	if self._useImplicitConnections then
		self:start()
	end
end

function TypedMotor:__tostring()
	return "Motor(Typed)"
end

return TypedMotor