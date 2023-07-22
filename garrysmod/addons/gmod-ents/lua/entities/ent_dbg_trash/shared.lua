ENT.Type 		= 'anim'
ENT.Base 		= 'octoinv_cont'
ENT.PrintName	= L.trash
ENT.Category	= L.dobrograd
ENT.Author		= 'chelog'
ENT.Contact		= 'chelog@octothorp.team'

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Model				= 'models/props_junk/trashdumpster01a.mdl'
ENT.Physics				= false

ENT.TrashData = {
	['models/highrise/trash_can_03.mdl'] = { Vector(14, 0, 15), Angle(0, 90, 90) },
	['models/highrise/trashcanashtray_01.mdl'] = { Vector(15.75, -10, 10), Angle(0, 90, 90) },
	['models/props_generic/trashbin002.mdl'] = { Vector(12, 0, 16), Angle(0, 90, 90) },
	['models/props_interiors/trashcan01.mdl'] = { Vector(12, 0, 36), Angle(0, 90, 90) },
	['models/props_interiors/trashcankitchen01.mdl'] = { Vector(10.5, 0, 25.5), Angle(0, 90, 90) },
	['models/props_junk/trashbin01a.mdl'] = { Vector(12.5, 0, 13.5), Angle(0, 90, 90) },
	['models/props_junk/trashdumpster01a.mdl'] = { Vector(20, 0, 10), Angle(0, 90, 90) },
	['models/props_trainstation/trashcan_indoor001a.mdl'] = { Vector(13, 0, 18), Angle(0, 90, 90) },
	['models/props_trainstation/trashcan_indoor001b.mdl'] = { Vector(13, 0, 18), Angle(0, 90, 90) },
	['models/props/cs_office/trash_can.mdl'] = { Vector(0, -7.75, 19), Angle(0, 0, 90) },
	['models/props/cs_office/trash_can_p.mdl'] = { Vector(0, -7.75, 19), Angle(0, 0, 90) },
}
ENT.models = {}
local i = 1
for k in pairs(ENT.TrashData) do
	ENT.models[#ENT.models + 1] = {
		name = string.StripExtension(string.GetFileFromFilename(k)),
		model = k,
		previewOffset = Vector(0, 0, 25),
	}
	i = i + 1
end

duplicator.RegisterEntityClass('ent_dbg_trash', function(ply, data)
	local ent = duplicator.GenericDuplicatorFunction(ply, data)
	ent:SetModel(ent.Model)
	ent:PhysicsInit(SOLID_VPHYSICS)
	ent:SetMoveType(MOVETYPE_VPHYSICS)
	ent:SetSolid(SOLID_VPHYSICS)
	local physObj = ent:GetPhysicsObject()
	if IsValid(physObj) then physObj:EnableMotion(false) end

	if IsValid(ply) then
		undo.Create('ent_dbg_trash')
		undo.AddEntity(ent)
		undo.SetPlayer(ply)
		undo.Finish()
		ply:AddCount('ent_dbg_trash', ent)
		ply:AddCleanup('ent_dbg_trash', ent)
	end

	return ent
end, 'Data', 'Model')
