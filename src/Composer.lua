local Composer = {}
Composer.__index = Composer

function Composer.new(options)
	assert(typeof(options) == "table", "options must be a table")

	assert(options.dataTypes, "options.dataTypes (table) is missing")
	assert(options.components, "options.components (table) is missing")
	assert(options.decompose, "options.decompose (function) is missing")
	assert(options.compose, "options.compose (function) is missing")

	return setmetatable({
		dataTypes = options.dataTypes,
		components = options.components,
		_decomposeFunction = options.decompose,
		_composeFunction = options.compose,
	}, Composer)
end

function Composer:decompose(composedValue)
	local decomposedValues = self._decomposeFunction(composedValue)

	for _, component in ipairs(self.components) do
		assert(decomposedValues[component], ("component %s missing from decomposer output"):format(component))
	end

	return decomposedValues
end

function Composer:compose(decomposedValues)
	return self._composeFunction(decomposedValues)
end

function Composer:accepts(composedValue)
	if table.find(self.dataTypes, typeof(composedValue)) then
		return true
	else
		return false
	end
end

return Composer