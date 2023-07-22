octoinv.registerProd('smelter', {
	name = L.smelter,
	icon = 'octoteam/icons/smelter.png',
	mass = 700,
	destruct = {
		{'bpd_smelter', 1},
	},
	fuel = {
		smelter_fuel = {
			craft_fuel = 30,
			craft_coal = 180,
		},
	},
	sounds = {
		loop = 'octoinv.prod15',
		work = 'octoinv.prod11',
	},
})

octoinv.registerProcess('smelter', {
	time = 30,
	ins = {smelter = {{'sand', 1}}},
	out = {smelter = {{'craft_glass', 10}}},
})

octoinv.registerProcess('smelter', {
	time = 5,
	ins = {smelter = {{'craft_bottle', 1}}},
	out = {smelter = {{'craft_glass', 2}}},
})
