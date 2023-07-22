ENT.Type 		= 'anim'
ENT.Base 		= 'ent_dbg_workproblem'
ENT.PrintName	= 'Камера'
ENT.Category	= L.dobrograd
ENT.Author		= 'Wani4ka'
ENT.Contact		= '4wk@wani4ka.ru'

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.RepairDistSqr		= 20000
ENT.LightDrawDistSqr = 500 * 500
ENT.FOV = 40
ENT.ViewDist = 1500
ENT.FieldViewDistSqr = 1500 * 1500
ENT.notifyData = {'cp'}

local function linear(val)
	local p = val % 2 - 1
	return val % 4 > 2 and p or -p
end

function ENT:GetRotation()

	local data = self:GetNetVar('rotationData')
	if not data or not data.center then return angle_zero, 0 end
	if data.v == 0 or data.r == 0 then return data.center, data.p end

	local ct = CurTime()
	local x = ct - self:GetNetVar('rotationStart', ct)
	if x <= 0 then return self:GetNetVar('freezeRotate', data.center), data.p end

	return data.center + linear(x * data.v) * data.r, data.p

end

function ENT:ScreenPos(rel)
	local y, p = self:GetRotation()
	local pos, ang = LocalToWorld(rel or Vector(1.4, 0, -1.5), Angle(-p, y, 0), self:GetPos(), self:GetAngles())
	return pos + ang:Forward() * 7.5, ang
end

function ENT:GetViewDist()
	local data = self:GetNetVar('rotationData')
	return data and data.viewDist or self.ViewDist or 1500
end
