octoinv.registerProd('refinery', {
	name = L.refinery,
	icon = 'octoteam/icons/chem_plant.png',
	mass = 1000,
	destruct = {
		{'bpd_refinery', 1},
	},
	fuel = {
		refinery_fuel = {
			craft_fuel = 30,
			craft_coal = 180,
		}
	},
	sounds = {
		loop = 'octoinv.prod3',
		work = 'octoinv.prod4',
	},
})

octoinv.registerProcess('refinery', {
	time = 10,
	ins = {refinery = {{'ore_iron', 1}}},
	out = {refinery = {{'ingot_iron', 1}}},
})

octoinv.registerProcess('refinery', {
	time = 30,
	ins = {refinery = {{'ore_steel', 1}}},
	out = {refinery = {{'ingot_steel', 1}}},
})

octoinv.registerProcess('refinery', {
	time = 20,
	ins = {refinery = {{'ore_bronze', 1}}},
	out = {refinery = {{'ingot_bronze', 1}}},
})

octoinv.registerProcess('refinery', {
	time = 45,
	ins = {refinery = {{'ore_gold', 1}}},
	out = {refinery = {{'ingot_gold', 1}}},
})

octoinv.registerProcess('refinery', {
	time = 15,
	ins = {refinery = {{'ore_copper', 1}}},
	out = {refinery = {{'ingot_copper', 1}}},
})

octoinv.registerProcess('refinery', {
	time = 40,
	ins = {refinery = {{'ore_silver', 1}}},
	out = {refinery = {{'ingot_silver', 1}}},
})

octoinv.registerProcess('refinery', {
	time = 10,
	ins = {refinery = {{'stone', 1}}},
	out = {refinery = {
		{'rubble', 1},
		{0.05, 'sulfur', 1},
		{0.1, 'craft_coal', 1},
	}},
})

octoinv.registerProcess('refinery', {
	time = 15,
	ins = {refinery = {{'rubble', 1}}},
	out = {refinery = {
		{'sand', 1},
		{0.005, 'jewelry_diamond', 1},
		{0.005, 'jewelry_ruby', 1},
		{0.005, 'jewelry_sapphire', 1},
		{0.005, 'jewelry_topaz', 1},
		{0.005, 'jewelry_emerald', 1},
	}},
})
