CFG.use.player = {
	function(ply, ent)
		if ply:IsGhost() then return end
		if ply:getJobTable().notHuman then return end
		if CurTime() < (ply.nextPush or 0) then return end
		return L.push, 'octoteam/icons/explosion.png', function(ply, ent)
			timer.Simple(0.5, function()
				if not IsValid(ply) or ply:GetEyeTrace().Entity ~= ent then return end
				local dir = ply:GetAimVector()
				dir:Normalize()
				dir.z = 0.3
				ent:SetVelocity(dir * 500)

				ent:ViewPunch(Angle(math.random(-5, 5), math.random(-5, 5), 0))
				ent:EmitSound('physics/body/body_medium_impact_soft'..math.random(1,7)..'.wav', 45)
			end)

			ply:DoAnimation(ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND)
			ply.nextPush = CurTime() + 2
		end
	end,
	function(ply, ent)
		if ply:IsGhost() then return end
		if ply:getJobTable().notHuman then return end
		if not ply.inv:GetContainer('_hand') then return end
		return L.show_hand, 'octoteam/icons/hand.png', function(ply, ent)
			ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
			ent:OpenInventory(ply.inv, {'_hand'})
		end
	end,
	function(ply, ent)
		if ply:Team() ~= TEAM_K9 then return end
		if ent:Team() == TEAM_K9 then return end
		if not ent.inv then return end
		return 'Обнюхать', 'octoteam/icons/search.png', function(ply, ent)
			ply:DelayedAction('smell', 'Обнюхивание', {
				time = 1,
				check = function() return octolib.use.check(ply, ent) end,
				succ = function()
					if not (IsValid(ply) and IsValid(ent) and ent.inv) then return end
				local found = false
				if ent:FindItem({ class = 'weapon' }) or ent:FindItem({ class = 'ammo' }) or ent:FindItem({ class = {_starts = 'drug_'} }) then
					ply:Notify('warning', 'Ты что-то унюхал!')
				else ply:Notify('hint', 'Кажется, этот человек чист') end
				end,
			})
		end
	end,
	function(ply, ent)
		if ply:IsGhost() then return end
		local job = ply:getJobTable()
		if job.notHuman then return end
		if not ent.bleeding and (not ply:isCP() and not job.canSearch and ent:GetNetVar('ScareState', 0) < 0.6) then return end
		if ent:IsAFK() and ply:Team() ~= TEAM_ADMIN then return end
		if ent:getJobTable().notHuman then return end
		return L.inventory_search, 'octoteam/icons/search.png', function(ply, ent)
			local time = 15
			ply:DelayedAction('searchPly', L.action_search, {
				time = ply:Team() == TEAM_ADMIN and 0.5 or ply:isCP() and time / 3 or time,
				check = function() return octolib.use.check(ply, ent) end,
				succ = function()
					if IsValid(ply) and IsValid(ent) then
						ply:OpenInventory(ent:GetInventory())
						if not ply.sg_invisible then
							ent:EmitSound('npc/combine_soldier/gear6.wav')
						end
						hook.Run('octoinv.search', ply, ent)
					end
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
		if ply:IsGhost() then return end
		if ply:getJobTable().notHuman then return end
		if not ent.bleeding then return end
		return 'Помочь встать', 'octoteam/icons/arrow_up2.png', function(ply, ent)
			local time, period = (11 - ent:Health()) * 2, 2
			if ply:Team() ~= TEAM_MEDCOP and ply:Team() ~= TEAM_MEDIC then
				time = time * 2
				period = 4
			end
			if time <= 0 then return end
			ply:DelayedAction('helpNearlyDead', 'Помощь', {
				time = time,
				check = function() return octolib.use.check(ply, ent) and ent.bleeding end,
				succ = function()
					ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
					ent:SetHealth(11)
				end,
			}, {
				time = period,
				action = function()
					ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
					if IsValid(ent) and ent.bleeding then
						ent:SetHealth(ent:Health() + 1)
					end
				end,
			})
		end
	end,
	function(ply, ent)
		if ply:getJobTable().notHuman then return end
		local cuffed, wep = ent:IsHandcuffed()
		if not cuffed or not wep.CanGag then return end
		local gagged = wep:GetNetVar('gag', false)
		return gagged and L.take_out_the_gag or L.insert_gag, 'octoteam/icons/silence.png', function(ply, ent)
			if IsValid(wep) then
				wep:Gag(not gagged)
			end
		end
	end,
	function(ply, ent)
		if ply:getJobTable().notHuman then return end
		local cuffed, wep = ent:IsHandcuffed()
		if not cuffed or not wep.CanBlind then return end
		local blind = wep:GetNetVar('blind', false)
		return blind and L.untie_eyes or L.tie_eyes, 'octoteam/icons/blind.png', function(ply, ent)
			if IsValid(wep) then
				wep:Blind(not blind)
			end
		end
	end,
	function(ply, ent)
		if ply:getJobTable().notHuman then return end
		if ply:IsGhost() or not ply:isCP() or ent:GetNetVar('Arrested') or (ent:isCP() and ply:Team() ~= TEAM_FBI) then return end
		return L.arrest_stick, 'octoteam/icons/handcuffs.png', function(ply, ent)
			local canArrest, why = hook.Run('canArrest', ply, ent)
			if canArrest == false then
				if why then ply:Notify('warning', why) end
				return
			end

			ent:Freeze(true)
			octolib.request.send(ply, {{
				required = true,
				type = 'strShort',
				name = 'Причина ареста',
				ph = 'Укажи причину здесь',
			}, {
				required = true,
				type = 'comboBox',
				name = L.reason_arrest_level[1],
				opts = {
					{ L.reason_arrest_level[2], 1, true },
					{ L.reason_arrest_level[3], 2 / 3 },
					{ L.reason_arrest_level[4], 1 / 3 },
				},
			}}, function(data)
				if not IsValid(ent) then
					ply:Notify('warning', L.player_left2)
					return
				end

				local reason, time = data[1], math.Clamp(data[2] or 1, 0, 3)
				if not reason or string.Trim(reason) == '' then
					ply:Notify('warning', L.wrong_reason_arrest)
				else
					ent:arrest(time, ply, reason)
					ent:Notify('warning', L.youre_arrested_by:format(ply:Nick()))
				end

				ent:Freeze(false)
			end, function()
				ent:Freeze(false)
			end)
		end
	end,
	function(ply, ent)
		if ply:getJobTable().notHuman then return end
		if ply:IsGhost() or ply:GetNetVar('Arrested') or not ent:GetNetVar('Arrested') then return end
		local job = ply:getJobTable()
		if not job.canUnarrest then return end
		return L.unarrest_action, 'octoteam/icons/handcuffs.png', function(ply, ent)
			local canUnarrest, why = hook.Run('canUnarrest', ply, ent)
			if canUnarrest == false then
				if why then ply:Notify('warning', why) end
				return
			end

			ent:unArrest(ply)
			ent:Notify(L.youre_unarrested_by:format(ply:Nick()))
		end
	end,
	function(ply, ent)
		if ent:IsGhost() or ply:Team() ~= TEAM_PRISON then return end
		for i = 0, #ent:GetMaterials() - 1 do
			if ent:GetSubMaterial(i) == 'models/humans/modern/octo/prisoner1_sheet' then
				return 'Снять тюремную робу', 'octoteam/icons/prisoner_clothes.png', function(ply, ent)
					ent:SetPrisonClothes(false)
				end
			end
		end
		return 'Выдать тюремную робу', 'octoteam/icons/prisoner_clothes.png', function(ply, ent)
			ent:SetPrisonClothes(true)
		end
	end,
	function(ply, ent)
		local job = ply:getJobTable()
		if not ent:IsHandcuffed() or ply:IsGhost() or ply:IsHandcuffed() then return end
		if job.notHuman then return end
		local label, icon
		if not ent.policeCuffs or ply:isCP() or job.canSearch then
			label, icon = L.uncuff, 'octoteam/icons/rope.png'
		else
			label, icon = 'Взломать', 'octoteam/icons/lockpick.png'
		end

		local wep = ply:GetActiveWeapon()
		if IsValid(wep) and wep:GetClass() ~= 'dbg_hands' then return end

		return label, icon, function(ply, ent)
			local cuffed, cuffs = ent:IsHandcuffed()
			if not (cuffed and IsValid(cuffs)) then return end

			if ent.policeCuffs and not ply:isCP() and not job.canSearch and ply:Team() ~= TEAM_ADMIN then
				ply:Lockpick(ent, {
					numOverride = 4,
					timeOverride = ply:HasBuff('Dextradose') and 0.825 or nil,
					succ = function(ply, ent)
						local cuffed, cuffs = ent:IsHandcuffed()
						if not (cuffed and IsValid(cuffs)) then return end
						cuffs:Breakout()
						ent:EmitSound('doors/door_latch1.wav')
					end,
					check = function(ply, ent)
						return ply.inv.conts._hand:HasItem('lockpick') > 0
					end,
				})
			else
				ply:DelayedAction('fbreak', L.handcuff_breaking, {
					time = cuffs.RemoveTime or 3,
					check = function() return octolib.use.check(ply, ent) and not ply:IsHandcuffed() and IsValid(cuffs) end,
					succ = function()
						cuffs:Breakout()
					end,
				}, {
					time = 1.5,
					inst = true,
					action = function()
						ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
					end,
				})
			end
		end
	end,
	function(ply, ent)

		if ply:getJobTable().notHuman then return end
		local cert = ply:GetDBVar('cert')
		if not cert then return end

		return 'Показать удостоверение', 'octoteam/icons/id.png', function(ply, ent)
			if ply:GetPos():DistToSqr(ent:GetPos()) > CFG.useDistSqr then return end
			local showed, whyNot = dbgCerts.show(ply, ent)
			if not showed then ply:Notify('warning', whyNot) end
		end

	end,
}

CFG.use.prop_ragdoll = {
	function(ply, ent)
		if ply:getJobTable().notHuman then return end
		if ply:IsGhost() or ply:IsHandcuffed() or not ent.inv then return end
		return L.inventory_search, 'octoteam/icons/search.png', function(ply, ent)
			if ent:GetRagdollOwner() == ply and ply:Team() ~= TEAM_ADMIN then
				ply:Notify('warning', L.loot_yourself)
				return
			end

			ent.criminals = ent.criminals or {}
			local name = ply:Name()
			if ply:isCP() then name = name .. L.loot_police end
			if not table.HasValue(ent.criminals, name) then table.insert(ent.criminals, name) end

			ply:DelayedAction('lootCorpse', L.loot_corpse, {
				time = 5,
				check = function() return octolib.use.check(ply, ent) end,
				succ = function()
					if ent.inv then
						ent.looters = ent.looters or {}
						if CurTime() - ent:GetNetVar('DeathTime', 0) < 120 and not ent.looters[ply:SteamID()] then
							ply:AddKarma(-2, L.karma_search_corpse)
							ent.looters[ply:SteamID()] = true
						end
						hook.Run('octoinv.search-corpse', ply, ent)
						ply:OpenInventory(ent.inv)
					end
				end,
			}, {
				time = 1.5,
				inst = true,
				action = function()
					ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
				end,
			})
		end
	end,
	function(ply, ent)
		local job = ply:getJobTable()
		if job.notHuman then return end
		if ent.tazeplayer or ply:IsGhost() or ply:IsHandcuffed() or not (job.police or job.canPackCorpse) then return end
		return L.pack_corpse2, 'octoteam/icons/scotch.png', function(ply, ent)
			if ply:isCP() and ply:Team() ~= TEAM_DPD and team.NumPlayers(TEAM_CORONER) >= 1 then
				return ply:Notify('warning', 'На сервере сейчас имеются коронёры, обратись за их помощью по рации')
			end
			ply:DelayedAction('packCorpse', L.pack_corpse, {
				time = 5,
				check = function() return octolib.use.check(ply, ent) end,
				succ = function()
					if not IsValid(ent) then return end
					local pos, ang = ent:GetBonePosition(0)
					pos:Add(ang:Right() * 40)
					ang:RotateAroundAxis(ang:Up(), -90)
					ang:RotateAroundAxis(ang:Right(), 90)
					ent:Remove()
					local prop, variant = ents.Create 'prop_ragdoll', math.random(2, 3)
					prop:SetModel('models/hospitals/bodybag' .. variant .. '.mdl')
					prop:SetPos(pos)
					prop:SetAngles(ang)
					prop:Spawn()
					prop:Activate()

					ent.APG_Ghosted  = false
					ent:DrawShadow(true)
					ent:SetColor(Color(255,255,255,255))
					ent:SetCollisionGroup(COLLISION_GROUP_NONE)

					local ph = prop:GetPhysicsObject()
					if IsValid(ph) then
						ph:SetMass(300)
						ph:Wake()
					end

					ply:Notify(L.corpse_packed)
					timer.Simple(60, function()
						if not IsValid(prop) then return end
						prop:Remove()
					end)
				end,
			}, {
				time = 1.5,
				inst = true,
				action = function()
					ent:EmitSound('physics/rubber/rubber_tire_strain'..math.random(1,3)..'.wav', 65)
					ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
				end,
			})
		end
	end,
	function(ply, ent)
		local job = ply:getJobTable()
		if job.notHuman then return end
		if ent.tazeplayer or ply:IsGhost() or ply:IsHandcuffed() or not (job.police or job.canZip) then return end
		if not ent:GetNetVar('Corpse.name') then return end
		return L.take_body_mat, 'octoteam/icons/urine.png', function(ply, ent)

			if ply:isCP() and ply:Team() ~= TEAM_DPD and team.NumPlayers(TEAM_CORONER) >= 1 then
				return ply:Notify('warning', 'На сервере сейчас имеются коронёры, обратись за их помощью по рации')
			end

			if not ply.inv or not ply.inv.conts._hand then
				ply:Notify('warning', L.hands_free)
				return
			end

			ply:DelayedAction('studyCorpse', L.study_corpse, {
				time = 5,
				check = function() return octolib.use.check(ply, ent) and ply.inv and ply.inv.conts._hand end,
				succ = function()

					if not ent.studied then
						ply.inv.conts._hand:AddItem('body_mat', {
							collector = ply:Nick(),
							corpse = ent:GetNetVar('Corpse.name'),
							criminals = ent.criminals or {},
							expire = os.time() + 60 * 60,
						})
						ent.studied = true
					else ply:Notify('warning', L.body_mat_already_take) end

					if not ent.inv or not (job.police or job.canZip) then return end

					local strs, mass, volume = {}, 0, 0
					for _,cont in pairs(ent.inv.conts) do
						for _,item in pairs(cont:GetItems()) do
							strs[#strs + 1] = octoinv.itemStr({item:GetData('class'), item})
							local amount = item:GetData('amount')
							mass = mass + item:GetData('mass') * amount
							volume = volume + item:GetData('volume') * amount
						end
					end

					if #strs == 0 then
						ply:Notify('warning', 'Улик не обнаружено')
						return
					end

					local storedStr = table.concat(strs, ', ')

					if ply.inv.conts._hand:AddItem('zip', {
						collector = ply:Nick() .. '\n\n',
						storedStr = storedStr,
						amount = 1,
						mass = mass * 0.5,
						volume = volume * 0.5,
						expire = os.time() + 60 * 60,
					}) > 0 then
						ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
						ent.inv:Clear()
					else ply:Notify('warning', 'В руках недостаточно места') end
					hook.Run('octoinv.collect-evidences', ply, ent, storedStr)

				end,
			}, {
				time = 1.5,
				inst = true,
				action = function()
					ent:EmitSound('physics/rubber/rubber_tire_strain'..math.random(1,3)..'.wav', 65)
					ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
				end,
			})
		end
	end,
}

local function packZip(ply, ent)
	if ply:getJobTable().notHuman then return end
	if not (ply:isCP() or ply:getJobTable().canZip) then return end
	local data = ent:GetNetVar('Item')
	if not data then return end
	if data[1] == 'zip' and not ent.isEvidence then return end
	return 'Положить в ZIP-пакет', 'octoteam/icons/zip_file.png', function(ply, ent)

		if not ply.inv or not ply.inv.conts._hand then
			ply:Notify('warning', L.hands_free)
			return
		end

		local storedStr = octoinv.itemStr(data)

		local amount = octoinv.getItemData('amount', data[1], data[2])
		local mass = amount * octoinv.getItemData('mass', data[1], data[2])
		local volume = amount * octoinv.getItemData('volume', data[1], data[2])

		if ply.inv.conts._hand:AddItem('zip', {
			collector = ply:Nick() .. '\n\n',
			storedStr = storedStr,
			amount = 1,
			mass = mass * 0.5,
			volume = volume * 0.5,
			expire = os.time() + 60 * 60,
		}) > 0 then
			ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
			hook.Run('octoinv.collect-evidences', ply, ent, storedStr)
			ent:Remove()
		else
			ply:Notify('warning', 'У тебя недостаточно места')
		end
	end
end

CFG.use.ent_dbg_radio = {
	function(ply, ent)
		if ent.duplicated then return end
		if ply:getJobTable().notHuman then return end
		return L.use, 'octoteam/icons/hand_point.png', function(ply, ent, args)
			netstream.Start(ply, 'dbg-radio.control', ent, ent.whitelisted, ent.curID, ent.curTitle, ent.curPlace, ent.curCountry)
		end
	end,
	function(ply, ent)
		if ent.duplicated then return end
		if ply:getJobTable().notHuman then return end
		if ent.owner ~= ply and not ply:IsAdmin() then return end
		local to = not ent.pinned
		return to and L.freeze or L.unfreeze, 'octoteam/icons/screw.png', function(ply, ent)
			if	to then
				DarkRP.freeze(ply, ent, function(ok, msg)
					if not ok then
						return ply:Notify('warning', msg)
					end
					ent.pinned = to
				end)
			else
				DarkRP.unfreeze(ply, ent)
				ent.pinned = to
			end
		end
	end,
	packZip,
}

CFG.use.ent_dbg_phone = {
	function(ply, ent)
		if ent.off then return end
		if ply:getJobTable().notHuman then return end
		return L.use, 'octoteam/icons/hand_point.png', function(ply, ent)
			ent:Use(ply, ply, USE_TOGGLE, 1)
		end
	end,
	function(ply, ent)
		if not ent.owned then return end
		if ply:getJobTable().notHuman then return end
		local to = not ent.off
		return ent.off and L.enable or L.disable, 'octoteam/icons/button_power.png', function(ply, ent)
			if not to then
				DarkRP.freeze(ply, ent, function(ok, msg)
					if not ok then
						return ply:Notify('warning', msg)
					end
					ent.off = to
					ent:EmitSound('buttons/button24.wav')
				end)
			else
				if ent.off ~= to then
					ent:EmitSound('buttons/button24.wav')
				end
				DarkRP.unfreeze(ply, ent)
				ent.off = to
			end
		end
	end,
}

local colors = {
	[0] = Color(255, 100, 100),
	[1] = Color(100, 100, 255),
	[2] = Color(255, 255, 100),
}

CFG.use.ent_dbg_xmas_ornament = {
	function(ply, ent)
		if ent.star or ply:SteamID64() ~= ent.ownerSID64 then return end
		return 'Перекрасить', 'octoteam/icons/xmas_ball.png', function(ply, ent)
			octolib.request.send(ply, {{
				name = 'Новый цвет шарика',
			},{
				type = 'comboBox',
				opts = {
					{'Красный', 0, ent:GetSkin() == 0},
					{'Синий', 1, ent:GetSkin() == 1},
					{'Желтый', 2, ent:GetSkin() == 2},
				},
			}}, function(data)
				ent:SetSkin(data[2])
				ent:EmitSound('garrysmod/save_load'..math.random(4)..'.wav', 50)
				netstream.StartPVS(ent:GetPos(), 'ornament.sparkles', ent:GetPos() + Vector(0,0,5), colors[data[2]])
			end)
		end
	end,
}

CFG.use.octoinv_item = {
	function(ply, ent)
		if ply:getJobTable().notHuman then return end
		return L.pickup, 'octoteam/icons/arrow_up2.png', function(ply, ent)
			ent:Use(ply, ply, USE_TOGGLE, 1)
		end
	end,
	packZip,
}

CFG.use.dbg_police_analyser = {
	function(ply, ent)
		if ply:getJobTable().notHuman then return end
		return L.check_hint, 'octoteam/icons/search.png', function(ply, ent)
			ent:Use(ply, ply, USE_TOGGLE, 1)
		end
	end,
	function(ply, ent)
		if ent.utilizerBusy then return end
		if ply:getJobTable().notHuman then return end
		return 'Запустить утилизатор', 'octoteam/icons/explosion.png', function(ply, ent)
			ent:NextItem()
		end
	end,
}

CFG.use.dbg_jobs_package = {
	function(ply, ent)

		if ent.ply ~= ply then return end
		if IsValid(ent.car) then return end

		if IsValid(ent.weld) then
			return L.item_unfreezed_car, 'octoteam/icons/screw.png', function(ply, ent)
				ent:Use(ply, ply, USE_TOGGLE, 1)
			end
		end

		local bottom = ent:NearestPoint(ent:GetPos() - Vector(0, 0, 300))
		local car = util.QuickTrace(bottom, -Vector(0,0,4), ent).Entity

		if not IsValid(car) or not car.IsSimfphyscar then
			return
		end
		if not list.Get('simfphys_vehicles')[car.VehicleName].Members.CanAttachPackages then
			return
		end

		return L.freeze_on_car, 'octoteam/icons/screw.png', function(ply, ent)
			ent:Use(ply, ply, USE_TOGGLE, 1)
		end
	end,
	function(ply, ent)

		if ent.ply ~= ply then return end
		if IsValid(ent.car) then return end
		if IsValid(ent.weld) then return end
		
		local bottom = ent:NearestPoint(ent:GetPos() - Vector(0, 0, 300))
		local car = util.QuickTrace(bottom, -Vector(0,0,4), ent).Entity
		
		if not IsValid(car) or not car.IsSimfphyscar then
			return
		end
		if not car.trunkOpen then return end
		if IsValid(car.package) then return end
		if not car.inv then return false end
		local cont = car.inv:GetContainer('trunk')
		if not cont then return end

		local volume = ent:GetVolumeLiters()
		return 'Положить в багажник', octolib.icons.color('car_trunk'), function(ply, ent)
			if cont:FreeSpace() < volume then
				return ply:Notify('warning', 'В багажнике не хватает ' .. (volume-cont:FreeSpace()) .. 'л места!')
			end
			if not IsValid(car.package) then
				ent:AttachToCar(car, cont)
				ply:Notify('Груз помещен в багажник')
			end
		end

	end,
}