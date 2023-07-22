
-- Copyright (C) 2018-2020 DBotThePony

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

local i18n = i18n
local DLib = DLib
local assert = assert
local type = type

--[[
	@doc
	@fname DLib.i18n.tformatByLang
	@args number time, string lang, boolean ago = false

	@returns
	string: formatted time in selected locale
]]
function i18n.tformatByLang(time, lang, ago)
	assert(type(time) == 'number', 'Invalid time specified')

	if time > 0xFFFFFFFFF then
		return i18n.localizeByLang('info.dlib.tformat.long', lang)
	elseif time <= 1 and time >= 0 then
		return i18n.localizeByLang('info.dlib.tformat.now', lang)
	--elseif time < 0 and not ago then
	--  return i18n.localizeByLang('info.dlib.tformat.past', lang)
	end

	local str = ''
	local suffix = ago and '_ago' or ''

	local centuries, years, months, weeks, days, hours, minutes, seconds = math.tformatVararg(time:abs())

	if seconds ~= 0 then
		str = i18n.localizeByLang('info.dlib.tformat.countable' .. suffix .. '.second.' .. seconds, lang)
	end

	if minutes ~= 0 then
		str = i18n.localizeByLang('info.dlib.tformat.countable' .. suffix .. '.minute.' .. minutes, lang) .. ' ' .. str
	end

	if hours ~= 0 then
		str = i18n.localizeByLang('info.dlib.tformat.countable' .. suffix .. '.hour.' .. hours, lang) .. ' ' .. str
	end

	if days ~= 0 then
		str = i18n.localizeByLang('info.dlib.tformat.countable' .. suffix .. '.day.' .. days, lang) .. ' ' .. str
	end

	if weeks ~= 0 then
		str = i18n.localizeByLang('info.dlib.tformat.countable' .. suffix .. '.week.' .. weeks, lang) .. ' ' .. str
	end

	if months ~= 0 then
		str = i18n.localizeByLang('info.dlib.tformat.countable' .. suffix .. '.month.' .. months, lang) .. ' ' .. str
	end

	if years ~= 0 then
		str = i18n.localizeByLang('info.dlib.tformat.countable' .. suffix .. '.year.' .. years, lang) .. ' ' .. str
	end

	if centuries ~= 0 then
		str = i18n.localizeByLang('info.dlib.tformat.countable' .. suffix .. '.century.' .. centuries, lang) .. ' ' .. str
	end

	return ago and i18n.localizeByLang('info.dlib.tformat.ago' .. (time < 0 and '_inv' or ''), lang, str) or time < 0 and ('-(' .. str .. ')') or str
end

--[[
	@doc
	@fname DLib.i18n.tformatTableByLang
	@args number time, string lang, boolean ago = false

	@returns
	table: array of formatted time in selected locale
]]
function i18n.tformatTableByLang(time, lang, ago)
	assert(type(time) == 'number', 'Invalid time specified')

	if time > 0xFFFFFFFFF then
		return {i18n.localizeByLang('info.dlib.tformat.long', lang)}
	elseif time <= 1 and time >= 0 then
		return {i18n.localizeByLang('info.dlib.tformat.now', lang)}
	elseif time < 0 then
		return {i18n.localizeByLang('info.dlib.tformat.past', lang)}
	end

	local str = {}
	local suffix = ago and '_ago' or ''

	local centuries, years, months, weeks, days, hours, minutes, seconds = math.tformatVararg(time)

	if seconds ~= 0 then
		table.insert(str, i18n.localizeByLang('info.dlib.tformat.countable' .. suffix .. '.second.' .. seconds, lang))
	end

	if minutes ~= 0 then
		table.insert(str, i18n.localizeByLang('info.dlib.tformat.countable' .. suffix .. '.minute.' .. minutes, lang))
	end

	if hours ~= 0 then
		table.insert(str, i18n.localizeByLang('info.dlib.tformat.countable' .. suffix .. '.hour.' .. hours, lang))
	end

	if days ~= 0 then
		table.insert(str, i18n.localizeByLang('info.dlib.tformat.countable' .. suffix .. '.day.' .. days, lang))
	end

	if weeks ~= 0 then
		table.insert(str, i18n.localizeByLang('info.dlib.tformat.countable' .. suffix .. '.week.' .. weeks, lang))
	end

	if months ~= 0 then
		table.insert(str, i18n.localizeByLang('info.dlib.tformat.countable' .. suffix .. '.month.' .. months, lang))
	end

	if years ~= 0 then
		table.insert(str, i18n.localizeByLang('info.dlib.tformat.countable' .. suffix .. '.year.' .. years, lang))
	end

	if centuries ~= 0 then
		table.insert(str, i18n.localizeByLang('info.dlib.tformat.countable' .. suffix .. '.century.' .. centuries, lang))
	end

	return str
end

--[[
	@doc
	@fname DLib.i18n.tformatRawTable
	@args number time

	@returns
	table: for use in functions like DLib.LMessage/AddonSpace.LMessage/i18n.AddChat
]]
function i18n.tformatRawTable(time, ago)
	assert(type(time) == 'number', 'Invalid time specified')

	if time > 0xFFFFFFFFF then
		return {'info.dlib.tformat.long'}
	elseif time <= 1 and time >= 0 then
		return {'info.dlib.tformat.now'}
	--elseif time < 0 then
	--  return {'info.dlib.tformat.past'}
	end

	local suffix = ago and '_ago' or ''
	local str = {}
	local centuries, years, months, weeks, days, hours, minutes, seconds = math.tformatVararg(time:abs())

	if ago then
		table.insert(str, 'info.dlib.tformat.ago' .. (time < 0 and '_inv' or ''))
	end

	if time < 0 then
		table.insert(str, '-(')
	end

	if seconds ~= 0 then
		table.insert(str, 'info.dlib.tformat.countable' .. suffix .. '.second.' .. seconds)
	end

	if minutes ~= 0 then
		table.insert(str, ' ')
		table.insert(str, 'info.dlib.tformat.countable' .. suffix .. '.minute.' .. minutes)
	end

	if hours ~= 0 then
		table.insert(str, ' ')
		table.insert(str, 'info.dlib.tformat.countable' .. suffix .. '.hour.' .. hours)
	end

	if days ~= 0 then
		table.insert(str, ' ')
		table.insert(str, 'info.dlib.tformat.countable' .. suffix .. '.day.' .. days)
	end

	if weeks ~= 0 then
		table.insert(str, ' ')
		table.insert(str, 'info.dlib.tformat.countable' .. suffix .. '.week.' .. weeks)
	end

	if months ~= 0 then
		table.insert(str, ' ')
		table.insert(str, 'info.dlib.tformat.countable' .. suffix .. '.month.' .. months)
	end

	if years ~= 0 then
		table.insert(str, ' ')
		table.insert(str, 'info.dlib.tformat.countable' .. suffix .. '.year.' .. years)
	end

	if centuries ~= 0 then
		table.insert(str, ' ')
		table.insert(str, 'info.dlib.tformat.countable' .. suffix .. '.century.' .. centuries)
	end

	if time < 0 then
		table.insert(str, ')')
	end

	return str
end

--[[
	@doc
	@fname DLib.i18n.tformat
	@args number time, boolean ago = false

	@returns
	string: formatted time
]]
function i18n.tformat(time, ago)
	return i18n.tformatByLang(time, i18n.CURRENT_LANG, ago)
end

--[[
	@doc
	@fname DLib.i18n.tformatTable
	@args number time, boolean ago = false

	@returns
	table: formatted time
]]
function i18n.tformatTable(time, ago)
	return i18n.tformatTableByLang(time, i18n.CURRENT_LANG, ago)
end

--[[
	@doc
	@fname DLib.i18n.tformatFor
	@args Player ply, number time, boolean ago = false

	@returns
	string: formatted time in player's locale
]]
function i18n.tformatFor(ply, time, ago)
	return i18n.tformatByLang(time, assert(type(ply) == 'Player' and ply, 'Invalid player provided').DLib_Lang or i18n.CURRENT_LANG)
end

--[[
	@doc
	@fname DLib.i18n.tformatTableFor
	@args Player ply, number time, boolean ago = false

	@returns
	table: formatted time in player's locale
]]
function i18n.tformatTableFor(ply, time, ago)
	return i18n.tformatTableByLang(time, assert(type(ply) == 'Player' and ply, 'Invalid player provided').DLib_Lang or i18n.CURRENT_LANG)
end
