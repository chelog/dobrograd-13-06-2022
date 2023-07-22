local ckie = {'food', {
	name = L.cookie,
	energy = 10,
	icon = 'octoteam/icons/food_cookies.png',
	mass = 0.15,
	volume = 0.15,
}}

octoinv.registerProd('stove', {
	name = L.stove,
	icon = 'octoteam/icons/stove.png',
	mass = 650,
	destruct = {
		{'bpd_stove', 1},
	},
	sounds = {
		loop = 'octoinv.prod15',
		work = 'octoinv.prod10',
	},
})

--
-- INGREDIENTS
--

-- Котлета
octoinv.registerProcess('stove', {
	time = 15,
	ins = {stove = {
		{'tool_pan', 1},
		{'ing_oil', 1},
		{'ing_salt', 1},
		{'ing_meat', 1},
	}},
	out = {stove = {{'tool_pan', 1}, {'ing_meatball', 1}}},
})

-- Бульон
octoinv.registerProcess('stove', {
	time = 30,
	ins = {stove = {
		{'tool_pot', 1},
		{'ing_water', 1},
		{'ing_salt', 1},
		{'ing_spice', 1},
	}},
	out = {stove = {{'tool_pot', 1}, {'ing_soup', 1}}},
})

-- Жареное мясо
octoinv.registerProcess('stove', {
	time = 25,
	ins = {stove = {
		{'tool_pan', 1},
		{'ing_oil', 1},
		{'ing_spice', 1},
		{'ing_meat', 1},
		{'ing_flour', 1},
	}},
	out = {stove = {{'tool_pan', 1}, {'ing_roastmeat', 1}}},
})

-- Вареный картофель
octoinv.registerProcess('stove', {
	time = 20,
	ins = {stove = {
		{'tool_pot', 1},
		{'ing_water', 1},
		{'ing_potato', 2},
	}},
	out = {stove = {{'tool_pot', 1}, {'ing_potato2', 2}}},
})

-- Основа для пиццы
octoinv.registerProcess('stove', {
	time = 20,
	ins = {oven = {
		{'tool_oventray', 1},
		{'ing_flour', 1},
		{'ing_egg', 2},
		{'ing_salt', 1},
	}},
	out = {oven = {{'tool_oventray', 1}, {'ing_pizza_base', 1}}},
})

-- Бисквит
octoinv.registerProcess('stove', {
	time = 20,
	ins = {oven = {
		{'tool_oventray', 1},
		{'ing_flour', 2},
		{'ing_sugar', 1},
		{'ing_oil', 1},
		{'ing_milk', 1},
		{'ing_egg', 2},
	}},
	out = {oven = {{'tool_oventray', 1}, {'ing_dough3', 1}}},
})

--
-- DISHES
--

-- Яичница
octoinv.registerProcess('stove', {
	time = 20,
	ins = {stove = {
		{'tool_pan', 1},
		{'tool_foodcont', 1},
		{'ing_egg', 2},
		{'ing_oil', 1},
		{'ing_salt', 1},
	}},
	out = {stove = {{'tool_pan', 1}, {'food', {
		name = L.omelet,
		desc = L.desc_omelet,
		icon = 'octoteam/icons/food_omlet.png',
		energy = 20
	}}}},
})

-- Пицца Пепперони
octoinv.registerProcess('stove', {
	time = 55,
	ins = {oven = {
		{'tool_oventray', 1},
		{'tool_foodcont', 1},
		{'ing_cheese', 1},
		{'ing_flour', 1},
		{'ing_salt', 2},
		{'ing_sausage2', 2},
		{'ing_pizza_base', 1},
		{'ing_oil', 1},
	}},
	out = {oven = {{'tool_oventray', 1}, {'food', {
		name = L.pizza_pepperoni,
		desc = L.desc_pizza_pepperoni,
		energy = 85,
		icon = 'octoteam/icons/food_pizza_pepperoni.png'
	}}}},
})

-- Пицца Маргарита
octoinv.registerProcess('stove', {
	time = 55,
	ins = {oven = {
		{'tool_oventray', 1},
		{'tool_foodcont', 1},
		{'ing_cheese', 1},
		{'ing_flour', 1},
		{'ing_salt', 2},
		{'ing_tomato', 3},
		{'ing_pizza_base', 1},
		{'ing_oil', 1},
	}},
	out = {oven = {{'tool_oventray', 1}, {'food', {
		name = L.pizza_margarita,
		desc = L.desc_pizza_margarita,
		energy = 85,
		icon = 'octoteam/icons/food_pizza_margherita.png'
	}}}},
})

-- Пицца Вулкано
octoinv.registerProcess('stove', {
	time = 55,
	ins = {oven = {
		{'tool_oventray', 1},
		{'tool_foodcont', 1},
		{'ing_cheese', 3},
		{'ing_flour', 1},
		{'ing_salt', 2},
		{'ing_tomato', 3},
		{'ing_pizza_base', 1},
		{'ing_chili', 2},
	}},
	out = {oven = {{'tool_oventray', 1}, {'food', {
		name = L.pizza_volcano,
		desc = L.desc_pizza_volcano,
		energy = 100,
		icon = 'octoteam/icons/food_pizza_volcano.png'
	}}}},
})

-- Пирожок с мясом
octoinv.registerProcess('stove', {
	time = 25,
	ins = {oven = {
		{'tool_oventray', 1},
		{'ing_dough1', 1},
		{'ing_roastmeat', 1},
	}},
	out = {oven = {{'tool_oventray', 1}, {'food', {
		name = L.meat_pie,
		icon = 'octoteam/icons/food_meat_pie.png',
		desc = L.desc_meat_pie,
		energy = 25
	}}}},
})

-- Хотдог
octoinv.registerProcess('stove', {
	time = 25,
	ins = {oven = {
		{'tool_oventray', 1},
		{'ing_dough1', 1},
		{'ing_sausage', 1},
	}},
	out = {oven = {{'tool_oventray', 1}, {'food', {
		name = L.hotdog,
		icon = 'octoteam/icons/food_hotdog.png',
		desc = L.desc_hotdog,
		energy = 25
	}}}},
})

-- Яблочный пирог
octoinv.registerProcess('stove', {
	time = 45,
	ins = {oven = {
		{'tool_oventray', 1},
		{'tool_foodcont', 1},
		{'ing_dough1', 2},
		{'ing_sugar', 3},
		{'ing_apple', 2},
	}},
	out = {oven = {{'tool_oventray', 1}, {'food', {
		name = L.apple_pie,
		desc = L.desc_apple_pie,
		energy = 60,
		icon = 'octoteam/icons/food_pie.png'
	}}}},
},{
	time = 120,
	ins = {oven = {
		{'tool_oventray', 1},
		{'ing_dough3', 2},
		{'ing_cocoa', 2},
	}},
	out = {oven = {{'tool_oventray', 1}, ckie, ckie, ckie}},
})

-- Блинчики
octoinv.registerProcess('stove', {
	time = 30,
	ins = {stove = {
		{'tool_pan', 1},
		{'ing_oil', 1},
		{'ing_milk', 2},
		{'ing_egg', 2},
		{'ing_flour', 2},
	}},
	out = {stove = {{'tool_pan', 1}, {'food', {
		name = L.cupcakes,
		energy = 40,
		icon = 'octoteam/icons/food_pancake.png'
	}}}},
})

-- Грибной суп
octoinv.registerProcess('stove', {
	time = 45,
	ins = {stove = {
		{'tool_pot', 1},
		{'tool_foodcont', 1},
		{'ing_soup', 1},
		{'ing_potato', 3},
		{'ing_mushroom', 5},
		{'ing_lettuce', 2},
	}},
	out = {stove = {{'tool_pot', 1}, {'food', {
		name = L.mushroom_soup,
		energy = 50,
		icon = 'octoteam/icons/food_mushroom_soup.png'
	}}}},
})

-- Борщ
octoinv.registerProcess('stove', {
	time = 80,
	ins = {stove = {
		{'tool_pot', 1},
		{'tool_foodcont', 1},
		{'ing_soup', 1},
		{'ing_potato', 4},
		{'ing_beet', 3},
		{'ing_tomato', 3},
		{'ing_cabbage', 1},
		{'ing_meat', 2},
		{'ing_salt', 1},
	}},
	out = {stove = {{'tool_pot', 1}, {'food', {
		name = L.borsch,
		energy = 80,
		icon = 'octoteam/icons/food_borsh.png'
	}}}},
})

-- Овощное рагу
octoinv.registerProcess('stove', {
	time = 55,
	ins = {stove = {
		{'tool_pan', 1},
		{'tool_foodcont', 1},
		{'ing_eggplant', 1},
		{'ing_potato', 2},
		{'ing_mushroom', 1},
		{'ing_cheese', 1},
		{'ing_onion', 1},
		{'ing_celery', 1},
		{'ing_oil', 1},
		{'ing_salt', 1},
	}},
	out = {stove = {{'tool_pan', 1}, {'food', {
		name = L.vegetable_stew,
		energy = 55,
		icon = 'octoteam/icons/food_rice.png'
	}}}},
})

-- Зитти
octoinv.registerProcess('stove', {
	time = 60,
	ins = {oven = {
		{'tool_oventray', 1},
		{'tool_foodcont', 1},
		{'ing_onion', 1},
		{'ing_cheese', 2},
		{'ing_tomato', 4},
		{'ing_meat', 2},
		{'ing_pasta', 1},
		{'ing_salt', 1},
		{'ing_spice', 1},
	}},
	out = {oven = {{'tool_oventray', 1}, {'food', {
		name = L.zitti,
		energy = 60,
		icon = 'octoteam/icons/food_porrige.png'
	}}}},
})

-- Болоньезе
octoinv.registerProcess('stove', {
	time = 50,
	ins = {stove = {
		{'tool_pan', 1},
		{'tool_foodcont', 1},
		{'ing_water', 1},
		{'ing_cheese', 2},
		{'ing_tomato', 3},
		{'ing_oil', 1},
		{'ing_meat', 1},
		{'ing_pasta', 1},
		{'ing_spice', 1},
	}},
	out = {stove = {{'tool_pan', 1}, {'food', {
		name = L.bolognese,
		energy = 50,
		icon = 'octoteam/icons/food_spaghetti.png'
	}}}},
})

-- Лазанья
octoinv.registerProcess('stove', {
	time = 100,
	ins = {oven = {
		{'tool_oventray', 1},
		{'tool_foodcont', 1},
		{'ing_olive', 3},
		{'ing_flour', 2},
		{'ing_milk', 1},
		{'ing_cheese', 4},
		{'ing_meat', 2},
		{'ing_oil', 2},
		{'ing_salt', 1},
		{'ing_spice', 1},
	}},
	out = {oven = {{'tool_oventray', 1}, {'food', {
		name = L.lasagna,
		energy = 100,
		icon = 'octoteam/icons/food_lazania.png'
	}}}},
})

-- Чай
octoinv.registerProcess('stove', {
	time = 15,
	ins = {stove = {
		{'tool_teapot', 1},
		{'tool_foodcont', 1},
		{'ing_tea', 2},
		{'ing_water', 1},
	}},
	out = {stove = {{'tool_teapot', 1}, {'food', {
		name = L.tea,
		energy = 15,
		maxenergy = 50,
		model = 'models/props_junk/garbage_coffeemug001a.mdl',
		icon = 'octoteam/icons/cup2.png',
		drink = true,
	}}}},
})

-- Какао
octoinv.registerProcess('stove', {
	time = 30,
	ins = {stove = {
		{'tool_coffeepot', 1},
		{'tool_foodcont', 1},
		{'ing_cocoa', 2},
		{'ing_milk', 1},
		{'ing_sugar', 3},
	}},
	out = {stove = {{'tool_coffeepot', 1}, {'food', {
		name = L.cacao,
		energy = 20,
		maxenergy = 60,
		model = 'models/props_junk/garbage_coffeemug001a.mdl',
		icon = 'octoteam/icons/cup.png',
		drink = true,
	}}}},
})

-- Капучино
octoinv.registerProcess('stove', {
	time = 20,
	ins = {stove = {
		{'tool_coffeepot', 1},
		{'tool_foodcont', 1},
		{'ing_coffee', 2},
		{'ing_milk', 1},
	}},
	out = {stove = {{'tool_coffeepot', 1}, {'food', {
		name = L.cappuccino,
		energy = 15,
		maxenergy = 60,
		mass = 0.5,
		volume = 0.5,
		model = 'models/props_junk/garbage_coffeemug001a.mdl',
		icon = 'octoteam/icons/coffee.png',
		drink = true,
	}}}},
})

-- Эспрессо
octoinv.registerProcess('stove', {
	time = 20,
	ins = {stove = {
		{'tool_coffeepot', 1},
		{'tool_foodcont', 1},
		{'ing_coffee', 3},
	}},
	out = {stove = {{'tool_coffeepot', 1}, {'food', {
		name = L.espresso,
		energy = 10,
		maxenergy = 60,
		mass = 0.35,
		volume = 0.35,
		model = 'models/props_junk/garbage_coffeemug001a.mdl',
		icon = 'octoteam/icons/coffee.png',
		drink = true,
	}}}},
})

-- Запеченный окунь
octoinv.registerProcess('stove', {
	time = 30,
	ins = {oven = {
		{'tool_oventray', 1},
		{'ing_fish1', 1},
		{'ing_oil', 1},
		{'ing_spice', 1},
		{'ing_salt', 1},
		{'ing_onion', 1},
		{'ing_tomato', 2},
		{'tool_foodcont', 1},
	}},
	out = {oven = {{'tool_oventray', 1}, {'food', {
		name = 'Запеченный окунь',
		icon = 'octoteam/icons/food_fish_cooked.png',
		energy = 60,
	}}}},
})

-- Запеченный карп
octoinv.registerProcess('stove', {
	time = 30,
	ins = {oven = {
		{'tool_oventray', 1},
		{'ing_fish2', 1},
		{'ing_oil', 1},
		{'ing_spice', 1},
		{'ing_salt', 1},
		{'ing_onion', 1},
		{'ing_lemon', 1},
		{'ing_carrot', 1},
		{'ing_tomato', 1},
		{'tool_foodcont', 1},
	}},
	out = {oven = {{'tool_oventray', 1}, {'food', {
		name = 'Запеченный карп',
		icon = 'octoteam/icons/food_fish_cooked.png',
		energy = 70,
	}}}},
})

-- Форель под медом
octoinv.registerProcess('stove', {
	time = 30,
	ins = {oven = {
		{'tool_oventray', 1},
		{'ing_fish3', 1},
		{'ing_spice', 1},
		{'ing_salt', 1},
		{'ing_onion', 1},
		{'ing_lemon', 2},
		{'ing_honey', 1},
		{'tool_foodcont', 1},
	}},
	out = {oven = {{'tool_oventray', 1},
		unpack(octolib.array.series({'food', {
			name = 'Форель под медом',
			icon = 'octoteam/icons/food_fish_cooked_honey.png',
			energy = 50,
		}}, 2))
	}},
})

-- Щука в сливочном соусе
octoinv.registerProcess('stove', {
	time = 45,
	ins = {oven = {
		{'tool_oventray', 1},
		{'ing_fish4', 1},
		{'ing_spice', 1},
		{'ing_salt', 1},
		{'ing_onion', 1},
		{'ing_cream', 1},
		{'ing_sauce', 1},
		{'ing_oil', 1},
		{'tool_foodcont', 1},
	}},
	out = {oven = {{'tool_oventray', 1},
		unpack(octolib.array.series({'food', {
			name = 'Щука в сливочном соусе',
			icon = 'octoteam/icons/food_fish_cooked_cream.png',
			energy = 60,
		}}, 2))
	}},
})
