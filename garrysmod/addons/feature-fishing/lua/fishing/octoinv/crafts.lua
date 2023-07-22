octoinv.registerCraft('fishing_rod', {
	name = 'Удочка',
	desc = 'Используется для ловли рыбы',
	icon = 'octoteam/icons/fishing_rod.png',
	time = 5,
	conts = {'_hand'},
	ings = {
		{'craft_stick', 1},
		{'craft_pulley', 1},
		{'fish_tackle', 1},
	},
	finish = {
		{'fishing_rod', 1},
	},
})
