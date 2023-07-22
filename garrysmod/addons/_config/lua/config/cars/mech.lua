carDealer.addCategory('mech', {
	name = 'Механики',
	icon = octolib.icons.silk16('wrench'),
	canUse = function(ply) return ply:Team() == TEAM_MECH, 'Доступно только механикам' end,
	spawns = carDealer.civilSpawns,
	spawnCheck = carDealer.limits.mech,
	limitGroup = 'mech',
})

carDealer.addVeh('towtruck', {
	category = 'mech',
	name = 'Tow Truck',
	simfphysID = 'sim_fphys_gta4_bobcat_towtruck',
	price = 30000,
	deposit = true,
})
