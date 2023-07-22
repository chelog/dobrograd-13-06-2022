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

local medicBgs = {
	[1] = {
		name = 'Форма',
		vals = {
			{'Парамедик', 0},
			{'Врач', 1},
			{'Хирург', 2},
		}
	},

	[2] = {
		name = 'Перчатки',
	},
}

local medics = {}
for i = 1, 9 do
	medics[#medics + 1] = {
		model = ('models/kerry/plats_medical_%02i.mdl'):format(i),
		male = true,
		name = 'Медик ' .. i,
		bgs = medicBgs,
	}
	if i == 6 then continue end
	medics[#medics + 1] = {
		model = ('models/player/kerry/plats_medic/male_%02i_medic.mdl'):format(i),
		male = true,
		name = 'Тёплая форма ' .. i,
	}
end
for i = 10, 11 do
	medics[#medics + 1] = {
		model = ('models/kerry/plats_medical_%02i.mdl'):format(i),
		male = false,
		name = 'Медик ' .. i,
		bgs = medicBgs,
	}
end
for i = 1, 6 do
	medics[#medics + 1] = {
		model = ('models/player/kerry/plats_medic/female_%02i_medic.mdl'):format(i),
		male = false,
		name = 'Тёплая форма ' .. i,
	}
end

simpleOrgs.addOrg('medic', {
	name = 'Медицинский центр',
	title = 'Работа в медицинском центре',
	shortTitle = 'Работа в мед. центре',
	team = 'paramedic',
	mdls = medics,
	clothes = clothesData,
	talkieFreq = 'ems',
})

carDealer.addCategory('medic', {
	name = 'Медики',
	icon =  octolib.icons.silk16('user_medical'),
	ems = true,
	doNotEvacuate = true,
	canUse = function(ply) return ply:Team() == TEAM_DOCTOR, 'Доступно только медикам' end,
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
	spawnCheck = carDealer.limits.medic,
	limitGroup = 'medic',
})

carDealer.addVeh('medicambulance', {
	category = 'medic',
	name = 'Ambulance',
	simfphysID = 'sim_fphys_gta4_ambulance',
	price = 0,
	deposit = true,
	customFOV = 42,
	default = {
		col = { Color(255,255,255), Color(23,11,192), Color(0,0,0), Color(255,255,255) },
		bg = { [1] = 1 },
	},
	radioWhitelist = carDealer.emsRadioStations,
})

hook.Add('OnPlayerChangedTeam', 'orgs.medic', function(ply, old, new)
	local job = RPExtraTeams[old]
	local mask = ply:GetNetVar('hMask')
	if job and job.medic and mask and mask[1] == 'medical_mask' then
		ply:SetNetVar('hMask', nil)
	end
end)
