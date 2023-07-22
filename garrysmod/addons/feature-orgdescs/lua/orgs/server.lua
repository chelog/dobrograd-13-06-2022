local function updatePlayers()
	local members = {}
	for k, v in pairs(simpleOrgs.orgs) do
		members[k] = table.IsSequential(v.members) and octolib.array.toKeys(v.members) or table.GetKeys(v.members)
	end
	octolib.func.throttle(player.GetAll(), 10, 0.1, function(ply)
		if not IsValid(ply) then return end
		local sid, orgs = ply:SteamID(), {}
		for k, v in pairs(members) do
			if v[sid] then orgs[k] = true end
		end
		ply:SetLocalVar('dbg-orgs.member', orgs)
	end)
end

local function reloadOrgs()
	octolib.db:RunQuery('SELECT * FROM `dbg_orgs`', function(q, st, res)
		if not istable(res) then return end

		local members, owners, urls, flyers = {}, {}, {}, {}
		for _,v in ipairs(res) do
			members[v.id] = pon.decode(v.members)
			owners[v.id] = pon.decode(v.owners)
			urls[v.id] = v.url or ''
			flyers[v.id] = v.flyer or ''
		end

		for k,v in pairs(simpleOrgs.orgs) do
			v.members = simpleOrgs.decompressMembers(members[k] or {})
			table.Empty(v.owners)
			for _, owner in ipairs(owners[k] or {}) do
				v.owners[#v.owners + 1] = owner
			end
			v.url = urls[k] or ''
			v.flyer = flyers[k] or ''
		end
		updatePlayers()
	end)
end

hook.Add('octolib.event:reloadOrgs', 'dbg-orgs', reloadOrgs)

hook.Add('octolib.db.init', 'dbg-orgs', function()
	octolib.db:RunQuery([[
		CREATE TABLE IF NOT EXISTS `dbg_orgs` (
			`id` VARCHAR(10) NOT NULL,
			`members` TEXT NOT NULL,
			`owners` TEXT NOT NULL,
			`url` VARCHAR(128) NOT NULL DEFAULT '',
			`flyer` VARCHAR(128) NOT NULL DEFAULT '',
			PRIMARY KEY (`id`)
		) COLLATE='utf8_general_ci'
	]], function(q, st, res)
		local vals = ''
		for k,v in pairs(simpleOrgs.orgs) do
			if #vals ~= 0 then vals = vals .. ',' end
			vals = vals .. ('(\'%s\',\'%s\',\'%s\',\'%s\',\'%s\')'):format(
				octolib.db:escape(k),
				octolib.db:escape(pon.encode(v.members)),
				octolib.db:escape(pon.encode(v.owners)),
				octolib.db:escape(v.url),
				octolib.db:escape(v.flyer))
		end
		octolib.db:RunQuery([[INSERT IGNORE INTO `dbg_orgs` VALUES ]] .. vals, reloadOrgs)
	end)
end)

local function saveOrg(id)
	local org = id and simpleOrgs.orgs[id]
	if not org then return end
	local members = simpleOrgs.compressMembers(id)
	octolib.db:PrepareQuery([[UPDATE `dbg_orgs` SET `members` = ?, `url` = ?, `flyer` = ? WHERE `id` = ?]], {pon.encode(members), org.url, org.flyer, id}, function(q, st, res)
		octolib.sendCmdToOthers('reloadOrgs')
		updatePlayers()
	end)
end
simpleOrgs.saveOrg = saveOrg


function simpleOrgs.compressMembers(membersOrID)
	membersOrID = membersOrID or {}
	local members = membersOrID
	if not istable(membersOrID) then members = simpleOrgs.orgs[membersOrID] and simpleOrgs.orgs[membersOrID].members end
	if not istable(members) then return {} end
	if table.IsSequential(members) then return octolib.table.mapSequential(members, octolib.string.compressSteamID) end
	local result = {}
	for k, v in pairs(members) do
		result[octolib.string.compressSteamID(k)] = v
	end
	return result
end

function simpleOrgs.decompressMembers(membersOrID)
	membersOrID = membersOrID or {}
	if not istable(membersOrID) then return simpleOrgs.orgs[membersOrID] and table.Copy(simpleOrgs.orgs[membersOrID].members) or {} end
	if table.IsSequential(membersOrID) then return octolib.table.mapSequential(membersOrID, octolib.string.decompressSteamID) end
	local result = {}
	for k, v in pairs(membersOrID) do
		result[octolib.string.decompressSteamID(k)] = v
	end
	return result
end

local allowedFlyerExts = octolib.array.toKeys {'.jpg', '.png'}
netstream.Hook('simple-orgs.editor.save', function(ply, orgId, data, url, flyer)
	if not (istable(data) and isstring(url) and isstring(flyer) and orgId and simpleOrgs.orgs[orgId]) then
		return ply:Notify('Организация не найдена')
	end
	if not table.HasValue(simpleOrgs.orgs[orgId].owners, ply:SteamID()) and not ply:IsSuperAdmin() then
		return ply:Notify('Доступ запрещен')
	end

	simpleOrgs.orgs[orgId].members = data
	simpleOrgs.orgs[orgId].url = url

	if flyer ~= '' then
		if flyer:sub(1, 20) ~= 'https://i.imgur.com/' then
			return ply:Notify('warning', 'Можно использовать только ссылки с Imgur')
		end
		if not allowedFlyerExts[flyer:sub(-4)] then
			return ply:Notify('warning', 'Можно использовать только ссылки в формате .jpg или .png')
		end
		flyer = flyer:sub(21)
	end
	simpleOrgs.orgs[orgId].flyer = flyer

	saveOrg(orgId)
	ply:Notify('Информация об организации обновлена')
end)

netstream.Hook('simple-orgs.editor.saveOwners', function(ply, orgId, data)
	if not (istable(data) and orgId and simpleOrgs.orgs[orgId]) then
		return ply:Notify('Организация не найдена')
	end
	local org = simpleOrgs.orgs[orgId]
	if not ply:query('DBG: Редактировать организации') then
		return ply:Notify('Доступ запрещен')
	end
	org.owners = data
	octolib.db:PrepareQuery([[UPDATE `dbg_orgs` SET `owners` = ? WHERE `id` = ?]], {pon.encode(data), orgId}, function(q, st, res)
		octolib.sendCmdToOthers('reloadOrgs')
	end)
	ply:Notify('Информация об организации обновлена')
end)

concommand.Add('dbg_orgs_edit', function(ply, cmd, args)
	local orgId = args[1]
	if not orgId then
		return ply:PrintMessage(HUD_PRINTCONSOLE, 'dbg_orgs_edit ID')
	end
	local _, msg = ply:OpenOrgEditor(orgId)
	if msg then ply:PrintMessage(HUD_PRINTCONSOLE, msg) end
end)

hook.Add('PlayerFinishedLoading', 'simple-orgs', function(ply)
	local orgs = {}
	for k in pairs(simpleOrgs.orgs) do
		if ply:IsOrgMember(k) then orgs[k] = true end
	end
	ply:SetLocalVar('dbg-orgs.member', orgs)
end)

hook.Add('playerCanChangeTeam', 'simple-orgs.multirank', function(ply, t, force)
	if force then return end
	local org = RPExtraTeams[t].orgID
	if org then org = simpleOrgs.orgs[org] end
	if org then
		return false, 'Это абстрактная профессия, которая используется участниками организации ' .. org.name .. '. Ты не можешь ее взять'
	end
end)

CFG.use.ent_dbg_org_board = {
	function(ply, ent)
		if not ent.orgId then return end
		return 'Изучить', 'octoteam/icons/search.png', function(ply, ent)
			ent:Use(ply, ply, USE_TOGGLE, 1)
		end
	end,
	function(ply, ent)
		if not ent.orgId then return end

		local org = simpleOrgs.orgs[ent.orgId]
		if not org or (not table.HasValue(org.owners, ply:SteamID()) and not ply:query('DBG: Редактировать организации')) then return end

		return 'Управление', 'octoteam/icons/group3.png', function(ply, ent)
			local ok, msg = ply:OpenOrgEditor(ent.orgId)
			if msg then ply:Notify(ok and 'hint' or 'warning', msg) end
		end
	end,
	function(ply, ent)
		if not ply:IsSuperAdmin() then return end
		return 'Настроить', 'octoteam/icons/keypad.png', function(ply, ent)
			octolib.request.send(ply, {
				{
					name = 'Идентификатор организации',
					desc = 'Организации создаются через разработчиков',
					type = 'comboBox',
					opts = octolib.table.mapSequential(table.GetKeys(simpleOrgs.orgs), function(v) return {simpleOrgs.orgs[v].name, v, ent.orgId == v} end),
					required = true,
				}
			}, function(data)
				ent:SetOrgID(data[1])
			end)
		end
	end,
}

local function simpleOrgAccess(ply, ent)

	local data = dbgEstates.getData(ent:GetEstateID())
	if not data or not data.owners then return end
	for _,v in ipairs(data.owners) do
		if string.StartWith(v, 'g:') then
			if v == 'g:police' then
				for k, v in pairs(simpleOrgs.orgs) do
					if v.police and ply:IsOrgMember(k) then
						return true
					end
				end
			else
				local gID = v:sub(3)
				if ply:IsOrgMember(gID) then
					return true
				end
			end
		end
	end

end
hook.Add('canKeysLock', 'dbg-orgs.doors', simpleOrgAccess)
hook.Add('canKeysUnlock', 'dbg-orgs.doors', simpleOrgAccess)

hook.Add('dbg-winter.isWarm', 'dbg-orgs', function(ply)
	if ply.dbgPolice_citizenData then
		return true
	end
end)

hook.Add('PlayerDisconnected', 'dbg-orgs.customClothes', function(ply)
	local clothes = ply.dbgPolice_citizenData and ply.dbgPolice_citizenData.cl
	if clothes then
		ply:SetDBVar('customClothes', clothes)
	end
end)

local function getClothes(mdl, clothesData)
	for prefix, clothes in pairs(clothesData) do
		if string.StartWith(mdl, prefix) then return clothes end
	end
end

netstream.Hook('dbg-orgs.clothes', function(ply, clID, value)

	if not (clID and value) then return end
	local org = ply.currentOrg and simpleOrgs.orgs[ply.currentOrg]
	if not (org and org.clothes) then return end

	local clothes = getClothes(ply:GetModel(), org.clothes)
	if not (clothes and clothes[clID]) then return end
	local clothing = clothes[clID]
	if clothing.vals[value] then
		ply:SetBodygroup(clothing.bodygroup, value)
	end
end)