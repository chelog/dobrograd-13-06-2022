
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


if SERVER then return end

local render = render
local assert = assert
local type = type
local table = table
local debug = debug

-- nope, nu stack object, because util.Stack() sux
local stack = {}

--[[
	@doc
	@fname render.PushScissorRect
	@args number x, number y, number xEnd, number yEnd

	@desc
	stack based version of !g:render.SetScissorRect
	@enddesc
]]
function render.PushScissorRect(x, y, xEnd, yEnd)
	x = assert(type(x) == 'number' and x, 'x must be a number!')
	y = assert(type(y) == 'number' and y, 'y must be a number!')
	xEnd = assert(type(xEnd) == 'number' and xEnd, 'xEnd must be a number!')
	yEnd = assert(type(yEnd) == 'number' and yEnd, 'xEnd must be a number!')
	local amount = #stack

	if amount ~= 0 then
		local x2, y2, xEnd2, yEnd2 = stack[amount - 3], stack[amount - 2], stack[amount - 1], stack[amount]

		x = x2:max(x)
		y = y2:max(y)
		xEnd = xEnd2:min(xEnd)
		yEnd = yEnd2:min(yEnd)
	end

	table.insert(stack, x)
	table.insert(stack, y)
	table.insert(stack, xEnd)
	table.insert(stack, yEnd)
	render.SetScissorRect(x, y, xEnd, yEnd, true)
end

--[[
	@doc
	@fname render.PopScissorRect

	@desc
	stack based version of !g:render.SetScissorRect
	@enddesc
]]
function render.PopScissorRect()
	if #stack == 0 then
		render.SetScissorRect(0, 0, 0, 0, false)
		return
	end

	if #stack == 4 then
		table.remove(stack)
		table.remove(stack)
		table.remove(stack)
		table.remove(stack)
		render.SetScissorRect(0, 0, 0, 0, false)
		return
	end

	table.remove(stack)
	table.remove(stack)
	table.remove(stack)
	table.remove(stack)
	local amount = #stack
	local x, y, xEnd, yEnd = stack[amount - 3], stack[amount - 2], stack[amount - 1], stack[amount]
	render.SetScissorRect(x, y, xEnd, yEnd, true)
end

local function PreRender()
	if #stack ~= 0 then
		stack = {}
	end
end

hook.Add('PreRender', 'render.PushScissorRect', PreRender)
