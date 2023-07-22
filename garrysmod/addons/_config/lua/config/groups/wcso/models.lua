local clothesData = {
	icon = 'sheriff',
	['models/player/octo_sheriff/'] = {
		{
			sm = 'Головной убор',
			icon = 'hat',
			bodygroup = 3,
			vals = {
				[0] = { 'Надеть шляпу', 'bullet_blue', '/me надевает шляпу на голову' },
				[1] = { 'Надеть шлем', 'bullet_black', '/me надевает шлем на голову' },
				[2] = { 'Снять убор', 'cross', '/me снимает головной убор' },
			},
		},{
			sm = 'Перчатки',
			icon = 'hand',
			bodygroup = 6,
			vals = {
				[0] = { 'Снять', 'cross', '/me снимает перчатки' },
				[1] = { 'Надеть черные перчатки', 'bullet_black', '/me надевает черные перчатки' },
				[2] = { 'Надеть белые перчатки', 'bullet_white', '/me надевает белые перчатки' },
			},
		},{
			sm = 'Кобура тазера',
			icon = 'gun',
			bodygroup = 2,
			vals = {
				[0] = { 'Надеть кобуру тазера слева', 'arrow_left', '/me надевает кобуру с тазером слева' },
				[1] = { 'Надеть кобуру тазера справа', 'arrow_right', '/me надевает кобуру с тазером справа' },
				[2] = { 'Снять кобуру с тазером', 'cross', '/me снимает шлем с головы' },
			},
		},{
			bodygroup = 7,
			vals = {
				[0] = { 'Надеть рацию', 'bullet_blue', '/me надевает рацию себе на грудь' },
				[1] = { 'Снять рацию', 'cross', '/me снимает рацию с груди' },
			},
		},{
			bodygroup = 5,
			vals = {
				[0] = { 'Надеть дубинку', 'bullet_blue', '/me вешает дубинку обратно на пояс' },
				[1] = { 'Снять дубинку', 'cross', '/me снимает дубинку с пояса' },
			},
		},{
			bodygroup = 4,
			vals = {
				[0] = { 'Надеть галстук', 'bullet_blue', '/me надевает галстук себе на шею, плотно его затягивая' },
				[1] = { 'Снять галстук', 'cross', '/me снимает галстук, расслабяя воротник' },
			},
		},
	},
	['models/player/octo_swat_team/'] = {
		{
			bodygroup = 1,
			vals = {
				[0] = { 'Надеть бронежилет с разгрузками', 'bullet_blue', '/me надевает бронежилет на тело' },
				[1] = { 'Снять бронежилет с разгрузками', 'cross', '/me снимает бронежилет с груди' },
			},
		},{
			bodygroup = 2,
			vals = {
				[0] = { 'Снарядить низ', 'bullet_blue', '/me нацепляет снаряжения на ноги' },
				[1] = { 'Снять всё с ног', 'cross', '/me снимает все снаряжение с ног' },
			},
		},{
			bodygroup = 3,
			vals = {
				[0] = { 'Распрямить рукава', 'arrow_down', '/me распрямляет рукава' },
				[1] = { 'Засучить рукава', 'arrow_up', '/me засучивает рукава' },
			},
		},{
			bodygroup = 4,
			vals = {
				[0] = { 'Снять перчатки', 'cross', '/me снимает тактические перчатки с рук' },
				[1] = { 'Надеть перчатки', 'bullet_blue', '/me надевает перчатки на руки' },
			},
		},{
			bodygroup = 5,
			vals = {
				[0] = { 'Снять часы', 'cross', '/me снимает часы с рук' },
				[1] = { 'Надеть часы', 'bullet_blue', '/me застегивает часы на руке' },
			},
		},{
			bodygroup = 9,
			vals = {
				[0] = { 'Надеть шлем', 'bullet_blue', '/me надевает шлем на голову' },
				[1] = { 'Снять шлем', 'cross', '/me снимает шлем с головы' },
			},
		},{
			bodygroup = 10,
			vals = {
				[0] = { 'Надеть наушники', 'bullet_blue', '/me надевает наушники' },
				[1] = { 'Снять наушники', 'cross', '/me снимает наушники' },
			},
		},{
			bodygroup = 11,
			vals = {
				[0] = { 'Надеть прозрачные очки', 'bullet_white', '/me надевает прозрачные тактические очки на глаза' },
				[1] = { 'Надеть затемненные очки', 'bullet_black', '/me надевает затемненные тактические очки на глаза' },
				[2] = { 'Снять очки', 'cross', '/me снимает тактические очки с глаз' },
			},
		},{
			bodygroup = 12,
			vals = {
				[0] = { 'Надеть камеру на шлем', 'bullet_blue', '/me надевает камеру на шлем' },
				[1] = { 'Снять камеру со шлема', 'cross', '/me снимает камеру со шлема' },
			},
		},
	},
}

local wcsoBgs = {
	[1] = {
		name = 'Внешний бронежилет',
	},
	[2] = {
		name = 'Тазер',
		vals = {
			{ 'Слева', 0, true },
			{ 'Справа', 1 },
			{ 'Снять', 2 },
		},
	},
	[3] = {
		name = 'Головной убор',
		vals = {
			{ 'Шляпа', 0, true },
			{ 'Шлем', 1 },
			{ 'Снять', 2 },
		},
	},
	[4] = {
		name = 'Форма',
		vals = {
			{ 'Строгая', 0, true },
			{ 'Повседневная', 1 },
			{ 'Легкая', 2 },
		},
	},
	[5] = {
		name = 'Снять дубинку',
	},
	[6] = {
		name = 'Перчатки',
		vals = {
			{ 'Без перчаток', 0, true },
			{ 'Черные', 1 },
			{ 'Белые', 2 },
		},
	},
	[7] = {
		name = 'Снять рацию',
	},
}

local mdls = {}
for i, v in ipairs({1, 2, 3, 4, 5, 6, 8, 9}) do
	mdls[#mdls + 1] = {
		name = '%s ' .. i,
		model = ('models/player/octo_sheriff/male_%02i.mdl'):format(v),
		unisex = true,
		bgs = wcsoBgs,
	}
end

local sebNames = {
	{'Westbrook', 0},
	{'Sandstorm', 1},
	{'Moore', 2},
	{'Miller', 3},
	{'Bartels', 4},
	{'Marler', 5},
	{'Mckenney', 6},
	{'Rain', 7},
	{'Thompson', 8},
	{'Rose', 9},
	{'Cramble', 10},
	{'Phillips', 11},
	{'Nelson', 12},
	{'Anderson', 13},
	{'Kertis', 14},
	{'Campbell', 15},
	{'Bradley', 16},
	{'Archuleta', 17},
	{'Murphy', 18},
	{'Rumberger', 19},
	{'Ter Stegen', 20},
	{'Gvidichi', 21},
	{'Coleman', 22},
	{'Без имени', 26},
}

local sebBgs = {
	[7] = {
		name = 'Позывной',
		vals = sebNames,
	},
	[13] = {
		name = 'Патч на шлеме',
		vals = {
			{'Без патча', 0},
			{'Патч "Punisher Thin Blue Line"', 1},
			{'Патч 715 Team', 2},
			{'Патч "Bang one, bang em\' all"', 3},
			{'Патч "My idea of help"', 4},
			{'Патч "Respect all, fear none', 5},
		},
	},
	[11] = {
		name = 'Очки',
		vals = {
			{'Прозрачные очки', 0},
			{'Затемненные очки', 1},
			{'Без очков', 2},
		},
	},
	[1] = {
		name = 'Стандартный вверх',
	},
	[2] = {
		name = 'Стандартный низ',
	},
	[3] = {
		name = 'Засученные рукава',
	},
	[4] = {
		name = 'Тактические перчатки',
	},
	[5] = {
		name = 'Часы',
	},
	[6] = {
		name = 'Медицинский патч на разгрузку',
	},
	[9] = {
		name = 'Снять шлем',
	},
	[10] = {
		name = 'Снять наушники',
	},
	[12] = {
		name = 'Снять камеру на шлеме',
	},
}

local sebMdls = {}
local skins = {[1] = 2, [2] = 2, [3] = 6, [4] = 3, [5] = 4, [6] = 4, [7] = 5, [8] = 4, [9] = 3}
for i = 1, 9 do
	sebMdls[#sebMdls + 1] = {
		name = 'Форма ' .. i,
		male = true,
		model = ('models/player/octo_swat_team/male_%02i.mdl'):format(i),
		bgs = sebBgs,
		requiredMats = {
			[4] = 'models/octo_swat_team/body_01_seb',
			[5] = 'models/octo_swat_team/armor_seb',
			[6] = 'models/octo_swat_team/patch_seb',
			[7] = 'models/octo_swat_team/lowr_01_seb',
			[11] = 'models/octo_swat_team/hlem_seb',
		},
		skin = {
			name = 'Внешность',
			vals = {},
		},
	}

	for n = 0, skins[i] do
		sebMdls[i].skin.vals[#sebMdls[i].skin.vals + 1] = { 'Внешность ' .. (n + 1), n }
	end

end

table.Add(sebMdls, mdls)

simpleOrgs.addOrg('wcso', {
	name = 'Офис Шерифа',
	title = 'Работа в Офисе Шерифа',
	shortTitle = 'Работа в WCSO',
	team = 'wcso',
	police = true,
	talkieFreq = 'ems',
	clothes = clothesData,
	rankOrder = { 'cad', 'ins', 'ds1', 'ds2', 'crp', 'srg', 'lie', 'cap', 'ass', 'she', 'seb' },
	multirank = true,
	ranks = {
		cad = { -- Cadet
			shortName = 'Кадет',
			name = 'Кадет офиса Шерифа',
			mdls = mdls,
			icon = octolib.icons.silk16('sheriff'),
			weps = { 'weapon_octo_air_glock17', 'weapon_octo_air_m4a1', 'weapon_octo_air_m3' },
			skin = 0,
		},
		ins = { -- Instructor
			shortName = 'Инструктор',
			name = 'Инструктор офиса Шерифа',
			mdls = mdls,
			icon = octolib.icons.silk16('sheriff'),
			weps = { 'weapon_octo_air_glock17', 'weapon_octo_air_m4a1', 'weapon_octo_air_m3' },
			skin = 3,
		},
		ds1 = { -- Deputy Sheriff I
			shortName = 'Помощник Шерифа I',
			name = 'Помощник Шерифа I',
			mdls = mdls,
			icon = octolib.icons.silk16('sheriff'),
			skin = 0,
		},
		ds2 = { -- Deputy Sheriff II
			shortName = 'Помощник Шерифа II',
			name = 'Помощник Шерифа II',
			mdls = mdls,
			icon = octolib.icons.silk16('sheriff'),
			skin = 1,
		},
		crp = { -- Corporal
			shortName = 'Капрал',
			name = 'Капрал офиса Шерифа',
			mdls = mdls,
			icon = octolib.icons.silk16('sheriff'),
			skin = 2,
		},
		srg = { -- Sergeant
			shortName = 'Сержант',
			name = 'Сержант офиса Шерифа',
			mdls = mdls,
			icon = octolib.icons.silk16('sheriff'),
			skin = 3,
		},
		lie = { -- Lieutenant
			shortName = 'Лейтенант',
			name = 'Лейтенант офиса Шерифа',
			mdls = mdls,
			icon = octolib.icons.silk16('sheriff'),
			skin = 4,
		},
		cap = { -- Captain
			shortName = 'Капитан',
			name = 'Капитан офиса Шерифа',
			mdls = mdls,
			icon = octolib.icons.silk16('sheriff'),
			skin = 5,
		},
		ass = { -- Assistant Sheriff
			shortName = 'Ассистент Шерифа',
			name = 'Ассистент Шерифа',
			mdls = mdls,
			icon = octolib.icons.silk16('sheriff'),
			skin = 6,
		},
		she = { -- Sheriff
			shortName = 'Шериф',
			name = 'Шериф',
			mdls = mdls,
			icon = octolib.icons.silk16('sheriff'),
			skin = 7,
		},

		seb = { -- S. E. B.
			shortName = 'Оператор S.E.B.',
			name = 'Оператор S.E.B.',
			armor = 100,
			mdls = sebMdls,
			icon = octolib.icons.silk16('lightning'),
			weps = {'weapon_octo_m4a1', 'weapon_octo_usps', 'weapon_octo_xm1014', 'weapon_octo_sg550', 'weapon_octo_beanbag', 'weapon_octo_p90', 'weapon_octo_tmp', 'door_ram', 'dbg_shield'},
			excludeWeps = {'weapon_octo_glock17', 'dbg_speedometer'},
		},
	}
})

netstream.Hook('wcso.gloves', function(ply, val)
	if not (ply:GetActiveRank('wcso') and octolib.math.inRange(val, 0, 2)) then return end
	ply:SetBodygroup(6, val)
end)
