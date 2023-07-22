AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

local bones = {
	['ValveBiped.Bip01_R_UpperArm'] = Angle(-28,18,-21),
	['ValveBiped.Bip01_L_Hand'] = Angle(0,0,119),
	['ValveBiped.Bip01_L_Forearm'] = Angle(15,20,40),
	['ValveBiped.Bip01_L_UpperArm'] = Angle(15, 26, 0),
	['ValveBiped.Bip01_R_Forearm'] = Angle(0,50,0),
	['ValveBiped.Bip01_R_Hand'] = Angle(45,34,-15),
	['ValveBiped.Bip01_L_Finger01'] = Angle(0,50,0),
	['ValveBiped.Bip01_R_Finger0'] = Angle(10,2,0),
	['ValveBiped.Bip01_R_Finger1'] = Angle(-10,0,0),
	['ValveBiped.Bip01_R_Finger11'] = Angle(0,-40,0),
	['ValveBiped.Bip01_R_Finger12'] = Angle(0,-30,0)
}
local cuffData = {
	norun = true,
}

function SWEP:SetupBones(ply, reset)
	if not IsValid(ply) then return end
	for k,v in pairs(bones) do
		local bone = ply:LookupBone(k)
		if bone then
			ply:ManipulateBoneAngles(bone, reset and Angle(0, 0, 0) or v)
		end
	end
end

function SWEP:Holster()
	self:SetHoldType(self.HoldType)
	return false
end

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)
	return true
end

-- function SWEP:Think()
-- 	if self:GetHoldType(self.HoldType) then
-- 		self:SetHoldType(self.HoldType)
-- 		self:SetupBones(newOwner)
-- 	end
-- end

function SWEP:Equip(newOwner)
	newOwner:DropObject()
	-- self:SetupBones(newOwner, true)
	newOwner:SelectWeapon(self:GetClass())
	self:SetupBones(newOwner)
	newOwner:MoveModifier('cuffed', cuffData)
	return true
end

function SWEP:OnRemove()
	if IsValid(self.Owner) then
		self:SetupBones(self.Owner, true)
		self.Owner:MoveModifier('cuffed')
		if IsValid(self.Owner:GetNetVar('dragger')) then
			self.Owner:SetNetVar('dragging')
		end
		self.Owner:SetNetVar('dragger')
	end
end

function SWEP:Uncuff()
	local ply = IsValid(self.Owner) and self.Owner
	self:Remove()
	if ply then ply:ConCommand('lastinv') end
end

function SWEP:Breakout()

	if IsValid(self.Owner) then
		self.Owner:EmitSound('physics/metal/metal_barrel_impact_soft4.wav')
		hook.Call('OnHandcuffBreak', GAMEMODE, self.Owner, self, self.friendBreaking)
	end

	self:Uncuff()
end

function SWEP:Gag(val)
	if self.CanGag then self:SetNetVar('gag', val == true or nil) end
end

function SWEP:Blind(val)
	if self.CanBlind then self:SetNetVar('blind', val == true or nil) end
end

hook.Add('PlayerSwitchWeapon', 'dbg-cuffs', function(ply, old, new)
	if new:GetClass() ~= 'weapon_cuffed' and ply:HasWeapon('weapon_cuffed') then
		return false
	end
end)