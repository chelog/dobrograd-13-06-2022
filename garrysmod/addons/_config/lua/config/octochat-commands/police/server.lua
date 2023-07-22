local leaveMeAloneID = 0
octochat.registerCommand('/callhelp', {
	cooldown = 60,
	log = true,
	execute = function(ply, txt)
		if txt == '' then return 'Формат: /callhelp Текст сообщения' end

		ply:DoEmote('{name} запрашивает подкрепление')

		local marker = {
			id = 'cpSupport' .. leaveMeAloneID,
			group = 'cpSupport',
			txt = 'Подкрепление',
			pos = ply:GetPos() + Vector(0,0,40),
			col = Color(102,170,170),
			des = {'timedist', { 600, 300 }},
			icon = 'octoteam/icons-16/exclamation.png',
		}
		for _,v in ipairs(player.GetAll()) do
			if v:isEMS() then
				octochat.talkTo(v, octochat.textColors.rp, '[Подкрепление] ', ply:Name(), ': ', color_red, txt)
				v:EmitSound('ambient/chatter/cb_radio_chatter_' .. math.random(1,3) .. '.wav', 45, 100, 0.5)
				v:AddMarker(marker)
			end
		end
		leaveMeAloneID = leaveMeAloneID + 1

	end,
	check = DarkRP.isCop,
})

octochat.registerCommand('/cr', {
	cooldown = 30,
	phone = true,
	execute = function(ply, txt)
		if txt == '' then return 'Формат: /cr Текст вызова' end
		local ph = ply:AtStationaryPhone()
		DarkRP.callEMS(ply, ph and ph:GetNick() or ply:Name(), txt)
	end,
})

octochat.registerCommand('/warrant', {
	execute = function(ply, _, args)

		local target, txt = octochat.pickOutTarget(args)
		if not IsValid(target) then return txt or 'Такой игрок не найден' end
		if utf8.len(txt) < 10 then return 'Укажи причину обыска' end
		if target.warranted then return L.already_a_warrant end

		local can, message = hook.Run('canRequestWarrant', target, ply, txt)
		if can == false then return message or 'Ты не можешь получить ордер на обыск этого игрока' end

		if not ply:getJobTable().mayor then -- No need to search through all the teams if the player is a mayor
			local mayors = {}
			for _,v in ipairs(player.GetAll()) do
				if v:getJobTable().mayor then
					mayors[#mayors + 1] = v
				end
			end
			if mayors[1] then
				octolib.questions.start({
					text = L.warrant_request:format(ply:Nick(), target:Nick(), txt),
					recipients = mayors,
					left = 'Одобрить',
					right = 'Отклонить',
					sound = 'Town.d1_town_02_elevbell1',
					time = 40,
					onFinish = function(res)
						if res <= 0 then
							ply:Notify('warning', L.warrant_denied)
						elseif IsValid(target) then
							target:warrant(txt)
						end
					end,
				})
			end
		else target:warrant(reason) end

	end,
	check = DarkRP.isCop,
})

octochat.registerCommand('/wanted', {
	execute = function(ply, _, args)

		local target, txt = octochat.pickOutTarget(args)
		if not IsValid(target) then return txt or 'Такой игрок не найден' end
		if utf8.len(txt) < 10 then return 'Укажи причину подачи в розыск' end
		if target:isWanted() then return L.already_wanted end
		if not target:Alive() or target:IsGhost() then return L.suspect_must_be_alive_to_do_x:format(L.make_someone_wanted) end
		if target:isArrested() then return L.suspect_already_arrested end

		local can, message = hook.Run('canWanted', target, ply, txt)
		if can == false then return message or 'Ты не можешь подать в розыск на этого игрока' end

		target:wanted(ply, txt)

	end,
	check = DarkRP.isCop,
})

octochat.registerCommand('/unwanted', {
	execute = function(ply, _, args)
		if not args[1] or args[1] == '' then return 'Ты не указал имя игрока!\nФормат: /unwanted "Ник игрока" "Причина"' end
		if not args[2] or args[2] == '' then return 'Ты не указал причину!\nФормат: /unwanted "Ник игрока" "Причина"' end

		local target, txt = octochat.pickOutTarget(args)
		if not IsValid(target) then return txt or 'Такой игрок не найден' end
		if not target:isWanted() then return L.not_wanted end

		local can, message = hook.Run('canUnwanted', target, ply)
		if can == false then return message or 'Ты не можешь отозвать розыск на этого игрока' end

		target:unWanted(ply, table.concat(args, ' ', 2))

	end,
	check = DarkRP.isCop,
})

local function isInCharge(msg)
	return function(ply)

		local mayor, chief, serg, cop
		for _,v in ipairs(player.GetAll()) do
			if v:isMayor() or v:GetActiveRank('gov') == 'worker' then
				mayor = true
				break
			elseif v:isChief() then
				chief = true
			elseif v:getJobTable().command == 'cop2' then
				serg = true
			elseif v:isCP() then cop = true end
		end

		if mayor then
			if not (ply:isMayor() or ply:GetActiveRank('gov') == 'worker') then return false, 'Сейчас ' .. msg .. ' может мэр' end
		elseif chief then
			if not ply:isChief() then return false, 'Сейчас ' .. msg .. ' может лейтенант полиции' end
		elseif serg then
			if ply:getJobTable().command ~= 'cop2' then return false, 'Сейчас ' .. msg .. ' может сержант полиции' end
		elseif cop then
			if not ply:isCP() then return false, 'Сейчас ' .. msg .. ' может сотрудник полиции' end
		elseif not ply:IsAdmin() then
			return false, 'Сейчас ' .. msg .. ' может только администратор'
		end

		return true

	end
end

octochat.registerCommand('/givelicense', {
	execute = function(ply, txt)

		local target = octolib.use.getTrace(ply).Entity
		if not IsValid(target) or not target:IsPlayer() then
			return L.must_be_looking_at:format('игрока')
		end

		target:Notify(L.gunlicense_granted:format(ply:Name(), target:Name()))
		ply:Notify(L.gunlicense_granted:format(ply:Name(), target:Name()))
		target:SetNetVar('HasGunlicense', txt or '')
		hook.Run('DarkRPGiveLicence', ply, target, txt or '')

	end,
	check = isInCharge('выдавать лицензии'),
})

octochat.registerCommand('/takelicense', {
	cooldown = 1.5,
	execute = function(ply)

		local target = octolib.use.getTrace(ply).Entity
		if not IsValid(target) or not target:IsPlayer() then
			return L.must_be_looking_at:format('игрока')
		end

		target:Notify(L.gunlicense_taken:format(ply:Name(), target:Name()))
		ply:Notify(L.gunlicense_taken:format(ply:Name(), target:Name()))
		target:SetNetVar('HasGunlicense')
		hook.Run('DarkRPTakeLicence', ply, target)

	end,
	check = isInCharge('отзывать лицензии'),
})

octochat.registerCommand('/carcheck', {
	cooldown = 1.5,
	execute = function(ply)

		octolib.request.send(ply, {{
			type = 'strShort',
			name = 'Номер автомобиля',
			desc = '6 или 7 символов. Только латинские буквы и цифры, без пробелов и дефисов',
			ph = carDealer.randomPlate(carDealer.plateLength),
			required = true,
		}}, function(data)

			local plate = data[1]
			if not isstring(plate) then return end
			if string.gsub(plate, '^[0-9a-zA-Z]+$', '') ~= '' then
				ply:Notify('warning', 'Только латинские буквы и цифры')
				return
			end
			if #plate < 6 or #plate > 7 then
				ply:Notify('warning', '6 или 7 символов')
				return
			end

			ply:DoEmote(L.emote_check)
			ply:DelayedAction('car_check', L.check_action, {
				time = 10,
				check = function() return IsValid(ply) and ply:isCP() end,
				succ = function()
					carDealer.getVehByPlate(plate, function(veh)
						if not IsValid(ply) then return end
						if not veh then
							return ply:Notify('Совпадений в базе не обнаружено')
						end

						if not octolib.string.isSteamID(veh.garage) then
							return ply:Notify('ooc', 'Эта машина не принадлежит игроку (скажи разработчикам)')
						end

						local msg = 'Владелец автомобиля с номером ' .. string.upper(plate) .. ': '
						octolib.getDBVar(veh.garage, 'lastRPName'):Then(function(var)
							if not IsValid(ply) then return end
							ply:Notify(msg .. var) -- to be tested
						end)
					end)

				end,
			})
		end)

	end,
	check = DarkRP.isCop,
})