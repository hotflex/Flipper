local composers = require(script.composers)

local Flipper = {
	isMotor = require(script.isMotor),

	SingleMotor = require(script.SingleMotor),
	GroupMotor = require(script.GroupMotor),
	TypedMotor = require(script.TypedMotor),

	Instant = require(script.Instant),
	Linear = require(script.Linear),
	Spring = require(script.Spring),
	
	TypedGoal = require(script.TypedGoal),

	XY = composers.XY,
}

return Flipper