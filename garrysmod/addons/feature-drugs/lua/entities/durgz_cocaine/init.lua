AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = "models/cocn.mdl"
ENT.MASS = 2; --the model is too heavy so we have to override it with THIS
ENT.LASTINGEFFECT = 45; --how long the high lasts in seconds

function ENT:High(activator,caller)
	sound.Play("drugs/insufflation.wav", activator:GetPos(), 75, 100, 1)

	if !self:Realistic() then activator:SetHealth(activator:Health() / 2 ) end
	if (activator:Health() > 1) then self:Say(activator, "MYNOSEISDRIBBLINGISANYONEELSESNOSEDRIBBLINGTHATSREALLYWEIRDIHOPEIDONTHAVEACOLD") end

	self.MakeHigh = false;

	if !self:Realistic() then
		if activator:GetNetVar("durgz_cocaine_high_end", 0) < CurTime() then
			self.MakeHigh = true;
		end
	end
end

function ENT:AfterHigh(activator, caller)
	--kill them if they're weak
	if (activator:Health() <=1) then
		activator.DURGZ_MOD_DEATH = "durgz_cocaine";
		activator.DURGZ_MOD_OVERRIDE = activator:Nick().." died of a heart attack (too much cocaine).";
		activator:Kill()
		return
	end

	if (self.MakeHigh) then
		activator.durgz_cocaine_fast = true
		pl:MoveModifier('drug', {
			runmul = 6,
			walkmul = 6,
		})
	end
end

--set speed back to normal once your high is over
hook.Add(
	"Think",
	"durgz_cocaine_resetspeed",
	function()
		for id,pl in pairs(player.GetAll())do
			if  pl.durgz_cocaine_fast and pl:GetNetVar("durgz_cocaine_high_end", 0) < CurTime() then
				pl:MoveModifier('drug', nil)
				pl.durgz_cocaine_fast = false
			end
		end
	end
)
