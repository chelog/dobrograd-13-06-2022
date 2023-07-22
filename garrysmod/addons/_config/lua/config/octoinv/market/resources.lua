octoinv.registerMarketItem('cat_resources', {
	name = L.resources,
	icon = 'octoteam/icons/ore_iron.png',
})

octoinv.registerMarketItem('ingot_iron', { parent = 'cat_resources' })
octoinv.registerMarketItem('ingot_steel', { parent = 'cat_resources' })
octoinv.registerMarketItem('ingot_silver', { parent = 'cat_resources' })
octoinv.registerMarketItem('ingot_bronze', { parent = 'cat_resources' })
octoinv.registerMarketItem('ingot_gold', { parent = 'cat_resources' })
octoinv.registerMarketItem('ingot_copper', { parent = 'cat_resources' })

octoinv.registerMarketItem('ore_silver', { parent = 'cat_resources' })
octoinv.registerMarketItem('ore_bronze', { parent = 'cat_resources' })
octoinv.registerMarketItem('ore_gold', { parent = 'cat_resources' })
octoinv.registerMarketItem('ore_copper', { parent = 'cat_resources' })
octoinv.registerMarketItem('stone', { parent = 'cat_resources' })
octoinv.registerMarketItem('gunpowder', { parent = 'cat_resources' })
octoinv.registerMarketItem('craft_glass', { parent = 'cat_resources' })

octoinv.registerMarketItem('ore_iron', {
	parent = 'cat_resources',
	retain = {
		sell = {
			price = 1950,
			amount = 20,
			getOrderInfo = function() return math.random(150, 225) * 10, math.random(1, 12) end,
		},
	},
})
octoinv.registerMarketItem('ore_steel', {
	parent = 'cat_resources',
	retain = {
		sell = {
			price = 3950,
			amount = 8,
			getOrderInfo = function() return math.random(250, 400) * 10, math.random(1, 3) end,
		},
	},
})

octoinv.registerMarketItem('craft_coal', {
	parent = 'cat_resources',
	retain = {
		sell = {
			price = 500,
			amount = 20,
			getOrderInfo = function() return math.random(98, 110) * 5, math.random(1, 8) end,
		},
	},
})

octoinv.registerMarketItem('sulfur', {
	parent = 'cat_resources',
	retain = {
		sell = {
			price = 3500,
			amount = 10,
			getOrderInfo = function() return math.random(330, 360) * 10, math.random(1, 3) end,
		},
	},
})

octoinv.registerMarketItem('rubble', {
	parent = 'cat_resources',
	retain = {
		buy = {
			price = 45,
			amount = 35,
			getOrderInfo = function() return math.random(9, 12) * 5, math.random(1, 8) end,
		},
	},
})

octoinv.registerMarketItem('sand', {
	parent = 'cat_resources',
	retain = {
		buy = {
			price = 35,
			amount = 35,
			getOrderInfo = function() return math.random(8, 11) * 5, math.random(1, 8) end,
		},
	},
})
