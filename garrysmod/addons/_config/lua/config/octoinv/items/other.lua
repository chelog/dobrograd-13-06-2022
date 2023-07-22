------------------------------------------------
--
-- TOOLS
--
------------------------------------------------

local descTemp = L.descTemp

octoinv.registerItem('tool_pen', {
	name = L.tool_pen,
	icon = 'octoteam/icons/pen.png',
	mass = 0.1,
	volume = 0.1,
	randomWeight = 0.25,
	desc = descTemp,
})

octoinv.registerItem('tool_pencil', {
	name = L.tool_pencil,
	icon = 'octoteam/icons/pencil.png',
	mass = 0.05,
	volume = 0.05,
	randomWeight = 0.25,
	desc = descTemp,
})

octoinv.registerItem('souvenir', {
	name = L.tool_souvenir,
	icon = 'octoteam/icons/coin.png',
	mass = 0.1,
	volume = 0.05,
	nostack = true,
	model = 'models/props_phx/misc/egg.mdl',
})


------------------------------------------------
--
-- FOOD / DRUGS / SIMILAR
--
------------------------------------------------

local function drink(_, _, part, partText)
	return L.drink .. partText, 'octoteam/icons/bottle.png', function(ply, item)
		if ply:HasBuff('Overdose') then
			ply:Notify('warning', L.overdose_hint)
			return 0
		end

		local drunkTime = item:GetData('drunkTime') * item:GetData('part') * part
		if drunkTime >= 180 then
			ply:SetLocalVar('frost', math.max(ply:GetNetVar('frost', 0) - 50, 0))
		end

		ply:AddBuff('Drunk', drunkTime)
		ply:EmitSound('npc/barnacle/barnacle_gulp2.wav', 75, 100)

		item:SetData('part', item:GetData('part') * (1 - part))
		item:SetData('desc', ('%s\nОсталось примерно %s%%'):format(
			item:GetData('desc'):gsub('\nОсталось примерно.+', ''),
			math.floor(item:GetData('part') * 100)
		))
		if item:GetData('part') <= 0 then item:Remove() end

		return 0
	end
end

octoinv.registerItem('drug_booze', {
	name = L.drugbooze,
	icon = 'octoteam/icons/food_beer.png',
	mass = 1.5,
	volume = 1.5,
	nostack = true,
	model = 'models/props_junk/garbage_glassbottle002a.mdl',
	desc = L.description_drugbooze,
	part = 1,
	drunkTime = 120,
	use = {
		function(ply, item) return drink(ply, item, 1, ' полностью') end,
		function(ply, item)
			if item:GetData('drunkTime') * item:GetData('part') >= 30 then return drink(ply, item, 0.5, ' половину') end
		end,
		function(ply, item)
			if item:GetData('drunkTime') * item:GetData('part') >= 60 then return drink(ply, item, 0.25, ' немного') end
		end,
	},
})

octoinv.registerItem('drug_booze2', {
	name = L.drugbooze2,
	icon = 'octoteam/icons/bottle_vodka.png',
	mass = 1.5,
	volume = 1,
	nostack = true,
	model = 'models/props_junk/glassbottle01a.mdl',
	desc = L.description_drugbooze2,
	part = 1,
	drunkTime = 240,
	use = {
		function(ply, item) return drink(ply, item, 1, ' полностью') end,
		function(ply, item)
			if item:GetData('drunkTime') * item:GetData('part') >= 30 then return drink(ply, item, 0.5, ' половину') end
		end,
		function(ply, item)
			if item:GetData('drunkTime') * item:GetData('part') >= 60 then return drink(ply, item, 0.25, ' немного') end
		end,
	},
})

octoinv.registerItem('ent_dbg_cigarette', {
	name = L.cigarettes,
	icon = 'octoteam/icons/cigarette.png',
	mass = 0.1,
	volume = 0.2,
	nostack = true,
	model = 'models/boxopencigshib.mdl',
	desc = L.desc_cigarette,
	cigsLeft = 20,
	leftField = 'cigsLeft',
	leftMaxField = 'cigsLeft',
	use = {
		function(ply, item)
			if ply:HasWeapon('dbg_cigarette') then return false, L.have_cigarette end
			return L.use_cigarette, 'octoteam/icons/cigarette.png', function(ply, item)
				if ply.bleeding then
					ply:Notify('warning', 'Ты при смерти')
					return 0
				end
				local left = (item:GetData('cigsLeft') or 20) - 1
				ply:Give('dbg_cigarette')

				if not item:GetData('leftMax') then item:SetData('leftMax', item:GetData('cigsLeft')) end
				item:SetData('cigsLeft', left)
				item:GetParent():QueueSync()

				return left == 0 and 1 or 0
			end
		end,
	},
})

octoinv.registerItem('bandage', {
	name = L.bandage,
	icon = 'octoteam/icons/bandage.png',
	mass = 0.1,
	volume = 0.08,
	model = 'models/props/cs_office/file_box_gib2.mdl',
	randomWeight = 0.2,
	desc = L.desc_bandage,
	use = {
		function(ply, item)
			if ply:Health() < 80 then return false, L.you_cant_plaster end
			if ply:Health() >= 100 then return false, L.are_you_okay end
			return L.seal_bruises, 'octoteam/icons/medkit.png', function(ply, item)
				ply:SetHealth(math.min(ply:Health() + 5, 100))
				return 1
			end
		end,
	},
})

octoinv.registerItem('clothes', {
	name = L.clothes,
	icon = 'octoteam/icons/clothes_warm.png',
	mass = 0.5,
	volume = 1.5,
	model = 'models/props_junk/cardboard_box003a.mdl',
	desc = L.desc_clothes,
	use = {
		function(ply, item)
			if ply:isCP() then return false, L.need_unwear_police_form end
			if ply:GetLocalVar('customClothes') then return false, 'Нужно снять текущую одежду' end
			return L.wear2, 'octoteam/icons/clothes_warm.png', function(ply, item)
				EventMakeRefugee(ply, function(ok)
					if ok then
						ply:TakeItem('clothes', 1)
						ply:EmitSound('npc/combine_soldier/gear5.wav', 65)
						ply.warmClothes = true
					elseif tonumber(ply:HasItem('clothes')) <= 0 then
						ply:Notify('warning', 'У тебя нет теплой одежды')
					else
						ply:Notify('warning', 'Теплая одежда не подошла по размеру... Попробуй сменить персонажа')
					end
				end, function()
					return tonumber(ply:HasItem('clothes')) > 0
				end)
			end
		end,
	},
})

local ply = FindMetaTable 'Player'
function ply:SetClothes(clothes)
	local mat = clothes and clothes.mat or nil
	for i, original in ipairs(self:GetMaterials()) do
		if string.match(original, '.+/sheet_%d+') then
			self:SetSubMaterial(i - 1, mat)
		end
	end

	local top = self.inv and self.inv:GetContainer('top')
	if top then
		top.icon = clothes and clothes.icon or octoinv.defaultInventory.top.icon
		top:QueueSync()
	end

	ply.warmClothes = clothes and clothes.warm or nil

	local old = self:GetDBVar('customClothes')
	self:SetLocalVar('customClothes', clothes)
	self:SetDBVar('customClothes', clothes)
	hook.Run('dbg-clothes.update', self, clothes, old)
end

octoinv.registerItem('clothes_custom', {
	name = 'Одежда',
	icon = 'octoteam/icons/clothes_tshirt.png',
	desc = 'Выделяйся из толпы!',
	mass = 0.5,
	volume = 1.5,
	nostack = true,
	model = 'models/props_junk/cardboard_box003a.mdl',
	use = {
		function(ply, item)
			local matsToReplace = octolib.table.count(ply:GetMaterials(), function(v) return string.match(v, '.+/sheet_%d+') end)
			if matsToReplace < 1 then return false, 'Ты не можешь это надеть сейчас' end
			if ply:GetNetVar('customClothes') then return false, 'Нужно снять текущую одежду' end

			local gender = item:GetData('gender')
			if gender then
				local isFemale = ply:GetInfo('dbg_model'):find('female')
				if gender == 'male' and isFemale then return false, 'Это мужская одежда' end
				if gender == 'female' and not isFemale then return false, 'Это женская одежда' end
			end

			return L.wear2, 'octoteam/icons/clothes_coat.png', function(ply, item)
				ply:SetClothes(item:Export())
				ply:EmitSound('npc/combine_soldier/gear5.wav', 65)

				return 1
			end
		end,
	},
})

concommand.Add('dbg_clothesoff', function(ply)
	if not IsValid(ply) then return end

	local clothes = ply:GetNetVar('customClothes')
	if not clothes then return ply:Notify('warning', 'На тебе нет одежды, которую можно снять') end

	local mats = ply:GetMaterials()
	for i = 0, #mats - 1 do
		if ply:GetSubMaterial(i) == clothes.mat then
			local amount = ply:AddItem(clothes.class or 'clothes_custom', clothes)
			if not amount or amount == 0 then
				return ply:Notify('warning', 'В руках недостаточно места')
			end

			ply:SetClothes(nil)
			break
		end
	end
end)

hook.Add('dbg-char.spawn', 'clothes', function(ply)
	ply:SetClothes(ply:GetDBVar('customClothes'))
end)

------------------------------------------------
--
-- CONTAINERS
--
------------------------------------------------

local function spawnCont(ply, data)
	local ent = ents.Create 'octoinv_cont'
	ent.dt = ent.dt or {}
	ent.dt.owning_ent = ply
	ent.Model = data.model
	ent.Skin = istable(data.skin) and math.random(data.skin[1], data.skin[2]) or data.skin or ent.Skin or 0
	ent.Mass = data.mass
	ent.Containers = data.conts
	ent.DestructParts = data.destruct

	ent.SID = ply.SID
	ent:Spawn()

	ply:BringEntity(ent)
	ent:SetPlayer(ply)
	ent:SetLocked(false)
	timer.Simple(3, function()
		if IsValid(ent) and IsValid(ply) then
			APG.entUnGhost(ent, ply)
		end
	end)

	return ent
end

octoinv.registerItem('cont', {
	name = L.container,
	icon = 'octoteam/icons/box1.png',
	mass = 1,
	volume = 1,
	nostack = true,
	use = {
		function(ply, item)
			local t = item:GetData('contdata')
			if not t then return false, L.item_break end
			return L.collect, 'octoteam/icons/box3_go.png', function(ply, item)
				return IsValid(spawnCont(ply, t)) and 1 or 0
			end
		end,
	},
})

local lockCont = {'func_door', 'func_door_rotating', 'prop_door_rotating', 'func_movelinear', 'prop_dynamic', 'octoinv_cont', 'octoinv_prod', 'octoinv_vend', 'octoinv_storage'}
octoinv.registerItem('lock_cont', {
	name = L.item_lock_cont,
	icon = 'octoteam/icons/lock.png',
	model = 'models/props_wasteland/prison_padlock001a.mdl',
	mass = 1,
	volume = 1,
	nostack = true,
	desc = L.desc_lock,
	use = {
		function(ply, item)
			local pass = item:GetData('password')
			if pass then return end
			return 'Настроить', 'octoteam/icons/wrench.png', function(ply, item)
				local oldCont = item:GetParent()
				octolib.request.send(ply, {{
					type = 'strLong',
					name = 'Пароль',
					desc = 'Кодовая фраза. Этот замок можно будет открыть только ключом, пароль которого совпадает с собственным. Можно установить только один раз',
					default = math.random(1000, 9999),
					required = true,
				}}, function(data)
					if not item or item:GetParent() ~= oldCont then return end
					local pass = tostring(data[1] or ''):sub(1, 32)
					item:SetData('password', pass)
				end)
			end
		end,
		function(ply, item)
			local num, pass = item:GetData('num'), item:GetData('password')
			if not num then return false, L.item_break end
			if not pass then return end

			local ent = octolib.use.getTrace(ply).Entity
			if not IsValid(ent) or (not table.HasValue(lockCont, ent:GetClass()) and not ent.lootable) then return false, L.need_see_on_item end
			if ent:IsDoor() and ent:GetPlayerOwner() ~= ply:SteamID() then return false, L.this_is_not_your_door end

			return L.set, 'octoteam/icons/wrench.png', function(ply, item)
				ply:DelayedAction('lock_mount', L.set_hint, {
					time = 5,
					check = function() return octolib.use.check(ply, ent) and tobool(ply:HasItem(item)) end,
					succ = function()
						ply:TakeItem(item)
						ent.lockNum = num
						if pass then
							ent.password = pass
						end
					end,
				}, {
					time = 1.5,
					inst = true,
					action = function()
						ply:EmitSound('ambient/machines/pneumatic_drill_'.. math.random(1, 4) ..'.wav')
						ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
					end,
				})
			end
		end,
	},
})

octoinv.registerItem('key', {
	name = 'Ключ',
	desc = 'Используется для открывания замков. На бирке написано: {tag}',
	icon = 'octoteam/icons/key.png',
	model = 'models/bull/buttons/key_switch.mdl',
	mass = 0.02,
	volume = 0.01,
	nodespawn = true,
	nostack = true,
	tag = '*пусто*',
	use = {
		function(ply, item)
			local pass = item:GetData('password')
			if pass then return end
			return 'Настроить', 'octoteam/icons/wrench.png', function(ply, item)
				local oldCont = item:GetParent()
				octolib.request.send(ply, {{
					type = 'strLong',
					name = 'Пароль',
					desc = 'Кодовая фраза. Этот ключ сможет открывать все замки, пароль которых совпадает с собственным. Можно установить только один раз',
					default = math.random(1000, 9999),
					required = true,
				}}, function(data)
					if not item or item:GetParent() ~= oldCont then return end
					local pass = tostring(data[1] or ''):sub(1, 32)
					item:SetData('password', pass)
				end)
			end
		end,
		function(ply, item)
			return 'Подписать', 'octoteam/icons/pencil.png', function(ply, item)
				local oldCont = item:GetParent()
				octolib.request.send(ply, {{
					type = 'strLong',
					name = 'Текст',
					default = '',
					required = true,
				}}, function(data)
					if not item or item:GetParent() ~= oldCont then return end
					local name = utf8.sub(tostring(data[1] or ''), 1, 128)
					item:SetData('tag', name)
					item:GetParent():Sync()
				end)
			end
		end,
	},
})

local function canLock(ply, ent)

	if ent.password then
		local key = ply:FindItem({ class = 'key', password = ent.password })
		if key then
			return true
		else
			return false
		end
	end

end
hook.Add('canKeysLock', 'octoinv.keys', canLock)
hook.Add('canKeysUnlock', 'octoinv.keys', canLock)
hook.Add('octoinv.canLock', 'octoinv.keys', canLock)
hook.Add('octoinv.canUnlock', 'octoinv.keys', canLock)

hook.Add('dbg-doors.unowned', 'octoinv.keys', function(ent)
	ent.password = nil
end)

------------------------------------------------
--
-- EVENT ITEMS
--
------------------------------------------------

local desc = L.descEvent
octoinv.registerItem('coupon_ammo', {
	name = L.coupon_ammo,
	icon = 'octoteam/icons/coupon_red.png',
	model = 'models/props/cs_assault/money.mdl',
	desc = desc,
	mass = 0.01,
	volume = 0.01,
})

octoinv.registerItem('coupon_food', {
	name = L.coupon_food,
	icon = 'octoteam/icons/coupon_green.png',
	model = 'models/props/cs_assault/money.mdl',
	desc = desc,
	mass = 0.01,
	volume = 0.01,
})

octoinv.registerItem('coupon_exit', {
	name = L.coupon_exit,
	icon = 'octoteam/icons/coupon_blue.png',
	model = 'models/props/cs_assault/money.mdl',
	desc = desc,
	mass = 0.01,
	volume = 0.01,
})

octoinv.registerItem('petard', {
	name = L.petards,
	icon = 'octoteam/icons/dynamite.png',
	mass = 0.5,
	volume = 0.4,
	usesLeft = 5,
	model = 'models/Items/BoxBuckshot.mdl',
	desc = L.desc_petards,
	nostack = true,
	use = {
		function()
			return 'Конвертировать', 'octoteam/icons/sparkler.png', function(ply, item)
				local cont = item:GetParent()
				local mass, volume, usesLeft = item:GetData('mass'), item:GetData('volume'), item:GetData('usesLeft')
				item:Remove()
				if usesLeft <= 0 then return end

				cont:AddItem('throwable', {
					name = 'Петарды',
					desc = 'Это еще что за шутки?!',
					icon = 'octoteam/icons/dynamite.png',
					usesLeft = usesLeft,
					mass = mass,
					volume = volume,
					gc = 'ent_dbg_petard',
				})
			end
		end,
	},
})

octoinv.registerItem('fireworks', {
	name = L.salute,
	icon = 'octoteam/icons/firework.png',
	mass = 1,
	volume = 0.8,
	model = 'models/Items/BoxSRounds.mdl',
	desc = L.desc_salute,
	nostack = true,
	use = {
		function(ply, item)
			return L.to_put, 'octoteam/icons/explosion.png', function(ply, item)
				ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
				timer.Simple(0.88, function()
					local pos, ang, vel = ply:GetBonePosition(ply:LookupBone('ValveBiped.Bip01_L_Hand') or 16)
					local tr = util.TraceLine { start = ply:GetShootPos(), endpos = pos, filter = ply }
					if tr.Hit then
						pos = tr.HitPos + tr.HitNormal * 5
						vel =  tr.HitNormal * 100
					elseif not vel then
						vel = Vector()
					end

					ang = ply:EyeAngles()
					ang.p = 0

					local ent = ents.Create 'ent_dbg_fireworks'
					ent:SetPos(pos)
					ent:SetAngles(ang)
					ent:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)

					ent:Spawn()
					ent:Activate()
					ply:LinkEntity(ent)

					local phys = ent:GetPhysicsObject()
					if IsValid(phys) then
						phys:Wake()
						phys:SetVelocity(vel)
					end
				end)

				return 1
			end
		end,
	},
})

octoinv.registerItem('soccer', {
	name = L.soccer,
	desc = L.soccerballdesc,
	icon = 'octoteam/icons/ball_soccer.png',
	mass = 0.5,
	volume = 0.5,
	nostack = true,
	use = {
		function(ply, item)
			if ply:HasItem('tool_pump') < 1 then return false, L.need_pump end
			return L.pump_up, 'octoteam/icons/box3_go.png', function(ply, item)
				local sid = ply:SteamID()
				local count = 0
				for _, v in ipairs(ents.FindByClass('sent_soccerball')) do
					if octolib.linkedCache[v] == sid then count = count + 1 end
				end
				if count >= 3 then
					return ply:Notify('warning', 'Зачем тебе столько мячей?')
				end

				local ent = ents.Create 'sent_soccerball'
				if not IsValid(ent) then return end

				ent:Spawn()
				ply:LinkEntity(ent)
				ply:BringEntity(ent)

				return 1
			end
		end,
	},
})

octoinv.registerItem('body_mat', {
	name = L.body_mat,
	desc = 'Собрал: {collector}\n\n{signature}Жертва: {corpse}{criminalsStr}',
	icon = 'octoteam/icons/body_material.png',
	mass = 0.2,
	volume = 0.5,
	nostack = true,
	nodespawn = true,
	collector = '???',
	signature = '\n',
	corpse = '???',
	criminalsStr = '???',
	use = {
		function(ply, item)
			if item.corpse and ply:isCP() then
				return 'Подписать', 'octoteam/icons/pencil.png', function()
					octolib.request.send(ply, {{
						type = 'strLong',
						name = 'Подпись',
						desc = 'Переносы строк конвертируются в пробелы',
						default = utf8.sub(item.signature or '\n\n', 1, -3),
					}}, function(data)
						if not istable(data) then return end
						local txt = string.Replace(data[1] or '', '\n', ' ')
						if data[1] ~= nil and string.Trim(utf8.sub(txt, 1, 256)) ~= '' then
							item:SetData('signature', string.Trim(utf8.sub(txt, 1, 256)) .. '\n\n')
						else item:SetData('signature', '') end
					end)
				end
			end
		end,
		function(ply, item)
			local cont = item:GetParent()
			if not cont then return end
			if ply:isCP() and cont.id == 'utilizer' then
				local own = cont:GetParent():GetOwner()
				if own.utilizerBusy then return false, 'Утилизатор уже работает' end
				return 'Запустить утилизацию', 'octoteam/icons/explosion.png', function()
					own:NextItem()
				end
			end
		end,
	},
})

octoinv.registerItem('binoculars', {
	name = L.craft_binoculars,
	icon = 'octoteam/icons/binoculars.png',
	mass = 1.2,
	volume = 1,
	nostack = true,
})

hook.Add('closelook.canZoom', 'binoculars', function(ply)
	if ply.inv and ply.inv.conts._hand and ply.inv.conts._hand:HasItem('binoculars') > 0 then
		return true, true
	end
end)

octoinv.registerItem('phone', {
	name = L.phone,
	icon = 'octoteam/icons/phone_old.png',
	mass = 0.35,
	volume = 0.5,
	model = 'models/lt_c/tech/cellphone.mdl',
	desc = L.desc_phone,
	nostack = true,
	on = false,
	status = 'ВЫКЛ',
	vibration = false,
	notification = false,
	use = {
		function(ply, item)
			if not item.on then return end
			if ply:GetNetVar('ScareState', 0) > 0.6 then
				return false, 'Ты трясешься от страха'
			end
			return L.use, 'octoteam/icons-16/phone.png', function(ply, item)
				netstream.Start(ply, 'dbg-phone.open')
			end
		end,
		function(ply, item)
			return item.on and 'Выключить' or 'Включить', 'octoteam/icons/button_power.png', function(ply, item)
				local on = not item.on
				item:SetData('on', on)
				item:SetData('status', on and 'ВКЛ' or 'ВЫКЛ')
				ply:EmitSound('buttons/button24.wav')
			end
		end,
		function(ply, item)
			if not item.on then return end
			return (item.notification and 'Выключить' or 'Включить') .. ' звук', 'octoteam/icons/phone_notification.png', function(ply, item)
				local on = not item.notification
				item:SetData('notification', on)
				if item.notification then ply:EmitSound('phone/phone_notification.wav', 38) end
			end
		end,
		function(ply, item)
			if not item.on then return end
			return (item.vibration and 'Выключить' or 'Включить') .. ' вибрацию', 'octoteam/icons/phone_vibration.png', function(ply, item)
				local on = not item.vibration
				item:SetData('vibration', on)
				if item.vibration then ply:EmitSound('phone/phone_vibration.wav', 25) end
			end
		end,
	},
})

octoinv.registerItem('phone_st', {
	name = 'Домашний телефон',
	icon = 'octoteam/icons/phone_office.png',
	mass = 1.5,
	volume = 5.5,
	model = 'models/props/cs_office/phone.mdl',
	desc = 'Средство связи, которое можно поставить у себя дома или на работе',
	nostack = true,
	class = 'ent_dbg_phone',
	drop = function(ply, item, amount, posData)
		local pos, ang, vel, put =
			posData.pos or Vector(),
			posData.ang or Angle(),
			posData.vel or Vector(),
			posData.put

		local ent = ents.Create('ent_dbg_phone')
		ent.Model = item:GetData('model', true) or 'models/props/cs_office/phone.mdl'
		ent:Spawn()
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent.owned = true

		if put then
			local a,b = ent:GetCollisionBounds()
			pos:Sub(Vector(0,0,math.min(a.z, b.z)))
			ent:SetPos(pos)
		end

		if not IsValid(ent) then return nil, 0 end

		local ph = ent:GetPhysicsObject()
		if IsValid(ph) then
			ph:Wake()
			ph:SetVelocity(vel)
		end

		ent:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
		if IsValid(ply) and ply:IsPlayer() then
			ply:LinkEntity(ent)
			ent.owner = ply
		end
		ent.off = true

		return ent, 1
	end,
	pickup = function(ply, ent)
		if not ent.owned or not ent.off then return false end
	end,
})

octoinv.registerItem('player', {
	name = L.radio,
	icon = 'octoteam/icons/boombox.png',
	mass = 2.5,
	volume = 2,
	model = 'models/props/cs_office/radio.mdl',
	desc = L.desc_radio,
	nostack = true,
	class = 'ent_dbg_radio',
	drop = function(ply, item, amount, posData)
		local pos, ang, vel, put =
			posData.pos or Vector(),
			posData.ang or Angle(),
			posData.vel or Vector(),
			posData.put

		local ent = ents.Create('ent_dbg_radio')
		ent.Model = item:GetData('model') or ent.Model
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:Spawn()

		if put then
			local a,b = ent:GetCollisionBounds()
			pos:Sub(Vector(0,0,math.min(a.z, b.z)))
			ent:SetPos(pos)
		end

		if not IsValid(ent) then return nil, 0 end

		local ph = ent:GetPhysicsObject()
		if IsValid(ph) then
			ph:Wake()
			ph:SetVelocity(vel)
		end

		ent:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
		ent.radioPlayer = true
		ent.owner = ply
		if IsValid(ply) and ply:IsPlayer() then
			ply:LinkEntity(ent)
		end

		return ent, 1
	end,
	pickup = function(ply, ent)
		if not ent.radioPlayer then return false end
		if ent.pinned then return false end
	end,
})

octoinv.registerItem('zip', {
	name = 'ZIP-пакет',
	desc = 'Собрал: {collector}{signature}Содержимое:\n{storedStr}',
	mass = 0.2,
	volume = 0.2,
	nodespawn = true,
	nostack = true,
	icon = 'octoteam/icons/zip_evidence.png',
	model = 'models/weapons/w_package.mdl',
	use = {
		function(ply, item)
			if item.storedStr then
				return 'Подписать', 'octoteam/icons/pencil.png', function()
					octolib.request.send(ply, {{
						type = 'strLong',
						name = 'Подпись',
						desc = 'Переносы строк конвертируются в пробелы',
						default = utf8.sub(item.signature or '\n\n', 1, -3),
					}}, function(data)
						if not istable(data) then return end
						local txt = string.Replace(data[1] or '', '\n', ' ')
						if data[1] ~= nil and string.Trim(utf8.sub(txt, 1, 256)) ~= '' then
							item:SetData('signature', string.Trim(utf8.sub(txt, 1, 256)) .. '\n\n')
						else item:SetData('signature', '') end
					end)
				end
			end
		end,
	},
})

octoinv.registerItem('h_mask', {
	name = L.mask,
	icon = 'octoteam/icons/comedy.png',
	mass = 0.3,
	volume = 0.5,
	desc = L.desc_mask,
	nodespawn = true,
	nostack = true,
	use = {
		function(ply, item)
			local mask = item:GetData('mask')
			if not mask then return false, L.item_break end
			if ply:GetNetVar('hMask') then return false, 'На тебе уже надет аксессуар' end
			return L.wear, 'octoteam/icons/key.png', function(ply, item)
				ply:Unmask()

				local expire = item:GetData('expire')
				if expire then
					ply.maskExpireUid = 'octoinv.maskExpire' .. octolib.string.uuid()
					timer.Create(ply.maskExpireUid, expire - os.time(), 1, function()
						if not IsValid(ply) then return end
						ply:SetNetVar('hMask')
						ply:SetDBVar('hMask')
						ply:Notify('У твоего аксессуара закончился срок годности')
					end)
				end

				ply:SetNetVar('hMask', {mask, item:GetData('expire')})
				ply:SetDBVar('hMask', {mask, item:GetData('expire')})
				return 1
			end
		end,
	},
})

------------------------------------------------
--
-- DOOR AND DETAILS
--
------------------------------------------------

octoinv.registerItem('door', {
	name = 'Дверь',
	icon = 'octoteam/icons/door.png',
	model = 'models/props_junk/cardboard_box001a.mdl',
	mass = 7.5,
	volume = 7.5,
	nostack = true,
	desc = L.desc_door,
	use = {
		function(ply, item)
			local door_skin = item:GetData('skin')
			local ent = octolib.use.getTrace(ply).Entity
			if not IsValid(ent) or 'prop_door_rotating' ~= ent:GetClass() then return false, 'Нужно смотреть на дверь' end
			if not ent:GetModel():find('models/props_c17/door01') then return false, 'Эту дверь нельзя заменить' end
			if ent:GetPlayerOwner() ~= ply:SteamID() then return false, L.this_is_not_your_door end
			if ent:GetSkin() == door_skin then return false, 'Нет смысла заменять дверь на точно такую же' end

			return L.set, 'octoteam/icons/wrench.png', function(ply, item)
				ply:DelayedAction('replace_door', L.replace, {
					time = 3,
					check = function() return octolib.use.check(ply, ent) and tobool(ply:HasItem(item)) end,
					succ = function()
						ply:TakeItem(item)
						ent:SetSkin(door_skin)
					end,
				}, {
					time = 1.5,
					inst = true,
					action = function()
						ply:EmitSound('ambient/machines/pneumatic_drill_'.. math.random(1, 4) ..'.wav')
						ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
					end,
				})
			end
		end,
	},
})

octoinv.registerItem('door_handle', {
	name = L.item_door_handle,
	icon = 'octoteam/icons/door_handle.png',
	model = 'models/props_junk/cardboard_box004a.mdl',
	mass = .75,
	volume = .75,
	nostack = true,
	desc = L.desc_door_handle,
	use = {
		function(ply, item)
			local door_handle = item:GetData('handle')
			local ent = octolib.use.getTrace(ply).Entity
			if not IsValid(ent) or 'prop_door_rotating' ~= ent:GetClass() then return false, 'Нужно смотреть на дверь' end
			if not ent:GetModel():find('models/props_c17/door01') then return false, 'Ручку на этой двери нельзя заменить' end
			if ent:GetPlayerOwner() ~= ply:SteamID() then return false, L.this_is_not_your_door end
			if ent:GetBodygroup(1) == door_handle then return false, 'На двери уже установлена такая ручка' end

			return L.set, 'octoteam/icons/wrench.png', function(ply, item)
				ply:DelayedAction('replace_door_handle', L.replace, {
					time = 3,
					check = function() return octolib.use.check(ply, ent) and tobool(ply:HasItem(item)) end,
					succ = function()
						ply:TakeItem(item)
						ent:SetBodygroup(1, door_handle)
					end,
				}, {
					time = 2,
					inst = true,
					action = function()
						ply:EmitSound('ambient/machines/pneumatic_drill_'.. math.random(1, 4) ..'.wav')
						ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
					end,
				})
			end
		end,
	},
})

hook.Add('dbg-doors.unowned', 'dbg-doors.custom', function(ent)
	ent:SetSkin(ent.defaultSkin or 0)
	for k,v in pairs(ent.defaultBGs or {}) do
		ent:SetBodygroup(k, v)
	end
end)
