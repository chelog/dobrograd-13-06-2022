--
-- CATEGORIES
--

octoinv.addShopCat('food', {
	name = L.food,
	icon = 'octoteam/icons/food_meal2.png',
})

octoinv.addShopCat('dish', {
	name = L.dish,
	icon = 'octoteam/icons/coin_stacks.png',
	jobs = {'cook'},
})
octoinv.addShopCat('ings', {
	name = L.ings,
	icon = 'octoteam/icons/food_ingredients.png',
	jobs = {'cook'},
})

--
-- ITEMS
--

-- tools
octoinv.addShopItem('tool_foodcont', { cat = 'dish', price = 20 })
octoinv.addShopItem('tool_pan', { cat = 'dish', price = 1000 })
octoinv.addShopItem('tool_pot', { cat = 'dish', price = 1500 })
octoinv.addShopItem('tool_oventray', { cat = 'dish', price = 1800 })
octoinv.addShopItem('tool_scoop', { cat = 'dish', price = 750 })
octoinv.addShopItem('tool_pastrybag', { cat = 'dish', price = 450 })
octoinv.addShopItem('tool_shaker', { cat = 'dish', price = 1500 })
octoinv.addShopItem('tool_teapot', { cat = 'dish', price = 800 })
octoinv.addShopItem('tool_coffeepot', { cat = 'dish', price = 850 })

-- ingredients
octoinv.addShopItem('ing_egg', { cat = 'ings', price = 20 })
octoinv.addShopItem('ing_oil', { cat = 'ings', price = 10 })
octoinv.addShopItem('ing_salt', { cat = 'ings', price = 10 })
octoinv.addShopItem('ing_potato', { cat = 'ings', price = 15 })
octoinv.addShopItem('ing_cheese', { cat = 'ings', price = 35 })
octoinv.addShopItem('ing_flour', { cat = 'ings', price = 15 })
octoinv.addShopItem('ing_onion', { cat = 'ings', price = 10 })
octoinv.addShopItem('ing_milk', { cat = 'ings', price = 50 })
octoinv.addShopItem('ing_cream', { cat = 'ings', price = 80 })
octoinv.addShopItem('ing_meat', { cat = 'ings', price = 100 })
octoinv.addShopItem('ing_carrot', { cat = 'ings', price = 10 })
octoinv.addShopItem('ing_tomato', { cat = 'ings', price = 12 })
octoinv.addShopItem('ing_sugar', { cat = 'ings', price = 5 })
octoinv.addShopItem('ing_mushroom', { cat = 'ings', price = 15 })
octoinv.addShopItem('ing_sausage', { cat = 'ings', price = 80 })
octoinv.addShopItem('ing_sausage2', { cat = 'ings', price = 55 })
octoinv.addShopItem('ing_bread', { cat = 'ings', price = 25 })
octoinv.addShopItem('ing_honey', { cat = 'ings', price = 100 })
octoinv.addShopItem('ing_spice', { cat = 'ings', price = 10 })
octoinv.addShopItem('ing_kvas', { cat = 'ings', price = 80 })
octoinv.addShopItem('ing_cucumber', { cat = 'ings', price = 15 })
octoinv.addShopItem('ing_nut', { cat = 'ings', price = 100 })
octoinv.addShopItem('ing_apple', { cat = 'ings', price = 20 })
octoinv.addShopItem('ing_corn', { cat = 'ings', price = 35 })
octoinv.addShopItem('ing_celery', { cat = 'ings', price = 25 })
octoinv.addShopItem('ing_bacon', { cat = 'ings', price = 70 })
octoinv.addShopItem('ing_olive', { cat = 'ings', price = 55 })
octoinv.addShopItem('ing_chili', { cat = 'ings', price = 50 })
octoinv.addShopItem('ing_broccoli', { cat = 'ings', price = 45 })
octoinv.addShopItem('ing_pineapple', { cat = 'ings', price = 120 })
octoinv.addShopItem('ing_pumpkin', { cat = 'ings', price = 75 })
--octoinv.addShopItem('ing_fish', { cat = 'ings', price = 130 })
octoinv.addShopItem('ing_strawberry', { cat = 'ings', price = 80 })
octoinv.addShopItem('ing_watermelon', { cat = 'ings', price = 60 })
octoinv.addShopItem('ing_melon', { cat = 'ings', price = 70 })
octoinv.addShopItem('ing_soy', { cat = 'ings', price = 25 })
octoinv.addShopItem('ing_peas', { cat = 'ings', price = 30 })
octoinv.addShopItem('ing_lettuce', { cat = 'ings', price = 50 })
octoinv.addShopItem('ing_cabbage', { cat = 'ings', price = 20 })
octoinv.addShopItem('ing_beet', { cat = 'ings', price = 15 })
octoinv.addShopItem('ing_redish', { cat = 'ings', price = 15 })
octoinv.addShopItem('ing_eggplant', { cat = 'ings', price = 45 })
octoinv.addShopItem('ing_prawn', { cat = 'ings', price = 150 })
octoinv.addShopItem('ing_avocado', { cat = 'ings', price = 60 })
octoinv.addShopItem('ing_pita', { cat = 'ings', price = 40 })
octoinv.addShopItem('ing_cocoa', { cat = 'ings', price = 30 })
octoinv.addShopItem('ing_choco', { cat = 'ings', price = 40 })
octoinv.addShopItem('ing_banana', { cat = 'ings', price = 40 })
octoinv.addShopItem('ing_orange', { cat = 'ings', price = 35 })
octoinv.addShopItem('ing_lemon', { cat = 'ings', price = 30 })
octoinv.addShopItem('ing_rice', { cat = 'ings', price = 35 })
octoinv.addShopItem('ing_sauce', { cat = 'ings', price = 40 })
octoinv.addShopItem('ing_pasta', { cat = 'ings', price = 75 })
octoinv.addShopItem('ing_coffee', { cat = 'ings', price = 50 })
octoinv.addShopItem('ing_tea', { cat = 'ings', price = 45 })

-- crafted ingredients
octoinv.addShopItem('ing_pizza_base', { cat = 'ings', price = 200 })
octoinv.addShopItem('ing_dough1', { cat = 'ings', price = 230 })
octoinv.addShopItem('ing_dough2', { cat = 'ings', price = 120 })
octoinv.addShopItem('ing_icecream', { cat = 'ings', price = 340 })
octoinv.addShopItem('ing_meatball', { cat = 'ings', price = 230 })
octoinv.addShopItem('ing_roastmeat', { cat = 'ings', price = 240 })
octoinv.addShopItem('ing_potato2', { cat = 'ings', price = 120 })
octoinv.addShopItem('ing_potatomash', { cat = 'ings', price = 400 })
octoinv.addShopItem('ing_soup', { cat = 'ings', price = 135 })
octoinv.addShopItem('ing_dough3', { cat = 'ings', price = 280 })

-- ready to eat
octoinv.addShopItem('food_chocolate', {
	cat = 'food', price = 150,
	name = L.chocolate,
	icon = 'octoteam/icons/food_choco.png',
	item = 'food',
	data = {
		name = L.chocolate,
		icon = 'octoteam/icons/food_choco.png',
		energy = 15,
		maxenergy = 50,
		trash = true,
	},
})

octoinv.addShopItem('food_chips', {
	cat = 'food', price = 220,
	name = L.chips,
	icon = 'octoteam/icons/food_chips.png',
	item = 'food',
	data = {
		name = L.chips,
		icon = 'octoteam/icons/food_chips.png',
		energy = 20,
		maxenergy = 50,
		trash = true,
	},
})

octoinv.addShopItem('food_soda', {
	cat = 'food', price = 120,
	name = L.food_soda,
	icon = 'octoteam/icons/food_soda.png',
	item = 'food',
	data = {
		name = L.food_soda,
		icon = 'octoteam/icons/food_soda.png',
		energy = 15,
		maxenergy = 30,
		drink = true,
		trash = true,
	},
})

octoinv.addShopItem('food_cream', {
	cat = 'food', price = 180,
	name = L.cream,
	icon = 'octoteam/icons/food_yogurt.png',
	item = 'food',
	data = {
		name = L.cream,
		icon = 'octoteam/icons/food_yogurt.png',
		energy = 18,
		maxenergy = 50,
		trash = true,
	},
})

octoinv.addShopItem('food_crackers', {
	cat = 'food', price = 135,
	name = L.crackers,
	icon = 'octoteam/icons/food_brezel.png',
	item = 'food',
	data = {
		name = L.crackers,
		icon = 'octoteam/icons/food_brezel.png',
		energy = 15,
		maxenergy = 40,
		trash = true,
	},
})

octoinv.addShopItem('food_burger', {
	cat = 'food', price = 650,
	jobs = {'cook'},
	name = L.burger,
	item = 'food',
	data = {
		name = L.burger,
		energy = 35,
	},
})

octoinv.addShopItem('food_meatcake', {
	cat = 'food', price = 450,
	jobs = {'cook'},
	name = L.meatcake,
	item = 'food',
	data = {
		name = L.meatcake,
		energy = 25,
	},
})

octoinv.addShopItem('food_applepie', {
	cat = 'food', price = 900,
	jobs = {'cook'},
	name = L.applepie,
	item = 'food',
	data = {
		name = L.applepie,
		energy = 60,
	},
})

octoinv.addShopItem('food_pancake', {
	cat = 'food', price = 600,
	jobs = {'cook'},
	name = L.pancake,
	item = 'food',
	data = {
		name = L.pancake,
		energy = 40,
	},
})

octoinv.addShopItem('food_sandwitch', {
	cat = 'food', price = 250,
	jobs = {'cook'},
	name = L.sandwitch,
	item = 'food',
	data = {
		name = L.sandwitch,
		energy = 15,
	},
})

octoinv.addShopItem('food_wrap', {
	cat = 'food', price = 850,
	jobs = {'cook'},
	name = L.wrap,
	item = 'food',
	data = {
		name = L.wrap,
		energy = 60,
	},
})
