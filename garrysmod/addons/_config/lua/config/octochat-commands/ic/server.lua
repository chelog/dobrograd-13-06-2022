octochat.registerCommand('/whisper', {
	cooldown = 1.5,
	log = true,
	execute = function(ply, txt) octochat.genericSayFunc(ply, txt, 90, ' шепчет: ') end,
	aliases = {'/w'},
})

octochat.registerCommand('/yell', {
	cooldown = 1.5,
	log = true,
	execute = function(ply, txt)
		if txt == '' then return end
		if txt:sub(-1) ~= '!' then txt = txt .. '!' end
		octochat.genericSayFunc(ply, txt, 550, ' кричит: ')
	end,
	aliases = {'/y'},
})

octochat.registerCommand('/me', {
	cooldown = 1.5,
	log = true,
	execute = function(ply, txt)
		if txt == '' then return 'Формат: /me действие от третьего лица' end
		ply:DoEmote('{name} ' .. utf8.lower(utf8.sub(txt, 1, 1)) .. utf8.sub(txt, 2))
	end,
})

octochat.registerCommand('/it', {
	cooldown = 1.5,
	log = true,
	execute = function(ply, txt)
		if txt == '' then return 'Формат: /it Описание обстановки от третьего лица' end
		octochat.talkToRange(ply, 250, octochat.textColors.rp, utf8.upper(utf8.sub(txt, 1, 1)) .. utf8.sub(txt, 2) .. ' ({name})' % {name = ply:Name()})
	end,
})

octochat.registerCommand('/pit', {
	cooldown = 1.5,
	log = true,
	execute = function(ply, _, args)
		local target, txt = octochat.pickOutTarget(args)
		if not target then return txt or 'Формат: /pit "Имя игрока" Текст обстановки' end
		if txt == '' then return 'Формат: /pit "Имя игрока" Текст обстановки' end
		octochat.talkTo(target, octochat.textColors.rp, '[Приватный IT, ', ply:Name(), '] ', txt)
		octochat.talkTo(ply, octochat.textColors.rp, '[Приватный IT, ', target:Name(), '] ', txt)
	end,
})


local function toit(ply, txt, radius, action)
	local args = string.Explode(' * ', txt)
	if not args[1] or args[1] == '' or not args[2] or args[2] == '' then return 'Формат: /toit действие * Фраза' end
	action = action or txt:sub(-1) == '?' and 'спрашивает:' or 'говорит:'
	octochat.genericSayFunc(ply, args[2], radius, (' %s, %s'):format(args[1], action))
	if ply:GetNetVar('os_govorilka') and not ply:IsGovorilkaMuted() then
		ply:DoVoice(args[2], ply:GetVoice(), heard)
	end
end

octochat.registerCommand('/toit', {
	cooldown = 1.5,
	log = true,
	execute = function(ply, txt)
		toit(ply, txt, 250)
	end,
})

octochat.registerCommand('/whispertoit', {
	cooldown = 1.5,
	log = true,
	execute = function(ply, txt)
		toit(ply, txt, 90, 'шепчет: ')
	end,
	aliases = {'/wtoit'},
})

octochat.registerCommand('/yelltoit', {
	cooldown = 1.5,
	log = true,
	execute = function(ply, txt)
		toit(ply, txt, 550, 'кричит: ')
	end,
	aliases = {'/ytoit'},
})

octochat.registerCommand('//it', {
	cooldown = 1.5,
	log = true,
	execute = function(_, txt)
		octochat.talkTo(nil, octochat.textColors.rp, txt)
	end,
	permission = 'DBG: Глобальный IT',
})

-- LOTTERY

local function lotterySay(ply, msg, all)
	if all then
		local receivers = octolib.array.filter(player.GetAll(), function(ply) return ply:HasPhone() end)
		for i, receiver in ipairs(receivers) do
			receiver:SendSMS(octochat.textColors.rp, 'Лотерейное бюро', L.owner_sms, Color(250,250,200), msg)
		end
		return
	else
		if not ply:HasPhone() then return end
		ply:SendSMS(octochat.textColors.rp, 'Лотерейное бюро', L.owner_sms, Color(250,250,200), msg)
	end
end

local function lotteryFilterValid(sid)
	local ply = player.GetBySteamID(sid)
	return IsValid(ply) and ply or nil
end

local entries = {}
local lotteryStarted, lotteryAmount = false, 0
local function startLottery()

	if player.GetCount() <= 5 then return end

	lotteryAmount = math.Round(math.random(GAMEMODE.Config.minlotterycost, GAMEMODE.Config.maxlotterycost))

	hook.Run('lotteryStarted', lotteryAmount)

	lotterySay(nil, L.lottery_started:format(DarkRP.formatMoney(lotteryAmount)), true)

	lotteryStarted = true

	timer.Simple(300, function()
		local online = octolib.array.map(entries, lotteryFilterValid)
		if not online[1] then
			lotterySay(nil, L.lottery_noone_entered, true)
			return hook.Run('lotteryEnded', entries)
		end

		local chosen = octolib.array.random(online)
		local sum = math.Round((#entries * lotteryAmount) * 0.95)
		hook.Run('lotteryEnded', entries, chosen, sum)
		chosen:BankAdd(sum)
		lotterySay(chosen, L.lottery_won:format(DarkRP.formatMoney(sum)))
		entries, lotteryAmount, lotteryStarted = {}, 0, false
	end)

end
timer.Create('dbg-lottery', octolib.time.toSeconds(1, 'hour'), 0, startLottery)

local function joinLottery(ply, args)
	if not lotteryStarted then return lotterySay(ply, 'Лотерея сейчас не идёт!') end

	table.remove(args, 1)
	local txt = string.Trim(string.Implode(' ', args))

	if not ply:BankHas(lotteryAmount) then
		return false, L.cant_afford:format('участия в лотерее'), 'warning'
	end

	for _, v in ipairs(entries) do
		if ply:SteamID() == v then
			return lotterySay(ply, 'Вы уже участвуете в лотерее!')
		end
	end

	ply:BankAdd(-lotteryAmount)
	entries[#entries + 1] = ply:SteamID()
	lotterySay(ply, L.lottery_entered)

	hook.Run('playerEnteredLottery', ply)
end

local groups = { 'dpd', 'medic', 'fire', 'coroners', 'prison', 'wcso', 'csd', 'fbi', 'gov' }
local function isInDepartment(ply)
	if ply:Team() == TEAM_ADMIN then return true end
	for _, groupID in ipairs(groups) do
		if ply.currentOrg == groupID then
			return true
		end
	end
	return false
end
octochat.registerCommand('/d', {
	cooldown = 1.5,
	log = true,
	execute = function(ply, txt)
		octochat.talkTo(octolib.array.filter(player.GetAll(), isInDepartment), octochat.textColors.rp, ply:Name(), ' передает на рацию департаментов: ', color_white, txt)
	end,
	check = isInDepartment,
})

octochat.registerCommand('/sms', {
	cooldown = 1.5,
	log = true,
	phone = true,
	execute = function(ply, _, args)

		if not ply:Alive() or ply:IsGhost() then
			return L.death_cannot_do_this
		end
		if ply:isArrested() then
			return L.you_arrested
		end
		if ply:IsHandcuffed() then
			return L.handcuffed_cannot_do_this
		end

		if txt == '' then return 'Формат: /sms "Имя игрока" Текст сообщения' end
		if args[1] == 'lottery' then
			joinLottery(ply, args)
			return
		end
		local target, txt = octochat.pickOutTarget(args)
		if not target then return txt or 'Формат: /sms "Имя игрока" Текст сообщения' end
		if not target:HasPhone() then return L.abonent_unavailable end

		ply:DoEmote('{name} отправляет SMS')
		if not target:IsHandcuffed() then
			target:SendSMS(octochat.textColors.rp, ply:Name(), L.owner_sms, Color(250,250,200), txt)
		else
			target:Notify('Тебе пришло SMS от ' .. ply:Name() .. ', но ты не можешь его прочитать, так как руки связаны')
		end
		ply:SendSMS(octochat.textColors.rp, target:Name(), L.target_sms, Color(250,250,200), txt)

	end,
})

octochat.registerCommand('/roll', {
	cooldown = 1.5,
	log = true,
	execute = function(ply, _, args)
		local roll = ply:IsSuperAdmin() and tonumber(args[1] or '') or math.random(100)
		ply:TalkToRange(350, octochat.textColors.rp, L.have_chance:format(ply:Name()), color_white, L.out_of_100:format(roll))
	end,
})

octochat.registerCommand('/dice', {
	cooldown = 1.5,
	log = true,
	execute = function(ply, _, args)
		local roll1 = ply:IsSuperAdmin() and tonumber(args[1] or '') or math.random(6)
		local roll2 = ply:IsSuperAdmin() and tonumber(args[2] or '') or math.random(6)
		ply:TalkToRange(350, octochat.textColors.rp, L.threw_the_dice:format(ply:Name()), color_white, L.dice_and:format(roll1, roll2))
	end,
})

octochat.registerCommand('/coin', {
	cooldown = 1.5,
	log = true,
	execute = function(ply, _, args)
		local roll = ply:IsSuperAdmin() and tonumber(args[1] or '') or math.random(2)
		ply:TalkToRange(350, octochat.textColors.rp, ply:Name(), ' подбрасывает монетку: ', color_white, roll == 1 and 'орел' or 'решка')
	end,
})

local cards = {}
for _, w1 in ipairs(L.card_parts1) do
	for _, w2 in ipairs(L.card_parts2) do
		cards[#cards + 1] = ('%s %s'):format(w1, w2)
	end
end

octochat.registerCommand('/card', {
	cooldown = 1.5,
	log = true,
	execute = function(ply, txt)
		local card = ply:IsSuperAdmin() and txt ~= '' and string.lower(txt) or table.Random(cards)
		local found = false
		for _,v in ipairs(cards) do
			if v == card then
				found = true
				break
			end
		end
		if not found then card = table.Random(cards) end

		ply:TalkToRange(350, octochat.textColors.rp, L.randomcard:format(ply:Name()), color_white, card)

	end,
})

octochat.registerCommand('/rockpaperscissors', {
	cooldown = 1.5,
	log = true,
	execute = function(ply, txt)

		local gest = ply:IsSuperAdmin() and txt ~= '' and string.lower(txt) or table.Random(L.rps)
		local found = false
		for _,v in ipairs(L.rps) do
			if v == gest then
				found = true
				break
			end
		end
		if not found then gest = table.Random(L.rps) end

		ply:TalkToRange(350, octochat.textColors.rp, L.gesture_showed:format(ply:Name()), color_white, gest)
	end,
})

octochat.registerCommand('/dbg_getidea', {
	cooldown = 1.5,
	execute = function(ply) ply:Notify(L.ideas[math.random(#L.ideas)]) end,
})

octochat.registerCommand('/give', {
	execute = function(ply, amount)

		amount = amount:gsub('[^0-9]', '')
		if amount == '' then return 'Формат: /give количество' end
		amount = tonumber(amount)
		if not amount then return 'Формат: /give количество' end
		amount = math.floor(amount)
		if amount <= 0 then return 'Укажи положительное число' end
		if not ply:canAfford(amount) then return 'У тебя нет столько денег' end

		local target = octolib.use.getTrace(ply).Entity
		if not IsValid(target) or not target:IsPlayer() then return L.must_be_looking_at:format('игрока') end
		if target:getJobTable().notHuman then return L.must_be_looking_at:format('живого человека') end

		ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_GIVE)
		ply:addMoney(-amount)
		ply:Notify(L.you_gave:format(target:Name(), DarkRP.formatMoney(amount)))

		timer.Simple(1.2, function()
			if not IsValid(ply) or not IsValid(target) then return end

			target:addMoney(amount)
			target:Notify(L.has_given:format(ply:Name(), DarkRP.formatMoney(amount)))
		end)

		hook.Run('DarkRP.payPlayer', ply, target, amount or 1)

	end,
})

octochat.registerCommand('/dropmoney', {
	cooldown = 3,
	execute = function(ply, amount)

		amount = amount:gsub('[^0-9]', '')
		if amount == '' then return 'Формат: /dropmoney количество' end
		amount = tonumber(amount)
		if not amount then return 'Формат: /dropmoney количество' end
		amount = math.floor(amount)
		if amount <= 0 then return 'Укажи положительное число' end
		if amount >= 10000000 then return 'Ты не можешь выбросить больше ' .. DarkRP.formatMoney(10000000) end
		if not ply:canAfford(amount) then return 'У тебя нет столько денег' end

		local taken = ply:addMoney(-amount)
		if (taken or 0) < 1 then return end
		ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_GIVE)

		timer.Simple(0.88, function()

			if not IsValid(ply) then return end

			local bonePos, boneAng = ply:GetBonePosition(ply:LookupBone('ValveBiped.Bip01_L_Hand') or 16)
			local spawnPos, spawnAng = LocalToWorld(Vector(0,0,0), Angle(0,60,-15), bonePos, boneAng)
			local drop = DarkRP.createMoneyBag(spawnPos, taken, ply)
			drop:SetAngles(spawnAng)
			drop.droppedBy = ply

			local phys = drop:GetPhysicsObject()
			if phys then
				local dir = ply:GetAimVector()
				dir.z = 0
				phys:SetVelocity(dir * 200)
			end

		end)

	end,
	aliases = {'/moneydrop'},
})

octochat.registerCommand('/putmoney', {
	cooldown = 3,
	execute = function(ply, amount)

		amount = amount:gsub('[^0-9]', '')
		if amount == '' then return 'Формат: /putmoney количество' end
		amount = tonumber(amount)
		if not amount then return 'Формат: /putmoney количество' end
		amount = math.floor(amount)
		if amount <= 0 then return 'Укажи положительное число' end
		if amount >= 10000000 then return 'Ты не можешь выбросить больше ' .. DarkRP.formatMoney(10000000) end
		if not ply:canAfford(amount) then return 'У тебя нет столько денег' end

		local taken = ply:addMoney(-amount)
		if (taken or 0) < 1 then return end
		ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_GIVE)

		timer.Simple(0.88, function()

			if not IsValid(ply) then return end

			local tr = util.TraceLine({
				start = ply:EyePos(),
				endpos = ply:EyePos() + ply:GetAimVector() * 85,
				filter = ply,
			})
			local drop = DarkRP.createMoneyBag(tr.HitPos, taken, ply)
			drop.droppedBy = ply

		end)

	end,
	aliases = {'/moneyput'},
})