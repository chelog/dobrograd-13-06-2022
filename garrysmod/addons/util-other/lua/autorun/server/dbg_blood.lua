local bloodDecalMats = {
	[BLOOD_COLOR_RED] = 'Blood',
	[BLOOD_COLOR_YELLOW] = 'YellowBlood',
	[BLOOD_COLOR_GREEN] = 'YellowBlood',
	[BLOOD_COLOR_MECH] = 'ManhackSparks',
	[BLOOD_COLOR_ANTLION] = 'YellowBlood',
	[BLOOD_COLOR_ZOMBIE] = 'YellowBlood',
	[BLOOD_COLOR_ANTLION_WORKER] = 'YellowBlood'
}

local function applyBloodOverride(ent)
	if ent:GetBloodColor() == DONT_BLEED then return end

	ent.overrideBloodColor = ent:GetBloodColor()
	ent:SetBloodColor(DONT_BLEED)
end
hook.Add('PlayerSpawn', 'dbg-blood', applyBloodOverride)

hook.Add('PostEntityTakeDamage', 'dbg-blood', function(ent, dmg)
	if not dmg:IsBulletDamage() or dmg:GetDamage() < 5
	or not (ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot()) then
		return
	end

	applyBloodOverride(ent)

	local bloodColor = ent.overrideBloodColor
	if not bloodColor then return end

	local hitPos = dmg:GetDamagePosition()
	local hitDir = dmg:GetDamageForce():GetNormalized() + VectorRand() * 0.2

	local effectData = EffectData()
	effectData:SetOrigin(hitPos)
	effectData:SetColor(bloodColor)
	util.Effect('BloodImpact', effectData)

	local decalMat = bloodDecalMats[bloodColor] or 'Blood'
	if bloodColor == BLOOD_COLOR_MECH or not decalMat then return end

	local decalTargetPos = hitPos + (hitDir * math.random(35, 150))
	if not util.TraceLine({
		start = hitPos,
		endpos = decalTargetPos,
		filter = ent,
	}).Hit then
		hitPos = Vector(decalTargetPos)
		decalTargetPos:Add(Vector(0, 0, -80))
	end

	util.Decal(decalMat, hitPos, decalTargetPos, ent)
end)