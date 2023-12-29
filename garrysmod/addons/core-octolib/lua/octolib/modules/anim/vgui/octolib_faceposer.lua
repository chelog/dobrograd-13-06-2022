local PANEL = {}

function PANEL:Init()

	self:Dock(FILL)
	self:SetPaintBackground(false)
	self.flexes = {}

	local m = self:Add 'DAdjustableModelPanel'
	m:Dock(LEFT)
	m:SetWide(300)
	m.LayoutEntity = function(m, ent)
		for k, v in pairs(self.flexes) do
			ent:SetFlexWeight(k, v)
		end
		ent:SetEyeTarget(m:GetCamPos())
	end
	self.model = m

	m.FirstPersonControls = function(m)
		local x, y = m:CaptureMouse()
		m.aLookAngle = m.aLookAngle + Angle( y * 0.1, x * -0.1, 0 )
		m.vCamPos = m.basePos - m.aLookAngle:Forward() * 20
	end

	local sp = self:Add 'DScrollPanel'
	sp:Dock(FILL)
	sp.pnlCanvas:DockPadding(10, 0, 10, 0)
	sp:SetPaintBackground(true)
	self.sliderContainer = sp

end

function PANEL:CopyEntity(ent)

	local m = self.model
	m:SetModel(ent:GetModel())
	local ent = m.Entity
	ent:SetSkin(ent:GetSkin())
	for k, v in ipairs(ent:GetBodyGroups()) do
		ent:SetBodygroup(k, ent:GetBodygroup(v.id))
	end

	local att = ent:GetAttachment(ent:LookupAttachment('eyes'))
	local ang = Angle(0, 173, 0)
	local basePos = att.Pos + Vector(0, 0, -1.5)
	local pos = basePos - ang:Forward() * 20
	m.basePos = basePos
	m:SetFOV(25)
	m:SetCamPos(pos)
	m:SetLookAng(ang)

	self.flexes = {}
	self.sliders = {}

	local function onChange(slider, val)
		val = math.Round(val, 2)
		self.flexes[slider.flexID] = val ~= 0 and val or nil
		ent:SetFlexWeight(slider.flexID, val)
	end

	for i = 0, ent:GetFlexNum() - 1 do
		local niceName = string.Explode('_', ent:GetFlexName(i))
		niceName = table.concat(octolib.table.mapSequential(niceName, function(v) return utf8.upper(utf8.sub(v, 1, 1)) .. utf8.lower(utf8.sub(v, 2)) end), ' ')

		self.flexes[i] = math.Round(ent:GetFlexWeight(i), 2)

		local slider = octolib.slider(self.sliderContainer, niceName, 0, 1, 2)
		slider:SetValue(self.flexes[i])
		slider.flexID = i
		slider.OnValueChanged = onChange
		self.sliders[i] = slider
	end

end

function PANEL:Import(data)

	for _, slider in pairs(self.sliders) do
		slider:SetValue(data[slider.flexID] or 0)
	end

end

function PANEL:Export()

	local out = table.Copy(self.flexes)
	for k, v in pairs(out) do
		local nv = math.Round(v, 2)
		if nv > 0 then
			out[k] = nv
		else
			out[k] = nil
		end
	end

	return out

end

vgui.Register('octolib_faceposer', PANEL, 'DPanel')
