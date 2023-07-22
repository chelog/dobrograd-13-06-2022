include 'shared.lua'

function ENT:Initialize()
	self.effects = EffectData()
	self.effects:SetScale(4)
	self.effects:SetEntity(self)
	self.effects:SetFlags(0)
end

function ENT:Think()
	if self:GetNetVar('baiting') and self:WaterLevel() > 0 then
		self.effects:SetOrigin(self:GetPos())
		util.Effect('WaterSplash', self.effects, true, true)
	end
	
	self:SetNextClientThink(CurTime() + 1)
	return true
end

function ENT:Draw()
	self:DrawModel()
end
