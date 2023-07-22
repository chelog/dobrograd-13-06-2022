local function attItem(mdl)
	local attData = simfphys.getAttByModel(mdl)
	return {'car_att', {
		name = attData.name,
		desc = attData.desc,
		icon = attData.icon,
		mass = attData.mass,
		volume = attData.volume,
		colorable = not attData.noPaint or nil,
		attmdl = attData.mdl,
		model = attData.mdl,
		skin = attData.skin,
		scale = attData.scale,
	}}
end
local function sendItem(item, sentNo, sentYes)
	return function(ply, amount)
		local data
		if isstring(item) then data = {{ item, amount }}
		elseif istable(item) then
			data = octolib.array.series(item, amount)
		end
		local sent, msg = halloween.sendItems(ply, data)
		if not sent then
			ply:Notify('warning', msg or sentNo)
		else ply:Notify('hint', sentYes) end
		return sent
	end
end

local function icon(name)
	return 'octoteam/icons-halloween/' .. name .. '.png'
end

halloween.registerItem('mystery_sweet', {
	name = 'Загадочная конфета',
	icon = icon('mystery_sweet'),
	desc = 'Конфета, обладающая случайным вкусом. Арбуз? Яблоко? А может, рвота или ушная сера? Попробуй и узнаешь!',
	price = 100,
	deliver = sendItem('h20_sweets', 'Не удалось отправить загадочные конфеты', 'Загадочные конфеты отправлены по почте и придут через пару минут'),
})

halloween.registerItem('guitar', {
	name = 'Гитара',
	icon = icon('guitar'),
	desc = 'Позволяет скрасить свое одиночество или задать атмосферу в компании',
	price = 300,
	deliver = sendItem({'weapon', {
		name = L.guitar,
		icon = octolib.icons.color('guitar'),
		model = 'models/custom/guitar/m_d_45.mdl',
		wepclass = 'guitar',
		mass = 2,
		volume = 5,
		ammoadd = 0,
		clip1 = 0,
		clip2 = 0,
	}}, 'Не удалось отправить гитару', 'Гитара отправлена по почте и придет через пару минут'),
})

local masks = { 'cleaver', 'monkey', 'zombie', 'hockey', 'gingerbread', 'top_hat', 'doctor', 'pig', 'bear', 'hoff_widesmile', 'hoff_tears', 'hoff_tinysmile', 'hoff_dude', 'hoff_killme', 'hoff_helpme' }
for _, v in ipairs(masks) do
	local mask = CFG.masks[v]
	local name = mask.name
	if mask.desc then name = name .. ' ' .. mask.desc end
	local item = {
		name = mask.name,
		icon = mask.icon,
		desc = mask.desc,
		mask = v,
	}
	halloween.registerItem('mask_' .. v, {
		name = name,
		icon = icon('mask_' .. v),
		skin = mask.skin,
		desc = 'Стильно, модно, молодежно. Можно надеть на голову',
		price = 3000,
		deliver = sendItem({'h_mask', item}, 'Не удалось отправить маску', 'Маска отправлена по почте и придет через пару минут'),
	})
	halloween.registerCaseItem('mask_' .. v, {
		name = name,
		icon = icon('mask_' .. v),
		maxMass = 0.3,
		maxVolume = 0.5,
		give = function(_, cont)
			cont:AddItem('h_mask', item)
		end,
	})
end

halloween.registerItem('theme', {
	name = 'Очки с оранжевыми линзами',
	icon = icon('theme'),
	desc = 'Понравилось хэллоуинское настроение? Ты можешь продлить его, захватив с собой эти очки с оранжевыми линзами!\n\n- Хэллоуинская тема. Ее можно будет включить в любой момент в настройках',
	price = 5000,
	max = 1,
	deliver = function(ply)
		ply:SetDBVar('halloweenTheme', true)
		ply:SetLocalVar('halloweenTheme', true)
		ply:ConCommand('octogui_reloadf4')
		ply:Notify('hint', 'Хэллоуинскую тему можно активировать в разделе "Другое" в настройках')
		return true
	end,
})

halloween.registerItem('jar', {
	name = 'Банка с глазами',
	icon = icon('jar'),
	desc = 'Старая банка с устрашающими глазами. Будет хорошо смотреться на приборной панели твоего автомобиля!',
	price = 6000,
	deliver = function(ply, amount)
		local data = octolib.array.series(attItem('models/props/spookington/eyejar.mdl'), amount)
		local sent, msg = halloween.sendItems(ply, data)
		if not sent then
			ply:Notify('warning', msg or 'Не удалось отправить банку с глазами')
		else ply:Notify('hint', 'Банка с глазами отправлена по почте и придет через пару минут') end
		return sent
	end,
})

halloween.registerItem('spider', {
	name = 'Паучок',
	icon = icon('spider'),
	desc = 'Страшный, волосатый, но отчасти милый хэллоуинский паучок. Представляешь, если он повиснет в салоне твоего автомобиля? Это будет просто безумно круто!',
	price = 6000,
	deliver = function(ply, amount)
		local data = octolib.array.series(attItem('models/props/spookington/spider_toy.mdl'), amount)
		local sent, msg = halloween.sendItems(ply, data)
		if not sent then
			ply:Notify('warning', msg or 'Не удалось отправить паучка')
		else ply:Notify('hint', 'Паучок отправлен по почте и придет через пару минут') end
		return sent
	end,
})

halloween.registerItem('sedan', {
	name = 'Седан',
	icon = icon('sedan'),
	desc = 'Подарочный сертификат автосалона на эксклюзивный черный седан!\n\n- Автомобиль будет доставлен в гараж\n- При продаже авто деньги не начислятся',
	price = 8500,
	deliverAsync = function(ply, amount, callback)
		octolib.func.parallel(
			octolib.array.series(function(res)
				carDealer.ownVeh(ply:SteamID(), 'halloween_sedan', function(_, plate)
					res(plate)
				end)
			end, amount)
		):Then(function(plates)
			callback(true)
			if not IsValid(ply) then return end
			if amount == 1 then
				ply:Notify('hint', 'Автомобиль с регистрационным номером ' .. plates[1] .. ' доставлен в твой гараж')
			elseif amount == 2 then
				ply:Notify('hint', 'Автомобили с регистрационными номерами ' .. plates[1] .. ' и ' .. plates[2] .. ' доставлены в твой гараж')
			else
				local last = plates[#plates]
				table.remove(plates)
				ply:Notify('hint', 'Автомобили с регистрационными номерами ' .. string.Implode(', ', plates) .. ' и ' .. last .. ' доставлены в твой гараж')
			end
		end):Catch(function(err)
			ErrorNoHalt(err)
			callback(false)
		end)
	end,
})

halloween.registerItem('pickup', {
	name = 'Пикап',
	icon = icon('pickup'),
	desc = 'Подарочный сертификат автосалона на эксклюзивный оранжевый пикап!\n\n- Автомобиль будет доставлен в гараж\n- При продаже авто деньги не начислятся',
	price = 8500,
	deliverAsync = function(ply, amount, callback)
		octolib.func.parallel(
			octolib.array.series(function(res)
				carDealer.ownVeh(ply:SteamID(), 'halloween_pickup', function(_, plate)
					res(plate)
				end)
			end, amount)
		):Then(function(plates)
			callback(true)
			if not IsValid(ply) then return end
			if amount == 1 then
				ply:Notify('hint', 'Автомобиль с регистрационным номером ' .. plates[1] .. ' доставлен в твой гараж')
			elseif amount == 2 then
				ply:Notify('hint', 'Автомобили с регистрационными номерами ' .. plates[1] .. ' и ' .. plates[2] .. ' доставлены в твой гараж')
			else
				local last = plates[#plates]
				table.remove(plates)
				ply:Notify('hint', 'Автомобили с регистрационными номерами ' .. string.Implode(', ', plates) .. ' и ' .. last .. ' доставлены в твой гараж')
			end
		end):Catch(function(err)
			ErrorNoHalt(err)
			callback(false)
		end)
	end,
})

-- CASE ITEMS

halloween.registerCaseItem('sweets_low', {
	name = 'Загадочные конфеты',
	icon = icon('mystery_sweet'),
	maxMass = 0.03,
	maxVolume = 0.03,
	give = function(ply, cont)
		local sweets = math.random(3)
		cont:AddItem('h20_sweets', sweets)
		ply:Notify('hint', 'Несколько загадочных конфет добавлено тебе в инвентарь')
	end,
})

halloween.registerCaseItem('money_low', {
	name = 'Потрепанный кошель',
	icon = icon('money_low'),
	maxMass = 0.04,
	maxVolume = 0.04,
	give = function(ply, cont)
		local money = math.random(4000)
		cont:AddItem('money', money)
		ply:Notify('hint', 'Как неожиданно и приятно... ' .. DarkRP.formatMoney(money) .. ' добавлено тебе в инвентарь')
	end,
})

halloween.registerCaseItem('money_large', {
	name = 'Мешок с монетками',
	icon = icon('money_large'),
	maxMass = 0.25,
	maxVolume = 0.25,
	give = function(ply, cont)
		local money = math.random(4000, 25000)
		cont:AddItem('money', money)
		ply:Notify('hint', 'Вот так везение... ' .. DarkRP.formatMoney(money) .. ' добавлено тебе в инвентарь')
	end,
})

halloween.registerCaseItem('sweets_large', {
	name = 'Горсть конфет',
	icon = icon('mystery_sweet'),
	maxMass = 0.13,
	maxVolume = 0.13,
	give = function(ply, cont)
		local sweets = math.random(3, 13)
		cont:AddItem('h20_sweets', sweets)
		ply:Notify('hint', sweets .. octolib.string.formatCount(sweets, ' загадочная конфета добавлена', ' загадочных конфеты добавлены', ' загадочных конфет добавлено') .. ' тебе в инвентарь')
	end,
})

halloween.registerCaseItem('candy', {
	name = 'Испорченный леденец',
	icon = icon('candy'),
	maxMass = 0.1,
	maxVolume = 0.05,
	give = function(_, cont)
		cont:AddItem('souvenir', {
			name = 'Испорченный леденец',
			icon = octolib.icons.color('food_candy2'),
			model = 'models/griim/foodpack/candycane.mdl',
			desc = 'Старый леденец. Присмотревшись к нему можно увидеть паутину. Лучше не пытаться его съесть, а как сувенир - очень даже неплохая вещица!',
		})
	end,
})

halloween.registerCaseItem('booze', {
	name = 'Хэллоуинская настойка',
	icon = icon('booze'),
	maxMass = 1.5,
	maxVolume = 1,
	give = function(_, cont)
		cont:AddItem('drug_booze2', {
			name = 'Хэллоуинская настойка',
			icon = octolib.icons.color('bottle_wine'),
		})
	end,
})

halloween.registerCaseItem('os_dobro', {
	name = 'Карта клуба почетных жителей "Добродей"',
	icon = icon('os_dobro'),
	give = function(ply)
		ply:osGiveItem('jobs_1m')
		ply:Notify('hint', 'Ты получил плюшку "Добродей" на месяц! Активировать ее можно в F4 -> Плюшки')
	end,
})

halloween.registerCaseItem('att_pumpkin', {
	name = 'Тыква-лампа для автомобиля',
	icon = icon('pumpkin'),
	maxMass = 1,
	maxVolume = 3,
	give = function(_, cont)
		cont:AddItem(unpack(attItem('models/halloween2015/pumbkin_n_f01.mdl')))
	end,
})

halloween.registerCaseItem('att_spider', {
	name = 'Паучок для автомобиля',
	icon = icon('spider'),
	maxMass = 0.7,
	maxVolume = 1,
	give = function(_, cont)
		cont:AddItem(unpack(attItem('models/props/spookington/spider_toy.mdl')))
	end,
})

-- CASES

halloween.registerCase('gift', {
	name = 'Подарок от Джека',
	icon = icon('gift'),
	desc = 'Я кладу какой-то предмет в коробочку и отправляю тебе по почте. Что за предмет - узнаешь, когда откроешь ;)',
	price = 750,
	items = {
		{31, 'sweets_low'},
		{20, 'booze'},
		{20, 'candy'},
		{13, 'sweets_large'},
		{9, 'money_low'},
		{5, 'money_large'},
		{2, 'os_dobro'},
		{1.5, 'att_pumpkin'},
		{1.5, 'att_spider'},
	},
})

halloween.registerCase('mask', {
	name = 'Какая-то маска',
	icon = icon('case-masks'),
	desc = 'Теряешься в моем огромном ассортименте масок? Я могу помочь выбрать! Никаких предпочтений по маскам у меня нет, поэтому я честно выберу случайную маску. Никакого мошенничества!',
	price = 3000,
	items = octolib.table.mapSequential(masks, function(v) return {1, 'mask_' .. v} end),
})
