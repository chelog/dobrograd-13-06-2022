
-- Copyright (C) 2017-2020 DBotThePony

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do so,
-- subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all copies
-- or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
-- DEALINGS IN THE SOFTWARE.


local net = net
local table = table
local Entity = Entity
local type = type
local error = error

net.pool = util.AddNetworkString

--[[
	@doc
	@fname net.WritePlayer
	@args Player ply
]]
function net.WritePlayer(ply)
	local i = ply:EntIndex()
	net.WriteUInt(i, 8)
	return i
end

--[[
	@doc
	@fname net.ReadPlayer
	@returns
	Player
]]
function net.ReadPlayer()
	return Entity(net.ReadUInt(8))
end

--[[
	@doc
	@fname net.WriteTypedArray
	@args table input, function callback

	@desc
	callback should write value provided in first argument
	example usage: `net.WriteTypedArray(arr, net.WriteType)`
	@enddesc
]]
function net.WriteTypedArray(input, callFunc)
	net.WriteUInt(#input, 16)

	for i, value in ipairs(input) do
		callFunc(value)
	end
end

--[[
	@doc
	@fname net.ReadTypedArray
	@args function callback

	@desc
	callback should read next value
	@enddesc

	@returns
	table
]]
function net.ReadTypedArray(callFunc)
	return table.construct({}, callFunc, net.ReadUInt(16))
end

--[[
	@doc
	@fname net.WriteArray
	@args table arrayIn
]]
function net.WriteArray(input)
	net.WriteTypedArray(input, net.WriteType)
end

--[[
	@doc
	@fname net.ReadArray
	@returns
	table
]]
function net.ReadArray()
	return table.construct({}, net.ReadType, net.ReadUInt(16))
end

--[[
	@doc
	@fname net.WriteStringArray
	@args table arrayOfStrings
]]
function net.WriteStringArray(input)
	net.WriteTypedArray(input, net.WriteString)
end

--[[
	@doc
	@fname net.ReadStringArray
	@returns
	table: array of strings
]]
function net.ReadStringArray()
	return table.construct({}, net.ReadString, net.ReadUInt(16))
end

--[[
	@doc
	@fname net.WriteEntityArray
	@args Entity input
]]
function net.WriteEntityArray(input)
	net.WriteTypedArray(input, net.WriteEntity)
end

--[[
	@doc
	@fname net.ReadEntityArray
	@returns
	table: array of entities
]]
function net.ReadEntityArray()
	return table.construct({}, net.ReadEntity, net.ReadUInt(16))
end

--[[
	@doc
	@fname net.WritePlayerArray
	@args table arrayOfPlayers
]]
function net.WritePlayerArray(input)
	net.WriteTypedArray(input, net.WritePlayer)
end

--[[
	@doc
	@fname net.ReadPlayerArray
	@returns
	table: array of players
]]
function net.ReadPlayerArray()
	return table.construct({}, net.ReadPlayer, net.ReadUInt(16))
end

--[[
	@doc
	@fname net.WriteFloatArray
	@args table arrayOfFloats
]]

--[[
	@doc
	@fname net.ReadFloatArray
	@returns
	table: array of floats
]]
function net.WriteFloatArray(input)
	net.WriteTypedArray(input, net.WriteFloat)
end

function net.ReadFloatArray()
	return table.construct({}, net.ReadFloat, net.ReadUInt(16))
end

--[[
	@doc
	@fname net.WriteDoubleArray
	@args table arrayOfDoubles
]]

--[[
	@doc
	@fname net.ReadDoubleArray
	@returns
	table: array of doubles
]]
function net.WriteDoubleArray(input)
	net.WriteTypedArray(input, net.WriteDouble)
end

function net.ReadDoubleArray()
	return table.construct({}, net.ReadDouble, net.ReadUInt(16))
end

--[[
	@doc
	@fname net.GReadUInt
	@args number bits

	@returns
	function: alias of `net.ReadUInt(bits)`
]]

--[[
	@doc
	@fname net.GWriteUInt
	@args number bits

	@returns
	function: alias of `net.WriteUInt(..., bits)`
]]
function net.GReadUInt(val)
	return function()
		return net.ReadUInt(val)
	end
end

function net.GWriteUInt(val)
	return function(val2)
		return net.WriteUInt(val2, val)
	end
end

--[[
	@docpreprocess

	const bits = [8, 16, 32, 64]

	const reply = []

	for (const bit of bits) {
		let output = []

		output.push(`@fname net.ReadUInt${bit}`)
		output.push(`@desc`)
		output.push(`typical single-argument alias of it's corresponding call`)
		output.push(`@enddesc`)
		output.push(`@returns`)
		output.push(`number`)

		reply.push(output)

		output = []

		output.push(`@fname net.ReadInt${bit}`)
		output.push(`@desc`)
		output.push(`typical single-argument alias of it's corresponding call`)
		output.push(`@enddesc`)
		output.push(`@returns`)
		output.push(`number`)

		reply.push(output)
	}

	return reply
]]
net.ReadUInt8 = net.GReadUInt(8)
net.ReadUInt16 = net.GReadUInt(16)
net.ReadUInt32 = net.GReadUInt(32)

net.WriteUInt8 = net.GWriteUInt(8)
net.WriteUInt16 = net.GWriteUInt(16)
net.WriteUInt32 = net.GWriteUInt(32)

--[[
	@doc
	@fname net.GReadInt
	@args number bits

	@returns
	function: alias of `net.ReadInt(bits)`
]]

--[[
	@doc
	@fname net.GWriteInt
	@args number bits

	@returns
	function: alias of `net.WriteInt(..., bits)`
]]
function net.GReadInt(val)
	return function()
		return net.ReadInt(val)
	end
end

function net.GWriteInt(val)
	return function(val2)
		return net.WriteInt(val2, val)
	end
end

net.ReadInt8 = net.GReadInt(8)
net.ReadInt16 = net.GReadInt(16)
net.ReadInt32 = net.GReadInt(32)

net.WriteInt8 = net.GWriteInt(8)
net.WriteInt16 = net.GWriteInt(16)
net.WriteInt32 = net.GWriteInt(32)

local maxint = 0x100000000

--[[
	@doc
	@fname net.WriteBigUInt
	@args number value

	@desc
	due to percision errors, not actually accurate
	this function attempts to write a unsigned 64 bits integer to the stream
	@enddesc
]]

--[[
	@doc
	@fname net.WriteBigInt
	@args number value

	@desc
	due to percision errors, not actually accurate
	this function attempts to write a 64 bits integer to the stream
	@enddesc
]]

--[[
	@doc
	@fname net.ReadBigUInt

	@returns
	number: 64 bit unsigned integer
]]

--[[
	@doc
	@fname net.ReadBigInt

	@returns
	number: 64 bit integer
]]
function net.WriteBigUInt(val)
	local first = val % maxint
	local second = (val - first) / maxint
	net.WriteUInt32(first)
	net.WriteUInt32(second)
end

function net.ReadBigUInt(val)
	local first = net.ReadUInt32()
	local second = net.ReadUInt32()

	return first + second * maxint
end

function net.WriteBigInt(val)
	net.WriteBool(val >= 0)
	net.WriteBigUInt(val:abs())
end

function net.ReadBigInt()
	local sign = net.ReadBool()
	local value = net.ReadBigUInt()

	if sign then
		return value
	end

	return -value
end

net.WriteUInt64 = net.WriteBigUInt
net.WriteInt64 = net.WriteBigInt

net.ReadUInt64 = net.ReadBigUInt
net.ReadInt64 = net.ReadBigInt

--[[
	@doc
	@fname net.ChooseOptimalBits
	@args number maximumPossibilities

	@returns
	number: minimal amount of bits required for sending all possible values
]]
function net.ChooseOptimalBits(amount)
	local bits = 1

	while 2 ^ bits <= amount do
		bits = bits + 1
	end

	return math.max(bits, 4)
end

--[[
	@doc
	@fname net.WriteVectorDouble
	@args Vector value

	@desc
	uses `net.WriteDouble` instead of `net.WriteFloat`
	@enddesc
]]
function net.WriteVectorDouble(vecIn)
	if type(vecIn) ~= 'Vector' then
		error('WriteVectorDouble - input is not a vector!')
	end

	net.WriteDouble(vecIn.x)
	net.WriteDouble(vecIn.y)
	net.WriteDouble(vecIn.z)

	return self
end

--[[
	@doc
	@fname net.WriteAngleDouble
	@args Angle value

	@desc
	uses `net.WriteDouble` instead of `net.WriteFloat`
	@enddesc
]]
function net.WriteAngleDouble(angleIn)
	if type(angleIn) ~= 'Angle' then
		error('WriteAngleDouble - input is not an angle!')
	end

	net.WriteDouble(angleIn.p)
	net.WriteDouble(angleIn.y)
	net.WriteDouble(angleIn.r)

	return self
end

--[[
	@doc
	@fname net.ReadVectorDouble

	@returns
	Vector
]]
function net.ReadVectorDouble()
	return Vector(net.ReadDouble(), net.ReadDouble(), net.ReadDouble())
end

--[[
	@doc
	@fname net.ReadAngleDouble

	@returns
	Angle
]]
function net.ReadAngleDouble()
	return Angle(net.ReadDouble(), net.ReadDouble(), net.ReadDouble())
end

local Color = Color

function net.WriteColor(colIn)
	if not IsColor(colIn) then
		error('Attempt to write a color which is not a color! ' .. type(colIn))
	end

	net.WriteUInt(colIn.r, 8)
	net.WriteUInt(colIn.g, 8)
	net.WriteUInt(colIn.b, 8)
	net.WriteUInt(colIn.a, 8)
end

function net.ReadColor()
	return Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8))
end
