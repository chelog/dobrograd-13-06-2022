AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = L.stunstick
	SWEP.Slot = 3
	SWEP.SlotPos = 5
	SWEP.RenderGroup = RENDERGROUP_BOTH

	killicon.AddAlias("stunstick", "weapon_stunstick")
end

DEFINE_BASECLASS("stick_base")

SWEP.Instructions = L.instruction_stunstick

SWEP.Spawnable = true
SWEP.Category = "DarkRP (Utility)"
SWEP.WorldModel = 'models/drover/w_baton.mdl'
SWEP.Sound = Sound('weapons/knife/knife_slash1.wav')

-- SWEP.StickColor = Color(0, 0, 255)

function SWEP:Initialize()
	BaseClass.Initialize(self)
end

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)
	-- Float 0 = LastPrimaryAttack
	-- Float 1 = ReloadEndTime
	-- Float 2 = BurstTime
	-- Float 3 = LastNonBurst
	-- Float 4 = SeqIdleTime
	-- Float 5 = HoldTypeChangeTime
	self:NetworkVar("Float", 6, "LastReload")
end

function SWEP:Think()
	BaseClass.Think(self)
end

function SWEP:DrawWorldModelTranslucent()
	self:DrawModel()
end

local entMeta = FindMetaTable("Entity")
function SWEP:DoAttack(dmg)
	if CLIENT then return end

	self:GetOwner():LagCompensation(true)
	local trace = util.QuickTrace(self:GetOwner():EyePos(), self:GetOwner():GetAimVector() * 90, {self:GetOwner()})
	self:GetOwner():LagCompensation(false)
	if IsValid(trace.Entity) and trace.Entity.onStunStickUsed then
		trace.Entity:onStunStickUsed(self:GetOwner())
		return
	elseif IsValid(trace.Entity) and trace.Entity:GetClass() == "func_breakable_surf" then
		trace.Entity:Fire("Shatter")
		self:GetOwner():EmitSound('physics/concrete/rock_impact_soft' .. math.random(1, 3) .. '.wav')
		return
	end

	self.WaitingForAttackEffect = true

	local ent = self:GetOwner():getEyeSightHitEntity(100, 15, fn.FAnd{fp{fn.Neq, self:GetOwner()}, fc{IsValid, entMeta.GetPhysicsObject}})

	if not IsValid(ent) then return end
	if ent:IsPlayer() and not ent:Alive() then return end

	if not ent:IsDoor() then
		ent:SetVelocity((ent:GetPos() - self:GetOwner():GetPos()) * 7)
	end

	if dmg > 0 then
		ent:TakeDamage(dmg, self:GetOwner(), self)
	end

	if ent:IsPlayer() then
		ent:MoveModifier('stunstick', {
			walkmul = 0.1,
			norun = true,
			nojump = true,
		})

		timer.Create('stunstick' .. ent:EntIndex(), 5, 1, function()
			if not IsValid(ent) then return end
			ent:MoveModifier('stunstick', nil)
		end)

		if math.random(1,2) == 1 then
			local w = ent:GetActiveWeapon()
			if IsValid(w) and not (GAMEMODE.Config.DisallowDrop[w:GetClass()] or ply:jobHasWeapon(w:GetClass())) then
				ent:dropDRPWeapon(w)
			end
		end
	end

	if ent:IsPlayer() or ent:IsNPC() or ent:IsVehicle() then
		self:GetOwner():EmitSound('physics/body/body_medium_impact_hard' .. math.random(1, 6) .. '.wav')
	else
		self:GetOwner():EmitSound('physics/concrete/rock_impact_soft' .. math.random(1, 3) .. '.wav')
		if FPP and FPP.plyCanTouchEnt(self:GetOwner(), ent, "EntityDamage") then
			if ent.SeizeReward and not ent.beenSeized and not ent.burningup and self:GetOwner():isCP() and ent.Getowning_ent and self:GetOwner() ~= ent:Getowning_ent() then
				self:GetOwner():addMoney(ent.SeizeReward)
				self:GetOwner():Notify('warning', L.you_received_x:format(DarkRP.formatMoney(ent.SeizeReward), L.bonus_destroying_entity))
				ent.beenSeized = true
			end
			ent:TakeDamage(1000 - dmg, self:GetOwner(), self) -- for illegal entities
		end
	end
end

function SWEP:PrimaryAttack()
	BaseClass.PrimaryAttack(self)
	self:SetNextSecondaryFire(self:GetNextPrimaryFire())
	self:DoAttack(0)
end

function SWEP:SecondaryAttack()
	BaseClass.PrimaryAttack(self)
	self:SetNextSecondaryFire(self:GetNextPrimaryFire())
	self:DoAttack(10)
end

function SWEP:Reload()
	self:SetHoldType("melee")
	self:SetHoldTypeChangeTime(CurTime() + 0.1)

	if self:GetLastReload() + 0.1 > CurTime() then self:SetLastReload(CurTime()) return end
	self:SetLastReload(CurTime())
end
