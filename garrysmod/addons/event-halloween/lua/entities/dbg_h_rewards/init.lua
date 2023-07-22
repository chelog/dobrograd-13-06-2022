AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

function ENT:Initialize()

	return self:Remove()
	-- self:SetModel('models/treasurechest/treasurechest.mdl')
	-- self:PhysicsInit(SOLID_VPHYSICS)
	-- self:SetMoveType(MOVETYPE_VPHYSICS)
	-- self:SetSolid(SOLID_VPHYSICS)
	-- self:SetUseType(SIMPLE_USE)
end

function ENT:Use(ply)
	if not ply:IsPlayer() then return end
	local ct = CurTime()
	if (ply.nextRewardsUse or 0) > ct then return end
	if ply:GetNetVar('sweets', 0) <= 0 then
		ply.nextRewardsUse = ct + 60
		return octochat.talkTo(ply, octochat.textColors.rp, 'Джек говорит: ', color_white, 'Нет конфет? Очень жаль. Надеюсь, увидимся на следующий Хэллоуин!')
	end
	ply.nextRewardsUse = ct + 2
	netstream.Start(ply, 'dbg-halloween.openRewards', self, halloween.collectData(ply))
	local mod = 1 - halloween.getPriceModifier(ply)
	if mod > 0 then
		octochat.talkTo(ply, octochat.textColors.rp, 'Джек говорит: ', color_white, ('О, мне про тебя рассказывали! Сделаю-ка я тебе скидку в %s%%'):format(mod * 100))
	end
end
