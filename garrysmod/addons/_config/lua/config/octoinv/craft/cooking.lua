------------------------------------------------
--
-- COOKING
--
------------------------------------------------

local cookSounds = {
	'physics/flesh/flesh_squishy_impact_hard1.wav',
	'physics/flesh/flesh_squishy_impact_hard2.wav',
	'physics/flesh/flesh_squishy_impact_hard3.wav',
	'physics/flesh/flesh_squishy_impact_hard4.wav',
	'physics/plastic/plastic_box_impact_soft1.wav',
	'physics/plastic/plastic_box_impact_soft2.wav',
	'physics/plastic/plastic_box_impact_soft3.wav',
	'physics/plastic/plastic_box_impact_soft4.wav',
	'physics/plastic/plastic_box_break1.wav',
	'physics/plastic/plastic_box_break2.wav',
}

--
-- INGREDIENTS
--

octoinv.registerCraft('ing_dough1', {
	name = L.dough1,
	desc = L.desc_dough1,
	conts = {'stove'},
	sound = cookSounds,
	time = 15,
	ings = {
		{'ing_flour', 1},
		{'ing_salt', 1},
		{'ing_milk', 1},
		{'ing_egg', 2},
	},
	finish = {
		{'ing_dough1', 1},
	}
})

octoinv.registerCraft('ing_dough2', {
	name = L.dough2,
	desc = L.desc_dough2,
	conts = {'stove'},
	sound = cookSounds,
	time = 15,
	ings = {
		{'ing_flour', 1},
		{'ing_sugar', 1},
		{'ing_egg', 2},
	},
	finish = {
		{'ing_dough2', 1},
	}
})

octoinv.registerCraft('ing_icecream', {
	name = L.ing_icecream2,
	desc = L.desc_ing_icecream,
	conts = {'stove'},
	sound = cookSounds,
	time = 5,
	tools = {
		{'tool_scoop', 1},
	},
	ings = {
		{'ing_cream', 2},
		{'ing_sugar', 2},
	},
	finish = {
		{'ing_icecream', 1},
	}
})

octoinv.registerCraft('ing_potatomash', {
	name = L.potatomash,
	desc = L.desc_potatomash,
	conts = {'stove'},
	sound = cookSounds,
	time = 10,
	tools = {
		{'tool_pot', 1},
	},
	ings = {
		{'ing_potato2', 2},
		{'ing_oil', 1},
		{'ing_salt', 1},
		{'ing_milk', 1},
	},
	finish = {
		{'ing_potatomash', 1},
	},
})

--
-- DISHES
--

octoinv.registerCraft('food_meatpotato', {
	name = L.meatpotato,
	desc = L.desc_meatpotato,
	conts = {'stove'},
	sound = cookSounds,
	time = 4,
	ings = {
		{'tool_foodcont', 1},
		{'ing_potatomash', 1},
		{'ing_meatball', 1},
	},
	finish = {
		{'food', {
			name = L.meatpotato,
			icon = 'octoteam/icons/food_mashed_potato_with_cutlet.png',
			energy = 70,
		}},
	}
})

octoinv.registerCraft('food_okroshka', {
	name = L.okroshka,
	desc = L.desc_okroshka,
	conts = {'stove'},
	sound = cookSounds,
	time = 10,
	tools = {
		{'tool_pot', 1},
	},
	ings = {
		{'tool_foodcont', 1},
		{'ing_egg', 2},
		{'ing_salt', 1},
		{'ing_cucumber', 2},
		{'ing_potato2', 3},
	},
	finish = {
		{'food', {
			name = L.okroshka,
			icon = 'octoteam/icons/food_soup.png',
			energy = 65,
		}},
	}
})

octoinv.registerCraft('food_sandwitch', {
	name = L.sandwitch,
	desc = L.desc_sandwitch,
	conts = {'stove', '_hand'},
	sound = cookSounds,
	time = 10,
	ings = {
		{'ing_sausage2', 1},
		{'ing_bread', 1},
	},
	finish = {
		{'food', {
			name = L.sandwitch,
			icon = 'octoteam/icons/food_sandwich_simple.png',
			energy = 15,
		}},
	}
})

-- octoinv.registerCraft('food_sushi', {
-- 	name = L.sushi,
-- 	desc = L.desc_sushi,
-- 	conts = {'stove'},
-- 	sound = cookSounds,
-- 	time = 10,
-- 	tools = {
-- 		{'tool_scoop', 1},
-- 	},
-- 	ings = {
-- 		{'tool_foodcont', 1},
-- 		{'ing_fish1', 2},
-- 		{'ing_rice', 2},
-- 	},
-- 	finish = {
-- 		{'food', {
-- 			name = L.sushi,
-- 			icon = 'octoteam/icons/food_sushi.png',
-- 			energy = 35,
-- 		}},
-- 	}
-- })

octoinv.registerCraft('food_wrap', {
	name = L.wrap,
	desc = L.desc_wrap,
	conts = {'stove'},
	sound = cookSounds,
	time = 10,
	ings = {
		{'tool_foodcont', 1},
		{'ing_roastmeat', 2},
		{'ing_lettuce', 1},
		{'ing_salt', 1},
		{'ing_pita', 1},
		{'ing_tomato', 1},
	},
	finish = {
		{'food', {
			name = L.wrap,
			icon = 'octoteam/icons/food_wrap.png',
			energy = 60,
		}},
	}
})

octoinv.registerCraft('food_cake_med', {
	name = L.cake_med,
	desc = L.desc_cake_med,
	conts = {'stove'},
	sound = cookSounds,
	time = 10,
	ings = {
		{'tool_foodcont', 1},
		{'ing_dough3', 1},
		{'ing_sugar', 2},
		{'ing_cocoa', 2},
		{'ing_cream', 1},
		{'ing_honey', 2},
	},
	finish = {
		{'food', {
			name = L.cake_med,
			icon = 'octoteam/icons/food_honey_cake.png',
			energy = 100,
		}},
	}
})

octoinv.registerCraft('food_ceasar', {
	name = L.ceasar,
	desc = L.desc_ceasar,
	conts = {'stove'},
	sound = cookSounds,
	time = 10,
	ings = {
		{'tool_foodcont', 1},
		{'ing_roastmeat', 1},
		{'ing_salt', 1},
		{'ing_oil', 1},
		{'ing_egg', 2},
		{'ing_lettuce', 1},
		{'ing_cheese', 1},
		{'ing_tomato', 2},
	},
	finish = {
		{'food', {
			name = L.ceasar,
			icon = 'octoteam/icons/food_caesar_salad.png',
			energy = 65,
		}},
	}
})

octoinv.registerCraft('food_burger1', {
	name = L.burger,
	desc = L.desc_burger,
	conts = {'stove'},
	sound = cookSounds,
	time = 10,
	ings = {
		{'tool_foodcont', 1},
		{'ing_bread', 2},
		{'ing_sauce', 1},
		{'ing_meatball', 1},
	},
	finish = {
		{'food', {
			name = L.burger,
			icon = 'octoteam/icons/food_hamburger.png',
			energy = 35,
		}},
	}
})

octoinv.registerCraft('food_burger2', {
	name = L.burger2,
	desc = L.desc_burger2,
	conts = {'stove'},
	sound = cookSounds,
	time = 10,
	ings = {
		{'tool_foodcont', 1},
		{'ing_bread', 2},
		{'ing_sauce', 1},
		{'ing_meatball', 1},
		{'ing_lettuce', 1},
		{'ing_cheese', 1},
	},
	finish = {
		{'food', {
			name = L.burger2,
			icon = 'octoteam/icons/food_cheeseburger.png',
			energy = 45,
		}},
	}
})

octoinv.registerCraft('food_burger3', {
	name = L.burger3,
	desc = L.desc_burger3,
	conts = {'stove'},
	sound = cookSounds,
	time = 10,
	ings = {
		{'tool_foodcont', 1},
		{'ing_bread', 2},
		{'ing_sauce', 1},
		{'ing_meatball', 2},
		{'ing_lettuce', 1},
		{'ing_cheese', 1},
		{'ing_tomato', 2},
		{'ing_onion', 1},
		{'ing_cucumber', 2},
	},
	finish = {
		{'food', {
			name = L.burger3,
			icon = 'octoteam/icons/food_bigmack.png',
			energy = 100,
		}},
	}
})

octoinv.registerCraft('food_coffeetail', {
	name = L.coffeetail2,
	conts = {'stove'},
	sound = cookSounds,
	time = 10,
	tools = {
		{'tool_shaker', 1},
	},
	ings = {
		{'tool_foodcont', 1},
		{'drug_booze2', 1},
		{'ing_water', 1},
		{'ing_coffee', 2},
		{'ing_sugar', 4},
	},
	finish = {
		{'food', {
			name = L.coffeetail2,
			icon = 'octoteam/icons/food_cocktail.png',
			energy = 15,
			drink = true,
		}},
	}
})

octoinv.registerCraft('food_coffeetail', {
	name = L.coffeetail,
	conts = {'stove'},
	sound = cookSounds,
	time = 15,
	tools = {
		{'tool_pot', 1},
		{'tool_shaker', 1},
	},
	ings = {
		{'tool_foodcont', 1},
		{'ing_milk', 1},
		{'ing_egg', 1},
		{'ing_sugar', 4},
		{'ing_honey', 1},
		{'ing_salt', 1},
	},
	finish = {
		{'food', {
			name = L.coffeetail,
			icon = 'octoteam/icons/food_gogol_mogul.png',
			energy = 30,
			drink = true,
		}},
	}
})
