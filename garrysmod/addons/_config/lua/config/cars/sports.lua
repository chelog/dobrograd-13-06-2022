carDealer.addCategory('sports', {
	name = 'Спортивные',
	icon = 'octoteam/icons-16/user.png',
	queue = true,
	canUse = carDealer.checks.civil,
	spawns = carDealer.civilSpawns,
})

carDealer.addVeh('feltzer2', {
	name = 'Feltzer',
	simfphysID = 'sim_fphys_gta4_feltzer',
	price = 3850000,
	bodygroups = {
		[1] = {
			name = 'Крыша',
			variants = {
				{ 'Заводская', 1000 },
				{ 'Мягкая', 275000 },
				{ 'Жесткая', 240000 },
			},
		},
	},
})

carDealer.addVeh('comet2', {
	name = 'Comet',
	simfphysID = 'sim_fphys_gta4_comet',
	price = 5000000,
})

carDealer.addVeh('banshee2', {
	name = 'Banshee',
	simfphysID = 'sim_fphys_gta4_banshee',
	price = 5800000,
	default = {
		bg = { [2] = 1 },
	},
	bodygroups = {
		[1] = {
			name = 'Крыша',
			variants = {
				{ 'Заводская', 1000 },
				{ 'Рама', 85000 },
				{ 'Закрытая', 325000 },
			},
		},
		[2] = {
			name = 'Капот',
			variants = {
				{ 'С вентиляцией', 145000 },
				{ 'Заводской', 1000 },
			},
		},
	},
})

--
-- DOBRO
--

carDealer.addVeh('sultanrs2', {
	name = 'Sultan RS',
	simfphysID = 'sim_fphys_gta4_sultanrs',
	price = 3000000,
	bodygroups = {
		[1] = {
			name = 'Капот',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Воздухозаборник', 235000 },
			},
		},
	},
	canUse = carDealer.checks.dobro,
	tags = { carDealer.tags.dobro },
})
