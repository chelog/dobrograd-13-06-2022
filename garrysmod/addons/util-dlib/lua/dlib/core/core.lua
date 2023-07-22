
--
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


local meta = debug.getmetatable(1) or {}
local math = math
meta.MetaName = 'number'

--[[
	@doc
	@fname number:__index
	@args any key

	@returns
	function: associated function in math or bit table
]]
function meta:__index(key)
	return meta[key] or math[key] or bit[key]
end

--[[
	@doc
	@fname number:IsValid

	@returns
	boolean: false
]]
function meta:IsValid()
	return false
end

local funcs = {}

for k, v in pairs(math) do
	funcs[k:sub(1, 1):lower() .. k:sub(2)] = v
end

for k, v in pairs(funcs) do
	if math[k] == nil then
		math[k] = v
	end
end

debug.setmetatable(1, meta)

--[[
	@doc
	@fname net.pool
	@args string netname

	@desc
	alias of !g:util.AddNetworkString
	@enddesc

	@returns
	number: created net ID
]]
net.pool = util.AddNetworkString

--[[
	@doc
	@fname net.receive
	@args string netname, function handler

	@desc
	alias of !g:net.Receive
	@enddesc
]]
net.receive = net.Receive

--[[
	@doc
	@fname file.mkdir
	@args string dirname

	@desc
	alias of !g:file.CreateDir
	@enddesc
]]
file.mkdir = file.CreateDir
