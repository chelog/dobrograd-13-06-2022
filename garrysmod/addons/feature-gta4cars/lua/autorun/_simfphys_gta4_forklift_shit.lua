function REN.GTA4Forklift(self)
	local skin = self:GetSkin()
	local prxyClr
		if (self.GetProxyColors) then
			prxyClr = self:GetProxyColors()
		end

	self.extramdl = ents.Create('prop_physics' )
	self.extramdl:SetModel('models/octoteam/vehicles/forklift_fork.mdl' )

	self.extramdl:SetSkin(skin )
	self.extramdl:SetPos(self:GetPos() )
	self.extramdl:SetAngles(self:GetAngles() )
	self.extramdl.DoNotDuplicate = true
	self.extramdl:Spawn()

	self.extraweld = constraint.Weld(self.extramdl, self, 0, 0, 5000, 1, 1)

	self:CallOnRemove('RemoveBed',function(self)
	if self.destroyed then
		self.extragib = ents.Create('gmod_sent_vehicle_fphysics_gib' )
		self.extragib:SetModel('models/octoteam/vehicles/forklift_fork.mdl' )

		self.extragib:SetSkin(skin )
		self.extragib.DoNotDuplicate = true
		self.extragib:SetPos(self:GetPos() )
		self.extragib:SetAngles(self:GetAngles() )

		self.Gib.extragib = self.extragib

		self.extragib:Spawn()

		self.Gib:CallOnRemove('RemoveForkGib',function(self)
			self.extragib:Remove()
		end)
	end
	end)
end

local function TankerDamage(ent, DmgPos, Damage)
    for k, v in pairs(ent.NAKTankerHB ) do
        if DmgPos:WithinAABox(v.OBBMin, v.OBBMax) then
			ent:TakeDamage(Damage*10)
			if vFireInstalled then
				CreateVFire(ent, ent:LocalToWorld(DmgPos), DmgPos:GetNormalized(), 15)
			end
		end
	end
end

function REN.ForkliftHitbox(self )
	--Bullet Damage
    self.NAKOnTakeDamage = self.OnTakeDamage
    self.OnTakeDamage = function(self, dmginfo)
        local Damage = dmginfo:GetDamage()
        local DamagePos = self:WorldToLocal(dmginfo:GetDamagePosition())
        local Explosion = dmginfo:IsExplosionDamage()
        TankerDamage(self, DamagePos, Damage)
        self:NAKOnTakeDamage(dmginfo)
    end
	--Physics Damage
    self.NAKHBPhysicsCollide = self.PhysicsCollide
    self.PhysicsCollide = function(self, data, physobj)
        if (not data.HitEntity:IsNPC()) and (not data.HitEntity:IsNextBot()) and
            (not data.HitEntity:IsPlayer()) then
            if (data.DeltaTime > 0.2) then
				local spd = data.Speed + data.OurOldVelocity:Length() + data.TheirOldVelocity:Length()
				local dmgmult = math.Round(spd / 20, 0)
				local damagePos = self:WorldToLocal(data.HitPos)
                TankerDamage(self, damagePos, dmgmult)
            end
        end
        self:NAKHBPhysicsCollide(data, physobj)
    end

	--//need to code a timer or something that slowly lets out fuel, and base how much fuel is left on the explosion size!
	self.OnDestroyed = function(self)
		if !self.destroyed then return end
		if vFireInstalled then
			CreateVFireBall(50, 100, self:GetPos()+Vector(0,0,200), Vector(0, 100, 25), nil)
			CreateVFireBall(50, 100, self:GetPos()+Vector(0,0,200), Vector(0, -100,25), nil)
			CreateVFireBall(50, 100, self:GetPos()+Vector(0,0,200), Vector(100, 0, 25), nil)
			CreateVFireBall(50, 100, self:GetPos()+Vector(0,0,200), Vector(-100, 0,25), nil)
		end
	end
end