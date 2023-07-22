local tastes = {
	{'арбуз', 'банан', 'виноград', 'вишня', 'груша', 'ежевика', 'зеленое яблоко', 'ириска', 'клубника', 'мармелад', 'мед', 'Тутти-фрутти', 'шоколад'},
	{'баклажан', 'бекон', 'брокколи', 'грейпфрут', 'гренка', 'гриб', 'жареные бобы', 'печенка', 'пицца', 'помидор', 'попкорн', 'рыба', 'картофельное пюре', 'кетчуп', 'кофе', 'сосиска', 'тост', 'тыква'},
	{'газонная трава', 'грязный носок', 'грязь', 'дождевой червь', 'перепревшая капуста', 'рвота', 'сопли', 'лук', 'мыло', 'тухлое яйцо', 'ушная сера', 'хрен'},
}
local reactions = {
	{'Вкуснятина!', 'Аж тает во рту!', 'Ням-ням!', 'М-м-м-м-м!', 'Повезло!'},
	{'Ну, сойдет', 'Эм, ну ладно', 'Ну-у-у-у...', 'Ну, хоть так', 'Могло быть и хуже'},
	{'Фу, гадость какая!', 'О боже...', 'Тьфу, нужно чем-то запить!', 'Черт, как это можно есть?!', 'Фу-у-у-у-у...'},
}
local msg = 'На вкус как... %s. %s'
octoinv.registerItem('h20_sweets', {
	name = 'Загадочная конфета',
	icon = octolib.icons.color('food_doughnut'),
	desc = 'Конфета со случайным вкусом. С каким? Не узнаешь, пока не попробуешь!\n\nВосстанавливает случайное количество сытости, в том числе отрицательное',
	mass = 0.01,
	volume = 0.01,
	use = {
		function()
			return 'Съесть', octolib.icons.color('food_meal2'), function(ply, item)
				if ply.eating then
					ply:Notify('warning', 'Поспешишь - людей насмешишь, как говорится. Не торопись')
					return
				end

				ply.eating = true
				ply:DelayedAction('eating', 'Употребление: ' .. item:GetData('name'), {
					time = 2,
					check = function() return ply.inv and tobool(ply:HasItem(item)) and not ply:IsSprinting() end,
					succ = function()
						ply.eating = nil

						local add = math.random(-30, 50)
						if add >= 25 then
							ply:Notify('hint', msg:format(tastes[1][math.random(#tastes[1])], reactions[1][math.random(#reactions[1])]))
						elseif add >= 0 then
							ply:Notify('rp', msg:format(tastes[2][math.random(#tastes[2])], reactions[2][math.random(#reactions[2])]))
						else
							ply:Notify('warning', msg:format(tastes[3][math.random(#tastes[3])], reactions[3][math.random(#reactions[3])]))
						end
						local newVal = math.Clamp(ply:GetNetVar('Energy', 100) + add, 0, 100)
						ply:SetHunger(newVal)

						item:SetData('amount', item:GetData('amount') - 1)
						if item:GetData('amount') <= 0 then item:Remove() end
					end,
					fail = function()
						ply.eating = nil
					end,
				}, {
					time = 1.5,
					inst = true,
					action = function()
						ply:EmitSound('physics/plastic/plastic_box_strain' .. math.random(1,3) .. '.wav', 60, 150)
						ply:DoAnimation(ACT_GMOD_GESTURE_BECON)
					end
				})
			end
		end,
	}
})

-- octoinv.registerItem('h20_case', {
-- 	name = 'Загадочная коробочка',
-- 	icon = octolib.icons.color('gift_question'),
-- 	desc = 'Так и хочется ее открыть!',
-- 	mass = 1,
-- 	volume = 1,
-- 	nostack = true,
-- 	use = {
-- 		function(_, item)
-- 			if not item.cid then return end
-- 			local case = halloween.cases[item.cid]
-- 			if not case or not case.items then return end
-- 			return 'Открыть', octolib.icons.color('box3_open'), function(ply, item)
-- 				local id = octolib.array.randomWeighted(case.items)
-- 				local caseItem = halloween.caseItems[id]
-- 				if not caseItem or not caseItem.give then
-- 					ErrorNoHalt(id .. ' was not registered correctly')
-- 				end
-- 				timer.Simple(0, function() caseItem.give(ply, item:GetParent()) end)
-- 				ply:Notify(('Ты открываешь загадочную коробочку, а в ней %s!'):format(caseItem.name))
-- 				octologs.createLog()
-- 					:Add(octologs.ply(ply), ' got ', octologs.string(caseItem.name), ' from Halloween case')
-- 				:Save()
-- 				return 1
-- 			end
-- 		end,
-- 	}
-- })
