
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


local GetConVar = GetConVar

--[[
	@doc
	@fname ConVar
	@args vararg arguments

	@desc
	alias of !g:GetConVar
	@enddesc

	@returns
	ConVar: returned object
]]
function _G.ConVar(...)
	return GetConVar(...)
end

local ConVar = FindMetaTable('ConVar')
local math = math
local error = error
local RunConsoleCommand = RunConsoleCommand

--[[
	@doc
	@fname ConVar:GetByType
	@args type string, vargarg arguments

	@desc
	valid types are:

	`'string'`
	`'int'`
	`'integer'`
	`'number'`
	`'uint'`
	`'uinteger'`
	`'unumber'`
	`'float'`
	`'bool'`
	`'boolean'`

	@enddesc

	@returns
	any: returned value
]]
function ConVar:GetByType(typeIn, ...)
	if typeIn == 'string' then
		return self:GetString(...)
	elseif typeIn == 'int' or typeIn == 'integer' or typeIn == 'number' then
		return self:GetInt(...)
	elseif typeIn == 'uint' or typeIn == 'uinteger' or typeIn == 'unumber' then
		return self:GetInt(...):max(0)
	elseif typeIn == 'float' then
		return self:GetFloat(...)
	elseif typeIn == 'bool' or typeIn == 'boolean' then
		return self:GetBool(...)
	else
		error('Unknown variable type - ' .. typeIn .. '!')
	end
end

function ConVar:Reset()
	local default = self:GetDefault()
	RunConsoleCommand(self:GetName(), default)
	return default
end
