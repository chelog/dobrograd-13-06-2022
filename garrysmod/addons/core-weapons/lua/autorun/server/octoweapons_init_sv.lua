--air
hook.Add('Initialize', 'dbg-weps.init', function()
	game.AddAmmoType({
		name = 'air',
		dmgtype = bit.band(DMG_BULLET, DMG_NEVERGIB, DMG_DIRECT),
		tracer = TRACER_LINE,
		plydmg = 0,
		npcdmg = 0,
		force = 0,
		minsplash = 5,
		maxsplash = 2.5,
		maxcarry = 100,
	})
end)

hook.Add('EntityTakeDamage', 'dbg-weps.air', function(ply, dmg)

	if not IsValid(ply) or not ply:IsPlayer() then return end
	if dmg:GetDamageType() ~= DMG_BULLET and dmg:GetDamageType() ~= DMG_BLAST then return end

	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and not wep.IsLethal and not (GAMEMODE.Config.DisallowDrop[wep:GetClass()] or ply:jobHasWeapon(wep:GetClass())) then
		ply:HolsterWeapon(wep)
	end

end)
