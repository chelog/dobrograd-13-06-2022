------------------------------------------------
--
-- DARKRP STUFF
--
------------------------------------------------

octoinv.registerItem('money', {
	name = L.money,
	model = 'models/props/cs_assault/money.mdl',
	icon = 'octoteam/icons/money_pack.png',
	mass = 0.00001,
	volume = 0.00001,
	randomWeight = 0.001,
	desc = L.desc_money,
})

local function isDriver(ply)
	local seat = ply:GetVehicle()
	if not IsValid(seat) or not IsValid(seat:GetParent()) then return false end
	return seat:GetParent().GetDriverSeat and seat:GetParent():GetDriverSeat() == seat
end

local function equipWeapon(text, doSound)
	return function(ply, item)
		if doSound and ply:KeyDown(IN_WALK) then return end

		local wep = ply:GetActiveWeapon()
		if not IsValid(wep) or wep:GetClass() ~= 'dbg_hands' then return false, L.take_weapon end
		if isDriver(ply) then return false, L.hands_busy_driver end
		if not item:GetData('wepclass') then return false, L.unknown_type_weapon end
		if ply:HasWeapon(item:GetData('wepclass')) then return false, L.you_already_take_weapon end
		return text, item:GetData('icon'), function(ply, item)
			local class = item:GetData('wepclass')
			if octoinv.gunBlacklist[class] then
				ply:Notify('warning', 'Это оружие запрещено использовать на сервере. Стоит рассказать администрации, как ты его заполучил')
				return 1
			end

			local wep = ents.Create(class)

			if not wep:IsValid() then return 0 end
			if not wep:IsWeapon() then wep:Remove() return 0 end
			if not hook.Call("PlayerCanPickupWeapon", GAMEMODE, ply, wep) then return 0 end

			local ammoT = wep:GetPrimaryAmmoType()
			local ammo = ply:GetAmmoCount(ammoT)
			wep:Remove()

			local wep = ply:Give(class)
			wep:SetClip1(item:GetData('clip1') or 0)
			wep:SetClip2(item:GetData('clip2') or -1)
			wep:SetShouldPlayPickupSound(false)
			wep.WorldModel = item:GetData('model') or wep.WorldModel
			wep:Initialize()

			ammo = math.Clamp(ammo + (item:GetData('ammoadd') or 0), 0, wep.Primary.ClipSize * 3)
			ply:SetAmmo(ammo, ammoT)

			wep.itemData = item:Export()
			wep.itemCont = item:GetParent().id
			wep.civil = true

			if item:GetData('expire') then
				wep.expireId = 'octoinv.expireWep' .. octolib.string.uuid()
				timer.Create(wep.expireId, item:GetData('expire') - os.time(), 1, function()
					if not IsValid(ply) then return end
					local active = ply:GetActiveWeapon() == wep
					if IsValid(wep) then
						wep:Remove()
						ply:Notify('У оружия истек срок годности')
					end
					if active then ply:ConCommand('lastinv') end
				end)
			end

			timer.Simple(0, function()
				if not doSound then ply.silentEquip = true end
				ply:SelectWeapon(class)
				ply.silentEquip = nil
			end)

			return 1
		end
	end
end

octoinv.registerItem('weapon', {
	name = L.weapons,
	model = 'models/weapons/w_pist_glock18.mdl',
	icon = 'octoteam/icons/gun_pistol.png',
	mass = 1,
	volume = 1,
	nostack = true,
	desc = L.desc_weapon,
	leftField = 'clip1',
	leftMaxField = 'ammoadd',
	nodespawn = true,
	use = {
		equipWeapon(L.take_in_hand, true),
		equipWeapon(L.silient_take_in_hand, false),
	},
})

octoinv.registerItem('ammo', {
	name = L.item_ammo,
	model = 'models/Items/BoxSRounds.mdl',
	icon = 'octoteam/icons/gun_bullet2.png',
	mass = 0.01,
	volume = 1,
	nostack = true,
	nodespawn = true,
	randomWeight = 0.25,
	desc = L.desc_item_ammo,
	use = {
		function(ply, item)
			local t = item:GetData('ammotype')
			if not t then return false, L.unknown_type_ammo end

			local wep = ply:GetActiveWeapon()
			if not IsValid(wep) or wep.Primary.Ammo ~= t then return false, 'Нужно держать совместимое оружие' end
			if wep:Ammo1() >= wep.Primary.ClipSize * 3 then return false, 'Это оружие максимально заряжено' end

			return L.charge, 'octoteam/icons/gun_bullet.png', function(ply, item)
				if not IsValid(wep) or wep.Primary.Ammo ~= t then return end
				if wep:Ammo1() >= wep.Primary.ClipSize * 3 then return end

				local amount = math.Clamp(item:GetData('ammocount') or 1, 0, wep.Primary.ClipSize * 3 - wep:Ammo1())
				ply:GiveAmmo(amount, t)
				ply:EmitSound('items/itempickup.wav', 60)

				return 1
			end
		end,
	},
})

local function eat(ply, item, part, partText)
	if ply:GetNetVar('Energy') == 100 then return false, L.max_hunger_hint end

	local name = item:GetData('drink') and L.drink or L.eat
	local icon = item:GetData('drink') and 'octoteam/icons/bottle.png' or 'octoteam/icons/food_meal2.png'
	return name .. partText, icon, function(ply, item)
		if ply.eating then
			ply:Notify('warning', 'Поспешишь - людей насмешишь, как говорится. Не торопись')
			return
		end

		local addEnergy = math.floor(item:GetData('energy') * part)
		ply.eating = true
		ply:DelayedAction('eating', 'Употребление: ' .. item:GetData('name'), {
			time = addEnergy / 10,
			check = function() return ply.inv and tobool(ply:HasItem(item)) and not ply:IsSprinting() end,
			succ = function()
				local newVal = math.Clamp((ply:GetNetVar('Energy') or 100) + addEnergy, 0, item:GetData('maxenergy'))
				ply.eating = nil
				if newVal > ply:GetNetVar('Energy') then
					ply:SetLocalVar('Energy', newVal)
				end
				ply:EmitSound('physics/wood/wood_strain' .. math.random(1,2) .. '.wav', 65)

				local mul = 1 - part
				if not item:GetData('leftMax') then item:SetData('leftMax', item:GetData('energy')) end
				item:SetData('energy', math.floor(item:GetData('energy') * mul))
				item:SetData('mass', math.max(item:GetData('mass') * mul, 0.05))
				item:SetData('volume', math.max(item:GetData('volume') * mul, 0.05))

				if item:GetData('energy') <= 0 and not item:GetData('trash') then item:Remove() end
			end,
			fail = function()
				ply.eating = nil
			end,
		}, {
			time = 1.5,
			inst = true,
			action = function()
				ply:EmitSound('physics/plastic/plastic_box_strain' .. math.random(1,3) .. '.wav', 60, 150)
				ply:DoAnimation(ACT_GMOD_GESTURE_BECON)
			end
		})

		return 0
	end
end

octoinv.registerItem('food', {
	name = L.item_food,
	model = 'models/props_junk/garbage_takeoutcarton001a.mdl',
	icon = 'octoteam/icons/food_meal2.png',
	mass = 0.2,
	volume = 0.25,
	nostack = true,
	randomWeight = 0.33,
	desc = L.desc_item_food,
	energy = 0,
	maxenergy = 100,
	leftField = 'energy',
	leftMaxField = 'energy',
	use = {
		function(ply, item) if item:GetData('energy') > 0 then return eat(ply, item, 1, ' полностью') end end,
		function(ply, item) if item:GetData('energy') >= 10 then return eat(ply, item, 0.5, ' половину') end end,
		function(ply, item) if item:GetData('energy') >= 20 then return eat(ply, item, 0.25, ' немного') end end,
	},
})

octoinv.registerItem('armor', {
	name = L.armor,
	model = 'models/combine_vests/bluevest.mdl',
	icon = 'octoteam/icons/armor.png',
	mass = 3,
	volume = 5,
	nostack = true,
	nodespawn = true,
	desc = L.desc_armor2,
	use = {
		function(ply, item)
			local amount = item:GetData('armor') or 12
			if ply:Armor() >= amount then return false, L.you_already_have_armor end
			return L.wear, 'octoteam/icons/armor.png', function(ply, item)
				ply.armorItem = item:Export()
				ply.armorItem.armor = amount
				ply:SetArmor(amount)
				ply:SetLocalVar('armor', amount)
				ply:EmitSound('npc/combine_soldier/gear3.wav', 55)
				return 1
			end
		end,
	},
})

octoinv.registerItem('radio', {
	name = L.talkie,
	model = 'models/handfield_radio.mdl',
	icon = 'octoteam/icons/radio.png',
	mass = 1,
	volume = 0.8,
	nostack = true,
	nodespawn = true,
	desc = L.desc_talkie,
})

octoinv.registerItem('lockpick', {
	name = L.gun_lockpick,
	model = 'models/props_c17/tools_pliers01a.mdl',
	icon = 'octoteam/icons/lockpick.png',
	mass = 0.3,
	volume = 0.25,
	randomWeight = 0.5,
	nodespawn = true,
	desc = L.desc_lockpick,
})

octoinv.registerItem('lockpick_broken', {
	name = L.gun_broken_lockpick,
	model = 'models/props_c17/tools_pliers01a.mdl',
	icon = 'octoteam/icons/lockpick_broken.png',
	mass = 0.3,
	volume = 0.25,
	randomWeight = 0.5,
	nodespawn = true,
	desc = L.desc_broken_lockpick,
})

octoinv.registerItem('throwable', {
	name = 'Метательный предмет',
	icon = 'octoteam/icons/dynamite.png',
	mass = 0.5,
	volume = 0.4,
	usesLeft = 5,
	model = 'models/Items/BoxBuckshot.mdl',
	desc = '',
	nodespawn = true,
	nostack = true,
	gc = 'ent_dbg_throwable',
	leftField = 'usesLeft',
	leftMaxField = 'usesLeft',
	use = {
		function()
			return 'Сильно метнуть', 'octoteam/icons/explosion.png', function(ply, item)
				ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_THROW)
				local gc = item:GetData('gc')
				if not gc then return end
				timer.Simple(0.88, function()
					local ent = ents.Create(item:GetData('gc'))
					if not IsValid(ent) then return end
					ent:Throw(ply, 1)
				end)

				if not item:GetData('leftMax') then item:SetData('leftMax', item:GetData('usesLeft')) end
				item:SetData('usesLeft', (item:GetData('usesLeft') or 5) - 1)
				item:SetData('mass', 0.5 * item:GetData('usesLeft'))
				item:SetData('volume', 0.4 * item:GetData('usesLeft'))
				return item:GetData('usesLeft') <= 0 and 1 or 0
			end
		end,
		function()
			return 'Слабо метнуть', 'octoteam/icons/explosion.png', function(ply, item)
				ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
				local gc = item:GetData('gc')
				if not gc then return end
				timer.Simple(0.88, function()
					local ent = ents.Create(item:GetData('gc'))
					if not IsValid(ent) then return end
					ent:Throw(ply, 0.5)
				end)

				if not item:GetData('leftMax') then item:SetData('leftMax', item:GetData('usesLeft')) end
				item:SetData('usesLeft', (item:GetData('usesLeft') or 5) - 1)
				item:SetData('mass', 0.5 * item:GetData('usesLeft'))
				item:SetData('volume', 0.4 * item:GetData('usesLeft'))
				return item:GetData('usesLeft') <= 0 and 1 or 0
			end
		end,
		function()
			return 'Положить', 'octoteam/icons/explosion.png', function(ply, item)
				ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
				timer.Simple(0.88, function()
					local ent = ents.Create(item:GetData('gc'))
					if not IsValid(ent) then return end
					ent:Throw(ply, 0.1)
					timer.Simple(0.75, function()
						if not (IsValid(ent) and IsValid(ent:GetPhysicsObject())) then return end
						local phys = ent:GetPhysicsObject()
						phys:SetVelocity(0)
						phys:Sleep()
					end)
				end)

				if not item:GetData('leftMax') then item:SetData('leftMax', item:GetData('usesLeft')) end
				item:SetData('usesLeft', (item:GetData('usesLeft') or 5) - 1)
				item:SetData('mass', 0.5 * item:GetData('usesLeft'))
				item:SetData('volume', 0.4 * item:GetData('usesLeft'))
				return item:GetData('usesLeft') <= 0 and 1 or 0
			end
		end,
	},
})
