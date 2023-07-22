octochat.commands = octochat.commands or {}
octochat.permissions = octochat.permissions or {}

function octochat.genericSayFunc(ply, txt, radius, action)

	local console = not IsValid(ply)

	if txt == '' then return end
	if not console and (ply.nextSay or 0) > os.time() then return end

	local prepostfix = ''
	if txt:find(')', 1, true) and not txt:find('(', 1, true) then
		txt = txt:gsub('[%):=]', '')
		if string.Trim(txt) == '' then
			if console then return octochat.talkTo(nil, octochat.textColors.rp, L.smile_hint % { name = L.console }) end
			return ply:DoEmote(L.smile_hint)
		end
		prepostfix = L.postfix_smile
	elseif txt:find('(', 1, true) and not txt:find(')', 1, true) then
		txt = txt:gsub('[%(:=]', '')
		if string.Trim(txt) == '' then
			if console then return octochat.talkTo(nil, octochat.textColors.rp, L.sad_hint % { name = L.console }) end
			return ply:DoEmote(L.sad_hint)
		end
		prepostfix = L.postfix_sad
	end
	local postfix = action or (txt:sub(-1) == '?' and L.postfix_question or L.postfix_say)

	if console then
		return octochat.talkTo(nil, octochat.textColors.rp, L.console, prepostfix, postfix, color_white, txt)
	end

	local color = hook.Run("GetPlayerChatColor", ply) or octochat.textColors.rp
	local heard = ply:TalkToRange(radius or 150, color, ply:Name(), prepostfix, postfix, color_white, txt)
	ply.nextSay = os.time() + 1

	if ply:GetNetVar('os_govorilka') and not ply:IsGovorilkaMuted() then
		ply:DoVoice(txt, ply:GetVoice(), heard)
	end

end

local function addPermission(perm)
	if not serverguard then octochat.permissions[#octochat.permissions + 1] = perm
	else serverguard.permission:Add(perm) end
end
hook.Add('Think', 'octochat.loadPerms', function()
hook.Remove('Think', 'octochat.loadPerms')
for _, v in ipairs(octochat.permissions) do
	serverguard.permission:Add(v)
end
octochat.permissions = {}
end)

function octochat.registerCommand(name, data)
	name = string.lower(name)

	local toRem = {}
	if octochat.commands[name] then
		for _,v in ipairs(octochat.commands[name].aliases or {}) do
			octochat.commands[v] = nil
			toRem[#toRem + 1] = v
		end
		octochat.commands[name] = nil
		toRem[#toRem + 1] = name
	end

	if not istable(data) then return end
	local toAdd = {}
	data.name = name
	toAdd[1] = name
	if data.cooldown then data._cooldowns = {} end
	octochat.commands[name] = data
	if data.aliases then
		for _,v in ipairs(data.aliases) do
			octochat.commands[v] = data
			toAdd[#toAdd + 1] = v
		end
	end
	if data.permission then addPermission(data.permission) end
	if data.cooldownBypass then addPermission(data.cooldownBypass) end
end

function octochat.pickOutTarget(args)

	args = table.Copy(args)
	if not args[1] or args[1] == '' then return false end

	local target = octochat.findPlayer(args[1])
	if not target then return false, L.could_not_find:format(tostring(args[1])) end

	table.remove(args, 1)
	local txt = string.Trim(string.Implode(' ', args))

	return target, txt
end

hook.Add('PlayerSay', 'octochat.commands', function(ply, _txt)

	if game.IsDedicated() then
		ServerLog('"' .. ply:Nick() .. '<' .. ply:UserID() .. '>' .. '<' .. ply:SteamID() .. '>' .. '<' .. team.GetName(ply:Team()) .. '>" say "' .. _txt .. '"\n')
	end

	local args = octochat.explodeArg(_txt)
	local alias = table.remove(args, 1)
	if not alias then return end
	alias = string.lower(alias)
	local data = octochat.commands[alias]
	if not data then return end

	local txt = string.Trim(string.Implode(' ', args))

	local sid = ply:SteamID()
	local bypassesCooldown = isfunction(data.cooldownBypass) and data.cooldownBypass(ply, txt, args, alias, data.name)
	bypassesCooldown = bypassesCooldown or  isstring(data.cooldownBypass) and ply:query(data.cooldownBypass)
	if data.cooldown and data._cooldowns[sid] and not bypassesCooldown then
		local timeLeft = math.max(1, math.ceil(data._cooldowns[sid] - os.time()))
		local msg = ('Ты сможешь выполнить эту команду %s'):format(octolib.time.formatIn(timeLeft))
		ply:Notify('warning', msg)
		return ''
	end

	local can, why = octochat.canExecuteCommand(ply, alias, args, txt)
	if not can then
		hook.Run('octochat.commandExecuted', ply, _txt, data, false, why)
		ply:Notify('warning', why)
		return ''
	end

	local result = data.execute(ply, txt, args, alias)
	if result == nil or result == true then
		hook.Run('octochat.commandExecuted', ply, _txt, data, true)
		if not data.cooldown or bypassesCooldown then return '' end
		data._cooldowns[sid] = os.time() + data.cooldown
		timer.Create('octochat.cooldowns' .. sid .. data.name, data.cooldown, 1, function()
			data._cooldowns[sid] = nil
		end)
	else
		result = isstring(result) and result or 'Команда выполнена неправильно'
		hook.Run('octochat.commandExecuted', ply, _txt, data, false, result)
		ply:Notify('warning', unpack(octolib.string.splitByUrl(result)))
	end

	return ''

end, -5)

hook.Add('ConsoleSay', 'octochat.commands', function(_txt)

	if game.IsDedicated() then
		ServerLog('"Console" say "' .. _txt .. '"\n')
	end

	local args = octochat.explodeArg(_txt)
	local alias = table.remove(args, 1)
	if not alias then return end
	alias = string.lower(alias)
	local data = octochat.commands[alias]
	if not data then return end

	local txt = string.Trim(string.Implode(' ', args))

	if not data.consoleFriendly then
		octolib.msg('Эту команду могут выполнить только игроки!')
		return ''
	end

	local result = data.execute(nil, txt, args, alias)
	if result == nil or result == true then
		hook.Run('octochat.commandExecuted', nil, _txt, data, true)
	else
		result = isstring(result) and result or 'Команда выполнена неправильно'
		hook.Run('octochat.commandExecuted', nil, _txt, data, false, result)
		octolib.msg(result)
	end

	return ''

end, -5)

hook.Run('octochat.registerCommands')
