octoinv.registerItem('fish_line', {
	name = 'Леска',
	icon = 'octoteam/icons/rope.png',
	mass = 0.017,
	nostack = true,
	volume = 0.02,
	desc = L.descCraft,
})

octoinv.registerItem('fish_tackle', {
	name = 'Рыболовная снасть',
	icon = 'octoteam/icons/fishing_tackle.png',
	mass = 0.21,
	volume = 0.04,
	desc = L.descCraft,
})

octoinv.registerItem('fish_bait', {
	name = 'Приманка',
	icon = 'octoteam/icons/box3.png',
	mass = 0.4,
	volume = 0.5,
	desc = 'Приманка, используется для ловли рыбы',
	nostack = true,
	use = {
		function(ply, item)
			local wep = ply:GetActiveWeapon()
			if not IsValid(wep) or wep:GetClass() ~= 'weapon_octo_fishing_rod' then return false, 'В руках должна быть удочка' end
			if wep.bait then return false, 'На крючке уже есть приманка' end
			return 'Зацепить на удочку', 'octoteam/icons/fishing_tackle.png', function(ply, item)
				local left = (item:GetData('baitsLeft') or 10) - 1

				wep.bait = item:GetData('bait')
				item:SetData('desc', ('В пачке осталось %s %s'):format(left, octolib.string.formatCount(left, 'штука', 'штуки', 'штук')))
				item:SetData('baitsLeft', left)

				return left <= 0 and 1 or 0
			end
		end,
	}
})

local function useAddLine(ply, item, tThin)
	local action = ('Прикрепить %s леску'):format(tThin and 'тонкую' or 'крепкую')
	if not item then return end
	if item:GetData('thin') ~= nil then return end
	local cont = item:GetParent()
	if not cont then return end
	local line = cont:FindItem({class = 'fish_line', thin = tThin})
	if not line then return false, action end
	return action, 'octoteam/icons/rope.png', function(ply, item)
		if not line then return end
		ply:DelayedAction('fishlineadd', 'Крепление лески', {
			time = 5,
			check = function() return IsValid(ply) and ply:HasItem(item) and item:GetData('thin') == nil and cont:HasItem(line) end,
			succ = function()
				cont:TakeItem(line)
				item:SetData('thin', tThin)
				item:SetData('usesLeft', 50)
				item:SetData('desc', ('Используется для ловли рыбы.\n\nЛеска %s, новая'):format(tThin and 'тонкая' or 'крепкая'))
				cont:QueueSync()
			end,
		}, {
			time = 1.5,
			inst = true,
			action = function()
				ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
				local sound = 'weapons/357/357_reload'.. math.random(1, 4) ..'.wav'
				ply:EmitSound(sound, 50)
			end,
		})
	end
end

octoinv.registerItem('fishing_rod', {
	name = 'Удочка',
	icon = 'octoteam/icons/fishing_rod.png',
	mass = 1.13,
	nostack = true,
	volume = 0.37,
	randomWeight = 0.25,
	desc = 'Используется для ловли рыбы',
	model = 'models/fishingmod_custom/fishingrod_beta2.mdl',
	use = {
		function(ply, item)
			if item:GetData('thin') == nil then return end
			return L.take_in_hand, 'octoteam/icons/fishing_rod.png', function(ply, item)
				if item:GetData('thin') == nil then return end
				local wep = ents.Create('weapon_octo_fishing_rod')
				if not wep:IsValid() then return 0 end
			   if not wep:IsWeapon() then wep:Remove() return 0 end
				if not hook.Call('PlayerCanPickupWeapon', GAMEMODE, ply, wep) then return 0 end
				wep:Remove()

				local wep = ply:Give('weapon_octo_fishing_rod')
				wep:SetShouldPlayPickupSound(false)
				wep.itemData = item:Export()
				wep.itemCont = item:GetParent().id
				wep.thin = item:GetData('thin')
				wep.usesLeft = item:GetData('usesLeft') or 0

				timer.Simple(0, function()
					ply:SelectWeapon('weapon_octo_fishing_rod')
				end)

				return 1
			end
		end,
		function(ply, item)
			if item:GetData('thin') == nil then return end
			local msg = ('%s леску'):format(item:GetData('usesLeft') == 50 and 'Снять' or 'Выкинуть')
			return msg, 'octoteam/icons/rope.png', function(ply, item)
				local thin = item:GetData('thin') or false
				ply:DelayedAction('fishlineremove', 'Снятие лески', {
					time = 5,
					check = function() return IsValid(ply) and tobool(ply:HasItem(item)) and item:GetData('thin') ~= nil end,
					succ = function()
						if not ply:HasItem(item) then return end
						if item:GetData('thin') == nil then return end
						if item:GetData('usesLeft') == 50 then
							local cnt, line = ply:AddItem('fish_line')
							if line ~= nil then
								line:SetData('name', item:GetData('thin') and 'Тонкая леска' or 'Крепкая леска')
								line:SetData('thin', item:GetData('thin'))
							end
						end
						item:SetData('thin', nil)
						item:SetData('usesLeft', 0)
						item:SetData('desc', 'Используется для ловли рыбы')
						item:GetParent():QueueSync()
					end,
				}, {
					time = 1.5,
					inst = true,
					action = function()
						ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_DROP + math.random(0,1))
						local sound = 'weapons/357/357_reload'.. math.random(1, 4) ..'.wav'
						ply:EmitSound(sound, 50)
					end,
				})
			end
		end,
		function(ply, item)
			return useAddLine(ply, item, true)
		end,
		function(ply, item, cont)
			return useAddLine(ply, item, false)
		end,
	}
})

octoinv.registerItem('ing_fish1', {
	name = 'Окунь',
	icon = 'octoteam/icons/fish_perch.png',
	mass = 2.5,
	volume = 2,
	randomWeight = 0.2,
	desc = L.descing,
})

octoinv.registerItem('ing_fish2', {
	name = 'Карп',
	icon = 'octoteam/icons/fish_carp.png',
	mass = 2.5,
	volume = 2,
	randomWeight = 0.2,
	desc = L.descing,
})

octoinv.registerItem('ing_fish3', {
	name = 'Форель',
	icon = 'octoteam/icons/fish_trout.png',
	mass = 5,
	volume = 3,
	randomWeight = 0.25,
	desc = L.descing,
})

octoinv.registerItem('ing_fish4', {
	name = 'Щука',
	icon = 'octoteam/icons/fish_pike.png',
	mass = 8,
	volume = 5,
	randomWeight = 0.1,
	desc = L.descing,
})
