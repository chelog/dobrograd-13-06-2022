carDealer.addCategory('4doors', {
	name = 'Четырехдверные',
	icon = 'octoteam/icons-16/user.png',
	queue = true,
	canUse = carDealer.checks.civil,
	spawns = carDealer.civilSpawns,
})

carDealer.addVeh('premier2', {
	name = 'Premier',
	simfphysID = 'sim_fphys_gta4_premier',
	price = 450000,
})

carDealer.addVeh('esperanto2', {
	name = 'Esperanto',
	simfphysID = 'sim_fphys_gta4_esperanto',
	price = 600000,
})

carDealer.addVeh('dilettante2', {
	name = 'Dilettante',
	simfphysID = 'sim_fphys_gta4_dilettante',
	price = 700000,
})

carDealer.addVeh('merit2', {
	name = 'Merit',
	simfphysID = 'sim_fphys_gta4_merit',
	price = 850000,
})

carDealer.addVeh('df2', {
	name = 'DF8-90',
	simfphysID = 'sim_fphys_gta4_df8',
	price = 1350000,
	bodygroups = {
		[1] = {
			name = 'Спойлер',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Высокий', 180000 },
				{ 'Низкий', 120000 },
			},
		},
	},
})

carDealer.addVeh('emperor2', {
	name = 'Emperor',
	simfphysID = 'sim_fphys_gta4_emperor',
	price = 1450000,
})

carDealer.addVeh('schafter2', {
	name = 'Schafter',
	simfphysID = 'sim_fphys_gta4_schafter',
	price = 2000000,
	default = {
		bg = { [1] = 1 },
	},
	bodygroups = {
		[1] = {
			name = 'Решетка',
			variants = {
				{ 'Частая', 95000 },
				{ 'Заводская', 1000 },
			},
		},
		[2] = {
			name = 'Передний бампер',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Тюнер', 120000 },
			},
		},
		[3] = {
			name = 'Пороги',
			variants = {
				{ 'Заводские', 1000 },
				{ 'Тюнер', 90000 },
			},
		},
		[4] = {
			name = 'Задний бампер',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Тюнер', 135000 },
			},
		},
	},
})

carDealer.addVeh('vincent2', {
	name = 'Vincent',
	simfphysID = 'sim_fphys_gta4_vincent',
	price = 2200000,
	tags = { carDealer.tags.new },
	bodygroups = {
		[1] = {
			name = 'Спойлер',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Спортивный', 115000 },
			},
		},
	},
})

carDealer.addVeh('admiral2', {
	name = 'Admiral',
	simfphysID = 'sim_fphys_gta4_admiral',
	price = 3200000,
})

carDealer.addVeh('cognoscenti2', {
	name = 'Cognoscenti',
	simfphysID = 'sim_fphys_gta4_cognoscenti',
	price = 5250000,
})

carDealer.addVeh('superdiamond2', {
	name = 'Super Diamond',
	simfphysID = 'sim_fphys_tbogt_superd',
	price = 5800000,
	tags = { carDealer.tags.new },
})

carDealer.addVeh('superdiamond-coupe2', {
	name = 'Super Diamond Coupe',
	simfphysID = 'sim_fphys_tbogt_superd2',
	price = 6000000,
	tags = { carDealer.tags.new },
	bodygroups = {
		[1] = {
			name = 'Крыша',
			variants = {
				{ 'Заводская', 1000 },
				{ 'Мягкая', 450000 },
			},
		},
	},
})

--
-- DOBRO
--

carDealer.addVeh('hakumai2', {
	name = 'Hakumai',
	simfphysID = 'sim_fphys_gta4_hakumai',
	price = 2250000,
	bodygroups = {
		[1] = {
			name = 'Пороги',
			variants = {
				{ 'Заводские', 1000 },
				{ 'Тюнер', 140000 },
			},
		},
		[2] = {
			name = 'Спойлер',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Тюнер', 180000 },
			},
		},
		[3] = {
			name = 'Передний бампер',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Тюнер', 145000 },
			},
		},
		[4] = {
			name = 'Огни',
			variants = {
				{ 'Заводские', 1000 },
				{ 'Противотуманки', 95000 },
			},
		},
	},
	canUse = carDealer.checks.dobro,
	tags = { carDealer.tags.dobro },
})

--
-- EVENT
--

carDealer.addVeh('halloween_pickup', {
	name = 'Regina',
	simfphysID = 'sim_fphys_tlad_regina',
	price = 0,
	tags = { carDealer.tags.halloween },
	canSee = carDealer.checks.no,
	canUse = carDealer.checks.civil,
})
