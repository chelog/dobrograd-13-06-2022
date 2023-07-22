
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


local Lerp = Lerp
local math = math

local function Lerp(t, a, b)
	return a + (b - a) * t
end

--[[
	@doc
	@fname LerpQuintic
	@args T t, T from, T to

	@returns
	T: lerped value
]]
function _G.LerpQuintic(t, a, b)
	if t < 0 then return a end
	if t >= 1 then return b end
	local value = t * t * t * (t * (t * 6 - 15) + 10)
	return Lerp(value, a, b)
end

--[[
	@doc
	@fname Quintic
	@args T t

	@returns
	T
]]
function _G.Quintic(t)
	return t * t * t * (t * (t * 6 - 15) + 10)
end

--[[
	@doc
	@fname LerpCosine
	@args T t, T from, T to

	@returns
	T: lerped value
]]
function _G.LerpCosine(t, a, b)
	if t < 0 then return a end
	if t >= 1 then return b end
	local value = (1 - math.cos(t * math.pi)) / 2
	return Lerp(value, a, b)
end

--[[
	@doc
	@fname Cosine
	@args T t

	@returns
	T
]]
function _G.Cosine(t)
	return (1 - math.cos(t * math.pi)) / 2
end

--[[
	@doc
	@fname LerpSinusine
	@args T t, T from, T to

	@returns
	T: lerped value
]]
function _G.LerpSinusine(t, a, b)
	if t < 0 then return a end
	if t >= 1 then return b end
	local value = (1 - math.sin(t * math.pi)) / 2
	return Lerp(value, a, b)
end

--[[
	@doc
	@fname Sinusine
	@args T t

	@returns
	T
]]
function _G.Sinusine(t)
	return (1 - math.sin(t * math.pi)) / 2
end

--[[
	@doc
	@fname LerpCubic
	@args T t, T from, T to

	@returns
	T: lerped value
]]
function _G.LerpCubic(t, a, b)
	if t < 0 then return a end
	if t >= 1 then return b end
	local value = -2 * t * t * t + 3 * t * t
	return Lerp(value, a, b)
end

--[[
	@doc
	@fname Cubic
	@args T t

	@returns
	T
]]
function _G.Cubic(t)
	return -2 * t * t * t + 3 * t * t
end
