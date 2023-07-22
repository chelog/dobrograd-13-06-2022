--[[
РАНГИ:
-- all
cad. Кадет
ppo. Стажер
po. Офицер
spo. Старший офицер
swat. Оперативник S.W.A.T.
dec1. Детектив I квалификации
dec2. Детектив II квалификации
dec3. Детектив III квалификации
lie. Лейтенант
cap. Капитан
cmd. Командующий
asch. Помощник заместителя шефа
asc. Заместитель шефа
chi. Шеф департамента
]]

local function addAll(...)
	local result = {}
	for _, tbl in ipairs({...}) do
		for _, v in ipairs(tbl) do
			result[#result + 1] = table.Copy(v)
		end
	end
	return result
end

local function addBgs(source, bgs)
	local result = table.Copy(source)
	for _, mdl in ipairs(result) do
		mdl.bgs = mdl.bgs or {}
		for k, v in pairs(bgs) do
			mdl.bgs[k] = v
		end
	end
	return result
end

local function addRequiredBgs(source, bgs)
	local result = table.Copy(source)
	for _, mdl in ipairs(result) do
		mdl.requiredBgs = mdl.requiredBgs or {}
		for k, v in pairs(bgs) do
			mdl.requiredBgs[k] = v
		end
	end
	return result
end

local function removeBgs(source, ...) -- in honor of kilo-7
	local result = table.Copy(source)
	for _, mdl in ipairs(result) do
		if not mdl.bgs then continue end
		for _, bg in ipairs({...}) do
			mdl.bgs[bg] = nil
		end
		if not next(mdl.bgs) then mdl.bgs = nil end
	end
	return result
end

local function modify(source, modify)
	local result = table.Copy(source)
	for _, mdl in ipairs(result) do
		for k, v in pairs(modify) do
			mdl[k] = v
		end
	end
	return result
end

local patrolModels, utilityModels, everydayModels, swatModels, decModels = {}, {}, {}, {}, {}

local patrolClothes = {
	{
		bodygroup = 3,
		vals = {
			[0] = { 'Снять бронежилет', 'cross', '/me снимает бронежилет с себя' },
			[1] = { 'Надеть бронежилет', 'bullet_blue', '/me надевает бронежилет на свое тело' },
		},
	},{
		bodygroup = 4,
		vals = {
			[0] = { 'Снять головной убор', 'cross', '/me снимает головной убор' },
			[1] = { 'Надеть кепку на голову', 'bullet_blue', '/me надевает кепку на свою голову' },
			[2] = { 'Надеть фуражку на голову', 'bullet_black', '/me надевает фуражку на свою голову' },
		},
	},
}

local malePatrolClothes = {
	{
		sm = 'Головной убор',
		icon = 'hat',
		bodygroup = 2,
		vals = {
			[0] = { 'Снять убор', 'cross', '/me снимает головной убор' },
			[1] = { 'Надеть фуражку', 'bullet_white', '/me надевает фуражку' },
			[2] = { 'Надеть кепку', 'bullet_blue', '/me надевает кепку' },
			[3] = { 'Надеть шапку', 'bullet_black', '/me надевает шапку' },
		}
	}, {
		sm = 'Перчатки',
		icon = 'hand',
		bodygroup = 6,
		vals = {
			[0] = { 'Снять', 'cross', '/me снимает перчатки' },
			[1] = { 'Надеть черные перчатки', 'bullet_black', '/me надевает черные перчатки' },
			[2] = { 'Надеть белые перчатки', 'bullet_white', '/me надевает белые перчатки' },
			[3] = { 'Надеть голубые нитриловые перчатки', 'bullet_blue', '/me надевает голубые нитриловые перчатки' },
		},
	}, {
		bodygroup = 8,
		vals = {
			[0] = { 'Снять жилет', 'cross', '/me снимает жилет с себя' },
			[1] = { 'Надеть бронежилет', 'shield', '/me надевает бронежилет на свое тело' },
			[2] = { 'Надеть светоотражающий жилет', 'life_vest', '/me надевает светоотражающий жилет на свое тело' },
		},
	}
}

local clothesData = {
	icon = 'user_policeman_white',
	['models/player/octo_dpd/male'] = malePatrolClothes,
	['models/humans/dpdfem/female'] = patrolClothes,
	['models/dpdac/male_'] = {
		{
			sm = 'Тактический пояс',
			icon = 'gun',
			bodygroup = 3,
			vals = {
				[0] = { 'Снять тактический пояс', 'cross', '/me снимает головной убор' },
				[1] = { 'Надеть пустой тактический пояс', 'bullet_black', '/me надевает пустой тактический пояс' },
				[2] = { 'Надеть пустой тактический пояс со значком', 'bullet_blue', '/me надевает пустой тактический пояс, вешая на него значок' },
				[3] = { 'Надеть тактический пояс с пистолетом', 'bullet_red', '/me надевает снаряженный тактический пояс' },
				[4] = { 'Надеть тактический пояс с пистолетом и значком', 'bullet_green', '/me надевает снаряженный тактический пояс, вешая на него значок' },
			},
		},{
			bodygroup = 4,
			vals = {
				[0] = { 'Снять бронежилет', 'cross', '/me снимает бронежилет' },
				[1] = { 'Надеть бронежилет', 'bullet_blue', '/me надевает бронежилет на свое тело' },
			},
		},{
			bodygroup = 5,
			vals = {
				[0] = { 'Снять кепку', 'bullet_blue', '/me снимает кепку с головы' },
				[1] = { 'Надеть кепку', 'cross', '/me надевает кепку на голову' },
			},
		},{
			bodygroup = 6,
			vals = {
				[0] = { 'Снять очки', 'bullet_blue', '/me снимает защитные очки с глаз' },
				[1] = { 'Надеть очки', 'cross', '/me надевает защитные очки' },
			},
		}
	},
	['models/humans/dpdfeminv/female_'] = {
		{
			bodygroup = 4,
			vals = {
				[0] = { 'Снять кепку', 'cross', '/me снимает кепку с головы' },
				[1] = { 'Надеть кепку', 'bullet_blue', '/me надевает кепку на голову, поправляя её' },
			},
		},{
			bodygroup = 5,
			vals = {
				[0] = { 'Снять очки', 'cross', '/me снимает защитные очки с глаз' },
				[1] = { 'Надеть очки', 'bullet_blue', '/me надевает защитные очки' },
			},
		},
	},
	['models/kerry/detective_dbg/male_'] = {
		{
			bodygroup = 1,
			vals = {
				[0] = { 'Снарядить полностью пояс', 'cross', '/me полностью снаряжает тактический пояс' },
				[1] = { 'Оставить на поясе только фонарик и табель', 'bullet_blue', '/me снимает с тактического пояса всё, кроме фонарика и табельного оружия' },
				[2] = { 'Оставить на поясе только фонарик', 'bullet_green', '/me снимает с тактического пояса всё, кроме фонарика' },
			},
		}
	},
	['models/dizcordum/citizens/playermodels/'] = {
		{
			bodygroup = 3,
			vals = {
				[0] = { 'Снять перчатки', 'cross', '/me снимает перчатки с рук' },
				[1] = { 'Надеть перчатки', 'bullet_blue', '/me надевает перчатки на руки' },
			},
		},
	},
	['models/player/octo_swat_team/'] = {
		{
			bodygroup = 1,
			vals = {
				[0] = { 'Надеть бронежилет с разгрузками', 'bullet_blue', '/me надевает бронежилет на тело' },
				[1] = { 'Снять бронежилет с разгрузками', 'cross', '/me снимает бронежилет' },
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

local everyday_maleBgs = {
	[3] = {
		name = 'Тактический пояс',
		vals = {
			{'Нет', 0},
			{'Пустой', 1},
			{'Со значком без пистолета', 2},
			{'Без значка и с пистолетом', 3},
			{'Со значком и с пистолетом', 4},
		},
	},
	[4] = {
		name = 'Бронежилет',
	},
	[5] = {
		name = 'Головной убор',
	},
	[6] = {
		name = 'Очки',
	},
}

local everyday_femaleBgs = {
	[4] = {
		name = 'Головной убор',
	},
	[5] = {
		name = 'Очки',
	},
}

local patrolBgs_hatAll = {
	[3] = {
		name = 'Бронежилет',
	},
	[4] = {
		name = 'Головной убор',
		vals = {
			{'Нет', 0},
			{'Кепка', 1},
			{'Фуражка', 2},
		},
	}
}

local utilityBgs = {
	[1] = {
		name = 'Верхняя одежда',
		vals = {
			{'Утилитарная с длинным рукавом', 5},
			{'Утилитарная с коротким рукавом', 7},
		},
	},
	[2] = {
		name = 'Головной убор',
		vals = {
			{'Нет', 0},
			{'Фуражка', 1},
			{'Кепка', 2},
			{'Шапка', 3},
		},
	},
	[5] = {
		name = 'Снять бодикамеру',
	},
	[6] = {
		name = 'Перчатки',
		vals = {
			{'Нет', 0},
			{'Черные', 1},
			{'Белые', 2},
			{'Голубые нитриловые', 3},
		},
	},
	[8] = {
		name = 'Жилет',
		vals = {
			{'Нет', 0},
			{'Бронежилет', 1},
			{'Светоотражающий жилет', 2},
		},
	},
}
local utilityBgs_req = {[3] = 1, [7] = 1}

local patrolBgs_hatAll_male = {
	[1] = {
		name = 'Верхняя одежда',
		vals = {
			{'Рубашка с галстуком', 0},
			{'Рубашка с длинным рукавом', 1},
			{'Рубашка с коротким рукавом', 2},
			{'Легкая куртка', 3},
			{'Зимняя куртка', 4},
		},
	},
	[2] = {
		name = 'Головной убор',
		vals = {
			{'Нет', 0},
			{'Фуражка', 1},
			{'Кепка', 2},
			{'Шапка', 3},
		},
	},
	[3] = {
		name = 'Тактический пояс',
	},
	[5] = {
		name = 'Снять бодикамеру',
	},
	[6] = {
		name = 'Перчатки',
		vals = {
			{'Нет', 0},
			{'Черные', 1},
			{'Белые', 2},
			{'Голубые нитриловые', 3},
		},
	},
	[8] = {
		name = 'Жилет',
		vals = {
			{'Нет', 0},
			{'Бронежилет', 1},
			{'Светоотражающий жилет', 2},
		},
	},
}

local swatNames = {
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
	{'Brown', 13},
	{'Jenkins', 14},
	{'Grace', 15},
	{'Campbell', 16},
	{'Hicks', 17},
	{'Ryan', 18},
	{'Hardy', 19},
	{'Krawler', 20},
	{'Shearman', 22},
	{'Stewart', 23},
	{'Campo', 24},
	{'Без имени', 26},
}

local swatBgs = {
	[7] = {
		name = 'Позывной',
		vals = swatNames,
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

local swatSubMats = {
	[4] = {
		name = 'Цвет формы',
		vals = {
			{'Обычный', 'models/octo_swat_team/body_01'},
            {'Черный', 'models/octo_swat_team/body_01_black'},
		},
	},
	[5] = {
		name = 'Цвет бронежилета',
		vals = {
			{'Обычный', 'models/octo_swat_team/armor'},
			{'Черный', 'models/octo_swat_team/armor_black'},
		},
	},
	[6] = {
		name = 'Цвет нашивок',
		vals = {
			{'Обычный', 'models/octo_swat_team/patch'},
			{'Черный', 'models/octo_swat_team/patch_black'},
		},
	},
	[7] = {
		name = 'Цвет штанов',
		vals = {
			{'Обычный', 'models/octo_swat_team/lowr_01'},
			{'Черный', 'models/octo_swat_team/lowr_01_black'},
		}
	}
}

local decBgs = {
	[1] = {
		name = 'Пояс',
		vals = {
			{'Полное вооружение', 0},
			{'Только фонарик и табель', 1},
			{'Только фонарик', 2},
		},
	},

	[2] = {
		name = 'Защита',
		vals = {
			{'Бронежилет детектива', 0},
			{'Бронежилет инспектора', 1},
			{'Бейдж инспектора', 2},
			{'Бейдж детектива', 3},
		}
	},

	[3] = {
		name = 'Значок',
		vals = {
			{'Значок детектива', 0},
			{'Значок инспектора', 1},
			{'Нет', 2},
		}
	},
}
local decSkin = {
	name = 'Одежда',
	vals = {
		{'Серая рубашка, черные брюки', 0},
		{'Черная рубашка, зеленые брюки', 1},
		{'Серая рубашка, синие брюки', 2},
		{'Серая рубашка, желтые брюки', 3},
		{'Голубая рубашка, черные брюки', 4},
	}
}
local civilSkins = {
	name = 'Одежда',
	vals = {
		{'Коричневый пиджачок', 0},
		{'Синяя клетчатая рубашка с белыми рукавами', 2},
		{'Темно-синяя кофта с белыми рукавами', 3},
		{'Серый мешок, измазан дерьмом, джинсы тоже', 4},
		{'Красная рубашка с белыми рукавами, коричневые джинсы', 5},
		{'Бежевая кофта с логотипом, черные брюки', 6},
		{'Черная куртка с логотипом скелета, бежевые брюки', 7},
		{'Оранжевая рубашка с узором "Такси" и белыми рукавами, темные джинсы', 8},
		{'Черная кофта с белыми рукавами и перчатками', 9},
		{'Черная кофта с логотипом, перчатки', 10},
		{'Серая кофта в зеленую полоску и белыми рукавами', 11},
		{'Красная кофта, бежевые джинсы', 12},
		{'Черная куртка, белая майка, серые джинсы', 13},
		{'Зеленая кофта, светлые брюки', 14},
		{'Черная куртка, серая майка, светлые брюки', 15},
		{'Красная клетчатая рубашка с черными рукавами и перчатками', 16},
		{'Синяя спортивка', 17},
		{'Черная куртка, черная рубашка', 18},
		{'Салатовая куртка, белая майка, светлые брюки', 19},
		{'Синяя куртка, салатовая майка, рваные джинсы', 20},
		{'Черный пиджак, бежевая кофта, салатовая майка, светлые брюки', 21},
		{'Зеленая куртка, бордовая кофта, светлые брюки', 22},
		{'Синяя кофта в белую полоску и белыми рукавами', 23},
	}
}

local dizcordumMale = {
	[1] = {
		name = 'Верх',
		vals = {
			{'Куртка болотного цвета', 0},
			{'Серая куртка, клетчатая рубашка', 1},
			{'Серая куртка, серая кофта с капюшоном', 2},
			{'Серо-синяя куртка, клетчатая рубашка, синий шарф', 3},
			{'Черно-бирюзовая куртка, рубашка в полоску, красный шарф', 4},
			{'Черно-красная куртка, серый свитер, синий шарф', 5},
			{'Серо-синяя куртка с воротником', 6},
			{'Черно-бирюзовая куртка с воротником', 7},
			{'Черно-красная куртка с воротником', 8},
		},
	},

	[2] = {
		name = 'Низ',
		vals = {
			{'Синие джинсы', 0},
			{'Темно-синие джинсы', 1},
			{'Серые джинсы', 2},
			{'Синие свободные джинсы', 3},
			{'Темные свободные джинсы', 4},
			{'Серые болоневые штаны', 5},
			{'Синие болоневые штаны', 6},
			{'Серые рабочие брюки', 7},
			{'Камуфляжные рабочие брюки', 8},
		},
	},

	[3] = {
		name = 'Перчатки',
	},
}

local dizcordumFemale = {
	[1] = {
		name = 'Верх',
		vals = {
			{'Куртка болотного цвета', 0},
			{'Бирюзовая куртка, расстегнута', 1},
			{'Бирюзовая куртка, застегнута', 5},
			{'Синяя куртка, расстегнута', 2},
			{'Синяя куртка, застегнута', 4},
			{'Красная куртка, расстегнута', 3},
			{'Красная куртка, застегнута', 6},
		},
	},

	[2] = {
		name = 'Низ',
		vals = {
			{'Синие джинсы + Ботинки', 0},
			{'Брюки + Сапоги', 1},
			{'Штаны с полоской + Ботинки', 2},
			{'Синие испачканные штаны + Ботинки', 3},
			{'Серые испачканные штаны + Ботинки', 4},
			{'Серые болоневые штаны', 5},
			{'Светлые болоневые штаны', 6},
			{'Серые рабочие брюки', 7},
		},
	},

	[3] = {
		name = 'Перчатки'
	},
}

for i = 1, 9 do
	patrolModels[#patrolModels + 1] = {
		name = '%s ' .. i,
		male = true,
		model = ('models/player/octo_dpd/male_%02i.mdl'):format(i),
		bgs = patrolBgs_hatAll_male,
	}
end
for i = 1, 9 do
	utilityModels[#utilityModels + 1] = {
		name = '%s (утилитарная) ' .. i,
		male = true,
		model = ('models/player/octo_dpd/male_%02i.mdl'):format(i),
		bgs = utilityBgs,
		requiredBgs = utilityBgs_req,
	}
end

local skins = {[1] = 2, [2] = 2, [3] = 6, [4] = 3, [5] = 4, [6] = 4, [7] = 5, [8] = 4, [9] = 3}
for i = 1, 9 do

	everydayModels[#everydayModels + 1] = {
		name = 'Повседневная форма ' .. i,
		model = ('models/dpdac/male_%02i_01.mdl'):format(i),
		male = true,
		bgs = everyday_maleBgs,
		everyday = true,
	}
	decModels[#decModels + 1] = {
		name = 'Детектив ' .. i,
		model = ('models/kerry/detective_dbg/male_%02i.mdl'):format(i),
		male = true,
		bgs = decBgs,
		skin = decSkin,
	}
	swatModels[#swatModels + 1] = {
		name = 'Форма ' .. i,
		male = true,
		model = ('models/player/octo_swat_team/male_%02i.mdl'):format(i),
		bgs = swatBgs,
		skin = {
			name = 'Внешность',
			vals = {},
		},
		subMaterials = swatSubMats,
	}

	for n = 0, skins[i] do
		swatModels[i].skin.vals[#swatModels[i].skin.vals + 1] = { 'Внешность ' .. (n + 1), n }
	end

end

for num, i in ipairs({ 1, 2, 3, 4, 6, 7 }) do
	patrolModels[#patrolModels + 1] = {
		name = '%s ' .. num,
		male = false,
		model = ('models/humans/dpdfem/female_%02i.mdl'):format(i),
		bgs = patrolBgs_hatAll,
	}
	everydayModels[#everydayModels + 1] = {
		name = 'Повседневная форма ' .. num,
		model = ('models/humans/dpdfeminv/female_%02i.mdl'):format(i),
		male = false,
		bgs = everyday_femaleBgs,
		everyday = true,
	}
	decModels[#decModels + 1] = {
		name = 'Детектив ' .. num,
		model = ('models/humans/dpdfeminv/female_%02i.mdl'):format(i),
		male = false,
		bgs = {
			[4] = {
				name = 'Головной убор',
			},
			[5] = {
				name = 'Очки',
			},
		},
		requiredSkin = 4,
	}
end

for num, i in ipairs({1, 2, 4, 6}) do
	decModels[#decModels + 1] = {
		name = 'Офисный работник ' .. num,
		model = ('models/humans/dpdfemsuits/female_%02i.mdl'):format(i),
		male = false,
		skin = {
			name = 'Цвет пиджака',
			vals = {
				{'Темный', 0},
				{'Синий', 1},
			},
		},
	}
end

for i = 1, 8 do
	decModels[#decModels + 1] = {
		name = 'Теплая одежда ' .. i,
		male = true,
		model = ('models/dizcordum/citizens/playermodels/pm_male_%02i.mdl'):format(i),
		bgs = dizcordumMale,
	}
end

for i, v in ipairs({'p_female_01', 'p_female_02', 'p_female_03', 'p_female_04', 'p_female_06', 'p_female_05'}) do
	decModels[#decModels + 1] = {
		name = 'Теплая одежда ' .. i,
		male = false,
		model = 'models/dizcordum/citizens/playermodels/' .. v .. '.mdl',
		bgs = dizcordumFemale,
	}
end

for i, v in ipairs({'07_01', '07_02', '07_06', '09_03', '06_04', '01_02', '08_01', '08_02', '08_03', '08_04'}) do
	decModels[#decModels + 1] = {
		name = 'Гражданский ' .. i,
		male = true,
		model = 'models/humans/octo/male_' .. v .. '.mdl',
		skin = civilSkins,
	}
end

decModels[#decModels + 1] = {
	name = 'Гражданский 1',
	male = false,
	model = 'models/humans/octo/female_01.mdl',
	skin = {
		name = 'Верх',
		vals = {
			{'Коричневое пальто и темные джинсы', 0},
			{'Темно-синяя куртка на молнии', 1},
			{'Зеленая клетчатая рубашка', 2},
			{'Светло-зеленая куртка на пуговицах', 3},
			{'Синяя кофта', 4},
			{'Коричневый худи с белыми шнурками', 5},
			{'Голубая спортивка', 6},
			{'Зеленая кофта с белым поясом', 7},
			{'Белая кофта с черным рисунком зайца', 8},
			{'Кофта "Hello Kitty"', 9},
			{'Красная полосатая куртка', 10},
			{'Сиреневая куртка', 11},
			{'Бордовое пальто', 12},
			{'Коричневая кожаная куртка', 13},
			{'Жилетка цвета хаки', 14},
		},
	},
}

decModels[#decModels + 1] = {
	name = 'Гражданский 2',
	male = false,
	model = 'models/humans/octo/female_02.mdl',
	skin = {
		name = 'Верх',
		vals = {
			{'Белая клетчатая рубашка', 0},
			{'Куртка армейской расцветки', 1},
			{'Серая куртка на молнии', 2},
			{'Куртка кирпичного цвета', 3},
			{'Красная кофта', 4},
			{'Джинсовка', 5},
			{'Голубая спортивка', 7},
			{'Зеленая кофта с белым поясом', 8},
			{'Белая кофта с черным рисунком зайца', 9},
			{'Кофта "Hello Kitty"', 10},
			{'Красная полосатая куртка', 11},
			{'Сиреневая куртка', 12},
			{'Серое пальто', 13},
			{'Черная кожаная куртка', 14},
		},
	},
}

local function getBadgeBg(base)
	return {
		[10] = {
			name = 'Жетон',
			vals = { {'Без ленты', base}, {'С лентой', base+9}, {'Снять', 18} },
		}
	}
end
local function cadetBgs() -- IN HONOR OF KILO-7!!!!!!!!!!!!!!!!!!!
	return {
		[10] = {
			name = 'Жетон',
			vals = { {'Без ленты', 0}, {'С лентой', 9}, {'Снять', 18} },
		},
		[1] = {
			name = 'Верхняя одежда',
			vals = {
				{'Рубашка с галстуком', 0},
				{'Легкая куртка', 3},
				{'Зимняя куртка', 4},
			},
		},
	}
end

local serviceStrip = {
	[12] = {
		name = 'Полоски выслуги лет',
		vals = {
			{'Нет', 0},
			{'5 лет', 1},
			{'10 лет', 2},
			{'15 лет', 3},
			{'20 лет', 4},
			{'25 лет', 5},
			{'30 лет', 6},
			{'35 лет', 7},
			{'40 лет', 8},
		}
	}
}
local function patrolBgs(rank, customBadges)
	return table.Merge(customBadges and table.Copy(customBadges) or getBadgeBg(rank), serviceStrip)
end

local swatBadges = {
	[10] = {
		name = 'Жетон',
		vals = {
			{'Жетон офицера', 0},
			{'Жетон сержанта', 2},
			{'Жетон лейтенанта', 3},
		},
	}
}
local swatUtilityRanks = {
	[11] = {
		name = 'Шеврон',
		vals = {
			{'Нет', 0},
			{'Офицер полиции', 1},
			{'Старший офицер полиции', 2},
			{'Сержант I квалификации', 3},
			{'Сержант II квалификации', 4},
		}
	}
}
local swatBadgesVals = swatBadges[10].vals
for i = 1, 3 do
	swatBadgesVals[#swatBadgesVals + 1] = {swatBadgesVals[i][1] .. ' с лентой', swatBadgesVals[i][2]+9}
end
swatBadgesVals[#swatBadgesVals + 1] = {'Снять', 18}

local swatUtilityTop = {
	[1] = {
		name = 'Верхняя одежда',
		vals = {
			{'Утилитарная с длинным рукавом', 6},
			{'Утилитарная с коротким рукавом', 8},
		},
	},
}
local function getUtilityModels(val, customBadges)
	local result = addBgs(addRequiredBgs(utilityModels, {[13] = val}), customBadges and table.Copy(customBadges) or getBadgeBg(0))
	if val == 2 then
		result = addBgs(addRequiredBgs(result, {[7] = 2}), table.Merge(table.Copy(swatUtilityTop), table.Copy(swatUtilityRanks)))
	end
	return result
end

local function highRankBg(val)
	return {
		[11] = {
			name = 'Воротник застегнут?',
			vals = {
				{'Да', val},
				{'Нет', val+6},
			},
		}
	}
end

simpleOrgs.addOrg('dpd', {
	name = 'Полицейский департамент',
	title = 'Работа в Полицейском департаменте',
	shortTitle = 'Работа в DPD',
	team = 'dpd',
	police = true,
	clothes = clothesData,
	talkieFreq = 'ems',
	rankOrder = { 'cad', 'ppo', 'po', 'spo', 'swat', 'dec1', 'se1', 'se2', 'dec2', 'dec3', 'lie', 'cap', 'cmd', 'asch', 'asc', 'chi' },
	multirank = true,
	ranks = {
		cad = { -- Кадет
			shortName = 'Кадет',
			name = 'Кадет полиции',
			mdls = everydayModels,
			icon = octolib.icons.silk16('shield_delete'),
			skin = 0,
			weps = {'weapon_octo_air_glock17', 'weapon_octo_air_m4a1'},
			excludeWeps = {'weapon_octo_glock17'},
		},
		ppo = { -- Стажер
			shortName = 'Стажер',
			name = 'Стажер полиции',
			mdls = addAll(addBgs(patrolModels, cadetBgs()), everydayModels),
			icon = octolib.icons.silk16('shield'),
			everydaySkin = 2,
		},
		po = { -- Офицер
			shortName = 'Офицер',
			name = 'Офицер полиции',
			mdls = addAll(addBgs(addRequiredBgs(patrolModels, {[11]=1}), patrolBgs(0)), addRequiredBgs(getUtilityModels(1), {[11]=1}), everydayModels),
			icon = octolib.icons.silk16('shield'),
			everydaySkin = 2,
		},
		spo = { -- Старший офицер
			shortName = 'Старший офицер',
			name = 'Старший офицер полиции',
			mdls = addAll(addBgs(addRequiredBgs(patrolModels, {[11]=2}), patrolBgs(0)), addRequiredBgs(getUtilityModels(1), {[11]=2}), everydayModels),
			icon = octolib.icons.silk16('shield'),
			everydaySkin = 2,
		},
		swat = { -- Офицер спецназа
			shortName = 'Офицер спецназа',
			name = 'Офицер спецназа',
			icon = octolib.icons.silk16('lightning'),
			mdls = addAll(swatModels, addBgs(patrolModels, patrolBgs(nil, swatBadges)), getUtilityModels(2, swatBadges), everydayModels),
			armor = function(ply)
				if string.StartWith(ply:GetModel(), 'models/player/octo_swat_team/') then
					return 100
				end
			end,
			weps = {'weapon_octo_m4a1', 'weapon_octo_xm1014', 'weapon_octo_g3sg1', 'weapon_octo_awp', 'weapon_octo_beanbag', 'weapon_octo_p90', 'door_ram', 'dbg_shield'},
			excludeWeps = {'dbg_speedometer'},
			everydaySkin = 3,
		},
		dec1 = { -- Детектив I
			shortName = 'Детектив I квалификации',
			name = 'Детектив полиции I квалификации',
			mdls = addAll(decModels, addBgs(addRequiredBgs(patrolModels, {[11]=5}), patrolBgs(1)), addRequiredBgs(getUtilityModels(1), {[11]=5}), everydayModels),
			icon = octolib.icons.silk16('shield'),
			weps = {'weapon_flashlight_uv'},
			everydaySkin = 2,
		},
		se1 = { -- Сержант I
			shortName = 'Сержант I квалификации',
			name = 'Сержант полиции I квалификации',
			mdls = addAll(addBgs(addRequiredBgs(patrolModels, {[11]=3}), patrolBgs(2)), addRequiredBgs(getUtilityModels(1), {[11]=3}),  everydayModels),
			icon = octolib.icons.silk16('shield'),
			everydaySkin = 2,
		},
		se2 = { -- Сержант II
			shortName = 'Сержант II квалификации',
			name = 'Сержант полиции II квалификации',
			mdls = addAll(addBgs(addRequiredBgs(patrolModels, {[11]=4}), patrolBgs(2)), addRequiredBgs(getUtilityModels(1), {[11]=4}),  everydayModels),
			icon = octolib.icons.silk16('shield'),
			everydaySkin = 2,
		},
		dec2 = { -- Детектив II
			shortName = 'Детектив II квалификации',
			name = 'Детектив полиции II квалификации',
			mdls = addAll(decModels, addBgs(addRequiredBgs(patrolModels, {[11]=6}), patrolBgs(1)), addRequiredBgs(getUtilityModels(1), {[11]=6}), everydayModels),
			icon = octolib.icons.silk16('shield'),
			weps = {'weapon_flashlight_uv'},
			everydaySkin = 2,
		},
		dec3 = { -- Детектив III
			shortName = 'Детектив III квалификации',
			name = 'Детектив полиции III квалификации',
			mdls = addAll(decModels, addBgs(addRequiredBgs(patrolModels, {[11]=7}), patrolBgs(1)), addRequiredBgs(getUtilityModels(1), {[11]=7}), everydayModels),
			icon = octolib.icons.silk16('shield'),
			weps = {'weapon_flashlight_uv'},
			everydaySkin = 2,
		},
		lie = { -- Лейтенант
			shortName = 'Лейтенант',
			name = 'Лейтенант полиции',
			mdls = addAll(addBgs(patrolModels, table.Merge(highRankBg(8), patrolBgs(3))), everydayModels),
			icon = octolib.icons.silk16('shield_add'),
			everydaySkin = 2,
		},
		cap = { -- Капитан
			shortName = 'Капитан',
			name = 'Капитан полиции',
			mdls = addAll(addBgs(patrolModels, table.Merge(highRankBg(9), patrolBgs(4))), everydayModels),
			icon = octolib.icons.silk16('shield_add'),
			everydaySkin = 2,
		},
		cmd = { -- Командующий
			shortName = 'Командующий',
			name = 'Командующий полиции',
			mdls = addAll(addBgs(patrolModels, table.Merge(highRankBg(10), patrolBgs(5))), everydayModels),
			icon = octolib.icons.silk16('shield_add'),
			everydaySkin = 2,
		},
		asch = { -- Помощник заместителя шефа
			shortName = 'Помощник заместителя шефа',
			name = 'Помощник заместителя шефа полиции',
			mdls = addAll(addBgs(patrolModels, table.Merge(highRankBg(11), patrolBgs(6))), everydayModels),
			icon = octolib.icons.silk16('shield_add'),
			everydaySkin = 2,
		},
		asc = { -- Заместитель шефа
			shortName = 'Заместитель шефа',
			name = 'Заместитель шефа полиции',
			mdls = addAll(addBgs(patrolModels, table.Merge(highRankBg(12), patrolBgs(7))), everydayModels),
			icon = octolib.icons.silk16('shield_add'),
			everydaySkin = 2,
		},
		chi = { -- Шеф департамента
			shortName = 'Шеф департамента',
			name = 'Шеф департамента полиции',
			mdls = addAll(addBgs(patrolModels, table.Merge(highRankBg(13), patrolBgs(8))), everydayModels),
			icon = octolib.icons.silk16('shield_add'),
			everydaySkin = 2,
		},
	}
})

hook.Add('EntityBodygroupChange', 'dbg-orgs.swat', function(ent, bgID, val)
	if not ent:GetModel():find('octo_swat_team') then return end
	timer.Simple(0, function()
		if bgID == 9 and val == 1 then
			ent:SetBodygroup(12, 1)
			ent:SetBodygroup(13, 0)
			ent:SetBodygroup(8, 26)
		end

		if bgID == 1 and val == 1 then
			ent:SetBodygroup(6, 0)
		end

		if bgID == 7 then
			ent:SetBodygroup(8, val)
		end
	end)
end)
