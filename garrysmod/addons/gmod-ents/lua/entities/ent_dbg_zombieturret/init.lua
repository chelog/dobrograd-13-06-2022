AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"

include "shared.lua"

function ENT:Initialize()

	local halfSize = Vector(10, 10, 10)
	self:SetModel('models/props/de_prodigy/turret.mdl')
	self:PhysicsInitBox(-halfSize, halfSize)
	-- self:SetMoveType(MOVETYPE_VPHYSICS)
	-- self:SetSolid(SOLID_VPHYSICS)

end

local enemies = {
	npc_zombie = true,
	npc_zombie_torso = true,
	npc_fastzombie = true,
	npc_headcrab_black = true,
	npc_headcrab_fast = true,
	npc_headcrab_poison = true,
	npc_fastzombie_torso = true,
	npc_headcrab = true,
	npc_poisonzombie = true,
}

hook.Add('PlayerSpawnedNPC', 'dbg-zombie', function(ply, npc)

	for i, v in ipairs(player.GetAll()) do
		if v:GetNetVar('zombie') then npc:AddEntityRelationship(v, D_NU, 99) end
	end

end)

hook.Add('dbg-zombie.changed', 'dbg-zombie', function(ply, st)

	for i, npc in ipairs(ents.FindByClass('npc_*')) do
		if npc.AddEntityRelationship then
			npc:AddEntityRelationship(ply, st and D_NU or D_HT, 99)
		end
	end

end)

function ENT:Think()

	for i, v in ipairs(ents.FindInSphere(self:GetPos(), 1200)) do
		if (v:IsPlayer() and v:Alive() and v:HasWeapon('weapon_zombie')) or (enemies[v:GetClass()] and v:GetNPCState() ~= NPC_STATE_DEAD) then
			local pos, mins, maxs = v:GetPos(), v:OBBMins() * 0.75, v:OBBMaxs() * 0.75
			pos.x = pos.x + math.random(mins.x, maxs.x)
			pos.y = pos.y + math.random(mins.y, maxs.y)
			pos.z = pos.z + math.random(mins.z, maxs.z)
			self:Shoot(pos)
			break
		end
	end

	self:NextThink(CurTime() + 1)
	return true

end

function ENT:Shoot(pos)

	local dir = pos - self:GetPos()
	local firepos = Vector(dir.x, dir.y, dir.z)
	firepos.z = 0
	firepos:Normalize()
	firepos:Mul(60)

	self:EmitSound('weapons/shotgun/shotgun_fire6.wav', 85, 100, 1)
	self:FireBullets({
		Attacker = self,
		IgnoreEntity = self,
		Damage = 200,
		Force = 50,
		Num = 1,
		Tracer = 1,
		TracerName = 'AR2Tracer',
		Src = self:GetPos() + firepos,
		Dir = dir,
		HullSize = 4,
	})

end
