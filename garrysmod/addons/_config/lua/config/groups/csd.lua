local models = {}

-- ELECTRICIANS
local electricianBgs = {
	[2] = {
		name = 'Головной убор',
		vals = {
			{ 'Нет', 0 },
			{ 'Шлем', 2 },
			{ 'Шлем + Наушники', 1 },
		},
	},
	[3] = {
		name = 'Жилет',
	},
	[4] = {
		name = 'Очки',
	},
}
for i = 1, 9 do
	models[#models + 1] = {
		name = 'Электрик ' .. i,
		male = true,
		model = ('models/player/supernek/workers/electricians/electrician_male%02d.mdl'):format(i),
		bgs = electricianBgs,
	}
end

-- HANDYMEN
local handymanBgs = {
	[2] = {
		name = 'Жилет',
	},
}
for i = 1, 9 do
	models[#models + 1] = {
		name = 'Мастер ' .. i,
		male = true,
		model = ('models/player/supernek/workers/handymen/handyman_male%02d.mdl'):format(i),
		bgs = handymanBgs,
	}
end

-- PLUMBERS
local plumberBgs = {
	[2] = {
		name = 'Кепка',
	},
	[3] = {
		name = 'Жилет',
	},
}
for i = 1, 9 do
	models[#models + 1] = {
		name = 'Сантехник ' .. i,
		male = true,
		model = ('models/player/supernek/workers/plumbers/plumber_male%02d.mdl'):format(i),
		bgs = plumberBgs,
	}
end

-- SCAVENGERS
local scavengerBgs = {
	[2] = {
		name = 'Жилет',
	},
}
for i = 1, 9 do
	models[#models + 1] = {
		name = 'Мусорщик ' .. i,
		male = true,
		model = ('models/player/supernek/workers/scavengers/scavenger_male%02d.mdl'):format(i),
		bgs = scavengerBgs,
	}
end

-- INSPECTORS
for i = 1, 7 do
	models[#models + 1] = {
		model = ('models/player/kerry/medic/medic_%02i.mdl'):format(i),
		male = true,
		name = 'Инспектор ' .. i,
		requiredMats = {
			[4] = 'models/debug/debugwhite',
			[7] = 'null',
		}
	}
	if i == 7 then continue end
	models[#models + 1] = {
		model = ('models/player/kerry/medic/medic_%02i_f.mdl'):format(i),
		male = false,
		name = 'Инспектор ' .. i,
		requiredMats = {
			[4] = 'models/debug/debugwhite',
			[5] = 'dev/dev_tvmonitor1a',
		}
	}
end

simpleOrgs.addOrg('csd', {
	name = 'Городская служба',
	title = 'Городская служба',
	shortTitle = 'Городская служба',
	team = 'csd',
	mdls = models,
	talkieFreq = 'csd',
})

carDealer.addCategory('csd', {
	name = 'Городская служба',
	icon = 'octoteam/icons-16/wrench.png',
	ems = true,
	queue = true,
	doNotEvacuate = true,
	canUse = function(ply) return ply:Team() == TEAM_CSD, 'Доступно только городской службе' end,
	spawns = {
		rp_riverden_dbg_220313 = {
			{ Vector(27.1625, 11166.7, 29.3211), Angle(0, 0, 0) },
			{ Vector(28.6012, 10978.4, 30.8232), Angle(0, 0, 0) },
			{ Vector(26.1124, 11999.1, 28.3349), Angle(0, 0, 0) },
		},
	},
})
carDealer.addVeh('csd_burrito', {
	category = 'csd',
	name = 'Burrito',
	simfphysID = 'sim_fphys_gta4_burrito_csd',
	price = 0,
	deposit = true,
	default = {
		bg = { [1] = 4 },
		mats = {
			[1] = 'octoteam/models/vehicles/burrito/burritocsd_livery_1',
		},
	},
})
carDealer.addVeh('csd_rancher', {
	category = 'csd',
	name = 'Rancher',
	simfphysID = 'sim_fphys_gta4_rancher',
	price = 0,
	deposit = true,
	default = {
		col = { Color(0, 88, 139), Color(0, 88, 139) },
		bg = { [1] = 1 },
	},
})
carDealer.addVeh('csd_moonbeam', {
	category = 'csd',
	name = 'Moonbeam',
	simfphysID = 'sim_fphys_gta4_moonbeam',
	price = 0,
	deposit = true,
	default = {
		col = { Color(0,88,139), Color(0,88,139), Color(0,0,0), Color(0,88,139) },
	},
})
