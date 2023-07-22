octochat.registerCommand('/spectate', {
	cooldown = 1.5,
	execute = function(ply, txt) ply:ConCommand('FSpectate ' .. txt) end,
	aliases = {'!spectate', '~spectate'},
	permission = 'FSpectate',
})

octochat.registerCommand('/spawn', {
	cooldown = 1.5,
	log = true,
	consoleFriendly = true,
	execute = function(ply, txt)
		local target = txt == '' and ply or util.FindPlayer(txt)
		if not IsValid(target) then return L.player_not_found end

		if target:Alive() then target:KillSilent() end
		target:SetNetVar('_SpawnTime', CurTime())

		target:Notify(L.you_rescued:format(octochat.safePlayerName(ply)))
		octochat.safeNotify(ply, L.you_rescued_by:format(target:Nick()))
	end,
	aliases = {'/respawn'},
	check = DarkRP.isAdmin,
})

octochat.registerCommand('/addjailpos', {
	execute = function(ply)
		dbgPolice.addJailPos(ply:GetPos())
		ply:Notify('Позиция тюрьмы добавлена')
	end,
	check = DarkRP.isSuperAdmin,
})

octochat.registerCommand('/clearjailpos', {
	execute = function(ply)
		dbgPolice.clearJailPos()
		ply:Notify('Позиции тюрьмы очищены')
	end,
	check = DarkRP.isSuperAdmin,
})
octochat.registerCommand('/resetname', {
	log = true,
	consoleFriendly = true,
	execute = function(ply, txt)
		local target = txt == '' and ply or util.FindPlayer(txt)
		if not IsValid(target) then return L.player_not_found end

		local name = L.names[1][math.random(#L.names[1])] .. ' ' .. L.names[2][math.random(#L.names[2])]
		target:SetName(name)
		target:Notify('ooc', 'Администрация посчитала твое ролевое имя нарушающим правила и сбросила его. Ты можешь поставить новое и сменить персонажа')
		target:ConCommand('dbg_name "' .. name .. '"')
		octochat.safeNotify(ply, 'hint', 'Ролевое имя игрока сменено на ' .. name)
	end,
	check = DarkRP.isAdmin,
})
octochat.registerCommand('/resetdesc', {
	log = true,
	consoleFriendly = true,
	execute = function(ply, txt)
		local target = txt == '' and ply or util.FindPlayer(txt)
		if not IsValid(target) then return L.player_not_found end

		target:SetNetVar('dbgDesc')
		target:Notify('ooc', 'Администрация посчитала твое описание внешности нарушающим правила и сбросила его. Ты можешь поставить новое и сменить персонажа')
		octochat.safeNotify(ply, 'hint', 'Описание внешности игрока "' .. target:Name() .. '" сброшено')
	end,
	check = DarkRP.isAdmin,
})

octochat.registerCommand('/forceunlock', {
	execute = function(ply)
		local door = ply:GetEyeTrace().Entity
		if not IsValid(door) or not door:IsDoor() then
			return L.must_be_looking_at:format(L.door)
		end
		door:DoUnlock()
		ply:Notify('Открыто')
	end,
	check = DarkRP.isAdmin,
})

octochat.registerCommand('/forcelock', {
	execute = function(ply)
		local door = ply:GetEyeTrace().Entity
		if not IsValid(door) or not door:IsDoor() then
			return L.must_be_looking_at:format(L.door)
		end
		door:DoLock()
		ply:Notify('Закрыто')
	end,
	check = DarkRP.isAdmin,
})

octochat.registerCommand('/forceown', {
	execute = function(ply, _, args)
		if not args[1] or args[1] == '' then return 'Формат: /forceown "Ник игрока"' end
		local door = ply:GetEyeTrace().Entity
		if not IsValid(door) or not door:IsDoor() then
			return L.must_be_looking_at:format(L.door)
		end
		local tgt = octochat.findPlayer(args[1])
		if not tgt then return 'Укажи ник игрока' end
		door:SetPlayerOwner(tgt)
		ply:Notify('Теперь ' .. tgt:Name() .. ' владеет помещением')
	end,
	check = DarkRP.isAdmin,
})

octochat.registerCommand('/forceunown', {
	execute = function(ply)
		local door = ply:GetEyeTrace().Entity
		if not IsValid(door) or not door:IsDoor() then
			return L.must_be_looking_at:format(L.door)
		end
		local cur = door:GetPlayerOwner()
		if not cur then return 'Этой дверью не владеет игрок' end
		door:RemoveOwner(cur)
		local tgt = player.GetBySteamID(cur)
		ply:Notify('Теперь ' .. (IsValid(tgt) and tgt:Name() or cur) .. ' не владеет помещением')
	end,
	check = DarkRP.isAdmin,
})

octochat.registerCommand('/groupown', {
	execute = function(ply, id)
		local door = ply:GetEyeTrace().Entity
		if not IsValid(door) or not door:IsDoor() then
			return L.must_be_looking_at:format(L.door)
		end
		if not dbgDoorGroups.groups[id] then return 'Такой группы не существует' end
		if door:AddGroupOwner(id) then
			ply:Notify('Теперь ' .. dbgDoorGroups.groups[id] .. ' владеет помещением')
		end
	end,
	check = DarkRP.isSuperAdmin,
})

octochat.registerCommand('/groupunown', {
	execute = function(ply, id)
		local door = ply:GetEyeTrace().Entity
		if not IsValid(door) or not door:IsDoor() then
			return L.must_be_looking_at:format(L.door)
		end
		if not dbgDoorGroups.groups[id] then return 'Такой группы не существует' end
		if door:RemoveOwner('g:' .. id) then
			ply:Notify('Теперь ' .. dbgDoorGroups.groups[id] .. ' не владеет помещением')
		end
	end,
	check = DarkRP.isSuperAdmin,
})

octochat.registerCommand('/jobown', {
	execute = function(ply, cmd)
		local door = ply:GetEyeTrace().Entity
		if not IsValid(door) or not door:IsDoor() then
			return L.must_be_looking_at:format(L.door)
		end
		local job = DarkRP.getJobByCommand(cmd)
		if not job then return 'Такой профессии не существует' end
		if door:AddJobOwner(cmd) then
			ply:Notify('Теперь ' .. job.name .. ' владеет помещением')
		end
	end,
	check = DarkRP.isSuperAdmin,
})

octochat.registerCommand('/jobunown', {
	execute = function(ply, cmd)
		local door = ply:GetEyeTrace().Entity
		if not IsValid(door) or not door:IsDoor() then
			return L.must_be_looking_at:format(L.door)
		end
		local job = DarkRP.getJobByCommand(cmd)
		if not job then return 'Такой професии не существует' end
		if door:RemoveOwner('j:' .. cmd) then
			ply:Notify('Теперь ' .. job.name .. ' не владеет помещением')
		end
	end,
	check = DarkRP.isSuperAdmin,
})


--
-- INVISIBILITY
--
octochat.registerCommand('!invisible', {
	cooldown = 1.5,
	execute = function(ply)
		local val = not ply:IsInvisible()
		ply.manualInvisibility = val or nil
		ply:MakeInvisible(val)
	end,
	aliases = {'~invisible', '/invisible', '!cloak', '~cloak', '/cloak'},
	permission = 'Invisible',
})


--
-- ADMINTELL
--
local function fillInForm(ply, target, time, title, msg)
	local isPlayer = target ~= nil

	octolib.request.send(ply, {
		{name = L.request_player, desc = 'Оставь заголовок и текст уведомления пустыми, если хочешь скрыть текущее уведомление у игрока'},
		{type = 'numSlider', min = 3, max = 120, dec = 0, txt = L.time, default = time or 10},
		{type = 'strShort', ph = L.title2, default = title},
		{type = 'strLong', ph = L.trigger_text, default = msg},
	}, function(data)

		if not istable(data) then return end
		if not (isnumber(data[2]) and isstring(data[3]) and isstring(data[4])) then return end

		if not IsValid(target) and isPlayer then
			if IsValid(ply) then ply:Notify('warning', 'Игрок вышел') end
			return
		end

		hook.Run('dbg-admin.tell', ply, data[2], data[3], data[4], target)
		octolib.notify.send(target, 'admin', data[2], data[3], data[4])

	end)

end

octochat.registerCommand('/admintell', {
	consoleFriendly = true,
	execute = function(ply, _, args)
		local target, txt = octochat.pickOutTarget(args)
		if not IsValid(target) then return txt or 'Не удалось найти такого игрока' end

		args = octochat.explodeArg(txt)
		local time, title, msg = tonumber(args[2] or ''), args[3] or '', table.concat(args, ' ', 4) or ''
		if not time or (title == '' and msg == '') then
			if not IsValid(ply) then return 'Формат: /admintell "Ник игрока" Время "Заголовок" "Сообщение"' end
			fillInForm(ply, target, time, title, msg)
		else
			hook.Run('dbg-admin.tell', ply, time, title, msg, target)
			octolib.notify.send(target, 'admin', time, title, msg)
		end

	end,
	check = DarkRP.isAdmin,
})

octochat.registerCommand('/admintellall', {
	consoleFriendly = true,
	execute = function(ply, _, args)

		local time, title, msg = tonumber(args[1] or ''), args[2] or '', table.concat(args, ' ', 3) or ''
		if not time or (title == '' and msg == '') then
			if not IsValid(ply) then return 'Формат: /admintellall Время "Заголовок" "Сообщение"' end
			fillInForm(ply, nil, time, title, msg)
		else
			hook.Run('dbg-admin.tell', ply, time, title, msg)
			octolib.notify.sendAll('admin', time, title, msg)
		end

	end,
	check = DarkRP.isAdmin,
})


--
-- TEAM BAN/UNBAN
--
octochat.registerCommand('/teamban', {
	execute = function()
		return 'Команда временно не работает'
	end,
	check = DarkRP.isAdmin,
})

octochat.registerCommand('/teamunban', {
	execute = function()
		return 'Команда временно не работает'
	end,
	check = DarkRP.isAdmin,
})
