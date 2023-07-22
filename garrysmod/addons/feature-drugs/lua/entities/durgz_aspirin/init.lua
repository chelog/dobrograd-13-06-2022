AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = "models/jaanus/aspbtl.mdl"
ENT.HASHIGH = false
ENT.LASTINGEFFECT = 0;

local TIME_TO_REMOVE = 15;
local HP_TO_ADD = 50;

--called when you use it (after it sets the high visual values and removes itself already)
function ENT:High(activator,caller)
	if (activator.durgz_aspirin_used) then
		activator.DURGZ_MOD_DEATH = "durgz_aspirin"
		activator.DURGZ_MOD_OVERRIDE = activator:Nick().." "..self.OverdosePhrase[math.random(1, #self.OverdosePhrase)].." "..self.Nicknames[math.random(1, #self.Nicknames)].." and died.";
		activator:Kill()

		return
	end

	activator.durgz_aspirin_used = true
	activator.durgz_aspirin_hp = activator:Health() + HP_TO_ADD
	activator.durgz_aspirin_hp_start = activator:Health()
	activator.durgz_aspirin_lasthealth = activator:Health();
	activator:SetHealth(activator:Health()+HP_TO_ADD);
	timer.Simple(TIME_TO_REMOVE, function()
		if IsValid(ply) then
			activator:SetHealth(activator:Health()-HP_TO_ADD);
		end
	end)
	activator.durgz_aspirin_start = CurTime();
end

hook.Add(
	"DoPlayerDeath",
	"durgz_aspirin_removehealth_reset",
	function(pl)
		pl.durgz_aspirin_hp = nil
		pl.durgz_aspirin_start = nil
		pl.durgz_aspirin_lasthealth = nil
		pl.durgz_aspirin_used = false
	end
)
