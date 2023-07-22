AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = "models/katharsmodels/contraband/metasync/blue_sky.mdl"
ENT.MASS = 2;
ENT.LASTINGEFFECT = 30;

function ENT:High(activator,caller)
	sound.Play("drugs/insufflation.wav", activator:GetPos(), 75, 100, 1)
	self:Say(activator, "I <3 METH")

	if not self:Realistic() then
		activator:SetHealth(activator:Health() / 3)
	end

	-- activator:SetGravity(1.5);
end

function ENT:AfterHigh(activator, caller)
	if (activator:Health() <= 2) then
		activator.DURGZ_MOD_DEATH = "durgz_meth";
		activator.DURGZ_MOD_OVERRIDE = activator:Nick().." died of a heart attack (methamphetamine overdose).";
		activator:Kill()
		return
	end
end

--set speed back to normal once your high is over
-- hook.Add("Think", "durgz_meth_resetspeed", function()
--	 for id,pl in pairs(player.GetAll())do
--		 if pl:GetNetVar("durgz_meth_high_end") < CurTime() then
-- 			pl:SetGravity(1)
--		 end
--	 end
-- end)
