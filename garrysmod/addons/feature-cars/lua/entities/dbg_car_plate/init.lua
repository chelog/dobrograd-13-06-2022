include 'shared.lua'
AddCSLuaFile 'shared.lua'
AddCSLuaFile 'cl_init.lua'

function ENT:Initialize()

	self:SetModel('models/octoteam/vehicles/attachments/licenceplate_01.mdl')
	self.DoNotDuplicate = true

end
