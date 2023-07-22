simfphys.AddPostSpawnAction('sim_fphys_gta4_bobcat_towtruck', function(veh)

	local hk = ents.Create 'dbg_tow_hook'
	hk:Spawn()
	hk:SetTruck(veh)

end)
