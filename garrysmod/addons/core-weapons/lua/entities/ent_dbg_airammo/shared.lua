ENT.Type 		= "anim"
ENT.Base 		= "base_gmodentity"
ENT.PrintName	= 'Пули для страйкбола'
ENT.Category	= L.dobrograd
ENT.Author		= "Wani4ka"
ENT.Contact		= "4wk@wani4ka.ru"

if SERVER then
	AddCSLuaFile()
end

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:Initialize()
	if SERVER then
		self:SetModel('models/items/ammocrate_smg1.mdl')
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
	end
end

function ENT:Use(ply)

	if not ply:IsPlayer() then return end
	local wep = ply:GetActiveWeapon()
	if not wep.Primary or wep.Primary.Ammo ~= 'air' then
		return ply:Notify('warning', 'Эти пульки подходят только для страйкбольного оружия')
	end
	if wep:Ammo1() >= 100 then
		return ply:Notify('warning', 'У тебя уже полный запас пулек')
	end

	ply:GiveAmmo(100 - wep:Ammo1(), 'air')
	wep:DefaultReload(ACT_VM_RELOAD)

	self:SetSequence(2) -- Open
	timer.Create('airammo.close' .. self:EntIndex(), 1, 1, function()
		if IsValid(self) then self:SetSequence(1) end -- Close
	end)

end
