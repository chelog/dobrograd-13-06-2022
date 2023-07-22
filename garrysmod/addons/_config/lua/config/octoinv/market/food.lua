-- octoinv.registerMarketItem('food', {
-- 	name = 'Еда',
-- 	nostack = true,
-- 	matches = function(item)
-- 		return item.class == 'food' and item.trash
-- 	end,
-- })

octoinv.registerMarketItem('cat_ings', {
	name = L.ings,
	icon = 'octoteam/icons/food_ingredients.png',
})

octoinv.registerMarketItem('ing_fish1', { parent = 'cat_ings' })
octoinv.registerMarketItem('ing_fish2', { parent = 'cat_ings' })
octoinv.registerMarketItem('ing_fish3', { parent = 'cat_ings' })
octoinv.registerMarketItem('ing_fish4', { parent = 'cat_ings' })
