local descBP = L.descBP
local descBPD = L.descBDP
------------------------------------------------
--
-- BLUEPRINTS
--
------------------------------------------------

--
-- benches
--

octoinv.registerItem('bp_stove', {
	name = L.stove,
	icon = 'octoteam/icons/blueprint.png',
	mass = 0.1,
	volume = 0.1,
	nostack = true,
	desc = descBP,
}) octoinv.registerItem('bpd_stove', {
	name = L.stove,
	icon = 'octoteam/icons/parts_stove.png',
	mass = 40,
	volume = 35,
	nostack = true,
	desc = descBPD,
})

octoinv.registerItem('bp_fridge', {
	name = L.fridge,
	icon = 'octoteam/icons/blueprint.png',
	mass = 0.1,
	volume = 0.1,
	nostack = true,
	desc = descBP,
}) octoinv.registerItem('bpd_fridge', {
	name = L.fridge,
	icon = 'octoteam/icons/parts_fridge.png',
	mass = 50,
	volume = 40,
	nostack = true,
	desc = descBPD,
})

octoinv.registerItem('bp_vend', {
	name = L.vend,
	icon = 'octoteam/icons/blueprint.png',
	mass = 0.1,
	volume = 0.1,
	desc = descBP,
}) octoinv.registerItem('bpd_vend', {
	name = L.vend,
	icon = 'octoteam/icons/parts_vending.png',
	mass = 40,
	volume = 30,
	desc = descBPD,
})

octoinv.registerItem('bp_workbench', {
	name = L.workbench,
	icon = 'octoteam/icons/blueprint.png',
	mass = 0.1,
	volume = 0.1,
	nostack = true,
	desc = descBP,
}) octoinv.registerItem('bpd_workbench', {
	name = L.workbench,
	icon = 'octoteam/icons/parts_workbench.png',
	mass = 45,
	volume = 50,
	nostack = true,
	desc = descBPD,
})

octoinv.registerItem('bp_machine', {
	name = L.machine,
	icon = 'octoteam/icons/blueprint.png',
	mass = 0.1,
	volume = 0.1,
	nostack = true,
	desc = descBP,
}) octoinv.registerItem('bpd_machine', {
	name = L.machine,
	icon = 'octoteam/icons/parts_machine.png',
	mass = 60,
	volume = 45,
	nostack = true,
	desc = descBPD,
})

octoinv.registerItem('bp_refinery', {
	name = L.refinery,
	icon = 'octoteam/icons/blueprint.png',
	mass = 0.1,
	volume = 0.1,
	nostack = true,
	desc = descBP,
}) octoinv.registerItem('bpd_refinery', {
	name = L.refinery,
	icon = 'octoteam/icons/parts_refinery.png',
	mass = 80,
	volume = 55,
	nostack = true,
	desc = descBPD,
})

octoinv.registerItem('bp_smelter', {
	name = L.smelter,
	icon = 'octoteam/icons/blueprint.png',
	mass = 0.1,
	volume = 0.1,
	nostack = true,
	desc = descBP,
}) octoinv.registerItem('bpd_smelter', {
	name = L.smelter,
	icon = 'octoteam/icons/parts_smelter.png',
	mass = 60,
	volume = 50,
	nostack = true,
	desc = descBPD,
})

--
-- other
--

octoinv.registerItem('bp_printer', {
	name = L.printer,
	icon = 'octoteam/icons/blueprint.png',
	mass = 0.1,
	volume = 0.1,
	nostack = true,
	desc = descBP,
}) octoinv.registerItem('bpd_printer', {
	name = L.printer,
	icon = 'octoteam/icons/box3.png',
	mass = 18,
	volume = 15,
	nostack = true,
	desc = descBPD,
})
