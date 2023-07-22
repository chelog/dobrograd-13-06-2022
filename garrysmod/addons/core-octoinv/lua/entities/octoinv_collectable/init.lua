AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

ENT.Model = 'models/props_junk/garbage_bag001a.mdl'

function ENT:Initialize()
	if not self.collectableID then
		self:SetCollectable({
			name = 'Золото',
			collectors = {'pickaxe'},
			models = {
				{'models/un/ore_un_un.mdl', color = Color(255,207,77), scale = 2.5},
			},
			drops = {
				{1, {'ore_gold', 1}},
			},
			sounds = {
				{'physics/concrete/boulder_impact_hard1.wav', 85},
				{'physics/concrete/boulder_impact_hard2.wav', 85},
				{'physics/concrete/boulder_impact_hard3.wav', 85},
				{'physics/concrete/boulder_impact_hard4.wav', 85},
			},
			period = 5,
			max = 5,
		})
	end
end

function ENT:SetCollectableID(id, selectedModel)

	local collectable = octoinv.collectables[id]
	if not collectable then return end

	self:SetCollectable(collectable, selectedModel)

end

function ENT:SetCollectable(collectable, selectedModel)

	self.Collectable = collectable
	self.collectableID = collectable.id

	local modelData = selectedModel and octolib.table.find(collectable.models,
		function(md) return md == selectedModel or md[1] == selectedModel
	end)
	if not modelData then
		modelData = table.Random(collectable.models)
	end

	if istable(modelData) then
		self:SetModel(modelData[1])
		if modelData.color then self:SetColor(modelData.color) end
		if modelData.skin then self:SetSkin(modelData.skin) end
		if modelData.material then self:SetMaterial(modelData.material) end
		if modelData.scale then self:SetModelScale(modelData.scale) end
		if modelData.bodyGroups then
			for k, v in pairs(modelData.bodyGroups) do
				self:SetBodygroup(k, v)
			end
		end
	else
		self:SetModel(modelData)
	end

	self.health = collectable.health or 100
	self:SetNetVar('dbgLook', {
		name = '',
		desc = collectable.name,
		time = 3,
	})

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:Activate()

	self:GetPhysicsObject():EnableMotion(false)

end

function ENT:Collect(ply, wep, tr)

	local collector = wep.Collector
	if not collector then return end

	local collectable = self.Collectable
	local effects = collectable.effects or {}

	if effects.hitSounds then
		local data = table.Random(effects.hitSounds)
		if not istable(data) then data = { data } end
		self:EmitSound(unpack(data))
	end

	if effects.hit then
		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
			effectdata:SetScale(1)
		util.Effect(effects.hit, effectdata)
	end

	self.health = (self.health or 0) - collector.power
	if self.health >= 0 then return end

	if effects.collectSounds then
		local data = table.Random(effects.collectSounds)
		if not istable(data) then data = { data } end
		self:EmitSound(unpack(data))
	end

	if effects.collect then
		local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetNormal(self:GetUp())
			effectdata:SetScale(1)
		util.Effect(effects.collect, effectdata)
	end

	local drops = collectable.drops
	for _ = 1, collectable.dropsAmount or 1 do
		local itemData = octolib.array.randomWeighted(drops)

		local ent = ents.Create 'octoinv_item'
		ent:SetPos(tr.HitPos or self:GetPos())
		ent:SetAngles(AngleRand())
		ent:Spawn()
		ent:Activate()
		ent:SetData(unpack(itemData))
		ent.dieTime = CurTime() + 480

		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetVelocity(VectorRand() * math.random(20, 100))
		end
	end
	self:Remove()

end
