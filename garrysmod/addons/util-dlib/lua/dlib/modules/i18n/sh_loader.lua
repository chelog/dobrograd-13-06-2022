
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


local filesLoad = {}
local i18n = i18n
local file = file
local ipairs = ipairs
local pairs = pairs
local table = table
local ProtectedCall = ProtectedCall
local getfenv = getfenv

--[[
	@doc
	@fname DLib.i18n.reload
	@internal
]]
function i18n.reload(module)
	if not module then
		local _, dirs = file.Find('dlib/i18n/*', 'LUA')

		for i, dir in ipairs(dirs) do
			i18n.reload(dir)
		end

		return
	end

	local files = file.Find('dlib/i18n/' .. module .. '/*.lua', 'LUA')

	for i2, luafile in ipairs(files) do
		-- if luafile:sub(-4) == '.lua' then
			AddCSLuaFile('dlib/i18n/' .. module .. '/' .. luafile)
			i18n.executeFile(luafile:sub(1, -5), 'dlib/i18n/' .. module .. '/' .. luafile)
		-- end
	end
end

--[[
	@doc
	@fname DLib.i18n.executeFile
	@args string langSpace, string filePath
	@internal
	@returns
	boolean
]]
function i18n.executeFile(langSpace, fileToRun)
	return i18n.executeFunction(langSpace, CompileFile(fileToRun))
end

local createNamedTable
local setmetatable = setmetatable
local mt = getmetatable

local tableMeta = {
	__index = function(self, key)
		if type(key) ~= 'string' then
			error('You can only use strings as indexes')
		end

		local value = rawget(self, key)
		if value ~= nil then return value end
		local newTable = createNamedTable(key, self)
		rawset(self, key, newTable)
		return newTable
	end,

	__newindex = function(self, key, value)
		if type(value) == 'table' then
			error("You don't have to define tables!")
		end

		if type(key) ~= 'string' then
			error('You can only use strings as indexes')
		end

		if type(value) == 'number' then
			value = value:tostring()
		end

		if type(value) ~= 'string' then
			error('You can only define strings')
		end

		local parent = mt(self).__parent
		local build = mt(self).__name .. '.' .. key

		while parent do
			build = mt(parent).__name .. '.' .. build
			parent = mt(parent).__parent
		end

		rawset(self, key, value)
		i18n.registerPhrase(mt(self).__lang, build, value)
	end
}

function createNamedTable(tableName, parent)
	local output = {}
	local meta = {
		__index = tableMeta.__index,
		__newindex = tableMeta.__newindex,
		__parent = parent,
		__name = tableName,
		__lang = i18n.LANG_SPACE
	}

	return setmetatable(output, meta)
end

local defaultNames = {
	'gui', 'attack', 'death', 'reason', 'command',
	'click', 'info', 'message', 'err', 'warning',
	'tip', 'player', 'help'
}

local function __indexEnv(self, key)
	local value = rawget(self, key)

	if value ~= nil then
		return value
	end

	value = getfenv(0)[key]

	if value ~= nil then
		return getfenv(0)[key]
	end

	local newTable = createNamedTable(key)
	rawset(self, key, newTable)
	return newTable
end

local function __newIndexEnv(self, key, value)
	getfenv(0)[key] = value
end

local function protectedFunc(langSpace, funcToRun)
	local envToRun = {
		LANGUAGE = langSpace
	}

	local namespace = {}

	for i, def in ipairs(defaultNames) do
		namespace[def] = createNamedTable(def)
	end

	for key, value in pairs(namespace) do
		envToRun[key] = value
	end

	envToRun.NAMESPACE = namespace
	envToRun.LANG_NAMESPACE = namespace
	envToRun.LANGUAGE_NAMESPACE = namespace

	setmetatable(envToRun, {
		__index = __indexEnv,
		__newindex = __newIndexEnv,
		__lang = langSpace,
		__space = namespace
	})

	local oldenv = getfenv(funcToRun)
	setfenv(funcToRun, envToRun)

	ProtectedCall(funcToRun)

	if oldenv then
		setfenv(funcToRun, oldenv)
	end
end

--[[
	@doc
	@fname DLib.i18n.executeFunction
	@args string langSpace, function toRun
	@internal

	@returns
	boolean
]]
function i18n.executeFunction(langSpace, funcToRun)
	i18n.LANG_SPACE = langSpace
	local status = ProtectedCall(protectedFunc:Wrap(langSpace, funcToRun))
	i18n.LANG_SPACE = nil

	return status
end
