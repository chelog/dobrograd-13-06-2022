local bankSubMats = {
	[27] = {
		name = 'Форма',
		vals = {
            {'Костюм "D\'Anglere"', 'models/humans/modern/octo/suit1_sheet'},
            {'Черный деловой костюм', 'models/humans/modern/octo/suit2_sheet'},
            {'Белый деловой костюм', 'models/humans/modern/octo/suit3_sheet'},
            {'Серый деловой костюм', 'models/humans/modern/octo/suit4_sheet'},
            {'Зеленый деловой костюм', 'models/humans/modern/octo/suit5_sheet'},
            {'Голубой деловой костюм', 'models/humans/modern/octo/suit6_sheet'},
            {'Черный пиджак', 'models/humans/modern/octo/suit7_sheet'},
            {'Синий пиджак', 'models/humans/modern/octo/suit8_sheet'},
		},
	},
}

local models = octolib.table.mapSequential({
	'models/humans/octo/male_01_01.mdl',
	'models/humans/octo/male_01_02.mdl',
	'models/humans/octo/male_01_03.mdl',
	'models/humans/octo/male_02_01.mdl',
	'models/humans/octo/male_02_02.mdl',
	'models/humans/octo/male_02_03.mdl',
	'models/humans/octo/male_03_01.mdl',
	'models/humans/octo/male_03_02.mdl',
	'models/humans/octo/male_03_03.mdl',
	'models/humans/octo/male_03_04.mdl',
	'models/humans/octo/male_03_05.mdl',
	'models/humans/octo/male_03_06.mdl',
	'models/humans/octo/male_03_07.mdl',
	'models/humans/octo/male_04_01.mdl',
	'models/humans/octo/male_04_02.mdl',
	'models/humans/octo/male_04_03.mdl',
	'models/humans/octo/male_04_04.mdl',
	'models/humans/octo/male_05_01.mdl',
	'models/humans/octo/male_05_02.mdl',
	'models/humans/octo/male_05_03.mdl',
	'models/humans/octo/male_05_04.mdl',
	'models/humans/octo/male_05_05.mdl',
	'models/humans/octo/male_06_01.mdl',
	'models/humans/octo/male_06_02.mdl',
	'models/humans/octo/male_06_03.mdl',
	'models/humans/octo/male_06_04.mdl',
	'models/humans/octo/male_06_05.mdl',
	'models/humans/octo/male_07_01.mdl',
	'models/humans/octo/male_07_02.mdl',
	'models/humans/octo/male_07_03.mdl',
	'models/humans/octo/male_07_04.mdl',
	'models/humans/octo/male_07_05.mdl',
	'models/humans/octo/male_07_06.mdl',
	'models/humans/octo/male_08_01.mdl',
	'models/humans/octo/male_08_02.mdl',
	'models/humans/octo/male_08_03.mdl',
	'models/humans/octo/male_08_04.mdl',
	'models/humans/octo/male_09_01.mdl',
	'models/humans/octo/male_09_02.mdl',
	'models/humans/octo/male_09_03.mdl',
	'models/humans/octo/male_09_04.mdl',
}, function(v, i)
	return {
		name = 'Внешность ' .. i,
		male = true,
		model = v,
		subMaterials = bankSubMats,
		requiredSkin = 23,
	}
end)

models[#models + 1] = {
    name = 'Сотрудник охраны',
    model = 'models/player/camo_09.mdl',
    male = true,
    bgs = {
        [1] = {
            name = 'Базовый бронежилет',
        },
        [2] = {
            name = 'Кепка',
        },
        [3] = {
            name = 'Пояс',
        },
        [5] = {
            name = 'Полный бронежилет',
        },
        [6] = {
            name = 'Шлем',
        }
    },
    requiredBgs = {[4] = 1}
}

simpleOrgs.addOrg('bank', {
	name = 'Sevila’s Bank',
	title = 'Sevila’s Bank | Лучший банк штата Мичиган',
	shortTitle = 'Sevila’s Bank',
	team = 'bank',
	mdls = models,
	talkieFreq = 'bank',
})

carDealer.addCategory('bank', {
	name = 'Банк',
	icon = 'icon16/money.png',
	queue = true,
	bulletproof = true,
	doNotEvacuate = true,
	spawns = carDealer.civilSpawns,
	canUse = function(ply) return ply:Team() == TEAM_BANK, 'Доступно только сотрудникам банка' end,
})

local plateCol = {
	bg = Color(30, 30, 30),
	border = Color(40, 40, 40),
	title = Color(255, 255, 255),
	txt = Color(255, 255, 255),
}

carDealer.addVeh('bank_stockade', {
	name = 'Stockade',
	simfphysID = 'sim_fphys_gta4_stockade',
	price = 0,
	bulletproof = true,
	deposit = true,
	police = true,
	plateCol = plateCol,
})

carDealer.addVeh('bank_dilettante', {
	name = 'Dilettante',
	simfphysID = 'sim_fphys_gta4_dilettante',
	price = 0,
	deposit = true,
	plateCol = plateCol,
	default = {
		col = { Color(30, 30, 30), Color(30, 30, 30), Color(0,0,0), Color(30, 30, 30) },
	},
})

carDealer.addVeh('bank_habanero', {
	name = 'Habanero',
	simfphysID = 'sim_fphys_gta4_habanero',
	price = 0,
	deposit = true,
	plateCol = plateCol,
	default = {
		col = { Color(30, 30, 30), Color(30, 30, 30), Color(0,0,0), Color(30, 30, 30) },
	},
})

local toStrip =	{'weapon_octo_p228', 'weapon_octo_m4a1', 'weapon_octo_mp5', 'weapon_cuff_police', 'stunstick', 'med_kit', 'stungun'}
hook.Add('OnPlayerChangedTeam', 'dbg-orgs.bank', function(ply, old, new)
    if not SERVER then return end
    if new == TEAM_BANK then
		timer.Simple(0, function()
			if ply:GetModel() ~= 'models/player/camo_09.mdl' then
				for _, v in ipairs(toStrip) do
					ply:SetNetVar('HasGunlicense')
					ply:StripWeapon(v)
				end
			end
		end)
	end
end)