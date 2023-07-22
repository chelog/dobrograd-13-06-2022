AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

local function lookingAt(ply, ent)
	local aim = ply:EyeAngles():Forward()
	local entVector = ent:GetPos() - ply:GetShootPos()
	local dot = aim:Dot(entVector) / entVector:Length()
	return dot * 8 >= math.pi
end

function ENT:Think()

	if not self:GetNetVar('exploded') then return end

	for _,v in ipairs(ents.FindInSphere(self:GetPos(), 200)) do
		if v:IsPlayer() and self:CanDamage(v, 'eyes') then
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

function ENT:OnExplode()
	self:SetNetVar('exploded', true)
	for _,v in ipairs(ents.FindInSphere(self:GetPos(), 400)) do
		if not v:IsPlayer() then continue end
		if not self:CanDamage(v, 'eyes') then
			netstream.Start(v, 'dbg-grenades.flash', self)
			continue
		end
		local looking = lookingAt(v, self)
		if looking then
			netstream.Start(v, 'dbg-grenades.shock', 16, 255, 12)
			v:SetEyeAngles(v:EyeAngles() + Angle(math.random(-45, 45), math.random(-45, 45)))
			v:MoveModifier('shock', {
				norun = true,
				walkmul = 0.5,
			})
			v:SetDSP(38) -- distorted speaker
			timer.Simple(0.25, function()
				if IsValid(v) then
					v:SetDSP(36) -- shock muffle 2
				end
			end)
			timer.Simple(1.75, function()
				if IsValid(v) then
					v:SetDSP(33) -- explosion ring 2
				end
			end)
			timer.Simple(2, function()
				if IsValid(v) then
					v:SetDSP(16)
				end
			end)
			timer.Simple(16, function()
				if IsValid(v) then
					v:SetDSP(1)
					v:MoveModifier('shock', nil)
				end
			end)
		else
			netstream.Start(v, 'dbg-grenades.shock', 4, 100, 4)
			v:SetEyeAngles(v:EyeAngles() + Angle(math.random(-15, 15), math.random(-15, 15)))
			v:SetDSP(16)
			timer.Simple(4, function()
				if IsValid(v) then
					v:SetDSP(1)
				end
			end)
		end
		if self:CanDamage(v) then
			local wep = v:GetActiveWeapon()
			if IsValid(wep) and wep:GetClass():find('_octo') then
				if not GAMEMODE.Config.DisallowDrop[wep:GetClass()] and not v:jobHasWeapon(wep:GetClass()) then
					local ent = v:dropDRPWeapon(wep)
					if IsValid(ent) and wep.IsLethal then
						ent.isEvidence = true
					end
				else
					v:SelectWeapon('dbg_hands')
				end
			end

			local dmg = DamageInfo()
			dmg:SetDamageType(DMG_BLAST)
			dmg:SetDamage(10)
			v:TakeDamageInfo(dmg)
		end
	end

	timer.Simple(45, function()
		if IsValid(self) then
			self:Remove()
		end
	end)

	return true
end