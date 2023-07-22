local descTool = L.descTool
local descCraft = L.descCraft
local descFuel = L.descFuel
local descCraftFuel = L.descCraftFuel

------------------------------------------------
--
-- TOOLS
--
------------------------------------------------

octoinv.registerItem('tool_screwer', {
	name = L.tool_screwer,
	icon = 'octoteam/icons/screwdriver.png',
	mass = 0.2,
	volume = 0.15,
	randomWeight = 0.25,
	desc = descTool,
})

octoinv.registerItem('tool_hammer', {
	name = L.tool_hammer,
	icon = 'octoteam/icons/hammer.png',
	mass = 0.2,
	volume = 0.15,
	randomWeight = 0.25,
	desc = descTool,
})

octoinv.registerItem('tool_wrench', {
	name = L.tool_wrench,
	icon = 'octoteam/icons/wrench.png',
	mass = 0.35,
	volume = 0.2,
	randomWeight = 0.25,
	desc = descTool,
})

octoinv.registerItem('tool_solder', {
	name = L.tool_solder,
	icon = 'octoteam/icons/solder.png',
	mass = 0.5,
	volume = 0.3,
	randomWeight = 0.25,
	desc = descTool,
})

octoinv.registerItem('tool_ruler', {
	name = L.tool_ruler,
	icon = 'octoteam/icons/ruler.png',
	mass = 0.35,
	volume = 0.2,
	randomWeight = 0.25,
	desc = descTool,
})

octoinv.registerItem('tool_caliper', {
	name = L.tool_caliper,
	icon = 'octoteam/icons/caliper.png',
	mass = 0.35,
	volume = 0.2,
	randomWeight = 0.25,
	desc = descTool,
})

octoinv.registerItem('tool_knife_stanley', {
	name = L.tool_knife_stanley,
	icon = 'octoteam/icons/knife_stanley.png',
	mass = 0.1,
	volume = 0.1,
	randomWeight = 0.25,
	desc = descTool,
})

octoinv.registerItem('tool_drill', {
	name = L.tool_drill,
	icon = 'octoteam/icons/drill.png',
	mass = 1.5,
	volume = 1,
	randomWeight = 0.25,
	desc = descTool,
})

octoinv.registerItem('tool_saw', {
	name = L.tool_saw,
	icon = 'octoteam/icons/saw.png',
	mass = 1.5,
	volume = 1,
	randomWeight = 0.25,
	desc = descTool,
})

octoinv.registerItem('tool_pump', {
	name = L.tool_pump,
	icon = 'octoteam/icons/pump_hand.png',
	mass = 0.8,
	volume = 0.4,
	randomWeight = 0.25,
	desc = descTool,
})

octoinv.registerItem('tool_craft', {
	name = L.tool_craft,
	icon = 'octoteam/icons/tool_craft.png',
	mass = 1.5,
	volume = 1,
	randomWeight = 0.25,
	desc = descTool,
})

------------------------------------------------
--
-- BUILD RESOURCES
--
------------------------------------------------

octoinv.registerItem('craft_screw', {
	name = L.craft_screw,
	icon = 'octoteam/icons/screw.png',
	mass = 0.01,
	volume = 0.01,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_screw2', {
	name = L.craft_screw2,
	icon = 'octoteam/icons/screw2.png',
	mass = 0.01,
	volume = 0.01,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_screwnut', {
	name = L.craft_screwnut,
	icon = 'octoteam/icons/screwnut.png',
	mass = 0.01,
	volume = 0.01,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_nail', {
	name = L.craft_nail,
	icon = 'octoteam/icons/nail.png',
	mass = 0.01,
	volume = 0.01,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_stick', {
	name = L.craft_stick,
	icon = 'octoteam/icons/stick.png',
	mass = 0.5,
	volume = 1,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_plank', {
	name = L.craft_plank,
	icon = 'octoteam/icons/wood.png',
	mass = 2,
	volume = 3,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_pallet', {
	name = L.craft_pallet,
	icon = 'octoteam/icons/pallet.png',
	mass = 2,
	volume = 5,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_sheet', {
	name = L.craft_sheet,
	icon = 'octoteam/icons/metal_sheet.png',
	mass = 1,
	volume = 0.5,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_spring', {
	name = L.craft_spring,
	icon = 'octoteam/icons/metal_spring.png',
	mass = 0.1,
	volume = 0.1,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_pulley', {
	name = L.craft_pulley,
	icon = 'octoteam/icons/pulley.png',
	mass = 0.2,
	volume = 0.2,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_cable', {
	name = L.craft_cable,
	icon = 'octoteam/icons/cable.png',
	mass = 0.2,
	volume = 0.2,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_plug', {
	name = L.craft_plug,
	icon = 'octoteam/icons/plug.png',
	mass = 0.1,
	volume = 0.1,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_socket', {
	name = L.craft_socket,
	icon = 'octoteam/icons/socket.png',
	mass = 0.1,
	volume = 0.2,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_piston', {
	name = L.craft_piston,
	icon = 'octoteam/icons/piston.png',
	mass = 0.5,
	volume = 0.5,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_engine', {
	name = L.craft_engine,
	icon = 'octoteam/icons/engine.png',
	mass = 1,
	volume = 0.5,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_bulb', {
	name = L.craft_bulb,
	icon = 'octoteam/icons/bulb.png',
	mass = 0.1,
	volume = 0.3,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_chip1', {
	name = L.craft_chip1,
	icon = 'octoteam/icons/chip1.png',
	mass = 0.1,
	volume = 0.1,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_chip2', {
	name = L.craft_chip2,
	icon = 'octoteam/icons/chip2.png',
	mass = 0.05,
	volume = 0.05,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_cnc', {
	name = L.craft_cnc,
	icon = 'octoteam/icons/machine_cnc.png',
	mass = 0.15,
	volume = 0.15,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_relay', {
	name = L.craft_relay,
	icon = 'octoteam/icons/relay.png',
	mass = 0.02,
	volume = 0.02,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_resistor', {
	name = L.craft_resistor,
	icon = 'octoteam/icons/resistor.png',
	mass = 0.02,
	volume = 0.02,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_transistor', {
	name = L.craft_transistor,
	icon = 'octoteam/icons/transistor.png',
	mass = 0.02,
	volume = 0.02,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_solar', {
	name = L.craft_solar,
	icon = 'octoteam/icons/solar_panel.png',
	mass = 1,
	volume = 1,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_gauge', {
	name = L.craft_gauge,
	icon = 'octoteam/icons/speed.png',
	mass = 0.5,
	volume = 0.5,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_scotch', {
	name = L.craft_scotch,
	icon = 'octoteam/icons/scotch.png',
	mass = 0.1,
	volume = 0.1,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_glue', {
	name = L.craft_glue,
	icon = 'octoteam/icons/glue.png',
	mass = 0.15,
	volume = 0.15,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_ink', {
	name = L.craft_ink,
	icon = 'octoteam/icons/ink.png',
	mass = 0.1,
	volume = 0.1,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_paper', {
	name = L.craft_paper,
	icon = 'octoteam/icons/paper.png',
	mass = 0.005,
	volume = 0.01,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('craft_paper2', {
	name = L.craft_paper2,
	icon = 'octoteam/icons/paper_stack.png',
	mass = 0.05,
	volume = 0.05,
	randomWeight = 0.1,
	desc = descCraft,
})

octoinv.registerItem('saltpeter', {
	name = L.saltpeter,
	icon = 'octoteam/icons/saltpeter.png',
	model = 'models/props_lab/chemjar01.mdl',
	mass = 0.4,
	volume = 0.3,
	desc = descCraft,
})

octoinv.registerItem('gunpowder', {
	name = L.gunpowder,
	icon = 'octoteam/icons/gunpowder.png',
	model = 'models/props_lab/chemjar01.mdl',
	mass = 0.4,
	volume = 0.3,
	desc = descCraft,
})

------------------------------------------------
--
-- FUEL
--
------------------------------------------------

octoinv.registerItem('craft_fuel', {
	name = L.craft_fuel,
	icon = 'octoteam/icons/fuel_barrel.png',
	mass = 1,
	volume = 1,
	randomWeight = 0.25,
	desc = descFuel,
})

octoinv.registerItem('craft_gas', {
	name = L.craft_gas,
	icon = 'octoteam/icons/fuel_tank.png',
	mass = 15,
	volume = 15,
	randomWeight = 0.25,
	desc = descFuel,
})

------------------------------------------------
--
-- HYBRID RESOURCES
--
------------------------------------------------

octoinv.registerItem('craft_battery', {
	name = L.craft_battery,
	icon = 'octoteam/icons/battery_car.png',
	mass = 3.5,
	volume = 2.5,
	nostack = true,
	randomWeight = 0.5,
	desc = descCraftFuel,
})

octoinv.registerItem('craft_battery2', {
	name = L.craft_battery2,
	icon = 'octoteam/icons/battery_charge.png',
	mass = 0.15,
	volume = 0.1,
	nostack = false,
	randomWeight = 0.5,
	desc = descCraftFuel,
})

------------------------------------------------
--
-- TRASH
--
------------------------------------------------

octoinv.registerItem('craft_bottle', {
	name = L.craft_bottle,
	icon = 'octoteam/icons/bottle_empty.png',
	mass = 0.2,
	volume = 0.5,
	randomWeight = 0.25,
	desc = descCraft,
})

octoinv.registerItem('craft_glass', {
	name = L.craft_glass,
	icon = 'octoteam/icons/glass.png',
	mass = 0.3,
	volume = 0.3,
	randomWeight = 0.25,
	desc = descCraft,
})
