hook.Add('car-dealer.priceOverride', 'dbg-police.dpd', function(ply, class)
	local cdData = carDealer.vehicles[class]
	if ply:Team() == TEAM_DPD and cdData.police and cdData.deposit then return 0 end
end)

--
-- STANDARD
--

carDealer.addCategory('dpd', {
	name = 'DPD',
	ems = true,
	icon = 'octoteam/icons-16/user_policeman_white.png',
	canUse = function(ply) return ply:Team() == TEAM_DPD, 'Доступно только DPD' end,
	spawns = carDealer.policeSpawns,
	spawnCheck = carDealer.limitedSpawn(3, 'dpd', 'В городе уже много автомобилей DPD, найди напарника или попробуй чуть позже'),
	limitGroup = 'dpd',
})

carDealer.addVeh('dpd-vapid', {
	category = 'dpd',
	name = 'DPD Vapid',
	simfphysID = 'sim_fphys_gta4_police',
	price = 30000,
	deposit = true,
	police = true,
	radioWhitelist = carDealer.policeRadioStations,
})

carDealer.addVeh('dpd-merit', {
	category = 'dpd',
	name = 'DPD Merit',
	simfphysID = 'sim_fphys_gta4_police2',
	price = 40000,
	deposit = true,
	police = true,
	radioWhitelist = carDealer.policeRadioStations,
})

carDealer.addVeh('dpd-buffalo', {
	category = 'dpd',
	name = 'DPD Buffalo',
	simfphysID = 'sim_fphys_tbogt_police3',
	price = 75000,
	deposit = true,
	police = true,
	canUse = function(ply)
		if ply:Team() == TEAM_DPD or ply:Team() == TEAM_WCSO then return true end
		if ply:isCP() and ply:Team() ~= TEAM_FBI and ply:Team() ~= TEAM_MAYOR then return carDealer.checks.dobro(ply) end
		return false
	end,
	tags = { carDealer.tags.dobro },
	radioWhitelist = carDealer.policeRadioStations,
})

--
-- NOMARK
--

local ranks = octolib.array.toKeys {'swat', 'dec1', 'se1', 'se2', 'dec2', 'dec3', 'lie', 'cap', 'cmd', 'asch', 'asc', 'chi'}
carDealer.addCategory('nomark', {
	name = 'Немаркированные',
	icon = 'icon16/user_suit.png',
	ems = true,
	doNotEvacuate = true,
	canUse = function(ply) return ply:Team() == TEAM_DPD and ranks[ply:GetActiveRank('dpd') or ''] or false, 'Доступно только детективам, либо сержанту и выше' end,
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

carDealer.addVeh('nomark_premier', {
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

carDealer.addVeh('nomark_dilettante', {
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

carDealer.addVeh('nomark_buffalo', {
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

carDealer.addVeh('nomark_admiral', {
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

carDealer.addVeh('nomark_taxi', {
	name = 'Taxi',
	simfphysID = 'sim_fphys_gta4_taxi2',
	price = 8000,
	police = true,
	deposit = true,
	default = {
		col = { Color(215,142,16), Color(215,142,16), Color(0,0,0), Color(215,142,16) },
	},
	plateCol = plateCol,
})

carDealer.addVeh('nomark_cabbie', {
	name = 'Cabby',
	simfphysID = 'sim_fphys_gta4_cabby',
	price = 15000,
	police = true,
	deposit = true,
	default = {
		col = { Color(215,142,16), Color(215,142,16), Color(0,0,0), Color(215,142,16) },
	},
	plateCol = plateCol,
})

--
-- SWAT
--

carDealer.addCategory('swat', {
	name = 'S.W.A.T',
	icon = 'icon16/lightning.png',
	ems = true,
	bulletproof = true,
	doNotEvacuate = true,
	canUse = function(ply) return ply:Team() == TEAM_DPD and ply:GetActiveRank('dpd') == 'swat', 'Доступно только S.W.A.T' end,
	spawnCheck = carDealer.limitedSpawn(2, 'swat', 'В городе уже много автомобилей SWAT, найди напарника или попробуй чуть позже'),
	limitGroup = 'swat',
	spawns = carDealer.policeSpawns,
})

carDealer.addVeh('swat_moonbeam', {
	name = 'Moonbeam',
	simfphysID = 'sim_fphys_gta4_moonbeam',
	price = 0,
	deposit = true,
	default = {
		col = { Color(15,15,15), Color(15,15,15), Color(0,0,0), Color(15,15,15)},
	},
})

carDealer.addVeh('swat_huntley', {
	name = 'Huntley',
	simfphysID = 'sim_fphys_gta4_huntley',
	price = 0,
	deposit = true,
	police = true,
	glauncher = true,
	default = {
		col = { Color(15,15,15), Color(15,15,15), Color(0,0,0), Color(15,15,15)},
	},
})

carDealer.addVeh('swat_enforcer', {
	name = 'Enforcer',
	simfphysID = 'sim_fphys_gta4_nstockade',
	price = 0,
	bulletproof = true,
	deposit = true,
	police = true,
	glauncher = true,
	radioWhitelist = carDealer.policeRadioStations,
})

carDealer.addVeh('swat_bearcat', {
	name = 'BearCat',
	simfphysID = 'sim_fphys_gta4_bearcat',
	previewOffset = Vector(0, 10, -30),
	SpawnAngleOffset = Angle(0,90,0),
	price = 0,
	bulletproof = true,
	deposit = true,
	police = true,
	glauncher = true,
	radioWhitelist = carDealer.policeRadioStations,
})

carDealer.addVeh('swat_bearcat_rescue', {
	name = 'BearCat Medevac',
	simfphysID = 'sim_fphys_gta4_bearcat',
	previewOffset = Vector(0, 10, -30),
	SpawnAngleOffset = Angle(0,90,0),
	price = 0,
	default = {
		skin = 2,
	},
	bulletproof = true,
	deposit = true,
	police = true,
	glauncher = true,
	radioWhitelist = carDealer.policeRadioStations,
})