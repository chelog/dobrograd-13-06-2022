hook.Add('car-dealer.priceOverride', 'dbg-police.wcso', function(ply, class)
	local cdData = carDealer.vehicles[class]
	if ply:Team() == TEAM_WCSO and cdData.police and cdData.deposit then return 0 end
end)

carDealer.addCategory('wcso', {
	name = 'Офис Шерифа',
	icon = octolib.icons.silk16('sheriff'),
	ems = true,
	doNotEvacuate = true,
	canUse = function(ply) return ply:Team() == TEAM_WCSO, 'Доступно только сотрудникам Офиса Шерифа на службе' end,
	spawns = carDealer.policeSpawns,
	spawnCheck = carDealer.limits.police,
	limitGroup = 'police',
})

carDealer.addVeh('wcso-vapid', {
	category = 'wcso',
	name = 'Police Vapid',
	simfphysID = 'sim_fphys_gta4_police',
	price = 30000,
	deposit = true,
	police = true,
	radioWhitelist = carDealer.policeRadioStations,
	default = {
		mats = {
			[1] = 'octoteam/models/vehicles/stainer/sheriff_livery_clr_1',
		},
	},
})

carDealer.addVeh('wcso-merit', {
	category = 'wcso',
	name = 'Police Merit',
	simfphysID = 'sim_fphys_gta4_police2',
	price = 40000,
	deposit = true,
	police = true,
	radioWhitelist = carDealer.policeRadioStations,
	default = {
		mats = {
			[14] = 'octoteam/models/vehicles/merit/sheriff2_livery_clr_1',
		},
	},
})

carDealer.addVeh('wcso-buffalo', {
	category = 'wcso',
	name = 'Police Buffalo',
	simfphysID = 'sim_fphys_tbogt_police3',
	price = 75000,
	deposit = true,
	police = true,
	radioWhitelist = carDealer.policeRadioStations,
	default = {
		mats = {
			[6] = 'octoteam/models/vehicles/buffalo/sheriff3_livery_clr_1',
		},
	},
})

local ranks = octolib.array.toKeys {'srg', 'lie', 'cap', 'ass', 'she', 'seb'}
carDealer.addCategory('wcso_nomark', {
	name = 'Немаркированные',
	icon = 'icon16/user_suit.png',
	ems = true,
	doNotEvacuate = true,
	canUse = function(ply) return ply:Team() == TEAM_WCSO and ranks[ply:GetActiveRank('wcso') or ''] or false, 'Доступно только сержанту и старше' end,
	spawns = {
		rp_evocity_dbg_220222 = {
			{ Vector(-4656, -7516, 225), Angle(0,-90,0) }, -- Duglas
			{ Vector(-4656, -7211, 225), Angle(0,-90,0) },
			{ Vector(-4656, -6906, 225), Angle(0,-90,0) },
			{ Vector(-4656, -6601, 225), Angle(0,-90,0) },
			{ Vector(-4656, -6296, 225), Angle(0,-90,0) },
		},
		rp_eastcoast_v4c = carDealer.policeSpawns.rp_eastcoast_v4c,
		rp_truenorth_v1a = carDealer.policeSpawns.rp_truenorth_v1a,
	},
	spawnCheck = carDealer.limits.police,
	limitGroup = 'police',
})

local randomColorTags = { {'icon16/color_wheel.png', 'Случайный цвет'} }
local function randomColor()
	local colData = table.Random(carDealer.defaultCarColors)
	local _, r, g, b = unpack(colData)
	local col = Color(r, g, b)
	return { col, col, Color(0,0,0), col }
end

local plateCol = {
	bg = Color(255, 255, 255),
	border = Color(40, 40, 40),
	title = Color(255, 255, 255),
	text = Color(0, 0, 0),
}

carDealer.addVeh('wcso_nomark_premier', {
	name = 'Premier',
	simfphysID = 'sim_fphys_gta4_premier',
	price = 0,
	police = true,
	deposit = true,
	tags = randomColorTags,
	default = {
		col = randomColor,
	},
	plateCol = plateCol,
})

carDealer.addVeh('wcso_nomark_dilettante', {
	name = 'Dilettante',
	simfphysID = 'sim_fphys_gta4_dilettante',
	price = 0,
	police = true,
	deposit = true,
	tags = randomColorTags,
	default = {
		col = randomColor,
	},
	plateCol = plateCol,
})

carDealer.addVeh('wcso_nomark_buffalo', {
	name = 'Buffalo',
	simfphysID = 'sim_fphys_gta4_fbi',
	price = 0,
	police = true,
	deposit = true,
	tags = randomColorTags,
	default = {
		col = randomColor,
	},
	plateCol = plateCol,
})

carDealer.addVeh('wcso_nomark_admiral', {
	name = 'Admiral',
	simfphysID = 'sim_fphys_gta4_admiral',
	price = 0,
	police = true,
	deposit = true,
	tags = randomColorTags,
	default = {
		col = randomColor,
	},
	plateCol = plateCol,
})

carDealer.addVeh('wcso_nomark_huntley', {
	name = 'Huntley',
	simfphysID = 'sim_fphys_gta4_huntley',
	price = 0,
	police = true,
	deposit = true,
	tags = randomColorTags,
	default = {
		col = randomColor,
	},
	plateCol = plateCol,
})


local function isSeb(ply)
	return ply:GetActiveRank('wcso') == 'seb', 'Доступно только S.E.B.'
end

carDealer.addVeh('wcso_nomark_mule', {
	name = 'Mule',
	simfphysID = 'sim_fphys_gta4_mule',
	price = 0,
	police = true,
	deposit = true,
	tags = randomColorTags,
	default = {
		col = randomColor,
	},
	plateCol = plateCol,
	canUse = isSeb,
})

carDealer.addVeh('wcso_nomark_burrito', {
	name = 'Burrito',
	simfphysID = 'sim_fphys_gta4_burrito',
	price = 0,
	police = true,
	deposit = true,
	tags = randomColorTags,
	default = {
		col = randomColor,
	},
	plateCol = plateCol,
	canUse = isSeb,
})

carDealer.addVeh('wcso_nomark_moonbeam', {
	name = 'Moonbeam',
	simfphysID = 'sim_fphys_gta4_moonbeam',
	price = 0,
	police = true,
	deposit = true,
	tags = randomColorTags,
	default = {
		col = randomColor,
	},
	plateCol = plateCol,
	canUse = isSeb,
})

carDealer.addVeh('wcso_nomark_taxi', {
	name = 'Taxi',
	simfphysID = 'sim_fphys_gta4_taxi2',
	price = 8000,
	police = true,
	deposit = true,
	default = {
		col = { Color(215,142,16), Color(215,142,16), Color(0,0,0), Color(215,142,16) },
	},
	plateCol = plateCol,
	canUse = isSeb,
})

carDealer.addVeh('wcso_nomark_cabbie', {
	name = 'Cabby',
	simfphysID = 'sim_fphys_gta4_cabby',
	price = 15000,
	police = true,
	deposit = true,
	default = {
		col = { Color(215,142,16), Color(215,142,16), Color(0,0,0), Color(215,142,16) },
	},
	plateCol = plateCol,
	canUse = isSeb,
})

-- SEB

carDealer.addVeh('seb_enforcer', {
	name = 'Enforcer',
	category = 'wcso',
	simfphysID = 'sim_fphys_gta4_nstockade',
	customFOV = 38,
	price = 0,
	bulletproof = true,
	deposit = true,
	police = true,
	canUse = isSeb,
	glauncher = true,
	canSee = function(ply)
		return ply:GetActiveRank('wcso') == 'seb'
	end,
	default = {
		skin = 1,
	},
	radioWhitelist = carDealer.policeRadioStations,
})
