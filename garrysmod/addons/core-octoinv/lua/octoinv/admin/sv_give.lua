local function isAllowed(ply)

	return serverguard.player:HasPermission(ply, L.permissions_edit_inventory)

end

local function sendResults(ply, data)


	netstream.Start(ply, 'octoinv.search', data)

end

local function editorInteractHook(cont, ply, item, contFrom)
	if istable(cont) and cont.noEdit then
		return false, cont.noEdit
	end
	if istable(contFrom) and contFrom.noEdit then
		return false, contFrom.noEdit
	end
	if cont.steamID or istable(contFrom) and contFrom.steamID then
		netstream.Start(cont:GetParent().owner, 'octoinv.editor.change', cont.steamID)
	end
end

local removers = {
	{'Унитаз', 'toilet'},
	{'Ненасытный Жора', 'denture'},
	{'Взрыв', 'explosion'},
	{'Термоядерный взрыв', 'explosion2'},
	{'ZIP-пакет', 'zip_file'},
	{'Краймер', 'robber'},
	{'Фонд Нуждающихся Игроков', 'group3'},
	{'Мусороперерабатывающая фабрика', 'chem_plant'},
	{'Подношение Челогу', 'gift_octo_pride'},
	{'Старый рюкзак', 'clothes_backpack2'},
	{'Пузырь растворителя', 'bottle_vodka'},
	{'Бесконечная любовь', 'heart'},
	{'Долгий ящик', 'inbox'},
	{'Странная колба', 'potion3'},
	{'Секонд-хенд', 'shop2'},
	{'Грузовик ""', 'truck'},
	{'Рука попрошайки', 'hand'},
	{'Игровой автомат', 'slot_machine'},
	{'Пакет чипсов твоего друга', 'food_chips'},
	{'Камера', 'camera'},
	{'Иностранный агент', 'spy'},
	{'Соответствующий контейнер', 'cross'},
	{'Ненадежный файлообменник', 'chip1'},
}

netstream.Hook('octoinv.editor.open', function(ply, steamID, name)

	if not isAllowed(ply) then
		ply:Notify('warning', L.not_have_access)
		return
	end
	if not steamID then return end

	local noEdit = IsValid(player.GetBySteamID(steamID)) and L.player_on_server
	octolib.func.chain({
		function(done)
			if noEdit then return done() end
			octolib.db:PrepareQuery([[select exists(select 1 from `octolib_backup_dbg` where steamID = ? limit 1) as `exists`]], {steamID}, function(q, st, res)
				if istable(res) then
					noEdit = noEdit or res[1].exists == 1 and L.player_on_old_dbg
				end
				done()
			end)
		end,
		function(done)
			if noEdit then return done() end
			octolib.db:PrepareQuery([[select exists(select 1 from `octolib_backup_dbg2` where steamID = ? limit 1) as `exists`]], {steamID}, function(q, st, res)
				if istable(res) then
					noEdit = noEdit or res[1].exists == 1 and L.player_on_new_dbg
				end
				done()
			end)
		end,
		-- function(done)
		-- 	if noEdit then return done() end
		-- 	octolib.db:PrepareQuery([[select exists(select 1 from `octolib_backup_dbg22` where steamID = ? limit 1) as `exists`]], {steamID}, function(q, st, res)
		-- 		if istable(res) then
		-- 			noEdit = noEdit or res[1].exists == 1 and L.player_on_new_dbg
		-- 		end
		-- 		done()
		-- 	end)
		-- end,
		function(done)
			octolib.db:PrepareQuery([[select money from `dbg_atm` where steamID = ? limit 1]], {steamID}, function(q, st, res)
				done(istable(res) and res[1].money or BraxBank.StartMoney())
			end)
		end,
		function(done, bank)
			octolib.db:PrepareQuery([[select karma from `dbg_karma` where steamID = ? limit 1]], {steamID}, function(q, st, res)
				done(bank, istable(res) and res[1].karma or 0)
			end)
		end,
		function(done, bank, karma)
			octolib.db:PrepareQuery([[select inv, `storage` from `inventory` where steamID = ? limit 1]], {steamID}, function(q, st, res)
				res = istable(res) and res[1]
				if res then
					done(bank, karma, res.inv and pon.decode(res.inv) or {}, res.storage and pon.decode(res.storage) or {})
				end
			end)
		end,
		function(done, bank, karma, inv, storage)
			local plyInv = ply:GetInventory()
			if not plyInv then return end

			ply.editorConts = ply.editorConts or {}
			ply.editorConts[steamID] = ply.editorConts[steamID] or {}
			ply.noEdits = ply.noEdits or {}
			ply.noEdits[steamID] = noEdit

			local function addCont(contID, contData)
				local id = '_e' .. steamID .. '_' .. contID

				local default = octoinv.defaultInventory[contID] or {}
				for k,v in pairs(default) do
					contData[k] = contData[k] or v
				end
				contData.name = (contData.name or L.container) .. ' - ' .. (name or steamID)

				if ply.editorConts[steamID][contID] then
					ply.editorConts[steamID][contID]:Remove()
				end

				local cont = plyInv:AddContainer(id, contData)
				cont.noEdit = noEdit
				cont.steamID = steamID
				cont.steamName = name
				cont.contID = contID

				cont:Hook('canMoveOut', 'octoinv.editor', editorInteractHook)
				cont:Hook('canMoveIn', 'octoinv.editor', editorInteractHook)
				cont:Hook('canSeeUseList', 'octoinv.editor', editorInteractHook)
				cont:Hook('canUse', 'octoinv.editor', editorInteractHook)
				cont:Hook('canDrop', 'octoinv.editor', editorInteractHook)

				for _,item in ipairs(contData.items or {}) do
					cont:AddItem(item.class, item, true)
				end

				ply.editorConts[steamID][contID] = cont
				return cont
			end

			for contID, contData in pairs(inv) do
				addCont(contID, contData):QueueSync()
			end

			storage = storage.storage
			if storage then
				storage.name = 'Хранилище'
				storage.volume = 350
				storage.icon = octolib.icons.color('case_travel')
				addCont('_storage', storage):QueueSync()
			end

			local remover
			if not noEdit then
				remover = octolib.array.random(removers)
				addCont('_remover', {
					name = remover[1],
					volume = 9999,
					icon = octolib.icons.color(remover[2]),
				})
			end

			netstream.Start(ply, 'octoinv.editor.open', {
				steamID = steamID,
				bank = bank,
				karma = karma,
				remover = remover and remover[2] or nil,
				noEdit = noEdit
			})
		end,
	})

end)

local defaultStorage = {
	name = 'Хранилище',
	volume = 350,
	icon = octolib.icons.color('case_travel'),
}

netstream.Hook('octoinv.editor.save', function(ply, steamID, bank, karma)
	if not isAllowed(ply) then
		ply:Notify('warning', L.not_have_access)
		return
	end

	if not isstring(steamID) or not isnumber(bank) or not isnumber(karma) then return end
	if not ply.editorConts or not ply.editorConts[steamID] then return end
	if ply.noEdits[steamID] then return ply:Notify(ply.noEdits[steamID]) end
	local conts = ply.editorConts[steamID]

	local stCont, remCont = conts._storage, conts._remover
	conts._storage, conts._remover = nil

	local function getExportedCont(cont, default)
		local res = cont:Export()
		default = default or {}
		for k,v in pairs(default) do
			if res[k] == v or k == 'name' and res[k] == v .. ' - ' .. res.steamName then
				res[k] = nil
			end
		end
		if default.name and res.name == default.name .. ' - ' .. res.steamName then
			res.name = nil
		end
		res.contID, res.noEdit, res.steamID, res.steamName = nil
		return res
	end

	local inv = {}
	for contID, cont in pairs(conts) do
		inv[contID] = getExportedCont(cont, octoinv.defaultInventory[contID])
	end

	local storage = {}
	if stCont then
		storage.storage = getExportedCont(stCont, defaultStorage)
	end

	octolib.db:PrepareQuery('update inventory set inv = ?, storage = ? where steamID = ?', {pon.encode(inv), pon.encode(storage), steamID})
	octolib.db:PrepareQuery('update dbg_atm set money = ? where steamID = ?', {math.Clamp(bank, -2147483647, 2147483647), steamID})
	octolib.db:PrepareQuery('update dbg_karma set karma = ? where steamID = ?', {math.Clamp(karma, -2147483647, 2147483647), steamID})
	ply:Notify('Информация об игроке сохранена')

	conts._storage, conts._remover = stCont, remCont
end)

netstream.Hook('octoinv.editor.close', function(ply, steamID)
	if ply.editorConts and ply.editorConts[steamID] then
		for _,cont in pairs(ply.editorConts[steamID]) do
			cont:Remove()
		end
		ply.editorConts[steamID] = nil
	end
	if ply.noEdits then ply.noEdits[steamID] = nil end
end)

netstream.Hook('octoinv.search', function(ply, data)

	if not isAllowed(ply) then
		ply:Notify('warning', L.not_have_access)
		return
	end
	if not data then return end

	if data.steamID and data.steamID ~= '' then
		octolib.db:PrepareQuery('select steamID from inventory where steamID = ? limit 250', { data.steamID }, function(q, st, res) sendResults(ply, res) end)
	elseif data.query and data.query ~= '' then
		local q = '\'%' .. octolib.db:escape(data.query) .. '%\''
		octolib.db:RunQuery('select steamID from inventory where inv like '..q..' or storage like '..q..' limit 250', function(q, st, res) sendResults(ply, res) end)
	end

end)

netstream.Hook('octoinv.edit', function(ply, steamID, data)

	if not isAllowed(ply) then
		ply:Notify('warning', L.not_have_access)
		return
	end
	if not steamID or not data then return end

	if IsValid(player.GetBySteamID(steamID)) then
		ply:Notify('warning', L.can_not_edit_player)
		return
	end

	for i, ent in ipairs(ents.FindByClass('octoinv_storage')) do
		if ent.steamID == steamID then
			ply:Notify('warning', L.can_not_edit_player_storage)
			return
		end
	end

	octolib.db:PrepareQuery('update inventory set inv = ?, storage = ? where steamID = ?', { pon.encode(data.inv), pon.encode(data.storage), steamID })
	octolib.db:PrepareQuery('update dbg_atm set money = ? where steamID = ?', { data.bank or 0, steamID })
	octolib.db:PrepareQuery('update dbg_karma set karma = ? where steamID = ?', { data.karma or 0, steamID })
	ply:Notify(L.data_saved)

end)

netstream.Hook('octoinv.create', function(ply, entID, contID, item)

	if not isAllowed(ply) then
		ply:Notify(L.not_have_access)
		return
	end

	local ent = Entity(entID)
	local cont = IsValid(ent) and ent.inv and ent.inv.conts[contID]
	if not cont then return end

	local class = octoinv.items[item.class]
	if not class then return end

	if class.nostack then
		local toGive = table.Copy(item)
		toGive._mo = nil
		if toGive.expire then
			toGive.expire = toGive.expire + os.time()
		end

		local amount, class = tonumber(toGive.amount or 1) or 1, toGive.class
		toGive.amount, toGive.class = nil
		for i = 1, amount do
			cont:AddItem(class, toGive)
		end
	else
		cont:AddItem(item.class, tonumber(item.amount or 1) or 1)
	end

	hook.Run('octoinv.adminGive', ply, item)

end)
