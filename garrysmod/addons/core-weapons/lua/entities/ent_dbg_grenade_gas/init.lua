AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Think()

	if not self:GetNetVar('exploded') then return end

	local ourPos = self:GetPos()
	for _,v in ipairs(ents.FindInSphere(ourPos, self.Radius)) do
		if v:IsPlayer() and v:GetShootPos():DistToSqr(ourPos) <= self.RadiusSqr and self:CanDamage(v, 'eyes') then
			timer.Simple(math.random(0.5,1.5), function()
				if IsValid(v) then
					v:EmitSound('ambient/voices/cough'..math.random(1,4)..'.wav')
				end
			end)
		end
	end

	self:NextThink(CurTime() + 2)
	return true
end
