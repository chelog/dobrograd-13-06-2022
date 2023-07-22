do return end -- BROKEN PIECE OF SHIT! :argh: GARRRRRYYYYYYYYYYYYYY!!!!!!!!!!!!
function CatmullRomCams.SV.Save(save_data)
	if not CatmullRomCams.Tracks[player.GetByID(1):UniqueID()] then return end
	
	local SaveGameData = {} -- I'm assuming here that you can only save games in singleplayer. Tell me if I'm wrong though! :V
	
	for numpad_key, track in pairs(CatmullRomCams.Tracks[player.GetByID(1):UniqueID()]) do
		SaveGameData[numpad_key] = 1--{}
		if false then
		for index, node in ipairs(track) do
			SaveGameData[numpad_key][index] = {Ent = node:EntIndex(), Data = node:RequestSaveData(true)}
		end
		end
	end
	
	return saverestore.WriteTable(SaveGameData, save_data)
end

function CatmullRomCams.SV.Restore(restore_data)
	local SavedGameData = saverestore.ReadTable(restore_data)
	local plyID = player.GetByID(1):UniqueID()
	PrintTable(SavedGameData)
	
	for numpad_key, track in pairs(SavedGameData) do
		if false then
			CatmullRomCams.Tracks[plyID][numpad_key] = {}
			
			for index, data in ipairs(track) do
				CatmullRomCams.Tracks[plyID][numpad_key][index] = ents.GetByIndex(node.Ent)
				CatmullRomCams.Tracks[plyID][numpad_key][index]:ApplyEngineSaveData(node.Data, index == 1)
				
				print("Loaded ", CatmullRomCams.Tracks[plyID][numpad_key][index], "'s saverestore data.\nDumping:")
				PrintTable(node.Data)
			end
		end
	end
end

saverestore.AddSaveHook(   "CatmullRomCams_SaveRestore", CatmullRomCams.SV.Save)
saverestore.AddRestoreHook("CatmullRomCams_SaveRestore", CatmullRomCams.SV.Restore)
