AddCSLuaFile 'shared.lua'
AddCSLuaFile 'cl_init.lua'
include 'shared.lua'

function ENT:Initialize()

	self:DrawShadow(false)
	self:SetRenderMode(RENDERMODE_TRANSALPHA)

	self:Setup('box', { Vector(-20, -50, -5), Vector(20, 50, 5) })
	self:SetIgnorePlayers(false)

end

function ENT:Setup(colType, data)

	self.ColliderType = colType
	self.ColliderData = data
	self:SetNetVar('collider', { colType, data })

	if colType == 'model' then
		self:SetModel(data)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMaterial('models/wireframe')
	elseif colType == 'box' then
		self:PhysicsInitBox(data[1], data[2])
		self:SetMoveType(MOVETYPE_VPHYSICS)

		-- local min, max = unpack(data)
		-- self:PhysicsInitConvex({
		-- 	Vector(min.x, min.y, min.z),
		-- 	Vector(min.x, min.y, max.z),
		-- 	Vector(min.x, max.y, min.z),
		-- 	Vector(min.x, max.y, max.z),
		-- 	Vector(max.x, min.y, min.z),
		-- 	Vector(max.x, min.y, max.z),
		-- 	Vector(max.x, max.y, min.z),
		-- 	Vector(max.x, max.y, max.z),
		-- })

		-- self:SetMoveType(MOVETYPE_VPHYSICS)
		-- self:SetSolid(SOLID_VPHYSICS)

		-- self:EnableCustomCollisions(true)
		-- self:SetCustomCollisionCheck(true)
		-- self:CollisionRulesChanged()
	end

end

function ENT:SetIgnorePlayers(val)

	self:SetNetVar('ignorePlayers', tobool(val))
	self:CollisionRulesChanged()

end
