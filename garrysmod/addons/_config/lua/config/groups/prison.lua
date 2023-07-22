local clothesData = {
	icon = 'user_police_england',
	['models/player/octo_guard/'] = {
		{
			bodygroup = 2,
			vals = {
				[0] = { 'Снять бронежилет', 'cross', '/me снимает бронежилет' },
				[1] = { 'Надеть бронежилет', 'bullet_blue', '/me надевает бронежилет на тело' },
			},
		},{
			bodygroup = 3,
			vals = {
				[0] = { 'Снять шлем', 'cross', '/me снимает шлем с головы' },
				[1] = { 'Надеть шлем', 'bullet_blue', '/me надевает шлем на голову' },
			},
		},
	},
}

local maleBgs = {
	[1] = {
		name = 'Звание',
		vals = {
			{'Нет', 4},
			{'Офицер I', 0},
			{'Офицер II', 1},
			{'Офицер III', 2},
			{'Сержант', 3},
		},
	},
	[2] = {
		name = 'Бронежилет',
	},
	[3] = {
		name = 'Шлем',
	},
	[4] = {
		name = 'Короткие рукава',
	},
}

local femaleBgs = {
	[1] = {
		name = 'Звание',
		vals = {
			{'Нет', 4},
			{'Офицер I', 0},
			{'Офицер II', 1},
			{'Офицер III', 2},
			{'Сержант', 3},
		},
	},
	[2] = {
		name = 'Бронежилет',
	},
	[3] = {
		name = 'Шлем',
	},
}

local models = {}
for i = 1, 9 do
	models[#models + 1] = {
		name = 'Форма ' .. i,
		male = true,
		model = ('models/player/octo_guard/male_%02i.mdl'):format(i),
		bgs = maleBgs,
	}
	if i >= 7 then continue end
	models[#models + 1] = {
		name = 'Форма ' .. i,
		male = false,
		model = ('models/player/octo_guard/female_%02i.mdl'):format(i),
		bgs = femaleBgs,
	}
end

simpleOrgs.addOrg('prison', {
	name = 'Тюрьма',
	title = 'Тюрьма',
	shortTitle = 'Тюрьма',
	team = 'prison',
	mdls = models,
	clothes = clothesData,
	talkieFreq = 'prison',
})

local ply = FindMetaTable 'Player'
function ply:SetPrisonClothes(val)
	if self:IsMale() then
		if val then
			local mat = 'models/humans/modern/octo/prisoner1_sheet'
			for i, original in ipairs(self:GetMaterials()) do
				if string.match(original, '.+/sheet_%d+') then
					self:SetSubMaterial(i - 1, mat)
				end
			end
		else
			local clothes = self:GetDBVar('customClothes') or nil
			self:SetClothes(clothes)
		end
	end
end

local spawns = table.Copy(carDealer.policeSpawns)
spawns['rp_riverden_dbg_220313'] = {
	{ Vector(11254, -10915, 820), Angle(0, 0, 0) },
	{ Vector(11254, -11105, 820), Angle(0, 0, 0) },
	{ Vector(11254, -11295, 820), Angle(0, 0, 0) },
	{ Vector(11254, -11485, 820), Angle(0, 0, 0) },
	{ Vector(11254, -12010, 820), Angle(0, 0, 0) },
	{ Vector(11254, -12220, 820), Angle(0, 0, 0) },
	{ Vector(11254, -12430, 820), Angle(0, 0, 0) },
	{ Vector(11254, -12640, 820), Angle(0, 0, 0) },
}


carDealer.addCategory('prison', {
	name = 'Тюрьма',
	icon = octolib.icons.silk16('user_police_england'),
	canUse = function(ply) return ply:Team() == TEAM_PRISON, 'Доступно только сотрудникам тюрьмы' end,
	spawns = spawns,
	spawnCheck =  carDealer.limitedSpawn(1, 'prison', 'В городе уже есть тюремный транспорт'),
	limitGroup = 'prison',
})

carDealer.addVeh('prison-bus', {
	name = 'Автобус',
	simfphysID = 'sim_fphys_tlad_pbus',
	price = 0,
	deposit = true,
	customFOV = 42,
	default = {
		col = { Color(63,79,127), Color(255,255,255), Color(0,0,0), Color(255,255,255) },
	},
	radioWhitelist = carDealer.emsRadioStations,
})

carDealer.addVeh('prison-bobcat', {
	name = 'Bobcat',
	simfphysID = 'sim_fphys_gta4_bobcat',
	price = 0,
	deposit = true,
	default = {
		col = { Color(71,75,78), Color(255,255,255), Color(0,0,0), Color(255,255,255) },
	},
})
