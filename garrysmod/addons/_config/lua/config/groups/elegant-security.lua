simpleOrgs.addOrg('elsec', {
	name = 'Elegant Security',
	title = 'Elegant Security',
	shortTitle = 'Elegant Security',
	team = 'elsec',
	mdls = {
		{
			name = 'Сотрудник',
			model = 'models/player/camo_09.mdl',
			bgs = {
				[1] = {
					name = 'Базовый бронежилет',
				},
				[2] = {
					name = 'Кепка',
				},
				[3] = {
					name = 'Пояс',
				},
				[5] = {
					name = 'Полный бронежилет',
				},
				[6] = {
					name = 'Шлем',
				}
			},
			requiredBgs = {[4] = 1}
		}
	},
	talkieFreq = 'elsec',
})

local plateCol = {
	bg = Color(30, 30, 30),
	border = Color(255, 191, 0),
	title = Color(255, 191, 0),
	txt = Color(255, 191, 0),
}

carDealer.addCategory('elsec', {
	name = 'Elegant Security',
	icon = 'icon16/lightning.png',
	queue = true,
	ems = true,
	bulletproof = true,
	doNotEvacuate = true,
	spawns = carDealer.civilSpawns,
	canUse = function(ply) return ply:Team() == TEAM_ELSEC, 'Доступно только Elegant Security' end,
})

carDealer.addVeh('elsec_moonbeam', {
	name = 'Moonbeam',
	simfphysID = 'sim_fphys_gta4_moonbeam',
	plateCol = plateCol,
	price = 12000,
	deposit = true,
	default = {
		col = { Color(36,36,36), Color(36,36,36), Color(0,0,0), Color(36,36,36) },
	},
})

carDealer.addVeh('elsec_premier', {
	name = 'Premier',
	simfphysID = 'sim_fphys_gta4_premier',
	plateCol = plateCol,
	price = 25000,
	deposit = true,
	default = {
		col = { Color(36,36,36), Color(0,0,0), Color(0,0,0), Color(36,36,36) },
	},
})
