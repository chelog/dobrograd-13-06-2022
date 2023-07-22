AddCSLuaFile 'shared.lua'
AddCSLuaFile 'cl_init.lua'
include 'shared.lua'

function SWEP:SetWorldModel(model, data)

	self.WorldModel = model
	self.WorldModelPos = data.pos or self.WorldModelPos
	self.WorldModelAng = data.ang or self.WorldModelAng

	local worldModel = { model = model }
	table.Merge(worldModel, data)
	self:SetNetVar('WorldModel', worldModel)

end

function SWEP:Initialize()

	if not self:GetNetVar('WorldModel') then
		self.WorldModelBodyGroups.BaseClass = nil -- WHAT THE FUCK?!
		self:SetWorldModel(self.WorldModel, {
			pos = self.WorldModelPos,
			ang = self.WorldModelAng,
			attachment = self.WorldModelAtt,
			scale = self.WorldModelScale,
			bones = self.WorldModelBones,
			skin = self.WorldModelSkin,
			bodyGroups = self.WorldModelBodyGroups,
		})
	end

end

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)
end

function SWEP:Holster()
	return true
end
