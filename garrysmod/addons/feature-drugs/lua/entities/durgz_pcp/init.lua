AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = "models/marioragdoll/Super Mario Galaxy/star/star.mdl"

ENT.MASS = 2; --the model is too heavy so we have to override it with THIS

ENT.LASTINGEFFECT = 20; --how long the high lasts in seconds

--called when you use it (after it sets the high visual values and removes itself already)
function ENT:High(activator,caller)
		
	local sayings = {
		"HELLO. MY NAME IS JARED AND I LIKE FOOTBALL.",
		"MY ARMS ARE LIKE FUCKING CANNONS",
		"FOOTBALLLL",
		"REEEED! MENOS TRES"
	}
	self:Say(activator, sayings)
		
end

