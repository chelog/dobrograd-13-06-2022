carDealer.addCategory('2doors', {
	name = 'Двухдверные',
	icon = 'octoteam/icons-16/user.png',
	queue = true,
	canUse = carDealer.checks.civil,
	spawns = carDealer.civilSpawns,
})

-- carDealer.addVeh('faction2', {
-- 	name = 'Faction',
-- 	simfphysID = 'sim_fphys_gta4_faction',
-- 	price = 0,
-- 	bodygroups = {
-- 		[1] = {
-- 			name = 'Крыша',
-- 			variants = {
-- 				{ 'Заводская', 1000 },
-- 				{ 'Стекло', 35000 },
-- 			},
-- 		},
-- 		[2] = {
-- 			name = 'Капот',
-- 			variants = {
-- 				{ 'Заводской', 1000 },
-- 				{ 'С выступом', 50000 },
-- 			},
-- 		},
-- 	},
-- })

carDealer.addVeh('fortune2', {
	name = 'Fortune',
	simfphysID = 'sim_fphys_gta4_fortune',
	price = 950000,
})

carDealer.addVeh('vigero2', {
	name = 'Vigero',
	simfphysID = 'sim_fphys_gta4_vigero',
	price = 1250000,
})

carDealer.addVeh('rhapsody2', {
	name = 'Rhapsody',
	simfphysID = 'sim_fphys_tlad_rhapsody',
	price = 2150000,
	tags = { carDealer.tags.new },
})

carDealer.addVeh('sabre2', {
	name = 'Sabre',
	simfphysID = 'sim_fphys_gta4_sabre',
	price = 2350000,
})

carDealer.addVeh('manana2', {
	name = 'Manana',
	simfphysID = 'sim_fphys_gta4_manana',
	price = 2500000,
	bodygroups = {
		[1] = {
			name = 'Крыша',
			variants = {
				{ 'Заводская', 1000 },
				{ 'Закрытая', 190000 },
			},
		},
	},
})

carDealer.addVeh('ruiner2', {
	name = 'Ruiner',
	simfphysID = 'sim_fphys_gta4_ruiner',
	price = 2600000,
	tags = { carDealer.tags.new },
	default = {
		bg = { [2] = 1, [3] = 1 },
	},
	bodygroups = {
		[1] = {
			name = 'Капот',
			variants = {
				{ 'Заводской', 1000 },
				{ 'С вентиляцией', 75000 },
			},
		},
		[2] = {
			name = 'Крыша',
			variants = {
				{ 'Панорамная', 175000 },
				{ 'Заводская', 1000 },
			},
		},
		[3] = {
			name = 'Багажник',
			variants = {
				{ 'Открытый', 80000 },
				{ 'Заводской', 1000 },
			},
		},
	},
})

carDealer.addVeh('sabregt2', {
	name = 'Sabre GT',
	simfphysID = 'sim_fphys_gta4_sabregt',
	price = 2850000,
	tags = { carDealer.tags.new },
	bodygroups = {
		[1] = {
			name = 'Капот',
			variants = {
				{ 'Заводской', 1000 },
				{ 'С воздухозаборником', 125000 },
				{ 'С выступом', 45000 },
			},
		},
	},
})

carDealer.addVeh('futo2', {
	name = 'Futo',
	simfphysID = 'sim_fphys_gta4_futo',
	price = 3100000,
	bodygroups = {
		[1] = {
			name = 'Бампер',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Тюнер', 75000 },
			},
		},
		[2] = {
			name = 'Тюнинг',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Рама, пороги, труба и сидение', 235000 },
			},
		},
		[3] = {
			name = 'Спойлер',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Тюнер', 95000 },
			},
		},
		[4] = {
			name = 'Капот',
			variants = {
				{ 'Заводской', 1000 },
				{ 'Карбон', 160000 },
			},
		},
	},
})

--
-- EVENT
--

carDealer.addVeh('halloween_sedan', {
	name = 'Peyote',
	simfphysID = 'sim_fphys_gta4_peyote',
	price = 0,
	tags = { carDealer.tags.halloween },
	canSee = carDealer.checks.no,
	canUse = carDealer.checks.civil,
	bodygroups = {
		[1] = {
			name = 'Крыша',
			variants = {
				{ 'Заводская', 1000 },
				{ 'Закрытая', 320000 },
			},
		},
		[2] = {
			name = 'Заднее крепление',
			variants = {
				{ 'Ничего', 1000 },
				{ 'Запаска', 185000 },
			},
		},
		[3] = {
			name = 'Сидения',
			variants = {
				{ 'Заводские', 1000 },
				{ 'Зебра', 210000 },
				{ 'Черные', 75000 },
			},
		},
	},
})
