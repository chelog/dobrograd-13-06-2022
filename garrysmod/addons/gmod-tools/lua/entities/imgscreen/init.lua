AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'
include 'shared.lua'

function ENT:Initialize()

	self:SetModel('models/hunter/plates/plate1x1.mdl')
	self:DrawShadow(false)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	local ph = self:GetPhysicsObject()
	ph:SetMass(1)

end

-- local allowedTools = octolib.array.toKeys {'imgscreen', 'remover', 'precision'}

-- hook.Add('CanTool', 'imgscreens.preventTools', function(ply, trace, tool)
-- 	if IsValid(trace.Entity) and trace.Entity:GetClass() == 'imgscreen' and not allowedTools[tool] then return false end
-- end, -5)

function ENT:UpdateImage()

	-- compatibility
	if self.imgURL:sub(1, 4) ~= 'http' then
		self.imgURL = 'https://i.imgur.com/' .. self.imgURL
	end

	self:SetNetVar('img', { self.imgURL, self.imgW, self.imgH, self.imgColor, self.imgFade })

end

local tosave = {'nocollide', 'imgURL', 'imgW', 'imgH', 'imgColor'}
duplicator.RegisterEntityClass('imgscreen', function(ply, data)

	if IsValid(ply) and not ply:CheckLimit('imgscreens') then
		return false
	end

	local ent = duplicator.GenericDuplicatorFunction(ply, data)
	ent:UpdateImage()

	if ent.nocollide then
		ent:GetPhysicsObject():EnableCollisions(false)
		ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
	end

	if IsValid(ply) then
		ply:AddCount('imgscreens', ent)
		ply:AddCleanup('imgscreens', ent)
	end

	return ent

end, 'Data', unpack(tosave))
