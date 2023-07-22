local woodsounds = {
	'physics/wood/wood_box_impact_bullet1.wav',
	'physics/wood/wood_box_impact_bullet2.wav',
	'physics/wood/wood_box_impact_bullet3.wav',
	'physics/wood/wood_box_impact_bullet4.wav',
	'physics/wood/wood_box_impact_hard1.wav',
	'physics/wood/wood_box_impact_hard2.wav',
	'physics/wood/wood_box_impact_hard3.wav',
}

------------------------------------------------
--
-- CONTAINERS
--
------------------------------------------------

-- octoinv.registerCraft('bpd_vend', {
-- 	name = L.vend,
-- 	desc = L.desc_bpd_vend,
-- 	icon = 'octoteam/icons/box3.png',
-- 	conts = {'_hand'},
-- 	sound = drillSounds,
-- 	soundTime = 2,
-- 	time = 30,
-- 	tools = {
-- 		{'tool_solder', 1},
-- 		{'tool_drill', 1},
-- 	},
-- 	ings = {
-- 		{'craft_cable', 4},
-- 		{'craft_bulb', 5},
-- 		{'craft_sheet', 2},
-- 		{'craft_plug', 1},
-- 		{'craft_relay', 1},
-- 		{'craft_transistor', 8},
-- 		{'craft_resistor', 8},
-- 	},
-- 	finish = {
-- 		{'bpd_vend', 1},
-- 	},
-- }) octoinv.registerCraft('cont_vend', {
-- 	name = L.vend,
-- 	desc = L.desc_cont_vend,
-- 	icon = 'octoteam/icons/machine_vend.png',
-- 	conts = {'_hand'},
-- 	sound = drillSounds,
-- 	soundTime = 2,
-- 	time = 30,
-- 	tools = {
-- 		{'tool_craft', 1},
-- 	},
-- 	ings = {
-- 		{'bp_vend', 1},
-- 		{'bpd_vend', 1},
-- 		{'craft_battery', 1},
-- 	},
-- 	finish = function(ply, cont)
-- 		local ent = ents.Create 'octoinv_vend'
-- 		ent.dt = ent.dt or {}
-- 		ent.dt.owning_ent = ply
-- 		ent.DestructParts = {
-- 			{'bpd_vend', 1},
-- 		}

-- 		ent.SID = ply.SID
-- 		ent:Spawn()

-- 		ply:BringEntity(ent)
-- 		ent:SetPlayer(ply)
-- 		ent:SetLocked(false)
-- 		return true
-- 	end,
-- })
