local blockedModels = {}
local function loadBlockedModels()
	octolib.getDBVar('blockedModels'):Then(function(data)
		blockedModels = octolib.array.toKeys(data)
	end)
end
hook.Add('octolib.db.init', 'dbg.noIdiots.blockedModels', loadBlockedModels)
if octolib.db and octolib.db:status() == mysqloo.DATABASE_CONNECTED then
	loadBlockedModels()
end

local function saveBlockedModels()
	octolib.setDBVar('blockedModels', nil, table.GetKeys(blockedModels))
end

netstream.Listen('blockedModels.edit', function(reply, ply, model, add)
	if not ply:query('DBG: Редактировать blacklist пропов') then return reply() end
	blockedModels[model] = add and true or nil
	saveBlockedModels()

	reply()
end)

netstream.Listen('blockedModels.get', function(reply, ply)
	if not ply:query('DBG: Редактировать blacklist пропов') then return end
	reply(table.GetKeys(blockedModels))
end)

local function canSpawn(ply, model)
	if blockedModels[model] and not ply:query('DBG: Пропы из blacklist') then
		ply:Notify('warning', 'Ты не можешь спаунить этот проп')
		return false
	end
end
hook.Add('PlayerSpawnProp', 'dbg.blacklist', canSpawn)
hook.Add('PlayerSpawnEffect', 'dbg.blacklist', canSpawn)
