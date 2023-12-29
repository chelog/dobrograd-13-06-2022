--[[
	Namespace: octolib

	Group: math
		Mathematical helper functions
]]
octolib.math = octolib.math or {}

--[[
	Function: clampCircular
		"Loops" number between min and max values

	Arguments:
		<float> val - Value to clamp
		<float> min - Lower limit of loop (inclusive)
		<float> max - Upper limit of loop (exclusive)

	Returns:
		<float> - Looped number

	Example:
		--- Lua
		local current = 0
		local function printNextNumber()
			current = octolib.math.loop(current + 1, 1, 4)
			print(current)
		end

		for i = 1, 5 do printNextNumber() end
		---
		> prints 1, 2, 3, 1, 2
]]
function octolib.math.loop(val, min, max)
	local res = (val - min) % (max - min)
	return res + min
end

--[[
	Function: diffCircular
		Returns closest loop difference between two numbers.
		Commonly used scenario is angles: they exist in a "loop"
		between 0 and 360 degrees

	Arguments:
		<float> val1 - Value to go from
		<float> val2 - Value to go to
		<float> min - Lower limit of loop (inclusive)
		<float> max - Upper limit of loop (inclusive)

	Returns:
		<float> - Delta of closest loop movement

	Example:
		--- Lua
		print(octolib.math.loopedDiff(10, 25, 0, 360))
		print(octolib.math.loopedDiff(10, 365, 0, 360)) -- 365 deg is 1 full circle + 5 deg
		---
		> 15
		> -5
]]
function octolib.math.loopedDiff(value1, value2, min, max)
	local interval = max - min
	local half = interval / 2
	local difference = value2 % interval - value1 % interval
	if difference > half then
		difference = difference - interval
	elseif difference <= -half then
		difference = difference + interval
	end

	return difference
end

--[[
	Function: distCircular
		Basically just math.abs()'ed version of <octolib.math.loopedDiff>
]]
function octolib.math.loopedDist(value1, value2, min, max)
	return math.abs(octolib.math.loopedDiff(value1, value2, min, max))
end

--[[
	Function: angDelta
		Convenience alias of <octolib.math.loopedDiff> with
		0 and 360 as min and max limits respectively
]]
function octolib.math.angleDiff(angle1, angle2)
	return octolib.math.loopedDiff(angle1, angle2, 0, 360)
end

--[[
	Function: sign
		Returns 1 or -1 depending on number's sign

	Arguments:
		<float> val - Input number

	Returns:
		<int> - Input's sign
]]
function octolib.math.sign(value)
	return value > 0 and 1 or value < 0 and -1 or 0
end

function octolib.math.lerp(src, tgt, fraction, min, max)
	if src == tgt then return src end
	local diff = tgt - src
	local sign = octolib.math.sign(diff)
	local distAbs = math.abs(diff)
	local dist = distAbs * fraction
	if min then dist = math.max(dist, min) end
	if max then dist = math.min(dist, max) end
	dist = math.min(distAbs, dist)

	return src + dist * sign
end

function octolib.math.lerpUnclamped(src, tgt, fraction, min, max)
	if src == tgt then return src end
	local diff = tgt - src
	local sign = octolib.math.sign(diff)
	local dist = math.abs(diff) * fraction
	if min then dist = math.max(dist, min) end
	if max then dist = math.min(dist, max) end

	return src + dist * sign
end

function octolib.math.lerpAngle(src, tgt, fraction, min, max)
	if src == tgt then return src end
	local ch = octolib.math.angleDiff(src, tgt)
	local sign = octolib.math.sign(ch)

	local d = math.abs(ch) * fraction
	if min then d = math.max(d, min) end
	if max then d = math.min(d, max) end

	return src + d * sign
end

function octolib.math.lerpVector(src, tgt, fraction, min, max)
	if src == tgt then return src end
	local diff = tgt - src
	local len = diff:Length()
	local dist = len * fraction
	if min then dist = math.max(dist, min) end
	if max then dist = math.min(dist, max) end
	dist = math.min(len, dist)

	return src + diff:GetNormalized() * dist
end

--[[
	Function: inRange
		Returns whether number is in range

	Arguments:
		<float> val - Input value
		<float> min - Lower limit
		<float> max - Upper limit
		<bool> exclusive = false - Pass true to exclude limits from interval

	Returns:
		<bool> - Whether input is in range
]]
function octolib.math.inRange(val, min, max, exclusive)
	if exclusive then
		return val > min and val < max
	else
		return val >= min and val <= max
	end
end

--[[
	Function: remap
		Remaps value from old to new range

	Arguments:
		<float> val - Input value
		<float> oldMin - Lower bound of old range
		<float> oldMax - Upper bound of old range
		<float> newMin - Lower bound of new range
		<float> newMax - Upper bound of new range

	Returns:
		<float> - Remapped value

	Example:
		--- Lua
		print(octolib.math.remap(9.81, 9, 10, 1, 100))
		---
		> 81
]]
function octolib.math.remap(val, oldMin, oldMax, newMin, newMax)
	local fraction = (val - oldMin) / (oldMax - oldMin)
	return newMin + fraction * (newMax - newMin)
end
