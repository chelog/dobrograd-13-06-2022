carDealer.addCategory('large', {
	name = 'Большие',
	icon = 'octoteam/icons-16/user.png',
	queue = true,
	canUse = carDealer.checks.civil,
	spawns = carDealer.civilSpawns,
})

carDealer.addVeh('ingot2', {
	name = 'Ingot',
	simfphysID = 'sim_fphys_gta4_ingot',
	price = 1000000,
	tags = { carDealer.tags.new },
	bodygroups = {
		[1] = {
			name = 'Передний бампер',
			variants = {
				{ 'Заводской', 1000 },
				{ 'С решеткой', 45000 },
			},
		},
		[2] = {
			name = 'Пороги',
			variants = {
				{ 'Заводские', 1000 },
				{ 'Увеличенные', 35000 },
			},
		},
		[3] = {
			name = 'Решетка радиатора',
			variants = {
				{ 'Заводская', 1000 },
				{ 'Без эмблемы', 25000 },
			},
		},
		[4] = {
			name = 'Крыша',
			variants = {
				{ 'Заводская', 1000 },
				{ 'С рейлингами', 40000 },
			},
		},
	},
})

carDealer.addVeh('rebla2', {
	name = 'Rebla',
	simfphysID = 'sim_fphys_gta4_rebla',
	price = 1750000,
	bodygroups = {
		[1] = {
			name = 'Пороги',
			variants = {
				{ 'Заводские', 1000 },
				{ 'Тюнер', 85000 },
			},
		},
		[2] = {
			name = 'Передний бампер',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Тюнер', 115000 },
			},
		},
		[3] = {
			name = 'Задний бампер',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Тюнер', 130000 },
			},
		},
		[4] = {
			name = 'Спойлер',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Тюнер', 75000 },
			},
		},
		[5] = {
			name = 'Выхлоп',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Тюнер', 120000 },
			},
		},
	},
})

carDealer.addVeh('habanero2', {
	name = 'Habanero',
	simfphysID = 'sim_fphys_gta4_habanero',
	price = 2600000,
})

carDealer.addVeh('pony2', {
	name = 'Pony',
	simfphysID = 'sim_fphys_gta4_pony',
	price = 3500000,
	bodygroups = {
		[1] = {
			name = 'Крыша',
			variants = {
				{ 'Заводская', 1000 },
				{ 'Рейлинги', 120000 },
			},
		},
	},
})

carDealer.addVeh('moonbeam2', {
	name = 'Moonbeam',
	simfphysID = 'sim_fphys_gta4_moonbeam',
	price = 3600000,
	bodygroups = {
		[1] = {
			name = 'Крыша',
			variants = {
				{ 'Заводская', 1000 },
				{ 'Рейлинги', 95000 },
				{ 'Багажник', 650000 },
			},
		},
		[2] = {
			name = 'Пороги',
			variants = {
				{ 'Заводские', 1000 },
				{ 'Спортивные', 135000 },
				{ 'Металлические', 110000 },
				{ 'Со вставками', 140000 },
			},
		},
		[3] = {
			name = 'Окна',
			variants = {
				{ 'Заводские', 1000 },
				{ 'Закрытые', 60000 },
			},
		},
		[4] = {
			name = 'Аксессуары',
			variants = {
				{ 'Заводские', 1000 },
				{ 'Запаска + лестница', 120000 },
			},
		},
		[5] = {
			name = 'Решетка',
			variants = {
				{ 'Заводская', 1000 },
				{ 'Во всю ширину', 200000 },
			},
		},
	},
})

carDealer.addVeh('huntley2', {
	name = 'Huntley',
	simfphysID = 'sim_fphys_gta4_huntley',
	price = 4000000,
	bodygroups = {
		[1] = {
			name = 'Тюнинг',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Выхлоп + решетка', 250000 },
			},
		},
	},
})

carDealer.addVeh('mule2', {
	name = 'Mule',
	simfphysID = 'sim_fphys_gta4_mule',
	price = 4400000,
	customFOV = 38,
})

carDealer.addVeh('patriot2', {
	name = 'Patriot',
	simfphysID = 'sim_fphys_gta4_patriot',
	price = 4850000,
	bodygroups = {
		[1] = {
			name = 'Тюнинг',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Выхлоп + огни', 320000 },
			},
		},
		[2] = {
			name = 'Бампер',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Кунгурятник', 180000 },
			},
		},
	},
})
