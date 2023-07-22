local function blockInput(ply, block)
	ply:Freeze(block)
	ply.blockedInput = block or nil
end

local dontBanSteamIDs = {} -- store last banned ids to avoid infinite loops
local function queueTimer()
	timer.Create('octobans.recursionFix', 10, 0, function() table.Empty(dontBanSteamIDs) end)
end

local function banFamily(doBan, ply, time, reason)
	reason = reason or 'No reason'
	local sid = isstring(ply) and ply or IsValid(ply) and ply:SteamID()

	if dontBanSteamIDs[sid] then return end
	dontBanSteamIDs[sid] = true

	octolib.family.getBySteamID(sid, function(family)
		if not family then return end

		for _, familySid in ipairs(family.steamids) do
			familySid = util.SteamIDFrom64(familySid)

			if familySid == sid or dontBanSteamIDs[familySid] then continue end
			dontBanSteamIDs[familySid] = true

			if doBan then
				octolib.msg('Banning linked account: %s -> %s', sid, familySid)
				RunConsoleCommand('sg', 'ban', familySid, tostring(math.floor(time)), L.ban_on_another_account .. reason)
			else
				octolib.msg('Unbanning linked account: %s -> %s', sid, familySid)
				serverguard:UnbanPlayer(familySid, nil, nil, true)
			end
		end
	end)

	queueTimer()
end
hook.Add('serverguard.PlayerBanned', 'octobans', function(ply, time, reason, admin) banFamily(true, ply, time, reason) end)
hook.Add('serverguard.PlayerBannedBySteamID', 'octobans', function(sID, time, reason, admin) banFamily(true, sID, time, reason) end)
hook.Add('serverguard.PlayerUnbanned', 'octobans', function(sID, admin) banFamily(false, sID) end)

hook.Add('octolib.family.mergedByHwid', 'octobans', function(families)
	local steamids = octolib.array.reduce(families, function(steamids, family)
		return table.Add(steamids, octolib.array.map(family.steamids, util.SteamIDFrom64))
	end, {})

	octolib.db:RunQuery([[
		SELECT * FROM ]] .. CFG.db.admin .. [[.serverguard_bans
		WHERE steam_id IN (']] .. table.concat(steamids, '\',\'') .. [[')]],
	function(q, st, rows)
		if #rows < 1 then return end

		local longestBan = rows[1]
		for _, ban in ipairs(rows) do
			if ban.end_time == 0 then
				longestBan = ban
				break
			end

			if ban.end_time > longestBan.end_time then
				longestBan = ban
			end
		end

		if longestBan then
			local time = longestBan.end_time == 0 and 0 or math.ceil((longestBan.end_time - os.time()) / 60)
			for _, sid in ipairs(steamids) do
				dontBanSteamIDs[sid] = true
				queueTimer()

				RunConsoleCommand('sg', 'ban', sid, tostring(math.floor(time)), 'Бан по связи: ' .. longestBan.reason)
			end
		end
	end)
end)

hook.Add('PlayerFinishedLoading', 'octobans', function(ply)
	if not ply.restrictedFromPlaying then return end
	netstream.Start(ply, 'octobans', ply.restrictedFromPlaying)
end)

local noReport = octolib.array.toKeys {'RU','KZ','UA','BY','LT','LV','EE','MD','GE','AM','AZ','UZ','TM'}
hook.Add('octolib.ipInfo', 'octobans', function(ply, info)
	if not info or not IsValid(ply) then return end

	if info.isp and info.isp:lower():find('nvidia') then
		blockInput(ply, true)
		ply.restrictedFromPlaying = 'Привет! На нашем сервере запрещена игра через GeForce NOW, так как он конфликтует с нашей системой обнаружения обходов бана. Единственный выход из данной ситуации – не использовать этот сервис. Приносим свои извинения за неудобства, но это необходимо для поддержания честной игры'
	end

	if CFG.webhooks.cheats and info.countryCode and not noReport[info.countryCode] then
		octoservices:post('/discord/webhook/' .. CFG.webhooks.cheats, {
			username = GetHostName(),
			embeds = {{
				title = 'Подключение из ' .. (info.country or info.countryCode),
				fields = {{
					name = L.player,
					value = ply:GetName() .. '\n[' .. ply:SteamID() .. '](' .. 'https://steamcommunity.com/profiles/' .. ply:SteamID64() .. ')',
				}},
			}},
		})
	end
end)
