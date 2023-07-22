local setReadyIfPossible = [[local wep = LocalPlayer():GetWeapon('%s')if IsValid(wep) and isfunction(wep.SetReady) then wep:SetReady(false)end]]

local function getItemData(wep)

	local itemData = hook.Run('dbg-weapons.getItemData', wep)
	if itemData then return itemData end

	local class = wep:GetClass()

	local itemData = wep.itemData
	local classData
	local bprint = octoinv.blueprints['gun_' .. (class:sub(13) or '')]
	if bprint and bprint.finish and bprint.finish[1] then
		classData = bprint.finish[1][2]
		if not itemData then itemData = bprint.finish[1][2] end
	end

	if not itemData then
		local gmodData = weapons.Get(class) or {
			PrintName = L.weapons,
			Icon = 'octoteam/icons/gun_pistol.png',
		}
		itemData = {
			name = gmodData.PrintName ~= 'Scripted Weapon' and gmodData.PrintName or class,
			icon = gmodData.Icon or 'octoteam/icons/gun_pistol.png',
			model = wep.WorldModel or gmodData.WorldModel,
		}
	else
		itemData = table.Copy(itemData) -- do not break referenced table
	end

	itemData.wepclass = class
	itemData.volume = itemData.volume or classData and classData.volume or 1
	itemData.mass = itemData.mass or classData and classData.mass or 1
	itemData.icon = itemData.icon or classData and classData.icon
	itemData.model = itemData.model or classData and classData.model

	return itemData

end

local meta = FindMetaTable('Player')
function meta:HolsterWeapon(wep)

	if not self.inv or not self:HasWeapon('dbg_hands') or wep:GetOwner() ~= self or wep.holstered then return end
	wep.holstered = true

	local ammo = self:GetAmmoCount(wep:GetPrimaryAmmoType())
	if wep.SetReady then
		wep:SetNetVar('NoReadyInput', true)
		self:SendLua(string.format(setReadyIfPossible, wep:GetClass()))
		wep:SetReady(false)
	end
	self:DropWeapon(wep)

	local itemData = getItemData(wep)

	self:SelectWeapon('dbg_hands')
	local cont = self.inv:GetContainer(wep.itemCont or '_hand') or self.inv:GetContainer('_hand')
	if cont:FreeSpace() < (itemData.volume or 1) then cont = self.inv:GetContainer('_hand') end

	local dontGive = false
	if not itemData.class or itemData.class == 'weapon' then
		itemData.clip1 = wep:Clip1()
		itemData.clip2 = wep:Clip2()
		itemData.ammoadd = ammo
		if octoinv.gunBlacklist[itemData.wepclass or ''] then
			self:Notify('warning', 'Это оружие запрещено использовать на сервере. Стоит рассказать администрации, как ты его заполучил')
			dontGive = true
		end
		-- itemData.leftMax = wep.Primary and wep.Primary.ClipSize
	end

	if not dontGive and (not itemData.expire or itemData.expire > os.time()) then
		local function giveItem()
			return cont:AddItem(itemData.class or 'weapon', itemData)
		end
		local item = giveItem()
		if not item or item == 0 then
			cont = self.inv:GetContainer('_hand')
			item = giveItem()
			if not item or item == 0 then return end
		end
	end

	if wep.expireId then
		timer.Remove(wep.expireId)
	end

	hook.Run('dbg-weapons.holstered', cont, itemData, self)
	hook.Call('onDarkRPWeaponDropped', nil, self, nil, wep)
	self:RemoveAmmo(ammo, wep:GetPrimaryAmmoType())
	wep:Remove()

end

meta.oldSwitchToDefault = meta.oldSwitchToDefault or meta.SwitchToDefaultWeapon
function meta:SwitchToDefaultWeapon()
	if self:HasWeapon('dbg_hands') then
		self:SelectWeapon('dbg_hands')
	else self:oldSwitchToDefault() end
end

function meta:dropDRPWeapon(wep, pos, ang, vel)

	if not pos or not ang or not vel then
		pos, ang = self:GetBonePosition(self:LookupBone('ValveBiped.Bip01_L_Hand') or 16)
		vel = self:GetAimVector()
		vel.z = 0
		vel = vel * 200
	end

	local ammo = self:GetAmmoCount(wep:GetPrimaryAmmoType())
	local model = wep.WorldModel or (wep:GetModel() == 'models/weapons/v_physcannon.mdl' and 'models/weapons/w_physics.mdl') or wep:GetModel()
	model = util.IsValidModel(model) and model or 'models/weapons/w_pist_glock18.mdl'
	if wep.SetReady then
		wep:SetNetVar('NoReadyInput', true)
		self:SendLua(string.format(setReadyIfPossible, wep:GetClass()))
		wep:SetReady(false)
	end
	self:DropWeapon(wep)

	local ent = ents.Create 'octoinv_item'
	ent:SetPos(pos)
	ent:SetAngles(ang)
	ent.Model = model

	local itemData = getItemData(wep)
	if not itemData.class or itemData.class == 'weapon' then
		itemData.clip1 = wep:Clip1()
		itemData.clip2 = wep:Clip2()
		itemData.ammoadd = ammo
		-- itemData.leftMax = wep.Primary and wep.Primary.ClipSize
	end
	ent:SetData(itemData.class or 'weapon', itemData)

	if wep.expireId then
		timer.Remove(wep.expireId)
	end

	hook.Call('onDarkRPWeaponDropped', nil, self, ent, wep)
	self:RemoveAmmo(ammo, wep:GetPrimaryAmmoType())
	wep:Remove()
	self:SwitchToDefaultWeapon()

	if not itemData.expire or itemData.expire > os.time() then
		ent:Spawn()
		ent:Activate()

		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetVelocity(vel)
		end
	else
		ent:Remove()
	end

	return ent

end
