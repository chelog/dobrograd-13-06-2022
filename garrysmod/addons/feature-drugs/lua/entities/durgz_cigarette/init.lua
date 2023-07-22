AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = "models/boxopencigshib.mdl"


ENT.LASTINGEFFECT = 60; --how long the high lasts in seconds

--called when you use it (after it sets the high visual values and removes itself already)
function ENT:High(activator,caller)
	local smoke = EffectData();
	smoke:SetOrigin(activator:EyePos());
	util.Effect("durgz_weed_smoke", smoke);
	--increase health/catch on fire
	if( math.random(0,10) == 0 )then
		activator:Ignite(5,0)
		self:Say(activator,"FUUUUUUUUUUUUUUUUUUUUUUUUUU")
	else
		--[[
		--Exploitable by changing name to "/concommand BAN *" or something
		if( self:Say(activator, "") )then
			for id,pl in pairs(player.GetAll())do
				if(pl != activator)then
					pl:ConCommand("say "..activator:Nick().." is COOL.")
				end
			end
		end
		]]
		self:Say(activator,"I am COOL.")
	end
	/*
	--cigarette
	if( !activator.DurgzModCigarette || !activator.DurgzModCigarette:IsValid() )then
		local cig = ents.Create("prop_dynamic")
		cig:SetModel("models/pissedmeoff.mdl")
		cig:SetPos( activator:EyePos() )
		cig:SetAngles(activator:EyeAngles())
		cig:SetParent(activator)
		cig:Spawn()
		activator.DurgzModCigarette = cig
	end
	*/
end


/*
local function RemoveCig()
	for id,pl in pairs(player.GetAll())do
		if	(pl.DurgzModCigarette && pl.DurgzModCigarette:IsValid() ) 
			&& !( pl:GetNetVar("durgz_cigarette_high_start") && pl:GetNetVar("durgz_cigarette_high_end") > CurTime() )
		then
			pl.DurgzModCigarette:Remove()
			pl.DurgzModCigarette = nil
		end
	end
end
hook.Add("Think", "durgz_cigarette_remove", RemoveCig)
*/

