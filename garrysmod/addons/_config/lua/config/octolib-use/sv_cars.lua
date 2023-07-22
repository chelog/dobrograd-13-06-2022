local function exitPlayer(ent, sender)

	local driver = ent:GetDriver()
	local HasPassenger = IsValid(driver)

	if HasPassenger then
		local cuffed, cuffs = driver:IsHandcuffed()
		if cuffed then
			driver.isForce = true
		end

		driver.handledVehicleExit = true
		local can = hook.Run('CanExitVehicle', ent, driver)
		driver.handledVehicleExit = nil
		driver.isForce = false
		if can == false then
			if sender then
				sender:Notify('warning', 'Что-то мешает высадить ' .. driver:Name())
			end
			return
		end

		driver:ExitVehicle()
		driver:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	end

end

CFG.use.gmod_sent_vehicle_fphysics_base = {

	function(ply, ent)
		local seat = ply:GetVehicle()
		if IsValid(seat) and seat:GetParent() == ent then return end

		return L.sit, 'octoteam/icons/door_open.png', function(ply, ent)
			ent:Use(ply, ply, USE_TOGGLE, 1)
		end
	end,

	function(ply, ent)
		local seat = ply:GetVehicle()
		if not IsValid(seat) or seat:GetParent() ~= ent then return end

		return 'Выйти', 'octoteam/icons/door_open.png', function(ply)
			exitPlayer(ply:GetVehicle())
		end
	end,

	function(ply, ent)
		if ply ~= ent:CPPIGetOwner() then return end
		if ent:GetIsLocked() then
			return L.open, 'octoteam/icons/lock_open.png', function(ply, ent)
				ent:UnLock()
			end
		else
			return L.close, 'octoteam/icons/lock.png', function(ply, ent)
				ent:Lock()
			end
		end
	end,

	function(ply, ent)
		if not ent.inv or not ent.inv.conts.trunk then return end
		local canOpen = ply:Team() == TEAM_ADMIN or ply == ent:CPPIGetOwner() or (not ent:GetIsLocked() and ply:Team() == TEAM_DPD) or false
		return 'Багажник', 'octoteam/icons/car_trunk.png', function(ply, ent, args)
			local back = ent:NearestPoint(ent:WorldSpaceCenter() + ent.Forward * -1000)
			if (ply:GetShootPos() - back):Length2DSqr() > CFG.useDistSqr then
				return ply:Notify('warning', 'Подойди ближе к задней части автомобиля')
			end

			if canOpen then
				if args[1] == 'lock' then
					ent.trunkOpen = nil
					ent:EmitSound('doors/door_latch1.wav')
					ent.inv.conts.trunk:RemoveUsers()
				elseif args[1] == 'unlock' then
					ent.trunkOpen = true
					ent:EmitSound('doors/door_latch1.wav')
					ply:OpenInventory(ent.inv, {'trunk'})
					ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
				end
			end

			if args[1] == 'open' then
				if not ent.trunkOpen then return end
				ply:OpenInventory(ent.inv, {'trunk'})
				ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
			elseif args[1] == 'lockpick' then
				if not ply.inv.conts._hand or ply.inv.conts._hand:HasItem('lockpick') <= 0 then return end
				ply:SetEyeAngles((back - ply:GetShootPos()):Angle())
				ply:Lockpick(ent, {
					timeOverride = ply:HasBuff('Dextradose') and 0.825 or nil,
					succ = function(ply, ent)
						ent.trunkOpen = true
						ent:EmitSound('doors/door_latch1.wav')
					end,
					check = function(ply, ent)
						if ply.inv.conts._hand:HasItem('lockpick') <= 0 then return false end
						if not IsValid(ent) then return false end
						if (ply:GetShootPos() - back):Length2DSqr() > CFG.useDistSqr then
							return false
						end
						return true
					end,
				})
			end
		end, function(ply, ent)
			local opts = {}
			if ent.trunkOpen then
				opts[#opts + 1] = {'Использовать', 'open'}
				if canOpen then
					opts[#opts + 1] = {'Закрыть', 'lock'}
				end
			else
				if canOpen then
					opts[#opts + 1] = {'Открыть', 'unlock'}
				elseif not ply:CheckCrimeDenied() then
					if ply.inv.conts._hand and ply.inv.conts._hand:HasItem('lockpick') > 0 then
						opts[#opts + 1] = {'Взломать', 'lockpick'}
					else
						opts[#opts + 1] = {'Для взлома нужна отмычка в руках'}
					end
				end
			end

			return opts
		end
	end,

	function(ply, ent)
		local carInv = ent:GetInventory()
		if not carInv or not carInv.conts.glove then return end
		if ply:Team() ~= TEAM_ADMIN and ply:Team() ~= TEAM_DPD then return end
		if ent:GetIsLocked() and ply:Team() == TEAM_DPD then return end
		return 'Бардачок', 'octoteam/icons/car_glovebox.png', function(ply, ent, args)
			ply:OpenInventory(carInv, {'glove'})
		end
	end,

	function(ply, ent)
		if ply == ent:CPPIGetOwner() then return end
		if ply:CheckCrimeDenied() then return end
		if not ply.inv or not ply.inv.conts._hand or ply.inv.conts._hand:HasItem('lockpick') <= 0 then return end
		if ply:GetNetVar('dbg-police.job', '') ~= '' then return end
		local dSeat = ent.DriverSeat
		if not IsValid(dSeat) then return end
		return L.lockpick_action, 'octoteam/icons/lockpick.png', function(ply, ent)
			local dPos = dSeat:GetPos()
			if (ply:GetShootPos() - dPos):Length2DSqr() > CFG.useDistSqr then
				return ply:Notify('Подойди ближе к двери водительского сидения')
			end
			ply:SetEyeAngles((dPos - ply:GetShootPos()):Angle())
			ply:Lockpick(ent, {
				timeOverride = ply:HasBuff('Dextradose') and 0.825 or nil,
				succ = function(ply, ent)
					ent:UnLock()
					ent.lockpicked = true
					ent.nextLock = CurTime() + 30
				end,
				check = function(ply, ent)
					if ply.inv.conts._hand:HasItem('lockpick') <= 0 then return false end
					if not IsValid(dSeat) then return false end
					dPos = dSeat:GetPos()
					if (ply:GetShootPos() - dPos):Length2DSqr() > CFG.useDistSqr then
						return false
					end
					return true
				end,
			})
		end
	end,

	function(ply, ent)
		local target = ply:GetNetVar('dragging')
		if not IsValid(target) then return end

		return L.plant_the_detainee, 'octoteam/icons/handcuffs.png', function(ply, ent)
			local cuffed, cuffs = target:IsHandcuffed()
			if IsValid(target) and cuffed and target:GetNetVar('dragger') == ply then
				target.isForce = true
				ent:SetPassenger(target, true)
			end
		end
	end,

	function(ply, ent)
		local owner = ent:CPPIGetOwner()
		if not (ply == owner or not IsValid(owner) or ent.lockpicked or (owner.Buddies and owner.Buddies[ply] and table.HasValue(owner.Buddies[ply], true))) then return end

		return L.to_land, 'octoteam/icons/clothes_boot.png', function(ply, ent, args)
			if IsValid(ent) then
				if args[1] then
					exitPlayer(args[1], ply)
				else
					for _, v in ipairs(ent:GetChildren()) do
						if v:GetClass() == 'prop_vehicle_prisoner_pod' then
							local driver = v:GetDriver()
							if IsValid(driver) then
								exitPlayer(v, ply)
							end
						end
					end
				end
			end
		end, function(ply, ent)
			local args = {{L.to_land_all}}
			for _, v in ipairs(ent:GetChildren()) do
				if v:GetClass() == 'prop_vehicle_prisoner_pod' and IsValid(v:GetDriver()) then
					table.insert(args, {v:GetDriver():Name(), v})
				end
			end
			return args
		end
	end,
	function(ply, ent)
		local job = ply:getJobTable()
		if not job.mech then return end
		local can, why = simfphys.CanPlayerTune(ply, ent)
		if not can then return false, why end
		return L.suspension, 'octoteam/icons/metal_spring.png', function(ply, ent, args)
			if ply:HasItem('tool_susp') <= 0 then return end

			local susp = {}
			local carData = list.Get('simfphys_vehicles')[ent.VehicleName].Members
			if args[1] == 1 then
				octolib.request.send(ply, {{
					name = L.car_front_suspension,
				},{
					type = 'numSlider', min = -1, max = 1,
					txt = L.height, val = ent:GetFrontSuspensionHeight() or 0,
				},{
					type = 'numSlider', min = carData.FrontConstant, max = carData.FrontConstant * 2, dec = 0,
					txt = L.rigidity, val = ent.consF or carData.FrontConstant,
				},{
					type = 'numSlider', min = 0, max = carData.FrontDamping * 1.5, dec = 0,
					txt = L.car_blanking, val = ent.dampF or carData.FrontDamping,
				},{
					type = 'numSlider', min = -8, max = 4,
					txt = L.car_takeaway, val = ent.wOffsetF or 0,
				},{
					name = L.car_rear_suspension,
				},{
					type = 'numSlider', min = -1, max = 1,
					txt = L.height, val = ent:GetRearSuspensionHeight() or 0,
				},{
					type = 'numSlider', min = carData.RearConstant, max = carData.RearConstant * 2, dec = 0,
					txt = L.rigidity, val = ent.consR or carData.RearConstant,
				},{
					type = 'numSlider', min = 0, max = carData.RearDamping * 1.5, dec = 0,
					txt = L.car_blanking, val = ent.dampR or carData.RearDamping,
				},{
					type = 'numSlider', min = -4, max = 4,
					txt = L.car_takeaway, val = ent.wOffsetR or 0,
				},{
					name = L.other,
				},{
					type = 'numSlider', min = -18, max = 10, dec = 0,
					txt = L.car_collapse, val = ent.camber or 0,
				}}, function(data)
					simfphys.SetupSuspension(ent, {
						data[2] or ent:GetFrontSuspensionHeight() or 0,
						data[3] or ent.consF or carData.FrontConstant or 25000,
						data[4] or ent.dampF or carData.FrontDamping or 1500,
						data[7] or ent:GetRearSuspensionHeight() or 0,
						data[8] or ent.consR or carData.RearConstant or 25000,
						data[9] or ent.dampR or carData.RearDamping or 1500
					})

					simfphys.ApplyWheel(ent, data[12] or ent.camber or 0, ent.wModelF or carData.CustomWheelModel or 'models/salza/zaz/zaz_wheel.mdl')
					simfphys.SetWheelOffset(ent, data[5] or 0, data[10] or 0)
					timer.Simple(1, function() carDealer.saveVeh(ent) end)
				end)
			elseif args[1] == 2 then
				simfphys.SetupSuspension(ent, {
					0,
					carData.FrontConstant or 25000,
					carData.FrontDamping or 1500,
					0,
					carData.RearConstant or 25000,
					carData.RearDamping or 1500
				})

				simfphys.ApplyWheel(ent, 0, ent.wModelF or carData.CustomWheelModel or 'models/salza/zaz/zaz_wheel.mdl')
				simfphys.SetWheelOffset(ent, 0, 0)
				timer.Simple(1, function() carDealer.saveVeh(ent) end)
			end
		end, function(ply, ent)
			if ply:HasItem('tool_susp') <= 0 then return {{L.need_suspension, -1}} end
			local can, why = simfphys.CanPlayerTune(ply, ent)
			if not can then return {{why or L.unavailable, -1}} end
			return {
				{L.regulate, 1},
				{L.reset, 2},
			}
		end
	end,
	function(ply, ent)
		-- local job = ply:getJobTable()
		-- if not job.mech then return end
		local can, why = simfphys.CanPlayerTune(ply, ent)
		if not can then return false, why end
		return L.take_off, 'octoteam/icons/tag_delete.png', function(ply, ent, args)
			if ply:HasItem('tool_wrench') < 1 or ply:HasItem('tool_screwer') < 1 then return end
			if not ply.inv or not ply.inv.conts._hand then return end

			local att = ent:GetNetVar('atts')[args[1]]
			if not att or not att.name then return end

			ply:DelayedAction('car_mount', L.dismantling, {
				time = 20,
				check = function() return octolib.use.check(ply, ent) and ply.inv and ply.inv.conts._hand end,
				succ = function()
					local atts = ent:GetNetVar('atts')
					local att = table.remove(atts, args[1])
					ent:SetNetVar('atts', atts)

					local attData = simfphys.getAttByModel(att.model)
					if attData then
						ply.inv.conts._hand:AddItem('car_att', {
							name = attData.name,
							desc = attData.desc,
							icon = attData.icon,
							mass = attData.mass,
							volume = attData.volume,
							colorable = not attData.noPaint or nil,
							attmdl = attData.mdl,
							model = attData.mdl,
							skin = attData.skin,
							scale = attData.scale,
						})
					else
						ply.inv.conts._hand:AddItem('car_att', {
							name = att.name,
							icon = att.icon,
							mass = att.mass,
							volume = att.volume,
							colorable = att.colorable,
							attmdl = att.model,
							model = att.model,
							skin = att.skin,
							scale = att.scale,
						})
					end

					timer.Simple(1, function() carDealer.saveVeh(ent) end)
				end,
			}, {
				time = 1.5,
				inst = true,
				action = function()
					ply:EmitSound('ambient/machines/pneumatic_drill_' .. math.random(1, 4) .. '.wav')
					ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
				end,
			})
		end, function(ply, ent)
			if ply:HasItem('tool_wrench') < 1 or ply:HasItem('tool_screwer') < 1 then return {{L.need_wrench_and_screwer, -1}} end
			if not ply.inv or not ply.inv.conts._hand then return {{L.hands_free, -1}} end
			local can, why = simfphys.CanPlayerTune(ply, ent)
			if not can then return {{why or L.unavailable, -1}} end

			local atts = ent:GetNetVar('atts')
			local opts = {}
			if atts then
				for id, att in ipairs(atts) do
					if att.name then table.insert(opts, {att.name, id}) end
				end
			end
			return opts
		end
	end,
	function(ply, ent)
		if ply:Team() ~= TEAM_ADMIN then return end
		return 'Сбросить', 'octoteam/icons/license_plate_remove.png', function(ply, ent, args)
			local owner = ent:CPPIGetOwner()
			if not IsValid(owner) then return ply:Notify('warning', 'Для этого владелец автомобиля должен быть на сервере') end

			if args[1] == -1 then
				local carData = list.Get('simfphys_vehicles')[ent.VehicleName].Members
				simfphys.SetupSuspension(ent, {
					0,
					carData.FrontConstant or 25000,
					carData.FrontDamping or 1500,
					0,
					carData.RearConstant or 25000,
					carData.RearDamping or 1500
				})
				simfphys.ApplyWheel(ent, 0, ent.wModelF or carData.CustomWheelModel or 'models/salza/zaz/zaz_wheel.mdl')
				simfphys.SetWheelOffset(ent, 0, 0)
				timer.Simple(1, function() carDealer.saveVeh(ent) end)

				ply:Notify('Настройки подвески были сброшены, уведомление отправлено владельцу')
				owner:Notify('ooc', 'Администрация сбросила настройки подвески на твоем автомобиле. Если у тебя есть вопросы, открой жалобу через @')
				return
			end

			if args[1] == -2 then
				local col = ent:GetColor()
				if col.r + col.g + col.b == 255 * 3 then return end

				ent:SetColor(Color(255,255,255))
				carDealer.saveVeh(ent)

				octoinv.addReturnItems(owner, {{'car_paint', 1}})

				ply:Notify('Цвет автомобиля был сброшен, уведомление отправлено владельцу')
				owner:Notify('ooc', 'Администрация сбросила покраску твоего автомобиля. Краску можно вернуть в магазине. Если у тебя есть вопросы, открой жалобу через @')
				return
			end

			if args[1] == -3 then
				carDealer.getPlateChangeHistory(ent:GetNetVar('cd.id'), ply:SteamID(), function(gCount, history)
					if not history[1] or ent:GetNetVar('cd.plate') ~= history[1] then
						return ply:Notify('warning', 'У этого игрока не блатной номер')
					end
					local desc = ''
					gCount = gCount - 1
					if gCount > 0 then
						desc = desc .. 'Владелец ранее менял номера своих автомобилей ' .. gCount .. ' раз' .. octolib.string.formatCount(gCount, '', 'а', '')
					else desc = desc .. 'Владелец ранее не менял номера своих автомобилей' end
					if history[1] then
						desc = desc .. ' История установки блатных номеров этого автомобиля: ' .. (#history == 20 and '... -> ' or '') .. string.Implode(' -> ', table.Reverse(history))
					end
					octolib.request.send(ply, {
						{
							name = 'Сброс номера',
							desc = 'Это действие нужно осуществлять только если номер нарушает правила. Запрещено использовать эту функцию в корыстных целях'
						}, {
							desc = desc,
						}, {
							type = 'check',
							desc = 'Если такое нарушение было зафиксировано впервые, плюшку следует вернуть',
							txt = 'Вернуть плюшку',
							check = true,
						}, {
							desc = 'Факт сброса номера будет сохранен',
						}
					}, function(data)
						if not IsValid(ent) then return end
						carDealer.resetPlate(ent, data[3], ply)
					end)
				end)
				return
			end

			local att = ent:GetNetVar('atts')[args[1]]
			if not att or not att.name then return end

			local atts = ent:GetNetVar('atts')
			local att = table.remove(atts, args[1])
			ent:SetNetVar('atts', atts)
			timer.Simple(1, function() carDealer.saveVeh(ent) end)

			local attData = simfphys.getAttByModel(att.model)
			if attData then
				octoinv.addReturnItems(owner, {{'car_att', {
					name = attData.name,
					desc = attData.desc,
					icon = attData.icon,
					mass = attData.mass,
					volume = attData.volume,
					colorable = not attData.noPaint or nil,
					attmdl = attData.mdl,
					model = attData.mdl,
					skin = attData.skin,
					scale = attData.scale,
				}}})
			else
				octoinv.addReturnItems(owner, {{'car_att', {
					name = att.name,
					icon = att.icon,
					mass = att.mass,
					volume = att.volume,
					colorable = att.colorable,
					attmdl = att.model,
					model = att.model,
					skin = att.skin,
					scale = att.scale,
				}}})
			end

			ply:Notify('Аксессуар был снят с автомобиля и возвращен владельцу')
			owner:Notify('ooc', 'Администрация сняла аксессуар ' .. att.name .. ' с твоего автомобиля, его можно вернуть через магазин. Если у тебя есть вопросы, открой жалобу через @')
		end, function(ply, ent)
			local opts = {
				{'Подвеска', -1},
			}

			local col = ent:GetColor()
			if col.r + col.g + col.b ~= 255 * 3 then
				opts[#opts + 1] = {'Цвет', -2}
			end

			if ply:query('DBG: Сбрасывать номера') then
				opts[#opts + 1] = {'Номер', -3}
			end

			local atts = ent:GetNetVar('atts')
			if atts then
				for id, att in ipairs(atts) do
					if att.name then table.insert(opts, {att.name, id}) end
				end
			end

			return opts
		end
	end,
	function(ply, ent)
		if not ply:isCP() then return end
		return L.check_hint, 'octoteam/icons/card2.png', function(ply, ent, args)
			ply:DoEmote(L.emote_check)
			ply:DelayedAction('car_check', L.check_action, {
				time = 10,
				check = function() return octolib.use.check(ply, ent) end,
				succ = function()
					local owner = ent:CPPIGetOwner()
					local name = IsValid(owner) and owner:Name() or L.unknown
					ply:Notify(L.car_owner_hint .. name)
				end,
			})
		end
	end,
	function(ply, ent)
		if not ent.police then return end

		local bodygroup, takeOff, armorOn, armorOff
		if ply:Team() == TEAM_DPD then
			local mdl = ply:GetModel()
			if mdl:find('octo_dpd/') then
				bodygroup, armorOn, armorOff = 8, 50, 28
			elseif mdl:find('dpdsl/') or mdl:find('dpdfem/') then
				bodygroup, armorOn, armorOff = 3, 50, 28
			else return end
		elseif ply:Team() == TEAM_WCSO then
			bodygroup, armorOn, armorOff = 1, 65, 40
		elseif ply:Team() == TEAM_ALPHA then
			bodygroup, armorOn, armorOff = 5, 55, 45
		else return end

		takeOff = ply:GetBodygroup(bodygroup) == 1
		return (takeOff and 'Снять' or 'Надеть') .. ' бронежилет', 'octoteam/icons/armor.png', function(ply, ent, args)
			local back = ent:NearestPoint(ent:WorldSpaceCenter() + ent.Forward * -1000)
			if (ply:GetShootPos() - back):Length2DSqr() > CFG.useDistSqr then
				return ply:Notify('warning', 'Подойди ближе к задней части автомобиля')
			end

			ply:DelayedAction('armor', (takeOff and 'Снятие' or 'Экипировка') .. ' бронежилета', {
				time = 5,
				check = function()
					return octolib.use.check(ply, ent)
				end,
				succ = function()
					ply:DoEmote('{name}, открыв багажник с помощью ключа, ' .. (takeOff and 'снимает' or 'надевает') .. ' бронежилет и закрывает багажник')
					ply:SetArmor(takeOff and armorOff or armorOn)
					ply:SetBodygroup(bodygroup, takeOff and 0 or 1)
				end,
			}, {
				time = 1.5,
				inst = true,
				action = function()
					ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
					if IsValid(ent) then
						ent:EmitSound('npc/combine_soldier/gear'.. math.random(1, 2) ..'.wav', 45)
					end
				end,
			})
		end
	end,
	function(ply, ent)
		local cdData = ent.cdData
		if not (cdData and cdData.glauncher) then return end
		if not ent.police then return end
		local wep = ply:GetActiveWeapon()
		if not IsValid(wep) or wep:GetClass() ~= 'weapon_octo_grenade_launcher' then return end
		return 'Пополнить снаряды', 'octoteam/icons/grenade_launcher.png', function(ply, ent, args)
			if ply:GetActiveWeapon() ~= wep then return end

			if ent.lockerBusy then
				return ply:Notify('warning', 'Кто-то уже сейчас пользуется багажником')
			end

			ply:DelayedAction('glauncher', 'Использование багажника', {
				time = 4,
				check = function()
					if not octolib.use.check(ply, ent) then return false end
					if ply:GetActiveWeapon() ~= wep then return false end
					return true
				end,
				succ = function()
					ent.lockerBusy = nil
					wep:Recharge()
					ply:DoEmote('{name} пополняет запас 40-мм снарядов для гранатомета')
				end,
				fail = function()
					ent.lockerBusy = nil
				end,
			}, {
				time = 1.5,
				inst = true,
				action = function()
					ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
					if IsValid(ent) then
						ent:EmitSound('npc/combine_soldier/gear'.. math.random(1, 2) ..'.wav', 45)
					end
				end,
			})

			ent.lockerBusy = true

		end
	end,
	function(ply, ent)
		if not ent.police or not (ply:Team() == TEAM_DPD or ply:Team() == TEAM_WCSO) then return end
		return 'Аммуниция', 'octoteam/icons/gun_rifle.png', function(ply, ent, args)
			ent.locker = ent.locker or {}

			local isTrunk, weaponClass, weaponModel = unpack(args)

			local back = ent:NearestPoint(ent:WorldSpaceCenter() + ent.Forward * -1000)
			if isTrunk and (ply:GetShootPos() - back):Length2DSqr() > CFG.useDistSqr then
				return ply:Notify('warning', 'Подойди ближе к задней части автомобиля')
			end

			if ent.lockerBusy then
				return ply:Notify('warning', 'Кто-то уже сейчас достает оружие')
			end

			if ent.locker[weaponClass] and not ply:HasWeapon(weaponClass) then
				return ply:Notify('warning', 'Чтобы это вернуть, нужно это иметь')
			end

			ply:DelayedAction('locker', 'Использование ' .. (isTrunk and 'багажника' or 'локера'), {
				time = 4,
				check = function()
					if not octolib.use.check(ply, ent) then return false end
					if ent.locker[weaponClass] and not ply:HasWeapon(weaponClass) then return false end
					return true
				end,
				succ = function()
					ent.lockerBusy = nil
					if ent.locker[weaponClass] then
						ply:StripWeapon(weaponClass)
						for i, wep in ipairs(ply.orgWeps) do
							if wep == weaponClass then
								table.remove(ply.orgWeps, i)
							end
						end
						ent.locker[weaponClass] = nil
					else
						ply.orgWeps = ply.orgWeps or {}
						ply.orgWeps[#ply.orgWeps + 1] = weaponClass
						ent.locker[weaponClass] = true
						local wep = ply:Give(weaponClass)
							if weaponModel then wep.WorldModel = weaponModel end
							local clip1 = wep:GetMaxClip1()
							if clip1 then wep:SetClip1(clip1) end
						wep:Initialize()
					end
				end,
				fail = function()
					ent.lockerBusy = nil
				end,
			}, {
				time = 1.5,
				inst = true,
				action = function()
					ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
					if IsValid(ent) then
						ent:EmitSound('npc/combine_soldier/gear'.. math.random(1, 2) ..'.wav', 45)
					end
				end,
			})

			ent.lockerBusy = true

		end, function(ply, ent)
			local opts = {
				{'M4A1', false, 'weapon_octo_m4a1'},
				{'M3', false, 'weapon_octo_m3'},
				{'BeanBag', true, 'weapon_octo_beanbag'},
				{'щит', true, 'dbg_shield', 'models/bshields/rshield.mdl'},
			}
			if ply:GetActiveRank('dpd') == 'swat' then table.Empty(opts) end

			for i, data in ipairs(opts) do
				data[1] = (ent.locker and ent.locker[data[3]] and 'Вернуть ' or 'Взять ') .. data[1]
			end

			local cdData = ent.cdData
			if cdData and cdData.glauncher and (ply:GetActiveRank('dpd') == 'swat' or ply:GetActiveRank('wcso') == 'seb') then
				opts[#opts + 1] = {
					(ent.locker and ent.locker['weapon_octo_grenade_launcher'] and 'Вернуть ' or 'Взять ') .. 'гранатомет',
					true, 'weapon_octo_grenade_launcher'
				}
			end

			return opts
		end
	end,
	function(ply, ent)
		if not (ply:Team() == TEAM_DPD or ply:Team() == TEAM_WCSO) or not ent.police then return end
		local giveBack = ent.usedspikes
		if giveBack and ply:HasItem('spike_strips') <= 0 then return end
		return (giveBack and 'Вернуть ' or 'Взять ') .. 'полицейские шипы', 'octoteam/icons/spike_strips.png', function(ply, ent, args)
			local back = ent:NearestPoint(ent:WorldSpaceCenter() + ent.Forward * -1000)
			if (ply:GetShootPos() - back):Length2DSqr() > CFG.useDistSqr then
				return ply:Notify('warning', 'Подойди ближе к задней части автомобиля')
			end

			if ent.spikesBusy then
				ply:Notify('warning', 'Кто-то уже сейчас достает шипы')
				return
			end

			ply:DelayedAction('spikes', 'Использование багажника', {
				time = 5,
				check = function()
					if not octolib.use.check(ply, ent) then return false end
					if giveBack and ply:HasItem('spike_strips') <= 0 then return false end
					return true
				end,
				succ = function()
					ent.spikesBusy = nil
					ply:DoEmote('{name}, открыв багажник с помощью ключа, ' .. (giveBack and 'возвращает' or 'достает') .. ' шипы и закрывает багажник')
					if giveBack then
						ply:TakeItem('spike_strips')
						ent.usedspikes = nil
					else
						ply:AddItem('spike_strips', {expire = os.time() + 7200})
						ent.usedspikes = true
					end
				end,
				fail = function()
					ent.spikesBusy = nil
				end,
			}, {
				time = 1.5,
				inst = true,
				action = function()
					ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
					if IsValid(ent) then
						ent:EmitSound('physics/rubber/rubber_tire_strain' ..math.random(1,3) ..'.wav', 65)
					end
				end,
			})

			ent.spikesBusy = true

		end
	end,
	function(ply, ent)
		local owner = ent:CPPIGetOwner()
		local cost = 1000
		local money = BraxBank.PlayerMoney(owner)
		local scoreToSet = ply:isCP() and 10 or 17

		if ply:GetNetVar('wanted') or ply:isArrested() or not(ply:isCP() or ply == owner) then return end
		if (ent.idleScore or 0) >= scoreToSet or not IsValid(owner) then return end

		return L.evacuate, 'octoteam/icons/receipt.png', function(ply, ent, args)
			if ply:isCP() then
				ply:Notify(L.evacuate_hint_ply)
				owner:Notify(L.evacuate_hint_owner)
			else
				if not owner:BankHas(cost) then return ply:Notify('warning', 'Недостаточно средств на банковском счете') end
				if money < cost then return ply:Notify('warning', 'Недостаточно средств') end
				owner:Notify(('Ты сделал запрос на эвакуатор для своего автомобиля. С твоего счета в банке было снято %s'):format(DarkRP.formatMoney(cost)))
				owner:BankAdd(-cost)
			end
			ent.idleScore = scoreToSet
			ply:DoEmote(L.evacuation_emote)
			hook.Run('dbg.evacuation', ent, ply, owner)
		end
	end,
	function(ply, ent)
		if ent:GetIsLocked() then return end
		return 'Радио', 'octoteam/icons/boombox.png', function(ply, ent, args)
			local r = ent.Radio
			if IsValid(r) then
				netstream.Start(ply, 'dbg-radio.control', r, r.whitelisted, r.curID, r.curTitle, r.curPlace, r.curCountry)
			end
		end
	end,
	function(ply, ent)
		if not ent.trunkOpen then return end
		local pack = ent.package
		if not IsValid(pack) then return end
		local owner = ent:CPPIGetOwner()
		if not (ply == owner or not IsValid(owner) or ent.lockpicked or (owner.Buddies and owner.Buddies[ply] and table.HasValue(owner.Buddies[ply], true)) or pack.ply == ply) then
			return
		end
		return 'Достать груз', octolib.icons.color('box4'), function(ply, ent)
			pack:DetachFromCar()
		end
	end,
}

