octoinv.addShopCat('fishing', {
	name = 'Рыбалка',
	icon = 'octoteam/icons/fishing_rod.png',
})

octoinv.addShopItem('bait_bacon', {
	cat = 'fishing', price = 400,
	name = 'Наживка из бекона',
	icon = 'octoteam/icons/bait_bacon.png',
	item = 'fish_bait',
	data = {
		name = 'Наживка из бекона',
		icon = 'octoteam/icons/bait_bacon.png',
		bait = 'bacon',
	},
})

octoinv.addShopItem('bait_cheese', {
	cat = 'fishing', price = 400,
	name = 'Насадка из сыра',
	icon = 'octoteam/icons/bait_cheese.png',
	item = 'fish_bait',
	data = {
		name = 'Насадка из сыра',
		icon = 'octoteam/icons/bait_cheese.png',
		bait = 'cheese',
	},
})

octoinv.addShopItem('bait_classic', {
	cat = 'fishing', price = 400,
	name = 'Черви',
	icon = 'octoteam/icons/bait_worm.png',
	item = 'fish_bait',
	data = {
		name = 'Черви',
		icon = 'octoteam/icons/bait_worm.png',
		bait = 'classic',
	},
})

octoinv.addShopItem('bait_fish', {
	cat = 'fishing', price = 400,
	name = 'Живцы',
	icon = 'octoteam/icons/bait_fish.png',
	item = 'fish_bait',
	data = {
		name = 'Живцы',
		icon = 'octoteam/icons/bait_fish.png',
		bait = 'fish',
	},
})

octoinv.addShopItem('bait_prawn', {
	cat = 'fishing', price = 400,
	name = 'Наживка из креветок',
	icon = 'octoteam/icons/bait_shrimp.png',
	item = 'fish_bait',
	data = {
		name = 'Наживка из креветок',
		icon = 'octoteam/icons/bait_shrimp.png',
		bait = 'prawn',
	},
})

octoinv.addShopItem('bait_synthetic', {
	cat = 'fishing', price = 400,
	name = 'Светящиеся окуни',
	icon = 'octoteam/icons/bait_glowing_perch.png',
	item = 'fish_bait',
	data = {
		name = 'Светящиеся окуни',
		icon = 'octoteam/icons/bait_glowing_perch.png',
		bait = 'synthetic',
	},
})

octoinv.addShopItem('fish_tackle', {
	cat = 'fishing', price = 2000,
})

octoinv.addShopItem('fish_line1', {
	cat = 'fishing', price = 1000,
	name = 'Леска крепкая',
	icon = 'octoteam/icons/fishing_line_thick.png',
	item = 'fish_line',
	data = {
		name = 'Крепкая леска',
		icon = 'octoteam/icons/fishing_line_thick.png',
		thin = false,
	},
})

octoinv.addShopItem('fish_line2', {
	cat = 'fishing', price = 1000,
	name = 'Леска тонкая',
	icon = 'octoteam/icons/fishing_line_thin.png',
	item = 'fish_line',
	data = {
		name = 'Тонкая леска',
		icon = 'octoteam/icons/fishing_line_thin.png',
		thin = true,
	},
})
