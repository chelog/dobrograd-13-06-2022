AddCSLuaFile "shared.lua"
AddCSLuaFile "cl_init.lua"
include "shared.lua"

local throwSound = Sound( "WeaponFrag.Throw" )

function SWEP:Deploy()

	self:UpdateHoldType('default')

end

function SWEP:UpdateHoldType(mode)

	local ht = self.HoldType
	if mode == 'default' then
		local owner = self:GetOwner()
		if IsValid(owner) and owner:InVehicle() then
			ht = 'physgun'
		end
	elseif mode == 'swing1' then
		ht = 'melee2'
	elseif mode == 'swing2' then
		ht = 'grenade'
	end

	self:SetHoldType(ht)

end

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire(CurTime() + 1)
	local owner = self:GetOwner()
	if not IsValid(owner) then return end
	if IsValid(self.hook) then return end
	if not self.bait then
		owner:Notify('Рыба не будет ловиться без приманки')
		return
	end
	if (self.usesLeft or 0) <= 0 then
		owner:Notify('warning', 'Леска закончилась')
		return
	end

	self:UpdateHoldType('swing1')
	owner:Freeze(true)
	timer.Simple(0.1, function() self.Owner:SetAnimation(PLAYER_ATTACK1) end)

	timer.Simple(0.2, function()
		owner:EmitSound(throwSound)
		local h = ents.Create('ent_dbg_fish_float')
		h.rod = self
		h.owner = owner

		local pos = owner:EyePos()
		local dir = (owner:GetEyeTrace().HitPos - pos):GetNormalized()
		h:SetPos(Vector(pos.x + dir.x * 100, pos.y + dir.y * 100, pos.z))
		h:SetAngles(owner:GetAngles())
		h:Spawn()
		self.hook = h
		self:SetNetVar('hook', self.hook:EntIndex())

		local phys = h:GetPhysicsObject()
		if IsValid(phys) then
			local vel = owner:GetForward() * 1500
			vel.z = dir.z * 1000
			phys:SetMass(1)
			phys:SetVelocity(vel)
			phys:Wake()
		end
	end)

	timer.Simple(0.4, function()
		self:UpdateHoldType('default')
		owner:Freeze(false)
		owner.fishing = true
	end)

end

function SWEP:SecondaryAttack()

	self:SetNextSecondaryFire(CurTime() + 1)

	self:UpdateHoldType('swing2')
	timer.Simple(0.25, function()
		self:UpdateHoldType('default')
		if IsValid(self.hook) then
			if self.hook:GetNetVar('baiting') then
				local item = fishing.getLoot(self:GetOwner(), self)
				if item then
					local take = 1
					if not item[1]:find('ing_fish') then
						take = (self.thin and 2 or 1) * 2
					end
					self.bait = nil
					self.usesLeft = (self.usesLeft or take) - take
					self:GetOwner():AddItem(unpack(item))
					self:GetOwner():Notify(('Ты поймал предмет: %s'):format(octoinv.itemStr(item)))
				end
				self.hook:SetNetVar('baiting', nil)
			end
			self.hook:Remove()
			self.hook = nil
		end
	end)

	return true

end

function SWEP:Reload()
	if not IsValid(self.hook) and self.bait then
		self.bait = nil
		self:GetOwner():DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
	end
end

function SWEP:Holster()
	if IsValid(self.hook) then
		self:GetOwner():SetNetVar('baiting', nil)
		self.hook:Remove()
		self.hook = nil
	end

	return true
end

local function updateHoldType(ply)
	timer.Simple(0, function()
		if not IsValid(ply) then return end
		local wep = ply:GetActiveWeapon()
		if IsValid(wep) and wep:GetClass() == 'weapon_octo_fishing_rod' then
			wep:UpdateHoldType('default')
		end
	end)
end
hook.Add('PlayerEnteredVehicle', 'dbg-fishing', updateHoldType)
hook.Add('PlayerLeaveVehicle', 'dbg-fishing', updateHoldType)
