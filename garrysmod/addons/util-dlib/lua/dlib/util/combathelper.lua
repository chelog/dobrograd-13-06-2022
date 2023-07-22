
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


local IsValid = FindMetaTable('Entity').IsValid
local type = type
local NULL = NULL
local table = table
DLib.combat = DLib.combat or {}
local combat = DLib.combat

--[[
	@doc
	@fname DLib.combat.findWeapon
	@args CTakeDamageInfo dmginfo

	@returns
	Weapon
	Entity: attacker
	Entity: inflictor
]]
function combat.findWeapon(dmginfo)
	local attacker, inflictor = dmginfo:GetAttacker(), dmginfo:GetInflictor()
	if not IsValid(attacker) or not IsValid(inflictor) then return NULL, attacker, inflictor end
	if type(attacker) ~= 'Player' or not (type(inflictor) == 'Weapon' or attacker == inflictor) then return end
	local weapon = type(inflictor) == 'Weapon' and inflictor or attacker:GetActiveWeapon()
	return weapon, attacker, inflictor
end

local function interval(val, min, max)
	return val > min and val <= max
end

--[[
	@doc
	@fname DLib.combat.inPVS
	@args Entity pointFrom, Entity pointTo, Angle eyes = pointFrom:EyeAnglesFixed(), number yawLimit = 60, number pitchLimit = 60

	@desc
	Despite function's name, this only checks whenever pointFrom can see on screen pointTo
	using eye angles check assuming they have direct line of sight to each other
	@enddesc

	@returns
	boolean
]]
function combat.inPVS(point1, point2, eyes, yawLimit, pitchLimit)
	if type(point1) ~= 'Vector' then
		if point1.EyeAnglesFixed then
			eyes = eyes or point1:EyeAnglesFixed()
		elseif point1.EyeAngles then
			eyes = eyes or point1:EyeAngles()
		end

		point1 = point1:EyePos()
	end

	if type(point2) ~= 'Vector' then
		point2 = point2:EyePos()
	end

	yawLimit = yawLimit or 60
	pitchLimit = pitchLimit or 60

	local ang = (point2 - point1):Angle()
	local diffPith = ang.p:AngleDifference(eyes.p)
	local diffYaw = ang.y:AngleDifference(eyes.y)

	return interval(diffYaw, -yawLimit, yawLimit) and interval(diffPith, -pitchLimit, pitchLimit)
end

--[[
	@doc
	@fname DLib.combat.turnAngle
	@args Entity pointFrom, Entity pointTo, Angle eyes = pointFrom:EyeAnglesFixed()

	@returns
	number: pitch delta
	number: yaw delta
]]
function combat.turnAngle(point1, point2, eyes)
	if type(point1) ~= 'Vector' then
		if point1.EyeAnglesFixed then
			eyes = eyes or point1:EyeAnglesFixed()
		elseif point1.EyeAngles then
			eyes = eyes or point1:EyeAngles()
		end

		point1 = point1:EyePos()
	end

	if type(point2) ~= 'Vector' then
		point2 = point2:EyePos()
	end

	local ang = (point2 - point1):Angle()
	return ang.p:AngleDifference(eyes.p), ang.y:AngleDifference(eyes.y)
end

--[[
	@doc
	@fname DLib.combat.findWeaponAlt
	@args CTakeDamageInfo dmginfo

	@returns
	Weapon
	Entity: attacker
	Entity: inflictor
]]
function combat.findWeaponAlt(dmginfo)
	local attacker, inflictor = dmginfo:GetAttacker(), dmginfo:GetInflictor()
	local weapon = inflictor

	if not IsValid(inflictor) and IsValid(attacker) then
		inflictor = attacker
		weapon = attacker
	end

	if not IsValid(attacker) or not IsValid(inflictor) then
		return inflictor, attacker, inflictor
	end

	if type(inflictor) ~= 'Weapon' and attacker.GetActiveWeapon then
		inflictor = attacker:GetActiveWeapon()
		weapon = inflictor
	end

	return weapon, attacker, inflictor
end

--[[
	@doc
	@fname DLib.combat.detect
	@args CTakeDamageInfo dmginfo

	@returns
	Entity: attacker
	Entity: weapon or inflictor
	Entity: inflictor
]]
function combat.detect(dmginfo)
	local weapon, attacker, inflictor = combat.findWeapon(dmginfo)

	if not IsValid(weapon) then
		weapon = inflictor
	end

	return attacker, weapon, inflictor
end

--[[
	@doc
	@fname DLib.combat.findPlayers
	@args Entity self

	@desc
	Attempts to find all players involved within certain entity. This can be a vehicle from another mod for example
	(SCars or Simfphys or even Neurotec)
	**This also include players who are spectating this entity**
	@enddesc

	@returns
	table: of players found or false, if self is NULL
]]
function combat.findPlayers(self)
	if not IsValid(self) then
		return false
	end

	local specs = {}

	for i, ply in ipairs(player.GetAll()) do
		if ply ~= self and ply:GetObserverTarget() == self then
			table.insert(specs, ply)
		end
	end

	if type(self) == 'Player' then
		table.insert(specs, self)
		return specs
	end

	if type(self) == 'Vehicle' then
		local driver = self:GetDriver()

		if not IsValid(driver) then
			return #specs ~= 0 and specs
		end

		table.insert(specs, driver)
		return specs
	end

	local MEM = {}
	local iterate = {self}

	while #iterate > 0 do
		local ent = table.remove(iterate)

		if MEM[ent] then
			goto CONTINUE
		end

		MEM[ent] = true

		for i, ent2 in ipairs(self:GetChildren()) do
			if type(ent2) == 'Player' then
				table.insert(specs, ent2)
			elseif type(ent2) == 'Vehicle' then
				local driver = ent2:GetDriver()

				if IsValid(driver) then
					table.insert(specs, driver)
				end
			else
				table.insert(iterate, ent2)
			end
		end

		::CONTINUE::
	end

	return #specs ~= 0 and table.deduplicate(specs) or false
end
