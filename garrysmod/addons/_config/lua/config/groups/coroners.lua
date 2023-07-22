local clothesData = {
	icon = 'user_medical',
	['models/kerry/plats_medical_'] = {
		{
			bodygroup = 2,
			vals = {
				[0] = { 'Снять перчатки', 'cross', '/me снимает перчатки с рук' },
				[1] = { 'Надеть перчатки', 'bullet_blue', '/me надевает перчатки на руки' },
			},
		},
	},
}

local uniform = {
	[4] = {
		name = 'Форма',
		vals = {
			{'Обычная форма', 'models/medic/coroner_jbib'},
			{'Специальная форма', 'models/medic/coroner_SU'},
		},
	},
}

local coroners = {}
for i = 1, 11 do
	coroners[#coroners + 1] = {
		model = ('models/kerry/plats_medical_%02i.mdl'):format(i),
		male = true,
		name = 'Коронер ' .. i,
		subMaterials = uniform,
		requiredMats = {
			[6] = 'null',
			[7] = 'null',
			[8] = 'null',
			[11] = 'models/merriweather/lowr_diff_000_a_uni',
			[16] = 'models/medic/uppr_diff_024_a_whi',
		},
	}
	coroners[#coroners + 1] = {
		model = ('models/kerry/plats_medical_%02i.mdl'):format(i),
		male = true,
		name = 'Теплая форма ' .. i,
		requiredBgs = {[1] = 1},
		requiredMats = {
			[6] = 'null',
			[7] = 'null',
			[8] = 'models/coroner/cid',
			[11] = 'models/merriweather/lowr_diff_000_a_uni',
			[12] = 'models/coroner/cwinter',
			[16] = 'models/medic/uppr_diff_024_a_whi',
		},
	}
end
for i = 10, 11 do
	coroners[#coroners + 1] = {
		model = ('models/kerry/plats_medical_%02i.mdl'):format(i),
		male = false,
		name = 'Коронер ' .. (i-9),
		subMaterials = uniform,
		requiredMats = {
			[8] = 'null',
			[9] = 'null',
			[10] = 'null',
			[15] = 'models/merriweather/lowr_diff_000_a_uni',
			[16] = 'models/medic/uppr_diff_024_a_whi',
		},
	}
end

if SERVER then
	netstream.Hook('coroners.gloves', function(ply, value)
		if ply:getJobTable().command == 'coroner' and octolib.math.inRange(value, 0, 1) then
			ply:SetBodygroup(2, value)
		end
	end)
end

simpleOrgs.addOrg('coroners', {
	name = 'Коронеры',
	title = 'Коронеры',
	shortTitle = 'Коронеры',
	team = 'coroner',
	mdls = coroners,
	clothes = clothesData,
	talkieFreq = 'medic',
})

carDealer.addCategory('coroners', {
	name = 'Коронеры',
	ems = true,
	doNotEvacuate = true,
	icon = 'octoteam/icons-16/hospital.png',
	canUse = function(ply) return ply:Team() == TEAM_CORONER, 'Доступно только коронерам' end,
	spawns = {
		rp_evocity_dbg_220222 = {
			{ Vector(-11295, 9344, 125), Angle(0,-90,0) }, -- hospital
			{ Vector(-11111, 9344, 125), Angle(0,-90,0) },
		},
		rp_eastcoast_v4c = carDealer.civilSpawns.rp_eastcoast_v4c,
		rp_truenorth_v1a = {
			{ Vector(11667, 12990, 128), Angle(0, -90, 0) },
			{ Vector(11876, 12990, 128), Angle(0, -90, 0) },
		},
		rp_riverden_dbg_220313 = {
			{ Vector(-5453.52, 1579.42, -220.133), Angle(-0, -90, 0) },
			{ Vector(-5453.98, 2185.43, -219.886), Angle(-0, -90, 0) },
		},
	},
	spawnCheck = carDealer.limits.coroner,
	limitGroup = 'coroner',
})
carDealer.addVeh('coroners_pony', {
	category = 'coroners',
	name = 'Pony',
	simfphysID = 'sim_fphys_gta4_pony_coroner',
	price = 0,
	deposit = true,
	default = {
		mats = {
			[1] = 'octoteam/models/vehicles/moonbeam/livery1',
		},
	},
})
carDealer.addVeh('coroners_moonbeam', {
	category = 'coroners',
	name = 'Moonbeam',
	simfphysID = 'sim_fphys_gta4_moonbeam',
	price = 0,
	deposit = true,
	default = {
		mats = {
			[4] = 'octoteam/models/vehicles/moonbeam/coroner_livery2',
		},
		col = { Color(36,36,36), Color(36,36,36), Color(0,0,0), Color(36,36,36) },
	},
})
