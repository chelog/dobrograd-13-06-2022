octochat.registerCommand('/broadcast', {
	cooldown = 1.5,
	log = true,
	execute = function(_, txt)
		if txt == '' then return 'Формат: /broadcast Текст объявления' end
		octochat.talkTo(nil, Color(214,74,65), L.broadcast_text, Color(250,250,200), unpack(octolib.string.splitByUrl(txt)))
	end,
	check = DarkRP.isMayor,
})

-- LAWS
octochat.registerCommand('/addlaw', {
	log = true,
	execute = function(ply, txt)

		local can, why = hook.Run('canEditLaws', ply, 'addLaw', txt)
		if can == false then
			return why or 'Ты не можешь изменять законы'
		end

		if txt == '' then return 'Формат: /addlaw Текст закона' end

		if utf8.len(txt) < 10 then
			return L.law_too_short
		end

		local laws = netvars.GetNetVar('laws')

		if #laws >= 20 then
			return L.laws_full
		end

		laws[#laws + 1] = txt
		netvars.SetNetVar('laws', laws)

		hook.Run('addLaw', #laws, txt, ply)
		ply:Notify(L.law_added)

	end,
	check = DarkRP.isMayor,
})

octochat.registerCommand('/removelaw', {
	log = true,
	execute = function(ply, _, args)

		local can, why = hook.Run('canEditLaws', ply, 'removeLaw', txt)
		if can == false then
			return why or 'Ты не можешь изменять законы'
		end

		local laws = netvars.GetNetVar('laws')

		local i = tonumber(args[1])
		if not i or not laws[i] then
			return 'Неверный номер закона'
		end

		if GAMEMODE.Config.DefaultLaws[i] then
			return L.default_law_change_denied
		end

		local law = laws[i]
		table.remove(laws, i)
		netvars.SetNetVar('laws', laws)

		hook.Run('removeLaw', i, law, ply)
		ply:Notify(L.law_removed)

	end,
	check = DarkRP.isMayor,
})

octochat.registerCommand('/resetlaws', {
	consoleFriendly = true,
	log = true,
	execute = function(ply)

		if IsValid(ply) then
			local can, why = hook.Run('canEditLaws', ply, 'resetLaws')
			if can == false then
				return why or 'Ты не можешь изменять законы'
			end
		end

		hook.Run('resetLaws', ply)
		DarkRP.resetLaws()
		octochat.safeNotify(ply, L.law_reset)

	end,
	check = DarkRP.isMayor,
})

local function updateGMFuncs()
	if not DarkRP then return end

	function DarkRP.resetLaws()
		netvars.SetNetVar('laws', table.Copy(GAMEMODE and GAMEMODE.Config.DefaultLaws or {}))
	end
	DarkRP.resetLaws()

	function DarkRP.getLaws()
		return netvars.GetNetVar('laws')
	end

end
hook.Add('darkrp.loadModules', 'dbg-commands.laws', updateGMFuncs)
updateGMFuncs()

-- LOCKDOWN
local lastLockdown = -math.huge
local function updateGMFuncs()
	if not DarkRP then return end

	function DarkRP.lockdown()
		for _,v in ipairs(player.GetAll()) do
			v:ConCommand('play ' .. GAMEMODE.Config.lockdownsound .. '\n')
		end
		netvars.SetNetVar('lockdown', true)
		octolib.notify.sendAll('warning', L.lockdown_started)
	end

	function DarkRP.unLockdown()
		netvars.SetNetVar('lockdown', nil)
		lastLockdown = CurTime()
		octolib.notify.sendAll('hint', L.lockdown_ended)
	end

end
hook.Add('darkrp.loadModules', 'dbg-commands.lockdown', updateGMFuncs)
updateGMFuncs()


octochat.registerCommand('/lockdown', {
	execute = function(_, txt)

		if netvars.GetNetVar('lockdown') then
			return 'Комендантский час уже введен. Выполни /unlockdown, чтобы отменить его'
		end

		if not GAMEMODE.Config.lockdown then
			return 'Комендантский час отключен'
		end

		if lastLockdown > CurTime() - GAMEMODE.Config.lockdowndelay then
			return 'Комендантский час уже недавно вводился'
		end

		txt = string.Trim(txt)
		if txt ~= '' then
			octochat.talkTo(nil, Color(214,74,65), L.broadcast_text, Color(250,250,200), unpack(octolib.string.splitByUrl(txt)))
		end
		DarkRP.lockdown()

	end,
	check = DarkRP.isMayor,
})

octochat.registerCommand('/unlockdown', {
	execute = function()
		if not netvars.GetNetVar('lockdown') then
			return 'Сейчас не объявлен комендантский час. Выполни /lockdown, чтобы ввести его'
		end
		if not GAMEMODE.Config.lockdown then
			return 'Комендантский час отключен'
		end
		DarkRP.unLockdown()
	end,
	check = DarkRP.isMayor,
})

--
-- DOBROGRAD NAME
--

local names = L.town_names

local function updateServerName()
	if CFG.dev then
		RunConsoleCommand('hostname', CFG.defaultHostName or (L.build_town .. netvars.GetNetVar('cityName', L.dobrograd)))
	else
		local name = netvars.GetNetVar('cityName', L.dobrograd)
		if name == L.dobrograd then
			RunConsoleCommand('hostname', CFG.defaultHostName or names[game.GetMap()] or names.rp_eastcoast_v4c)
		else
			RunConsoleCommand('hostname', L.history_town .. name)
		end
	end
end
timer.Simple(5, updateServerName)

local function renameCity(name)
	name = name or L.dobrograd
	netvars.SetNetVar('cityName', name)
	octolib.notify.sendAll('ooc', L.name_town_change:format(name))
	updateServerName()
end

local function cleanUpAfterMayorLeft()
	if netvars.GetNetVar('cityName', L.dobrograd) ~= L.dobrograd then
		renameCity()
	end
	if netvars.GetNetVar('lockdown') then
		DarkRP.unLockdown()
	end
end

hook.Add('OnPlayerChangedTeam', 'dbg-mayor.resetCity', function(ply, before)
	if before ~= TEAM_MAYOR then return end
	if not ply:Alive() or ply:IsGhost() then return end
	cleanUpAfterMayorLeft()
end)
hook.Add('PlayerDeath', 'dbg-mayor.resetCity', function(ply)
	if not ply:isMayor() then
		ply:changeTeam(1, true, true)
		cleanUpAfterMayorLeft()
	end
end)
hook.Add('PlayerDisconnected', 'dbg-mayor.recetCity', function(ply)
	if ply:isMayor() then cleanUpAfterMayorLeft() end
end)

octochat.registerCommand('/renamecity', {
	cooldown = 1.5,
	log = true,
	execute = function(ply, name)

		if not ply:GetNetVar('os_dobro') then return L.this_feature_only_dobro end
		if not ply:canAfford(5000) then return L.not_enough_money2 end

		if name == '' then return 'Формат: /renamecity Название' end
		if utf8.len(name) > 31 then return L.title_too_long end

		renameCity(name)
		ply:addMoney(-5000)

	end,
	check = DarkRP.isMayor,
})

octochat.registerCommand('/resetcity', {
	cooldown = 1.5,
	log = true,
	consoleFriendly = true,
	execute = function(ply) renameCity() end,
	check = function(ply)
		return DarkRP.isMayor(ply) or ply:IsSuperAdmin(), L.can_do_only_mayor
	end,
})
