local maleSubMats = {
	[27] = {
		name = 'Форма',
		vals = {
			{'Бежевый костюм', 'models/blairs/bs_suit_beige'},
			{'Черный костюм', 'models/blairs/bs_suit_blackf'},
			{'Светло-черный костюм', 'models/blairs/bs_suit_blacks'},
			{'Синий костюм', 'models/blairs/bs_suit_blue'},
			{'Серый костюм', 'models/blairs/bs_suit_gray'},
			{'Зеленый костюм', 'models/blairs/bs_suit_green'},
			{'Белый костюм', 'models/blairs/bs_suit_white'},
		},
	},
}

local femaleSubMats = {
	[18] = 'models/blairs/bs_suite_femwhite',
}


local models = octolib.table.mapSequential({
	'models/humans/octo/male_01_01.mdl',
	'models/humans/octo/male_01_02.mdl',
	'models/humans/octo/male_01_03.mdl',
	'models/humans/octo/male_02_01.mdl',
	'models/humans/octo/male_02_02.mdl',
	'models/humans/octo/male_02_03.mdl',
	'models/humans/octo/male_03_01.mdl',
	'models/humans/octo/male_03_02.mdl',
	'models/humans/octo/male_03_03.mdl',
	'models/humans/octo/male_03_04.mdl',
	'models/humans/octo/male_03_05.mdl',
	'models/humans/octo/male_03_06.mdl',
	'models/humans/octo/male_03_07.mdl',
	'models/humans/octo/male_04_01.mdl',
	'models/humans/octo/male_04_02.mdl',
	'models/humans/octo/male_04_03.mdl',
	'models/humans/octo/male_04_04.mdl',
	'models/humans/octo/male_05_01.mdl',
	'models/humans/octo/male_05_02.mdl',
	'models/humans/octo/male_05_03.mdl',
	'models/humans/octo/male_05_04.mdl',
	'models/humans/octo/male_05_05.mdl',
	'models/humans/octo/male_06_01.mdl',
	'models/humans/octo/male_06_02.mdl',
	'models/humans/octo/male_06_03.mdl',
	'models/humans/octo/male_06_04.mdl',
	'models/humans/octo/male_06_05.mdl',
	'models/humans/octo/male_07_01.mdl',
	'models/humans/octo/male_07_02.mdl',
	'models/humans/octo/male_07_03.mdl',
	'models/humans/octo/male_07_04.mdl',
	'models/humans/octo/male_07_05.mdl',
	'models/humans/octo/male_07_06.mdl',
	'models/humans/octo/male_08_01.mdl',
	'models/humans/octo/male_08_02.mdl',
	'models/humans/octo/male_08_03.mdl',
	'models/humans/octo/male_08_04.mdl',
	'models/humans/octo/male_09_01.mdl',
	'models/humans/octo/male_09_02.mdl',
	'models/humans/octo/male_09_03.mdl',
	'models/humans/octo/male_09_04.mdl',
}, function(v, i)
	return {
		name = 'Внешность ' .. i,
		male = true,
		model = v,
		subMaterials = maleSubMats,
		requiredSkin = 23,
	}
end)

for num, i in ipairs({ 1, 2, 3, 4, 6, 7 }) do
	models[#models + 1] = {
		name = 'Внешность ' .. num,
		male = false,
		model = ('models/humans/octo/female_%02i.mdl'):format(i),
		requiredMats = femaleSubMats,
		requiredSkin = 29,
	}
end

simpleOrgs.addOrg('taxi', {
	name = 'Такси',
	title = 'Работа в такси',
	shortTitle = 'Работа в такси',
	team = 'taxi',
	mdls = models,
	talkieFreq = 'taxi',
})

carDealer.addCategory('taxi', {
	name = 'Таксисты',
	icon = octolib.icons.silk16('car_taxi'),
	queue = true,
	canUse = function(ply) return ply:Team() == TEAM_TAXI, 'Доступно только таксистам' end,
	spawns = carDealer.civilSpawns,
	-- spawnCheck = carDealer.limitedSpawn(2, 'taxi', 'В городе уже достаточно машин такси'),
	-- limitGroup = 'taxi',
})

carDealer.addVeh('taxi_taxi', {
	name = 'Merit',
	simfphysID = 'sim_fphys_gta4_taxi2',
	price = 0,
	deposit = true,
	default = {
		bg = { [1] = 2 },
		col = { Color(215,142,16), Color(215,142,16), Color(0,0,0), Color(215,142,16) },
		skin = 1,
	},
})

carDealer.addVeh('taxi_cabbie', {
	name = 'Cabby',
	simfphysID = 'sim_fphys_gta4_cabby',
	price = 0,
	deposit = true,
	default = {
		col = { Color(215,142,16), Color(215,142,16), Color(0,0,0), Color(215,142,16) },
		skin = 1,
	},
})

carDealer.addVeh('taxi_vapid', {
	name = 'Vapid',
	simfphysID = 'sim_fphys_gta4_taxi',
	price = 0,
	deposit = true,
	default = {
		bg = { [1] = 2 },
		col = { Color(215,142,16), Color(215,142,16), Color(0,0,0), Color(215,142,16) },
		skin = 1,
	},
})