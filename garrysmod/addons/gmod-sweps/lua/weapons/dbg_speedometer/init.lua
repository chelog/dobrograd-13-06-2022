AddCSLuaFile 'shared.lua'
AddCSLuaFile 'cl_init.lua'

include 'shared.lua'

function SWEP:Measure(tr)

	self.Owner:EmitSound('npc/turret_floor/shoot1.wav', 75, 200)
	local ent = tr.Entity
	if not IsValid(ent) or not ent.IsSimfphyscar then return end
	if self.Owner:GetShootPos():DistToSqr(tr.HitPos) > 4000000 then return end

	local speed = math.Round(ent:GetVelocity():Length() * 0.0568182, 0)
	self.Owner:Notify(L.result_speedometer:format(speed))

end
