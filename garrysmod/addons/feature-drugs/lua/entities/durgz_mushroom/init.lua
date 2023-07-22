AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = "models/ipha/mushroom_small.mdl"
ENT.MASS = 55;
ENT.LASTINGEFFECT = 60; --how long the high lasts in seconds

--called when you use it (after it sets the high visual values and removes itself already)
function ENT:High(activator,caller)
	if (math.random(0, 22) == 0) then
		activator:Ignite(5, 0)
		self:Say(activator, "FFFFFFUUUUUUUUUUUUUUUUUU")
	else
		local health = activator:Health()

		if (health * 3 / 2 < 500) then
			activator:SetHealth (math.floor(health - 5))
		else
			activator:SetHealth(health - 5)
		end

		-- activator:SetGravity(0.135);
		self:Say(activator, "what")
	end
end

function ENT:AfterHigh(activator, caller)
end

-- local function ResetGrav()
-- 	for id, pl in pairs(player.GetAll()) do
-- 		if (pl:GetNetVar("durgz_mushroom_high_end") - 0.5 < CurTime() && pl:GetNetVar("durgz_mushroom_high_end") > CurTime() )then
-- 			pl:SetGravity(1)
-- 		end
-- 	end
-- end
-- hook.Add("Think", "durgz_mushroom_resetgrav", ResetGrav)
