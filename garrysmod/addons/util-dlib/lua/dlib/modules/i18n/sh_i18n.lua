
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
local string = string
local type = type
local error = error
local team = team
local DLib = DLib
local table = table
local IsColor = IsColor

i18n.hashed = i18n.hashed or {}
i18n.hashedFunc = i18n.hashedFunc or {}
i18n.hashedNoArgs = i18n.hashedNoArgs or {}
i18n.hashedLang = i18n.hashedLang or {}
i18n.hashedLangFunc = i18n.hashedLangFunc or {}
i18n.hashedNoArgsLang = i18n.hashedNoArgsLang or {}

local formatters = {
	['##'] = function(self)
		return {'##'}, 0
	end,

	['#E'] = function(self, ent)
		local ltype = type(ent)

		if ltype == 'Player' then
			local nick = ent:Nick()

			if ent.SteamName and ent:SteamName() ~= nick then
				nick = nick .. ' (' .. ent:SteamName() .. ')'
			end

			return {team.GetColor(ent:Team()) or Color(), nick, color_white, string.format('<%s>', ent:SteamID())}
		elseif ltype == 'Entity' then
			return {DLib.ENTITY_COLOR:Copy(), tostring(ent)}
		elseif ltype == 'NPC' then
			return {DLib.NPC_COLOR:Copy(), tostring(ent)}
		elseif ltype == 'Vehicle' then
			return {DLib.VEHICLE_COLOR:Copy(), tostring(ent)}
		elseif ltype == 'NextBot' then
			return {DLib.NEXTBOT_COLOR:Copy(), tostring(ent)}
		elseif ltype == 'Weapon' then
			return {DLib.WEAPON_COLOR:Copy(), tostring(ent)}
		else
			error('Invalid argument to #E: ' .. ltype)
		end
	end,

	-- executor
	['#e'] = function(self, ent)
		local ltype = type(ent)

		if ltype == 'Player' then
			local nick = ent:Nick()

			if ent.SteamName and ent:SteamName() ~= nick then
				nick = nick .. ' (' .. ent:SteamName() .. ')'
			end

			return {team.GetColor(ent:Team()) or Color(), nick, color_white, string.format('<%s>', ent:SteamID())}
		elseif ltype == 'Entity' and not IsValid(ent) then
			return {Color(126, 63, 255), 'Console'}
		else
			error('Invalid argument to #e (executor) - ' .. ltype .. ' (' .. tostring(ent)  .. ')')
		end
	end,

	['#C'] = function(self, color)
		if not IsColor(color) then
			error('#C must be a color! ' .. type(color) .. ' given.')
		end

		return {color}
	end,

	['#%.%d+i'] = function(self, val)
		if type(val) ~= 'number' then
			error('Invalid argument to custom #i: ' .. type(val))
		end

		return {DLib.NUMBER_COLOR:Copy(), string.format('%' .. self:sub(2, #self - 1) ..'i', val)}
	end,

	['#i'] = function(self, val)
		if type(val) ~= 'number' then
			error('Invalid argument to #i: ' .. type(val))
		end

		return {DLib.NUMBER_COLOR:Copy(), string.format('%i', val)}
	end,

	['#%.%d+f'] = function(self, val)
		if type(val) ~= 'number' then
			error('Invalid argument to custom #f: ' .. type(val))
		end

		return {DLib.NUMBER_COLOR:Copy(), string.format('%' .. self:sub(2, #self - 1) ..'f', val)}
	end,

	['#f'] = function(self, val)
		if type(val) ~= 'number' then
			error('Invalid argument to #f: ' .. type(val))
		end

		return {DLib.NUMBER_COLOR:Copy(), string.format('%f', val)}
	end,

	['#%.%d+[xX]'] = function(self, val)
		if type(val) ~= 'number' then
			error('Invalid argument to custom #x/#X: ' .. type(val))
		end

		if self[#self] == 'x' then
			return {DLib.NUMBER_COLOR:Copy(), string.format('%' .. self:sub(2, #self - 1) ..'x', val)}
		else
			return {DLib.NUMBER_COLOR:Copy(), string.format('%' .. self:sub(2, #self - 1) ..'X', val)}
		end
	end,

	['#[xX]'] = function(self, val)
		if type(val) ~= 'number' then
			error('Invalid argument to #x/#X: ' .. type(val))
		end

		if self[2] == 'x' then
			return {DLib.NUMBER_COLOR:Copy(), string.format('%x', val)}
		else
			return {DLib.NUMBER_COLOR:Copy(), string.format('%X', val)}
		end
	end,

	['#[duco]'] = function(self, val)
		if type(val) ~= 'number' then
			error('Invalid argument to #[duco]: ' .. type(val))
		end

		return {DLib.NUMBER_COLOR:Copy(), string.format('%' .. self[2], val)}
	end,

	['#b'] = function(self, val)
		if type(val) ~= 'number' then
			error('Invalid argument to #b: ' .. type(val))
		end

		local format = ''

		if val < 0 then
			val = val + 0xFFFFFFFF
		end

		val = val:floor()

		while val > 0 do
			local div = val % 2
			val = (val - div) / 2
			format = div .. format
		end

		return {DLib.NUMBER_COLOR:Copy(), format}
	end,

	['#%.%d+b'] = function(self, val)
		if type(val) ~= 'number' then
			error('Invalid argument to custom #b: ' .. type(val))
		end

		local format = ''

		if val < 0 then
			val = val + 0xFFFFFFFF
		end

		val = val:floor()

		while val > 0 do
			local div = val % 2
			val = (val - div) / 2
			format = div .. format
		end

		local num = tonumber(self:sub(3, #self - 1))

		if #format < num then
			format = string.rep('0', num - #format) .. format
		end

		return {DLib.NUMBER_COLOR:Copy(), format}
	end,
}

--[[
	@doc
	@fname DLib.i18n.format
	@args string unformatted, Color colorDef = nil, vararg format

	@desc
	Supports colors from custom format arguments
	This is the same as creating i18n phrase with required arguments put in,
	but slower due to `unformatted` being parsed each time on call, when
	i18n phrase is parsed only once.
	Available arguments are:
	`#.0b`, `#b`, `#d`, `#u`, `#c`, `#o`, `#x`, `#.0x`, `#X`, `#.0X`, `#f`, `#.0f`, `#i`, `#.0i`, `#C` = Color, `#E` = Entity, `#e` = Command executor
	As well as all `%` arguments !g:string.format accept
	@enddesc

	@returns
	table: formatted message
	number: arguments "consumed"
]]
function i18n.format(unformatted, defColor, ...)
	local formatTable = luatype(defColor) == 'Color'
	defColor = defColor or color_white
	local argsPos = 1
	local searchPos = 1
	local output = {}
	local args = {...}

	if not formatTable then
		table.unshift(args, defColor)
	end

	local hit = true

	while hit and searchPos ~= #unformatted do
		hit = false

		local findBest, findBestCutoff, findBestFunc, findFormatter = 0x1000000, 0x1000000

		for formatter, funcCall in pairs(formatters) do
			local findNext, findCutoff = unformatted:find(formatter, searchPos, false)

			if findNext and findBest > findNext then
				hit = true
				findBest, findBestCutoff, findBestFunc, findFormatter = findNext, findCutoff, funcCall, formatter
			end
		end

		if findBestFunc then
			local slicePre = unformatted:sub(searchPos, findBest - 1)
			local count = i18n.countExpressions(slicePre)

			if count ~= 0 then
				table.insert(output, string.format(slicePre, unpack(args, argsPos, argsPos + count - 1)))
				argsPos = argsPos + count
			else
				table.insert(output, slicePre)
			end

			local ret, grabbed = findBestFunc(unformatted:sub(findBest, findBestCutoff), unpack(args, argsPos, #args))

			if ret then
				table.append(output, ret)

				if not IsColor(ret[#ret]) then
					table.insert(output, defColor)
				end
			end

			argsPos = argsPos + (grabbed or 1)
			searchPos = findBestCutoff + 1

			if searchPos == #unformatted then
				table.insert(output, unformatted[#unformatted])

				if formatTable then
					return output, argsPos - 1
				end

				local build = ''

				for i, arg in ipairs(output) do
					if type(arg) == 'string' then
						build = build .. arg
					end
				end

				return build, argsPos - 1
			end
		end
	end

	if searchPos ~= #unformatted then
		local slice = unformatted:sub(searchPos)
		local count = i18n.countExpressions(slice)

		if count ~= 0 then
			table.insert(output, string.format(slice, unpack(args, argsPos, argsPos + count - 1)))
			argsPos = argsPos + count
		else
			table.insert(output, slice)
		end
	end

	if formatTable then
		return output, argsPos - 1
	end

	local build = ''

	for i, arg in ipairs(output) do
		if type(arg) == 'string' then
			build = build .. arg
		end
	end

	return build, argsPos - 1
end

local function compileExpression(unformatted)
	local searchPos = 1
	local funclist = {}
	local hit = true

	while hit and searchPos ~= #unformatted do
		hit = false

		local findBest, findBestCutoff, findBestFunc, findFormatter = 0x1000000, 0x1000000

		for formatter, funcCall in pairs(formatters) do
			local findNext, findCutoff = unformatted:find(formatter, searchPos, false)

			if findNext and findBest > findNext then
				hit = true
				findBest, findBestCutoff, findBestFunc, findFormatter = findNext, findCutoff, funcCall, formatter
			end
		end

		if findBestFunc then
			local slicePre = unformatted:sub(searchPos, findBest - 1)
			local count = i18n.countExpressions(slicePre)

			if count ~= 0 then
				table.insert(funclist, function(...)
					return string.format(slicePre, ...), count
				end)
			else
				table.insert(funclist, slicePre)
			end

			table.insert(funclist, function(...)
				local ret, count = findBestFunc(unformatted:sub(findBest, findBestCutoff), ...)
				return ret, count or 1
			end)

			searchPos = findBestCutoff + 1

			if searchPos == #unformatted then
				table.insert(funclist, unformatted[#unformatted])
				break
			end
		end
	end

	if searchPos ~= #unformatted then
		local slice = unformatted:sub(searchPos)
		local count = i18n.countExpressions(slice)

		if count ~= 0 then
			table.insert(funclist, function(...)
				return string.format(slice, ...), count
			end)
		else
			table.insert(funclist, slice)
		end
	end

	return function(defColor, ...)
		defColor = defColor or color_white
		local output = {}
		local argsPos = 1
		local args = {...}

		for i, func in ipairs(funclist) do
			local ftype = type(func)

			if ftype == 'string' then
				table.insert(output, func)
			else
				local fret, fcount = func(unpack(args, argsPos, #args))
				local frettype = type(fret)

				if frettype == 'string' then
					table.insert(output, fret)
					argsPos = argsPos + fcount
				elseif frettype == 'table' then
					table.append(output, fret)

					if not IsColor(fret[#fret]) then
						table.insert(output, defColor)
					end

					argsPos = argsPos + fcount
				end
			end
		end

		return output, argsPos - 1
	end
end

--[[
	@doc
	@fname DLib.i18n.localizeByLang
	@args string phrase, string lang, vararg format

	@returns
	string: formatted message
]]
function i18n.localizeByLang(phrase, lang, ...)
	if not i18n.hashed[phrase] or i18n.DEBUG_LANG_STRINGS:GetBool() then
		return phrase
	end

	if i18n.hashedFunc[phrase] then
		local unformatted

		if lang == 'en' or not i18n.hashedLang[lang] then
			unformatted = i18n.hashedFunc[phrase] or nil
		else
			unformatted = i18n.hashedLangFunc[lang] and i18n.hashedLangFunc[lang][phrase] or i18n.hashedFunc[phrase] or nil
		end

		if not unformatted then
			return phrase
		end

		local status, formatted = pcall(unformatted, nil, ...)

		if status then
			local output = ''

			for i, value in ipairs(formatted) do
				if type(value) == 'string' then
					output = output .. value
				end
			end

			return output
		else
			return 'Format error: ' .. phrase .. ' ' .. formatted
		end
	end

	local unformatted

	if lang == 'en' or not i18n.hashedLang[lang] then
		unformatted = i18n.hashed[phrase] or phrase
	else
		unformatted = i18n.hashedLang[lang][phrase] or i18n.hashed[phrase] or phrase
	end

	local status, formatted = pcall(string.format, unformatted, ...)

	if status then
		return formatted
	else
		return 'Format error: ' .. phrase .. ' ' .. formatted
	end
end

--[[
	@doc
	@fname DLib.i18n.localizeByLangAdvanced
	@args string phrase, string lang, Color colorDef = color_white, vararg format

	@desc
	Supports colors from custom format arguments
	You don't want to use this unless you know that
	some of phrases can contain custom format arguments
	@enddesc

	@returns
	table: formatted message
	number: arguments "consumed"
]]
function i18n.localizeByLangAdvanced(phrase, lang, colorDef, ...)
	if luatype(colorDef) ~= 'Color' then
		return i18n._localizeByLangAdvanced(phrase, lang, color_white, ...)
	else
		return i18n._localizeByLangAdvanced(phrase, lang, colorDef, ...)
	end
end

function i18n._localizeByLangAdvanced(phrase, lang, colorDef, ...)
	if not i18n.hashed[phrase] or i18n.DEBUG_LANG_STRINGS:GetBool() then
		return {phrase}, 0
	end

	if i18n.hashedFunc[phrase] then
		local unformatted

		if lang == 'en' or not i18n.hashedLang[lang] then
			unformatted = i18n.hashedFunc[phrase] or nil
		else
			unformatted = i18n.hashedLangFunc[lang] and i18n.hashedLangFunc[lang][phrase] or i18n.hashedFunc[phrase] or nil
		end

		if not unformatted then
			return phrase
		end

		local status, formatted, cnum = pcall(unformatted, colorDef, ...)

		if status then
			return formatted, cnum
		else
			return {'Format error: ' .. phrase .. ' ' .. formatted}, 0
		end
	end

	local unformatted

	if lang == 'en' or not i18n.hashedLang[lang] then
		unformatted = i18n.hashed[phrase] or phrase
	else
		unformatted = i18n.hashedLang[lang][phrase] or i18n.hashed[phrase] or phrase
	end

	local status, formatted, cnum = pcall(string.format, unformatted, ...)

	if status then
		return {formatted}, i18n.countExpressions(unformatted)
	else
		return {'Format error: ' .. phrase .. ' ' .. formatted}, 0
	end
end

--[[
	@doc
	@fname DLib.i18n.countExpressions
	@args string str

	@returns
	number
]]
function i18n.countExpressions(str)
	local i = 0

	for line in str:gmatch('[%%][^%%]') do
		i = i + 1
	end

	return i
end

--[[
	@doc
	@fname DLib.i18n.registerPhrase
	@args string lang, string phrase, string unformatted

	@deprecated
	@internal

	@returns
	boolean: true
]]
function i18n.registerPhrase(lang, phrase, unformatted)
	local advanced = false

	for formatter, funcCall in pairs(formatters) do
		if unformatted:find(formatter) then
			advanced = true
			break
		end
	end

	if lang == 'en' then
		i18n.hashed[phrase] = unformatted
	else
		i18n.hashed[phrase] = i18n.hashed[phrase] or unformatted
		i18n.hashedLang[lang] = i18n.hashedLang[lang] or {}
		i18n.hashedLang[lang][phrase] = unformatted
	end

	if advanced then
		local fncompile = compileExpression(unformatted)

		if lang == 'en' then
			i18n.hashedFunc[phrase] = fncompile
		else
			i18n.hashedLangFunc[lang] = i18n.hashedLangFunc[lang] or {}
			i18n.hashedLangFunc[lang][phrase] = fncompile
		end
	else
		if lang == 'en' then
			i18n.hashedFunc[phrase] = nil
		else
			i18n.hashedLangFunc[lang] = i18n.hashedLangFunc[lang] or {}
			i18n.hashedLangFunc[lang][phrase] = nil
		end
	end

	if i18n.countExpressions(phrase) == 0 then
		if lang == 'en' then
			i18n.hashedNoArgs[phrase] = unformatted
		else
			i18n.hashedNoArgsLang[lang] = i18n.hashedNoArgsLang[lang] or {}
			i18n.hashedNoArgsLang[lang][phrase] = unformatted
		end
	else
		if lang == 'en' then
			i18n.hashedNoArgs[phrase] = nil
		else
			i18n.hashedNoArgsLang[lang] = i18n.hashedNoArgsLang[lang] or {}
			i18n.hashedNoArgsLang[lang][phrase] = nil
		end
	end

	return true
end

--[[
	@doc
	@fname DLib.i18n.localize
	@args string phrase, vararg format

	@returns
	string: formatted message
]]
function i18n.localize(phrase, ...)
	return i18n.localizeByLang(phrase, i18n.CURRENT_LANG, ...)
end

--[[
	@doc
	@fname DLib.i18n.localizeAdvanced
	@args string phrase, Color colorDef = color_white, vararg format

	@desc
	Supports colors from custom format arguments
	You don't want to use this unless you know that
	some of phrases can contain custom format arguments
	@enddesc

	@returns
	table: formatted message
	number: arguments "consumed"
]]
function i18n.localizeAdvanced(phrase, colorDef, ...)
	if luatype(colorDef) ~= 'Color' then
		return i18n.localizeByLang(phrase, i18n.CURRENT_LANG, nil, ...)
	else
		return i18n.localizeByLang(phrase, i18n.CURRENT_LANG, colorDef, ...)
	end
end

--[[
	@doc
	@fname DLib.i18n.getRaw
	@args string phrase

	@returns
	string: or nil
]]
function i18n.getRaw(phrase)
	return i18n.getRawByLang(phrase, i18n.CURRENT_LANG)
end

--[[
	@doc
	@fname DLib.i18n.getRaw2
	@args string phrase

	@returns
	string: or nil
]]
function i18n.getRaw2(phrase)
	return i18n.getRawByLang2(phrase, i18n.CURRENT_LANG)
end


--[[
	@doc
	@fname DLib.i18n.getRawByLang
	@args string phrase, string lang

	@returns
	string: or nil
]]
function i18n.getRawByLang(phrase, lang)
	return i18n.hashedLang[lang] and i18n.hashedLang[lang][phrase] or i18n.hashed[phrase]
end

--[[
	@doc
	@fname DLib.i18n.getRawByLang2
	@args string phrase, string lang

	@returns
	string: or nil
]]
function i18n.getRawByLang2(phrase, lang)
	return i18n.hashedLang[lang] and i18n.hashedLang[lang][phrase] or i18n.hashedLang[phrase] and i18n.hashedLang[phrase][lang] or i18n.hashed[phrase]
end

--[[
	@doc
	@fname DLib.i18n.phrasePresent
	@alias DLib.i18n.exists
	@alias DLib.i18n.phraseExists
	@args string phrase

	@returns
	boolean
]]
function i18n.phrasePresent(phrase)
	return i18n.hashed[phrase] ~= nil
end

--[[
	@doc
	@fname DLib.i18n.safePhrase
	@args string phrase

	@returns
	boolean
]]
function i18n.safePhrase(phrase)
	return i18n.hashedNoArgs[phrase] ~= nil
end

i18n.exists = i18n.phrasePresent
i18n.phraseExists = i18n.phrasePresent

local table = table
local type = type

--[[
	@doc
	@fname DLib.i18n.rebuildTable
	@args table args, Color colorDef = color_white, boolean backward = false

	@desc
	when `backward` is `true`, table will be constructed from it's end. This means that when a phrase require
	format arguments, it's arguments can be localized too (recursive localization)
	`'info.i18n.phrase_with_two_format_values', 'Player', 'info.i18n.phrase'`
	will localize both `info.i18n.phrase_with_two_format_values` and `info.i18n.phrase`
	in case if `info.i18n.phrase_with_two_format_values` hold two format values (e.g. `'%s was %s'`)
	`false` = `'Player was info.i18n.phrase'`
	`true` = `'Player was looking at phrase'`
	@enddesc

	@returns
	table: a table with localized strings. other types are untouched. does not modify original table
]]
function i18n.rebuildTable(args, colorDef, backward)
	return i18n.rebuildTableByLang(args, i18n.CURRENT_LANG, colorDef, backward)
end

--[[
	@doc
	@fname DLib.i18n.rebuildTableByLang
	@args table args, string lang, Color colorDef = color_white, boolean backward = false

	@desc
	when `backward` is `true`, table will be constructed from it's end. This means that when a phrase require
	format arguments, it's arguments can be localized too (recursive localization)
	`'info.i18n.phrase_with_two_format_values', 'Player', 'info.i18n.phrase'`
	will localize both `info.i18n.phrase_with_two_format_values` and `info.i18n.phrase`
	in case if `info.i18n.phrase_with_two_format_values` hold two format values (e.g. `'%s was %s'`)
	`false` = `'Player was info.i18n.phrase'`
	`true` = `'Player was looking at phrase'`
	@enddesc

	@returns
	table: a table with localized strings. other types are untouched. does not modify original table
]]
function i18n.rebuildTableByLang(args, lang, colorDef, backward)
	if backward == nil then backward = false end
	local rebuild
	local i = backward and #args or 1

	if backward then
		rebuild = table.qcopy(args)

		while i > 0 do
			local arg = rebuild[i]
			local index = #rebuild - i

			if type(arg) ~= 'string' or not i18n.exists(arg) then
				i = i - 1
			else
				local phrase, consumed = i18n.localizeByLangAdvanced(arg, lang, colorDef, unpack(rebuild, i + 1, #rebuild))
				table.splice(rebuild, i, consumed + 1, unpack(phrase, 1, #phrase))
				i = i - 1 - consumed
			end
		end
	else
		rebuild = {}

		while i <= #args do
			local arg = args[i]

			if type(arg) ~= 'string' or not i18n.exists(arg) then
				table.insert(rebuild, arg)
				i = i + 1
			else
				local phrase, consumed = i18n.localizeByLangAdvanced(arg, lang, colorDef, unpack(args, i + 1, #args))
				i = i + 1 + consumed
				table.append(rebuild, phrase)
			end
		end
	end

	return rebuild
end
