--[[
РАНГИ:
cad. Пожарный кадет
tra. Пожарный стажер
ff1. Пожарный I
emt. EMT пожарных
ff2. Пожарный II
prm. Парамедик пожарных
lie. Пожарный лейтенант
cap. Пожарный капитан
bc. Пожарный командир батальона
rchi. Пожарный районный шеф
ass. Помощник заместителя шефа
dep. Заместитель пожарного шефа
chi. Шеф пожарного департамента
]]

local clothesData = {
	icon = 'user_firefighter',
	['models/gta5/fire'] = {
		{
			bodygroup = 1,
			vals = {
				[0] = { 'Надеть шлем', 'bullet_blue', '/me надевает шлем на голову' },
				[1] = { 'Снять шлем', 'cross', '/me снимает шлем с головы' },
			},
		},{
			bodygroup = 2,
			vals = {
				[0] = { 'Снять кислородный баллон', 'cross', '/me снимает кислородный баллон с плеч' },
				[1] = { 'Надеть кислородный баллон', 'bullet_blue', '/me надевает кислородный баллон на плечи' },
			},
		},{
			bodygroup = 3,
			vals = {
				[0] = { 'Снять кислородную маску', 'cross', '/me снимает кислородную маску с лица' },
				[1] = { 'Надеть кислородную маску', 'bullet_blue', '/me надевает кислородную маску на лицо' },
			},
		},
	},
	['models/taggart/police02/'] = {
		{
			bodygroup = 1,
			vals = {
				[0] = { 'Надеть кепку', 'bullet_blue', '/me надевает кепку на голову' },
				[1] = { 'Снять кепку', 'cross', '/me снимает кепку с головы' },
			},
		},
	},
}

local everydayMats = {
	[4] = 'models/taggart/police02/securityguard1',
}

local everydayMats_hq = {
	[4] = 'models/taggart/police02/securityguard2',
}

local firemenBgs = {
	[1] = {
		name = 'Снять шлем',
	},
	[2] = {
		name = 'Газовый баллон',
	},
	[3] = {
		name = 'Маска',
	},
}

local models = {}
for i = 1, 9 do
	models[#models + 1] = {
		name = 'Офисная форма ' .. i,
		model = ('models/taggart/police02/male_%02i.mdl'):format(i),
		unisex = true,
		everyday = true,
		bgs = {
			[1] = {
				name = 'Снять кепку',
			},
		},
	}

	if i > 7 then continue end
	models[#models + 1] = {
		name = 'Пожарный ' .. i,
		model = ('models/gta5/fire%s.mdl'):format(i),
		unisex = true,
		bgs = firemenBgs,
	}
end

simpleOrgs.addOrg('fire', {
	name = 'Пожарный Департамент',
	title = 'Работа в Пожарном Департаменте',
	shortTitle = 'Работа в Департаменте',
	team = 'firefighter',
	clothes = clothesData,
	talkieFreq = 'ems',
	rankOrder = {'cad', 'tra', 'ff1', 'emt', 'ff2', 'prm', 'lie', 'cap', 'bc', 'rchi', 'ass', 'dep', 'chi'},
	multirank = true,
	ranks = {
		cad = { -- Cadet
			shortName = 'Кадет',
			name = 'Пожарный кадет',
			mdls = models,
			everydayMats = everydayMats,
			icon = octolib.icons.silk16('user_firefighter'),
			skin = 2,
		},
		tra = { -- Trainee
			shortName = 'Стажер',
			name = 'Пожарный стажер',
			mdls = models,
			everydayMats = everydayMats,
			icon = octolib.icons.silk16('user_firefighter'),
			skin = 2,
		},
		ff1 = { -- FireFighter I
			shortName = 'Пожарный I',
			name = 'Пожарный I',
			mdls = models,
			everydayMats = everydayMats,
			icon = octolib.icons.silk16('user_firefighter'),
			skin = 0,
		},
		emt = { -- Fire EMT
			shortName = 'EMT',
			name = 'EMT пожарных',
			mdls = models,
			everydayMats = everydayMats,
			icon = octolib.icons.silk16('user_medical'),
			skin = 0,
		},
		ff2 = { -- FireFighter II
			shortName = 'Пожарный II',
			name = 'Пожарный II',
			mdls = models,
			everydayMats = everydayMats,
			icon = octolib.icons.silk16('user_firefighter'),
			skin = 0,
		},
		prm = { -- Paramedic
			shortName = 'Парамедик',
			name = 'Парамедик пожарных',
			mdls = models,
			everydayMats = everydayMats,
			icon = octolib.icons.silk16('user_medical'),
			skin = 0,
		},
		lie = { -- Lieutenant
			shortName = 'Лейтенант',
			name = 'Пожарный лейтенант',
			mdls = models,
			everydayMats = everydayMats_hq,
			icon = octolib.icons.silk16('user_firefighter'),
			skin = 1,
		},
		cap = { -- Captain
			shortName = 'Капитан',
			name = 'Пожарный капитан',
			mdls = models,
			everydayMats = everydayMats_hq,
			icon = octolib.icons.silk16('user_firefighter'),
			skin = 1,
		},
		bc = { -- Battalion Commander
			shortName = 'Шеф батальона',
			name = 'Пожарный шеф батальона',
			mdls = models,
			icon = octolib.icons.silk16('user_firefighter'),
			skin = 3,
		},
		rchi = { -- District Chief
			shortName = 'Районный шеф',
			name = 'Пожарный районный шеф',
			mdls = models,
			icon = octolib.icons.silk16('user_firefighter'),
			skin = 3,
		},
		ass = { -- Assistant Chief
			shortName = 'Помощник заместителя шефа',
			name = 'Помощник заместителя шефа',
			mdls = models,
			icon = octolib.icons.silk16('lightning'),
			skin = 3,
		},
		dep = { -- Deputy Chief
			shortName = 'Заместитель пожарного шефа',
			name = 'Заместитель пожарного шефа',
			mdls = models,
			icon = octolib.icons.silk16('user_firefighter'),
			skin = 3,
		},
		chi = { -- Chief
			shortName = 'Шеф',
			name = 'Шеф пожарного департамента',
			mdls = models,
			icon = octolib.icons.silk16('user_firefighter'),
			skin = 3,
		},
	},
})

-- fuck that shit
local toChange = octolib.array.toKeys({'male_02.mdl','male_05.mdl','male_06.mdl','male_07.mdl','male_08.mdl'})
hook.Add('EntitySubMaterialChange', 'dbg-orgs.fire', function(ent, index, mat)
 	local mdl = ent:GetModel()
	if not mdl:find('taggart/police02') or not toChange[mdl:gsub('.+%/', '')] then return end
	if index == 4 then ent:SetSubMaterial(5, mat) return true end
end)