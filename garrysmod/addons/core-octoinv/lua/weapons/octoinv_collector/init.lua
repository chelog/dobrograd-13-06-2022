AddCSLuaFile 'shared.lua'
AddCSLuaFile 'cl_init.lua'
include 'shared.lua'

SWEP.SecondaryAttack = octolib.func.zero
SWEP.Reload = octolib.func.zero

function SWEP:Initialize()

	self.collectorID = 'pickaxe'

	if self.collectorID then
		self:SetCollectorID(self.collectorID)
	else
		self:SetCollector({
			hold = 'melee2',
			interval = 1.5,
			delay = 0.15,
			worldModel = {
				model = 'models/weapons/hl2meleepack/w_pickaxe.mdl',
				pos = Vector(-1.9, -0.6, -0.7),
				ang = Angle(168.6, -100.5, -4),
				scale = 0.8
			},
		})
	end

	self.BaseClass.Initialize(self)

end

function SWEP:Deploy()

	self.BaseClass.Deploy(self)

	local ct = CurTime()
	local interval = self.Collector.interval or 1
	self:SetNextPrimaryFire(ct + interval)
	self:SetNextSecondaryFire(ct + interval)

end

function SWEP:SetCollectorID(id)

	local collector = octoinv.collectors[id]
	if not collector then return end

	self:SetCollector(collector)

end

function SWEP:SetCollector(collector)

	if collector.worldModel then
		local worldModel = collector.worldModel
		self:SetWorldModel(worldModel.model, worldModel)
	end

	self.Collector = collector
	self.collectorID = collector.id
	self:SetNetVar('Collector', self.Collector)

	self.health = self.health or collector.health

	self:SetHoldType(collector.hold or 'melee2')

end

function SWEP:TryCollect()

	local owner = self:GetOwner()

	local tr = {}
	tr.start = owner:GetShootPos()
	tr.endpos = tr.start + owner:GetAimVector() * 100
	tr.filter = owner
	tr = util.TraceLine(tr)

	if not tr.Hit then return end
	-- self:FireBullets({
	-- 	Src = tr.HitPos + tr.HitNormal,
	-- 	Dir = -tr.HitNormal,
	-- 	Damage = 2,
	-- 	Force = 5,
	-- 	Distance = 5,
	-- })

	if self.Collector.sounds then
		local data = table.Random(self.Collector.sounds)
		if not istable(data) then data = { data } end
		sound.Play(data[1], tr.HitPos, unpack(data, 2))
	end

	local ent = tr.Entity
	if IsValid(ent) and ent:GetClass() == 'octoinv_collectable' and table.HasValue(ent.Collectable.collectors, self.Collector.id) then
		ent:Collect(owner, self, tr)
	end

	self.health = (self.health or 1) - 1
	if self.health <= 0 then
		self:EmitSound('physics/wood/wood_box_impact_hard' .. math.random(1, 3) .. '.wav', 75, 100, 0.8)
		self:Remove()

		local owner = self:GetOwner()
		timer.Simple(0, function()
			owner:SelectWeapon('dbg_hands')
		end)
	end

end

hook.Add('dbg-weapons.getItemData', 'octoinv.collect', function(wep)
	if wep:GetClass() ~= 'octoinv_collector' then return end

	return table.Merge(table.Copy(wep.itemData or {}), {
		class = 'collector',
		collector = wep.collectorID,
		health = wep.health,
	})
end)
