octoinv.registerMarketItem('cat_legacy', {
	name = 'Пеработка',
	icon = 'octoteam/icons/reset.png',
})

octoinv.registerMarketItem('craft_paper2', {
	parent = 'cat_legacy',
	retain = {
		buy = {
			price = 70,
			amount = 500,
			getOrderInfo = function() return math.random(60, 85), math.random(5, 50) end,
		},
	},
})

octoinv.registerMarketItem('craft_ink', {
	parent = 'cat_legacy',
	retain = {
		buy = {
			price = 550,
			amount = 80,
			getOrderInfo = function() return math.random(100, 130) * 5, math.random(5, 50) end,
		},
	},
})

octoinv.registerMarketItem('bpd_vend', {
	parent = 'cat_legacy',
	retain = {
		buy = {
			price = 4600,
			amount = 8,
			getOrderInfo = function() return math.random(450, 500) * 10, math.random(1, 2) end,
		},
	},
})

