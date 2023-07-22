include 'shared.lua'

ENT.DrawShared = false
ENT.DrawPos = Vector(2.65, -35, 22.5)
ENT.DrawAng = Angle(0, 90, 90)
ENT.DPU = 5

InteractivePanels = InteractivePanels or {}

function ENT:InitPanel(pnl)

	local but = vgui.Create('DButton', pnl)
	but:SetSize(50, 30)
	but:Center()

	but:SetText('Test')

end

function ENT:Initialize()

	local function createPanel()
		vgui.MaxRange3D2D(100)

		local pnl = vgui.Create('DPanel')
		pnl:SetSize(474, 474)
		pnl:SetPos(0, 0)
		pnl:ParentToHUD()

		self:InitPanel(pnl)
		pnl:Paint3D2D()
		return pnl
	end

	if self.DrawShared then
		local pnl = InteractivePanels[self:GetClass()]
		if IsValid(pnl) then
			self.panel = pnl
		else
			pnl = createPanel()
			InteractivePanels[self:GetClass()] = pnl
			self.panel = pnl
		end
	else
		self.panel = createPanel()
	end

end

function ENT:OnRemove()

	local pnl = self.panel
	timer.Simple(0, function()
		if self.DrawShared and #ents.FindByClass(self:GetClass()) > 0 then return end
		if IsValid(pnl) then pnl:Remove() end
	end)

end

function ENT:Draw()

	self:DrawModel()

	local dist = self:GetPos():DistToSqr(LocalPlayer():EyePos())
	if dist < 90000 then
		local pos, ang = LocalToWorld(self.DrawPos, self.DrawAng, self:GetPos(), self:GetAngles())
		vgui.Start3D2D(pos, ang, 1 / self.DPU)
			surface.SetAlphaMultiplier((90000 - dist) / 50000)
			self.panel:Paint3D2D()
			self:DrawScreen()
			surface.SetAlphaMultiplier(1)
		vgui.End3D2D()
	end

end

function ENT:Think()
	
	if not IsValid(self.panel) then self:Initialize() end
	if not self.panel:IsVisible() then self.panel:SetVisible(true) end

	local ply = LocalPlayer()
	local tr = ply:GetEyeTrace()
	if ply:KeyDown(IN_USE) and tr.Entity == self then
		if not self.isDragging then
			local dist = tr.HitPos:DistToSqr(ply:EyePos())
			if dist > 10000 then return end

			local pos, ang = LocalToWorld(self.DrawPos, self.DrawAng, self:GetPos(), self:GetAngles())
			local hitPos = util.IntersectRayWithPlane(ply:EyePos(), ply:GetAimVector(), pos, ang:Up())
			local relPos = WorldToLocal(hitPos, Angle(), pos, ang)
			relPos.y = -relPos.y
			
			self:DoClick(relPos * self.DPU)
			self.isDragging = true
		end
	else
		self.isDragging = false
	end

end

function ENT:DoClick(clickPos)

	self:MakeClickEffect(clickPos)
	self:EmitSound('ui/buttonrollover.wav')

end

function ENT:DrawScreen()

	for k, v in pairs(self.clickEffects) do
		local state = v.time + 1 - CurTime()

		local poly, radius = {}, math.pow(1-state, 0.4) * 4 * self.DPU
		for i = 1, 24 do
			poly[ i ] = { x = v.x + math.cos(math.pi / 12 * i) * radius, y = v.y + math.sin(math.pi / 12 * i) * radius }
		end

		draw.NoTexture()
		surface.SetDrawColor(255,255,255, math.pow(state, 2) * 255)
		surface.DrawPoly(poly)

		if state <= 0 then table.remove(self.clickEffects, k) end
	end

	-- local tr = LocalPlayer():GetEyeTrace()
	-- local relPos = self:WorldToLocal(tr.HitPos) * self.DPU
	-- draw.RoundedBox(4, relPos.x - 4, relPos.y + 4, 8, 8, color_white)

end

ENT.clickEffects = {}
function ENT:MakeClickEffect(clickPos)

	table.insert(self.clickEffects, {
		time = CurTime(),
		x = clickPos.x,
		y = clickPos.y,
	})

end
