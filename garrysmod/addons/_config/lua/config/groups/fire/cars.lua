carDealer.addCategory('fire', {
	name = 'Пожарные',
	icon = octolib.icons.silk16('fire'),
	ems = true,
	doNotEvacuate = true,
	canUse = function(ply) return ply:Team() == TEAM_FIREFIGHTER and ply:GetActiveRank('fire') ~= 'cad' or false, 'Доступно только пожарным' end,
	spawns = {
		rp_evocity_dbg_220222 = {
			{ Vector(-3650, -7671, 265), Angle(0,180,0) },
			{ Vector(-3650, -7953, 265), Angle(0,180,0) },
			{ Vector(-3650, -8245, 265), Angle(0,180,0) },
		},
		rp_eastcoast_v4c = carDealer.civilSpawns.rp_eastcoast_v4c,
		rp_truenorth_v1a = {
			{ Vector(13090, 12190, 75), Angle(0, 180, 0) },
			{ Vector(13090, 11926, 75), Angle(0, 180, 0) },
			{ Vector(13090, 11680, 75), Angle(0, 180, 0) },
			{ Vector(13090, 11421, 75), Angle(0, 180, 0) },
		},
		rp_riverden_dbg_220313 = {
			{ Vector(-12195.1, 1425.92, -202.995), Angle(-0, 90, 0) },
			{ Vector(-12446.4, 1424.97, -203.212), Angle(-0, 90, 0) },
		},
	},
	spawnCheck = carDealer.limits.fire,
	limitGroup = 'fire',
})

local seniorsStaff = octolib.array.toKeys {'lie', 'cap', 'bc', 'rchi', 'ass', 'dep', 'chi'}
local highStaff = octolib.array.toKeys {'bc', 'rchi', 'ass', 'dep', 'chi'}

local function isSeniors(ply)
	return seniorsStaff[ply:GetActiveRank('fire') or ''] or false, 'Доступно только старшему пожарному составу'
end

local function isHigh(ply)
	return highStaff[ply:GetActiveRank('fire') or ''] or false, 'Доступно только высшему пожарному составу'
end

local plateCol = {
	bg = Color(255, 54, 54),
	border = Color(40, 40, 40),
	title = Color(255, 255, 255),
	txt = Color(255, 255, 255),
}

carDealer.addVeh('fireambulance', {
	category = 'fire',
	name = 'Ambulance',
	simfphysID = 'sim_fphys_gta4_ambulance',
	price = 0,
	deposit = true,
	customFOV = 42,
	default = {
		col = { Color(255,255,255), Color(255,0,0), Color(0,0,0), Color(255,255,255) },
		bg = { [1] = 1 },
	},
	radioWhitelist = carDealer.emsRadioStations,
})

carDealer.addVeh('firetruck', {
	category = 'fire',
	name = 'Fire Truck',
	simfphysID = 'sim_fphys_gta4_firetruk',
	price = 0,
	deposit = true,
	customFOV = 45,
	plateCol = plateCol,
	radioWhitelist = carDealer.emsRadioStations,
})

carDealer.addVeh('ladder', {
	name = 'Fire Truck Ladder',
	simfphysID = 'sim_fphys_l4d_fire_truck',
	price = 0,
	deposit = true,
	customFOV = 52,
	plateCol = plateCol,
	radioWhitelist = carDealer.emsRadioStations,
})

carDealer.addVeh('battalion', {
	name = 'Battalion',
	simfphysID = 'sim_fphys_gta4_battalion',
	price = 0,
	deposit = true,
	customFOV = 35,
	plateCol = plateCol,
	radioWhitelist = carDealer.emsRadioStations,
	canUse = isHigh,
	canSee = function(ply)
		return highStaff[ply:GetActiveRank('fire') or ''] or false
	end,
})

carDealer.addVeh('battalion_inv', {
	name = 'Battalion Investigator',
	simfphysID = 'sim_fphys_gta4_battalion',
	price = 0,
	deposit = true,
	customFOV = 35,
	plateCol = plateCol,
	radioWhitelist = carDealer.emsRadioStations,
	canUse = isSeniors,
	canSee = function(ply)
		return seniorsStaff[ply:GetActiveRank('fire') or ''] or false
	end,
	default = {
		mats = {
			[4] = 'octoteam/models/vehicles/landstalker/landstalkerdfd_exterior_invest',
		},
	},
})

-- carDealer.addVeh('fireranch', {
-- 	category = 'fire',
-- 	name = 'Fire Rancher',
-- 	simfphysID = 'simfphys_gta_sa_fdranch',
-- 	price = 0,
-- 	deposit = true,
-- 	plateCol = plateCol,
--	radioWhitelist = carDealer.emsRadioStations,
-- })
