include('shared.lua')
local mat = Material('sprites/light_glow02_add_noz')

function ENT:Initialize()
	self.drawLight = false
	self.pixvishandle = util.GetPixelVisibleHandle()
	self.nextDraw = CurTime()
	timer.Simple(0, function() if IsValid(self) then self.oldRotationData = nil end end)
end

function ENT:Move() -- vertim boshkoy
	local center, p = self:GetRotation()
	self:ManipulateBoneAngles(1, Angle(0, 0, center))
	self:ManipulateBoneAngles(2, Angle(0, p, 0))
end

function ENT:Think()

	if self:GetNetVar('broken') then
		self.drawLight = false
		return
	end

	local lp = LocalPlayer()
	local ct = CurTime()

	if ct > self.nextDraw and IsValid(lp) then
		self.drawLight = not self.drawLight and self:GetPos():DistToSqr(lp:GetPos()) < self.LightDrawDistSqr
		self.nextDraw = ct + 0.75

		--[[ if self.drawLight and self:GetNetVar('rotationStart', ct) < ct then
			self:EmitSound('npc/turret_floor/ping.wav', 50, 100, 0.5)
		end ]]
	end

	local data = self:GetNetVar('rotationData')
	if data and (data.r > 0 and data.v > 0 or data ~= self.oldRotationData) then
		self:Move()
		self.oldRotationData = data
	end

end

local fieldSegs = 20
local rPos = {}
for i = 1, fieldSegs do
	local ang = math.pi * 2 / fieldSegs * i
	rPos[i] = { math.cos(ang), math.sin(ang) }
end

local colField = Color(255, 100, 100)
local coneRadius = math.tan(math.rad(ENT.FOV))
function ENT:Draw()
	pcall(function()
		self:DrawModel()

		if self.drawLight then
			local pos = LocalToWorld(Vector(2.6, -8, -1.5), Angle(), self:GetBonePosition(2))
			local visible = util.PixelVisible(pos, 2, self.pixvishandle)
			if visible and visible >= 0.6 then
				visible = (visible - 0.6) * 2.5
				render.SetMaterial(mat)
				render.DrawSprite(pos, 5, 5, Color(255,0,0, 255*visible))
			end
		end

		local d = self:GetViewDist()
		if octolib.drawDebug and not self:GetNetVar('broken') and self:GetPos():DistToSqr(LocalPlayer():GetPos()) < d*d*4 then
			local pos, ang = self:ScreenPos()
			local endpos = pos + ang:Forward() * d
			for i = 1, fieldSegs do
				local right, up = ang:Right() * rPos[i][1] * coneRadius * d, ang:Up() * rPos[i][2] * d
				render.DrawLine(pos, endpos + right + up, colField, true)
			end
		end
	end)
end
