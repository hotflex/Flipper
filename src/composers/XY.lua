local Composer = require(script.Parent.Parent.Composer)

local XY = Composer.new({
	dataTypes = { "Vector2" },
	components = { "X", "Y" },
	decompose = function(vector2)
		return {
			X = vector2.X,
			Y = vector2.Y,
		}
	end,
	compose = function(components)
		return Vector2.new(components.X, components.Y)
	end,
})

return XY