local function checkPrinterLimit(ply)
	local prods = octolib.getLinkedEnts(ply:SteamID(), {'octoinv_prod'})
	local hasPrinters = octolib.table.count(prods, function(ent)
		local inv = IsValid(ent) and ent.inv
		return inv and inv.conts and inv.conts.printer or false
	end)
	if hasPrinters >= 2 then
		return false, 'Достигнут лимит принтеров'
	end
	return true
end

------------------------------------------------
--
-- OTHER
--
------------------------------------------------

-- octoinv.registerCraft('printer', {
-- 	name = L.printer,
-- 	desc = L.desc_printer,
-- 	icon = 'octoteam/icons/atm.png',
-- 	conts = {'_hand'},
-- 	sound = drillSounds,
-- 	soundTime = 2,
-- 	time = 25,
-- 	tools = {
-- 		{'tool_screwer', 1},
-- 		{'tool_wrench', 1},
-- 	},
-- 	ings = {
-- 		{'bp_printer', 1},
-- 		{'craft_screw2', 20},
-- 		{'craft_screwnut', 20},
-- 		{'craft_engine', 1},
-- 		{'craft_cable', 3},
-- 		{'craft_cnc', 1},
-- 		{'craft_sheet', 2},
-- 	},
-- 	finish = octoinv.spawnProd({
-- 		mdl = 'models/props_c17/consolebox01a.mdl',
-- 		conts = {
-- 			printer_cart = { name = L.printer_cart, volume = 3 },
-- 			printer = { name = L.printer, volume = 5, prod = true },
-- 		},
-- 		prod = 'printer',
-- 		check = checkPrinterLimit,
-- 		other = {
-- 			CanBeOwnedBy = function(_, ply)
-- 				return checkPrinterLimit(ply)
-- 			end,
-- 		},
-- 	}),
-- })

-- octoinv.registerCraft('craft_paper2', {
-- 	name = L.craft_paper2,
-- 	icon = 'octoteam/icons/paper_stack.png',
-- 	conts = {'workbench'},
-- 	time = 5,
-- 	ings = {
-- 		{'craft_paper', 10}
-- 	},
-- 	finish = {
-- 		{'craft_paper2', 1}
-- 	},
-- })

octoinv.registerCraft('craft_radio', {
	name = L.talkie,
	icon = 'octoteam/icons/radio.png',
	conts = {'workbench'},
	jobs = {'gun', 'gun2'},
	time = 15,
	tools = {
		{'tool_screwer', 1},
		{'tool_solder', 1},
	},
	ings = {
		{'craft_resistor', 5},
		{'craft_chip2', 1},
		{'craft_bulb', 3},
		{'craft_relay', 5},
		{'craft_glue', 1},
		{'craft_cable', 10},
		{'craft_sheet', 2},
		{'craft_screwnut', 8},
		{'craft_screw2', 8},
		{'craft_transistor', 5},
	},
	finish = {
		{'radio', 1}
	},
})

octoinv.registerCraft('craft_binoculars', {
	name = L.craft_binoculars,
	icon = 'octoteam/icons/binoculars.png',
	conts = {'workbench'},
	jobs = {'gun', 'gun2'},
	time = 20,
	tools = {
		{'tool_screwer', 1},
		{'tool_hammer', 1},
	},
	ings = {
		{'craft_sheet', 2},
		{'craft_glue', 1},
		{'craft_sight', 4},
		{'craft_spring', 2},
		{'craft_piston', 2},
	},
	finish = {
		{'binoculars', 1}
	},
})
