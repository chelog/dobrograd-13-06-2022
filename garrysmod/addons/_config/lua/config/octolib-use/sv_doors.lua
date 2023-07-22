local function cpCheckDoor(ply, ent)
	return ply:isCP() and not ent:IsBlocked() and not ent:CanBeOwned() and ent:GetPlayerOwner() ~= ply:SteamID()
end

local nextCI = 1 -- Common Index
-- local forbiddenSkins = octolib.array.toKeys {4,5,6,7,8,9,12} -- door breaching

local function toggleDoor(ent, ply, speedMul)

	ent.baseSpeed = ent.baseSpeed or tonumber(ent:GetInternalVariable('Speed'))
	ent:SetKeyValue('Speed', ent.baseSpeed * speedMul)
	ent:Use(ply, ply, USE_TOGGLE, 1)

	local pair = ent:GetPairedDoor()
	if not ent.doorCI then
		ent.doorCI = nextCI
		if IsValid(pair) then pair.doorCI = nextCI end
		nextCI = nextCI + 1
	end

	if ent:CanBeOwned() or ent:GetEstateID() == 0 then
		timer.Create('dbg-estates.close' .. ent.doorCI, 10, 1, function()
			if IsValid(ent) and (ent:CanBeOwned() or ent:GetEstateID() == 0) then
				ent:Fire('Close')
				if IsValid(pair) then pair:Fire('Close') end
			end
		end)
	end

end

local doorUse = {
	function(ply, ent)
		local isOpen = ent:GetInternalVariable('m_angRotation') ~= ent:GetInternalVariable('m_angRotationClosed')
		return isOpen and L.close or L.open, 'octoteam/icons/key.png', function(ply, ent)
			ent.unlockSound = ent.unlockSound or ent:GetInternalVariable('soundunlockedoverride')
			ent.lockSound = ent.lockSound or ent:GetInternalVariable('soundlockedoverride')

			if ent:HasSpawnFlags(4096) then
				ent:Fire('addoutput', 'spawnflags ' .. bit.band(ent:GetSpawnFlags(), bit.bnot(4096))) -- remove "silent" flag
				ent:SetKeyValue('soundunlockedoverride', ent.unlockSound)
				ent:SetKeyValue('soundlockedoverride', ent.lockSound)
			end

			toggleDoor(ent, ply, 1)

		end
	end,
	function(ply, ent)
		local isOpen = ent:GetInternalVariable('m_angRotation') ~= ent:GetInternalVariable('m_angRotationClosed')
		return (isOpen and L.close or L.open) .. ' тихо', 'octoteam/icons/leather_gloves.png', function(ply, ent)
			ent.unlockSound = ent.unlockSound or ent:GetInternalVariable('soundunlockedoverride')
			ent.lockSound = ent.lockSound or ent:GetInternalVariable('soundlockedoverride')

			if not ent:HasSpawnFlags(4096) then
				ent:Fire('addoutput', 'spawnflags ' .. bit.bor(ent:GetSpawnFlags(), 4096)) -- add "silent" flag
				ent:SetKeyValue('soundunlockedoverride', '') -- handle needs time to update "silent" flag
				ent:SetKeyValue('soundlockedoverride', '')
			end

			toggleDoor(ent, ply, 0.25)

		end
	end,

	function(ply, ent)
		if not ent:IsDoorLocked() then return end
		if not (ply:Team() == TEAM_DPD or ply:Team() == TEAM_WCSO) then return end
		-- if not ent:GetModel():find('models/props_c17/door01') or forbiddenSkins[ent:GetSkin()] then return end
		return 'Выбить дверь', 'octoteam/icons/door_breaching.png', function(ply, ent)

			if not ent:HasSpawnFlags(4096) then
				ent:Fire('addoutput', 'spawnflags ' .. bit.bor(ent:GetSpawnFlags(), 4096)) -- add "silent" flag
				ent:SetKeyValue('soundunlockedoverride', '') -- handle needs time to update "silent" flag
				ent:SetKeyValue('soundlockedoverride', '')
			end

			ent:DoUnlock()

			timer.Simple(0.5, function()
				toggleDoor(ent, ply, 7.5)
				ent:EmitSound('physics/wood/wood_plank_break1.wav', 60)
			end)
		end
	end,
	function(ply, ent)
		if ent:IsDoorLocked() then
			if ent:CanBeUnlockedBy(ply) and CurTime() > (ent.nextLock or 0) then
				return L.door_unlock, 'octoteam/icons/lock_open.png', function(ply, ent)
					ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
					ply:EmitSound('doors/door_latch1.wav')
					ent:DoUnlock()
				end
			end
		else
			if ent:CanBeLockedBy(ply) and CurTime() > (ent.nextLock or 0) then
				return L.door_lock, 'octoteam/icons/lock.png', function(ply, ent)
					ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
					ply:DelayedAction('door_lock', 'Закрытие замка', {
						time = 1.5,
						check = function() return octolib.use.check(ply, ent) end,
						succ = function()
							ply:EmitSound('doors/door_latch1.wav')
							ent:DoLock()
						end,
					})
				end
			end
		end
	end,
	function(ply, ent)
		if ent:IsDoorLocked() then
			if ent:CanBeUnlockedBy(ply) and CurTime() > (ent.nextLock or 0) then
				return 'Тихо открыть', 'octoteam/icons/lock_password.png', function(ply, ent)
					ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
					ply:DelayedAction('door_lock', 'Открытие замка', {
						time = 5,
						check = function() return octolib.use.check(ply, ent) end,
						succ = function()
							ent:DoUnlock()
						end,
					})
				end
			end
		else
			if ent:CanBeLockedBy(ply) and CurTime() > (ent.nextLock or 0) then
				return 'Тихо закрыть', 'octoteam/icons/lock_password.png', function(ply, ent)
					ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
					ply:DelayedAction('door_lock', 'Закрытие замка', {
						time = 5,
						check = function() return octolib.use.check(ply, ent) end,
						succ = function()
							ent:DoLock()
						end,
					})
				end
			end
		end
	end,
	function(ply, ent)
		if not ent:IsDoorLocked() or ent:CanBeUnlockedBy(ply) then return end
		if ply:CheckCrimeDenied() then return end
		if not ply.inv or not ply.inv.conts._hand or ply.inv.conts._hand:HasItem('lockpick') <= 0 then return end
		return L.lockpick_action, 'octoteam/icons/lockpick.png', function(ply, ent)
			ply:Lockpick(ent, {
				timeOverride = ply:HasBuff('Dextradose') and 0.825 or nil,
				succ = function(ply, ent)
					ent:DoUnlock()
					ent:EmitSound('doors/door_latch1.wav')
					ent.nextLock = CurTime() + 30
				end,
				check = function(ply, ent)
					return ply.inv.conts._hand:HasItem('lockpick') > 0
				end,
			})
		end
	end,
	function(ply, ent)
		if not peepholes.canAccess(ply, ent) or ply.peephole then return end
		return 'Посмотреть в глазок', 'octoteam/icons/bubble.png', function(ply, ent)
			if peepholes.canAccess(ply, ent) and not ply.peephole then peepholes.view(ply, ent) end
		end
	end,
	function(ply, ent)
		if ent:GetPlayerOwner() ~= ply:SteamID() then return end
		return 'Поставить табличку', 'octoteam/icons/tag.png', function()
			octolib.request.send(ply, {{
				type = 'strShort',
				name = 'Текст',
				desc = 'Укажи текст таблички (до 32 символов). Оставь пустым, чтобы убрать табличку',
				default = ent:GetTitle(),
			}}, function(data)
				if not istable(data) or (data[1] ~= nil and not isstring(data[1])) then return end
				local txt
				if isstring(data[1]) then
					txt = string.Trim(data[1])
					txt = utf8.sub(txt, 1, 32)
					if txt == '' then txt = nil end
				end
				if ent:GetPlayerOwner() == ply:SteamID() then
					ent:SetNetVar('tempTitle', txt)
				end
			end)
		end
	end,
	function(ply, ent)
		if not cpCheckDoor(ply, ent) then return end
		return L.check_hint, 'octoteam/icons/card2.png', function (ply, ent)
			ply:DoEmote('{name} проверяет недвижимость по базе данных')
			ply:DelayedAction('est_check', L.check_action, {
				time = 10,
				check = function() return octolib.use.check(ply, ent) and cpCheckDoor(ply, ent) end,
				succ = function()
					netstream.Start(ply, 'dbg-doors.identify', ent:GetEstateID())
					ply:Notify('Информация о недвижимости обновлена')
				end,
			})
		end
	end,
	function(ply, ent)
		if not ent:CanBeOwned() then return end
		local job = RPExtraTeams[ply:Team()]
		if job and job.hobo then return end
		return L.buy, 'octoteam/icons/money_pack.png', function()
			if not ent:CanBeOwned() then return end
			if not ply:BankHas(ent:GetPrice()) then
				return ply:Notify('warning', 'Маловато деньжат на банковском счете, дружище')
			end

			local function buy(ply, ent)
				if not (IsValid(ply) and IsValid(ent)) then return end
				if not ent:CanBeOwned() then return end
				local price = ent:GetPrice()
				if not ply:BankHas(price) then
					return ply:Notify('warning', 'Маловато деньжат на банковском счете, дружище')
				end
				ent:SetPlayerOwner(ply)
				ply:BankAdd(-price)
				ply:Notify(L.door_bought:format(DarkRP.formatMoney(price)))
			end

			local est = ent:GetEstate()
			if est and est.purpose then
				local forBusiness = (est.purpose == 1)
				octolib.request.send(ply, {{
					name = 'Помещение для ' .. (forBusiness and 'бизнеса' or 'проживания'),
					desc = (forBusiness and L.estate_business_only or L.estate_residency_only) .. '\n\nИгнорирование этого предупреждения может привести к выселению или даже выдаче наказания',
					type = 'check',
					txt = 'Я буду использовать это помещение только для ' .. (forBusiness and 'бизнеса' or 'проживания'),
					required = true,
				}}, function(data)
					if data and data[1] then buy(ply, ent) end
				end)
			else buy(ply, ent) end

		end
	end,
	function(ply, ent)
		if netvars.GetNetVar('pendingTax') or ent:GetPlayerOwner() ~= ply:SteamID() then return end
		return L.sell, 'octoteam/icons/money_pack.png', function()
			if netvars.GetNetVar('pendingTax') or ent:GetPlayerOwner() ~= ply:SteamID() then return end
			local prSell = math.floor(ent:GetPrice() * 0.666 + 0.5)
			ent:RemoveOwner(ply:SteamID())
			ply:addMoney(prSell)
			ply:Notify(L.door_sold:format(DarkRP.formatMoney(prSell)))
		end
	end,
}

CFG.use.func_door = doorUse
CFG.use.func_door_rotating = doorUse
CFG.use.prop_door_rotating = doorUse
CFG.use.func_movelinear = doorUse
