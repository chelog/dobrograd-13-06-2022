AddCSLuaFile("shared.lua")
include("shared.lua")


ENT.MODEL = "models/drug_mod/alcohol_can.mdl"


ENT.LASTINGEFFECT = 45; --how long the high lasts in seconds


local function shouldnt_do_that_shit(pl)
	return pl == NULL or not pl or pl == nil or not pl:GetActiveWeapon() or pl:GetNetVar("durgz_alcohol_high_end", 0) < CurTime()
end

function ENT:High(activator,caller)
	self:Say(activator,"waitt, wait. guysss. i need to tells u abuot micrsfoft excel!11!")

	--does random stuff while higH!
	local commands = {"left", "right", "moveleft", "moveright", "attack"}
	local thing = math.random(1,3)

	local TRANSITION_TIME = self.TRANSITION_TIME;

	for i = 1,thing do
		timer.Simple(math.Rand(5,10), function()
			if activator and activator:GetNetVar("durgz_alcohol_high_end", 0) - TRANSITION_TIME > CurTime() then
				local cmd = commands[math.random(1, #commands)]
				activator:ConCommand("+"..cmd)
				timer.Simple(1, function()
					activator:ConCommand("-"..cmd)
				end)
			end
		end)
	end

	--takes out the pistol and then shoots randomly
	local oldwep = activator:GetActiveWeapon():GetClass()



	if not oldwep then return end
	for id,wep in pairs(activator:GetWeapons())do
		if( wep:GetClass() == "weapon_pistol" )then
			activator:SelectWeapon("weapon_pistol")
			timer.Simple(0.3, function() if shouldnt_do_that_shit(activator) then return end
				activator:ConCommand("+attack")
				timer.Simple(0.1, function() if activator == NULL or not activator or activator == nil then return end
					activator:ConCommand("-attack")
					if oldwep and oldwep != nil and oldwep != NULL and activator:Alive() then
						activator:SelectWeapon(oldwep)
					end
				end)
			end)
		end
	end
end
