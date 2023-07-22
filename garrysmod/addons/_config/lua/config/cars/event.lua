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

carDealer.addVeh('halloween_pickup', {
	name = 'Regina',
	simfphysID = 'sim_fphys_tlad_regina',
	price = 0,
	tags = { carDealer.tags.halloween },
	canSee = carDealer.checks.no,
	canUse = carDealer.checks.civil,
})
