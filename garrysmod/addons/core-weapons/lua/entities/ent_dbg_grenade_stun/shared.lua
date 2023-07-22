ENT.Base 		= 'ent_dbg_throwable'
ENT.PrintName	= 'Светошумовая'
ENT.Category	= 'Гранаты'
ENT.Spawnable	= true
ENT.AdminSpawnable = true
ENT.Author		= 'Wani4ka'
ENT.Contact		= '4wk@wani4ka.ru'

if SERVER then
	AddCSLuaFile()
end

ENT.Model				= 'models/csgo/weapons/w_eq_flashbang.mdl'
ENT.LifeTime = 1
ENT.SoundExplode = {'weapons/flashbang/flashbang_explode2.wav', 100, 100, 1}
ENT.SoundHit	  = {'weapons/smokegrenade/grenade_hit1.wav'}
