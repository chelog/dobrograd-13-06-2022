octoinv.registerMarketItem('cat_collector', {
	name = 'Добыча ресурсов',
	icon = octolib.icons.color('crowbar'),
	nostack = true,
})

octoinv.registerMarketItem('collector_pickaxe', {
	name = 'Кирка',
	parent = 'cat_collector',
	nostack = true,
	matches = function(item)
		return item.class == 'collector' and item.collector == 'pickaxe' and item.health and item.health > 0
	end,
	retain = {
		sell = {
			amount = 5,
			price = 14500,
			getOrderInfo = function()
				local health = math.random(15, 500)
				local price = 2000 + health * 25 + math.random(-100, 100) * 10
				return price, {
					class = 'collector',
					name = 'Кирка',
					icon = octolib.icons.color('crowbar'),
					collector = 'pickaxe',
					maxhealth = 500,
					health = health,
				}
			end,
		},
	},
})
