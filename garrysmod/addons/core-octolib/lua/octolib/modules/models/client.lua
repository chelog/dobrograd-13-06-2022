local function sidePadding(pan)
	if not IsValid(pan) then return 0 end
	local l, _, r = pan:GetDockPadding()
	return l + r
end

local function safeWidth(pan)
	if not (IsValid(pan) and pan:IsVisible()) then return 0 end
	local l, _, r = pan:GetDockMargin()
	return l + pan:GetWide() + r
end

local function filterByGender(mdls)
	local imMale = LocalPlayer():IsMale()
	local response = octolib.array.filter(mdls, function(v, i) -- trying to look up model with same gender (or unisex)
		if (imMale == true) == (v.male == true) or v.unisex then
			v.id = i
			return true
		end
	end)

	if not response[1] then -- if there are no models with our gender, we allow all models
		for i, v in ipairs(mdls) do
			v.id = i
			response[#response + 1] = v
		end
	end
	return response
end

local function addDefaultValue(data)
	local hasSelected = false
	for _, v in ipairs(data) do
		if v[3] then
			hasSelected = true
			break
		end
	end
	if not hasSelected then data[1][3] = true end
end

local function populateSkin(pnl, data, update)
	if not data then return 0 end
	addDefaultValue(data.vals)
	local combo = octolib.comboBox(pnl, data.name, data.vals)
	function combo:OnSelect(_, _, val)
		update(val)
	end
	pnl.skinCustomizer = combo
	return 185
end

local function populateOptions(pnl, key, data, update)

	if not data then return 0 end

	local function updateCheckbox(self, val)
		update(self.id, val and self.okVal or 0)
	end
	local function updateCombobox(self, _, _, val)
		update(self.id, val)
	end

	key = key .. 'Customizers'

	local width = 0
	surface.SetFont('DermaDefault')
	for id, obj in pairs(data) do
		if istable(obj.vals) and obj.vals[2] then
			addDefaultValue(obj.vals)
			local combo = octolib.comboBox(pnl, obj.name, obj.vals)

			combo.id = id
			combo.OnSelect = updateCombobox
			pnl[key][combo.id] = {true, combo}
			combo:InvalidateLayout(true)
			combo:ChooseOptionID(1)
			width = math.max(width, 185)
		else
			local cbox = octolib.checkBox(pnl, obj.name)
			cbox.id = id
			cbox.okVal = istable(obj.vals) and obj.vals[1] or 1
			cbox.OnChange = updateCheckbox
			pnl[key][cbox.id] = {false, cbox}
			width = math.max(width, cbox.Label.x + select(1, cbox.Label:GetTextSize()))
		end
	end
	return width

end

local function fpcFixed(self)
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
local function thinkFixed(self)
	self:oThink()

	if IsValid(self.Entity) and self.aLookAngle ~= self.tgtLookAngle then
		self.aLookAngle = LerpAngle(FrameTime() * 8, self.aLookAngle, self.tgtLookAngle)

		local pos = self.Entity:OBBCenter() - Vector(0, 0, -35.5)
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
local function mouseReleasedFixed(self, k)
	self:oMR(k)
	self:SetCursor('hand')
end

octolib.models.selectorPanel = octolib.models.selectorPanel
function octolib.models.selector(input, callback)
	if IsValid(octolib.models.selectorPanel) then
		octolib.models.selectorPanel:Remove()
	end

	local pnl = vgui.Create 'DFrame'
	pnl:SetSize(452, 469)
	pnl:SetTitle('Выбор модели')
	pnl:MakePopup()
	pnl:Center()
	function pnl:OnClose()
		callback(false)
	end
	octolib.models.selectorPanel = pnl

	local layoutPan = pnl:Add('DScrollPanel')
	layoutPan:Dock(LEFT)
	layoutPan:SetWide(217)
	layoutPan:InvalidateLayout(true)
	pnl.layoutPan = layoutPan

	local layout = layoutPan:Add('DIconLayout')
	layout:Dock(FILL)
	layout:SetSpaceX(5)
	layout:SetSpaceY(5)
	pnl.layout = layout

	local customization

	local function btnClick(self)
		customization:ChangeModel(self.index, self.mdlData)
	end

	local mdls = {}
	pnl.mdls = mdls
	function layout:AddModel(index, mdlData)
		local wrap = layout:Add('DButton')
		wrap:SetSize(64, 64)
		wrap:SetText('')
		Derma_Hook(wrap, 'Paint', 'Paint', 'Panel')
		wrap.index = index
		wrap.mdlData = mdlData
		wrap.DoClick = btnClick
		wrap:SetTooltip(mdlData.name)

		local mdl = wrap:Add('ModelImage')
		mdl:Dock(FILL)
		mdl:SetMouseInputEnabled(false)
		mdl:SetVisible(false)
		wrap.mdl = mdl

		mdls[#mdls + 1] = wrap
		return wrap
	end

	input = filterByGender(input or {})
	for _, v in ipairs(input) do layout:AddModel(v.id, v) end
	layoutPan:InvalidateLayout(true)
	timer.Simple(0.5, function()
		if IsValid(layoutPan) and not layoutPan.VBar.Enabled then
			layoutPan:SetWide(202)
			pnl:RecalculateWidth()
		end
	end)

	octolib.func.throttle(table.Reverse(layout:GetChildren()), 2, 0.1, function(v)
		if not layout:IsValid() then return end

		local mdlData = v.mdlData
		util.PrecacheModel(mdlData.model)
		local bgsStr = ''
		if mdlData.requiredBgs then
			for i = 0, table.maxn(mdlData.requiredBgs) do
				bgsStr = bgsStr .. tostring(mdlData.requiredBgs[i] or 0)
			end
		end
		v.mdl:SetModel(mdlData.model, mdlData.requiredSkin or 0, bgsStr)
		v.mdl:SetVisible(true)

	end)

	customization = pnl:Add('DScrollPanel')
	customization:Dock(LEFT)
	customization:DockMargin(10, 5, 5, 5)
	customization:SetVisible(false)
	pnl.params = customization

	local mpWrap = pnl:Add 'DPanel'
	mpWrap:Dock(LEFT)
	mpWrap:DockMargin(5, 0, 0, 0)
	mpWrap:SetWide(225)
	pnl.mpWrap = mpWrap

	local modelPreview = mpWrap:Add('DAdjustableModelPanel')
	modelPreview:Dock(FILL)
	modelPreview:SetFont('octolib.normal')
	modelPreview:SetText('Выбери модель слева')
	modelPreview:SetMouseInputEnabled(false)
	modelPreview.FirstPersonControls = fpcFixed
	modelPreview.oThink = modelPreview.Think
	modelPreview.Think = thinkFixed
	modelPreview.oMR = modelPreview.OnMouseReleased
	modelPreview.OnMouseReleased = mouseReleasedFixed
	modelPreview.OnMouseWheeled = octolib.func.zero
	modelPreview.LayoutEntity = octolib.func.zero
	modelPreview:SetCamPos(Vector(100,0,35.5))
	modelPreview:SetLookAng(Angle(0,180,0))
	modelPreview:SetFirstPerson(true)
	modelPreview:SetFOV(25)
	modelPreview.vRawCamPos = Vector(0,0,5.5)
	modelPreview.tgtLookAngle = Angle(0,180,0)
	pnl.modelPreview = modelPreview

	local submitBtn = octolib.button(mpWrap, 'Выбрать', function()
		local ent = modelPreview.Entity

		local bgs = {}
		for _, bg in pairs(ent:GetBodyGroups()) do
			bgs[bg.id] = ent:GetBodygroup(bg.id)
		end

		callback(pnl.index, ent:GetSkin(), bgs, pnl.mats)
		pnl:Close()
	end)
	submitBtn:Dock(BOTTOM)
	submitBtn:SetTall(25)
	submitBtn:SetVisible(false)
	pnl.submitBtn = submitBtn

	function pnl:RecalculateWidth(add)
		add = add or 0

		local totalWidth = sidePadding(self) + safeWidth(mpWrap) + safeWidth(layoutPan) + add
		local d = self:GetWide() - totalWidth
		self:SetWide(totalWidth)

		local x, y = self:GetPos()
		x = x + (d / 2)
		self:SetPos(x, y)
	end
	pnl:RecalculateWidth()

	function customization:ChangeModel(index, data)
		self:GetCanvas():Clear()
		self.skinCustomizer, self.bgCustomizers, self.matCustomizers = nil, {}, {}
		modelPreview:SetModel(data.model)
		modelPreview:SetMouseInputEnabled(true)
		if IsValid(submitBtn) then submitBtn:SetVisible(true) end

		local ent = modelPreview.Entity
		ent:SetPos(-ent:OBBCenter() + (data.previewOffset or Vector()))
		modelPreview.vRawCamPos = Vector(100, 0, 33)
		modelPreview.tgtLookAngle = modelPreview.aLookAngle
		modelPreview:SetText('')

		modelPreview.viewOffset = data.previewOffset or Vector()

		pnl.index = index
		pnl.mats = {}

		local paramsWidth = 0
		if data.requiredSkin then
			ent:SetSkin(data.requiredSkin)
		else
			paramsWidth = populateSkin(self, data.skin, function(val)
				modelPreview.Entity:SetSkin(val)
			end)
		end
		if data.requiredBgs then
			for k, v in pairs(data.requiredBgs) do
				ent:SetBodygroup(k, v)
			end
		end
		if data.requiredMats then
			for k, v in pairs(data.requiredMats) do
				pnl.mats[k] = v
				ent:SetSubMaterial(k, v)
			end
		end
		paramsWidth = math.max(paramsWidth, populateOptions(self, 'bg', data.bgs, function(bgID, bgVal)
			modelPreview.Entity:SetBodygroup(bgID, bgVal)
		end))

		paramsWidth = math.max(paramsWidth, populateOptions(self, 'mat', data.subMaterials, function(matID, matVal)
			modelPreview.Entity:SetSubMaterial(matID, matVal)
			pnl.mats[matID] = matVal
		end))

		self:SetVisible(paramsWidth > 0)
		self:SetWide(paramsWidth)
		self:InvalidateLayout(true)
		if self.VBar:IsEnabled() then
			self:SetWide(paramsWidth + 15)
			self:InvalidateLayout(true)
		end

		pnl:RecalculateWidth(safeWidth(self))

	end

	return pnl

end

netstream.Hook('octolib.modelSelector', function(mdls)
	octolib.models.selector(mdls, function(index, skin, bgs, mats)
		netstream.Start('octolib.modelSelector', index, skin, bgs, mats)
	end)
end)
