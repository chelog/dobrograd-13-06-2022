
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


AddCSLuaFile()

local grabBaseclass = baseclass.Get('base_entity')

ENT.Type = 'anim'
ENT.Author = 'DBot'
ENT.Base = 'dlib_espawner'
ENT.PrintName = 'Weapon Spawner Base'
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Model = 'models/items/item_item_crate.mdl'
ENT.SPAWN_HOOK_CALL = 'PlayerSpawnSWEP'
ENT.SPAWNED_HOOK_CALL = 'PlayerSpawnedSWEP'
ENT.IS_SPAWNER = true

function ENT:SpawnFunction(ply, tr, class)
	if not tr.Hit then return end

	local can = hook.Run(self.SPAWN_HOOK_CALL, ply, self.CLASS, self.TABLE)
	if can == false then return end

	local ent = ents.Create(class)
	ent:SetPos(tr.HitPos + tr.HitNormal * 3)
	ent:SetModel(self.DefaultModel)
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:DoSpawn(ply)
	if IsValid(self.LastGun) and not IsValid(self.LastGun:GetOwner()) then return false end

	local ent = ents.Create(self.CLASS)
	ent:SetPos(ply:EyePos())
	ent:Spawn()

	self.LastGun = ent
	self.LastPly = ply

	self:SetNextSpawn(CurTimeL() + (self.ResetTimer or self.RESET_TIMER:GetFloat()))

	return true
end
