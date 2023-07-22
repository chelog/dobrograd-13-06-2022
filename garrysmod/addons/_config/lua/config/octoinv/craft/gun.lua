------------------------------------------------
--
-- GUN CRAFTING
--
------------------------------------------------

local benchSounds = {
	'physics/metal/metal_box_strain1.wav',
	'physics/metal/metal_box_strain2.wav',
	'physics/metal/metal_box_strain3.wav',
	'physics/metal/metal_box_strain4.wav',
	'physics/metal/metal_canister_impact_soft1.wav',
	'physics/metal/metal_canister_impact_soft2.wav',
	'physics/metal/metal_canister_impact_soft3.wav',
}

-- ammo

octoinv.registerCraft('ammo_pistol', {
	name = L.small_ammo,
	icon = 'octoteam/icons/gun_bullet.png',
	conts = {'workbench'},
	jobs = {'gun', 'gun2'},
	sound = benchSounds,
	time = 5,
	ings = {
		{'gunpowder', 1},
		{'craft_sheet', 1},
	},
	finish = octolib.array.series({'ammo', {
		name = L.small_ammo,
		icon = 'octoteam/icons/gun_bullet.png',
		mass = 0.8,
		volume = 0.25,
		ammotype = 'pistol',
		ammocount = 24,
	}}, 2)
})

octoinv.registerCraft('ammo_smg', {
	name = L.large_ammo,
	icon = 'octoteam/icons/gun_bullet2.png',
	conts = {'workbench'},
	jobs = {'gun', 'gun2'},
	sound = benchSounds,
	time = 5,
	ings = {
		{'gunpowder', 2},
		{'craft_sheet', 1},
	},
	finish = octolib.array.series({'ammo', {
		name = L.large_ammo,
		icon = 'octoteam/icons/gun_bullet2.png',
		mass = 1.5,
		volume = 0.5,
		ammotype = 'smg1',
		ammocount = 30,
	}}, 1)
})

octoinv.registerCraft('ammo_sniper', {
	name = L.sniper_ammo,
	icon = 'octoteam/icons/gun_bullet2.png',
	conts = {'workbench'},
	jobs = {'gun', 'gun2'},
	sound = benchSounds,
	time = 5,
	ings = {
		{'gunpowder', 4},
		{'craft_sheet', 4},
	},
	finish = octolib.array.series({'ammo', {
		name = L.sniper_ammo,
		icon = 'octoteam/icons/gun_bullet2.png',
		mass = 1.3,
		volume = 0.6,
		ammotype = 'sniper',
		ammocount = 12,
	}}, 2)
})

octoinv.registerCraft('ammo_buckshot', {
	name = L.buckshot,
	icon = 'octoteam/icons/gun_bullet.png',
	conts = {'workbench'},
	jobs = {'gun', 'gun2'},
	sound = benchSounds,
	time = 5,
	ings = {
		{'gunpowder', 2},
		{'craft_sheet', 3},
	},
	finish = octolib.array.series({'ammo', {
		name = L.buckshot,
		icon = 'octoteam/icons/gun_bullet.png',
		mass = 0.6,
		volume = 0.35,
		ammotype = 'buckshot',
		ammocount = 8,
	}}, 3)
})

-- weapons

octoinv.registerCraft('armor_l', {
	name = L.armor_l,
	desc = L.desc_armor,
	conts = {'workbench'},
	icon = 'octoteam/icons/armor_heavy.png',
	sound = benchSounds,
	jobs = {'gun2'},
	time = 10,
	ings = {
		{'craft_sheet', 12},
		{'craft_scotch', 1},
		{'craft_glue', 1},
	},
	finish = {
		{'armor', {
			name = L.armor_l,
			icon = 'octoteam/icons/armor_heavy.png',
			armor = 40,
		}},
	}
})

octoinv.registerCraft('armor', {
	name = L.armor,
	desc = L.desc_armor,
	conts = {'workbench'},
	icon = 'octoteam/icons/armor.png',
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 10,
	ings = {
		{'craft_sheet', 5},
		{'craft_scotch', 1},
		{'craft_glue', 1},
	},
	finish = {
		{'armor', {
			armor = 28,
		}},
	}
})

octoinv.registerCraft('armor_s', {
	name = L.armor_s,
	desc = L.desc_armor,
	conts = {'workbench'},
	icon = 'octoteam/icons/armor_light.png',
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 10,
	ings = {
		{'craft_sheet', 3},
		{'craft_scotch', 1},
		{'craft_glue', 1},
	},
	finish = {
		{'armor', {
			name = L.armor_s,
			icon = 'octoteam/icons/armor_light.png',
			armor = 16,
		}},
	}
})

octoinv.registerCraft('gun_knife', {
	name = L.knife,
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/knife.png',
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 10,
	ings = {
		{'craft_sheet', 2},
		{'craft_grip', 1},
		{'craft_pulley', 2},
		{'craft_spring', 1},
		{'craft_glue', 1},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_knife},
	}
})

octoinv.registerCraft('gun_axe', {
	name = L.axe,
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_axe.png',
	sound = benchSounds,
	jobs = {'gun2'},
	time = 10,
	ings = {
		{'craft_sheet', 2},
		{'craft_plank', 1},
		{'craft_grip', 1},
		{'craft_glue', 1},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_axe},
	}
})

octoinv.registerCraft('gun_shovel', {
	name = L.shovel,
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/shovel.png',
	sound = benchSounds,
	jobs = {'gun2'},
	time = 10,
	ings = {
		{'craft_sheet', 2},
		{'craft_plank', 2},
		{'craft_glue', 1},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_shovel},
	}
})

octoinv.registerCraft('gun_hook', {
	name = L.hook,
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/crowbar.png',
	sound = benchSounds,
	jobs = {'gun2'},
	time = 12,
	ings = {
		{'craft_sheet', 5},
		{'craft_grip', 1},
		{'craft_glue', 1},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_hook},
	}
})

octoinv.registerCraft('gun_lockpick', {
	name = L.gun_lockpick,
	desc = L.desc_gun_lockpick,
	conts = {'workbench'},
	icon = 'octoteam/icons/lockpick.png',
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 10,
	ings = {
		{'craft_sheet', 1},
		{'craft_grip', 1},
		{'craft_glue', 1},
	},
	finish = {
		{'lockpick', 6},
	}
})

octoinv.registerCraft('gun_cracker', {
	name = L.keypad_cracker,
	desc = L.desc_cracker,
	conts = {'workbench'},
	icon = 'octoteam/icons/keypad_cracker.png',
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 15,
	ings = {
		{'craft_sheet', 4},
		{'craft_chip1', 2},
		{'craft_chip2', 1},
		{'craft_relay', 20},
		{'craft_resistor', 25},
		{'craft_transistor', 20},
		{'craft_scotch', 1},
		{'craft_glue', 1},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.keypad_cracker},
	}
})

octoinv.registerCraft('gun_glock', {
	name = 'Glock',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_pistol.png',
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 1},  -- 1000
		{'craft_barrel', 1}, -- 1000
		{'craft_grip', 1}, -- 2000
		{'craft_trigger', 1}, -- 250
		{'craft_clip', 1}, -- 2000
		{'craft_piston', 1}, -- 125
		{'craft_pulley', 1}, -- 100
		{'craft_spring', 1}, -- 50
		{'craft_glue', 1}, -- 35
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_glock},
	}
})

octoinv.registerCraft('gun_usp', {
	name = 'USP',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_pistol.png',
	sound = benchSounds,
	jobs = {'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 1},
		{'craft_barrel', 2},
		{'craft_grip', 1},
		{'craft_drummer', 1},
		{'craft_trigger', 1},
		{'craft_stopper', 1},
		{'craft_clip', 1},
		{'craft_piston', 5},
		{'craft_pulley', 4},
		{'craft_spring', 3},
		{'craft_glue', 1},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_usp},
	}
})

octoinv.registerCraft('gun_usps', {
	name = 'USP-S',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_pistol.png',
	sound = benchSounds,
	jobs = {'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 1},
		{'craft_barrel', 2},
		{'craft_grip', 1},
		{'craft_drummer', 1},
		{'craft_trigger', 1},
		{'craft_stopper', 1},
		{'craft_clip', 1},
		{'craft_piston', 5},
		{'craft_pulley', 4},
		{'craft_spring', 3},
		{'craft_glue', 1},
		{'craft_silencer', 1},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_usps},
	}
})

octoinv.registerCraft('gun_p228', {
	name = 'P228',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_pistol.png',
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 1},
		{'craft_barrel', 2},
		{'craft_grip', 1},
		{'craft_drummer', 1},
		{'craft_trigger', 1},
		{'craft_stopper', 1},
		{'craft_clip', 1},
		{'craft_piston', 5},
		{'craft_pulley', 4},
		{'craft_spring', 3},
		{'craft_glue', 1},
		{'craft_sheet', 1},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_p228},
	}
})

octoinv.registerCraft('gun_fiveseven', {
	name = 'FiveseveN',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_pistol.png',
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 1},
		{'craft_barrel', 2},
		{'craft_grip', 1},
		{'craft_drummer', 3},
		{'craft_trigger', 1},
		{'craft_stopper', 2},
		{'craft_clip', 1},
		{'craft_piston', 5},
		{'craft_pulley', 4},
		{'craft_spring', 3},
		{'craft_glue', 1},
		{'craft_sheet', 3},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_fiveseven},
	}
})

octoinv.registerCraft('gun_deagle', {
	name = 'Desert Eagle',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_pistol.png',
	sound = benchSounds,
	jobs = {'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 2},
		{'craft_barrel', 2},
		{'craft_grip', 1},
		{'craft_drummer', 5},
		{'craft_trigger', 1},
		{'craft_stopper', 4},
		{'craft_clip', 1},
		{'craft_piston', 8},
		{'craft_pulley', 5},
		{'craft_spring', 5},
		{'craft_glue', 1},
		{'craft_sheet', 4},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_deagle},
	}
})

octoinv.registerCraft('gun_357', {
	name = 'Colt .357',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_revolver.png',
	sound = benchSounds,
	jobs = {'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 2},
		{'craft_barrel', 2},
		{'craft_grip', 1},
		{'craft_drummer', 6},
		{'craft_trigger', 1},
		{'craft_stopper', 6},
		{'craft_clip', 1},
		{'craft_piston', 8},
		{'craft_pulley', 5},
		{'craft_spring', 5},
		{'craft_glue', 1},
		{'craft_sheet', 4},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_357},
	}
})

octoinv.registerCraft('gun_dualelites', {
	name = 'Dual Elites',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_pistol.png',
	sound = benchSounds,
	jobs = {'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 2},
		{'craft_barrel', 4},
		{'craft_grip', 2},
		{'craft_drummer', 4},
		{'craft_trigger', 2},
		{'craft_stopper', 4},
		{'craft_clip', 2},
		{'craft_piston', 10},
		{'craft_pulley', 4},
		{'craft_spring', 4},
		{'craft_glue', 2},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_dualelites},
	}
})

octoinv.registerCraft('gun_mp5', {
	name = 'MP5',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_smg.png',
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 3},
		{'craft_barrel', 2},
		{'craft_grip', 2},
		{'craft_drummer', 5},
		{'craft_trigger', 1},
		{'craft_stopper', 5},
		{'craft_clip', 1},
		{'craft_piston', 8},
		{'craft_pulley', 5},
		{'craft_spring', 5},
		{'craft_glue', 1},
		{'craft_sheet', 4},
		{'craft_aim', 2},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_mp5},
	}
})

octoinv.registerCraft('gun_ump45', {
	name = 'UMP45',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_smg.png',
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 3},
		{'craft_barrel', 2},
		{'craft_grip', 2},
		{'craft_drummer', 5},
		{'craft_trigger', 1},
		{'craft_stopper', 5},
		{'craft_clip', 1},
		{'craft_piston', 8},
		{'craft_pulley', 5},
		{'craft_spring', 5},
		{'craft_glue', 1},
		{'craft_sheet', 3},
		{'craft_aim', 2},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_ump45},
	}
})

octoinv.registerCraft('gun_mac10', {
	name = 'MAC10',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_smg.png',
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 2},
		{'craft_barrel', 2},
		{'craft_grip', 1},
		{'craft_drummer', 5},
		{'craft_trigger', 1},
		{'craft_stopper', 5},
		{'craft_clip', 1},
		{'craft_piston', 8},
		{'craft_pulley', 5},
		{'craft_spring', 5},
		{'craft_glue', 1},
		{'craft_sheet', 2},
		{'craft_aim', 1},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_mac10},
	}
})

octoinv.registerCraft('gun_tmp', {
	name = 'TMP',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_smg.png',
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 3},
		{'craft_barrel', 2},
		{'craft_grip', 2},
		{'craft_drummer', 5},
		{'craft_trigger', 1},
		{'craft_stopper', 5},
		{'craft_clip', 1},
		{'craft_piston', 10},
		{'craft_pulley', 5},
		{'craft_spring', 5},
		{'craft_glue', 1},
		{'craft_sheet', 5},
		{'craft_aim', 2},
		{'craft_silencer', 1},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_tmp},
	}
})

octoinv.registerCraft('gun_m3', {
	name = 'M3',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_shotgun.png',
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 3},
		{'craft_barrel', 3},
		{'craft_grip', 2},
		{'craft_drummer', 8},
		{'craft_trigger', 1},
		{'craft_stopper', 8},
		{'craft_clip', 1},
		{'craft_piston', 12},
		{'craft_pulley', 8},
		{'craft_spring', 8},
		{'craft_glue', 1},
		{'craft_sheet', 3},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_m3},
	}
})

octoinv.registerCraft('gun_p90', {
	name = 'P90',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_smg.png',
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 3},
		{'craft_barrel', 2},
		{'craft_grip', 2},
		{'craft_drummer', 6},
		{'craft_trigger', 1},
		{'craft_stopper', 5},
		{'craft_clip', 2},
		{'craft_piston', 12},
		{'craft_pulley', 8},
		{'craft_spring', 5},
		{'craft_glue', 1},
		{'craft_sheet', 6},
		{'craft_aim', 2},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_p90},
	}
})

octoinv.registerCraft('gun_galil', {
	name = 'Galil',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_rifle.png',
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 3},
		{'craft_barrel', 2},
		{'craft_grip', 2},
		{'craft_drummer', 6},
		{'craft_trigger', 1},
		{'craft_stopper', 5},
		{'craft_clip', 3},
		{'craft_piston', 12},
		{'craft_pulley', 8},
		{'craft_spring', 5},
		{'craft_glue', 1},
		{'craft_sheet', 6},
		{'craft_aim', 2},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_galil},
	}
})

octoinv.registerCraft('gun_scout', {
	name = 'Scout',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_sniper.png',
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 3},
		{'craft_barrel', 2},
		{'craft_grip', 2},
		{'craft_drummer', 6},
		{'craft_trigger', 1},
		{'craft_stopper', 5},
		{'craft_clip', 3},
		{'craft_piston', 12},
		{'craft_pulley', 8},
		{'craft_spring', 5},
		{'craft_glue', 1},
		{'craft_sheet', 6},
		{'craft_sight', 1},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_scout},
	}
})

octoinv.registerCraft('gun_famas', {
	name = 'FAMAS',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_rifle.png',
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 3},
		{'craft_barrel', 2},
		{'craft_grip', 2},
		{'craft_drummer', 6},
		{'craft_trigger', 1},
		{'craft_stopper', 5},
		{'craft_clip', 3},
		{'craft_piston', 12},
		{'craft_pulley', 10},
		{'craft_spring', 8},
		{'craft_glue', 1},
		{'craft_sheet', 6},
		{'craft_aim', 4},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_famas},
	}
})

octoinv.registerCraft('gun_xm1014', {
	name = 'XM1014',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_shotgun.png',
	sound = benchSounds,
	jobs = {'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 3},
		{'craft_barrel', 2},
		{'craft_grip', 2},
		{'craft_drummer', 10},
		{'craft_trigger', 1},
		{'craft_stopper', 10},
		{'craft_clip', 3},
		{'craft_piston', 12},
		{'craft_pulley', 10},
		{'craft_spring', 8},
		{'craft_glue', 1},
		{'craft_sheet', 6},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_xm1014},
	}
})

octoinv.registerCraft('gun_ak', {
	name = 'AK',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_rifle.png',
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 3},
		{'craft_barrel', 3},
		{'craft_grip', 3},
		{'craft_drummer', 8},
		{'craft_trigger', 1},
		{'craft_stopper', 8},
		{'craft_clip', 3},
		{'craft_piston', 12},
		{'craft_pulley', 10},
		{'craft_spring', 8},
		{'craft_glue', 1},
		{'craft_sheet', 6},
		{'craft_aim', 4},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_ak},
	}
})

octoinv.registerCraft('gun_m4a1', {
	name = 'M4A1',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_rifle.png',
	sound = benchSounds,
	jobs = {'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 4},
		{'craft_barrel', 3},
		{'craft_grip', 3},
		{'craft_drummer', 6},
		{'craft_trigger', 1},
		{'craft_stopper', 8},
		{'craft_clip', 3},
		{'craft_piston', 12},
		{'craft_pulley', 10},
		{'craft_spring', 8},
		{'craft_glue', 1},
		{'craft_sheet', 8},
		{'craft_aim', 5},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_m4a1},
	}
})

octoinv.registerCraft('gun_aug', {
	name = 'AUG',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_sniper.png',
	sound = benchSounds,
	jobs = {'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 4},
		{'craft_barrel', 3},
		{'craft_grip', 3},
		{'craft_drummer', 6},
		{'craft_trigger', 1},
		{'craft_stopper', 8},
		{'craft_clip', 3},
		{'craft_piston', 12},
		{'craft_pulley', 10},
		{'craft_spring', 8},
		{'craft_glue', 1},
		{'craft_sheet', 10},
		{'craft_sight', 3},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_aug},
	}
})

octoinv.registerCraft('gun_sg552', {
	name = 'SG552',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_sniper.png',
	sound = benchSounds,
	jobs = {'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 4},
		{'craft_barrel', 3},
		{'craft_grip', 3},
		{'craft_drummer', 6},
		{'craft_trigger', 1},
		{'craft_stopper', 8},
		{'craft_clip', 3},
		{'craft_piston', 12},
		{'craft_pulley', 10},
		{'craft_spring', 8},
		{'craft_glue', 1},
		{'craft_sheet', 10},
		{'craft_sight', 3},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_sg552},
	}
})

octoinv.registerCraft('gun_awp', {
	name = 'AWP',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_sniper.png',
	sound = benchSounds,
	jobs = {'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 4},
		{'craft_barrel', 3},
		{'craft_grip', 3},
		{'craft_drummer', 12},
		{'craft_trigger', 1},
		{'craft_stopper', 12},
		{'craft_clip', 3},
		{'craft_piston', 12},
		{'craft_pulley', 10},
		{'craft_spring', 15},
		{'craft_glue', 1},
		{'craft_sheet', 10},
		{'craft_sight', 5},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_awp},
	}
})

octoinv.registerCraft('gun_g3sg1', {
	name = 'G3SG1',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_sniper.png',
	sound = benchSounds,
	jobs = {'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 4},
		{'craft_barrel', 3},
		{'craft_grip', 3},
		{'craft_drummer', 8},
		{'craft_trigger', 1},
		{'craft_stopper', 8},
		{'craft_clip', 5},
		{'craft_piston', 12},
		{'craft_pulley', 10},
		{'craft_spring', 10},
		{'craft_glue', 1},
		{'craft_sheet', 10},
		{'craft_sight', 3},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_g3sg1},
	}
})

octoinv.registerCraft('gun_sg550', {
	name = 'SG550',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_sniper.png',
	sound = benchSounds,
	jobs = {'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 5},
		{'craft_barrel', 5},
		{'craft_grip', 3},
		{'craft_drummer', 8},
		{'craft_trigger', 1},
		{'craft_stopper', 8},
		{'craft_clip', 5},
		{'craft_piston', 12},
		{'craft_pulley', 10},
		{'craft_spring', 12},
		{'craft_glue', 1},
		{'craft_sheet', 10},
		{'craft_sight', 3},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_sg550},
	}
})

octoinv.registerCraft('gun_m249', {
	name = 'M249',
	desc = L.weapons,
	conts = {'workbench'},
	icon = 'octoteam/icons/gun_rifle.png',
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 15,
	ings = {
		{'craft_shutter', 3},
		{'craft_barrel', 5},
		{'craft_grip', 3},
		{'craft_drummer', 8},
		{'craft_trigger', 1},
		{'craft_stopper', 10},
		{'craft_clip', 25},
		{'craft_piston', 20},
		{'craft_pulley', 20},
		{'craft_spring', 15},
		{'craft_glue', 1},
		{'craft_aim', 5},
	},
	finish = {
		{'weapon', octoinv.gunsItemData.weapon_octo_m249},
	}
})

------------------------------------------------
--
-- CRAFTABLE ITEMS
--
------------------------------------------------

octoinv.registerCraft('craft_aim', {
	name = L.crosshair,
	desc = L.weapons,
	conts = {'workbench'},
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 5,
	tools = {
		{'tool_screwer', 1},
	},
	ings = {
		{'craft_barrel', 1},
		{'craft_glass', 2},
	},
	finish = {
		{'craft_sight', 1},
	}
})

octoinv.registerCraft('craft_silencer', {
	name = L.silencer,
	desc = L.weapons,
	conts = {'workbench'},
	sound = benchSounds,
	jobs = {'gun', 'gun2'},
	time = 5,
	tools = {
		{'tool_screwer', 1},
	},
	ings = {
		{'craft_barrel', 1},
		{'craft_sheet', 1},
		{'craft_glue', 1},
	},
	finish = {
		{'craft_silencer', 1},
	}
})

octoinv.registerCraft('gunpowder', {
	name = L.gunpowder,
	desc = L.descCraft,
	conts = {'workbench'},
	sound = benchSounds,
	time = 10,
	tools = {
		{'tool_hammer', 1},
	},
	ings = {
		{'craft_coal', 1},
		{'sulfur', 1},
		{'saltpeter', 1},
	},
	finish = {
		{'gunpowder', 5},
	},
})
