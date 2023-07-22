local defaultColors = { Color(255,255,255), Color(255,255,255), Color(0,0,0), Color(255,255,255) }

local PANEL = {}

function PANEL:Init()

	self:Dock(FILL)
	self.vRawCamPos = Vector()
	self.tgtLookAngle = Angle()
	self.camPos = Vector(200, 400, 50)

end

function PANEL:SetVehicle(vehID, data)

	data = data or {}

	local cdData = carDealer.vehicles[vehID]
	if not cdData then return end

	self.vehID = vehID

	local spData = list.Get('simfphys_vehicles')[cdData.simfphysID]
	assert(spData ~= nil, 'Wrong simfphysID for ' .. vehID)

	self:Cleanup()
	local default = cdData.default

	self:SetModel(spData.Model)
	local ent = self.Entity
	ent:SetPos(-ent:OBBCenter() + (cdData.previewOffset or Vector()))
	ent:SetAngles(Angle(0, cdData.SpawnAngleOffset or spData.SpawnAngleOffset or 0, 0))
	local cols = default and default.col or defaultColors
	self.Entity:SetProxyColors({ cols[1], cols[2], CFG.reflectionTint, cols[4] })
	self.Entity:SetSkin(default and default.skin or 0)
	carDealer.attachWheels(ent, vehID, data.data)
	self:SetCamPos(self.camPos)
	self.vRawCamPos = self.camPos
	self:SetLookAng((-self.camPos):Angle())
	self.tgtLookAngle = self.aLookAngle
	self:SetFOV((cdData.customFOV or 30) * (self.fovMultiplier or 1))

	for k, v in pairs(default and default.bg or {}) do
		ent:SetBodygroup(k, v)
	end

	local status = data.data
	if status then
		local ent = self.Entity
		if status.col then
			self.Entity:SetProxyColors({ status.col[1], status.col[2], CFG.reflectionTint, status.col[4] })
		end
		if status.skin then ent:SetSkin(status.skin) end
		if status.bg then
			for k, v in pairs(status.bg) do
				ent:SetBodygroup(k, v)
			end
		end

		if status.atts then
			carDealer.attachAccessories(ent, status.atts)
		end
	end
	local mats = status and status.mats or default and default.mats or {}
	for k, v in pairs(mats) do
		self.Entity:SetSubMaterial(k-1, v)
	end

	self.viewOffset = cdData.previewOffset or self.viewOffset or Vector()
	if self.camOffset then
		local off = self.camOffset
		self.vCamPos = self.vRawCamPos +
			self.aLookAngle:Right() * off.x +
			self.aLookAngle:Forward() * off.y +
			self.aLookAngle:Up() * off.z
	end

end

function PANEL:FirstPersonControls()

	if not self.canControl then return end

	local x, y = self:CaptureMouse()
	local scale = self:GetFOV() / 180
	x = x * -0.5 * scale
	y = y * 0.5 * scale

	if self.MouseKey == MOUSE_LEFT then
		self:SetCursor('blank')
		self.tgtLookAngle = self.tgtLookAngle + Angle(y * 4, x * 4, 0)
		self.tgtLookAngle.p = math.Clamp(self.tgtLookAngle.p, -25, 25)
	end

end

function PANEL:Think()

	self.BaseClass.Think(self)

	if self.canControl and IsValid(self.Entity) and self.aLookAngle ~= self.tgtLookAngle then
		self.aLookAngle = LerpAngle(FrameTime() * 8, self.aLookAngle, self.tgtLookAngle)

		local pos = self.Entity:OBBCenter() - self.viewOffset
		self.vRawCamPos = pos - self.aLookAngle:Forward() * (pos - self.vRawCamPos):Length()

		if self.camOffset then
			local off = self.camOffset
			self.vCamPos = self.vRawCamPos +
				self.aLookAngle:Right() * off.x +
				self.aLookAngle:Forward() * off.y +
				self.aLookAngle:Up() * off.z
		else
			self.vCamPos = self.vRawCamPos
		end
	end

end

function PANEL:OnMouseReleased(k)

	self.BaseClass.OnMouseReleased(self, k)
	self:SetCursor('hand')

end

function PANEL:OnMouseWheeled()
	-- prevent baseclass function
end

function PANEL:LayoutEntity()
	-- prevent baseclass function
end

function PANEL:PostDrawModel(ent)

	if ent.wheels then
		render.SetColorModulation(1, 1, 1)
		for _, w in ipairs(ent.wheels) do
			w:DrawModel()
		end
	end

	if ent.atts then
		for _, a in ipairs(ent.atts) do
			local col = a:GetColor()
			render.SetColorModulation(col.r / 255, col.g / 255, col.b / 255)
			a:DrawModel()
		end
	end

end

function PANEL:FixPosition()

	local pos = self.Entity:OBBCenter() - (self.viewOffset or vector_zero)
	self.vCamPos = pos - self.aLookAngle:Forward() * (pos - self.vCamPos):Length()

end

function PANEL:Cleanup()

	local ent = self.Entity
	if IsValid(ent) then
		if ent.wheels then
			for _, w in ipairs(ent.wheels) do
				w:Remove()
			end
		end

		if ent.atts then
			for _, a in ipairs(ent.atts) do
				a:Remove()
			end
		end

		ent:Remove()
	end

end

function PANEL:OnRemove()

	self:Cleanup()

end

vgui.Register('cd_vehModel', PANEL, 'DAdjustableModelPanel')
