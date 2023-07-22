include('shared.lua')

function ENT:Think()

	if not IsValid(self.em) then return end
	if not self:GetNetVar('exploded') then
		return self.BaseClass.Think(self)
	end

	if LocalPlayer():EyePos():DistToSqr(self:GetPos()) <= self.RadiusSqr*100 then
		local p = self.em:Add(string.format('particle/smokesprites_00%02d', math.random(1,10)), self:GetPos())
		if p then
			local dir = VectorRand() + Vector(0, 0, 0.4)
			p:SetVelocity(dir * 200)
			p:SetDieTime(math.Rand(6, 8))
			p:SetStartAlpha(math.Rand(100, 150))
			p:SetEndAlpha(0)
			p:SetStartSize(math.Rand(40, 50))
			p:SetEndSize(math.Rand(150, 200))
			p:SetRoll(math.Rand(0, 360))
			p:SetRollDelta(math.Rand(-0.5, 0.5))
			local col = math.Rand(135, 145)
			p:SetColor(col, col, col)
			p:SetAirResistance(200)
			p:SetGravity(dir * math.random(50, 75))
			p:SetCollide(true)
		end
	end

	self:SetNextClientThink(CurTime() + 0.2)
	return true

end

local function hasGasMask(ply)
	local hMask = ply:GetNetVar('hMask')
	return hMask and hMask[1] == 'gasmask'
end

local affectedBy, affectedRadius
local grenades = {'ent_dbg_grenade_gas', 'ent_dbg_grenade_shock'}
timer.Create('dbg-grenades.gas', 0.5, 0, function()

	local lp = LocalPlayer()
	if IsValid(lp) and not hasGasMask(lp) and not (lp:GetNetVar('Ghost') or lp:GetNetVar('Invisible')) then
		affectedBy, affectedRadius = nil
		local ourPos = lp:GetShootPos()
		for _, class in ipairs(grenades) do
			for _, v in ipairs(ents.FindByClass(class)) do
				if v:GetNetVar('exploded') and ourPos:DistToSqr(v:GetPos()) <= v.RadiusSqr and v:CanDamage(lp, 'eyes') then
					affectedBy = v
					affectedRadius = v.RadiusSqr
					return
				end
			end
		end
	end

	affectedBy = nil

end)

local effectAmount = 0
local xRand, yRand = math.Rand(1, 3), math.Rand(1, 3)
hook.Add('RenderScreenspaceEffects', 'dbg-grenades.gas', function()

	local lp = LocalPlayer()

	if IsValid(affectedBy) then
		local dst = (affectedRadius - lp:GetShootPos():DistToSqr(affectedBy:GetPos())) / affectedRadius
		effectAmount = math.min(effectAmount + dst * FrameTime(), 1)
	end

	if effectAmount > 0 then
		DrawMaterialOverlay('effects/water_warp01', 0.5 * effectAmount)
		DrawColorModify({
			['$pp_colour_contrast'] = 1 - effectAmount * 0.8,
			['$pp_colour_colour'] = 1 - effectAmount,
			['$pp_colour_brightness'] = effectAmount * 0.5,
		})

		local ct = CurTime()
		local off = effectAmount * 10
		dbgView.lookOff.p = math.sin(ct * yRand) * off
		dbgView.lookOff.y = math.sin(ct * xRand) * off
	end

	if effectAmount > 0 then
		effectAmount = math.Approach(effectAmount, 0, FrameTime() * 0.01)
	end

end)
