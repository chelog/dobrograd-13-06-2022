local clothesData = {
	icon = 'lock',
	['models/player/octo_alpha/'] = {{
			sm = 'Головной убор',
			icon = 'hat',
			bodygroup = 1,
			vals = {
				[0] = { 'Без головного убора', 'cross', '/me снимает головной убор' },
				[2] = { 'Кепка', 'cap', '/me надевает кепку' },
			},
		},{
			sm = 'Перчатки',
			icon = 'hand',
			bodygroup = 3,
			vals = {
				[0] = { 'Снять', 'cross', '/me снимает перчатки' },
				[1] = { 'Надеть', 'bullet_black', '/me надевает перчатки' },
			},
		},{
			sm = 'Кобура',
			icon = 'gun',
			bodygroup = 6,
			vals = {
				[0] = { 'Надеть на пояс', 'arrow_up', '/me надевает кобуру на пояс' },
				[1] = { 'Надеть на ногу', 'arrow_down', '/me надевает кобуру на ногу' },
				[2] = { 'Снять', 'cross', '/me снимает кобуру' },
			},
		},{
			sm = 'Кобура тазера',
			icon = 'lightning',
			bodygroup = 7,
			vals = {
				[0] = { 'Надеть', 'bullet_blue', '/me вешает кобуру с тазером обратно на пояс' },
				[1] = { 'Снять', 'cross', '/me снимает кобуру с тазером с пояса' },
			},
		},{
			sm = 'Дубинка',
			icon = 'baton',
			bodygroup = 8,
			vals = {
				[0] = { 'Надеть', 'bullet_blue', '/me вешает дубинку обратно на пояс' },
				[1] = { 'Снять', 'cross', '/me снимает дубинку с пояса' },
			},
		},{
			sm = 'Наручники',
			icon = 'radio_button',
			bodygroup = 9,
			vals = {
				[0] = { 'Надеть одну пару', 'bullet_blue', '/me надевает одну пару наручников обратно на пояс' },
				[1] = { 'Надеть две пары', 'bullet_black', '/me надевает две пары наручников обратно на пояс' },
				[2] = { 'Снять', 'cross', '/me снимает наручники с пояса' },
			},
		},{
			sm = 'Рация',
			icon = 'radio_modern',
			bodygroup = 10,
			vals = {
				[0] = { 'Надеть', 'bullet_blue', '/me надевает рацию обратно на пояс' },
				[1] = { 'Снять', 'cross', '/me снимает рацию с пояса' },
			},
		},
	},
}

local modelNums = {1, 2, 3, 4, 5, 6, 8, 9}

local bgsData = {
	[1] = {
		name = 'Головной убор',
		vals = {
			{'Без головного убора', 0, true},
			{'Кепка', 2},
		},
	},
	[2] = {
		name = 'Гарнитура',
		vals = {
			{'Проводная', 0, true},
			{'Снять', 2},
		},
	},
	[4] = {
		name = 'Верх',
		vals = {
			{'Строгая рубашка', 0, true},
			{'Строгая рубашка и куртка', 1},
			{'Поло', 2},
			{'Поло и куртка', 3},
			{'Поло и куртка с бронежилетом', 4},
		},
	},
	[5] = {
		name = 'Бронежилет',
		vals = {
			{'Без бронежилета', 0, true},
			{'Без магазинов', 1},
		},
	},
	[11] = {
		name = 'Нашивка',
		vals = {
			{'Без нашивки', 0, true},
			{'S.S.U.', 1},
			{'King', 2},
			{'Zero', 3},
			{'Siesta', 4},
			{'Yankee', 5},
			{'Alpha', 6},
			{'Ricardo', 7},
			{'Union', 8},
		},
	},
	[12] = {
		name = 'Патч',
		vals = {
			{'Без патча', 0, true},
			{'DMC', 1},
			{'Золотой орел', 2},
			{'Череп', 3},
			{'Орел со звездой', 4},
			{'Sabaton', 5},
			{'Снежинка', 6},
			{'Вялоухий', 7},
			{'Легионер', 8},
			{'Нептун', 9},
			{'ДУХ АХАХАХ', 10},
		},
	}
}

local skinData = {
	name = 'Низ',
	vals = {
		{'Темные брюки', 0, true},
		{'Светлые брюки', 4},
	},
}

local models = {}
for i, v in ipairs(modelNums) do
	models[#models + 1] = {
		name = 'Охранник ' .. i,
		model = ('models/player/octo_alpha/male_%02d.mdl'):format(v),
		bgs = bgsData,
		skin = skinData,
	}
end

simpleOrgs.addOrg('alpha', {
	name = 'Alpha',
	title = 'Alpha Corporation | Делаем вашу жизнь безопаснее',
	shortTitle = 'Alpha',
	clothes = clothesData,
	team = 'alpha',
	mdls = models,
	talkieFreq = 'alpha',
})

local plateCol = {
	bg = Color(123, 0, 28),
	border = Color(40, 40, 40),
	title = Color(255, 255, 255),
	txt = Color(179, 179, 179),
}

carDealer.addCategory('alpha', {
	name = 'Alpha',
	icon = 'icon16/lightning.png',
	queue = true,
	ems = true,
	bulletproof = true,
	doNotEvacuate = true,
	spawns = carDealer.civilSpawns,
	canUse = function(ply) return ply:Team() == TEAM_ALPHA, 'Доступно только Alpha' end,
})

carDealer.addVeh('alpha_merit', {
	name = 'Merit',
	simfphysID = 'sim_fphys_gta4_merit_alpha',
	plateCol = plateCol,
	price = 12000,
	deposit = true,
	police = true,
	default = {
		mats = {
			[14] = 'models/alpha_cars/alpha_car_04',
		},
	},
})

local function canUse(ply)
	return DarkRP.isTaxist(ply) or ply:Team() == TEAM_ALPHA
end

if SERVER then
	local leaveMeAloneID = 0


	octochat.registerCommand('/alphabutton', {
		cooldown = 60,
		log = true,
		execute = function(ply)
			local job, jobname = ply:getJobTable()
			if job then jobname = job.name end
			local customJob = ply:GetNetVar('customJob')
			if customJob then jobname = unpack(customJob) end

			ply:DoEmote('{name} нажимает кнопку паники')

			local msg = ('%s %s передает свое местоположение, используя тревожную кнопку!'):format(jobname, ply:Name())
			local marker = {
				id = 'cpPanicBtn' .. leaveMeAloneID,
				group = 'cpPanicBtn',
				txt = 'Кнопка паники',
				pos = ply:GetPos() + Vector(0,0,40),
				col = Color(102,170,170),
				des = {'timedist', { 600, 300 }},
				icon = 'octoteam/icons-32/exclamation.png',
				size = 32,
			}
			for _,v in ipairs(player.GetAll()) do
				if v:Team() == TEAM_ALPHA then
					v:Notify('warning', msg)
					v:EmitSound('npc/attack_helicopter/aheli_damaged_alarm1.wav', 45, 100, 0.5)
					v:AddMarker(marker)
				end
			end
			leaveMeAloneID = leaveMeAloneID + 1
		end,
		check = canUse,
	})
else
	octochat.defineCommand('/alphabutton', canUse)
end