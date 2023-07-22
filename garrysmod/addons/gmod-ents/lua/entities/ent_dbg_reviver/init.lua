AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"

include "shared.lua"
local lastUses = {}

function ENT:Initialize()

	self:SetModel('models/hunter/plates/plate2x3.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetColor(Color(0,0,0, 0))

	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end

end

-- function ENT:PhysicsCollide( colData, collider )

-- 	local ply = colData.HitEntity
-- 	if not ply:IsPlayer() or not ply:IsGhost() then return end

-- 	local priestAmount = team.NumPlayers(TEAM_PRIEST)
-- 	if priestAmount < 1 then
-- 		local time = CurTime() + 30 - math.min(ply:GetKarma(), 2) * 10
-- 		if ply:GetNetVar("_SpawnTime", 0) > time then
-- 			ply:EmitSound('dbg/revive.ogg', 70, 100, 0.8)
-- 			local effectdata = EffectData()
-- 			effectdata:SetOrigin(ply:GetPos() + Vector(0,0,45))
-- 			effectdata:SetMagnitude(2.5)
-- 			effectdata:SetScale(2)
-- 			effectdata:SetRadius(3)
-- 			util.Effect("GlassImpact", effectdata, true, true)
-- 		end
-- 		ply:SetNetVar( "_SpawnTime", math.min(ply:GetNetVar("_SpawnTime", 0), time) )
-- 	else
-- 		ply:Notify('warning', L.priest_online)
-- 	end

-- end

function ENT:Use(ply)

	ply:DelayedAction('reviverKarma', L.confession, {
		time = 60,
		check = function() return octolib.use.check(ply, self) end,
		succ = function()
			local sID = ply:SteamID()
			if CurTime() - (lastUses[sID] or -2400) > 2400 then
				ply:AddKarma(1, L.confession_help)
				print('[KARMA] ' .. tostring(ply) .. ' +1 karma for prayer')
				lastUses[sID] = CurTime()
			else
				ply:Notify('warning', L.god_love_you)
			end
		end,
	}, {
		time = 3,
		inst = true,
		action = function()
			ply:DoAnimation(ACT_GMOD_GESTURE_BOW)
		end,
	})

end
