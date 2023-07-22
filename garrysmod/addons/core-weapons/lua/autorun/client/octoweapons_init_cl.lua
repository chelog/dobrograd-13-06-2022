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
