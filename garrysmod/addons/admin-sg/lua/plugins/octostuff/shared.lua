local plugin = plugin

plugin.name = 'Octostuff'
plugin.author = 'chelog'
plugin.version = '1.0'
plugin.description = 'Useful stuff for Octothorp Team\'s servers'
plugin.permissions = {
	'Link Accounts',
	'List Linked Accounts',
	'LuaDev',
	'octolib.flyEditor',
}

plugin:IncludeFile('cl_bans.lua', SERVERGUARD.STATE.CLIENT)
plugin:IncludeFile('sv_bans.lua', SERVERGUARD.STATE.SERVER)

local command = {};

command.help	= 'Link player accounts';
command.command   = 'link';
command.arguments = {'steamid', 'steamid'};
command.permissions = 'Link Accounts';
command.immunity  = SERVERGUARD.IMMUNITY.LESSOREQUAL;

function command:Execute(admin, silent, args)
	if not SERVER then return true end
	local pID, fID = args[1], args[2]
	if not octolib.string.isSteamID(pID) or not octolib.string.isSteamID(fID) then
		admin:Notify('Неправильный формат SteamID')
		return
	end

	plugin.addFamilyLink(pID, fID):Then(function()
		admin:Notify(('Аккаунты %s и %s теперь связаны'):format(pID, fID))
	end):Catch(function()
		admin:Notify('warning', 'Произошла ошибка при попытке связать аккаунты ' .. pID .. ' и ' .. fID)
	end)

	return true;
end;

serverguard.command:Add(command);

local command = {};

command.help	= 'List linked Steam accounts';
command.command   = 'listlinked';
command.arguments = {'steamid'};
command.permissions = 'List Linked Accounts';
command.immunity  = SERVERGUARD.IMMUNITY.LESSOREQUAL;

function command:Execute(admin, silent, args)
	if not SERVER then return true end
	local steamID = args[1]
	if not octolib.string.isSteamID(steamID) then return end

	octolib.getDBVar(steamID, 'family'):Then(function(family)
		if istable(family) then
			admin:Notify(('Список связанных с %s аккаунтов, которые появлялись на сервере: %s'):format(steamID, table.concat(family, ', ')))
		else
			admin:Notify('Аккаунты, связанные семейным доступом с этим SteamID, не появлялись на этом сервере')
		end
	end):Catch(function()
		admin:Notify('Данные не найдены')
	end)

	return true;
end;

serverguard.command:Add(command);

local capturing = {}
local command = {}

command.help = 'Grab player screen'
command.command = 'capture'
command.arguments = {'player'}
command.permissions = 'Screencap'
command.immunity = SERVERGUARD.IMMUNITY.LESSOREQUAL

local function notifyWaiting(sid, msg)
	for _,v in ipairs(capturing[sid]) do
		if IsValid(v) then v:Notify('rp', unpack(octolib.string.splitByUrl(msg))) end
	end
	capturing[sid] = nil
end

local errmsg = 'Не удалось получить скриншот экрана %s (%s): %s'
function command:OnPlayerExecute(admin, target)
	if not IsValid(target) then return end
	if not SERVER then return true end
	local name, sid = target:Name(), target:SteamID()
	admin:Notify(('Захват экрана %s (%s)...'):format(name, sid))
	if not capturing[sid] then
		capturing[sid] = {}
		octolib.screen.sendToImgur(target):Then(function(r)
			local msg
			if not r.success then
				msg = errmsg:format(name, sid, tostring(r.data.error))
			else msg = ('Скриншот экрана %s (%s): %s'):format(name, sid, r.data.link) end
			notifyWaiting(sid, msg)
		end):Catch(function(r)
			notifyWaiting(sid, errmsg:format(name, sid, tostring(r)))
		end)
	end
	capturing[sid][#capturing[sid] + 1] = admin
	return true
end

serverguard.command:Add(command)

local command = {};

command.help	= 'Transfer members from one rank to another'
command.command   = 'ranktransfer'
command.arguments = {'from', 'to'}
command.permissions = 'Edit Ranks'
command.immunity  = SERVERGUARD.IMMUNITY.LESSOREQUAL;

function command:Execute(admin, silent, args)

	if not SERVER then return true end
	local rankFrom = args[1]
	local rankTo = args[2]
	if not rankFrom or not rankTo or not serverguard.ranks:FindByID(rankTo) then return end

	local queryObj = serverguard.mysql:Select('serverguard_users')
		queryObj:Where('rank', rankFrom)
		queryObj:Callback(function(result, status, lastID)
			if not istable(result) or #result < 1 then return end
			for _, row in ipairs(result) do
				serverguard.command.Run(admin, 'rank', false, row.steam_id, rankTo, 0)
			end
		end)
	queryObj:Execute()

	return true

end

serverguard.command:Add(command)

local meta = FindMetaTable 'Player'
function meta:query(priv)
	return serverguard.player:HasPermission(self, priv)
end
