------------------------------------------------
--
-- CAR STUFF
--
------------------------------------------------

octoinv.registerItem('tool_susp', {
	name = L.tool_susp,
	icon = 'octoteam/icons/tool_suspension.png',
	mass = 2,
	volume = 1.5,
	desc = L.desc_tool_susp,
	nodespawn = true,
})

octoinv.registerItem('car_kit', {
	name = L.car_kit,
	icon = 'octoteam/icons/tool_repair.png',
	mass = 5,
	volume = 6,
	desc = L.desc_car_kit,
	nodespawn = true,
	use = {
		function(ply, item)
			if ply:Team() ~= TEAM_MECH then return false, L.this_only_mech end
			return L.repair_car, 'octoteam/icons/repair.png', function(ply, item)
				local ent = octolib.use.getTrace(ply).Entity
				if not IsValid(ent) or ent:GetClass() ~= 'gmod_sent_vehicle_fphysics_base' or ent:GetCurHealth() >= ent:GetMaxHealth() then
					ply:Notify('warning', L.repair_car_hint)
					return 0
				end

				ply:DelayedAction('repair', L.repair_action, {
					time = 20,
					check = function() return octolib.use.check(ply, ent) and ply:HasItem('car_kit') > 0 end,
					succ = function()
						ply:TakeItem('car_kit', 1)
						local MaxHealth = ent:GetMaxHealth()
						local NewHealth = math.min(ent:GetCurHealth() + 450, MaxHealth)

						if NewHealth > (MaxHealth * 0.6) then
							ent:SetOnFire( false )
							ent:SetOnSmoke( false )
						end

						if NewHealth > MaxHealth * 0.3 then
							ent:SetOnFire( false )
							if NewHealth <= MaxHealth * 0.6 then
								ent:SetOnSmoke( true )
							end
						end

						ent:SetCurHealth(NewHealth)
						net.Start('simfphys_lightsfixall')
							net.WriteEntity(ent)
						net.Broadcast()

						local effect = ents.Create('env_spark')
						effect:SetKeyValue('targetname', 'target')
						effect:SetPos(ent:GetPos())
						effect:SetAngles(Angle())
						effect:Spawn()
						effect:SetKeyValue('spawnflags','128')
						effect:SetKeyValue('Magnitude',2)
						effect:SetKeyValue('TrailLength',0.5)
						effect:Fire( 'SparkOnce' )
						effect:Fire('kill','',0.5)

						timer.Simple(1, function() carDealer.saveVeh(ent) end)
					end,
				}, {
					time = 1.5,
					inst = true,
					action = function()
						ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
						ply:EmitSound("weapons/357/357_reload".. math.random(1, 4) ..".wav")
					end,
				})

				return 0
			end
		end
	},
})

octoinv.registerItem('car_wheel', {
	name = L.car_wheel,
	icon = 'octoteam/icons/wheel_flat.png',
	model = 'models/props_vehicles/carparts_tire01a.mdl',
	mass = 3,
	volume = 3,
	nostack = true,
	nodespawn = true,
	desc = L.desc_car_wheel,
	use = {
		function(ply, item)
			if ply:Team() ~= TEAM_MECH then return false, L.this_only_mech end
			return L.repair_wheel, 'octoteam/icons/wheel_flat.png', function(ply, item)
				local ent = octolib.use.getTrace(ply).Entity
				if not IsValid(ent) or ent:GetClass() ~= 'gmod_sent_vehicle_fphysics_wheel' or not ent:GetDamaged() then
					ply:Notify('warning', L.repair_wheel_hint)
					return 0
				end
				if ent.deposit then return ply:Notify('warning', 'Арендованные автомобили нельзя изменять') end

				ply:DelayedAction('repair', L.repair_action, {
					time = 15,
					check = function() return octolib.use.check(ply, ent) and ply:HasItem('car_wheel') > 0 end,
					succ = function()
						ply:TakeItem('car_wheel', 1)
						local effect = ents.Create('env_spark')
						effect:SetKeyValue('targetname', 'target')
						effect:SetPos(ent:GetPos())
						effect:SetAngles(Angle())
						effect:Spawn()
						effect:SetKeyValue('spawnflags','128')
						effect:SetKeyValue('Magnitude',1)
						effect:SetKeyValue('TrailLength',0.2)
						effect:Fire( 'SparkOnce' )
						effect:Fire('kill','',0.08)

						local w = ent.GhostEnt
						if IsValid(w) then
							local gib = ents.Create 'gmod_sent_vehicle_fphysics_gib'
							gib:SetModel(w:GetModel())
							gib:SetPos(w:GetPos() - ply:GetAimVector():GetNormalized())
							gib:SetAngles(w:GetAngles())
							gib:Spawn()
							gib:Activate()
							gib:GetPhysicsObject():SetMass(20)
							gib.DoNotDuplicate = true
							gib.NoFire = true
						else
							local gib = ents.Create 'gmod_sent_vehicle_fphysics_gib'
							gib:SetModel('models/props_vehicles/tire001c_car.mdl')
							gib:SetPos(ent:GetPos() - ply:GetAimVector():GetNormalized())
							gib:SetAngles(ent:GetAngles())
							gib:Spawn()
							gib:Activate()
							gib:GetPhysicsObject():SetMass(20)
							gib.DoNotDuplicate = true
							gib.NoFire = true
						end
						ent:SetDamaged(false)
					end,
				}, {
					time = 1.5,
					inst = true,
					action = function()
						ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
						ply:EmitSound("weapons/357/357_reload".. math.random(1, 4) ..".wav")
					end,
				})

				return 0
			end
		end
	},
})

octoinv.registerItem('car_fuel', {
	name = 'Канистра',
	icon = 'octoteam/icons/gas_can.png',
	mass = 5,
	volume = 6,
	desc = 'Используется для заправки автомобиля',
	nodespawn = true,
	use = {
		function(ply, item)
			return 'Заправить машину', 'octoteam/icons/gas_can.png', function(ply, item)
				local ent = octolib.use.getTrace(ply).Entity
				if not IsValid(ent) or ent:GetClass() ~= 'gmod_sent_vehicle_fphysics_base' or ent:GetFuel() >= ent:GetMaxFuel() then
					ply:Notify('warning', 'Нужно смотреть на незаправленную машину')
					return 0
				end

				ply:DelayedAction('repair', 'Заправка', {
					time = 20,
					check = function() return octolib.use.check(ply, ent) and ply:HasItem('car_fuel') > 0 end,
					succ = function()
						ply:TakeItem('car_fuel', 1)
						local newFuel = ent:GetFuel() + 10
						ent:SetFuel(newFuel)
						ent:SetNetVar('Fuel', newFuel)
					end,
				}, {
					time = 1.5,
					inst = true,
					action = function()
						ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
						ply:EmitSound("vehicles/jetski/jetski_no_gas_start.wav")
					end,
				})

				return 0
			end
		end
	},
})

octoinv.registerItem('car_paint', {
	name = L.car_paint,
	icon = 'octoteam/icons/bucket.png',
	mass = 3,
	volume = 2,
	nostack = true,
	nodespawn = true,
	desc = L.desc_car_paint,
	use = {
		function(ply, item)
			if ply:Team() ~= TEAM_MECH then return false, L.this_only_mech end
			local ent = octolib.use.getTrace(ply).Entity
			if not IsValid(ent) or ent:GetClass() ~= 'gmod_sent_vehicle_fphysics_base' then return false, L.see_car end
			if ent.police then return false, L.car_not_paint end
			if ent.deposit then return ply:Notify('warning', 'Арендованные автомобили нельзя изменять') end

			local can, why = simfphys.CanPlayerTune(ply, ent)
			if not can then return false, why end

			return L.painting_car, 'octoteam/icons/blood.png', function(ply, item)
				local ent = octolib.use.getTrace(ply).Entity
				if not IsValid(ent) or ent:GetClass() ~= 'gmod_sent_vehicle_fphysics_base' or ent.police or ent.deposit then return 0 end

				octolib.request.send(ply, {
					{
						name = L.car_color,
						desc = L.desc_car_color,
						type = 'color',
					},
				}, function(data)
					local col = data[1] or Color(255,255,255)
					col.a = 255

					local playSound = true
					ply:DelayedAction('paint', L.paint, {
						time = 20,
						check = function() return octolib.use.check(ply, ent) and tobool(ply:HasItem(item)) end,
						succ = function()
							ply:TakeItem(item)
							ply:StopSound('d1_town.GasJet')
							ent:SetProxyColors({ col, col, CFG.reflectionTint, col })
							ent:RemoveAllDecals()
							if ent.atts then
								for k, attEnt in pairs(ent.atts) do if not attEnt.noPaint then attEnt:SetColor(col) end end
							end
							timer.Simple(1, function() carDealer.saveVeh(ent) end)
						end,
						fail = function()
							ply:StopSound('d1_town.GasJet')
						end,
					}, {
						time = 1.5,
						inst = true,
						action = function()
							if playSound then
								ply:EmitSound('d1_town.GasJet')
								playSound = false
							end
							ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
						end,
					})
				end)

				return 0
			end
		end
	},
})

octoinv.registerItem('car_part', {
	name = L.car_part,
	icon = 'octoteam/icons/cogs.png',
	mass = 1,
	volume = 1,
	nostack = true,
	nodespawn = true,
	desc = L.desc_car_part,
	use = {
		function(ply, item)
			if ply:Team() ~= TEAM_MECH then return false, L.this_only_mech end
			if not item:GetData('car') or not item:GetData('bgnum') or not item:GetData('bgval') then return false, L.item_break end
			local ent
			for i, v in ipairs(ents.FindInSphere(ply:GetShootPos(), 120)) do
				if v:GetClass() == 'gmod_sent_vehicle_fphysics_base' then ent = v break end
			end
			if not IsValid(ent) then return false, L.see_car end
			if ent.deposit then return ply:Notify('warning', 'Арендованные автомобили нельзя изменять') end
			if ent.VehicleName ~= item:GetData('car') then return false, L.item_does_not_fit end
			local bgn, bgv = item:GetData('bgnum'), item:GetData('bgval')
			if ent:GetBodygroup(bgn) == bgv then return false, L.detail_already_set end
			local can, why = simfphys.CanPlayerTune(ply, ent)
			if not can then return false, why end

			return L.set_detail, 'octoteam/icons/wrench.png', function(ply, item)
				local ent = octolib.use.getTrace(ply).Entity
				if not IsValid(ent) or ent:GetClass() ~= 'gmod_sent_vehicle_fphysics_base' then return 0 end
				if ent.VehicleName ~= item:GetData('car') then return 0 end
				local bgn, bgv = item:GetData('bgnum'), item:GetData('bgval')
				if ent:GetBodygroup(bgn) == bgv then return 0 end

				ply:DelayedAction('car_mount', L.set_hint, {
					time = 20,
					check = function() return octolib.use.check(ply, ent) and tobool(ply:HasItem(item)) end,
					succ = function()
						ply:TakeItem(item)
						ent:SetBodygroup(bgn, bgv)
						ent:UpdateInventory()
						timer.Simple(1, function() carDealer.saveVeh(ent) end)
					end,
				}, {
					time = 1.5,
					inst = true,
					action = function()
						ply:EmitSound("ambient/machines/pneumatic_drill_".. math.random(1, 4) ..".wav")
						ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
					end,
				})

				return 0
			end
		end
	},
})

octoinv.registerItem('car_rims', {
	name = L.car_rims,
	icon = 'octoteam/icons/wheel.png',
	mass = 1,
	volume = 1,
	nostack = true,
	nodespawn = true,
	desc = L.desc_car_rims,
	use = {
		function(ply, item)
			if ply:Team() ~= TEAM_MECH then return false, L.this_only_mech end
			local ent
			for i, v in ipairs(ents.FindInSphere(ply:GetShootPos(), 120)) do
				if v:GetClass() == 'gmod_sent_vehicle_fphysics_base' then ent = v break end
			end
			if not IsValid(ent) then return false, L.see_car end
			if ent.deposit then return false, 'Арендованные автомобили нельзя изменять' end
			local mdl = item:GetData('model')
			if ent.wModelF == mdl then return false, L.detail_already_set end
			local can, why = simfphys.CanPlayerTune(ply, ent)
			if not can then return false, why end

			return L.set_discs, 'octoteam/icons/wrench.png', function(ply, item)
				local ent = octolib.use.getTrace(ply).Entity
				if not IsValid(ent) or ent:GetClass() ~= 'gmod_sent_vehicle_fphysics_base' then return 0 end
				if ent.wModelF == mdl then return 0 end

				ply:DelayedAction('car_mount', L.set_hint, {
					time = 20,
					check = function() return octolib.use.check(ply, ent) and tobool(ply:HasItem(item)) end,
					succ = function()
						ply:TakeItem(item)
						simfphys.ApplyWheel(ent, ent.camber or 0, mdl)
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

				return 0
			end
		end
	},
})

octoinv.registerItem('car_att', {
	name = L.car_att,
	icon = 'octoteam/icons/cogs.png',
	mass = 1,
	volume = 1,
	nostack = true,
	nodespawn = true,
	desc = L.desc_car_att,
	use = {
		function(ply, item)
			if item:GetData('att') then
				return 'Конвертировать', 'octoteam/icons/sparkler.png', function(ply, item)
					local cont = item:GetParent()
					item:Remove()

					local attData = simfphys.attachments[item:GetData('att')]
					if not attData then return end

					cont:AddItem('car_att', {
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

					return 0
				end
			end

			local veh = ply:GetVehicle()
			if not IsValid(veh) or not veh.base or veh.base:GetDriverSeat() ~= veh then
				return false, 'Нужно быть на водительском сидении'
			end

			return L.set_detail, 'octoteam/icons/wrench.png', function(ply, item)
				local car = veh.base
				local carRadius = car:GetModelRadius()

				local posDelta = (car:GetForward() + car:GetUp() * 0.8):GetNormalized()
				local vPos = car:GetPos() + posDelta * carRadius
				local vAng = (-posDelta):Angle()

				octolib.flyEdit(ply, {
					parent = car,
					props = {{
						model = item:GetData('attmdl'),
						skin = item:GetData('skin'),
						scale = item:GetData('scale'),
						colorable = item:GetData('colorable'),
						col = item:GetData('colorable') and car:GetProxyColors()[1]:ToColor() or item:GetData('col') or nil,
						name = item:GetData('name'),
						icon = item:GetData('icon'),
						limits = item:GetData('limits') or { scale = {0.1, 3} },
					}},

					space = octolib.flyEditor.SPACE_PARENT,
					vPos = vPos,
					vAng = vAng,
					maxDist = carRadius * 1.2,
					anchorEnt = car,
					noCopy = true,
					noRemove = true,
				}, function(changed, options)
					if not ply:HasItem(item) or not IsValid(car) then return end

					local atts = car:GetNetVar('atts', {})
					for ent, data in pairs(changed) do
						if not options.props[ent] or options.props[ent].model ~= data.model then continue end

						-- local pos, ang = WorldToLocal(data.pos, data.ang, car:GetPos(), car:GetAngles())
						data.size.x = math.Clamp(data.size.x, 0.1, 3)
						data.size.y = math.Clamp(data.size.y, 0.1, 3)
						data.size.z = math.Clamp(data.size.z, 0.1, 3)

						local att = {
							model = data.model,
							pos = data.pos,
							ang = data.ang,
							col = data.col,
							skin = data.skin,
							mat = data.mat,
							bgs = data.bgs,
							size = data.size,
							name = item:GetData('name'),
							icon = item:GetData('icon'),
							mass = item:GetData('mass'),
							volume = item:GetData('volume'),
							colorable = item:GetData('colorable'),
						}

						octolib.table.strip(att, octolib.entDefaults)
						att.col = data.col
						att.pos = att.pos or Vector()
						att.ang = att.ang or Angle()
						atts[#atts + 1] = att

						ply:TakeItem(item)
						ply:EmitSound('ambient/machines/pneumatic_drill_' .. math.random(1, 4) .. '.wav')

						break
					end

					car:SetNetVar('atts', atts)
					timer.Simple(1, function() carDealer.saveVeh(car) end)
				end)

				return 0
			end
		end
	},
})
