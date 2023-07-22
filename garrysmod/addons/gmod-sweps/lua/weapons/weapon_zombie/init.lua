AddCSLuaFile 'shared.lua'
include 'shared.lua'

hook.Add('canDropWeapon', 'dbg-zombie', function(ply, wep)

	if IsValid(wep) and wep:GetClass() == 'weapon_zombie' then
		return false
	end

end)

hook.Add('PlayerSwitchWeapon', 'dbg-zombie', function(ply, old, new)

	if IsValid(old) and old:GetClass() == 'weapon_zombie' then
		return true
	end

end)

hook.Add('onDarkRPWeaponDropped', 'dbg-zombie', function(ply, spW, orW)

	if IsValid(orW) and orW:GetClass() == 'weapon_zombie' then
		spW:Remove()
	end

end)

hook.Add('shouldViewPunchOnDamage', 'dbg-zombie', function(ply)

	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and wep:GetClass() == 'weapon_zombie' then
		return true
	end

end)

hook.Add('PlayerCanHearPlayersVoice', 'dbg-zombie', function(listener, talker)

	if talker:GetNetVar('zombie') and not listener:GetNetVar('zombie') then
		return false
	end

end)

hook.Add('PlayerCanSeePlayersChat', 'dbg-zombie', function(txt, t, listener, talker)

	if talker:GetNetVar('zombie') and not listener:GetNetVar('zombie') then
		return false
	end

end)

hook.Add('PlayerLoadout', 'dbg-zombie', function(ply)

	-- if ply.pendingZombie and not ply:IsGhost() then
	-- 	timer.Simple(3, function()
	-- 		ply:Give('weapon_zombie')
	-- 	end)
	-- 	return true
	-- end

	if not ply:HasWeapon('weapon_zombie') then
		if ply:GetNetVar('zombie') ~= nil then hook.Run('dbg-zombie.changed', ply, false) end
		ply:MoveModifier('zombie', nil)
		ply:SetNetVar('zombie', nil)
	end

end)

hook.Add('PlayerDeath', 'dbg-zombie', function(ply, inf, att)

	if att:IsPlayer() and att:HasWeapon('weapon_zombie') then
		ply.pendingZombie = true
	end

end)

hook.Add('hungerUpdate', 'dbg-zombie', function(ply)

	if ply:HasWeapon('weapon_zombie') then
		return true
	end

end)

function SWEP:Initialize()

	self:SetHoldType(self.HoldType)

	timer.Simple(0.5, function()
		local ply = self.Owner
		if not IsValid(ply) or not ply:HasWeapon('weapon_zombie') then return end
		for k, wep in pairs(ply:GetWeapons()) do
			local class = wep:GetClass()
			if class ~= 'weapon_zombie' then ply:StripWeapon(class) end
			ply:SelectWeapon('weapon_zombie')
		end
	end)

end

function SWEP:NormalSpeed()

	if IsValid(self.Owner) then
		if self.Owner:GetNetVar('zombie') ~= nil then hook.Run('dbg-zombie.changed', self.Owner, false) end
		self.Owner:MoveModifier('zombie', nil)
		self.Owner:SetNetVar('zombie', nil)
	end

end

function SWEP:CustomSpeed()

	if IsValid(self.Owner) then
		if self.Owner:GetNetVar('zombie') ~= true then hook.Run('dbg-zombie.changed', self.Owner, true) end
		self.Owner:SetNetVar('zombie', true)
		self.Owner:MoveModifier('zombie', {
			walkadd = -20,
			runadd = 30,
			jumpmul = 1.6,
		})
	end

end

function SWEP:Deploy()

	if IsValid(self.Owner) then
		self:CustomSpeed()
		self.Owner:SetModel('models/player/zombie_fast.mdl')
		self.Owner:SetHealth(game.GetMap():find('rp_eastcoast') and 2000 or 250)
	end
	return true

end

function SWEP:Holster()

	self:NormalSpeed()
	return true

end

function SWEP:Damage(ent, damage, pl)

	if ent:IsPlayer() and ent:HasWeapon('weapon_zombie') then return end

	if ent:IsDoor() then
		ent:DoUnlock()
		ent:Fire('Open')
		ent:EmitSound('physics/wood/wood_crate_impact_hard4.wav', 65)
	end

	ent:TakeDamage(damage, pl, self)
	if ent:GetClass() == 'func_breakable_surf' then
		ent:Fire('Shatter', Vector(0,0,0))
	end

end
