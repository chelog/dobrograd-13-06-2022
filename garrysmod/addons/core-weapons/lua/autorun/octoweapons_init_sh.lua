local function addWeaponSound(soundName, path, distantPath, silenced)
	sound.Add({
		name = soundName,
		channel = CHAN_USER_BASE + 10,
		volume = 1,
		sound = path,
		pitch = {95, 105},
		level = 75,
	})

	if distantPath then
		sound.Add({
			name = soundName .. '-distant',
			channel = CHAN_USER_BASE + 11,
			volume = silenced and 0.05 or 1,
			sound = distantPath,
			pitch = {95, 105},
			level = silenced and 85 or 95,
		})
	end
end

addWeaponSound('beanbag.fire', 'weapons/beanbag/beanbagfire.wav', 'weapons/beanbag/beanbagfire.wav', true)
addWeaponSound('ak47.fire', 'dbg/weapons/ak47/cv47-1.wav', 'dbg/weapons/ak47/cv47-1-distant.wav')
addWeaponSound('aug.fire', 'dbg/weapons/aug/aug-1.wav', 'dbg/weapons/aug/aug-1-distant.wav')
addWeaponSound('awp.fire', 'dbg/weapons/awp/awm-1.wav', 'dbg/weapons/awp/awm-1-distant.wav')
addWeaponSound('deagle.fire', 'dbg/weapons/deagle/deagle-1.wav', 'dbg/weapons/deagle/deagle-1-distant.wav')
addWeaponSound('elite.fire', 'dbg/weapons/elite/elite-1.wav', 'dbg/weapons/elite/elite-1-distant.wav')
addWeaponSound('famas.fire', 'dbg/weapons/famas/famas-1.wav', 'dbg/weapons/famas/famas-1-distant.wav')
addWeaponSound('fiveseven.fire', 'dbg/weapons/fiveseven/fiveseven-1.wav', 'dbg/weapons/fiveseven/fiveseven-1-distant.wav')
addWeaponSound('g3sg1.fire', 'dbg/weapons/g3sg1/g3sg1-1.wav', 'dbg/weapons/g3sg1/g3sg1-1-distant.wav')
addWeaponSound('galil.fire', 'dbg/weapons/galil/galil-1.wav', 'dbg/weapons/galil/galil-1-distant.wav')
addWeaponSound('glock.fire', 'dbg/weapons/glock/glock-1.wav', 'dbg/weapons/glock/glock-1-distant.wav')
addWeaponSound('glock18.fire', 'dbg/weapons/glock/glock18-1.wav', 'dbg/weapons/glock/glock18-1-distant.wav')
addWeaponSound('m249.fire', 'dbg/weapons/m249/m249-1.wav', 'dbg/weapons/m249/m249-1-distant.wav')
addWeaponSound('m3.fire', 'dbg/weapons/m3/m3-1.wav', 'dbg/weapons/m3/m3-1-distant.wav')
addWeaponSound('m3nova.fire', 'dbg/weapons/m3/nova-1.wav', 'dbg/weapons/m3/nova-1-distant.wav')
addWeaponSound('m4a1.fire', 'dbg/weapons/m4a1/m4a4_1.wav', 'dbg/weapons/m4a1/m4a4_1_distant.wav')
addWeaponSound('m4a1s.fire', 'dbg/weapons/m4a1/m4a1_1s.wav', 'dbg/weapons/m4a1/m4a1_1s_distant.wav', true)
addWeaponSound('mac10.fire', 'dbg/weapons/mac10/mac10-1.wav', 'dbg/weapons/mac10/mac10-1-distant.wav')
addWeaponSound('mp5navy.fire', 'dbg/weapons/mp5navy/mp5-1.wav', 'dbg/weapons/mp5navy/mp5-1-distant.wav')
addWeaponSound('p228.fire', 'dbg/weapons/p228/p228-1.wav', 'dbg/weapons/p228/p228-1-distant.wav')
addWeaponSound('p90.fire', 'dbg/weapons/p90/p95-1.wav', 'dbg/weapons/p90/p95-1_distant.wav')
addWeaponSound('revolver.fire', 'dbg/weapons/revolver/revolver-1_01.wav', 'dbg/weapons/revolver/revolver-1_distant.wav')
addWeaponSound('scout.fire', 'dbg/weapons/scout/ssg08-1.wav', 'dbg/weapons/scout/ssg08-1-distant.wav')
addWeaponSound('sg550.fire', 'dbg/weapons/sg550/sg550-1.wav', 'dbg/weapons/sg550/sg550-1-distant.wav')
addWeaponSound('sg552.fire', 'dbg/weapons/sg552/sg556-1.wav', 'dbg/weapons/sg552/sg556-1-distant.wav')
addWeaponSound('tmp.fire', 'dbg/weapons/tmp/tmp-1.wav', 'dbg/weapons/tmp/tmp-1-distant.wav', true)
addWeaponSound('ump45.fire', 'dbg/weapons/ump45/ump45-1.wav', 'dbg/weapons/ump45/ump45-1-distant.wav')
addWeaponSound('usp.fire', 'dbg/weapons/usp/usp_unsil-1.wav', 'dbg/weapons/usp/usp_unsil-1-distant.wav')
addWeaponSound('usps.fire', 'dbg/weapons/usp/usp1.wav', 'dbg/weapons/usp/usp1-distant.wav', true)
addWeaponSound('xm1014.fire', 'dbg/weapons/xm1014/xm1014-1.wav', 'dbg/weapons/xm1014/xm1014-1-distant.wav')
