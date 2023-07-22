local uniform = {
	[5] = {
		name = 'Форма',
		vals = {
			{'Работник склада', 'models/humans/modern/octo/ra2_sheet'},
			{'Работник RA', 'models/humans/modern/octo/ra1_sheet'},
		},
	},
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
		requiredSkin = 1,
		subMaterials = uniform,
	}
end)

simpleOrgs.addOrg('ra', {
	name = 'Richardson Atlantics',
	title = 'Работа в Richardson Atlantics',
	shortTitle = 'Richardson Atlantics',
	team = 'ra',
	mdls = models,
})

local carsColor = { Color(81,117,56), Color(81,117,56), Color(0,0,0), Color(81,117,56) }
carDealer.addCategory('ra', {
	name = 'RA',
	icon = 'octoteam/icons-16/lorry.png',
	queue = true,
	doNotEvacuate = true,
	spawns = carDealer.civilSpawns,
	canUse = function(ply)
		if not ply:IsOrgMember('ra') then
			return false, 'Доступно только для Richardson Atlantics'
		end
	end,
})

carDealer.addVeh('ra_pony', {
	name = 'Pony',
	simfphysID = 'sim_fphys_gta4_pony',
	price = 5000,
	deposit = true,
	default = {
		col = carsColor,
	},
})

carDealer.addVeh('ra_packer', {
	name = 'Packer',
	simfphysID = 'sim_fphys_gta4_packer',
	price = 15000,
	deposit = true,
	customFOV = 42,
	default = {
		col = carsColor,
	},
})

carDealer.addVeh('ra_boxville', {
	name = 'Boxville',
	simfphysID = 'sim_fphys_gta4_boxville',
	price = 20000,
	deposit = true,
	customFOV = 38,
	default = {
		col = carsColor,
	},
})

carDealer.addVeh('ra_yankee', {
	name = 'Yankee',
	simfphysID = 'sim_fphys_gta4_yankee',
	price = 25000,
	deposit = true,
	customFOV = 42,
	default = {
		col = carsColor,
		skin = 3,
	},
})

carDealer.addVeh('ra_flatbed', {
	name = 'Flatbed',
	simfphysID = 'sim_fphys_gta4_flatbed',
	price = 30000,
	deposit = true,
	customFOV = 45,
	default = {
		col = carsColor,
	},
})
