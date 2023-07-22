
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

local gstring = _G.string
local string = setmetatable(DLib.string or {}, {__index = string})
DLib.string = string
local unpack = unpack
local os = os
local select = select
local math = math
local table = table

--[[
	@doc
	@fname string.formatname
	@args string self

	@desc
	first character is uppecased
	@enddesc

	@returns
	string
]]
function gstring.formatname(self)
	return self:sub(1, 1):upper() .. self:sub(2)
end

--[[
	@doc
	@fname string.formatname2
	@args string self

	@desc
	first character is uppecased, `_` are replaced with spaces
	@enddesc

	@returns
	string
]]
function gstring.formatname2(self)
	return self:sub(1, 1):upper() .. self:sub(2):replace('_', ' ')
end

--[[
	@doc
	@fname DLib.string.tformat
	@args number time

	@deprecated

	@desc
	use DLib.i18n.tformat
	@enddesc

	@returns
	string: formatted time
]]
function string.tformat(time)
	if time > 0xFFFFFFFFF then
		return 'Way too long'
	elseif time <= 1 then
		return 'Right now'
	end

	local str = ''

	local centuries, years, months, weeks, days, hours, minutes, seconds = math.tformatVararg(time)

	if seconds ~= 0 then
		str = seconds .. ' seconds'
	end

	if minutes ~= 0 then
		str = minutes .. ' minutes ' .. str
	end

	if hours ~= 0 then
		str = hours .. ' hours ' .. str
	end

	if days ~= 0 then
		str = days .. ' days ' .. str
	end

	if weeks ~= 0 then
		str = weeks .. ' weeks ' .. str
	end

	if months ~= 0 then
		str = months .. ' months ' .. str
	end

	if years ~= 0 then
		str = years .. ' years ' .. str
	end

	if centuries ~= 0 then
		str = centuries .. ' centuries ' .. str
	end

	return str
end

--[[
	@doc
	@fname DLib.string.qdate
	@args number time = os.time(), boolean isLocal = true, boolean removeTimezone = false

	@desc
	`isLocal` - time is result of call os.time() or similar
	`removeTimezone` - whenever to sub/add time using operating system's timezone (and don't print timezone in final result)
	@enddesc

	@returns
	string: quick formatted os.date (Human friendly ISO8601 format)
]]
function string.qdate(time, isLocal, removeTimezone)
	if time == nil then time = os.time() end
	if isLocal == nil then isLocal = true end

	local timezone = os.date('%z', time)
	local timezoneNum = 0

	if isLocal then
		if #timezone == 0 then
			timezone = '+??:??'
		else
			timezone = timezone:sub(1, 3) .. ':' .. timezone:sub(4)
			timezoneNum = ((tonumber(timezone:sub(2, 3)) or 0) * 3600 + (tonumber(timezone:sub(4)) or 0) * 60) * (timezone[1] == '-' and -1 or 1)
		end
	end

	if removeTimezone and isLocal then
		time = time - timezoneNum
	end

	if isLocal and not removeTimezone then
		return os.date('%Y-%m-%d %H:%M:%S', time) .. ' UTC' .. timezone
	else
		return os.date('%Y-%m-%d %H:%M:%S', time) .. ' UTC+00:00'
	end
end

string.HU_IN_M = 40
string.HU_IN_CM = string.HU_IN_M / 100

--[[
	@doc
	@fname DLib.string.ddistance
	@args number z, boolean newline, number fromZ

	@returns
	string: unlocalized Z difference
]]
function string.ddistance(z, newline, from)
	if newline == nil then
		newline = true
	end

	local delta

	if from then
		delta = from - z
	else
		delta = LocalPlayer():GetPos().z - z
	end

	if delta > 200 and not newline then
		return string.fdistance(delta) .. ' lower'
	end

	if delta > 200 and newline then
		return '\n' .. string.fdistance(delta) .. ' lower'
	end

	if -delta > 200 and not newline then
		return string.fdistance(delta) .. 'upper'
	end

	if -delta > 200 and newline then
		return '\n' .. string.fdistance(delta) .. 'upper'
	end

	return ''
end

--[[
	@doc
	@fname DLib.string.fdistance
	@args number distanceInHammerUnits

	@returns
	string: formatted metres
]]
function string.fdistance(m)
	return string.format('%.1fm', m / string.HU_IN_M)
end

--[[
	@doc
	@fname DLib.string.niceName
	@args Entity ent
	@deprecated

	@desc
	Use Entity:GetPrintNameDLib()
	@enddesc

	@returns
	string
]]
function string.niceName(ent)
	if not IsValid(ent) then return '' end
	if ent.Nick then return ent:Nick() end
	if ent.PrintName and ent.PrintName ~= '' then return ent.PrintName end
	if ent.GetPrintName then return ent:GetPrintName() end
	return ent:GetClass()
end

--[[
	@doc
	@fname string.split
	@args string self, string separator, vararg arguments

	@desc
	flip of !g:string.Explode
	@enddesc

	@returns
	table: of strings
]]
function string.split(stringIn, explodeIn, ...)
	return string.Explode(explodeIn, stringIn, ...)
end

-- fuck https://github.com/Facepunch/garrysmod/pull/1176
string.StartsWith = string.StartWith


--[[
	@doc
	@fname string.StartsWith
	@args string self, string check

	@desc
	[alias](https://github.com/Facepunch/garrysmod/pull/1176) of !g:string.StartWith
	@enddesc

	@returns
	boolean
]]
gstring.StartsWith = gstring.StartWith

local funcs = {}

for k, v in pairs(gstring) do
	funcs[k:sub(1, 1):lower() .. k:sub(2)] = v
end

for k, v in pairs(funcs) do
	if gstring[k] == nil then
		gstring[k] = v
	end
end

--[[
	@doc
	@fname DLib.string.bchar
	@args vararg bytes

	@desc
	allows to bypass bytes limit of bytes-per-call of !g:string.char transparently
	@enddesc

	@returns
	string
]]
function string.bchar(...)
	local bytes = select('#', ...)

	if bytes < 800 then
		return string.char(...)
	end

	local input = {...}
	local output = ''
	local i = -799

	::loop::
	i = i + 800

	output = output .. string.char(unpack(input, i, math.min(i + 799, bytes)))

	if i + 799 < bytes then
		goto loop
	end

	return output
end

--[[
	@doc
	@fname DLib.string.bcharTable
	@args table bytes

	@desc
	allows to bypass bytes limit of bytes-per-call of !g:string.char transparently
	@enddesc

	@returns
	string
]]
function string.bcharTable(input)
	local bytes = #input
	if bytes == 0 then return '' end

	if bytes < 800 then
		return string.char(unpack(input))
	end

	local output = ''
	local i = -799

	::loop::
	i = i + 800

	local status, output2 = pcall(string.char, unpack(input, i, math.min(i + 799, bytes)))

	if not status then
		for i2 = i, math.min(i + 799, bytes) do
			if input[i2] < 0 or input[i2] > 255 then
				error(output2 .. ' (' .. input[i2] .. ')')
			end
		end
	end

	output = output .. output2

	if i + 799 < bytes then
		goto loop
	end

	return output
end

--[[
	@doc
	@fname DLib.string.bbyte
	@args string self, number sliceAt, number sliceEnd

	@desc
	allows to bypass bytes limit of bytes-per-call of !g:string.byte transparently
	@enddesc

	@returns
	table: of bytes
]]
function string.bbyte(strIn, sliceStart, sliceEnd)
	local strLen = #strIn
	local delta = sliceEnd - sliceStart

	if delta < 800 then
		local i = sliceStart - 1
		local output = {}

		::loop1::
		i = i + 1

		table.insert(output, strIn:byte(i, i))

		if i < sliceEnd then
			goto loop1
		end

		return output
	end

	local output = {}

	local i = sliceStart - 1

	::loop::
	i = i + 1

	table.insert(output, strIn:byte(i, i))

	if i < sliceEnd then
		goto loop
	end

	return output
end
