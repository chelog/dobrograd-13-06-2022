octoinv.registerItem('collector', {
	name = 'Инструмент',
	icon = octolib.icons.color('crowbar'),
	nostack = true,
	mass = 5,
	volume = 5,
	desc = 'Используется для сбора ресурсов',
	model = 'models/weapons/hl2meleepack/w_pickaxe.mdl',
	leftField = 'health',
	leftMaxField = 'maxhealth',
	nodespawn = true,
	use = {
		function(ply, item)
			local collector = octoinv.collectors[item:GetData('collector') or '']
			if not collector then return false, 'Неизвестный тип инструмента' end

			return L.take_in_hand, octolib.icons.color('crowbar'), function(ply, item)
				local wep = ents.Create('octoinv_collector')
				if not wep:IsValid() then return 0 end
			   if not wep:IsWeapon() then wep:Remove() return 0 end
				if not hook.Call('PlayerCanPickupWeapon', GAMEMODE, ply, wep) then return 0 end
				wep:Remove()

				local wep = ply:Give('octoinv_collector')
				wep:SetShouldPlayPickupSound(false)
				wep.itemData = item:Export()
				wep.itemCont = item:GetParent().id
				wep:SetCollectorID(item:GetData('collector'))
				wep.health = item:GetData('health') or collector.health

				if not wep.itemData.name or not wep.itemData.maxhealth then
					wep.itemData.name = collector.name
					wep.itemData.icon = collector.icon
					wep.itemData.maxhealth = collector.health
				end

				timer.Simple(0, function()
					ply:SelectWeapon('octoinv_collector')
				end)

				return 1
			end
		end,
	},
})

--
-- RESOURCES
--

octoinv.registerItem('ore_iron', {
	name = L.ore_iron,
	icon = 'octoteam/icons/ore_iron.png',
	model = 'models/un/ore_un_un.mdl',
	modelColor = Color(90,90,90),
	mass = 3,
	volume = 2,
	desc = L.descOre,
})

octoinv.registerItem('ore_steel', {
	name = L.ore_steel,
	icon = 'octoteam/icons/ore_steel.png',
	model = 'models/un/ore_un_un.mdl',
	modelColor = Color(185,185,185),
	mass = 3,
	volume = 2,
	desc = L.descOre,
})

octoinv.registerItem('ore_silver', {
	name = L.ore_silver,
	icon = 'octoteam/icons/ore_silver.png',
	model = 'models/un/ore_un_un.mdl',
	modelColor = Color(255,255,255),
	mass = 3,
	volume = 2,
	desc = L.descOre,
})

octoinv.registerItem('ore_bronze', {
	name = L.ore_bronze,
	icon = 'octoteam/icons/ore_bronze.png',
	model = 'models/un/ore_un_un.mdl',
	modelColor = Color(214,157,0),
	mass = 3,
	volume = 2,
	desc = L.descOre,
})

octoinv.registerItem('ore_gold', {
	name = L.ore_gold,
	icon = 'octoteam/icons/ore_gold.png',
	model = 'models/un/ore_un_un.mdl',
	modelColor = Color(255,207,77),
	mass = 3,
	volume = 2,
	desc = L.descOre,
})

octoinv.registerItem('ore_copper', {
	name = L.ore_copper,
	icon = 'octoteam/icons/ore_copper.png',
	model = 'models/un/ore_un_un.mdl',
	modelColor = Color(79,255,77),
	mass = 3,
	volume = 2,
	desc = L.descOre,
})

octoinv.registerItem('stone', {
	name = L.stone,
	icon = 'octoteam/icons/rock.png',
	model = 'models/un/ore_un_un.mdl',
	modelMaterial = 'models/props/CS_militia/militiarock',
	mass = 5,
	volume = 3,
	desc = 'Остатки горной породы, можно попробовать раздробить в очистителе',
})

octoinv.registerItem('rubble', {
	name = L.rubble,
	icon = 'octoteam/icons/rubble.png',
	model = 'models/props_marines/sandbag_static.mdl',
	mass = 5,
	volume = 2.5,
	desc = 'Дробленые куски горной породы среднего размера',
})

octoinv.registerItem('sand', {
	name = L.sand,
	icon = 'octoteam/icons/sand.png',
	model = 'models/props_marines/sandbag_static.mdl',
	mass = 5,
	volume = 2,
	desc = 'Очень мелкие частицы горной породы',
})

octoinv.registerItem('sulfur', {
	name = L.sulfur,
	icon = 'octoteam/icons/sulfur.png',
	model = 'models/un/ore_un_un.mdl',
	modelMaterial = 'models/props/cs_assault/pylon',
	mass = 0.8,
	volume = 0.5,
	desc = 'Грубые кристаллы серы',
})

octoinv.registerItem('ingot_iron', {
	name = L.ingot_iron,
	icon = 'octoteam/icons/ingot_iron.png',
	mass = 1,
	volume = 0.5,
	desc = L.descIngot,
})

octoinv.registerItem('ingot_steel', {
	name = L.ingot_steel,
	icon = 'octoteam/icons/ingot_steel.png',
	mass = 1,
	volume = 0.5,
	desc = L.descIngot,
})

octoinv.registerItem('ingot_silver', {
	name = L.ingot_silver,
	icon = 'octoteam/icons/ingot_silver.png',
	mass = 1,
	volume = 0.5,
	desc = L.descIngot,
})

octoinv.registerItem('ingot_bronze', {
	name = L.ingot_bronze,
	icon = 'octoteam/icons/ingot_bronze.png',
	mass = 1,
	volume = 0.5,
	desc = L.descIngot,
})

octoinv.registerItem('ingot_gold', {
	name = L.ingot_gold,
	icon = 'octoteam/icons/ingot_gold.png',
	mass = 1,
	volume = 0.5,
	desc = L.descIngot,
})

octoinv.registerItem('ingot_copper', {
	name = L.ingot_copper,
	icon = 'octoteam/icons/ingot_copper.png',
	mass = 1,
	volume = 0.5,
	desc = L.descIngot,
})

octoinv.registerItem('craft_coal', {
	name = L.craft_coal,
	icon = 'octoteam/icons/coal.png',
	model = 'models/un/ore_un_un.mdl',
	modelMaterial = 'models/gibs/metalgibs/metal_gibs',
	mass = 3,
	volume = 3,
	randomWeight = 0.25,
	desc = L.descFuel,
})
