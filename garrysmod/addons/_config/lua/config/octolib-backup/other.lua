octolib.registerBackupClass('octoinv_item',
	function(ent)
		return { i = ent:GetNetVar('Item'), m = ent:GetModel() }
	end,
	function(ent, ply, data)
		ent:SetData(data.i[1], data.i[2])
	end
)

octolib.registerBackupClass('octoinv_storage',
	function(ent)
		return { i = ent:ExportInventory() }
	end,
	function(ent, ply, data)
		ent.steamID = ply:SteamID()
		timer.Simple(1, function()
			if data.i then ent:ImportInventory(data.i) end
			ent:Save()
			timer.Simple(1, function() ent:Remove() end)
			-- we create the entity in first place to save inventory with removing it
		end)
	end
)

octolib.registerBackupClass('octoinv_cont',
	function(ent)
		return { m = ent:GetModel(), i = ent:ExportInventory(), d = ent.DestructParts }
	end,
	function(ent, ply, data)
		ent.Model = data.m
		ent:SetPlayer(ply)
		timer.Simple(1, function()
			if data.i then ent:ImportInventory(data.i) end
			if data.d then ent.DestructParts = data.d end
			ent:SetLocked(true)
		end)
	end
)

octolib.registerBackupClass('octoinv_prod',
	function(ent)
		return { m = ent:GetModel(), i = ent:ExportInventory(), d = ent.DestructParts, pr = ent.prodClass }
	end,
	function(ent, ply, data)
		ent.Model = data.m
		ent:SetPlayer(ply)
		timer.Simple(1, function()
			if data.i then ent:ImportInventory(data.i) end
			if data.d then ent.DestructParts = data.d end
			if data.pr then ent:SetProdData(octoinv.prod[data.pr]) end
			ent.prodClass = data.pr
			ent:SetLocked(true)
		end)
	end
)

octolib.registerBackupClass('octoinv_vend',
	function(ent)
		return { m = ent:GetModel(), i = ent:ExportInventory(), d = ent.DestructParts }
	end,
	function(ent, ply, data)
		ent.Model = data.m
		ent:SetPlayer(ply)
		timer.Simple(1, function()
			if data.i then ent:ImportInventory(data.i) end
			if data.d then ent.DestructParts = data.d end
			ent:SetLocked(true)
		end)
	end
)