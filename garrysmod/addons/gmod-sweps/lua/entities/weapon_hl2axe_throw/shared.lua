ENT.Type 			= "anim"
ENT.PrintName		= "Axe"
ENT.Author			= "Worshipper, well, sort of. most of it is his anyway"
ENT.Contact			= "Josephcadieux@hotmail.com"
ENT.Purpose			= ""
ENT.Instructions		= ""

if SERVER then

AddCSLuaFile("shared.lua")

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()

	self:SetModel("models/weapons/HL2meleepack/w_axe.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	self.NextThink = CurTime() +  1

	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(10)
	end

	util.PrecacheSound("physics/metal/metal_grenade_impact_hard3.wav")
	util.PrecacheSound("physics/metal/metal_grenade_impact_hard2.wav")
	util.PrecacheSound("physics/metal/metal_grenade_impact_hard1.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet1.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet2.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet3.wav")

	self.Hit = {
	Sound("physics/metal/metal_grenade_impact_hard1.wav"),
	Sound("physics/metal/metal_grenade_impact_hard2.wav"),
	Sound("physics/metal/metal_grenade_impact_hard3.wav")};

	self.FleshHit = {
	Sound("physics/flesh/flesh_impact_bullet1.wav"),
	Sound("physics/flesh/flesh_impact_bullet2.wav"),
	Sound("physics/flesh/flesh_impact_bullet3.wav")}

	self:GetPhysicsObject():SetMass(2)

	self.Entity:SetUseType(SIMPLE_USE)
end

/*---------------------------------------------------------
   Name: ENT:Disable()
---------------------------------------------------------*/
function ENT:Disable()

	self.PhysicsCollide = function() end

	timer.Simple(0, function()
		self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self.Entity:SetOwner(NULL)
	end)

end

/*---------------------------------------------------------
   Name: ENT:PhysicsCollided()
---------------------------------------------------------*/
function ENT:PhysicsCollide(data, phys)

	local Ent = data.HitEntity
	local stuck = math.random(4) ~= 1
	-- if !IsValid( Ent ) then return end

	local health = Ent:Health()
	if health ~= 0 and health < 80 then stuck = false end
	Ent:TakeDamage(80, self:GetOwner(), self.Entity)

	if (Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll") then

		-- if not(Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll") then
		-- 	util.Decal("ManhackCut", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
		-- 	self:EmitSound(self.Hit[math.random(1, #self.Hit)])
		-- 	self:Disable()
		-- end

		-- if (Ent:IsPlayer() or Ent:IsNPC() or Ent:GetClass() == "prop_ragdoll") then
			local effectdata = EffectData()
			effectdata:SetStart(data.HitPos)
			effectdata:SetOrigin(data.HitPos)
			effectdata:SetScale(1)
			util.Effect("BloodImpact", effectdata)

			self:EmitSound(self.FleshHit[math.random(1,#self.FleshHit)])
			self:Disable()
			self.Entity:GetPhysicsObject():SetVelocity(data.OurOldVelocity / 4)

		-- end

	else

		-- util.Decal("ManhackCut", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)

		local yaw = data.OurOldVelocity:Angle().y
		self:EmitSound( stuck and "Canister.ImpactHard" or table.Random(self.Hit) )
		if stuck then
			self:SetPos(data.HitPos - data.HitNormal * 12)
			self:SetAngles(data.HitNormal:Angle() + Angle(135, math.abs(data.HitNormal.z) == 1 and yaw or 0, -90))
		end


		if Ent:IsWorld() then
			if stuck then self:GetPhysicsObject():EnableMotion(false) end
		elseif stuck then
			self:SetParent( Ent )
			self.Entity:GetPhysicsObject():SetVelocity(data.OurOldVelocity)
		end

		self:Disable()


	end

end

/*---------------------------------------------------------
   FROM octoinv_item
---------------------------------------------------------*/

function ENT:SetData(item, data)

	self:SetNetVar('Item', { item, data })
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		local amount = istable(data) and data.amount or isnumber(data) and data or 1
		local mass = istable(data) and data.mass or octoinv.items[item].mass or 0

		self.baseMass = self.baseMass or phys:GetMass()
		phys:SetMass(self.baseMass + mass * amount)
	end

end

function ENT:Use(ply)

	if not ply:Alive() or ply:IsGhost() then return end

	local cont = ply:GetInventory():GetContainer('_hand')
	if not cont then
		ply:Notify('warning', L.onlyhandsitem2)
		return
	end

	local itemData = self:GetNetVar('Item')
	if not itemData then return end

	local added, item = cont:AddItem(itemData[1], itemData[2])
	if added < 1 then
		ply:Notify('warning', L.inhandsnospace)
		return
	end

	if istable(itemData[2]) then
		itemData[2].amount = itemData[2].amount and (itemData[2].amount - added) or 0
		self:SetNetVar('Item', { itemData[1], itemData[2] })
		if itemData[2].amount < 1 then self:Remove() end
	elseif isnumber(itemData[2]) then
		itemData[2] = itemData[2] - added
		self:SetNetVar('Item', { itemData[1], itemData[2] })
		if itemData[2] < 1 then self:Remove() end
	end
	ply:DoAnimation(ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND)

	hook.Run('octoinv.pickup', ply, self, item, added)

end

end

if CLIENT then
/*---------------------------------------------------------
   Name: ENT:Draw()
---------------------------------------------------------*/
function ENT:Draw()
	self.Entity:DrawModel()
end
end
