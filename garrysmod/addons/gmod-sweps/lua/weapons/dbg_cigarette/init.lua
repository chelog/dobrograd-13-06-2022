AddCSLuaFile 'shared.lua'
AddCSLuaFile 'cl_init.lua'
include 'shared.lua'

-------------------------------------------------
-- MAIN
-------------------------------------------------

function SWEP:Holster()

	self.Owner:SetNetVar('IsSmoking', false)
	return true

end

function SWEP:OnRemove()

	self.Owner:SetNetVar('IsSmoking', false)

end

function SWEP:PrimaryAttack()

	-- do nothing

end

function SWEP:SecondaryAttack()

	self:DropCigarette()
	self:SetNextSecondaryFire(CurTime() + 1)

end

function SWEP:DropCigarette()

	local ply = self.Owner
	if not IsValid(ply) then return end

	local e = ents.Create 'prop_physics'
	e:SetPos(ply:GetShootPos())
	e:SetModel('models/phycigold.mdl')
	e:SetAngles(ply:EyeAngles())
	e:Spawn()
	e:Activate()
	e:SetCollisionGroup(COLLISION_GROUP_WORLD)
	local phys = e:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:AddVelocity(ply:GetAimVector() * 300)
	end

	timer.Simple(20, function()
		if IsValid(e) then e:Remove() end
	end)

	self.Owner:SetNetVar('IsSmoking', false)
	self:Remove()

	local curWep = ply:GetActiveWeapon()
	if curWep == self then
		ply:ConCommand('lastinv')

		if not IsValid(curWep) and ply:HasWeapon('dbg_hands') then
			ply:SelectWeapon('dbg_hands')
		end
	end

end

function SWEP:Reload()

	-- do nothing

end

util.AddNetworkString 'dbg.cigarette.exhale'
function SWEP:Think()

	if not IsValid(self.Owner) then return end
	if self.Owner:KeyPressed(IN_ATTACK) then
		self:SetHoldType('slam')
		self.Owner:SetNetVar('IsSmoking', true)
		self.inhaleTime = CurTime() + 0.5
	elseif self.Owner:KeyReleased(IN_ATTACK) then
		self:SetHoldType('normal')
		self.Owner:SetNetVar('IsSmoking', false)

		local amount = math.min(math.floor((CurTime() - (self.inhaleTime or 0)) * 4), 15)
		if amount > 0 then
			net.Start('dbg.cigarette.exhale')
				net.WriteEntity(self.Owner)
				net.WriteUInt(amount, 8)
			net.SendPVS(self.Owner:GetPos())

			self.dieTime = self.dieTime - amount * 6
		end
	end

end

timer.Create('dbg.cigarette.think', 2, 0, function()

	octolib.func.throttle(player.GetAll(), 10, 0.1, function(ply)
		if not IsValid(ply) then return end
		local c = ply:GetWeapon('dbg_cigarette')
		if IsValid(c) and not ply:GetNetVar('IsSmoking') and CurTime() > c.dieTime then
			c:DropCigarette()
		end
	end)

end)
