octoinv.registerProd('fridge', {
	name = L.fridge,
	icon = 'octoteam/icons/fridge.png',
	destruct = {
		{'bpd_fridge', 1},
	},
	sounds = {
		loop = 'octoinv.prod14',
		work = 'octoinv.prod12',
	},
})

octoinv.registerProcess('fridge', {
	time = 90,
	ins = {fridge = {
		{'tool_foodcont', 1},
		{'ing_icecream', 1},
		{'ing_banana', 2},
		{'ing_strawberry', 2},
		{'ing_cocoa', 2},
	}},
	out = {fridge = {{'food', {
		name = L.strawberry_banana_ice_cream,
		desc = L.desc_strawberry_banana_ice_cream,
		energy = 35,
		icon = 'octoteam/icons/food_icecream.png'
	}}}},
})

octoinv.registerProcess('fridge', {
	time = 90,
	ins = {fridge = {
		{'tool_foodcont', 1},
		{'ing_dough3', 1},
		{'ing_cream', 1},
		{'ing_strawberry', 1},
		{'ing_cocoa', 1},
	}},
	out = {fridge = {{'food', {
		name = L.muffin,
		energy = 25,
		icon = 'octoteam/icons/food_cupcake.png'
	}}}},
})

octoinv.registerProcess('fridge', {
	time = 60,
	ins = {fridge = {
		{'tool_foodcont', 1},
		{'ing_sugar', 2},
		{'ing_cocoa', 2},
		{'ing_cream', 1},
	}},
	out = {fridge = {{'food', {
		name = L.ing_choco,
		energy = 25,
		icon = 'octoteam/icons/food_choco.png'
	}}}},
})

octoinv.registerProcess('fridge', {
	time = 60,
	ins = {fridge = {
		{'tool_shaker', 1},
		{'tool_foodcont', 1},
		{'ing_sugar', 2},
		{'ing_milk', 1},
		{'ing_icecream', 1},
		{'ing_banana', 1},
	}},
	out = {fridge = {{'tool_shaker', 1} ,{'food', {
		name = L.milkshake,
		energy = 40,
		icon = 'octoteam/icons/food_milkshake.png',
		drink = true,
	}}}},
})
