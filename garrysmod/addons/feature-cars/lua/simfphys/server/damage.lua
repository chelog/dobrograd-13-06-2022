util.AddNetworkString('simfphys_spritedamage')
util.AddNetworkString('simfphys_lightsfixall')
util.AddNetworkString('simfphys_backfire')

local function Spark(pos , normal , snd)
	local effectdata = EffectData()
	effectdata:SetOrigin(pos - normal)
	effectdata:SetNormal(-normal)
	util.Effect('stunstickimpact', effectdata, true, true)

	if snd then
		sound.Play(Sound(snd), pos, 75)
	end
end

local function DestroyVehicle(ent)
	if not IsValid(ent) then return end
	if ent.destroyed then return end

	ent:OnDestroyed()

	ent.destroyed = true

	local ply = ent.EntityOwner
	local skin = ent:GetSkin()
	local Col = ent:GetColor()
	Col.r = Col.r * 0.8
	Col.g = Col.g * 0.8
	Col.b = Col.b * 0.8

	local bprop = ents.Create('gmod_sent_vehicle_fphysics_gib')
	bprop:SetModel(ent:GetModel())
	bprop:SetPos(ent:GetPos())
	bprop:SetAngles(ent:GetAngles())
	bprop:Spawn()
	bprop:Activate()
	bprop:GetPhysicsObject():SetVelocity(ent:GetVelocity() + Vector(math.random(-5,5),math.random(-5,5),math.random(150,250)))
	bprop:GetPhysicsObject():SetMass(ent.Mass * 0.75)
	bprop.DoNotDuplicate = true
	bprop.MakeSound = true
	bprop:SetColor(Col)
	bprop:SetSkin(skin)

	simfphys.SetOwner(ply , bprop)

	if IsValid(ply) then
		undo.Create('Gib')
		undo.SetPlayer(ply)
		undo.AddEntity(bprop)
		undo.SetCustomUndoText('Undone Gib')
		undo.Finish('Gib')
		ply:AddCleanup('Gibs', bprop)
	end

	if ent.CustomWheels == true and not ent.NoWheelGibs then
		for i = 1, table.Count(ent.GhostWheels) do
			local Wheel = ent.GhostWheels[i]
			if IsValid(Wheel) then
				local prop = ents.Create('gmod_sent_vehicle_fphysics_gib')
				prop:SetModel(Wheel:GetModel())
				prop:SetPos(Wheel:LocalToWorld(Vector(0,0,0)))
				prop:SetAngles(Wheel:LocalToWorldAngles(Angle(0,0,0)))
				prop:SetOwner(bprop)
				prop:Spawn()
				prop:Activate()
				prop:GetPhysicsObject():SetVelocity(ent:GetVelocity() + Vector(math.random(-5,5),math.random(-5,5),math.random(0,25)))
				prop:GetPhysicsObject():SetMass(20)
				prop.DoNotDuplicate = true
				bprop:DeleteOnRemove(prop)

				simfphys.SetOwner(ply , prop)
			end
		end
	end

	local Driver = ent:GetDriver()
	if IsValid(Driver) and ent.RemoteDriver ~= Driver then
		Driver:Kill()
	end

	if ent.PassengerSeats then
		for i = 1, table.Count(ent.PassengerSeats) do
			local Passenger = ent.pSeat[i]:GetDriver()
			if IsValid(Passenger) then
				Passenger:Kill()
			end
		end
	end

	ent:Extinguish()
	ent:Remove()
end

local function DamageVehicle(ent , damage, type, allowExplode)
	if not simfphys.DamageEnabled then return end

	local MaxHealth = ent:GetMaxHealth()
	local CurHealth = ent:GetCurHealth()

	local NewHealth = math.max(math.Round(CurHealth - damage, 0), allowedExplode and 0 or 10)
	ent:SetCurHealth(NewHealth)

	if NewHealth <= (MaxHealth * 0.5) then
		if NewHealth <= (MaxHealth * 0.175) then
			ent:SetOnFire(true)
			ent:SetOnSmoke(false)
		else
			ent:SetOnSmoke(true)
		end
	end

	if MaxHealth > 30 and NewHealth <= 30 and ent:EngineActive() then
		ent:DamagedStall()
	end

	if NewHealth <= 0 then
		if type ~= DMG_GENERIC and type ~= DMG_CRUSH or damage > 400 then
			hook.Run('VehicleDestroyed', ent)
			DestroyVehicle(ent)
			return
		end

		if ent:EngineActive() then
			ent:DamagedStall()
		end

		return
	end
end
simfphys.DamageVehicle = DamageVehicle

local function HurtPlayers(ent, damage)
	-- if not simfphys.pDamageEnabled then return end

	local Driver = ent:GetDriver()

	if IsValid(Driver) then
		Driver:TakeDamage(damage * (Driver:GetNetVar('belted') and 0.4 or 1), Entity(0), ent)
	end

	if ent.PassengerSeats then
		for i = 1, table.Count(ent.PassengerSeats) do
			local Passenger = ent.pSeat[i]:GetDriver()

			if IsValid(Passenger) then
				Passenger:TakeDamage(damage * (Passenger:GetNetVar('belted') and 0.4 or 1), Entity(0), ent)
			end
		end
	end
end

local function bcDamage(vehicle , position , cdamage)
	if not simfphys.DamageEnabled then return end

	cdamage = cdamage or false
	net.Start('simfphys_spritedamage')
		net.WriteEntity(vehicle)
		net.WriteVector(position)
		net.WriteBool(cdamage)
	net.Broadcast()
end

hook.Add('PhysgunDrop', 'dbg-cars.damage', function(ply, ent) ent.lastUnfreeze = CurTime() end)
hook.Add('PlayerSpawnedProp', 'dbg-cars.damage', function(ply, mdl, ent) ent.lastUnfreeze = CurTime() end)

local propClasses = octolib.array.toKeys({'prop_physics'})
local function onCollide(ent, data)
	if ent._nodmg then return end

	local ent2 = data.HitEntity
	if IsValid(ent2) then
		if ent2:GetClass():StartWith('npc_') then
			Spark(data.HitPos , data.HitNormal , 'MetalVehicle.ImpactSoft')
			return
		end

		if ent2.APG_Picked and propClasses[ent2:GetClass()] then
			ent2:Remove()
			return
		end
		if CurTime() - (ent2.lastUnfreeze or 0) < 5 then
			ent._nodmg = true
			timer.Simple(0.5, function()
				if IsValid(ent) then ent._nodmg = nil end
			end)

			return
		end
	end

	-- local vec
	-- if ent2 == Entity(0) or not data.HitObject:IsMotionEnabled() then
	-- 	vec = data.OurOldVelocity
	-- else
	-- 	vec = data.OurOldVelocity - data.TheirOldVelocity
	-- end

	-- local imp = vec:Length() * math.abs(vec:GetNormalized():Dot(data.HitNormal))
	-- local mass = data.HitObject:GetMass()
	-- if ent2 ~= Entity(0) and mass ~= 0 then
	-- 	imp = imp / math.max(500 / mass, 1)
	-- end

	local imp = data.OurNewVelocity:Distance(data.OurOldVelocity)
	if ent2:GetClass() == 'gmod_sent_vehicle_fphysics_base' then
		imp = imp / math.Clamp(data.OurOldVelocity:LengthSqr() / data.TheirOldVelocity:LengthSqr(), 0.7, 1)
	end

	local pos = data.HitPos
	local plyDmg, carDmg

	if imp > 1200 then
		Spark(pos , data.HitNormal , 'MetalVehicle.ImpactHard')
		bcDamage(ent , ent:WorldToLocal(pos) , true)
		plyDmg = imp * 0.07
		carDmg = imp * 0.75
	elseif imp > 800 then
		Spark(pos , data.HitNormal , 'MetalVehicle.ImpactHard')
		bcDamage(ent , ent:WorldToLocal(pos) , true)
		plyDmg = imp * 0.05
		carDmg = imp * 0.6
	elseif imp > 400 then
		bcDamage(ent , ent:WorldToLocal(pos) , true)
		plyDmg = imp * 0.04
		carDmg = imp * 0.45
	elseif imp > 200 then
		local hitent = ent2:IsPlayer()
		if not hitent then
			bcDamage(ent, ent:WorldToLocal(pos) , true)
			carDmg = imp * 0.25
		end
	end

	if plyDmg then HurtPlayers(ent, plyDmg) end
	if carDmg and imp > 400 then
		ent:TakeDamage(carDmg * simfphys.DamageMul, Entity(0), Entity(0))
		-- reduce chance to not stall as we approach imp = 1500
		local dontStallChance = octolib.math.remap(imp, 400, 1500, ent.police and 10 or 2, 0)
		if math.random(10) > dontStallChance then
			ent:DamagedStall()
		end
	end

	if ent2:IsPlayer() and imp > 100 then
		local ply = ent2
		local dmg = DamageInfo()
		dmg:SetDamage(math.Clamp(imp / 1.25, 0, ply:Health() - 10))
		dmg:SetAttacker(ent:GetDriver() or Entity(0))
		dmg:SetInflictor(ent)
		dmg:SetDamageType(DMG_VEHICLE)
		ply:TakeDamageInfo(dmg)
	end
end

local function OnDamage(ent, dmginfo)
	ent:TakePhysicsDamage(dmginfo)

	if not ent:IsInitialized() then return end

	local Damage = dmginfo:GetDamage()
	local DamagePos = dmginfo:GetDamagePosition()
	local Type = dmginfo:GetDamageType()
	local Driver = ent:GetDriver()
	bcDamage(ent , ent:WorldToLocal(DamagePos))

	local Mul = 1
	if Type == DMG_BLAST then
		Mul = 10
	end

	if Type == DMG_BULLET then
		Mul = 2
	end

	DamageVehicle(ent , Damage * Mul, Type)

	-- if ent.IsArmored then return end
	--
	-- if IsValid(Driver) then
	-- 	local Distance = (DamagePos - Driver:GetPos()):Length()
	-- 	if (Distance < 40) then
	-- 		local Damage = (40 - Distance) / 22
	-- 		dmginfo:ScaleDamage(Damage)
	-- 		Driver:TakeDamageInfo(dmginfo)
	-- 		BloodEffect(DamagePos)
	-- 	end
	-- end
	--
	-- if ent.PassengerSeats then
	-- 	for i = 1, table.Count(ent.PassengerSeats) do
	-- 		local Passenger = ent.pSeat[i]:GetDriver()
	--
	-- 		if IsValid(Passenger) then
	-- 			local Distance = (DamagePos - Passenger:GetPos()):Length()
	-- 			local Damage = (40 - Distance) / 22
	-- 			if (Distance < 40) then
	-- 				dmginfo:ScaleDamage(Damage)
	-- 				Passenger:TakeDamageInfo(dmginfo)
	-- 				BloodEffect(DamagePos)
	-- 			end
	-- 		end
	-- 	end
	-- end
end

hook.Add('OnEntityCreated', 'simfphys_damagestuff', function(ent)
	if simfphys.IsCar(ent) then
		timer.Simple(0.2, function()
			if not IsValid(ent) then return end

			local Health = math.floor(ent.MaxHealth and ent.MaxHealth or (1000 + ent:GetPhysicsObject():GetMass() / 3))

			ent:SetMaxHealth(Health)
			ent:SetCurHealth(Health)

			ent.PhysicsCollide = onCollide
			ent.OnTakeDamage = OnDamage
		end)
	end
end)
