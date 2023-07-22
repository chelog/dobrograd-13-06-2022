local function setLocked(ent, val)
	if ent.SetLocked then
		return ent:SetLocked(val)
	end

	if not ent:GetInventory() or not ent.lootable then
		return
	end

	ent.locked = val
	ent:EmitSound('doors/door_latch' .. (val and 1 or 3) .. '.wav', 55)

	if val then
		for contID, cont in pairs(ent.inv.conts) do
			for user, _ in pairs(cont.users) do
				cont:RemoveUser(user)
			end
		end
	end
end

local contUse = {
	function(ply, ent)
		return L.check_hint, 'octoteam/icons/search.png', function(ply, ent)
			ent:Use(ply, ply, USE_TOGGLE, 1)
		end
	end,
	function(ply, ent)
		local can, why = hook.Run('octoinv.canUnlock', ply, ent)
		if can == false then return end
		if not ent:GetInventory() then return end
		if not ent.locked then return end
		return L.open, 'octoteam/icons/lock_open.png', function(ply, ent)
			setLocked(ent, false)
		end
	end,
	function(ply, ent)
		local can, why = hook.Run('octoinv.canLock', ply, ent)
		if can == false then return end
		if not ent:GetInventory() then return end
		if ent.locked then return end
		if CurTime() < (ent.nextLock or 0) then return false, L.item_recently_lockpicked end
		return L.close, 'octoteam/icons/lock.png', function(ply, ent)
			setLocked(ent, true)
		end
	end,
	function(ply, ent)
		if not ent.locked or ent:GetNetVar('owner') == ply then return end
		if ply:CheckCrimeDenied() then return end
		if not ply.inv or not ply.inv.conts._hand or ply.inv.conts._hand:HasItem('lockpick') <= 0 then return end
		if ply:GetNetVar('dbg-police.job', '') ~= '' then return end
		return L.lockpick_action, 'octoteam/icons/lockpick.png', function(ply, ent)
			ply:Lockpick(ent, {
				timeOverride = ply:HasBuff('Dextradose') and 0.825 or nil,
				succ = function(ply, ent)
					setLocked(ent, false)
					ent.nextLock = CurTime() + 30
				end,
				check = function(ply, ent)
					return ply.inv.conts._hand:HasItem('lockpick') > 0
				end,
			})
		end
	end,
	function(ply, ent)
		if ent:GetNetVar('owner') ~= ply or ent.pendingOwner then return end
		return L.write_give, 'octoteam/icons/man_medit.png', function(ply, ent, args)
			-- ent:SetPlayer(args[1])
			ent.pendingOwner = args[1]
			ply:Notify('rp', L.give_end_when, args[1]:Name(), L.give_end_when2)
		end, function(ply, ent)
			local args = {}
			for i, v in ipairs(player.GetAll()) do
				if v ~= ply then
					table.insert(args, { v:Name(), v })
				end
			end

			return args
		end
	end,
	function(ply, ent)
		if not ent.pendingOwner or ent:GetNetVar('owner') ~= ply then return end
		return L.take_cancel, 'octoteam/icons/man_mdel.png', function(ply, ent)
			ent.pendingOwner = nil
			ply:Notify(L.take_cancel_hint)
		end
	end,
	function(ply, ent)
		if not ent.pendingOwner or ent.pendingOwner ~= ply then return end
		return L.take_item, 'octoteam/icons/man_medit.png', function(ply, ent)
			if isfunction(ent.CanBeOwnedBy) then
				local can, why = ent:CanBeOwnedBy(ply)
				if not can then
					ply:Notify('warning', why or 'Ты не можешь принять этот предмет сейчас')
					ent.pendingOwner = nil
					return
				end
			end
			ent:SetPlayer(ply)
			ent.pendingOwner = nil
			ply:Notify(L.now_is_your)
		end
	end,
	function(ply, ent)
		if ent.static or IsValid(ent.carWeld) or ent:GetNetVar('owner') ~= ply then return end
		local b = ent:NearestPoint(ent:GetPos() - Vector(0,0,1000))
		local t = {
			start = b,
			endpos = b - Vector(0,0,4),
			filter = ent,
		}

		local car = util.TraceLine(t).Entity
		if IsValid(car) and car.IsSimfphyscar then
			return L.freeze_on_car, 'octoteam/icons/screw.png', function(ply, ent)
				ent.carWeld = constraint.Weld(ent, car, 0, 0, 5000, true, false)
				ply:Notify(L.freezed_on_car)
			end
		else
			return L.freeze, 'octoteam/icons/screw.png', function(ply, ent)
				DarkRP.freeze(ply, ent, function(ok, msg)
					ply:Notify(ok and 'hint' or 'warning', msg)
				end)
			end
		end
	end,
	function(ply, ent)
		if ent:GetNetVar('owner') ~= ply then return end
		if IsValid(ent.carWeld) then
			return L.item_unfreezed_car, 'octoteam/icons/screw.png', function(ply, ent)
				ent.carWeld:Remove()
				ent.carWeld = nil
				ply:Notify(L.item_unfrozen_car)
			end
		elseif ent.static then
			return L.unfreeze, 'octoteam/icons/screw.png', function(ply, ent)
				DarkRP.unfreeze(ply, ent)
				ply:Notify(L.item_unfrozen)
			end
		end
	end,
	function(ply, ent)
		if ent.locked or not ent.DestructParts then return end
		local job = ply:getJobTable()
		if not job or not job.canDestruct then return end
		return L.destruct, 'octoteam/icons/crowbar.png', function(ply, ent)
			ply:DelayedAction('destruct', L.destruct_hint, {
				time = 30,
				check = function() return octolib.use.check(ply, ent) end,
				succ = function()
					ent:Destruct()
				end,
			}, {
				time = 1,
				inst = true,
				action = function()
					ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
					local sound = 'weapons/357/357_reload'.. math.random(1, 4) ..'.wav'
					ply:EmitSound(sound, 50)
				end,
			})
		end
	end,
}

CFG.use.octoinv_cont = contUse
CFG.use.octoinv_prod = contUse
CFG.use.octoinv_vend = table.Add(table.Copy(contUse), {
	function(ply, ent)
		if ent.locked or ent:GetNetVar('owner') ~= ply then return end
		return L.run, 'octoteam/icons/badge_sale.png', function(ply, ent)
			local r = {[0] = {
				name = L.run_hint,
				desc = L.desc_run_hint
			}}

			for k, slot in pairs(ent.slots) do
				local item = slot.cont.items[1]
				if item then
					r[k] = {
						required = true,
						type = 'strShort',
						numeric = true,
						name = string.format(L.vend_slot_hint, k, item:GetData('name')),
						ph = L.price_for_one,
					}
				end
			end

			octolib.request.send(ply, r, function(data)
				if not ent:SetPrices(data) then
					ply:Notify('warning', L.vend_price_fail)
				end
			end)
		end
	end,
})

CFG.use.octoinv_storage = {
	function(ply, ent)
		return L.check_hint, 'octoteam/icons/search.png', function(ply, ent)
			ent:Use(ply, ply, USE_TOGGLE, 1)
		end
	end,
	function(ply, ent)
		local canUnlock = ent.steamID == ply:SteamID() or ply:Team() == TEAM_ADMIN
		if not canUnlock or ent.locked then return end
		return L.close, 'octoteam/icons/lock.png', function(ply, ent)
			setLocked(ent, true)
			if canUnlock then ent.nextSteal = nil end

			local cont = ent.inv.conts['storage']
			for user, _ in pairs(cont.users) do
				cont:RemoveUser(user)
			end
		end
	end,
	function(ply, ent)
		if (ent.steamID ~= ply:SteamID() and ply:Team() ~= TEAM_ADMIN) or not ent.locked then return end
		return L.open, 'octoteam/icons/lock_open.png', function(ply, ent)
			setLocked(ent, false)
		end
	end,
	function(ply, ent)
		if not ent.locked or ent.steamID == ply:SteamID() then return end
		if ply:CheckCrimeDenied() then return end
		if not ply.inv or not ply.inv.conts._hand or ply.inv.conts._hand:HasItem('lockpick') <= 0 then return end
		if ply:GetNetVar('dbg-police.job', '') ~= '' then return end
		return L.lockpick_action, 'octoteam/icons/lockpick.png', function(ply, ent)
			ply:Lockpick(ent, {
				timeOverride = ply:HasBuff('Dextradose') and 0.825 or nil,
				succ = function(ply, ent)
					setLocked(ent, false)
					ent.nextLock = CurTime() + 30
				end,
				check = function(ply, ent)
					return ply.inv.conts._hand:HasItem('lockpick') > 0
				end,
			})
		end
	end,
	function(ply, ent)
		local owner = player.GetBySteamID(ent.steamID)
		if ent.locked or ply:GetNetVar('dbg-police.job', '') ~= '' then return end
		if IsValid(owner) and (owner == ply or (owner.Buddies and owner.Buddies[ply] and table.HasValue(owner.Buddies[ply], true))) then return end
		return L.steal, 'octoteam/icons/crowbar.png', function(ply, ent)
			if ent.stealing then
				ply:Notify('warning', L.already_stealing)
				return
			end

			if CurTime() < (ent.nextSteal or 0) then
				ply:Notify('warning', L.recent_stealed)
				return
			end

			ent.stealing = true
			ply:DelayedAction('steal', L.stealing, {
				time = 20,
				check = function() return octolib.use.check(ply, ent) and not ent.locked end,
				succ = function()
					local stolen = ent.inv:MoveRandom(ply.inv.conts._hand, {
						maxItems = 5,
						maxVolume = 25,
					})
					ent.nextSteal = CurTime() + 30 * 60
					ent.stealing = nil

					hook.Run('octoinv.stolen', table.GetFirstValue(ent.inv.conts), stolen, ply)
				end,
				fail = function()
					ent.stealing = nil
				end
			}, {
				time = 1,
				inst = true,
				action = function()
					ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
					ply:EmitSound('physics/cardboard/cardboard_box_shake'.. math.random(1, 3) ..'.wav', 50)
				end,
			})
		end
	end,
	function(ply, ent)
		local owner = player.GetBySteamID(ent.steamID)
		if not (IsValid(owner) and (owner == ply or (owner.Buddies and owner.Buddies[ply] and table.HasValue(owner.Buddies[ply], true)))) then return end
		if ent.static or IsValid(ent.carWeld) then return end
		local b = ent:NearestPoint(ent:GetPos() - Vector(0,0,1000))
		local t = {
			start = b,
			endpos = b - Vector(0,0,4),
			filter = ent,
		}

		local car = util.TraceLine(t).Entity
		if IsValid(car) and car.IsSimfphyscar then
			return L.freeze_on_car, 'octoteam/icons/screw.png', function(ply, ent)
				ent.carWeld = constraint.Weld(ent, car, 0, 0, 5000, true, false)
				ply:Notify(L.freezed_on_car)
			end
		else
			return L.freeze, 'octoteam/icons/screw.png', function(ply, ent)
				local pos = ent:GetPos()
				timer.Simple(1, function()
					if ent:GetPos():DistToSqr(pos) > 1 then
						ply:Notify(L.unstable)
						return
					end

					ent:GetPhysicsObject():EnableMotion(false)
					ent.static = true
					ply:Notify(L.item_freezed)
				end)
			end
		end
	end,
	function(ply, ent)
		local owner = player.GetBySteamID(ent.steamID)
		if not (IsValid(owner) and (owner == ply or (owner.Buddies and owner.Buddies[ply] and table.HasValue(owner.Buddies[ply], true)))) then return end
		if IsValid(ent.carWeld) then
			return L.item_unfreezed_car, 'octoteam/icons/screw.png', function(ply, ent)
				ent.carWeld:Remove()
				ent.carWeld = nil
				ply:Notify(L.item_unfrozen_car)
			end
		elseif ent.static then
			return L.unfreeze, 'octoteam/icons/screw.png', function(ply, ent)
				ent:GetPhysicsObject():EnableMotion(true)
				ent.static = nil
				ply:Notify(L.item_unfrozen)
			end
		end
	end,
}

local evidenceClasses = octolib.array.toKeys({
	'weapon', 'lockpick', 'lockpick_broken', 'throwable', 'ammo', 'armor',
	'drug_vitalex', 'drug_painkiller', 'drug_relaxant', 'drug_vampire', 'drug_dextradose', 'drug_roids',
	'drug_bouncer', 'drug_antitoxin', 'drug_weed', 'drug_pingaz', 'drug_preserver', 'drug_meth'
})
CFG.use.ent_dbg_trash = {
	function(ply, ent)
		return L.use, 'octoteam/icons/hand_point.png', function(ply, ent)
			ent:Use(ply, ply, USE_TOGGLE, 1)
		end
	end,
	function(ply, ent)
		if ent.pendingWorker ~= ply then return end
		return 'Выбросить мусор', octolib.icons.color('trash'), function(ply, ent)
			ent:NonHoboUse(ply)
		end
	end,
	function(ply, ent)
		local job = ply:getJobTable()
		if not (ply:isCP() or job.canZip) or ent.evidenceSearch then return end
		return 'Найти улики', octolib.icons.color('search'), function(ply, ent)

			if ply:isCP() and ply:Team() ~= TEAM_DPD and team.NumPlayers(TEAM_CORONER) >= 1 then
				return ply:Notify('warning', 'На сервере сейчас имеются коронёры, обратись за их помощью по рации')
			end

			if not (ply.inv and ply.inv.conts._hand) then
				return ply:Notify('warning', L.hands_free)
			end

			ent.evidenceSearch = true
			ply:DelayedAction('searchEvidence', 'Поиск улик', {
				time = math.Clamp(-ent.innerCont:FreeSpace() / 10, 5, 40),
				check = function() return octolib.use.check(ply, ent) and ply:isCP() end,
				succ = function()
					ent.evidenceSearch = nil
					local strs, mass, volume, ids = {}, 0, 0, {}
					for _, item in ipairs(ent.innerCont.items) do
						local class = item:GetData('class')
						if not evidenceClasses[class] then continue end
						strs[#strs + 1] = octoinv.itemStr({class, item})
						ids[#ids + 1] = item.id
						local amount = item:GetData('amount')
						mass = mass + item:GetData('mass') * amount
						volume = volume + item:GetData('volume') * amount
					end

					if not strs[1] then
						ply:Notify('warning', 'Улик не обнаружено')
						return
					end

					if ply.inv.conts._hand:AddItem('zip', {
						collector = ply:Nick() .. '\n\n',
						storedStr = table.concat(strs, ', '),
						amount = 1,
						mass = mass * 0.5,
						volume = math.min(volume * 0.5, 100),
						expire = os.time() + 60 * 60,
					}) > 0 then
						for i = #ids, 1, -1 do
							table.remove(ent.innerCont.items, ids[i])
						end
						ent.innerCont:QueueSync()
						hook.Run('dbg-trash.searchedEvidence', ent, ply, strs)
						ply:Notify('Найденные улики упакованы в ZIP-пакет')
					else ply:Notify('warning', 'В руках недостаточно места') end
				end,
				fail = function()
					ent.evidenceSearch = nil
				end
			}, {
				time = 1,
				inst = true,
				action = function()
					ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
					ply:EmitSound('physics/cardboard/cardboard_box_shake'.. math.random(1, 3) ..'.wav', 50)
				end,
			})

		end
	end,
	function(ply, ent)
		if not ply:IsSuperAdmin() then return end
		return 'Изменить модель', octolib.icons.color('cog'), function(ply, ent)
			ply:SelectModel(ent.models, function(ply, mdl, skin, bgs)
				if mdl and IsValid(ent) then
					ent:SetModel(mdl.model)
					ent:PhysicsInit(SOLID_VPHYSICS)
					ent:SetMoveType(MOVETYPE_VPHYSICS)
					ent:SetSolid(SOLID_VPHYSICS)

					local phys = ent:GetPhysicsObject()
					if phys:IsValid() then
						phys:Wake()
					end
					ent:Activate()
				end
			end)
		end
	end,
}

local propUse = octolib.table.mapSequential(contUse, function(func)
	return function(ply, ent)
		return func(ply, ent)
	end
end)

propUse[1] = function(ply, ent)
	if not ent:GetInventory() and not ent.lootable then return end
	return L.check_hint, 'octoteam/icons/search.png', function(ply, ent)
		if ent.locked then
			return ply:Notify('Предмет закрыт')
		end


		local lootData = ent.lootData
		local animTimes = 0

		local soundData
		if lootData.period and (lootData.soundURL or lootData.soundFile) then
			soundData = {
				dist = 512,
				url = lootData.soundURL,
				file = lootData.soundFile,
				level = 50,
				ent = ply,
				pos = ply:WorldToLocal(ply:GetShootPos()),
			}
		end

		ply:DelayedAction('loot', L.action_search, {
			time = lootData.time or 0,
			check = function() return octolib.use.check(ply, ent) end,
			succ = function()
				ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
				if ent.inv then ply:OpenInventory(ent.inv) end
			end,
		}, {
			time = 1.5,
			inst = true,
			action = function()
				ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
				if soundData and lootData.period and animTimes % lootData.period == 0 then
					octolib.audio.play(soundData)
				end
				animTimes = animTimes + 1
			end,
		})
	end
end
propUse[0] = function(ply, ent)
	if not ent.isFadingDoor then return end
	if not (ply:Team() == TEAM_DPD or ply:Team() == TEAM_WCSO) then return end
	return 'Выбить', 'octoteam/icons/door_breaching.png', function(ply, ent)
		timer.Simple(0.5, function()
			ent:fadeActivate()
			ent:EmitSound('physics/wood/wood_plank_break1.wav', 60)
		end)
	end
end

CFG.use.prop_static = propUse
CFG.use.prop_physics = propUse
