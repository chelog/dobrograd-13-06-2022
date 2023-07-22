do return end

local minTime = 5 * 60 * 60

-- ammo
octoinv.registerMarketItem('cat_ammo', {
	name = 'Аммуниция',
	icon = 'octoteam/icons/gun_bullet.png',
	nostack = true,
})

local function registerAmmo(id, name, icon)
	octoinv.registerMarketItem('ammo_' .. id, {
		name = name,
		icon = icon,
		parent = 'cat_ammo',
		nostack = true,
		matches = function(item)
			return item.class == 'ammo' and item.ammotype == id
		end,
		canBuy = function(ply, order)
			return CFG.dev or ply:GetTimeTotal() >= minTime, 'Оружие можно покупать только наиграв на сервере 5 часов'
		end,
	})
end
registerAmmo('pistol', L.small_ammo, 'octoteam/icons/gun_bullet.png')
registerAmmo('smg1', L.large_ammo, 'octoteam/icons/gun_bullet2.png')
registerAmmo('sniper', L.sniper_ammo, 'octoteam/icons/gun_bullet2.png')
registerAmmo('buckshot', L.buckshot, 'octoteam/icons/gun_bullet.png')

-- guns
octoinv.registerMarketItem('cat_gun', {
	name = 'Оружие',
	icon = 'octoteam/icons/gun_pistol.png',
	nostack = true,
})

local gunBase
local function registerGun(id, name)
	octoinv.registerMarketItem(id, {
		name = name,
		parent = gunBase,
		nostack = true,
		matches = function(item)
			return item.class == 'weapon' and item.wepclass == 'weapon_octo_' .. id
		end,
		canBuy = function(ply, order)
			return CFG.dev or ply:GetTimeTotal() >= minTime, 'Оружие можно покупать только наиграв на сервере 5 часов'
		end,
	})
end

-------------------
-- PISTOLS
-------------------
octoinv.registerMarketItem('cat_gun_pistol', {
	name = 'Пистолеты',
	parent = 'cat_gun',
	nostack = true,
})

gunBase = 'cat_gun_pistol'
registerGun('357', 'Colt .357')
registerGun('deagle', 'Desert Eagle')
registerGun('dualelites', 'Dual Elites')
registerGun('fiveseven', 'FiveseveN')
registerGun('glock', 'Glock 27')
registerGun('p228', 'P228')
registerGun('usp', 'USP')
registerGun('usps', 'USP-S')

-------------------
-- RIFLES
-------------------
octoinv.registerMarketItem('cat_gun_rifle', {
	name = 'Автоматы',
	icon = 'octoteam/icons/gun_rifle.png',
	parent = 'cat_gun',
	nostack = true,
})
gunBase = 'cat_gun_rifle'
registerGun('ak', 'AK')
registerGun('famas', 'FAMAS')
registerGun('galil', 'Galil')
registerGun('m4a1', 'M4A1')
registerGun('m249', 'M249')

-------------------
-- SHOTGUNS
-------------------
octoinv.registerMarketItem('cat_gun_shotgun', {
	name = 'Дробовики',
	icon = 'octoteam/icons/gun_shotgun.png',
	parent = 'cat_gun',
	nostack = true,
})
gunBase = 'cat_gun_shotgun'
registerGun('m3', 'M3')
registerGun('xm1014', 'XM1014')

-------------------
-- SUBMACHINE GUNS
-------------------
octoinv.registerMarketItem('cat_gun_smg', {
	name = 'Полуавтоматы',
	icon = 'octoteam/icons/gun_smg.png',
	parent = 'cat_gun',
	nostack = true,
})
gunBase = 'cat_gun_smg'
registerGun('mac10', 'MAC10')
registerGun('mp5', 'MP5')
registerGun('p90', 'P90')
registerGun('tmp', 'TMP')
registerGun('ump45', 'UMP45')

-------------------
-- SNIPER
-------------------
octoinv.registerMarketItem('cat_gun_sniper', {
	name = 'Винтовки',
	icon = 'octoteam/icons/gun_sniper.png',
	parent = 'cat_gun',
	nostack = true,
})
gunBase = 'cat_gun_sniper'
registerGun('awp', 'AWP')
registerGun('scout', 'Scout')
registerGun('sg550', 'SG550')
