ENT.Base 		= 'ent_dbg_throwable'
ENT.PrintName	= 'Метательное яблоко'
ENT.Category	= 'Гранаты'
ENT.Spawnable	= true
ENT.AdminSpawnable = true

if SERVER then
	AddCSLuaFile()
end

ENT.Model				= 'models/props_everything/applered.mdl'
ENT.LifeTime			= 15
