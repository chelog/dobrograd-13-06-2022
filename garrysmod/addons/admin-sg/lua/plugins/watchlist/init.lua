local plugin = plugin;

plugin:IncludeFile('shared.lua', SERVERGUARD.STATE.SHARED);
plugin:IncludeFile('sh_commands.lua', SERVERGUARD.STATE.SHARED);

local function removeExpired(wls)
	local ct, changed = os.time(), false
	for i = #wls, 1, -1 do
		local v = wls[i]
		if v[4] == '' then continue end
		local d, m, y = v[4]:match('(%d%d)%.(%d%d)%.(%d%d%d%d)')
		if not (d and m and y) or os.time({day = tonumber(d), month = tonumber(m), year = tonumber(y)}) <= ct then
			table.remove(wls, i)
			changed = true
		end
	end
	return changed
end

local function checkDate(d, m, y)
	if m < 1 or m > 12 then return false end
	if d < 1 or d > 31 then return false end
	if (m == 4 or m == 6 or m == 9 or m == 11) and d > 30 then return false end
	if m == 2 then
		if not (y % 400 == 0 or y % 100 ~= 0 and y % 4 == 0) and d > 28 then return false end
		if d > 29 then return false end
	end
	return true
end

netvars.Register('watchList', {
	checkAccess = function(ply)
		return ply:query('DBG: WatchLists')
	end,
})

function plugin:OpenEditor(admin, target)
	if not octolib.string.isSteamID(target) and target ~= 'BOT' then
		return admin:Notify('warning', 'Укажи ник онлайн-игрока или SteamID')
	end
	if admin == target then
		admin:Notify('warning', 'Любишь быть в центре внимания?')
		return
	end
	octolib.getDBVar(target, 'wls', {}):Then(function(wls)
		if removeExpired(wls) then
			octolib.setDBVar(target, 'wls', wls)
		end
		octolib.entries.gui(admin, 'Watchlist\'ы игрока ' .. target, {
			fields = {
				{
					name = 'Краткое описание*',
					desc = 'Название нарушения, сколько дней накидывать к бану',
					type = 'strShort',
					len = 32,
					required = true,
				},
				{
					name = 'Подробное описание',
					desc = 'Что сделал игрок, чтобы получить Watchlist? Опиши одной-двумя фразами',
					type = 'strLong',
					len = 128,
					tall = 60,
					ph = 'Расстрелял двух офицеров за отказ брать взятку. Запрет на игру крайм-профессий',
				},
				{
					name = 'Кем выдан*',
					type = 'strShort',
					required = true,
					len = 16,
					ph = 'Wani4ka',
				},
				{
					name = 'До какой даты действителен',
					desc = 'В этот день Watchlist снимется автоматически. Можно оставить пустым',
					type = 'strShort',
					numeric = true,
					ph = 'ДД.ММ.ГГГГ',
				},
			},
			labelIndex = 1,
			entries = wls,
		}, function(res)
			if not istable(res) then return end
			if #res > 10 then
				return admin:Notify('warning', 'Не более 10 одновременно действующих Watchlist\'ов')
			end
			local ct, ctstr = os.time(), os.date('%d.%m.%Y')
			for _,v in ipairs(res) do
				v[1] = utf8.sub(string.Trim(v[1] or ''), 1, 32)
				v[2] = utf8.sub(string.Trim(v[2] or ''), 1, 128)
				v[3] = utf8.sub(string.Trim(v[3] or ''), 1, 16)
				v[4] = utf8.sub(string.Trim(v[4] or ''), 1, 10)
				if v[1] == '' then
					return admin:Notify('warning', v[1], ': Краткое описание Watchlist\'а не должно быть пустым')
				end
				if v[3] == '' then
					return admin:Notify('warning', v[1], ': Укажи, кем выдан этот Watchlist')
				end
				if v[4] ~= '' then
					local d, m, y = v[4]:match('^(%d%d)%.(%d%d)%.(%d%d%d%d)$')
					if not (d and m and y) then
						return admin:Notify('warning', v[1], ': Укажи правильную дату окончания действия или оставь это поле пустым')
					end
					d, m, y = tonumber(d), tonumber(m), tonumber(y)
					if not (d and m and y) then
						return admin:Notify('warning', v[1], ': Укажи правильную дату окончания действия или оставь это поле пустым')
					end
					if not checkDate(d, m, y) then
						return admin:Notify('warning', v[1], ': Укажи правильную дату окончания действия или оставь это поле пустым')
					end
					if os.time({day = tonumber(d), month = tonumber(m), year = tonumber(y)}) < ct and v[4] ~= ctstr then
						return admin:Notify('warning', v[1], ': Дата окончания действия задним числом')
					end
				end
			end
			if not res[1] then res = nil end
			octolib.setDBVar(target, 'wls', res):Then(function()
				admin:Notify('Watchlist\'ы игрока ' .. target .. ' сохранены')

				local ply = player.GetBySteamID(target)
				if IsValid(ply) then
					ply:SetNetVar('watchList', res and #res or nil)
				end
			end)
		end)
	end)
end

hook.Add('octolib.dbvars-loaded', 'dbg-watch.remove', function(ply)
	local wls = ply:GetDBVar('wls')
	if not wls then return end
	if removeExpired(wls) then
		ply:SetDBVar('wls', wls[1] and wls or nil)
	end
	ply:SetNetVar('watchList', wls[1] and #wls or nil)

	if #wls > 0 then
		local admins = {}
		for _,v in ipairs(player.GetAll()) do
			if v:IsAdmin() then admins[#admins + 1] = v end
		end
		serverguard.Notify(admins, SGPF('watchlist', ply:Name(), ply:SteamID()))
		for _,v in ipairs(wls) do
			serverguard.Notify(admins, SGPF('watchlist_note', v[1]))
		end
	end
end)
