local maxFamilyDisplay = 20

local function notifyDiscord(admin, sid, ban, reason)
	local permanent = ban.endTime <= 0
	local console = not IsValid(admin)
	octolib.func.chain({

		function(nxt)
			octolib.getDBVar(sid, 'family', {}):Then(nxt):Catch(ErrorNoHalt)
		end,

		function(nxt, family)

			local toCheck = { util.SteamIDTo64(sid) }
			if not console then toCheck[#toCheck + 1] = admin:SteamID64() end
			local familySize = 1
			for i, v in ipairs(family) do
				if v ~= sid then
					toCheck[#toCheck + 1] = util.SteamIDTo64(v)
					familySize = familySize + 1
				end
				if familySize > maxFamilyDisplay then break end -- check only 10 first family members
			end
			octolib.getSteamData(toCheck, nxt)

		end,

		function(nxt, response)

			local steamData = { -- change data format for convenience
				target = response[1],
				admin = not console and response[2] or nil,
				family = {},
			}
			for i = (console and 2 or 3), #response do
				steamData.family[#steamData.family + 1] = response[i]
			end

			local embed = {
				author = {
					name = steamData.admin and steamData.admin.name or 'Console',
					icon_url = steamData.admin and steamData.admin.avatar or 'https://cdn.octothorp.team/img/logo/white.png',
					url = steamData.admin and ('https://steamcommunity.com/profiles/' .. steamData.admin.steamid64) or 'https://panel.octothorp.team/',
				},
				title = steamData.target.name,
				url = 'https://steamcommunity.com/profiles/' .. steamData.target.steamid64,
				description = 'Игроку в ' .. (permanent and 'перманентной ' or '') .. 'блокировке выдан разбан',
				thumbnail = { url = steamData.target.avatar },
				fields = {
					{
						name = 'SteamID',
						value = steamData.target.steamid,
					}, {
						name = 'Блокировку выдал',
						value = ban.admin,
					}, {
						name = 'Причина блокировки',
						value = ban.reason,
					}, {
						name = 'Причина снятия блокировки',
						value = reason or 'Не указана',
					}, {
						name = 'Примерное время в блокировке',
						value = octolib.time.formatDuration(os.time() - ban.startTime),
					},
				},
			}
			if not permanent then
				table.insert(embed.fields, 3, {
					name = 'Примерный срок блокировки',
					value = octolib.time.formatDuration(ban.endTime - ban.startTime),
				})
			end

			for i, member in ipairs(steamData.family) do
				embed.fields[#embed.fields + 1] = {
					name = 'Связанный аккаунт #' .. i,
					value = '[' .. member.name .. '](https://steamcommunity.com/profiles/' .. member.steamid64 .. ')\n' .. member.steamid,
					inline = true,
				}
			end

			if #steamData.family == maxFamilyDisplay then
				embed.footer = {
					text = ('Отображаются только первые %s связанных аккаунтов. Полный список можно посмотреть на https://octothorp.team/admin/octolib-vars'):format(maxFamilyDisplay),
					icon_url = 'https://img.icons8.com/color/48/asterisk.png',
				}
			end

			if CFG.webhooks.unban then
				octoservices:post('/discord/webhook/' .. CFG.webhooks.unban, {
					content = permanent and CFG.adminMention or nil,
					embeds = { embed },
				}):Catch(function(err)
					octolib.msg('Error getting Steam data: %s', err)
				end)
			end
		end,
	})
end

local function requestConsent(admin, sid, ban, reason)
	octolib.getDBVar(sid, 'family', {}):Then(function(family)
		if not IsValid(admin) then return end
		netstream.Start(admin, 'dbg-unban.consent', {
			target = sid,
			admin = ban.admin,
			reason = ban.reason,
			length = ban.endTime > 0 and (ban.endTime - ban.startTime) or 0,
			spent = os.time() - ban.startTime,
			family = family,
			unbanReason = reason or nil,
		})
	end)
end

local function requestConsoleConsent(sid, ban, reason)
	octolib.func.chain({

		function(nxt)
			octolib.getDBVar(sid, 'family', {}):Then(nxt):Catch(ErrorNoHalt)
		end,

		function(nxt, family)
			local toCheck = { util.SteamIDTo64(sid) }
			local size = 1
			for i, v in ipairs(family) do
				if v ~= sid then
					toCheck[#toCheck + 1] = util.SteamIDTo64(v)
					size = size + 1
				end
				if size > maxFamilyDisplay then break end -- check only 10 first family members
			end
			octolib.getSteamData(toCheck, nxt)
		end,

		function(nxt, response)

			local steamData = { -- change data format for convenience
				target = response[1],
				family = {},
			}
			for i = 2, #response do
				steamData.family[#steamData.family + 1] = response[i]
			end

			octolib.msg('=================================')
			octolib.msg('Ты собираешься разбанить игрока, находящегося в блокировке')
			octolib.msg('Пожалуйста, проверь всю информацию о нем, чтобы убедиться в отсутствии последствий')
			octolib.msg('Ник игрока: %s', steamData.target.name)
			octolib.msg('SteamID: %s', steamData.target.steamid)
			octolib.msg('Ссылка на профиль: https://steamcommunity.com/profiles/%s', steamData.target.steamid64)
			octolib.msg('Блокировку выдавал админ: %s', ban.admin)
			if ban.endTime > 0 then
				octolib.msg('Примерная длительность блокировки: %s', octolib.time.formatDuration(ban.endTime - ban.startTime))
			else
				octolib.msg('БЛОКИРОВКА БЕССРОЧНАЯ! Особенно внимательно просмотри связанные аккаунты')
			end
			octolib.msg('Причина блокировки: %s', ban.reason)
			octolib.msg('Причина снятия блокировки: %s', reason)
			octolib.msg('Примерное время в блокировке: %s', octolib.time.formatDuration(os.time() - ban.startTime))

			if steamData.family[1] then
				octolib.msg('Связанные аккаунты:')
				for _, member in ipairs(steamData.family) do
					octolib.msg('- %s, %s, https://steamcommunity.com/profiles/%s', member.name, member.steamid, member.steamid64)
				end
				if #steamData.family == maxFamilyDisplay then
					octolib.msg('(Отображаются только первые %s связанных аккаунтов, полный список на https://octothorp.team/admin/octolib-vars)', maxFamilyDisplay)
				end
			else octolib.msg('Связанные аккаунты: отсутствуют') end

			octolib.msg('Введи эту команду еще раз, чтобы выдать разбан. Об этом будет уведомлена старшая администрация')
			octolib.msg('sg unban "%s" "%s"', sid, reason)
			octolib.msg('=================================')

		end,

	})

end

-- consents['admin steamid'] = 'last target steamid allowed to unban'
-- consoleConsents['target steamid allowed to unban'] = true
local consents, consoleConsents = {}, {}

hook.Add('serverguard.PreventPlayerUnban', 'dbg-security.unbanConfirmation', function(sid, admin, reason)

	local ban = serverguard.banTable[sid]
	local asid = IsValid(admin) and admin:SteamID() or false
	if not ban or (ban.endTime > 0 and ban.endTime <= os.time()) then
		consents[asid] = nil -- player is not banned permanently
		if asid then admin:Notify('warning', 'Этот игрок не заблокирован')
		else octolib.msg('Этот игрок не заблокирован') end
		return
	end

	if IsValid(admin) then

		if ban.endTime <= 0 and not admin:query('Unban permanently banned players') then
			admin:Notify('warning', 'Обратись к старшей администрации, чтобы снять перманентные блокировки')
			return true -- prevent unban
		end
		if consents[asid] ~= sid then
			requestConsent(admin, sid, ban, reason)
			return true -- prevent unban for now
		end
		consents[asid] = nil
		notifyDiscord(admin, sid, ban, reason)

	else

		if not consoleConsents[sid] then
			requestConsoleConsent(sid, ban, reason)
			consoleConsents[sid] = true
			timer.Simple(120, function() -- console has to re-enter unban command in 2 minutes
				consoleConsents[sid] = nil
			end)
			return true -- prevent unban for now
		else
			notifyDiscord(nil, sid, ban, reason)
			consoleConsents[sid] = nil
		end

	end
end)

hook.Add('serverguard.PlayerBannedBySteamID', 'dbg-security.rebanCheck', function(sid, len, reason, admin)
	local ban = serverguard.banTable[sid]
	if not ban then return end

	if ban.endTime <= 0 or (ban.endTime - os.time()) >= (len - 1) * 60 then
		if IsValid(admin) then
			admin:Notify('warning', 'Сначала разбань этого игрока, затем выдай ему бан повторно')
		else
			octolib.msg('Сначала разбань этого игрока, затем выдай ему бан повторно')
		end
		return true
	end
end)

netstream.Hook('dbg-unban.consent', function(ply, sid, reason)
	if not (octolib.string.isSteamID(sid) and ply:query('Unban')) then return end
	local ban = serverguard.banTable[sid]
	if not ban then return end
	if not (ban.endTime > 0 or ply:query('Unban permanently banned players')) then return end
	consents[ply:SteamID()] = sid
	ply:ConCommand(('sg unban "%s" "%s"'):format(sid, reason))
end)
