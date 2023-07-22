
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


local LocalPlayer = LocalPlayer
local IsValid = FindMetaTable('Entity').IsValid
local NULL = NULL

--[[
	@doc
	@fname LocalWeapon
	@alias ActiveWeapon
	@alias GetActiveWeapon

	@returns
	Weapon: which player currently hold in hands or NULL
]]
local function LocalWeapon()
	local ply = LocalPlayer()
	if not IsValid(ply) then return NULL end
	local weapon = ply:GetActiveWeapon()
	if not IsValid(weapon) then return NULL end
	return weapon
end

--[[
	@doc
	@fname LocalViewModel
	@alias LocalViewmodel

	@returns
	Entity
]]
function _G.LocalViewModel(...)
	local ply = LocalPlayer()
	if not IsValid(ply) then return NULL end
	return ply:GetViewModel(...)
end

_G.LocalViewmodel = LocalViewModel

--[[
	@doc
	@fname LocalHands
	@alias LocalArms

	@returns
	Entity
]]
function _G.LocalHands(...)
	local ply = LocalPlayer()
	if not IsValid(ply) then return NULL end
	return ply:GetHands(...)
end

_G.LocalArms = LocalHands

--[[
	@doc
	@fname LocalEyeTrace

	@returns
	table: !g:TraceResult or `false`
]]
function _G.LocalEyeTrace(...)
	local ply = LocalPlayer()
	if not IsValid(ply) then return false end
	return ply:GetEyeTrace(...)
end

local LocalEyeTrace = LocalEyeTrace

--[[
	@doc
	@fname LocalLookingAt

	@returns
	Entity: or NULL
]]
function _G.LocalLookingAt(...)
	local tr = LocalEyeTrace(...)
	if not tr then return NULL end
	return tr.Entity or NULL
end

--[[
	@doc
	@fname LocalClip1

	@returns
	number
]]
function _G.LocalClip1()
	local weapon = LocalWeapon()
	if not IsValid(weapon) then return -1 end
	return weapon:Clip1()
end

--[[
	@doc
	@fname LocalClip2

	@returns
	number
]]
function _G.LocalClip2()
	local weapon = LocalWeapon()
	if not IsValid(weapon) then return -1 end
	return weapon:Clip2()
end

--[[
	@doc
	@fname LocalMaxClip1

	@returns
	number
]]
function _G.LocalMaxClip1()
	local weapon = LocalWeapon()
	if not IsValid(weapon) then return -1 end
	return weapon:GetMaxClip1()
end

--[[
	@doc
	@fname LocalMaxClip2

	@returns
	number
]]
function _G.LocalMaxClip2()
	local weapon = LocalWeapon()
	if not IsValid(weapon) then return -1 end
	return weapon:GetMaxClip2()
end

--[[
	@doc
	@fname LocalAmmoType1

	@returns
	number
]]
function _G.LocalAmmoType1()
	local weapon = LocalWeapon()
	if not IsValid(weapon) then return -1 end
	return weapon:GetPrimaryAmmoType()
end

--[[
	@doc
	@fname LocalAmmoType2

	@returns
	number
]]
function _G.LocalAmmoType2()
	local weapon = LocalWeapon()
	if not IsValid(weapon) then return -1 end
	return weapon:GetSecondaryAmmoType()
end

_G.ActiveWeapon = LocalWeapon
_G.GetActiveWeapon = LocalWeapon
_G.LocalWeapon = LocalWeapon

--[[
	@doc
	@fname LocalPos
	@alias LocalPosition

	@returns
	Vector
]]
function _G.LocalPos()
	local ply = LocalPlayer()
	if not IsValid(ply) then return Vector() end
	return ply:GetPos()
end

_G.LocalPosition = LocalPos

--[[
	@doc
	@fname LocalAngles
	@alias LocalAng

	@returns
	Vector
]]
function _G.LocalAngles()
	local ply = LocalPlayer()
	if not IsValid(ply) then return Angle() end
	return ply:GetAngles()
end

_G.LocalAng = LocalAngles
