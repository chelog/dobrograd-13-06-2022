local function niceTime(time)

	local h, m, s
	h = math.floor(time / 60 / 60)
	m = math.floor(time / 60) % 60
	s = math.floor(time) % 60

	return string.format("%02i:%02i:%02i", h, m, s)

end

local function sendOOC(ply, txt)
	txt = txt:gsub('\n', ' ')
	if ply:IsAdmin() then
		octochat.talkTo(nil, octochat.textColors.ooc, ('[OOC] %s (%s): '):format(ply:SteamName(), ply:Name()), color_white, unpack(octolib.string.splitByUrl(txt)))
	else
		octochat.talkTo(nil, octochat.textColors.ooc, ('[OOC] %s (%s): '):format(ply:SteamName(), ply:Name()), color_white, txt)
	end
end

octochat.registerCommand('/ooc', {
	log = true,
	execute = function(ply, txt, _, cmd)
		local can, why = hook.Run('PlayerCanOOC', ply, txt)
		if can == false then
			return why or false
		end

		netstream.Start(ply, 'octochat.ooc', txt, ply:GetCooldown('ooc') and math.ceil(ply:GetCooldown('ooc') - CurTime()) or 0)
	end,
	aliases = {'//', '/a'},
})

netstream.Hook('octochat.ooc', function(ply, txt)
	local nextOOC = ply:GetCooldown('ooc')
	if nextOOC then return ply:Notify('warning', 'Следующее сообщение в ООС-чат можно будет отправить через ' .. niceTime(nextOOC - CurTime())) end
	if txt == '' then return ply:Notify('warning', 'Формат: ' .. cmd .. ' Текст сообщения') end

	sendOOC(ply, txt)
	if not ply:query('DBG: Нет ограничения на OOC') then
		ply:TriggerCooldown('ooc', 30 * 60)
	end
end)

octochat.registerCommand('/looc', {
	cooldown = 1.5,
	log = true,
	cooldownBypass = 'DBG: Нет ограничения на OOC',
	execute = function(ply, txt, _, cmd)
		if txt == '' then return 'Формат: ' .. cmd .. ' Текст сообщения' end

		if ply:IsAdmin() then
			octochat.talkToRange(ply, 250, octochat.textColors.ooc, ('[LOOC] %s (%s): '):format(ply:SteamName(), ply:Name()), color_white, unpack(octolib.string.splitByUrl(txt)))
		else
			octochat.talkToRange(ply, 250, octochat.textColors.ooc, ('[LOOC] %s (%s): '):format(ply:SteamName(), ply:Name()), color_white, txt)
		end
	end,
	aliases = {'/'},
})

octochat.registerCommand('/pm', {
	cooldown = 3,
	log = true,
	cooldownBypass = 'DBG: Нет ограничения на OOC',
	execute = function(ply, _, args)
		local target, txt = octochat.pickOutTarget(args)
		if not target then return txt or 'Формат: /pm "Имя игрока" Текст сообщения' end
		if txt == '' then return 'Формат: /pm "Имя игрока" Текст сообщения' end

		if ply:IsAdmin() then
			octochat.talkTo(target, octochat.textColors.ooc, ('[PM] от %s (%s): '):format(ply:SteamName(), ply:Name()), Color(250,250,200), unpack(octolib.string.splitByUrl(txt)))
			octochat.talkTo(ply, octochat.textColors.ooc, ('[PM] для %s (%s): '):format(target:SteamName(), target:Name()), Color(250,250,200), unpack(octolib.string.splitByUrl(txt)))
		else
			octochat.talkTo(target, octochat.textColors.ooc, ('[PM] от %s (%s): '):format(ply:SteamName(), ply:Name()), Color(250,250,200), txt)
			octochat.talkTo(ply, octochat.textColors.ooc, ('[PM] для %s (%s): '):format(target:SteamName(), target:Name()), Color(250,250,200), txt)
		end
	end,
})

octochat.registerCommand('/demote', {
	cooldown = 80,
	execute = function(ply, _, args)

		if not args[1] or args[1] == '' or not args[2] or args[2] == '' then
			return 'Формат: /demote "Ник игрока" Причина увольнения'
		end

		local target, reason = octochat.pickOutTarget(args)
		if not IsValid(target) then return reason or 'Такой игрок не найден' end
		if target == ply then return L.cant_demote_self end

		if utf8.len(reason) > 100 then return L.unable:format('указать такую причину', 'Она должна быть покороче') end

		local canDemote, message = hook.Run('canDemote', ply, target, reason)
		if canDemote == false then return message or L.unable:format('уволить этого игрока', '') end

		if target:getJobTable().candemote == false then return L.unable:format('уволить этого игрока', '') end

		local recipients = octolib.array.filter(player.GetAll(), function(v) return v ~= p and v ~= ply end)
		target.IsBeingDemoted = octolib.questions.start({
			text = L.demote_vote_text:format(ply:Name(), target:Name(), reason),
			recipients = recipients,
			spectators = {ply, target},
			time = 20,
			onFinish = function(result)
				if not IsValid(target) then return end
				target.IsBeingDemoted = nil

				if result > 0 then
					if target:Alive() then
						target:changeTeam(GAMEMODE.DefaultTeam, true)
						if target:isArrested() then
							target:arrest()
						end
					else
						target.demotedWhileDead = true
					end

					hook.Run('onPlayerDemoted', ply, target, reason)
					octolib.notify.sendAll(L.demoted:format(target:Nick()))
				else
					octolib.notify.sendAll('warning', L.demoted_not:format(target:Nick()))
				end
			end,
		})
		octolib.notify.sendAll(L.demote_vote_started:format(ply:Nick(), target:Nick()))

	end,
})
