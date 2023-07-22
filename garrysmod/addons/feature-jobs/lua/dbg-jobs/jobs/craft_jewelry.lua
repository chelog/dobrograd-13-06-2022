local function createItem(id, name, icon, mass, volume)
	octoinv.registerItem(id, {
		name = name,
		icon = icon,
		mass = mass,
		volume = volume,
	})
end

createItem('jewelry_chain_gold', 'Золотая цепь', octolib.icons.color('chain_gold'), 0.1, 0.1) -- 1100Р
createItem('jewelry_chain_silver', 'Серебряная цепь', octolib.icons.color('chain_silver'), 0.1, 0.1) -- 700P
createItem('jewelry_ring_gold', 'Золотое кольцо', octolib.icons.color('ring_gold'), 0.1, 0.1) -- 1100P
createItem('jewelry_ring_silver', 'Серебряное кольцо', octolib.icons.color('ring_silver'), 0.1, 0.1) -- 700P
createItem('jewelry_pearl', 'Жемчужина', octolib.icons.color('bubble'), 0.05, 0.05)
createItem('jewelry_diamond', 'Алмаз', octolib.icons.color('diamond'), 0.05, 0.05)
createItem('jewelry_ruby', 'Рубин', octolib.icons.color('ruby'), 0.05, 0.05)
createItem('jewelry_topaz', 'Топаз', octolib.icons.color('topaz'), 0.05, 0.05)
createItem('jewelry_emerald', 'Изумруд', octolib.icons.color('emerald'), 0.05, 0.05)
createItem('jewelry_sapphire', 'Сапфир', octolib.icons.color('sapphire'), 0.05, 0.05)

octoinv.addShopCat('jewelry', { name = 'Драгоценности', icon = octolib.icons.color('diamond') })
octoinv.addShopItem('jewelry_pearl', { cat = 'jewelry', price = 4500 })
octoinv.addShopItem('jewelry_diamond', { cat = 'jewelry', price = 15000 })
octoinv.addShopItem('jewelry_ruby', { cat = 'jewelry', price = 11000 })
octoinv.addShopItem('jewelry_sapphire', { cat = 'jewelry', price = 13500 })
octoinv.addShopItem('jewelry_topaz', { cat = 'jewelry', price = 12000 })
octoinv.addShopItem('jewelry_emerald', { cat = 'jewelry', price = 14500 })

octoinv.registerMarketCatFromShop('jewelry')
octoinv.registerMarketItem('jewelry_chain_gold', { parent = 'cat_jewelry' })
octoinv.registerMarketItem('jewelry_chain_silver', { parent = 'cat_jewelry' })
octoinv.registerMarketItem('jewelry_ring_gold', { parent = 'cat_jewelry' })
octoinv.registerMarketItem('jewelry_ring_silver', { parent = 'cat_jewelry' })

--
-- WORKBENCH
--

local benchSounds = {
	'physics/metal/metal_box_strain1.wav',
	'physics/metal/metal_box_strain2.wav',
	'physics/metal/metal_box_strain3.wav',
	'physics/metal/metal_box_strain4.wav',
	'physics/metal/metal_canister_impact_soft1.wav',
	'physics/metal/metal_canister_impact_soft2.wav',
	'physics/metal/metal_canister_impact_soft3.wav',
}

octoinv.registerCraft('jewelry_ring', {
	name = 'Золотое кольцо с гравировкой',
	icon = octolib.icons.color('one_ring'),
	conts = {'workbench'},
	sound = benchSounds,
	time = 15,
	tools = {
		{'tool_caliper', 1},
		{'tool_hammer', 1},
	},
	ings = {
		{'jewelry_ring_gold', 2},
		{'craft_nail', 1},
	},
	finish = {
		{'souvenir', {
			name = 'Золотое кольцо с гравировкой',
			icon = octolib.icons.color('one_ring'),
			mass = 0.15,
			volume = 0.1,
		}},
	}
})

octoinv.registerCraft('jewelry_ring_diamond', {
	name = 'Золотое кольцо с алмазом',
	icon = octolib.icons.color('diamond_ring'),
	conts = {'workbench'},
	sound = benchSounds,
	time = 15,
	tools = {
		{'tool_caliper', 1},
	},
	ings = {
		{'jewelry_ring_gold', 1},
		{'jewelry_diamond', 1},
	},
	finish = {
		{'souvenir', {
			name = 'Золотое кольцо с алмазом',
			icon = octolib.icons.color('diamond_ring'),
			mass = 0.15,
			volume = 0.1,
		}},
	}
})

octoinv.registerCraft('jewelry_ring_ruby', {
	name = 'Золотое кольцо с рубином',
	icon = octolib.icons.color('ring_ruby'),
	conts = {'workbench'},
	sound = benchSounds,
	time = 15,
	tools = {
		{'tool_caliper', 1},
	},
	ings = {
		{'jewelry_ring_gold', 1},
		{'jewelry_ruby', 1},
	},
	finish = {
		{'souvenir', {
			name = 'Золотое кольцо с рубином',
			icon = octolib.icons.color('ring_ruby'),
			mass = 0.15,
			volume = 0.1,
		}},
	}
})

octoinv.registerCraft('jewelry_ring_sapphire', {
	name = 'Золотое кольцо с сапфиром',
	icon = octolib.icons.color('ring_sapphire'),
	conts = {'workbench'},
	sound = benchSounds,
	time = 15,
	tools = {
		{'tool_caliper', 1},
	},
	ings = {
		{'jewelry_ring_gold', 1},
		{'jewelry_sapphire', 1},
	},
	finish = {
		{'souvenir', {
			name = 'Золотое кольцо с сапфиром',
			icon = octolib.icons.color('ring_sapphire'),
			mass = 0.15,
			volume = 0.1,
		}},
	}
})

octoinv.registerCraft('jewelry_ring_sapphire_silver', {
	name = 'Серебряное кольцо с сапфиром',
	icon = octolib.icons.color('ring_sapphire'),
	conts = {'workbench'},
	sound = benchSounds,
	time = 15,
	tools = {
		{'tool_caliper', 1},
	},
	ings = {
		{'jewelry_ring_silver', 1},
		{'jewelry_sapphire', 1},
	},
	finish = {
		{'souvenir', {
			name = 'Серебряное кольцо с сапфиром',
			icon = octolib.icons.color('ring_sapphire'),
			mass = 0.15,
			volume = 0.1,
		}},
	}
})

octoinv.registerCraft('jewelry_bracelet', {
	name = 'Золотой браслет с рубинами',
	icon = octolib.icons.color('bracelet'),
	conts = {'workbench'},
	sound = benchSounds,
	time = 15,
	tools = {
		{'tool_caliper', 1},
	},
	ings = {
		{'jewelry_chain_gold', 2},
		{'jewelry_ruby', 4},
	},
	finish = {
		{'souvenir', {
			name = 'Золотой браслет с рубинами',
			icon = octolib.icons.color('bracelet'),
			mass = 0.2,
			volume = 0.15,
		}},
	}
})

octoinv.registerCraft('jewelry_necklace', {
	name = 'Золотое ожерелье с рубинами',
	icon = octolib.icons.color('necklace'),
	conts = {'workbench'},
	sound = benchSounds,
	time = 20,
	tools = {
		{'tool_caliper', 1},
	},
	ings = {
		{'jewelry_chain_gold', 2},
		{'jewelry_ring_gold', 3},
		{'jewelry_ruby', 3},
	},
	finish = {
		{'souvenir', {
			name = 'Золотое ожерелье с рубинами',
			icon = octolib.icons.color('necklace'),
			mass = 0.4,
			volume = 0.3,
		}},
	}
})

octoinv.registerCraft('jewelry_earrings', {
	name = 'Серьги с алмазом и жемчужиной',
	icon = octolib.icons.color('earrings'),
	conts = {'workbench'},
	sound = benchSounds,
	time = 20,
	tools = {
		{'tool_caliper', 1},
	},
	ings = {
		{'jewelry_ring_silver', 2},
		{'jewelry_pearl', 2},
		{'jewelry_diamond', 2},
	},
	finish = {
		{'souvenir', {
			name = 'Серьги с алмазом и жемчужиной',
			icon = octolib.icons.color('earrings'),
			mass = 0.4,
			volume = 0.3,
		}},
	}
})

--
-- MACHINE
--
createItem('jewelry_bp_chain', 'Цепь', octolib.icons.color('microsd'), 0.02, 0.02)
createItem('jewelry_bp_ring', 'Кольцо', octolib.icons.color('microsd'), 0.02, 0.02)
octoinv.addShopItem('jewelry_bp_chain', { cat = 'machinebp', price = 15 })
octoinv.addShopItem('jewelry_bp_ring', { cat = 'machinebp', price = 15 })

octoinv.registerProcess('machine', {
	time = 15,
	ins = {machine = {{'ingot_gold', 1}}, machine_tray = {{'jewelry_bp_chain', 1}}},
	out = {machine = {{'jewelry_chain_gold', 5}}},
}, 'jewelry_chain_gold')

octoinv.registerProcess('machine', {
	time = 15,
	ins = {machine = {{'ingot_silver', 1}}, machine_tray = {{'jewelry_bp_chain', 1}}},
	out = {machine = {{'jewelry_chain_silver', 5}}},
}, 'jewelry_chain_silver')

octoinv.registerProcess('machine', {
	time = 15,
	ins = {machine = {{'ingot_gold', 1}}, machine_tray = {{'jewelry_bp_ring', 1}}},
	out = {machine = {{'jewelry_ring_gold', 5}}},
}, 'jewelry_ring_gold')

octoinv.registerProcess('machine', {
	time = 15,
	ins = {machine = {{'ingot_silver', 1}}, machine_tray = {{'jewelry_bp_ring', 1}}},
	out = {machine = {{'jewelry_ring_silver', 5}}},
}, 'jewelry_ring_silver')
