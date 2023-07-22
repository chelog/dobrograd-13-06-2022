
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

DLib.bitworker = DLib.bitworker or {}
local table = table
local DLib = DLib
local math = math
local bitworker = DLib.bitworker
local type = type
local ipairs = ipairs

local bit = bit
local lshift = bit.lshift
local rshift = bit.rshift
local band = bit.band
local bor = bit.bor
local bxor = bit.bxor
local bnot = bit.bnot
local pow = math.pow

local function isValidNumber(numIn)
	return type(numIn) == 'number' and numIn == numIn and numIn ~= math.huge and numIn ~= -math.huge
end

local function table_insert(tabIn, val)
	tabIn[#tabIn + 1] = val
end

--[[
	@doc
	@fname DLib.bitworker.IntegerToBinary
	@args number value, number bitsAmount

	@desc
	function is a bit slow (for intensive use)
	this uses forwarding bit for negative values (the one used in networking (not in Sorse Engine networking wtf!)/etc/etc)
	@enddesc

	@returns
	table: bits
]]
function bitworker.IntegerToBinary(numberIn, bitsNum)
	if not isValidNumber(numberIn) then
		local vr = {}

		for i = 1, bitsNum do
			vr[i] = 0
		end

		return vr
	end

	local bits = {}
	local sign = numberIn >= 0 and 0 or 1
	if sign == 1 then
		numberIn = -numberIn
	end

	bits[1] = sign

	for i = 2, bitsNum do
		bits[i] = 0
	end

	for i = 2, bitsNum do
		if numberIn == 0 then break end
		local div = numberIn % 2
		numberIn = (numberIn - div) / 2
		bits[bitsNum - i + 2] = div
	end

	return bits
end

--[[
	@doc
	@fname DLib.bitworker.IntegerToBinary2
	@args number value, number bitsAmount

	@desc
	function is a bit slow (for intensive use)
	this uses overflow for negative values (the one used by Sorse Engine)
	@enddesc

	@returns
	table: bits
]]
function bitworker.IntegerToBinary2(numberIn, bitsNum)
	local max = math.pow(2, bitsNum)

	if numberIn < 0 then
		numberIn = max + numberIn
	elseif numberIn > max then
		numberIn = numberIn - max
	end

	local bits = {}

	for i = 1, bitsNum do
		bits[i] = 0
	end

	for i = 1, bitsNum do
		if numberIn == 0 then break end
		local div = numberIn % 2
		numberIn = (numberIn - div) / 2
		bits[bitsNum - i + 1] = div
	end

	return bits
end

--[[
	@doc
	@fname DLib.bitworker.BinaryToUInteger
	@args table bits

	@desc
	reversal of UIntegerToBinary
	@enddesc

	@returns
	number
]]
function bitworker.BinaryToUInteger(inputTable)
	local amount = #inputTable
	local output = 0

	for i = 1, amount do
		if inputTable[i] == 1 then
			output = output + math.pow(2, amount - i)
		end
	end

	return output
end

--[[
	@doc
	@fname DLib.bitworker.BinaryToInteger
	@args table bits

	@desc
	reversal of IntegerToBinary
	@enddesc

	@returns
	number
]]
function bitworker.BinaryToInteger(inputTable)
	local direction = inputTable[1]
	local amount = #inputTable
	local output = 0

	for i = 2, amount do
		if inputTable[i] == 1 then
			output = output + math.pow(2, amount - i)
		end
	end

	if direction == 0 then
		return output
	else
		return -output
	end
end

--[[
	@doc
	@fname DLib.bitworker.BinaryToInteger2
	@args table bits

	@desc
	reversal of IntegerToBinary2
	@enddesc

	@returns
	number
]]
function bitworker.BinaryToInteger2(bits)
	local bitsNum = #bits
	local max = math.pow(2, bitsNum - 1) - 1
	local output = 0

	for i = 1, bitsNum do
		if bits[i] == 1 then
			output = output + math.pow(2, bitsNum - i)
		end
	end

	if output > max then
		output = output - math.pow(2, bitsNum)
	end

	return output
end

--[[
	@doc
	@fname DLib.bitworker.UIntegerToBinary
	@args number value, number bitsAmount

	@desc
	negative values are handled by overflow
	so please don't pass negative values ok?
	@enddesc

	@returns
	table: bits
]]
function bitworker.UIntegerToBinary(numberIn, bitsNum)
	if not isValidNumber(numberIn) then
		local vr = {}

		for i = 1, bitsNum do
			vr[i] = 0
		end

		return vr
	end

	if numberIn < 0 then
		numberIn = math.pow(2, bitsNum) + numberIn
	end

	local bits = {}

	for i = 1, bitsNum do
		bits[i] = 0
	end

	for i = 1, bitsNum do
		if numberIn == 0 then break end
		local div = numberIn % 2
		numberIn = (numberIn - div) / 2
		bits[bitsNum - i + 1] = div
	end

	return bits
end

--[[
	@doc
	@fname DLib.bitworker.NumberToMantiss
	@args number value, number bitsAllowed

	@returns
	table: bits
	number: exponent
]]
function bitworker.NumberToMantiss(numberIn, bitsAllowed)
	if not isValidNumber(numberIn) then
		local bits = {}

		for i = 1, bitsAllowed do
			bits[i] = 0
		end

		return bits
	end

	local exp = 0
	numberIn = math.abs(numberIn)
	local lastMult = numberIn % 1

	if numberIn >= 2 then
		-- try to normalize number to be less than 2
		-- shift to right
		while numberIn >= 2 do
			numberIn = numberIn / 2
			exp = exp + 1
		end
	end

	-- if our number is less than one, shift to left
	if exp == 0 and numberIn < 1 then
		while numberIn < 1 do
			numberIn = numberIn * 2
			exp = exp - 1
		end
	end

	-- if number is not a zero, it is known amoung all computers that
	-- first bit of mantissa is always 1
	-- so let's assume so
	numberIn = numberIn - 1

	local bits = {}
	for i = 1, bitsAllowed do
		numberIn = numberIn * 2

		if numberIn >= 1 then
			table_insert(bits, 1)
			numberIn = numberIn - 1
		else
			table_insert(bits, 0)
		end
	end

	return bits, exp
end

--[[
	@doc
	@fname DLib.bitworker.NumberToMantissFast
	@args number value, number bitsAllowed

	@returns
	number: fist part of mantiss (32-bit integer)
	number: second part of mantiss (32-bit integer)
	number: exponent
]]
function bitworker.NumberToMantissFast(numberIn, bitsAllowed)
	if not isValidNumber(numberIn) then
		return 0
	end

	local exp, numberOut1, numberOut2 = 0, 0, 0
	numberIn = math.abs(numberIn)
	local lastMult = numberIn % 1

	if numberIn >= 2 then
		-- try to normalize number to be less than 2
		-- shift to right
		while numberIn >= 2 do
			numberIn = numberIn / 2
			exp = exp + 1
		end
	end

	-- if our number is less than one, shift to left
	if exp == 0 and numberIn < 1 then
		while numberIn < 1 do
			numberIn = numberIn * 2
			exp = exp - 1
		end
	end

	-- if number is not a zero, it is known amoung all computers that
	-- first bit of mantissa is always 1
	-- so let's assume so
	numberIn = numberIn - 1
	local dest1, dest2 = math.min(32, bitsAllowed), math.min(32, bitsAllowed - 32)

	for i = 1, dest1 do
		numberIn = numberIn * 2

		if numberIn >= 1 then
			numberOut1 = bor(numberOut1, lshift(1, dest1 - i))
			numberIn = numberIn - 1
		end
	end

	for i = 1, dest2 do
		numberIn = numberIn * 2

		if numberIn >= 1 then
			numberOut2 = bor(numberOut2, lshift(1, dest2 - i))
			numberIn = numberIn - 1
		end
	end

	return numberOut1, numberOut2, exp
end

--[[
	@doc
	@fname DLib.bitworker.MantissToNumber
	@args table bits, number exponent

	@returns
	number
]]
function bitworker.MantissToNumber(bitsIn, exp)
	exp = exp or 0
	local num = 0

	for i = 1, #bitsIn do
		if bitsIn[i] == 1 then
			num = num + pow(2, -i)
		end
	end

	return pow(2, exp) * (1 + num)
end

--[[
	@doc
	@fname DLib.bitworker.MantissToNumberFast
	@args number mantiss1, number mantiss2, number exponent, number bitsIn

	@returns
	number
]]
function bitworker.MantissToNumberFast(numberIn1, numberIn2, exp, bitsIn)
	exp = exp or 0
	numberIn1 = numberIn1 or 0
	numberIn2 = numberIn2 or 0
	local num = 0
	local dest1 = math.min(32, bitsIn) - 1
	local dest2 = math.min(32, bitsIn - 32) - 1

	numberIn1 = lshift(numberIn1, math.max(32 - bitsIn, 0))
	numberIn2 = lshift(numberIn2, 63 - bitsIn)

	for i = 0, dest1 do
		if band(rshift(numberIn1, 31 - i), 1) == 1 then
			num = num + pow(2, -(i + 1))
		end
	end

	for i = 0, dest2 do
		if band(rshift(numberIn2, 31 - i), 1) == 1 then
			num = num + pow(2, -(i + 32))
		end
	end

	return pow(2, exp) * (1 + num)
end

--[[
	@doc
	@fname DLib.bitworker.FloatToBinaryIEEE
	@args number value, number bitsForExponent, number bitsForMantissa

	@returns
	table: bits
]]
-- final range is bitsExponent + bitsMantissa + 2
-- where 2 is two bits which one forwards number sign and one forward exponent sign
function bitworker.FloatToBinaryIEEE(numberIn, bitsExponent, bitsMantissa)
	if not isValidNumber(numberIn) or numberIn == 0 then
		local bits = {}

		for i = 0, bitsExponent + bitsMantissa do
			table_insert(bits, 0)
		end

		return bits
	end

	local bits = {numberIn >= 0 and 0 or 1}
	local mantissa, exp = bitworker.NumberToMantiss(numberIn, bitsMantissa)
	local expBits = bitworker.UIntegerToBinary(exp + math.pow(2, bitsExponent - 1) - 1, bitsExponent)

	table.append(bits, expBits)
	table.append(bits, mantissa)

	return bits
end

--[[
	@doc
	@fname DLib.bitworker.FastFloatToBinaryIEEE
	@args number value

	@returns
	number: integer representation of float
]]
function bitworker.FastFloatToBinaryIEEE(numberIn)
	if not isValidNumber(numberIn) or numberIn == 0 then
		return 0
	end

	local mantissa1, mantissa2, exp = bitworker.NumberToMantissFast(numberIn, 23)
	return bor(lshift(numberIn >= 0 and 0 or 1, 31), lshift(exp + 127, 23), mantissa1)
end

--[[
	@doc
	@fname DLib.bitworker.FastDoubleToBinaryIEEE
	@args number value

	@returns
	number: integer representation of double (first part)
	number: integer representation of double (second part)
]]
function bitworker.FastDoubleToBinaryIEEE(numberIn)
	if not isValidNumber(numberIn) or numberIn == 0 then
		return 0, 0
	end

	local mantissa1, mantissa2, exp = bitworker.NumberToMantissFast(numberIn, 52)
	return bor(lshift(numberIn >= 0 and 0 or 1, 31), lshift(exp + 1023, 20), rshift(mantissa1, 12)), bor(lshift(band(mantissa1, 4095), 20), mantissa2)
end

--[[
	@doc
	@fname DLib.bitworker.BinaryToFloatIEEE
	@args table bits, number bitsExponent, number bitsMantissa

	@returns
	number
]]
function bitworker.BinaryToFloatIEEE(bitsIn, bitsExponent, bitsMantissa)
	local valid = false

	for i = 1, #bitsIn do
		if bitsIn[i] ~= 0 then
			valid = true
			break
		end
	end

	if not valid then return 0 end

	local forward = bitsIn[1]
	local exponent = table.gcopyRange(bitsIn, 2, 2 + bitsExponent - 1)
	local exp = bitworker.BinaryToUInteger(exponent)
	local mantissa = table.gcopyRange(bitsIn, 2 + bitsExponent)

	local value = bitworker.MantissToNumber(mantissa, exp - math.pow(2, bitsExponent - 1) + 1)

	if forward == 0 then
		return value
	end

	return -value
end

--[[
	@doc
	@fname DLib.bitworker.FastBinaryToFloatIEEE
	@args number integerRepresentation

	@returns
	number: float
]]
function bitworker.FastBinaryToFloatIEEE(numberIn)
	if numberIn == 0 then return 0 end
	local point = rshift(numberIn, 31)
	local exp = band(rshift(numberIn, 23), 0xFF) - 127
	local mantissa = band(numberIn, 0x7FFFFF)
	local value = bitworker.MantissToNumberFast(mantissa, 0, exp, 23)

	if point == 0 then return value end
	return -value
end

--[[
	@doc
	@fname DLib.bitworker.FastBinaryToDoubleIEEE
	@args number integerRepresentation1, number integerRepresentation2

	@returns
	number: double
]]
function bitworker.FastBinaryToDoubleIEEE(numberIn1, numberIn2)
	if numberIn == 0 then return 0 end
	local point = rshift(numberIn1, 31)
	local exp = band(rshift(numberIn1, 20), 0x7FF) - 1023
	local mantissa1 = lshift(band(numberIn1, 0xFFFFF), 12)
	local mantissa2 = band(numberIn2, 0xFFFFF)
	mantissa1 = bor(mantissa1, rshift(numberIn2, 20))
	local value = bitworker.MantissToNumberFast(mantissa1, mantissa2, exp, 52)

	if point == 0 then return value end
	return -value
end

--[[
	@doc
	@fname DLib.bitworker.BitsToBytes
	@args table bits

	@desc
	a table consist of `{1, 1, 1, 0, 0, 0, 1, 0}` turns into `{226}` for example
	`{1, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1}` turns into `{226, 225}`
	@descdesc

	@returns
	table: bytes
]]
function bitworker.BitsToBytes(bitsIn)
	assert(#bitsIn % 8 == 0, 'Not full bytes')
	local output = {}

	for i = 1, #bitsIn / 8 do
		output[i] =
			bitsIn[(i - 1) * 8 + 8] +
			bitsIn[(i - 1) * 8 + 7] * 2 +
			bitsIn[(i - 1) * 8 + 6] * 4 +
			bitsIn[(i - 1) * 8 + 5] * 8 +
			bitsIn[(i - 1) * 8 + 4] * 16 +
			bitsIn[(i - 1) * 8 + 3] * 32 +
			bitsIn[(i - 1) * 8 + 2] * 64 +
			bitsIn[(i - 1) * 8 + 1] * 128
	end

	return output
end
