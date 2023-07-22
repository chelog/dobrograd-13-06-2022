hook.Add('octolib.db.init', 'octoinv', function(db)

	octolib.db:RunQuery([[
		CREATE TABLE IF NOT EXISTS inventory (
			steamID VARCHAR(30) NOT NULL,
			inv TEXT,
			storage TEXT,
				PRIMARY KEY (steamID)
		) ENGINE=INNODB CHARACTER SET utf8 COLLATE utf8_general_ci
	]])

end)

hook.Add('PlayerDisconnected', 'octoinv', function(ply)

	if hook.Run('octoinv.overrideInventories') == false then return end

	local hand = ply.inv and ply.inv.conts._hand
	if hand then
		local ang = ply:EyeAngles()
		hand:Remove(true, ply:EyePos(), ang, ang:Forward() * 200 + VectorRand() * 20)
	end

	ply:SaveInventory()

	if ply.inv then
		ply.inv:Remove()
	end

end)

hook.Add('PlayerSpawn', 'octoinv', function(ply)

	if not ply.inv and ply.loadedInv then
		ply:ImportInventory(octoinv.defaultInventory)
	end

end)

hook.Add('PlayerFinishedLoading', 'octoinv', function(ply)

	ply:SyncOctoinv()
	ply:LoadInventory()

end)

hook.Add('EntityRemoved', 'octoinv', function(ent)

	if ent.inv then
		ent.inv:Remove()
	end

end)
