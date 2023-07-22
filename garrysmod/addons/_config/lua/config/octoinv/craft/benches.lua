------------------------------------------------
--
-- BENCHES
--
------------------------------------------------

local drillSounds = {
	'ambient/machines/pneumatic_drill_1.wav',
	'ambient/machines/pneumatic_drill_2.wav',
	'ambient/machines/pneumatic_drill_4.wav',
}

octoinv.registerCraft('bpd_stove', {
	name = L.stove,
	desc = L.desc_bpd_stove,
	icon = 'octoteam/icons/box3.png',
	conts = {'_hand'},
	sound = drillSounds,
	soundTime = 2,
	time = 30,
	tools = {
		{'tool_screwer', 1},
		{'tool_wrench', 1},
		{'tool_solder', 1},
		{'tool_drill', 1},
	},
	ings = {
		{'craft_cable', 4},
		{'craft_bulb', 4},
		{'craft_sheet', 2},
		{'craft_plug', 1},
		{'craft_gauge', 1},
		{'craft_relay', 2},
		{'craft_transistor', 4},
		{'craft_resistor', 2},
	},
	finish = {
		{'bpd_stove', 1},
	},
}) octoinv.registerCraft('cont_stove', {
	name = L.stove,
	desc = L.desc_cont_stove,
	icon = 'octoteam/icons/stove.png',
	previewModel = 'models/props_c17/furniturestove001a.mdl',
	conts = {'_hand'},
	sound = drillSounds,
	soundTime = 2,
	time = 30,
	tools = {
		{'tool_craft', 1},
	},
	ings = {
		{'bp_stove', 1},
		{'bpd_stove', 1},
		{'craft_battery', 1},
	},
	finish = octoinv.spawnProd({
		mdl = 'models/props_c17/furniturestove001a.mdl',
		conts = {
			stove = { name = L.stove, volume = 40, icon = octolib.icons.color('stove'), craft = true, prod = true },
			oven = { name = L.oven, volume = 60, icon = octolib.icons.color('stove'), craft = true },
		},
		prod = 'stove',
	}),
})

octoinv.registerCraft('bpd_fridge', {
	name = L.fridge,
	desc = L.desc_bpd_fridge,
	icon = 'octoteam/icons/box3.png',
	conts = {'_hand'},
	sound = drillSounds,
	soundTime = 2,
	time = 30,
	tools = {
		{'tool_screwer', 1},
		{'tool_drill', 1},
		{'tool_solder', 1},
	},
	ings = {
		{'craft_cable', 3},
		{'craft_spring', 2},
		{'craft_sheet', 1},
		{'craft_pulley', 2},
		{'craft_plug', 1},
		{'craft_bulb', 4},
		{'craft_transistor', 2},
		{'craft_resistor', 2},
		{'craft_relay', 4},
	},
	finish = {
		{'bpd_fridge', 1},
	},
}) octoinv.registerCraft('cont_fridge', {
	name = L.fridge,
	desc = L.desc_cont_fridge,
	icon = 'octoteam/icons/fridge.png',
	previewModel = 'models/props_c17/furniturefridge001a.mdl',
	conts = {'_hand'},
	sound = drillSounds,
	soundTime = 2,
	time = 30,
	tools = {
		{'tool_craft', 1},
	},
	ings = {
		{'bp_fridge', 1},
		{'bpd_fridge', 1},
		{'craft_battery', 1},
	},
	finish = octoinv.spawnProd({
		mdl = 'models/props_c17/furniturefridge001a.mdl',
		conts = {
			fridge = { name = L.fridge, volume = 60, icon = octolib.icons.color('fridge'), prod = true },
		},
		prod = 'fridge',
	}),
})

octoinv.registerCraft('bpd_machine', {
	name = L.machine,
	desc = L.desc_bpd_machine,
	icon = 'octoteam/icons/box3.png',
	conts = {'_hand'},
	sound = drillSounds,
	soundTime = 2,
	time = 30,
	tools = {
		{'tool_caliper', 1},
		{'tool_solder', 1},
		{'tool_screwer', 1},
		{'tool_drill', 1},
		{'tool_wrench', 1},
	},
	ings = {
		{'craft_cable', 3},
		{'craft_piston', 2},
		{'craft_spring', 4},
		{'craft_sheet', 2},
		{'craft_pulley', 2},
		{'craft_plug', 1},
		{'craft_engine', 1},
		{'craft_gauge', 2},
	},
	finish = {
		{'bpd_machine', 1},
	},
}) octoinv.registerCraft('cont_machine', {
	name = L.machine,
	desc = L.desc_cont_machine,
	icon = 'octoteam/icons/machine.png',
	previewModel = 'models/codeandmodeling_samgaze_gta/gr_prop_gr_vertmill_01c.mdl',
	conts = {'_hand'},
	sound = drillSounds,
	soundTime = 2,
	time = 30,
	tools = {
		{'tool_craft', 1},
	},
	ings = {
		{'bp_machine', 1},
		{'bpd_machine', 1},
		{'craft_battery', 1},
	},
	finish = octoinv.spawnProd({
		mdl = 'models/codeandmodeling_samgaze_gta/gr_prop_gr_vertmill_01c.mdl',
		conts = {
			machine_tray = { name = L.machine_tray, volume = 60, icon = octolib.icons.color('machine'), prod = true },
			machine = { name = L.machine, volume = 60, icon = octolib.icons.color('machine') },
		},
		prod = 'machine'
	}),
})

octoinv.registerCraft('bpd_workbench', {
	name = L.workbench,
	desc = L.desc_bpd_workbench,
	icon = 'octoteam/icons/box3.png',
	conts = {'_hand'},
	sound = drillSounds,
	soundTime = 2,
	time = 30,
	tools = {
		{'tool_caliper', 1},
		{'tool_solder', 1},
		{'tool_wrench', 1},
		{'tool_hammer', 1},
		{'tool_drill', 1},
	},
	ings = {
		{'craft_cable', 2},
		{'craft_piston', 4},
		{'craft_spring', 4},
		{'craft_bulb', 2},
		{'craft_plank', 2},
		{'craft_pulley', 2},
		{'craft_plug', 1},
		{'craft_engine', 1},
	},
	finish = {
		{'bpd_workbench', 1},
	},
}) octoinv.registerCraft('cont_workbench', {
	name = L.workbench,
	desc = L.cont_workbench,
	icon = 'octoteam/icons/table.png',
	previewModel = 'models/codeandmodeling_samgaze_gta/prop_tool_bench02.mdl',
	conts = {'_hand'},
	sound = drillSounds,
	soundTime = 2,
	time = 30,
	tools = {
		{'tool_craft', 1},
	},
	ings = {
		{'bp_workbench', 1},
		{'bpd_workbench', 1},
	},
	finish = octoinv.spawnCont('models/codeandmodeling_samgaze_gta/prop_tool_bench02.mdl', {
		workbench = { name = L.workbench, volume = 100, icon = octolib.icons.color('table'), craft = true },
	},{
		destruct = {
			{'bpd_workbench', 1},
		},
	}),
})

octoinv.registerCraft('bpd_refinery', {
	name = L.refinery,
	desc = L.desc_bpd_refinery,
	icon = 'octoteam/icons/box3.png',
	conts = {'_hand'},
	sound = drillSounds,
	soundTime = 2,
	time = 30,
	tools = {
		{'tool_drill', 1},
		{'tool_screwer', 1},
		{'tool_caliper', 1},
	},
	ings = {
		{'craft_cable', 2},
		{'craft_sheet', 2},
		{'craft_pulley', 2},
		{'craft_plug', 1},
		{'craft_chip2', 2},
		{'craft_resistor', 2},
		{'craft_gauge', 4},
		{'craft_engine', 1},
	},
	finish = {
		{'bpd_refinery', 1},
	},
}) octoinv.registerCraft('cont_refinery', {
	name = L.refinery,
	desc = L.desc_refinery,
	icon = 'octoteam/icons/chem_plant.png',
	previewModel = 'models/mark2580/gtav/garage_stuff/sand_blaster_01a.mdl',
	previewRotation = 90,
	conts = {'_hand'},
	sound = drillSounds,
	soundTime = 2,
	time = 30,
	tools = {
		{'tool_craft', 1},
	},
	ings = {
		{'bp_refinery', 1},
		{'bpd_refinery', 1},
	},
	finish = octoinv.spawnProd({
		mdl = 'models/mark2580/gtav/garage_stuff/sand_blaster_01a.mdl',
		conts = {
			refinery_fuel = { name = L.refinery_fuel, volume = 100, icon = octolib.icons.color('chem_plant'), prod = true },
			refinery = { name = L.refinery, volume = 100, icon = octolib.icons.color('chem_plant') },
		},
		prod = 'refinery',
		rotate = 90,
	}),
})

octoinv.registerCraft('bpd_smelter', {
	name = L.smelter,
	desc = L.desc_bpd_smelter,
	icon = 'octoteam/icons/box3.png',
	conts = {'_hand'},
	sound = drillSounds,
	soundTime = 2,
	time = 30,
	tools = {
		{'tool_drill', 1},
		{'tool_screwer', 1},
		{'tool_caliper', 1},
	},
	ings = {
		{'ingot_iron', 1},
		{'craft_sheet', 2},
		{'craft_pulley', 2},
		{'craft_gauge', 2},
	},
	finish = {
		{'bpd_smelter', 1},
	},
}) octoinv.registerCraft('cont_smelter', {
	name = L.smelter,
	desc = L.desc_smelter,
	icon = 'octoteam/icons/smelter.png',
	previewModel = 'models/props/de_train/processor.mdl',
	previewRotation = 90,
	conts = {'_hand'},
	sound = drillSounds,
	soundTime = 2,
	time = 30,
	tools = {
		{'tool_craft', 1},
	},
	ings = {
		{'bp_smelter', 1},
		{'bpd_smelter', 1},
	},
	finish = octoinv.spawnProd({
		mdl = 'models/props/de_train/processor.mdl',
		conts = {
			smelter_fuel = { name = L.smelter_fuel, volume = 100, icon = octolib.icons.color('smelter'), prod = true },
			smelter = { name = L.smelter, volume = 100, icon = octolib.icons.color('smelter') },
		},
		prod = 'smelter',
		rotate = 90,
	}),
})
