------------------------------------------------
--
-- TOOLS
--
------------------------------------------------

octoinv.registerItem('tool_foodcont', {
	name = L.tool_foodcont,
	icon = 'octoteam/icons/inbox.png',
	mass = 0.1,
	volume = 0.05,
	randomWeight = 0.1,
	desc = L.desc_tool_foodcont,
})

local descTool = L.descfoodtool

octoinv.registerItem('tool_pan', {
	name = L.tool_pan,
	icon = 'octoteam/icons/pan.png',
	mass = 0.8,
	volume = 1,
	randomWeight = 0.5,
	desc = descTool,
})

octoinv.registerItem('tool_pot', {
	name = L.tool_pot,
	icon = 'octoteam/icons/pot.png',
	mass = 1,
	volume = 3,
	randomWeight = 0.5,
	desc = descTool,
})

octoinv.registerItem('tool_scoop', {
	name = L.tool_scoop,
	icon = 'octoteam/icons/scoop.png',
	mass = 0.5,
	volume = 0.25,
	randomWeight = 0.25,
	desc = descTool,
})

octoinv.registerItem('tool_shaker', {
	name = L.tool_shaker,
	icon = 'octoteam/icons/cocktail_shaker.png',
	mass = 0.5,
	volume = 1,
	randomWeight = 0.5,
	desc = descTool,
})

octoinv.registerItem('tool_oventray', {
	name = L.tool_oventray,
	icon = 'octoteam/icons/oventray.png',
	mass = 1,
	volume = 2,
	randomWeight = 0.5,
	desc = descTool,
})

octoinv.registerItem('tool_pastrybag', {
	name = L.tool_pastrybag,
	icon = 'octoteam/icons/pastry_bag.png',
	mass = 0.3,
	volume = 0.5,
	randomWeight = 0.25,
	desc = descTool,
})

octoinv.registerItem('tool_teapot', {
	name = L.tool_teapot,
	icon = 'octoteam/icons/pot_tea.png',
	mass = 0.5,
	volume = 1,
	randomWeight = 0.5,
	desc = descTool,
})

octoinv.registerItem('tool_coffeepot', {
	name = L.tool_coffeepot,
	icon = 'octoteam/icons/pot_coffee.png',
	mass = 0.5,
	volume = 1,
	randomWeight = 0.5,
	desc = descTool,
})

------------------------------------------------
--
-- RESOURCES
--
------------------------------------------------

local descIng = L.descing

octoinv.registerItem('ing_water', {
	name = L.ing_water,
	icon = 'octoteam/icons/bottle.png',
	mass = 0.5,
	volume = 0.5,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_egg', {
	name = L.ing_egg,
	icon = 'octoteam/icons/food_egg.png',
	mass = 0.08,
	volume = 0.1,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_oil', {
	name = L.ing_oil,
	icon = 'octoteam/icons/food_oil.png',
	mass = 0.4,
	volume = 0.5,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_salt', {
	name = L.ing_salt,
	icon = 'octoteam/icons/food_salt.png',
	mass = 0.05,
	volume = 0.1,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_potato', {
	name = L.ing_potato,
	icon = 'octoteam/icons/food_potato.png',
	mass = 0.12,
	volume = 0.15,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_cheese', {
	name = L.ing_cheese,
	icon = 'octoteam/icons/food_cheese.png',
	mass = 0.2,
	volume = 0.2,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_flour', {
	name = L.ing_flour,
	icon = 'octoteam/icons/food_flour.png',
	mass = 0.2,
	volume = 0.2,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_onion', {
	name = L.ing_onion,
	icon = 'octoteam/icons/food_onion.png',
	mass = 0.08,
	volume = 0.1,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_milk', {
	name = L.ing_milk,
	icon = 'octoteam/icons/food_milk.png',
	mass = 1,
	volume = 1,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_cream', {
	name = L.ing_cream,
	icon = 'octoteam/icons/food_milk2.png',
	mass = 0.3,
	volume = 0.3,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_meat', {
	name = L.ing_meat,
	icon = 'octoteam/icons/food_meat4.png',
	mass = 0.25,
	volume = 0.25,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_carrot', {
	name = L.ing_carrot,
	icon = 'octoteam/icons/food_carrot.png',
	mass = 0.12,
	volume = 0.1,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_tomato', {
	name = L.ing_tomato,
	icon = 'octoteam/icons/food_tomato.png',
	mass = 0.12,
	volume = 0.15,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_sugar', {
	name = L.ing_sugar,
	icon = 'octoteam/icons/food_sugar.png',
	mass = 0.1,
	volume = 0.1,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_mushroom', {
	name = L.ing_mushroom,
	icon = 'octoteam/icons/food_mushroom.png',
	mass = 0.05,
	volume = 0.05,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_sausage', {
	name = L.ing_sausage,
	icon = 'octoteam/icons/food_sausage.png',
	mass = 0.1,
	volume = 0.1,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_sausage2', {
	name = L.ing_sausage2,
	icon = 'octoteam/icons/food_sausage2.png',
	mass = 0.15,
	volume = 0.15,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_bread', {
	name = L.ing_bread,
	icon = 'octoteam/icons/food_bread.png',
	mass = 0.15,
	volume = 0.5,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_honey', {
	name = L.ing_honey,
	icon = 'octoteam/icons/food_honey.png',
	mass = 0.3,
	volume = 0.2,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_spice', {
	name = L.ing_spice,
	icon = 'octoteam/icons/food_spice.png',
	mass = 0.05,
	volume = 0.1,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_kvas', {
	name = L.ing_kvas,
	icon = 'octoteam/icons/food_kvas.png',
	mass = 0.5,
	volume = 0.5,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_cucumber', {
	name = L.ing_cucumber,
	icon = 'octoteam/icons/food_cucumber.png',
	mass = 0.15,
	volume = 0.15,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_rice', {
	name = L.ing_rice,
	icon = 'octoteam/icons/food_rice.png',
	mass = 0.2,
	volume = 0.2,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_nut', {
	name = L.ing_nut,
	icon = 'octoteam/icons/food_nut.png',
	mass = 0.1,
	volume = 0.1,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_apple', {
	name = L.ing_apple,
	icon = 'octoteam/icons/food_apple.png',
	mass = 0.15,
	volume = 0.15,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_corn', {
	name = L.ing_corn,
	icon = 'octoteam/icons/food_corn.png',
	mass = 0.2,
	volume = 0.2,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_celery', {
	name = L.ing_celery,
	icon = 'octoteam/icons/food_celery.png',
	mass = 0.2,
	volume = 0.2,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_bacon', {
	name = L.ing_bacon,
	icon = 'octoteam/icons/food_bacon.png',
	mass = 0.15,
	volume = 0.15,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_olive', {
	name = L.ing_olive,
	icon = 'octoteam/icons/food_olive.png',
	mass = 0.15,
	volume = 0.15,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_chili', {
	name = L.ing_chili,
	icon = 'octoteam/icons/food_chili.png',
	mass = 0.1,
	volume = 0.1,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_broccoli', {
	name = L.ing_broccoli,
	icon = 'octoteam/icons/food_broccoli.png',
	mass = 0.15,
	volume = 0.15,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_pineapple', {
	name = L.ing_pineapple,
	icon = 'octoteam/icons/food_pineapple.png',
	mass = 0.5,
	volume = 0.5,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_pumpkin', {
	name = L.ing_pumpkin,
	icon = 'octoteam/icons/food_pumpkin.png',
	mass = 0.8,
	volume = 0.8,
	randomWeight = 0.1,
	desc = descIng,
})

-- octoinv.registerItem('ing_fish', {
-- 	name = L.ing_fish,
-- 	icon = 'octoteam/icons/food_fish.png',
-- 	mass = 0.3,
-- 	volume = 0.3,
-- 	randomWeight = 0.1,
-- 	desc = descIng,
-- })

octoinv.registerItem('ing_strawberry', {
	name = L.ing_strawberry,
	icon = 'octoteam/icons/food_strawberry.png',
	mass = 0.3,
	volume = 0.3,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_watermelon', {
	name = L.ing_watermelon,
	icon = 'octoteam/icons/food_watermelon.png',
	mass = 1.5,
	volume = 1.5,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_melon', {
	name = L.ing_melon,
	icon = 'octoteam/icons/food_melon.png',
	mass = 1.5,
	volume = 1.5,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_soy', {
	name = L.ing_soy,
	icon = 'octoteam/icons/food_soy.png',
	mass = 0.3,
	volume = 0.3,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_peas', {
	name = L.ing_peas,
	icon = 'octoteam/icons/food_peas.png',
	mass = 0.3,
	volume = 0.3,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_lettuce', {
	name = L.ing_lettuce,
	icon = 'octoteam/icons/food_lettuce.png',
	mass = 0.2,
	volume = 0.2,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_cabbage', {
	name = L.ing_cabbage,
	icon = 'octoteam/icons/food_cabbage.png',
	mass = 0.5,
	volume = 0.5,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_beet', {
	name = L.ing_beet,
	icon = 'octoteam/icons/food_beet.png',
	mass = 0.2,
	volume = 0.2,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_redish', {
	name = L.ing_redish,
	icon = 'octoteam/icons/food_redish.png',
	mass = 0.2,
	volume = 0.2,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_eggplant', {
	name = L.ing_eggplant,
	icon = 'octoteam/icons/food_eggplant.png',
	mass = 0.4,
	volume = 0.4,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_prawn', {
	name = L.ing_prawn,
	icon = 'octoteam/icons/food_prawn.png',
	mass = 0.2,
	volume = 0.2,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_avocado', {
	name = L.ing_avocado,
	icon = 'octoteam/icons/food_avocado.png',
	mass = 0.3,
	volume = 0.3,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_pita', {
	name = L.ing_pita,
	icon = 'octoteam/icons/food_pita.png',
	mass = 0.2,
	volume = 0.2,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_cocoa', {
	name = L.ing_cocoa,
	icon = 'octoteam/icons/food_cocoa.png',
	mass = 0.2,
	volume = 0.2,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_choco', {
	name = L.ing_choco,
	icon = 'octoteam/icons/food_choco.png',
	mass = 0.2,
	volume = 0.2,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_coffee', {
	name = L.ing_coffee,
	icon = 'octoteam/icons/food_coffee.png',
	mass = 0.1,
	volume = 0.1,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_tea', {
	name = L.ing_tea,
	icon = 'octoteam/icons/leaves.png',
	mass = 0.1,
	volume = 0.1,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_banana', {
	name = L.ing_banana,
	icon = 'octoteam/icons/food_banana.png',
	mass = 0.25,
	volume = 0.25,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_orange', {
	name = L.ing_orange,
	icon = 'octoteam/icons/food_orange.png',
	mass = 0.2,
	volume = 0.25,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_lemon', {
	name = L.ing_lemon,
	icon = 'octoteam/icons/food_lemon.png',
	mass = 0.15,
	volume = 0.2,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_sauce', {
	name = L.ing_sauce,
	icon = 'octoteam/icons/food_sauce.png',
	mass = 0.2,
	volume = 0.15,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_pasta', {
	name = L.ing_pasta,
	icon = 'octoteam/icons/food_pasta.png',
	mass = 0.5,
	volume = 0.8,
	randomWeight = 0.25,
	desc = descIng,
})

------------------------------------------------
--
-- CRAFTED RESOURCES
--
------------------------------------------------

octoinv.registerItem('ing_potato2', {
	name = L.ing_potato2,
	icon = 'octoteam/icons/food_potato_boiled.png',
	mass = 0.12,
	volume = 0.15,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_meatball', {
	name = L.ing_meatball,
	icon = 'octoteam/icons/food_cutlet.png',
	mass = 0.15,
	volume = 0.15,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_roastmeat', {
	name = L.ing_roastmeat,
	icon = 'octoteam/icons/food_meat5.png',
	mass = 0.15,
	volume = 0.15,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_potatomash', {
	name = L.ing_potatomash,
	icon = 'octoteam/icons/food_porrige.png',
	mass = 0.15,
	volume = 0.15,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_soup', {
	name = L.ing_soup,
	icon = 'octoteam/icons/food_bouillon.png',
	mass = 0.5,
	volume = 0.5,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_icecream', {
	name = L.ing_icecream,
	icon = 'octoteam/icons/food_icecream2.png',
	mass = 0.1,
	volume = 0.1,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_dough1', {
	name = L.dough1,
	icon = 'octoteam/icons/food_pita.png',
	mass = 0.2,
	volume = 0.2,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_dough2', {
	name = L.dough2,
	icon = 'octoteam/icons/food_pita.png',
	mass = 0.2,
	volume = 0.2,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_dough3', {
	name = L.ing_dough3,
	icon = 'octoteam/icons/food_pita.png',
	mass = 0.2,
	volume = 0.2,
	randomWeight = 0.1,
	desc = descIng,
})

octoinv.registerItem('ing_pizza_base', {
	name = L.ing_pizza_base,
	icon = 'octoteam/icons/food_pizza_base.png',
	mass = 0.5,
	volume = 0.5,
	randomWeight = 0.1,
	desc = descIng,
})
