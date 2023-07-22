local fbiSubMats = {
	[27] = 'models/humans/male/group01/fbi',
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
		requiredMats = fbiSubMats,
		requiredSkin = 23,
	}
end)

simpleOrgs.addOrg('fbi', {
	name = 'ФБР',
	title = '',
	shortTitle = '',
	team = 'fbi',
	mdls = models,
	talkieFreq = 'fbi',
})

carDealer.addCategory('fbi', {
	name = 'FBI',
	icon = 'octoteam/icons-16/emotion_daddy_cool.png',
	ems = true,
	doNotEvacuate = true,
	canUse = function(ply) return ply:Team() == TEAM_FBI, 'Доступно только FBI' end,
	spawns = carDealer.civilSpawns,
	spawnCheck = carDealer.limitedSpawn(1, 'fbi', 'В городе уже есть автомобиль FBI, найди напарника или попробуй чуть позже'),
	limitGroup = 'fbi',
})

local fbiPlateCol = {
	bg = Color(75, 86, 208),
	border = Color(40, 40, 40),
	title = Color(255, 255, 255),
	txt = Color(255, 255, 255),
}

carDealer.addVeh('fbi_admiral', {
	name = 'Admiral',
	simfphysID = 'sim_fphys_gta4_admiral',
	price = 0,
	police = true,
	deposit = true,
	default = {
		col = { Color(30,30,30), Color(30,30,30), Color(0,0,0), Color(30,30,30) },
	},
	plateCol = {}, -- reset plates
})

carDealer.addVeh('fbi_emperor', {
	name = 'Emperor',
	simfphysID = 'sim_fphys_gta4_emperor',
	price = 0,
	police = true,
	deposit = true,
	default = {
		col = { Color(30,30,30), Color(30,30,30), Color(0,0,0), Color(30,30,30) },
	},
	plateCol = {}, -- reset plates
})

carDealer.addVeh('fbi_manana', {
	name = 'Manana',
	simfphysID = 'sim_fphys_gta4_manana',
	price = 0,
	police = true,
	deposit = true,
	default = {
		col = { Color(30,30,30), Color(30,30,30), Color(0,0,0), Color(30,30,30) },
		bg = { [1] = 1 },
	},
	plateCol = {}, -- reset plates
})

carDealer.addVeh('fbi_buffalo', {
	name = 'Buffalo',
	simfphysID = 'sim_fphys_gta4_fbi',
	price = 0,
	police = true,
	deposit = true,
	default = {
		col = { Color(30,30,30), Color(30,30,30), Color(0,0,0), Color(30,30,30) },
	},
	plateCol = fbiPlateCol,
})