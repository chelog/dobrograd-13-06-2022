
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

jit.on()

local util = setmetatable(DLib.util or {}, {__index = util})
DLib.util = util
local DLib = DLib
local vgui = vgui
local type = luatype
local ipairs = ipairs
local IsValid = IsValid
local LVector = LVector
local Vector = Vector
local Angle = Angle

if CLIENT then
	concommand.Add('dlib_gui_openurl', function(_, _, args)
		return gui.OpenURL(table.concat(args, '%20'))
	end)
end

--[[
	@doc
	@fname DLib.VCreate
	@args string panelName, Panel parent

	@desc
	!g:vgui.Create but does not create panel when parent is not present
	@enddesc

	@returns
	Panel: created panel
]]
function DLib.VCreate(pnlName, pnlParent)
	if not IsValid(pnlParent) then
		DLib.Message(debug.traceback('Attempt to create ' .. pnlName .. ' without valid parent!', 2))
		return
	end

	return vgui.Create(pnlName, pnlParent)
end

--[[
	@doc
	@fname DLib.util.Clone
	@args any variable

	@desc
	creates better copy of variable.
	can clone tables better than !g:table.Copy
	**NOT RECURSION SAFE**
	**will attempt to throw an error when encounters a recursion**
	@enddesc

	@returns
	any: clone
]]
function util.copy(var)
	if type(var) == 'table' then
		local output = {}

		for k, v in pairs(var) do
			if k == var or v == var then
				error('Confused by recursion')
			end

			output[util.Copy(k)] = util.Copy(v)
		end

		return output
	end

	if type(var) == 'Angle' then return Angle(var.p, var.y, var.r) end
	if type(var) == 'Vector' then return Vector(var) end
	if type(var) == 'LVector' then return LVector(var) end
	return var
end

util.clone = util.copy
util.Clone = util.copy
util.Copy = util.copy

--[[
	@doc
	@fname DLib.util.VectorRand
	@alias DLib.util.RandomVector
	@args number x, number y, number z

	@desc
	calls math.Rand(-component, component) for each component
	@enddesc

	@returns
	Vector
]]
function util.randomVector(mx, my, mz)
	return Vector(math.Rand(-mx, mx), math.Rand(-my, my), math.Rand(-mz, mz))
end

util.RandomVector = util.randomVector
util.VectorRand = util.randomVector

--[[
	@doc
	@fname DLib.util.ComposeEnums
	@args table input, vararg ...numbers

	@desc
	:bor()'s numbers in `input` and :bor()'s numbers in vararg towards newly created value
	@enddesc

	@returns
	number
]]
function util.composeEnums(input, ...)
	local num = 0

	if type(input) == 'table' then
		for k, v in ipairs(input) do
			num = num:bor(v)
		end
	else
		num = input
	end

	return num:bor(...)
end

util.ComposeEnums = util.composeEnums

--[[
	@doc
	@fname DLib.util.ValidateSteamID
	@args string steamid

	@returns
	boolean: whenever string provided is regular steamid (STEAM_0)
]]
function util.ValidateSteamID(input)
	if not input then return false end
	return input:match('STEAM_0:[0-1]:[0-9]+$') ~= nil
end

--[[
	@doc
	@fname DLib.util.SteamLink
	@args string steamid

	@desc
	accepts steamid and steamid64
	@enddesc

	@returns
	string
]]
function util.SteamLink(steamid)
	if util.ValidateSteamID(steamid) then
		return 'https://steamcommunity.com/profiles/' .. util.SteamIDTo64(steamid) .. '/'
	else
		return 'https://steamcommunity.com/profiles/' .. steamid .. '/'
	end
end

--[[
	@doc
	@fname DLib.util.CreateSharedConvar
	@args string cvarname, string cvardef, string description

	@desc
	quick way to workaround [this](https://github.com/Facepunch/garrysmod-issues/issues/3323)
	adds `FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY` flags serverside and only `FCVAR_REPLICATED` clientside
	@enddesc

	@returns
	ConVar
]]
function util.CreateSharedConvar(cvarname, cvarvalue, description)
	if CLIENT then
		return CreateConVar(cvarname, cvarvalue, {FCVAR_REPLICATED}, description)
	else
		return CreateConVar(cvarname, cvarvalue, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, description)
	end
end

-- Replace PrintTable with something better

local rawtype = rawtype
local table = table
local error = error
local pcall = pcall
local debug = debug
local strict = false

local RECURSION_COLOR = Color(195, 222, 69)
local TOO_DEEP_COLOR = Color(196, 158, 91)
local EQUALS_COLOR = Color(169, 117, 222)
local TABLE_TOKEN_COLOR = Color(197, 104, 111)
local COMMENTARY_COLOR = Color(143, 165, 46)

DLib._OldPrintTable = DLib._OldPrintTable or PrintTable

local wellknown, prints
local unmap = {}

for i = 0, 16 do
	unmap[string.char(i)] = '\\x' .. string.format('%.2X', i)
end

local function getValueString(typeIn, valueIn)
	if typeIn == 'string' then
		return DLib.DEFAULT_TEXT_COLOR, '"' .. valueIn:gsub('"', '\\"'):gsub('\t', '\\t'):gsub('\n', '\\n'):gsub('.', function(str) return unmap[str] or str end) .. '"'
	end

	return DLib.GetPrettyPrint(valueIn, typeIn)
end

function util.PrintableString(valueIn)
	return valueIn:gsub('"', '\\"'):gsub('\t', '\\t'):gsub('\n', '\\n'):gsub('.', function(str) return unmap[str] or str end), nil
end

local comparableTypes = {}

local function InternalPrintLoop(tableIn, level, recursionCheck)
	if prints > 100000 then
		error('I dont want to print more. Probably hit a recursion.')
	end

	if strict then
		if wellknown[tableIn] then
			MsgC(RECURSION_COLOR, ' [well known/recursion] ')
			return false
		end
	else
		if wellknown[tableIn] and wellknown[tableIn] > 6 then
			MsgC(RECURSION_COLOR, ' [well known] ')
			return false
		end

		if recursionCheck and recursionCheck[tableIn] then
			MsgC(RECURSION_COLOR, ' [recursion] ')
			return false
		end
	end

	if level > 10 then
		MsgC(TOO_DEEP_COLOR, ' [too deep] ')
		return false
	end

	local keys = {}

	for k in pairs(tableIn) do
		table.insert(keys, k)
	end

	table.sort(keys, function(a, b)
		local ta, tb = type(a), type(b)
		local cmp = false
		local token = ta .. '-' .. tb

		if comparableTypes[token] == nil then
			comparableTypes[token] = pcall(function()
				cmp = a < b
			end)
		elseif comparableTypes[token] then
			cmp = a < b
		end

		return cmp
	end)

	wellknown[tableIn] = (wellknown[tableIn] or 0) + 1

	local hitAnything = false

	for i, key in ipairs(keys) do
		prints = prints + 1

		if not hitAnything then
			MsgC('\n')
			hitAnything = true
		end

		local ktp = type(key)
		MsgC(string.rep(' ', level * 4), TABLE_TOKEN_COLOR, '[')
		MsgC(getValueString(ktp, key))
		MsgC(TABLE_TOKEN_COLOR, ']', EQUALS_COLOR, ' = ')
		local value = tableIn[key]

		if type(value) == 'table' then
			MsgC(TABLE_TOKEN_COLOR, '{')
			local useSpaces = InternalPrintLoop(value, level + 1, strict and '' or recursionCheck or {})

			if useSpaces then
				MsgC(TABLE_TOKEN_COLOR, string.rep(' ', level * 4), '},\n')
			else
				MsgC(TABLE_TOKEN_COLOR, '},\n')
			end
		else
			local tp = type(value)
			MsgC(getValueString(tp, value))
			MsgC(TABLE_TOKEN_COLOR, ',\n')
		end
	end

	if not hitAnything then
		MsgC(COMMENTARY_COLOR, ' --[[ empty ]] ')
	end

	return hitAnything
end

--[[
	@doc
	@fname PrintTable
	@replaces
	@args table value

	@desc
	pretty prints a table.
	attempts to avoid recursion.
	@enddesc
]]
function _G.PrintTable(tableIn)
	assert(rawtype(tableIn) == 'table', 'Input must be a table!')
	wellknown = {}
	prints = 0
	strict = false
	MsgC(TABLE_TOKEN_COLOR, '{')
	InternalPrintLoop(tableIn, 1)
	MsgC(TABLE_TOKEN_COLOR, '}\n')
end

--[[
	@doc
	@fname PrintTableStrict
	@args table value

	@desc
	pretty prints a table.
	strictly avoids any meaning of recursion.
	@enddesc
]]
function _G.PrintTableStrict(tableIn)
	assert(rawtype(tableIn) == 'table', 'Input must be a table!')
	wellknown = {}
	prints = 0
	strict = true
	MsgC(TABLE_TOKEN_COLOR, '{')
	InternalPrintLoop(tableIn, 1)
	MsgC(TABLE_TOKEN_COLOR, '}\n')
end

local files = file.Find('scripts/weapons/*.txt', 'GAME')
local wepdata = {}

for i, mfile in ipairs(files) do
	local parsed = util.KeyValuesToTable(file.Read('scripts/weapons/' .. mfile, 'GAME'))

	if parsed then
		wepdata[mfile:sub(1, -5)] = parsed
	end
end

if CLIENT then
	for wepclass, data in pairs(wepdata) do
		if data.texturedata then
			if data.texturedata.weapon and data.texturedata.weapon.file then
				data.texturedata.weapon.material = Material(data.texturedata.weapon.file)
			end

			if data.texturedata.weapon_s and data.texturedata.weapon_s.file then
				data.texturedata.weapon_s.material = Material(data.texturedata.weapon_s.file)
			end

			if data.texturedata.ammo and data.texturedata.ammo.file then
				data.texturedata.ammo.material = Material(data.texturedata.ammo.file)
			end

			if data.texturedata.ammo2 and data.texturedata.ammo2.file then
				data.texturedata.ammo2.material = Material(data.texturedata.ammo2.file)
			end
		end
	end
end

--[[
	@doc
	@fname DLib.util.GetWeaponScript
	@args Weapon weaponIn

	@returns
	table: or nil, if no script present
]]
function DLib.util.GetWeaponScript(weaponIn)
	if isstring(weaponIn) then
		return wepdata[weaponIn]
	elseif type(weaponIn) == 'Weapon' then
		return wepdata[weaponIn:GetClass()]
	else
		error('Invalid weapon provided: ' .. type(weaponIn))
	end
end

--[[
	@doc
	@fname printflags
	@args number flags, number minimumDecimals = 0

	@returns
	string: formatted
]]
function _G.printflags(flagsIn, mnum)
	assert(type(flagsIn) == 'number', 'flagsIn must be a number')
	mnum = mnum or 0
	local format = ''

	if flagsIn < 0 then
		flagsIn = flagsIn + 0xFFFFFFFF
	end

	flagsIn = flagsIn:floor()

	while flagsIn > 0 do
		local div = flagsIn % 2
		flagsIn = (flagsIn - div) / 2
		format = div .. format
	end

	if #format < mnum then
		format = string.rep('0', mnum - #format) .. format
	end

	print(format)
	return format
end
