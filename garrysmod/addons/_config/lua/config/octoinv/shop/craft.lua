--
-- CATEGORIES
--

octoinv.addShopCat('tool', {
	name = L.tools,
	icon = 'octoteam/icons/repair.png',
})

octoinv.addShopCat('build', {
	name = L.build,
	icon = 'octoteam/icons/cog.png',
})

octoinv.addShopCat('blueprint', {
	name = L.blueprint,
	icon = 'octoteam/icons/blueprint.png',
})

octoinv.addShopCat('parts', {
	name = L.parts,
	icon = 'octoteam/icons/cogs.png',
})

octoinv.addShopCat('prod', {
	name = L.prod,
	icon = 'octoteam/icons/robot_arm.png',
})

--
-- ITEMS
--

octoinv.addShopItem('tool_screwer', { cat = 'tool', price = 350 })
octoinv.addShopItem('tool_hammer', { cat = 'tool', price = 250 })
octoinv.addShopItem('tool_wrench', { cat = 'tool', price = 500 })
octoinv.addShopItem('tool_solder', { cat = 'tool', price = 850 })
octoinv.addShopItem('tool_ruler', { cat = 'tool', price = 50 })
octoinv.addShopItem('tool_caliper', { cat = 'tool', price = 450 })
octoinv.addShopItem('tool_pump', { cat = 'tool', price = 800 })
octoinv.addShopItem('tool_knife_stanley', { cat = 'tool', price = 100 })
octoinv.addShopItem('tool_drill', { cat = 'tool', price = 1500 })
octoinv.addShopItem('tool_saw', { cat = 'tool', price = 350 })
octoinv.addShopItem('tool_craft', { cat = 'tool', price = 1000 })
octoinv.addShopItem('tool_pen', { cat = 'everyday', price = 45 })
octoinv.addShopItem('tool_pencil', { cat = 'everyday', price = 10 })

octoinv.addShopItem('craft_screw', { cat = 'build', price = 40 })
octoinv.addShopItem('craft_screw2', { cat = 'build', price = 50 })
octoinv.addShopItem('craft_screwnut', { cat = 'build', price = 40 })
octoinv.addShopItem('craft_nail', { cat = 'build', price = 30 })
octoinv.addShopItem('craft_stick', { cat = 'build', price = 20 })
octoinv.addShopItem('craft_plank', { cat = 'build', price = 100 })
octoinv.addShopItem('craft_pallet', { cat = 'build', price = 150 })
octoinv.addShopItem('craft_sheet', { cat = 'build', price = 800 })
octoinv.addShopItem('craft_spring', { cat = 'build', price = 90 })
octoinv.addShopItem('craft_pulley', { cat = 'build', price = 150 })
octoinv.addShopItem('craft_cable', { cat = 'build', price = 50 })
octoinv.addShopItem('craft_plug', { cat = 'build', price = 45 })
octoinv.addShopItem('craft_socket', { cat = 'build', price = 60 })
octoinv.addShopItem('craft_piston', { cat = 'build', price = 180 })
octoinv.addShopItem('craft_engine', { cat = 'build', price = 500 })
octoinv.addShopItem('craft_bulb', { cat = 'build', price = 45 })
octoinv.addShopItem('craft_chip1', { cat = 'build', price = 100 })
octoinv.addShopItem('craft_chip2', { cat = 'build', price = 450 })
octoinv.addShopItem('craft_cnc', { cat = 'build', price = 300 })
octoinv.addShopItem('craft_relay', { cat = 'build', price = 30 })
octoinv.addShopItem('craft_resistor', { cat = 'build', price = 35 })
octoinv.addShopItem('craft_transistor', { cat = 'build', price = 30 })
octoinv.addShopItem('craft_solar', { cat = 'build', price = 800 })
octoinv.addShopItem('craft_gauge', { cat = 'build', price = 450 })
octoinv.addShopItem('craft_scotch', { cat = 'build', price = 50 })
octoinv.addShopItem('craft_glue', { cat = 'build', price = 35 })
octoinv.addShopItem('craft_paper', { cat = 'build', price = 8 })
octoinv.addShopItem('craft_ink', { cat = 'everyday', price = 650 })
octoinv.addShopItem('ing_water', { cat = 'everyday', price = 30 })
octoinv.addShopItem('craft_battery', { cat = 'everyday', price = 400 })
octoinv.addShopItem('craft_battery2', { cat = 'everyday', price = 50 })

octoinv.addShopItem('craft_fuel', { cat = 'prod', price = 50 })
octoinv.addShopItem('craft_gas', { cat = 'prod', price = 400 })
octoinv.addShopItem('saltpeter', { cat = 'prod', price = 2000 })

octoinv.addShopItem('bp_stove', { cat = 'blueprint', price = 150 })
octoinv.addShopItem('bp_fridge', { cat = 'blueprint', price = 150 })
octoinv.addShopItem('bp_refinery', { cat = 'blueprint', price = 150 })
octoinv.addShopItem('bp_smelter', { cat = 'blueprint', price = 150 })
octoinv.addShopItem('bp_machine', { cat = 'blueprint', price = 150 })
octoinv.addShopItem('bp_workbench', { cat = 'blueprint', price = 150 })

octoinv.addShopItem('bpd_stove', { cat = 'parts', price = 6500 })
octoinv.addShopItem('bpd_fridge', { cat = 'parts', price = 2500 })
octoinv.addShopItem('bpd_refinery', { cat = 'parts', price = 7500 })
octoinv.addShopItem('bpd_smelter', { cat = 'parts', price = 6000 })
octoinv.addShopItem('bpd_machine', { cat = 'parts', price = 6500 })
octoinv.addShopItem('bpd_workbench', { cat = 'parts', price = 3500 })
