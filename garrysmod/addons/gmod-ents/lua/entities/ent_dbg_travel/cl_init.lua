include 'shared.lua'

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.RenderGroup 		= RENDERGROUP_BOTH

surface.CreateFont('dbg-travel.normal', {
	font = 'Calibri',
	extended = true,
	size = 48,
	weight = 350,
})

surface.CreateFont('dbg-travel.small', {
	font = 'Calibri',
	extended = true,
	size = 27,
	weight = 350,
})

surface.CreateFont('dbg-travel.xsmall', {
	font = 'Calibri',
	extended = true,
	size = 24,
	weight = 350,
})

local dstVal, timeVal = '%s останов%s', '≈%sсек'
local gbMsgs = {'Приятной поездки!', 'Хорошей дороги!', 'Счастливого пути!', 'Доброго пути!'}
local noFeeTime, transferFee, transferLength = ENT.noFeeTime, ENT.transferFee, ENT.transferLength
local goFrame

local function param(parent, name, val)
	local wrap = parent:Add('DPanel')
	wrap:Dock(TOP)
	wrap:SetTall(45)

	local title = wrap:Add('DLabel')
	title:Dock(LEFT)
	title:DockMargin(5, 5, 5, 5)
	title:SetFont('f4.normal')
	title:SetText(name)
	title:SizeToContentsX()

	local value = wrap:Add('DLabel')
	value:Dock(FILL)
	value:DockMargin(5, 5, 5, 5)
	value:SetFont('f4.normal')
	value:SetText(val or '...')
	value:SetContentAlignment(6)

	return value
end

netstream.Hook('dbg-travel.buildMenu', function(stops, nt, justUpdate, curStop)

	if IsValid(goFrame) then return end -- maybe he is afk, so we shouldn't transfer him further

	if justUpdate then
		for i,v in ipairs(stops) do
			local mark = octomap.createMarker('bus_' .. i)
			mark:SetPos(v[1])
			mark:SetIconSize(16)
			mark:SetClickable(true)
			mark.pos = i
			mark:SetIcon('octoteam/icons-16/bus.png')
			mark:AddToSidebar('Остановка', 'bus')
			mark.LeftClick = octomap.sidebarMarkerClick
		end

		return
	end

	local start = CurTime()
	goFrame = vgui.Create('DFrame')
	goFrame:SetTitle('Автобус')
	goFrame:SetSize(720, 480)
	goFrame:SetMinHeight(395)
	goFrame:SetSizable(true)
	goFrame:SetPos(ScrW(), (ScrH() - goFrame:GetTall()) / 2)
	local tgt = (ScrW() - goFrame:GetWide()) / 2
	goFrame:MakePopup()

	local map = goFrame:Add('octomap')
	map:DockMargin(5, 5, 5, 5)
	map:SetOptions({
		minScale = 0.01,
		scale = 0.15,
		tgtScale = 0.15,
		paddingR = 270,
	})

	local ot = goFrame.Think
	function goFrame:Think()
		if isfunction(ot) then ot(self) end
		local x, y = self:GetPos()
		x = x + (tgt - x) * octolib.tween.easing.outQuad(math.min(CurTime() - start, 0.75) / 0.75, 0, 1, 1)
		self:SetPos(x, y)
		if x <= tgt then
			self.Think = ot
		elseif x - tgt <= 88 then
			map:AlignToBounds()
		end
	end

	local osc = goFrame.OnSizeChanged
	function goFrame:OnSizeChanged(w, h)
		if isfunction(osc) then osc(self, w, h) end
		if w ~= 1.5 * h then self:SetWide(1.5 * h) end
		map.tgtScale = 0.000333 * self:GetTall()
	end

	local right = map:Add('DPanel')
	right:Dock(RIGHT)
	right:DockMargin(5, 5, 5, 5)
	right:DockPadding(5, 5, 5, 5)
	right:SetWide(260)

	local e = octolib.label(right, 'Автобус')
	e:SetTall(45)
	e:SetFont('f4.medium')
	e:SetContentAlignment(5)

	local descPnl = right:Add('DPanel')
	descPnl:Dock(TOP)
	descPnl:SetTall(45)
	e = octolib.label(descPnl, 'Выбери остановку на карте')
	e:Dock(FILL)
	e:SetFont('dbg-travel.xsmall')
	e:DockMargin(5, 5, 5, 5)
	e:SetContentAlignment(5)

	local params = right:Add('DPanel')
	params:Dock(TOP)
	params:SetTall(140)
	params:DockMargin(0, 5, 0, 5)
	params:SetDrawBackground(false)

	local marks, cur, sel = {}
	local dist, time, price = param(params, 'Расстояние'), param(params, 'Время в пути'), param(params, 'Стоимость проезда')
	local function updateParams()
		local dst = octolib.math.loopedDist(cur, sel, 0, #stops)
		dist:SetText(dstVal:format(dst, octolib.string.formatCount(dst, 'ка', 'ки', 'ок')))
		time:SetText(timeVal:format(transferLength * dst))
		price:SetText(DarkRP.formatMoney(curStop:GetFee(LocalPlayer(), dst)))
	end

	local function click(marker)
		if marker.pos == cur or marker.pos == sel then return end
		marks[sel]:SetIcon('octoteam/icons-32/bullet_white.png')
		sel = marker.pos
		marker:SetIcon('octoteam/icons-32/bullet_green.png')
		updateParams()
	end
	local function reset()
		for _,v in ipairs(marks) do
			v:SetIcon('octoteam/icons-16/bus.png')
			v:SetIconSize(16)
			v.LeftClick = octomap.sidebarMarkerClick
			v.RightClick = nil
			v:AddToSidebar('Остановка', 'bus')
		end
	end
	local ooc = goFrame.OnClose
	function goFrame:OnClose()
		if isfunction(ooc) then ooc(self) end
		reset()
	end

	for i,v in ipairs(stops) do
		local mark = octomap.createMarker('bus_' .. i)
		mark:SetPos(v[1])
		mark:SetIconSize(32)
		mark.pos = i
		if v[2] then
			cur = i
			mark:SetIcon('octoteam/icons-32/bullet_purple.png')
		else
			mark.LeftClick, mark.RightClick = click
			mark:SetIcon('octoteam/icons-32/bullet_white.png')
		end
		marks[#marks+1] = mark
	end
	sel = cur % #stops + 1
	marks[sel]:SetIcon('octoteam/icons-32/bullet_green.png')

	updateParams()

	local tl = math.ceil(nt - CurTime()) - 1
	local tlPanel = octolib.label(right, 'Отправление через ' .. tl)
	tlPanel:SetFont('f4.normal')
	tlPanel:SetTall(40)
	tlPanel:SetContentAlignment(5)
	local usageWarn = octolib.label(right, 'Не закрывай это окно, чтобы поехать')
	usageWarn:SetContentAlignment(5)
	timer.Create('bus.tl', 1, tl, function()
		if not IsValid(tlPanel) then
			timer.Remove('bus.tl')
			reset()
			return
		end
		if tl <= 1 then
			netstream.Start('dbg-travel.submit', cur, sel)
			tlPanel:SetText(gbMsgs[math.random(#gbMsgs)])
			descPnl:Remove()
			usageWarn:Remove()
			timer.Remove('bus.tl')
			return
		end
		tl = tl - 1
		tlPanel:SetText('Отправление через ' .. tl)
	end)

end)

function ENT:Initialize()

	self.controlText = ('Нажми %s, чтобы выбрать остановку'):format(input.LookupBinding('+use', true):upper())
	self.timeText = ('%d:%02d'):format(0, 0)
	noFeeTime = self.noFeeTime or noFeeTime or 5 * 60 * 60
	transferFee = self.transferFee or transferFee or 40
	transferLength = self.transferLength or transferLength or 10

end

local screenPos, screenAng = Vector(-27,59,93), Angle(0,0,100)
local colors = CFG.skinColors

function ENT:DrawInfobox(relPos, relAng, al)
	local col1, col2, ply = Color(238,238,238, al), Color(180,180,180, al), LocalPlayer()
	local pos, ang = LocalToWorld(relPos, relAng, self:GetPos(), self:GetAngles())

	local mins = self:GetRenderBounds()
	if self:WorldToLocal(EyePos()).x < mins.x then return end

	cam.Start3D2D(pos, ang, 0.058)
		draw.RoundedBox(8, -250, -75, 500, 225, ColorAlpha(colors.bg50, al))
		draw.SimpleText(L.next_bus .. (self.timeText or '0:00'), 'dbg-travel.normal', 0, 0, col1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		local price = (self:FreeTransfer(ply) and '' or 'от ') .. DarkRP.formatMoney(self:GetFee(ply))
		draw.SimpleText(L.price_bus .. price, 'dbg-travel.normal', 0, 40, col1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(self.insideText or 'Дождись, пока приедет автобус', 'dbg-travel.small', 0, 85, col2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function ENT:Draw()

	self:DrawModel()

	local ply = LocalPlayer()
	if IsValid(ply) then
		local al = math.Clamp(1 - (self:GetPos():DistToSqr(EyePos()) - 40000) / 40000, 0, 1) * 255
		if al > 0 then
			self:DrawInfobox(screenPos, screenAng, al)
		end
	end


end

function ENT:Think()

	if self:GetPos():DistToSqr(EyePos()) < 80000 then
		local time = math.max(self:GetNetVar('nextTransfer', 0) - CurTime(), 0)
		self.timeText = ('%d:%02d'):format(math.floor(time / 60), math.floor(time % 60))

		local ply = LocalPlayer()
		if IsValid(ply) then
			local can, why = self:CanTransfer(ply, self:GetFee(ply))
			self.insideText = why
			if can then
				if self:GetNetVar('nextTransfer', 0) - CurTime() > self.menuLength then
					self.insideText = 'Дождись, пока приедет автобус'
				else self.insideText = self.controlText end
			end
		end
	end

	self:NextThink(CurTime() + 1)
	return true

end
