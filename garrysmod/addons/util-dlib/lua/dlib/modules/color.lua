
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


local string = string
local setmetatable = setmetatable
local math = math
local type = type
local tonumber = tonumber
local Vector = Vector
local ColorToHSV = ColorToHSV
local Lerp = Lerp
local util = util
local assert = assert
local srnd = util.SharedRandom

local colorMeta = FindMetaTable('Color') or {}
colorMeta.__index = colorMeta
colorMeta.MetaName = 'Color'
debug.getregistry().Color = colorMeta


--[[
	@doc
	@fname Color
	@replaces
	@args any r = 255, number g = 255, number b = 255, number a = 255

	@desc
	First argument can be either table with `r, g, b, a` properties defined, or be a number
	if it is number, then if it is bigger than 255, it is considered to be a big endian color number.
	@enddesc

	@returns
	Color: newly created object
]]
local function Color(r, g, b, a)
	if IsColor(r) then
		g = r.g
		b = r.b
		a = r.a
		r = r.r
	elseif type(r) == 'number' and not g and not b and not a then
		return ColorBE(r)
	elseif type(r) == 'nil' and type(g) ~= 'nil' then
		error('I think this is not something you want to do. Red is nil, Green is ' .. type(g) .. ', Blue is ' .. type(b))
	end

	r = (tonumber(r) or 255):clamp(0, 255):floor()
	g = (tonumber(g) or 255):clamp(0, 255):floor()
	b = (tonumber(b) or 255):clamp(0, 255):floor()
	a = (tonumber(a) or 255):clamp(0, 255):floor()

	local newObj = {
		r = r,
		g = g,
		b = b,
		a = a,
	}

	return setmetatable(newObj, colorMeta)
end

--[[
	@doc
	@fname ColorFromSeed
	@args string seed

	@returns
	Color: newly created object
]]
function _G.ColorFromSeed(seedIn)
	return Color(srnd(seedIn, 0, 255, 0), srnd(seedIn, 0, 255, 1), srnd(seedIn, 0, 255, 2))
end

--[[
	@doc
	@fname IsColor
	@replaces
	@args any value

	@desc
	unlike !g:IsColor
	this can duck type the value
	@enddesc

	@returns
	boolean
]]
_G.Color = Color
local IsColor

--[[
	@doc
	@fname ColorAlpha
	@replaces
	@args Color target, number newAlpha

	@returns
	Color: copied color with modified alpha
]]
function _G.ColorAlpha(target, newAlpha)
	if not IsColor(target) then
		error('Input is not a color! typeof ' .. type(target))
	end

	if target.Copy then
		return target:Copy():SetAlpha(newAlpha)
	else
		return Color(target.r, target.g, target.b, newAlpha)
	end
end

do
	local pcall = pcall

	local function getMeta(object)
		return type(object) == 'table' and
			type(object.r) == 'number' and
			type(object.g) == 'number' and
			type(object.b) == 'number' and
			type(object.a) == 'number'
	end

	function IsColor(object)
		if getmetatable(object) == colorMeta then
			return true
		end

		local cstatus, cresult = pcall(getMeta, object)
		return cstatus and cresult
	end
end

_G.iscolor = IsColor
_G.IsColor = IsColor

--[[
	@doc
	@fname Color:__tostring

	@returns
	string
]]
function colorMeta:__tostring()
	return string.format('Color[%i %i %i %i]', self.r, self.g, self.b, self.a)
end

--[[
	@doc
	@fname Color:ToHex

	@returns
	string
]]
function colorMeta:ToHex()
	return string.format('0x%02x%02x%02x', self.r, self.g, self.b)
end

--[[
	@doc
	@fname Color:ToNumberLittle
	@alias Color:ToNumberLittlEndian
	@alias Color:ToNumberLE
	@args boolean writeAlpha

	@desc
	turns color into little endian integer
	@enddesc

	@returns
	number
]]
function colorMeta:ToNumberLittle(writeAlpha)
	if writeAlpha then
		return self.r:band(255) + self.g:band(255):lshift(8) + self.b:band(255):lshift(16) + self.a:band(255):lshift(24)
	else
		return self.r:band(255) + self.g:band(255):lshift(8) + self.b:band(255):lshift(16)
	end
end

--[[
	@doc
	@fname Color:ToNumber
	@alias Color:ToNumberBig
	@alias Color:ToNumberBigEndian
	@alias Color:ToNumberBE
	@args boolean writeAlpha

	@desc
	turns color into big endian integer
	@enddesc

	@returns
	number
]]
function colorMeta:ToNumber(writeAlpha)
	if writeAlpha then
		return self.r:band(255):lshift(24) + self.g:band(255):lshift(16) + self.b:band(255):lshift(8) + self.a:band(255)
	else
		return self.r:band(255):lshift(16) + self.g:band(255):lshift(8) + self.b:band(255)
	end
end

colorMeta.ToNumberBig = colorMeta.ToNumber
colorMeta.ToNumberBigEndian = colorMeta.ToNumber
colorMeta.ToNumberBE = colorMeta.ToNumber
colorMeta.ToNumberLittlEndian = colorMeta.ToNumberLittle
colorMeta.ToNumberLE = colorMeta.ToNumberLittle

--[[
	@doc
	@fname ColorFromNumberLittle
	@alias ColorFromNumberLittleEndian
	@alias ColorFromNumberLE
	@alias ColorLE

	@args number value, boolean hasAlpha

	@desc
	turns little endian integer into color
	@enddesc

	@returns
	Color
]]
function _G.ColorFromNumberLittle(numIn, hasAlpha)
	assert(type(numIn) == 'number', 'Must be a number!')
	if hasAlpha then
		local a, b, g, r =
			numIn:rshift(24):band(255),
			numIn:rshift(16):band(255),
			numIn:rshift(8):band(255),
			numIn:band(255)

		return Color(r, g, b, a)
	end

	local b, g, r =
		numIn:rshift(16):band(255),
		numIn:rshift(8):band(255),
		numIn:band(255)

	return Color(r, g, b)
end

--[[
	@doc
	@fname ColorFromNumber
	@alias ColorFromNumberBig
	@alias ColorFromNumberBigEndian
	@alias ColorFromNumberBE
	@alias ColorBE

	@args number value, boolean hasAlpha

	@desc
	turns big endian integer into color
	@enddesc

	@returns
	Color
]]
function _G.ColorFromNumber(numIn, hasAlpha)
	assert(type(numIn) == 'number', 'Must be a number!')
	if hasAlpha then
		local r, g, b, a =
			numIn:rshift(24):band(255),
			numIn:rshift(16):band(255),
			numIn:rshift(8):band(255),
			numIn:band(255)

		return Color(r, g, b, a)
	end

	local r, g, b =
		numIn:rshift(16):band(255),
		numIn:rshift(8):band(255),
		numIn:band(255)

	return Color(r, g, b)
end

local ColorFromNumber = ColorFromNumber

--[[
	@doc
	@fname ColorFromHex
	@alias ColorHex
	@alias ColorHEX
	@alias ColorFromHEX
	@alias Color16
	@alias ColorFrom16

	@args string value, boolean hasAlpha

	@returns
	Color
]]
function _G.ColorFromHex(hex, hasAlpha)
	return ColorFromNumber(tonumber(hex, 16), hasAlpha)
end

_G.ColorHex = _G.ColorFromHex
_G.ColorHEX = _G.ColorFromHex
_G.ColorFromHEX = _G.ColorFromHex
_G.Color16 = _G.ColorFromHex
_G.ColorFrom16 = _G.ColorFromHex
_G.ColorFromNumberLittleEndian = _G.ColorFromNumberLittle
_G.ColorFromNumberLE = _G.ColorFromNumberLittle
_G.ColorLE = _G.ColorFromNumberLittle
_G.ColorFromNumberBig = _G.ColorFromNumber
_G.ColorFromNumberBigEndian = _G.ColorFromNumber
_G.ColorFromNumberBE = _G.ColorFromNumber
_G.ColorBE = _G.ColorFromNumber

--[[
	@doc
	@fname HSVToColorC
	@args number hue, number saturation, number value

	@desc
	the old (gmod's) !g:HSVToColor
	@enddesc

	@returns
	table
]]
_G.HSVToColorC = HSVToColorC or HSVToColor
local HSVToColorC = HSVToColorC

--[[
	@doc
	@fname HSVToColorLua
	@args number hue, number saturation, number value

	@desc
	JIT compilable !g:HSVToColor
	**This function has metatable of color fixed**
	**This function has left bitwise shift overflow fixed**
	**This function clamp saturation and value (unlike original function), and modulo divide hue (like original function)**
	@enddesc

	@returns
	Color
]]
function _G.HSVToColorLua(hue, saturation, value)
	if type(hue) ~= 'number' then
		error('Hue expected to be a number, ' .. type(hue) .. ' given')
	end

	if type(saturation) ~= 'number' then
		error('Saturation expected to be a number, ' .. type(hue) .. ' given')
	end

	if type(value) ~= 'number' then
		error('Value (brightness) expected to be a number, ' .. type(hue) .. ' given')
	end

	hue = (hue % 360):floor()
	if hue < 0 then hue = 360 + hue end
	saturation = saturation:clamp(0, 1)
	value = value:clamp(0, 1)

	local huei = (hue / 60):floor() % 6
	local valueMin = (1 - saturation) * value
	local delta = (value - valueMin) * (hue % 60) / 60
	local valueInc = valueMin + delta
	local valueDec = value - delta

	if huei == 0 then
		return Color(value * 255, valueInc * 255, valueMin * 255)
	elseif huei == 1 then
		return Color(valueDec * 255, value * 255, valueMin * 255)
	elseif huei == 2 then
		return Color(valueMin * 255, value * 255, valueInc * 255)
	elseif huei == 3 then
		return Color(valueMin * 255, valueDec * 255, value * 255)
	elseif huei == 4 then
		return Color(valueInc * 255, valueMin * 255, value * 255)
	end

	return Color(value * 255, valueMin * 255, valueDec * 255)
end

--[[
	@doc
	@fname HSVToColor
	@replaces
	@args number hue, number saturation, number value

	@desc
	!g:HSVToColor with metatable fixed
	@enddesc

	@returns
	Color
]]
function _G.HSVToColor(hue, saturation, value)
	return setmetatable(HSVToColorC(hue, saturation, value), colorMeta)
end

--[[
	@doc
	@fname Color:__eq
	@args any other

	@desc
	var1 == var2
	@enddesc

	@returns
	boolean
]]
function colorMeta:__eq(target)
	if not IsColor(target) then
		return false
	end

	return target.r == self.r and target.g == self.g and target.b == self.b and target.a == self.a
end

local function NormalizeColor(r, g, b)
	if r >= 0 and r < 256 and g >= 0 and g < 256 and b >= 0 and b < 256 then
		return r, g, b
	end

	if r < 0 then
		g, b = g - r, b - r
		r = 0
	end

	if g < 0 then
		r, b = r - g, b - g
		g = 0
	end

	if b < 0 then
		r, g = r - b, g - b
		b = 0
	end

	if r >= 0 and r < 256 and g >= 0 and g < 256 and b >= 0 and b < 256 then
		return r, g, b
	end

	local len = (r:pow(2) + g:pow(2) + b:pow(2)):sqrt() / 255

	r = (r / len):round()
	g = (g / len):round()
	b = (b / len):round()

	return r, g, b
end

--[[
	@doc
	@fname NormalizeColor
	@args number r, number g, number b

	@desc
	normalizes negative and overflown channels
	@enddesc

	@returns
	number: r
	number: g
	number: b
]]
_G.NormalizeColor = NormalizeColor

--[[
	@doc
	@fname Color:__add
	@args any other

	@desc
	var1 + var2
	accepts `number`, `Vector` and `Color`
	throws an error if one of arguments is not in list above
	operation is performed on each channel separately if other operand is not a number
	This operation work over color like over normalized vector
	@enddesc

	@returns
	Color: copy
]]
function colorMeta:__add(target)
	if not IsColor(self) and IsColor(target) then
		local s1, s2 = self, target
		target = s1
		self = s2
	end

	if type(target) == 'number' then
		local r, g, b = mathLogic(self.r, target, self.g, self.b)
		g, r, b = mathLogic(g, target, r, b)
		b, r, g = mathLogic(b, target, r, g)

		return Color(NormalizeColor(self.r + target, self.g + target, self.b + target)):SetAlpha(self.a)
	elseif type(target) == 'Vector' then
		return self + target:ToColor()
	else
		if not IsColor(target) then
			error('Color + ' .. type(target) .. ' => Not a function!')
		end

		return Color(NormalizeColor(self.r + target.r, self.g + target.g, self.b + target.b)):SetAlpha(self.a)
	end
end

--[[
	@doc
	@fname Color:__sub
	@args any other

	@desc
	var1 - var2
	accepts `number`, `Vector` and `Color`
	throws an error if one of arguments is not in list above
	operation is performed on each channel separately if other operand is not a number
	This operation work over color like over normalized vector
	@enddesc

	@returns
	Color: copy
]]
function colorMeta:__sub(target)
	if not IsColor(self) and IsColor(target) then
		local s1, s2 = self, target
		target = s1
		self = s2
	end

	if type(target) == 'number' then
		return Color(NormalizeColor(self.r - target, self.g - target, self.b - target)):SetAlpha(self.a)
	elseif type(target) == 'Vector' then
		return self - target:ToColor()
	else
		if not IsColor(target) then
			error('Color - ' .. type(target) .. ' => Not a function!')
		end

		return Color(NormalizeColor(self.r - target.r, self.g - target.g, self.b - target.b)):SetAlpha(self.a)
	end
end

--[[
	@doc
	@fname Color:__mul
	@args any other

	@desc
	var1 * var2
	accepts `number`, `Vector` and `Color`
	throws an error if one of arguments is not in list above
	operation is performed on each channel separately if other operand is not a number
	This operation work over color like over normalized vector
	@enddesc

	@returns
	Color: copy
]]
function colorMeta:__mul(target)
	if not IsColor(self) and IsColor(target) then
		local s1, s2 = self, target
		target = s1
		self = s2
	end

	if type(target) == 'number' then
		return Color(NormalizeColor(self.r * (target / 255), self.g * (target / 255), self.b * (target / 255))):SetAlpha(self.a)
	elseif type(target) == 'Vector' then
		return self * target:ToColor()
	else
		if not IsColor(target) then
			error('Color * ' .. type(target) .. ' => Not a function!')
		end

		return Color(NormalizeColor(self.r * (target.r / 255), self.g * (target.g / 255), self.b * (target.b / 255))):SetAlpha(self.a)
	end
end

--[[
	@doc
	@fname Color:__div
	@args any other

	@desc
	var1 / var2
	accepts `number`, `Vector` and `Color`
	throws an error if one of arguments is not in list above
	operation is performed on each channel separately if other operand is not a number
	This operation work over color like over normalized vector
	@enddesc

	@returns
	Color: copy
]]
function colorMeta:__div(target)
	if not IsColor(self) and IsColor(target) then
		local s1, s2 = self, target
		target = s1
		self = s2
	end

	if type(target) == 'number' then
		return Color(NormalizeColor(self.r / target, self.g / target, self.b / target)):SetAlpha(self.a)
	elseif type(target) == 'Vector' then
		return self / target:ToColor()
	else
		if not IsColor(target) then
			error('Color / ' .. type(target) .. ' => Not a function!')
		end

		return Color(NormalizeColor(self.r / target.r, self.g / target.g, self.b / target.b)):SetAlpha(self.a)
	end
end

--[[
	@doc
	@fname Color:__mod
	@args any other

	@desc
	var1 % var2
	accepts `number`, `Vector` and `Color`
	throws an error if one of arguments is not in list above
	operation is performed on each channel separately if other operand is not a number
	@enddesc

	@returns
	Color: copy
]]
function colorMeta:__mod(target)
	if not IsColor(self) and IsColor(target) then
		local s1, s2 = self, target
		target = s1
		self = s2
	end

	if type(target) == 'number' then
		return Color(NormalizeColor(self.r % target, self.g % target, self.b % target)):SetAlpha(self.a)
	elseif type(target) == 'Vector' then
		return self % target:ToColor()
	else
		if not IsColor(target) then
			error('Color % ' .. type(target) .. ' => Not a function!')
		end

		return Color(NormalizeColor(self.r % target.r, self.g % target.g, self.b % target.b)):SetAlpha(self.a)
	end
end

--[[
	@doc
	@fname Color:__pow
	@args any other

	@desc
	var1 ^ var2
	accepts `number`, `Vector` and `Color`
	throws an error if one of arguments is not in list above
	operation is performed on each channel separately if other operand is not a number
	@enddesc

	@returns
	Color: copy
]]
function colorMeta:__pow(target)
	if not IsColor(self) and IsColor(target) then
		local s1, s2 = self, target
		target = s1
		self = s2
	end

	if type(target) == 'number' then
		return Color(NormalizeColor(self.r:pow(target), self.g:pow(target), self.b:pow(target))):SetAlpha(self.a)
	elseif type(target) == 'Vector' then
		return self ^ target:ToColor()
	else
		if not IsColor(target) then
			error('Color ^ ' .. type(target) .. ' => Not a function!')
		end

		return Color(NormalizeColor(self.r:pow(target.r), self.g:pow(target.g), self.b:pow(target.b))):SetAlpha(self.a)
	end
end

--[[
	@doc
	@fname Color:__concat
	@args any other

	@desc
	var1 .. var2
	accepts `number`, `Vector` and `Color`
	throws an error if one of arguments is not in list above
	operation is performed on each channel separately if other operand is not a number
	@enddesc

	@returns
	string
]]
function colorMeta:__concat(target)
	if IsColor(self) then
		return string.format('%i %i %i %i', self.r, self.g, self.b, self.a) .. target
	else
		return self .. string.format('%i %i %i %i', target.r, target.g, target.b, target.a)
	end
end

--[[
	@doc
	@fname Color:__lt
	@args any other

	@desc
	var1 < var2
	accepts `number`, `Vector` and `Color`
	throws an error if one of arguments is not in list above
	operation is performed on `Length` of Color, which is red + green + blue
	@enddesc

	@returns
	boolean
]]
function colorMeta:__lt(target)
	if not IsColor(self) and IsColor(target) then
		local s1, s2 = self, target
		target = s1
		self = s2
	end

	if type(target) == 'number' then
		return self:Length() < target
	elseif type(target) == 'Vector' then
		return self < target:ToColor()
	else
		if not IsColor(target) then
			error('Color < ' .. type(target) .. ' => Not a function!')
		end

		return self:Length() < target:Length()
	end
end

--[[
	@doc
	@fname Color:__le
	@args any other

	@desc
	var1 <= var2
	accepts `number`, `Vector` and `Color`
	throws an error if one of arguments is not in list above
	operation is performed on `Length` of Color, which is red + green + blue
	@enddesc

	@returns
	boolean
]]
function colorMeta:__le(target)
	if not IsColor(self) and IsColor(target) then
		local s1, s2 = self, target
		target = s1
		self = s2
	end

	if type(target) == 'number' then
		return self:Length() <= target
	elseif type(target) == 'Vector' then
		return self <= target:ToColor()
	else
		if not IsColor(target) then
			error('Color <= ' .. type(target) .. ' => Not a function!')
		end

		return self:Length() <= target:Length()
	end
end

--[[
	@doc
	@fname Color:__unm

	@desc
	-var1
	alias for Color:Invert
	@enddesc

	@returns
	Color: copy
]]
function colorMeta:__unm()
	return self:Invert()
end

--[[
	@doc
	@fname Color:Copy

	@returns
	Color: copy
]]
function colorMeta:Copy()
	return Color(self.r, self.g, self.b, self.a)
end

--[[
	@doc
	@fname Color:Length

	@returns
	number: r + g + b
]]
function colorMeta:Length()
	return self.r + self.g + self.b
end

--[[
	@doc
	@fname Color:Invert
	@args any other

	@desc
	Inverts color channels
	@enddesc

	@returns
	Color: copy
]]
function colorMeta:Invert()
	return Color(255 - self.r, 255 - self.g, 255 - self.b, self.a)
end

--[[
	@doc
	@fname Color:ToHSV

	@returns
	number: hue
	number: saturation
	number: value
]]
function colorMeta:ToHSV()
	return ColorToHSV(self)
end

--[[
	@doc
	@fname Color:ToVector

	@returns
	Vector: normalized vector
]]
function colorMeta:ToVector()
	return Vector(self.r / 255, self.g / 255, self.b / 255)
end

--[[
	@doc
	@fname Color:Lerp
	@args number t, Color lerpTo

	@desc
	You can also use regular !g:Lerp function for this.
	@enddesc

	@returns
	Color: copy
]]
function colorMeta:Lerp(lerpValue, lerpTo)
	if not IsColor(lerpTo) then
		error('Color:Lerp - second argument is not a color!')
	end

	local r = Lerp(lerpValue, self.r, lerpTo.r)
	local g = Lerp(lerpValue, self.g, lerpTo.g)
	local b = Lerp(lerpValue, self.b, lerpTo.b)

	return Color(r, g, b, self.a)
end

--[[
	@docpreprocess

	const methods = [
		'Red',
		'Green',
		'Blue',
		'Alpha',
	]

	const output = []

	for (const method of methods) {
		const output2 = []

		output2.push(`@fname Color:Set${method}`)
		output2.push(`@args number newValue`)

		output2.push(`@desc`)
		output2.push(`Sets \`${method}\` channel of color`)
		output2.push(`This **modifies** the original color.`)
		output2.push(`@enddesc`)

		output2.push(`@returns`)
		output2.push(`Color: self`)

		output.push(output2)

		const output3 = []

		output3.push(`@fname Color:Modify${method}`)
		output3.push(`@args number newValue`)

		output3.push(`@desc`)
		output3.push(`Sets \`${method}\` channel of color`)
		output3.push(`This **creates a copy** of the original color.`)
		output3.push(`@enddesc`)

		output3.push(`@returns`)
		output3.push(`Color: copy`)

		output.push(output3)

		const output4 = []

		output4.push(`@fname Color:Get${method}`)

		output4.push(`@returns`)
		output4.push(`number: the \`${method}\` channel of color`)

		output.push(output4)
	}

	return output
]]
do
	local methods = {
		r = 'Red',
		g = 'Green',
		b = 'Blue',
		a = 'Alpha'
	}

	for key, method in pairs(methods) do
		colorMeta['Set' .. method] = function(self, newValue)
			self[key] = (tonumber(newValue) or 255):clamp(0, 255):floor()
			return self
		end

		colorMeta['Modify' .. method] = function(self, newValue)
			local new = Color(self)
			new[key] = (tonumber(newValue) or 255):clamp(0, 255):floor()
			return new
		end

		colorMeta['Get' .. method] = function(self)
			return self[key]
		end
	end
end

local colorBundle = {
	color_black = Color() - 255,
	color_white = Color(255, 255, 255),
	color_red = Color(255, 0, 0),
	color_green = Color(0, 255, 0),
	color_blue = Color(0, 0, 255),
	color_cyan = Color(0, 255, 255),
	color_magenta = Color(255, 0, 255),
	color_yellow = Color(255, 255, 0),
	color_dlib = Color(0, 0, 0, 255),
	color_transparent = Color():SetAlpha(0),
}

for k, v in pairs(colorBundle) do
	_G[k] = v
end
