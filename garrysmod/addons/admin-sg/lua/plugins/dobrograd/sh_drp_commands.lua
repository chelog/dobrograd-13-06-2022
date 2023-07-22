local function getSteamID(ply, str)
	local target = util.FindPlayer(str)
	if not IsValid(target) then
		target = str
		if not octolib.string.isSteamID(target) then
			if IsValid(ply) then ply:Notify('warning', 'Укажи никнейм или SteamID игрока')
			else octolib.msg('Укажи никнейм или SteamID игрока') end
			return
		end
	else target = target:SteamID() end
	return target
end

local command = {}

command.help		= "Set a player's name."
command.command 	= "name"
command.arguments	= {"player", "name"}
command.permissions	= "Set Player Name"
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(_, target, arguments)
	target:SetName(arguments[2])
	return true
end

serverguard.command:Add(command)

local command = {}

command.help		= "Set a player's hunger."
command.command 	= "hunger"
command.arguments	= {"player", "hunger"}
command.permissions	= 'DBG: Изменять голод'
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(_, target, arguments)
	local hunger = tonumber(arguments[2])
	target:SetLocalVar("Energy", math.Clamp(hunger or 100, 0, 100))

	return true
end

serverguard.command:Add(command)

local command = {}

command.help		= "Set a player's model."
command.command 	= "setmodel"
command.arguments	= {"player", "model"}
command.permissions	= "Set model"
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(_, target, arguments)
	local model = tostring(arguments[2])
	local bg = arguments[3]
	if IsUselessModel(model) then return false end

	target:SetModel(model)
	if bg then target:SetBodyGroups(bg) end
	return true
end

serverguard.command:Add(command)

local command = {}

command.help		= "Set a player's job name."
command.command 	= "jobname"
command.arguments	= {"player", "job_name"}
command.permissions	= L.permissions_admin_commands
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(player, target, arguments)

	local name = arguments[2]

	if not name or not isstring(name) then

		serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, string.format(L.print_job_name, player:Nick()))
		return true

	else
		target:updateJob(name)

		serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, player:Name(), SERVERGUARD.NOTIFY.WHITE, " has set ", SERVERGUARD.NOTIFY.RED, target:Name(), SERVERGUARD.NOTIFY.WHITE, " job name to ", SERVERGUARD.NOTIFY.GREEN, name, SERVERGUARD.NOTIFY.WHITE, ".")
	end

	return true

end

serverguard.command:Add(command)

local command = {}

command.help		= "Set a player's job"
command.command 	= "job"
command.arguments	= {"player", "job name"}
command.permissions	= L.permissions_admin_commands
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(player, target, arguments)

	local name = arguments[2]
	if not name or not isstring(name) then
		serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, string.format(L.print_job_name_or_nick, player:Nick()))
		return true
	else
		for k, v in ipairs(RPExtraTeams) do
			if string.find(team.GetName(k):lower(), name:lower(), 1, false) or v.command == name:lower() then
				-- if target:Team() == k then
				-- 	serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, string.format("%s, игрок уже в этой профессии.", player:Nick()))
				-- 	return true
				-- end

				if v.police then
					target:SetNetVar('dbg-police.job', v.command)
				else
					target:changeTeam(k, true)
					target:SetNetVar('dbg-police.job', nil)
				end

				break
			end
		end
	end

	return true
end

serverguard.command:Add(command)

-- BROKEN. TODO: FIX

-- local command = {}

-- command.help		= "Ban player from the job"
-- command.command 	= "teamban"
-- command.arguments	= {"player", "job name", "time"}
-- command.permissions	= L.permissions_admin_commands
-- command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

-- function command:OnPlayerExecute(player, target, arguments)

-- 	local name = arguments[2]

-- 	if not name or not isstring(name) then

-- 		serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, string.format(L.print_job_name_or_nick, player:Nick()))
-- 		return true

-- 	else

-- 		local time = util.ToNumber(arguments[3])

-- 		for k, v in ipairs(RPExtraTeams) do

-- 			if string.find( team.GetName(k):lower(), name:lower(), 1, false ) then

-- 				target:teamBan(k, time)

-- 				player:Notify(L.you_ban_job_time:format(target:GetName(), target:SteamID(), team.GetName(k), string.ToMinutesSeconds(time)))

-- 				break

-- 			end

-- 		end
-- 	end

-- 	return true
-- end

-- serverguard.command:Add(command)

-- local command = {}

-- command.help		= "Unban player from the job"
-- command.command 	= "teamunban"
-- command.arguments	= {"player", "job name"}
-- command.permissions	= L.permissions_admin_commands
-- command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

-- function command:OnPlayerExecute(player, target, arguments)

-- 	local name = arguments[2]

-- 	if not name or not isstring(name) then

-- 		serverguard.Notify(player, SERVERGUARD.NOTIFY.RED, string.format(L.print_job_name_or_nick, player:Nick()))
-- 		return true

-- 	else

-- 		for k, v in ipairs(RPExtraTeams) do

-- 			if string.find( team.GetName(k):lower(), name:lower(), 1, false ) then

-- 				target:teamUnBan(k)

-- 				player:Notify('rp', 'Теперь %s может занимать профессию "%s"'):format(target:GetName(), team.GetName(k))

-- 				break

-- 			end

-- 		end
-- 	end

-- 	return true
-- end

-- serverguard.command:Add(command)

local command = {}

command.help		= "Arrest player"
command.command 	= "arrest"
command.arguments	= {"player", "length"}
command.optionalArguments = {"reason"}
command.permissions	= L.permissions_admin_commands
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:Execute(ply, _, arguments)

	local target = getSteamID(ply, arguments[1])
	if not target then return end

	local targetPly = player.GetBySteamID(target)

	if IsValid(targetPly) and targetPly:isArrested() then
		if IsValid(ply) then
			ply:Notify('warning', 'Игрок уже арестован')
		else
			octolib.msg('Игрок уже арестован')
		end
		return
	end

	local time = util.ParseDuration(arguments[2])
	if time < 0 then return end
	time = time * 60

	octolib.setDBVar(target, 'arrest', {arguments[3] or nil, time}):Then(function()
		if IsValid(targetPly) then
			targetPly:arrest(time, ply, arguments[3] or nil, true)
		end
		if IsValid(ply) then ply:Notify('warning', 'Игрок арестован') else octolib.msg('Игрок арестован') end
	end)


	return true
end

serverguard.command:Add(command)

local command = {}

command.help		= "Unarrest player"
command.command 	= "unarrest"
command.arguments	= {"player"}
command.permissions	= L.permissions_admin_commands
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:Execute(ply, _, arguments)

	local target = getSteamID(ply, arguments[1])
	if not target then return end

	octolib.setDBVar(target, 'arrest', nil):Then(function()
		local targetPly = player.GetBySteamID(target)
		if IsValid(targetPly) then
			targetPly:unArrest()
		end
		if IsValid(ply) then ply:Notify('hint', 'Игрок освобожден') else octolib.msg('Игрок освобожден') end
	end)

	return true
end

serverguard.command:Add(command)

local command = {}

command.help		= "Add money to player"
command.command 	= "addmoney"
command.arguments	= {"player", "amount"}
command.permissions	= L.permissions_superadmin_commands
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(ply, target, arguments)
	local amount = util.ToNumber(arguments[2])
	target:addMoney(math.max(target:GetNetVar("money")*-1, amount))

	return true
end

serverguard.command:Add(command)

local command = {}

command.help		= "Sell door you'r looking at"
command.command 	= "selldoor"
command.arguments	= {"player"}
command.permissions	= L.permissions_admin_commands
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(ply, target, arguments)
	local trent = target:GetEyeTrace().Entity
	if not trent:IsDoor() then return end
	local owner = trent:GetPlayerOwner()
	trent:RemoveOwner(owner)

	return true
end

serverguard.command:Add(command)

local command = {}

command.help		= "Sell all doors"
command.command 	= "sellalldoors"
command.arguments	= {"player"}
command.permissions	= L.permissions_admin_commands
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(ply, target, arguments)
	local price, amount = target:UnownAllDoors()
	if IsValid(ply) then
		ply:Notify(('%s помещени%s игрока продано за %s'):format(amount, octolib.string.formatCount(amount, 'е', 'я', 'й'), DarkRP.formatMoney(price)))
	end
	return true
end

serverguard.command:Add(command)

local command = {}

command.help        = 'Телепорт в админ зону';
command.command     = 'adminzone';
command.arguments   = {"player"};
command.permissions = 'Goto';

local maps = {
	truenorth = Vector(-11643.262695, 2303.640625, 7746.319336),
	evocity = Vector(-15921.785156, 15925.755859, 4703.173340),
	eastcoast = Vector(-3508.420166, 2497.798584, -1175.5),
	riverden = Vector(-15946, 15915, 6840),
}

function command:OnPlayerExecute(ply, target, arguments)
	for map, pos in pairs(maps) do
    	if game.GetMap():find(map) then
			target.sg_LastPosition = target:GetPos()
			target.sg_LastAngles = target:EyeAngles()
        	target:SetPos(pos)
   		end
	end

	return true;
end;

serverguard.command:Add(command);

local command = {}

command.help		= "Add karma"
command.command 	= "addkarma"
command.arguments	= {"player", "amount"}
command.permissions	= L.permissions_edit_karma
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(ply, target, arguments)
	local amount = math.floor(util.ToNumber(arguments[2]))
	target:AddKarma(amount, L.edit_karma:format(octolib.string.signed(amount), ply:Name()), true, true)

	return true
end

serverguard.command:Add(command)

local command = {}

if SERVER then
	netvars.Register('nocrime', {
		checkAccess = DarkRP.isAdmin,
	})
end

command.help		= "Deny crime roleplay"
command.command 	= "denycrime"
command.arguments	= {"player", "length"}
command.permissions	= L.permissions_admin_commands
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:Execute(ply, _, arguments)

	local target = getSteamID(ply, arguments[1])
	if not target then return end

	local time = util.ParseDuration(arguments[2])
	if time < 0 then return end
	time = time * 60

	local val
	if time == 0 then val = true else val = os.time() + time end
	octolib.setDBVar(target, 'nocrime', val):Then(function()
		local targetPly = player.GetBySteamID(target)
		if IsValid(targetPly) then
			targetPly:SetNetVar('nocrime', val == true or (CurTime() + (val - os.time())))
		end
		if IsValid(ply) then ply:Notify('Запрет установлен') else octolib.msg('Запрет установлен') end
	end)
	return true

end

serverguard.command:Add(command)

local command = {}

command.help		= "Allow crime roleplay"
command.command 	= "allowcrime"
command.arguments	= {"player"}
command.permissions	= L.permissions_admin_commands
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:Execute(ply, target, arguments)

	local target = getSteamID(ply, arguments[1])
	if not target then return end

	octolib.setDBVar(target, 'nocrime', nil):Then(function()
		local targetPly = player.GetBySteamID(target)
		if IsValid(targetPly) then
			targetPly:SetNetVar('nocrime', nil)
		end
		if IsValid(ply) then ply:Notify('Запрет снят') else octolib.msg('Запрет снят') end
	end)
	return true

end

serverguard.command:Add(command)

local command = {}

if SERVER then
	netvars.Register('nopolice', {
		checkAccess = DarkRP.isAdmin,
	})
end

command.help		= "Deny police roleplay"
command.command 	= "denypolice"
command.arguments	= {"player", "length"}
command.permissions	= L.permissions_admin_commands
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:Execute(ply, _, arguments)

	local target = getSteamID(ply, arguments[1])
	if not target then return end

	local time = util.ParseDuration(arguments[2])
	if time < 0 then return end
	time = time * 60

	local val
	if time == 0 then val = true else val = os.time() + time end
	octolib.setDBVar(target, 'nopolice', val):Then(function()
		local targetPly = player.GetBySteamID(target)
		if IsValid(targetPly) then
			targetPly:SetNetVar('nopolice', val == true or (CurTime() + (val - os.time())))
		end
		if IsValid(ply) then ply:Notify('Запрет установлен') else octolib.msg('Запрет установлен') end
	end)
	return true

end

serverguard.command:Add(command)

local command = {}

command.help		= "Allow police roleplay"
command.command 	= "allowpolice"
command.arguments	= {"player"}
command.permissions	= L.permissions_admin_commands
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:Execute(ply, _, arguments)

	local target = getSteamID(ply, arguments[1])
	if not target then return end

	octolib.setDBVar(target, 'nopolice', nil):Then(function()
		local targetPly = player.GetBySteamID(target)
		if IsValid(targetPly) then
			targetPly:SetNetVar('nopolice', nil)
		end
		if IsValid(ply) then ply:Notify('Запрет снят') else octolib.msg('Запрет снят') end
	end)
	return true

end

serverguard.command:Add(command)

local command = {}

command.help		= L.dobrograd
command.command 	= "lockdown"
command.arguments	= {"player"}
command.permissions	= L.permissions_admin_commands
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(ply, target, arguments)
	if netvars.GetNetVar('lockdown') then
		DarkRP.unLockdown()
	else
		DarkRP.lockdown()
	end

	return true
end

function command:ContextMenu(pPlayer, menu, rankData)
	local drpmenu, pm = menu:AddSubMenu(L.dobrograd)
	pm:SetImage("icon16/star.png")

	local mo, pm = drpmenu:AddSubMenu(L.global_actions)
	pm:SetImage("icon16/world.png")

	mo:AddOption(L.lockdown_change, function()
		serverguard.command.Run("lockdown", true, pPlayer:Name())
	end):SetImage("icon16/exclamation.png")

	mo:AddOption(L.rename_city, function()
		Derma_StringRequest(L.rename_city, L.new_title, netvars.GetNetVar('cityName', L.dobrograd), function(text)
			serverguard.command.Run("renamecity", true, pPlayer:Name(), text)
		end, function(text) end, L.ok, L.cancel)
	end):SetImage("icon16/page_edit.png")

	mo:AddOption(L.reset_city, function()
		serverguard.command.Run("resetcity", true, pPlayer:Name())
	end):SetImage("icon16/page_delete.png")

	local mo, pm = drpmenu:AddSubMenu(L.money)
	pm:SetImage("icon16/money.png")

	mo:AddOption(L.give_money, function()
		Derma_StringRequest(L.give_money, L.how_much_money, "", function(text)
			serverguard.command.Run("addmoney", true, pPlayer:Name(), text)
		end, function(text) end, L.ok, L.cancel)
	end):SetImage("icon16/money_add.png")

	local mo, pm = drpmenu:AddSubMenu(L.job)
	pm:SetImage("icon16/user_gray.png")

	local smo, spm = mo:AddSubMenu(L.change_job)
	spm:SetImage("icon16/group_go.png")
	for k,v in pairs(RPExtraTeams) do
		smo:AddOption(v.name, function()
			serverguard.command.Run("job", true, pPlayer:Name(), k)
		end)
	end

	local smo, spm = mo:AddSubMenu(L.ban_job)
	spm:SetImage("icon16/door_in.png")
	for k,v in pairs(RPExtraTeams) do
		smo:AddOption(v.name, function()
			Derma_StringRequest("Ban player from the job", "Set time for ban in seconds.", "", function(text)
				serverguard.command.Run("teamban", true, pPlayer:Name(), k, text)
			end, function(text) end, L.ok, L.cancel)
		end)
	end

	local smo, spm = mo:AddSubMenu( L.unban_job)
	spm:SetImage("icon16/door_out.png")
	for k,v in pairs(RPExtraTeams) do
		smo:AddOption(v.name, function()
			serverguard.command.Run("teamunban", true, pPlayer:Name(), k)
		end)
	end

	local mo, pm = drpmenu:AddSubMenu(L.other)
	pm:SetImage("icon16/add.png")

	mo:AddOption(L.addkarma, function()
		Derma_StringRequest(L.addkarma, L.addkarma_help, pPlayer:Name(), function(text)
			serverguard.command.Run("addkarma", true, pPlayer:Name(), text)
		end, function(text) end, L.ok, L.cancel)
	end):SetImage("icon16/lightbulb.png")

	mo:AddOption(L.change_name, function()
		Derma_StringRequest(L.change_name, L.new_name, pPlayer:Name(), function(text)
			serverguard.command.Run("name", true, pPlayer:Name(), text)
		end, function(text) end, L.ok, L.cancel)
	end):SetImage("icon16/information.png")

	mo:AddOption(L.sell_all_doors, function()
		serverguard.command.Run("sellalldoors", true, pPlayer:Name())
	end):SetImage("icon16/house_go.png")

	mo:AddOption(L.send_to_jail, function()
		Derma_StringRequest(L.send_to_jail, L.time_in_seconds, "", function(text)
			serverguard.command.Run("arrest", true, pPlayer:Name(), text)
		end, function(text) end, L.ok, L.cancel)
	end):SetImage("icon16/lock.png")

	mo:AddOption(L.unarrest_hint, function()
		serverguard.command.Run("unarrest", true, pPlayer:Name())
	end):SetImage("icon16/lock_open.png")

	mo:AddOption('Телепортироваться в админ зону', function()
		serverguard.command.Run("adminzone", true, pPlayer:Name())
	end):SetImage("icon16/world.png")

end

serverguard.command:Add(command)
