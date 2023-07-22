
--local Hackz = {}

function CatmullRomCams.SV.AdvDupPaste(self, Player, plyID, Ent, CreatedEntities)
	Ent.EntityMods.CatmullRomCamsDupData.UndoData.PID = plyID
	
	self:ApplySaveData(Player, plyID, CreatedEntities, Ent.EntityMods.CatmullRomCamsDupData)
	
	return Player:AddCleanup("catmullrom_cameras", Ent)
end
