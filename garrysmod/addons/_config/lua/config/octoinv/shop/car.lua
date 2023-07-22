hook.Add('Initialize', 'octoinv.shop.car', function() -- let simfphys load

local function carAtt(price, id)
	local att = simfphys.attachments[id]
	if not att then return end

	return {
		cat = 'car_atts',
		price = price,
		name = att.name,
		item = 'car_att',
		data = {
			name = att.name,
			desc = att.desc,
			icon = att.icon,
			attmdl = att.mdl,
			model = att.mdl,
			skin = att.skin,
			scale = att.scale,
			mass = att.mass,
			volume = att.volume,
		},
	}
end

--
-- CATEGORIES
--

octoinv.addShopCat('car', {
	name = L.to_car,
	icon = 'octoteam/icons/repair.png',
	jobs = {'mech'},
})
octoinv.addShopCat('car_parts', {
	name = L.car_parts,
	icon = 'octoteam/icons/car.png',
	jobs = {'mech'},
})
octoinv.addShopCat('car_rims', {
	name = L.discs,
	icon = 'octoteam/icons/wheel.png',
	jobs = {'mech'},
})
octoinv.addShopCat('car_atts', {
	name = L.car_atts,
	icon = 'octoteam/icons/bust.png',
	jobs = {'mech'},
})

--
-- ITEMS
--

octoinv.addShopItem('car_fuel', { cat = 'everyday', price = 1380 })

-- kits
octoinv.addShopItem('car_kit', { cat = 'car', price = 8000 })
octoinv.addShopItem('car_wheel', { cat = 'car', price = 3500 })
octoinv.addShopItem('car_paint', { cat = 'car', price = 22500 })
octoinv.addShopItem('tool_susp', { cat = 'car', price = 20000 })

for vehID, veh in pairs(carDealer.vehicles) do
	if not veh.bodygroups then continue end
	for bgID, group in pairs(veh.bodygroups) do
		for val, variant in ipairs(group.variants) do
			local bgVal = val - 1
			local variantName, variantPrice, variantMass, variantVolume = unpack(variant)
			local name = ('%s – %s: %s'):format(veh.name, group.name, variantName)
			octoinv.addShopItem(('%s_%d%d'):format(vehID, bgID, bgVal), {
				cat = 'car_parts',
				price = variantPrice,
				name = name,
				item = 'car_part',
				data = {
					name = name,
					car = veh.simfphysID,
					bgnum = bgID,
					bgval = bgVal,
					mass = variantMass or 20,
					volume = variantVolume or 15,
				},
			})
		end
	end
end

local rimID = 1
for wheelMdl, rim in pairs(simfphys.rims) do
	if not rim.price then continue end
	octoinv.addShopItem('rims' .. rimID, {
		cat = 'car_rims',
		price = rim.price,
		name = rim.name,
		item = 'car_rims',
		data = {
			name = rim.name,
			model = wheelMdl,
			mass = 25,
			volume = 15,
		},
	})

	rimID = rimID + 1
end

octoinv.addShopItem('att1', carAtt(175000, 'spoiler1'))
octoinv.addShopItem('att2', carAtt(195000, 'spoiler2'))
octoinv.addShopItem('att3', carAtt(190000, 'spoiler3'))
octoinv.addShopItem('att4', carAtt(150000, 'spoiler4'))
octoinv.addShopItem('att5', carAtt(200000, 'spoiler5'))
octoinv.addShopItem('att6', carAtt(120000, 'ladder'))
octoinv.addShopItem('att7', carAtt(250000, 'supercharger'))
octoinv.addShopItem('att8', carAtt(120000, 'huladoll'))

end)
