AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = "models/smile/smile.mdl"


ENT.LASTINGEFFECT = 60; --how long the high lasts in seconds

--called when you use it (after it sets the high visual values and removes itself already)
function ENT:High(activator,caller)
	local sayings = {
		"OH MY GOD I JUST DEFLATED",
		"I WONDER WHAT HAPPENS WHEN I POUR GASOLINE ALL OVER MYSELF? THAT MUST BE THE CURE FOR CANCER, DUDE"
	}
	self:Say(activator, sayings)
end
