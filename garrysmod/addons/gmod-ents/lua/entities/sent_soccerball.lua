AddCSLuaFile()

ENT.Type = 'anim'
ENT.Base = 'base_anim'
ENT.PrintName = L.soccerball
ENT.Category = L.dobrograd
ENT.Author = 'Jvs'
ENT.Spawnable = true
ENT.AdminOnly = false

if CLIENT then
	ENT.HitMaterial = Material(util.DecalMaterial('impact.concrete'))
	ENT.RenderGroup = RENDERGROUP_BOTH
else
	ENT.CanPickupSoccerball = CreateConVar(
		'sv_pickupsoccerball' ,
		'1',
		{
			FCVAR_SERVER_CAN_EXECUTE,
			FCVAR_ARCHIVE
		},
		'When true, it allows anyone to pickup the soccerball'
	)
end

function ENT:SpawnFunction(ply , tr , classname)
	if not tr.Hit then
		return
	end

	local spawnpos = tr.HitPos + tr.HitNormal * 25

	local ent = ents.Create(classname)
	ent:SetPos(spawnpos)
	ent:Spawn()
	return ent
end

function ENT:SetupDataTables()
	self:NetworkVar('Float' , 0 , 'LastImpact')	--I made this into a dtvar because at some point I'll add some clientside animations for when the ball bounces
	self:NetworkVar('Float' , 1 , 'PressureExpireStart')
	self:NetworkVar('Float' , 2 , 'PressureExpireEnd')
end

function ENT:Initialize()
	if SERVER then
		self:SetMaxHealth(50)
		self:SetHealth(50)
		self:SetLagCompensated(true)	--players can shoot at us even with their shitty ping!
		self:SetUseType(SIMPLE_USE)	--don't let players spam +use on us, that's rude
		self:SetModel('models/props_phx/misc/soccerball.mdl')
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		self:ResetPressure()
		self:SetTrigger(true)	--allow us to use touch,starttouch and whatever even if we can't collide with the player

		local physobj =  self:GetPhysicsObject()

		if IsValid(physobj) then
			physobj:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			physobj:AddGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)
			physobj:SetBuoyancyRatio(0.5)
			physobj:SetDamping(0.25 , 1)
			physobj:Wake()
		end

		self:StartMotionController()
	end

	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
end

--[[
	I wanted to have this complicated system where the soccerball would lose pressure every frame but first off,
	that's annoying to code for little to no benefit, and second, I can fake it off by just using a timed variable
	that gets decreased everytime
]]

function ENT:GetPressure()
	local pressure = math.Clamp(math.TimeFraction(self:GetPressureExpireEnd() , self:GetPressureExpireStart() , CurTime()) , 0 , 1)

	return pressure
end

function ENT:ResetPressure()
	self:SetPressureExpireStart(0)
	self:SetPressureExpireEnd(0)
end

function ENT:IsLosingPressure()
	return self:GetPressureExpireStart() ~= 0 and self:GetPressureExpireEnd() ~= 0
end

function ENT:OnRemove()
	if CLIENT then
		if self.PressureLeakSound then
			self.PressureLeakSound:Stop()
			self.PressureLeakSound = nil
		end
	end
end

if SERVER then
	function ENT:PhysicsSimulate(physobj , delta)
		return SIM_NOTHING
	end

	function ENT:OnTakeDamage(dmginfo)
		if self:IsEFlagSet(EFL_KILLME) then
			return
		end

		self:TakePhysicsDamage(dmginfo)

		local dmg = dmginfo:GetDamage()

		local healthtoset = math.Clamp(self:Health() - dmg , 0 , self:GetMaxHealth())

		self:SetHealth(healthtoset)

		local isoverkill = (dmg >= (self:GetMaxHealth() / 2)) or (healthtoset <= 0)


		--either overkill
		if (isoverkill and not dmginfo:IsDamageType(DMG_BULLET)) or isoverkill then

			local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetScale(self:GetPressure())
			util.Effect('soccerball_explode', effectdata)

			self:Remove()
		end

		--we haven't been killed yet, start to lose pressure if the damage was coming from a bullet
		if not self:IsEFlagSet(EFL_KILLME) and dmginfo:IsDamageType(DMG_BULLET) then
			if not self:IsLosingPressure() then
				self:SetPressureExpireStart(CurTime())
				self:SetPressureExpireEnd(CurTime() + 5)
			else
				--decrease it a bit for every shot
				self:SetPressureExpireEnd(self:GetPressureExpireEnd() - 0.5)
			end
		end
	end

	function ENT:Use(ply)
		if self:GetVelocity():Length2DSqr() > 100 or not ply.inv or not ply.inv.conts._hand then
			ply:Notify('warning', L.take_soccerball)
			return
		end

		local i = ply.inv.conts._hand:AddItem('soccer')
		if i and i ~= 0 then self:Remove() end
	end

	function ENT:PhysicsCollide(data, physobj)
		if self:GetLastImpact() < CurTime() and data.DeltaTime > 0.2 and data.OurOldVelocity:Length() > 100 then
			self:EmitSound('Rubber.ImpactHard')
			self:SetLastImpact(CurTime() + 0.1)
		end
	end

	function ENT:PhysicsUpdate(physobj)
		physobj:SetMass(10)
		physobj:SetBuoyancyRatio(0.5 * self:GetPressure())
		physobj:SetDamping(0.25 , 1)
	end

	--touch is not called when the physics object hits an entity, but rather when the collision bounds do, which
	--is done with traces on the game side
	function ENT:StartTouch(ent)
		if not SERVER or not IsValid(ent) or self:IsPlayerHolding() then
			return
		end

		--ignore players that might be noclipping or in a vehicle
		if ent:IsPlayer() and ent:GetMoveType() ~= MOVETYPE_WALK then
			return
		end

		local tr = self:GetTouchTrace()
		local kickmultiplier = 1.5 + 1 * self:GetPressure()
		local massmultiplier = 15
		local direction = tr.Normal

		local normal = (ent:WorldSpaceCenter() - self:GetPos()):GetNormal() * -1
		local physobj = self:GetPhysicsObject()
		local ourvel = self:GetVelocity()
		local theirvel = ent:GetVelocity()


		if IsValid(physobj) and (ent:IsPlayer() or ent:IsNPC()) then

			local aimvec = ent:EyeAngles()
			aimvec.p = 0
			aimvec = aimvec:Forward()
			aimvec.z = 0

			if aimvec:Dot(theirvel:GetNormal()) < 0 then
				theirvel = vector_origin
				theirvel = normal * physobj:GetMass() * massmultiplier
			end
			--kick the ball!
			if theirvel ~= vector_origin then
				self:EmitSound('Rubber.BulletImpact')
				physobj:SetVelocityInstantaneous(theirvel * kickmultiplier + Vector(0, 0 , physobj:GetMass() * massmultiplier) )
				self:SetLastImpact(CurTime() + 0.1)
			else --bounce the ball back
				self:EmitSound('Rubber.ImpactHard')
				physobj:SetVelocityInstantaneous(-1 * normal * ourvel:Dot(normal))
			end
			self:SetLastImpact(CurTime() + 0.1) --we just kicked the ball, suppress the bounce sound for a little while
		end
	end

else

	function ENT:Think()
		self:HandleSound()
	end

	function ENT:HandleSound()
		if not self.PressureLeakSound then
			self.PressureLeakSound = CreateSound(self , 'PhysicsCannister.ThrusterLoop')
		end

		if self:IsLosingPressure() and self:GetPressure() ~= 0 then
			self.PressureLeakSound:Play()
			self.PressureLeakSound:ChangeVolume(self:GetPressure())
		else
			self.PressureLeakSound:Stop()
		end
	end

	function ENT:Draw(flags)
		self:DrawModel()
	end

	function ENT:DrawTranslucent()
	end


end
