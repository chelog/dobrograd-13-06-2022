
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


local DLib = DLib
DLib.fnlib = {}

local rawequal = rawequal
local error = error
local fnlib = DLib.fnlib
local meta = debug.getmetatable(function() end) or {}

meta.MetaName = 'function'

--[[
	@doc
	@fname function:__index
	@args any key

	@returns
	any: associated value (probably a function) in funclib
]]

--[[
	@doc
	@fname nil:__index
	@args any key

	@desc
	function throws an error at all times upon call
	nil seems to have the same metatable as function
	@enddesc
]]
function meta:__index(key)
	if rawequal(self, nil) then
		local i = 1
		local lasts, lastsAll = {}, {}

		while true do
			local name, value = debug.getlocal(2, i)
			if name == nil then break end
			i = i + 1

			if value == nil then
				table.insert(lastsAll, name)

				if name ~= '(*temporary)' then
					table.insert(lasts, name)
				end
			end
		end

		if #lasts == 0 and #lastsAll ~= 0 then
			error(string.format('attempt to index field %q of a nil value (bytecode local variable)', key), 2)
		elseif #lasts == 0 and #lastsAll == 0 then
			error(string.format('attempt to index field %q of a nil value (unable to detect)', key), 2)
		elseif #lasts == 1 then
			error(string.format('attempt to index field %q of a nil value (probably %s?)', key, lasts[1]), 2)
		elseif #lasts <= 4 then
			error(string.format('attempt to index field %q of a nil value (%i possibilities: %s)', key, #lasts, table.concat(lasts, ', ')), 2)
		else
			local things = {}

			for i = #lasts - 4, #lasts do
				table.insert(things, lasts[i])
			end

			if #lastsAll ~= #lasts then
				error(string.format('attempt to index field %q of a nil value (%i possibilities + bytecode local variables, probably %s)', key, #lasts, table.concat(things, ', ')), 2)
			else
				error(string.format('attempt to index field %q of a nil value (%i possibilities, probably %s)', key, #lasts, table.concat(things, ', ')), 2)
			end
		end
	end

	local val = meta[key]

	if val ~= nil then
		return val
	end

	return fnlib[key]
end

local function genError(reason)
	return function(self, target)
		if type(self) == type(target) then
			local format = string.format('%s (both sides are %s values)', reason:format(type(self)), type(self))
			error(format, 2)
		elseif type(self) == 'function' or type(self) == 'nil' then
			local format = string.format('%s (left side of expression is a %s, right side is a %s)', reason:format(type(self)), type(self), type(target))
			error(format, 2)
		end

		local format = string.format('%s (left side of expression is a %s, right side is a %s)', reason:format(type(nil)), type(self), type(target))
		error(format, 2)
	end
end

meta.__unm = genError('attempt to unary minus a %s value')
meta.__add = genError('attempt to add a %s value')
meta.__sub = genError('attempt to substract a %s value')
meta.__mul = genError('attempt to multiply a %s value')
meta.__div = genError('attempt to divide a %s value')
meta.__mod = genError('attempt to modulo a %s value')
meta.__pow = genError('attempt to involute a %s value')
meta.__concat = genError('attempt to concat a %s value')
meta.__lt = genError('attempt to compare (<) a %s value(s)')
meta.__le = genError('attempt to compare (<=) a %s value(s)')

--[[
	@doc
	@fname function:IsValid

	@returns
	boolean: false
]]
function meta:IsValid()
	return false
end

debug.setmetatable(function() end, meta)

local unpack = unpack
local table = table

-- Falco's FN Lib implementation
-- in a greater™ way

--[[
	@doc
	@fname function:SingleWrap
	@args vararg prepend

	@desc
	makes a function which on call calls `self` with `prepend` arguments unpacked
	@enddesc

	@returns
	function: a function to call
]]
function fnlib:SingleWrap(...)
	local args = {...}

	return function()
		return self(unpack(args))
	end
end

--[[
	@doc
	@fname function:Wrap
	@args vararg prepend
	@alias function:fp
	@alias function:Partial

	@desc
	makes a function which on call calls `self` with `prepend` arguments unpacked,
	and passing extra arguments passed to packer on call
	@enddesc

	@returns
	function: a function to call
]]
function fnlib:Wrap(...)
	local args = {...}

	return function(...)
		local copy = table.qcopy(args)
		local args2 = table.append(copy, {...})
		return self(unpack(args2))
	end
end

-- ???
fnlib.fp = fnlib.Wrap
fnlib.Partial = fnlib.Wrap

--[[
	@doc
	@fname function:FlipFull
	@args vararg prepend

	@desc
	packs `self` and on call of returned function flips order of passed arguments
	@enddesc

	@returns
	function: a function to call
]]
function fnlib:FlipFull(...)
	local args = {...}

	return function(...)
		local copy = table.qcopy(args)
		local args2 = table.append(args2, {...})
		return self(unpack(table.flip(args2)))
	end
end

--[[
	@doc
	@fname function:Flip

	@desc
	packs a function and flips it's first two arguments (further are untouched)
	@enddesc

	@returns
	function: a function to call
]]
function fnlib:Flip()
	return function(a, b, ...)
		return self(b, a, ...)
	end
end

--[[
	@doc
	@fname function:Id
	@args vararg arguments

	@returns
	function: self
	vararg: arguments
]]
function fnlib:Id(...)
	return self, ...
end

-- func:Compose(func2, func3, func4) ->
-- func(func2(func3(func4(...))))

local select = select
local type = type

local function Compose(currentFunc, nextFunc, ...)
	if nextFunc == nil then return currentFunc end

	nextFunc = Compose(nextFunc, ...)

	return function(...)
		return currentFunc(nextFunc(...))
	end
end


--[[
	@doc
	@fname function:Compose
	@args function tableOfOrList
	@alias function:fc

	@desc
	packs all functions to be called in chain. `func1:Compose(func2, func3, func4) -> func1(func2(func3(func4(arguments passed))))`
	@enddesc

	@returns
	function: a function to call
]]
function fnlib:Compose(funcList, ...)
	if type(funcList) == 'table' then
		return Compose(self, unpack(funcList))
	else
		return Compose(self, funcList, ...)
	end
end

fnlib.fc = fnlib.Compose


--[[
	@doc
	@fname function:ReverseArgs
	@args vararg arguments

	@returns
	vararg: flipped arguments list. same as `unpack(table.flip({...}))`
]]
function fnlib:ReverseArgs(...)
	return unpack(table.flip({...}))
end

--[[
	@doc
	@fname function:Apply
	@args vararg arguments

	@returns
	function: a function to call
]]
function fnlib:Apply(...)
	return self(...)
end

for k, v in pairs(fnlib) do
	fnlib[k:sub(1, 1):lower() .. k:sub(2)] = v
end
