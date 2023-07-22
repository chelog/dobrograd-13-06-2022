octoinv.registerProd('machine', {
	name = L.machine,
	icon = 'octoteam/icons/machine.png',
	mass = 400,
	destruct = {
		{'bpd_machine', 1},
	},
	sounds = {
		loop = 'octoinv.prod12',
		work = 'octoinv.prod9',
	},
})

octoinv.registerProcess('machine', {
	time = 15,
	ins = {machine = {{'ingot_steel', 1}}, machine_tray = {{'bp_shutter', 1}}},
	out = {machine = {{'craft_shutter', 2}}},
})

octoinv.registerProcess('machine', {
	time = 10,
	ins = {machine = {{'ingot_steel', 1}}, machine_tray = {{'bp_barrel', 1}}},
	out = {machine = {{'craft_barrel', 2}}},
})

octoinv.registerProcess('machine', {
	time = 10,
	ins = {machine = {{'ingot_steel', 1}}, machine_tray = {{'bp_grip', 1}}},
	out = {machine = {{'craft_grip', 1}}},
})

octoinv.registerProcess('machine', {
	time = 10,
	ins = {machine = {{'ingot_steel', 1}}, machine_tray = {{'bp_aim', 1}}},
	out = {machine = {{'craft_aim', 7}}},
})

octoinv.registerProcess('machine', {
	time = 10,
	ins = {machine = {{'ingot_steel', 1}}, machine_tray = {{'bp_drummer', 1}}},
	out = {machine = {{'craft_drummer', 5}}},
})

octoinv.registerProcess('machine', {
	time = 10,
	ins = {machine = {{'ingot_steel', 1}}, machine_tray = {{'bp_trigger', 1}}},
	out = {machine = {{'craft_trigger', 8}}},
})

octoinv.registerProcess('machine', {
	time = 10,
	ins = {machine = {{'ingot_steel', 1}}, machine_tray = {{'bp_stopper', 1}}},
	out = {machine = {{'craft_stopper', 5}}},
})

octoinv.registerProcess('machine', {
	time = 10,
	ins = {machine = {{'ingot_steel', 1}}, machine_tray = {{'bp_clip', 1}}},
	out = {machine = {{'craft_clip', 1}}},
})

octoinv.registerProcess('machine', {
	time = 10,
	ins = {machine = {{'ingot_iron', 1}}, machine_tray = {{'bp_screw', 1}}},
	out = {machine = {{'craft_screw', 30}}},
})

octoinv.registerProcess('machine', {
	time = 10,
	ins = {machine = {{'ingot_iron', 1}}, machine_tray = {{'bp_screw2', 1}}},
	out = {machine = {{'craft_screw2', 25}}},
})

octoinv.registerProcess('machine', {
	time = 10,
	ins = {machine = {{'ingot_iron', 1}}, machine_tray = {{'bp_screwnut', 1}}},
	out = {machine = {{'craft_screwnut', 30}}},
})

octoinv.registerProcess('machine', {
	time = 10,
	ins = {machine = {{'ingot_iron', 1}}, machine_tray = {{'bp_nail', 1}}},
	out = {machine = {{'craft_nail', 40}}},
})

octoinv.registerProcess('machine', {
	time = 10,
	ins = {machine = {{'ingot_iron', 1}}, machine_tray = {{'bp_spring', 1}}},
	out = {machine = {{'craft_spring', 10}}},
})

octoinv.registerProcess('machine', {
	time = 10,
	ins = {machine = {{'ingot_iron', 1}}, machine_tray = {{'bp_pulley', 1}}},
	out = {machine = {{'craft_pulley', 5}}},
})

octoinv.registerProcess('machine', {
	time = 10,
	ins = {machine = {{'ingot_iron', 1}}, machine_tray = {{'bp_piston', 1}}},
	out = {machine = {{'craft_piston', 4}}},
})

octoinv.registerProcess('machine', {
	time = 10,
	ins = {machine = {{'craft_glass', 1}}, machine_tray = {{'bp_bulb', 1}}},
	out = {machine = {{'craft_bulb', 3}}},
})
