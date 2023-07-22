--
-- SHOP
--

hook.Add('octoinv.shop.order', 'octologs', function(ply, receiver, items, price, id)

	price = DarkRP.formatMoney(price)
	local data = {
		'Order ID: #' .. id,
		'Total price: ' .. price,
	} table.Add(data, items)

	octologs.createLog(octologs.CAT_SHOP)
		:Add(octologs.ply(ply, {'wep'}), ' placed ', octologs.table('order #' .. id, data))
		:Add(' for ', octologs.ply(receiver), ', price: ', price)
	:Save()

end)

hook.Add('octoinv.shop.delivery', 'octologs', function(ply, receiver, id, box)

	octologs.createLog(octologs.CAT_SHOP)
		:Add('Order #' .. id, ' for ', octologs.ply(receiver, {'wep'}), ' arrived in ', octologs.ent(box))
	:Save()

end)

hook.Add('octoinv.shop.timeout', 'octologs', function(ply, receiver, id, box)

	octologs.createLog(octologs.CAT_SHOP)
		:Add('Order #' .. id, ' for ', octologs.ply(receiver, {'wep'}), ' timed out')
	:Save()

end)

--
-- INVENTORY
--

hook.Add('DarkRP.payPlayer', 'octologs', function(ply, victim, amount)

	octologs.createLog(octologs.CAT_INVENTORY)
		:Add(octologs.ply(ply), ' payed ', octologs.ply(victim), ' ', DarkRP.formatMoney(amount))
	:Save()

end)

hook.Add('atm.withdraw', 'octologs', function(ply, amount)

	octologs.createLog(octologs.CAT_INVENTORY)
		:Add(octologs.ply(ply, {'wep'}), ' withdrew ', DarkRP.formatMoney(amount), ' with ATM')
	:Save()

end)

hook.Add('atm.deposit', 'octologs', function(ply, amount)

	octologs.createLog(octologs.CAT_INVENTORY)
		:Add(octologs.ply(ply, {'wep'}), ' deposited ', DarkRP.formatMoney(amount), ' with ATM')
	:Save()

end)

local function formatCont(cont)

	if not cont then return 'invalid' end
	local toReturn = {}

	local ent, owner = cont:GetParent().owner
	if IsValid(ent) then
		if ent:IsPlayer() then
			owner = ent
		elseif IsValid(ent.owner) and ent.owner:IsPlayer() then
			owner = ent.owner
		end
	else
		return 'invalid container'
	end

	if owner then
		toReturn[#toReturn + 1] = { owner:Name(), octologs.plyData(ent, {'job', 'loc', 'wep', 'hp', 'ar'}) }
		toReturn[#toReturn + 1] = '\'s '
	end

	toReturn[#toReturn + 1] = { cont.name or 'cont', ent ~= owner and octologs.entData(ent, {'loc'}) or {} }

	return unpack(toReturn)

end

hook.Add('octoinv.plymoved', 'octologs', function(ply, item, from, to, amount)

	if item and IsValid(ply) and ply:IsPlayer() then
		octologs.createLog(octologs.CAT_INVENTORY)
			:Add(octologs.ply(ply), ' moved ', ('[%dx%s]'):format(amount or 1, item:GetData('name')), ': [')
			:Add(formatCont(from))
			:Add(']➞[')
			:Add(formatCont(to))
			:Add(']')
		:Save()
	end

end)

hook.Add('octoinv.dropped', 'octologs', function(cont, item, ent, ply)

	if item and IsValid(ply) and ply:IsPlayer() then
		local entData = ent:GetNetVar('Item')
		local amount = entData and isnumber(entData[2]) and entData[2] or 1
		local itemStr = ('[%dx%s]'):format(amount or 1, item:GetData('name'))

		octologs.createLog(octologs.CAT_INVENTORY)
			:Add(octologs.ply(ply), ' dropped ', octologs.string(itemStr), ' from [')
			:Add(formatCont(cont))
			:Add(']')
		:Save()
	end

end)

hook.Add('octoinv.pickup', 'octologs', function(ply, ent, item, amount)

	if item and IsValid(ply) and ply:IsPlayer() then
		local itemStr = ('[%dx%s]'):format(amount or 1, item:GetData('name'))
		local log = octologs.createLog(octologs.CAT_INVENTORY)
			:Add(octologs.ply(ply), ' picked up ', octologs.string(itemStr))
		if IsValid(ent.droppedBy) and ent.droppedBy:IsPlayer() then
			log = log:Add(' dropped by ', octologs.ply(ent.droppedBy))
		end
		log:Save()
	end

end)

hook.Add('octoinv.crafted', 'octologs', function(ply, ent, bpID, cont)

	if item and IsValid(ply) and ply:IsPlayer() then
		local bp = octoinv.getBlueprint(bpID)
		local name = bp.name
		if istable(bp.finish) and not name then
			local item = bp.finish[1]
			name = octoinv.getItemData('name', unpack(item))
		end

		octologs.createLog(octologs.CAT_INVENTORY)
			:Add(octologs.ply(ply), ' crafted ', octologs.string(name), ' in [')
			:Add(formatCont(cont))
			:Add(']')
		:Save()
	end

end)

hook.Add('octoinv.collect-evidences', 'octologs', function(ply, ent, items)
	if IsValid(ply) and ply:IsPlayer() then
		local from
		if ent:GetClass() == 'octoinv_item' then
			from = octologs.string('GROUND')
		else
			local bodyStr = 'Труп - ' .. ent:GetNetVar('Corpse.name')
			from = {octologs.string(bodyStr), octologs.entData(ent, {'mdl'})}
		end
		octologs.createLog(octologs.CAT_INVENTORY)
			:Add(octologs.ply(ply), ' collected evidence [', octologs.string(items), '] from ', from)
		:Save()
	end
end)

hook.Add('octoinv.used', 'octologs', function(cont, item, ply)

	if item and IsValid(ply) and ply:IsPlayer() then
		local itemStr = ('[%dx%s]'):format(amount or 1, item:GetData('name'))
		octologs.createLog(octologs.CAT_INVENTORY)
			:Add(octologs.ply(ply), ' used ', octologs.string(itemStr), ' from ')
			:Add(formatCont(cont))
		:Save()
	end

end)

hook.Add('octoinv.stolen', 'octologs', function(cont, items, ply)

	if items and IsValid(ply) and ply:IsPlayer() then
		local itemsText = {}
		for k, v in pairs(items) do itemsText[#itemsText + 1] = ('%sx%s'):format(v, k) end

		local itemStr = table.concat(itemsText, ', ')
		octologs.createLog(octologs.CAT_INVENTORY)
			:Add(octologs.ply(ply), ' stole [', octologs.string(itemStr), '] from [')
			:Add(formatCont(cont))
			:Add(']. Police online: ', tostring(#player.GetPolice()))
		:Save()
	end

end)

hook.Add('octoinv.search', 'octologs', function(ply, victim)

	if IsValid(ply) and IsValid(victim) then
		octologs.createLog(octologs.CAT_INVENTORY)
			:Add(octologs.ply(ply), ' searched ', octologs.ply(victim))
			:Add('. Police online: ', tostring(#player.GetPolice()))
		:Save()
	end

end)

hook.Add('octoinv.search-corpse', 'octologs', function(ply, ent)

	if IsValid(ply) and IsValid(ent) then
		local bodyStr = 'Труп - ' .. ent:GetNetVar('Corpse.name')
		octologs.createLog(octologs.CAT_INVENTORY)
			:Add(octologs.ply(ply), ' searched ', { octologs.string(bodyStr), octologs.entData(ent, {'mdl'}) })
			:Add('. Police online: ', tostring(#player.GetPolice()))
		:Save()
	end

end)

hook.Add('octoinv.storageSpawned', 'octologs', function(ply, ent)

	octologs.createLog(octologs.CAT_INVENTORY)
		:Add(octologs.ply(ply), ' dropped ', { 'octoinv_storage', octologs.entData(ent, {'mdl'}) })
	:Save()

end)

hook.Add('dbg-weapons.holstered', 'octologs', function(cont, itemData, ply)

	if itemData and IsValid(ply) and ply:IsPlayer() then
		local itemStr = ('[%s] to [%s]'):format(itemData.name, formatCont(cont))
		octologs.createLog(octologs.CAT_INVENTORY)
			:Add(octologs.ply(ply), ' holstered [', octologs.string(itemData.name), '] to [')
			:Add(formatCont(cont))
			:Add(']')
		:Save()
	end

end)

hook.Add('onLockpickCompleted', 'octologs', function(ply, success, ent)

	local owner
	if ent.GetPlayerOwner and ent:GetPlayerOwner() then
		owner = ent:GetPlayerOwner()
		local pl = player.GetBySteamID(owner)
		owner = IsValid(pl) and pl or owner
	elseif ent.owner and IsValid(ent.owner) then
		owner = ent.owner
	elseif ent.steamID then
		local ply = player.GetBySteamID(ent.steamID)
		owner = IsValid(ply) and ply or ent.steamID
	end

	if isstring(owner) then
		octologs.createLog(octologs.CAT_LOCKPICK)
			:Add(octologs.ply(ply, {'loc', 'wep', 'hp', 'ar'}), ' lockpicked ', octologs.string(owner), '\'s ', octologs.ent(ent), ': ', success and 'success' or 'fail')
			:Add('. Police online: ', tostring(#player.GetPolice()))
		:Save()
	elseif not istable(owner) and IsValid(owner) then
		octologs.createLog(octologs.CAT_LOCKPICK)
			:Add(octologs.ply(ply, {'loc', 'wep', 'hp', 'ar'}), ' lockpicked ', octologs.ply(owner), '\'s ', octologs.ent(ent), ': ', success and 'success' or 'fail')
			:Add('. Police online: ', tostring(#player.GetPolice()))
		:Save()
	else
		octologs.createLog(octologs.CAT_LOCKPICK)
			:Add(octologs.ply(ply, {'loc', 'wep', 'hp', 'ar'}), ' lockpicked ', octologs.ent(ent), ': ', success and 'success' or 'fail')
			:Add('. Police online: ', tostring(#player.GetPolice()))
		:Save()
	end

end)

hook.Add('dbg-hack.1stCommand', 'octologs', function(ply, ent)

	local owner
	if ent.CPPIGetOwner and ent:CPPIGetOwner() then
		owner = ent:CPPIGetOwner()
	elseif ent.owner and IsValid(ent.owner) then
		owner = ent.owner
	elseif ent.steamID then
		local ply = player.GetBySteamID(ent.steamID)
		owner = IsValid(ply) and ply or ent.steamID
	end

	if isstring(owner) then
		octologs.createLog(octologs.CAT_LOCKPICK)
			:Add(octologs.ply(ply, {'loc', 'wep', 'hp', 'ar'}), ' started cracking ', octologs.string(owner), '\'s ', octologs.ent(ent))
			:Add('. Police online: ', tostring(#player.GetPolice()))
		:Save()
	elseif IsValid(owner) then
		octologs.createLog(octologs.CAT_LOCKPICK)
			:Add(octologs.ply(ply, {'loc', 'wep', 'hp', 'ar'}), ' started cracking ', octologs.ply(owner), '\'s ', octologs.ent(ent))
			:Add('. Police online: ', tostring(#player.GetPolice()))
		:Save()
	else
		octologs.createLog(octologs.CAT_LOCKPICK)
			:Add(octologs.ply(ply, {'loc', 'wep', 'hp', 'ar'}), ' started cracking ', octologs.ent(ent))
			:Add('. Police online: ', tostring(#player.GetPolice()))
		:Save()
	end

end)

hook.Add('onKeypadHack', 'octologs', function(ply, success, ent)

	if not success then return end

	local owner
	if ent.CPPIGetOwner and ent:CPPIGetOwner() then
		owner = ent:CPPIGetOwner()
	elseif ent.owner and IsValid(ent.owner) then
		owner = ent.owner
	elseif ent.steamID then
		local ply = player.GetBySteamID(ent.steamID)
		owner = IsValid(ply) and ply or ent.steamID
	end

	if isstring(owner) then
		octologs.createLog(octologs.CAT_LOCKPICK)
			:Add(octologs.ply(ply, {'loc', 'wep', 'hp', 'ar'}), ' cracked ', octologs.string(owner), '\'s ', octologs.ent(ent))
			:Add('. Police online: ', tostring(#player.GetPolice()))
		:Save()
	elseif IsValid(owner) then
		octologs.createLog(octologs.CAT_LOCKPICK)
			:Add(octologs.ply(ply, {'loc', 'wep', 'hp', 'ar'}), ' cracked ', octologs.ply(owner), '\'s ', octologs.ent(ent))
			:Add('. Police online: ', tostring(#player.GetPolice()))
		:Save()
	else
		octologs.createLog(octologs.CAT_LOCKPICK)
			:Add(octologs.ply(ply, {'loc', 'wep', 'hp', 'ar'}), ' cracked ', octologs.ent(ent))
			:Add('. Police online: ', tostring(#player.GetPolice()))
		:Save()
	end

end)

--
-- DAMAGE
--

hook.Add('tazer.tazed', 'octologs', function(ply, victim)

	octologs.createLog(octologs.CAT_DAMAGE)
		:Add(octologs.ply(ply), ' tazed ', octologs.ply(victim, {'loc'}))
	:Save()

end)

hook.Add('dbg.scareStart', 'octologs', function(victim, ply, wep)

	octologs.createLog(octologs.CAT_DAMAGE)
		:Add(octologs.ply(ply), ' scared ', octologs.ply(victim), ' with ', octologs.wep(wep))
		:Add('. Police online: ', tostring(#player.GetPolice()))
	:Save()

end)

hook.Add('dbg.scareInit', 'octologs', function(victim, ply, wep)

	octologs.createLog(octologs.CAT_DAMAGE)
		:Add(octologs.ply(ply), ' aimed at ', octologs.ply(victim, {'loc'}), ' with ', octologs.wep(wep))
		:Add('. Police online: ', tostring(#player.GetPolice()))
	:Save()

end)

hook.Add('dbg.scareEnd', 'octologs', function(ply)

	octologs.createLog(octologs.CAT_DAMAGE)
		:Add(octologs.ply(ply), ' is not scared now')
	:Save()

end)

local function formatAttacker(attacker)
	if isstring(attacker) then
		return octologs.string(attacker)
	elseif IsValid(attacker) then
		if attacker:IsPlayer() then
			return octologs.ply(attacker)
		elseif attacker.cdData then
			return octologs.veh(attacker)
		else
			return octologs.ent(attacker)
		end
	else
		return octologs.string('world')
	end
end

local function formatWeapon(wep)
	if isstring(wep) then
		return octologs.string(wep)
	elseif IsValid(wep) then
		if wep:IsWeapon() then
			return octologs.wep(wep)
		elseif wep.cdData then
			return octologs.veh(wep)
		else
			return octologs.ent(wep, {'loc'})
		end
	else
		return octologs.string('something')
	end
end

hook.Add('EntityDamage', 'octologs', function(victim, attacker, wep, dmgInfo)

	local dmg = math.Round(dmgInfo:GetDamage())
	local wepName
	if IsValid(wep) then
		wepName = wep:GetClass()
		local info = weapons.GetStored(wepName)
		if info then wepName = info.PrintName or info.Name or wepName end
	end

	if victim:IsPlayer() and victim:Alive() then
		local health = victim:Health() - dmg

		victim.lastAttacker = IsValid(attacker) and attacker:IsPlayer() and attacker:Name()
		if victim.attackedBy then victim.lastAttacker = victim.attackedBy end
		victim.lastWeapon = victim.weaponUsed or wepName
		victim.weaponUsed = nil
		victim.attackedBy = nil
		victim.lastDMGT = dmgInfo:GetDamageType()

		local log
		if health <= 0 and (not wep or not wep:GetClass():find('gmod_sent_vehicle_fphysics')) then
			local inv = victim:GetInventory()
			local items = {}
			if inv then
				for _, cont in pairs(inv.conts) do
					items[#items + 1] = cont.name
					for _, item in pairs(cont.items) do
						items[#items + 1] = (' %d x %s'):format(item:GetData('amount'), item:GetData('name'))
					end
				end
			end
			log = octologs.createLog(octologs.CAT_DAMAGE)
				:Add(octologs.ply(victim), octologs.table(' (inventory)', items), ' was killed')
		else
			log = octologs.createLog(octologs.CAT_DAMAGE)
				:Add(octologs.ply(victim), ' was hurt: ', octologs.string(dmg .. 'HP'))
		end

		if not attacker then
			attacker = wep
			wep = nil
		end

		if attacker then log:Add(' by ', formatAttacker(attacker)) end
		if wep then log:Add(' with '):Add(formatWeapon(wep)) end

		log:Add('. Police online: ', tostring(#player.GetPolice()))
		log:Save()
	elseif IsValid(attacker) and victim:GetClass():find('gmod_sent_vehicle_fphysics') then
		local log = octologs.createLog(octologs.CAT_DAMAGE)
			:Add(octologs.veh(victim, exclude))
			:Add(' was damaged: ', octologs.string(dmg .. 'HP'))

		if not attacker then
			attacker = wep
			wep = nil
		end

		if attacker then log:Add(' by ', formatAttacker(attacker)) end
		if wep then log:Add(' with ', formatWeapon(wep)) end

		log:Add('. Police online: ', tostring(#player.GetPolice()))
		log:Save()
	end

end)

hook.Add('dbg-karma.changed', 'octologs', function(ply, new, old)

	if new >= old then return end
	octologs.createLog(octologs.CAT_KARMA)
		:Add(octologs.ply(ply), '\'s karma: ', octologs.string(old .. ' ➞ ' .. new))
	:Save()

end)

hook.Add('PlayerDeath', 'octologs', function(victim, _, attacker)

	if not IsValid(victim) or not victim:IsPlayer() then return end
	if not IsValid(attacker) or not attacker:IsPlayer() then return end

	if attacker == victim then
		octologs.createLog(octologs.CAT_DAMAGE)
			:Add(octologs.ply(victim), ' suicided')
		:Save()
	end

end)

hook.Add('OnHandcuffed', 'octologs', function(cop, ply, cuff)

	octologs.createLog(octologs.CAT_CUFF)
		:Add(octologs.ply(ply), ' was cuffed by ', octologs.ply(cop, {'loc'}), ' with ', octologs.string(cuff.CuffType))
		:Add('. Police online: ', tostring(#player.GetPolice()))
	:Save()

end)

hook.Add('OnHandcuffBreak', 'octologs', function(ply, cuff, mate)

	local log = octologs.createLog(octologs.CAT_CUFF)
		:Add(octologs.ply(ply), ' was uncuffed from ', octologs.string(cuff.CuffType or 'unknown'))
		if IsValid(mate) then log:Add(' by ', octologs.ply(mate)) end
		log:Add('. Police online: ', tostring(#player.GetPolice()))
	log:Save()

end)

hook.Add('dbg.evacuation', 'octologs', function(car, cop, owner)
	octologs.createLog(octologs.CAT_OTHER)
		:Add(octologs.ply(ply), ' requested evacuation for ', octologs.ply(owner), '\'s ', octologs.ent(car))
	:Save()
end)

hook.Add('dbg-police.call', 'octologs', function(ply, nick, text, sentPos)
	local log = octologs.createLog(octologs.CAT_OTHER)
		:Add(octologs.ply(ply), ' called police under nickname "', octologs.string(nick), '"')
	if sentPos then
		log = log:Add(' and sent their pos to cops.')
	else log = log:Add('.') end
	log:Add(' Message text: ', text):Save()
end)

--
-- VEHICLES
--

timer.Simple(0, function()
	local doNotLog = octolib.array.toKeys {'gmod_sent_vehicle_fphysics_attachment', 'gmod_sent_vehicle_fphysics_wheel', 'info_particle_system', 'prop_physics', 'prop_vehicle_prisoner_pod'}
	hook.Add('PlayerSpawnedVehicle', 'octologs', function(ply, veh)
		if doNotLog[veh:GetClass()] then return end

		octologs.createLog(octologs.CAT_BUILD)
			:Add(octologs.ply(ply, {'wep','loc','job'}), ' spawned vehicle: ', octologs.string(veh:GetClass()))
		:Save()
	end)
end)

hook.Add('car-dealer.bought', 'octologs', function(class, ply, price)
	local cdData = carDealer.vehicles[class]
	octologs.createLog(octologs.CAT_VEHICLE)
		:Add(octologs.ply(ply, {'wep', 'hp', 'ar'}), ' bought ')
		:Add(octologs.string(cdData and cdData.name or class or 'vehicle'))
		:Add(' for ', DarkRP.formatMoney(price or 0))
	:Save()
end)

local function percent(cur, max)
	return math.Round(cur / (max or 1) * 100) .. '%'
end

hook.Add('car-dealer.sold', 'octologs', function(veh, ply, price)
	local data = {
		'HP: ' .. percent(veh.data.health or 1),
		'Fuel: ' .. percent(veh.data.fuel or 1),
	}

	if veh.data.rims then
		local mdl = veh.data.rims[1]
		local rimsData = simfphys.rims[mdl]
		if rimsData then
			data[#data + 1] = rimsData.name
		else
			data[#data + 1] = mdl
		end
	end

	if veh.data.atts then
		for _, att in ipairs(veh.data.atts) do
			data[#data + 1] = att.name
		end
	end

	if veh.data.bg then
		data[#data + 1] = util.TableToJSON(veh.data.bg)
	end

	local cdData = carDealer.vehicles[veh.class or '']
	octologs.createLog(octologs.CAT_VEHICLE)
		:Add(octologs.ply(ply, {'wep', 'hp', 'ar'}), ' sold ')
		:Add(octologs.table(cdData and cdData.name or class or 'vehicle', data))
		:Add(' for ', DarkRP.formatMoney(price or 0))
	:Save()
end)

hook.Add('car-dealer.spawnedOwned', 'octologs', function(veh, ply)
	timer.Simple(1.2, function()
		if not IsValid(veh) then return end
		octologs.createLog(octologs.CAT_VEHICLE)
			:Add(octologs.ply(ply, {'wep', 'hp', 'ar'}), ' spawned ')
			:Add(octologs.veh(veh))
		:Save()
	end)
end)

hook.Add('car-dealer.spawnedDeposit', 'octologs', function(veh, ply)
	timer.Simple(1.2, function()
		if not IsValid(veh) then return end
		octologs.createLog(octologs.CAT_VEHICLE)
			:Add(octologs.ply(ply, {'wep', 'hp', 'ar'}), ' spawned ')
			:Add(octologs.veh(veh))
			:Add(' for ', DarkRP.formatMoney(veh.deposit or 0))
		:Save()
	end)
end)

hook.Add('car-dealer.stored', 'octologs', function(veh, ply)
	octologs.createLog(octologs.CAT_VEHICLE)
		:Add(octologs.ply(ply, {'wep', 'hp', 'ar'}), ' stored ')
		:Add(octologs.veh(veh))
	:Save()
end)

hook.Add('car-dealer.returnedDeposit', 'octologs', function(veh, ply, amount)
	octologs.createLog(octologs.CAT_VEHICLE)
		:Add(octologs.ply(ply, {'wep', 'hp', 'ar'}), ' returned ')
		:Add(DarkRP.formatMoney(amount or 0), ' for ')
		:Add(octologs.veh(veh))
	:Save()
end)

hook.Add('car-dealer.resetPlate', 'octologs', function(ply, ent, plate, returned)
	local owner = ent:CPPIGetOwner()
	octologs.createLog(octologs.CAT_VEHICLE)
		:Add(octologs.ply(ply, {'loc', 'job', 'wep', 'hp', 'ar'}), ' reset ')
		:Add(octologs.ply(owner, {'loc', 'job', 'wep', 'hp', 'ar'}))
		:Add('\'s car plate (was ', octologs.string(plate), '). ')
		:Add('Item was', returned and '' or 'n\'t', ' returned.')
	:Save()
end)

hook.Add('dbg-cars.itemBurned', 'octologs', function(veh, item, amount)

	if not item then return end

	local itemStr = ('[%dx%s]'):format(amount or 1, item:GetData('name'))
	octologs.createLog(octologs.CAT_INVENTORY)
		:Add(octologs.string(itemStr), ' burned in ')
		:Add(octologs.veh(veh))
	:Save()

end)

--
-- MASK & CLOTHES
--

hook.Add('dbg-masks.mask', 'octologs', function(ply, maskID, justUpdate)
	if justUpdate then return end
	local mask = CFG.masks[maskID]
	octologs.createLog(octologs.CAT_INVENTORY)
		:Add(octologs.ply(ply), ' masked ', octologs.table(mask.name, { id = maskID }))
	:Save()
end)

hook.Add('dbg-masks.unmask', 'octologs', function(ply, maskName, maskID)
	octologs.createLog(octologs.CAT_INVENTORY)
		:Add(octologs.ply(ply), ' unmasked ', octologs.table(maskName, { id = maskID }))
	:Save()
end)

hook.Add('dbg-clothes.update', 'octologs', function(ply, clothes, old)
	if not (clothes and old) then return end
	local log = octologs.createLog(octologs.CAT_INVENTORY)
		:Add(octologs.ply(ply), ' put ', clothes and 'on' or 'off', ' ')
	if clothes then
		log = log:Add(octologs.table(clothes.name, clothes, true))
	else log = log:Add(octologs.table(old.name, old, true)) end
	log:Save()
end)

--
-- OTHER
--

hook.Add('dbg-camera.trigger', 'octologs', function(cam, vict, comment, sawAtt, att)
	local log = octologs.createLog(octologs.CAT_OTHER)
		:Add({cam.camName, {loc = octologs.location(cam)}}, ' ', comment, ' (triggered at ', octologs.ply(vict), ')')
	if sawAtt ~= nil then
		log = log:Add(' (could', sawAtt and '' or ' not', ' see the attacker, attacker was ', octologs.ply(att), ')')
	end
		log:Add('. Police online: ', tostring(#player.GetPolice()))
	log:Save()
end)

hook.Add('dbg-camera.damage', 'octologs', function(cam, att)
	local log = octologs.createLog(octologs.CAT_OTHER)
		:Add({cam.camName, {loc = octologs.location(cam)}}, ' was damaged')
	if IsValid(att) then
		log = log:Add(' by ')
		if att:IsPlayer() then
			log = log:Add(octologs.ply(att))
		else
			log = log:Add(octologs.ent(att))
		end
	end
		log:Add('. Police online: ', tostring(#player.GetPolice()))
	log:Save()
end)

hook.Add('dbg-camera.destroy', 'octologs', function(cam)
	octologs.createLog(octologs.CAT_OTHER)
		:Add({cam.camName, {loc = octologs.location(cam)}}, ' was destroyed.')
	:Save()
end)

hook.Add('PostPlayerSay', 'octologs', function(ply, text)
	octologs.createLog()
		:Add(octologs.ply(ply, {'loc', 'wep'}), ': ', octologs.string(text))
	:Save()
end)

hook.Add('PostConsoleSay', 'octologs', function(text)
	octologs.createLog()
		:Add('invalid player', ': ', octologs.string(text))
	:Save()
end)

hook.Add('octochat.commandExecuted', 'octologs', function(ply, text, cmdData, succ, msg)
	if not cmdData.log then return end
	octologs.createLog()
		:Add(octologs.ply(ply, {'loc', 'wep'}))
		:Add(' ', succ and 'successfully' or octologs.table('unsuccessfully', {msg}), ' ')
		:Add('executed chat command: ', octologs.string(text))
	:Save()
end)

hook.Add('dbg-trash.add', 'octologs', function(ent, ply, item)
	octologs.createLog(octologs.CAT_INVENTORY)
		:Add(octologs.ply(ply), ' put ', ('[%dx%s]'):format(item:GetData('amount'), item:GetData('name')))
		:Add(' in ', octologs.ent(ent))
	:Save()
end)

hook.Add('dbg-trash.empty', 'octologs', function(ent, ply)
	octologs.createLog(octologs.CAT_INVENTORY)
		:Add(octologs.ply(ply), ' emptied ', octologs.ent(ent))
	:Save()
end)

hook.Add('dbg-trash.loot', 'octologs', function(ent, ply, item)
	octologs.createLog(octologs.CAT_INVENTORY)
		:Add(octologs.ply(ply), ' found ', octoinv.itemStr(item), ' in ', octologs.ent(ent))
	:Save()
end)

hook.Add('dbg-trash.searchedEvidence', 'octologs', function(ent, ply, items)
	octologs.createLog(octologs.CAT_INVENTORY)
		:Add(octologs.ply(ply), ' searched ', octologs.ent(ent), ' for evidence and found ', octologs.table(#items .. ' items', items))
	:Save()
end)

hook.Add('gmpanel.moved', 'octologs', function(ply, target, pos, ang)
	octologs.createLog(octologs.CAT_OTHER)
		:Add(octologs.ply(ply), ' moved ', octologs.ply(target), ' via gmpanel')
	:Save()
end)
