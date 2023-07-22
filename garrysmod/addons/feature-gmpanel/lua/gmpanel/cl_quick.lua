gmpanel.quick = gmpanel.quick or {}

local showRadius = false
local radius = 0

hook.Add('PostDrawTranslucentRenderables', 'gmpanel.radius', function()
	if not showRadius then return end
	render.SetColorMaterial()
	local pos = LocalPlayer():GetEyeTrace().HitPos
	local r = radius
	if pos:DistToSqr(LocalPlayer():GetPos()) <= r * r then
		r = -r
	end
	render.DrawSphere(pos, r, 30, 30, Color(255, 255, 255, 32))

	for _,v in ipairs(ents.FindInSphere(pos, radius)) do
		if v:IsPlayer() then
			local mins, maxs = v:GetCollisionBounds()
			local ang = v:GetAngles()
			ang.p = 0
			render.DrawWireframeBox(v:GetPos(), ang, mins, maxs, color_red, false)
		end
	end
end)

local pan

function gmpanel.quick.close()
	if IsValid(pan) then
		pan:Close()
	end
end

local function performInRadius()
	local e = ents.FindInSphere(LocalPlayer():GetEyeTrace().HitPos, radius)
	local players = {}
	for _,v in ipairs(e) do
		if v:IsPlayer() then
			players[#players + 1] = v:SteamID()
		end
	end

	local menu = DermaMenu()
	hook.Run('gmpanel.populateActionsMenu', menu, players)
	menu:AddSpacer()
	menu:AddOption('Объединить в группу', function()
		Derma_StringRequest('Объединить в группу', 'Укажи название группы', 'Группа', function(str)
			gmpanel.groups.groups[#gmpanel.groups.groups + 1] = {
				name = string.Trim(str),
				players = players,
			}
			gmpanel.quick.update()
			if gmpanel.groups.isOpen() then gmpanel.groups.open() end
		end)
	end):SetIcon('icon16/group_add.png')
	menu:Open()
end

local function performForGroup(self)
	local menu = DermaMenu()
	hook.Run('gmpanel.populateActionsMenu', menu, self.players)
	menu:Open()
end

local function build(w, h, x, y)
	gmpanel.quick.close()
	pan = vgui.Create('DFrame')
	pan:SetSize(isnumber(w) and w or 250, isnumber(h) and h or ScrH() * 0.7)
	pan:SetTitle('Панель Гейм-Мастера')
	if isnumber(x) and isnumber(y) then
		pan:SetPos(x, y)
	else
		pan:AlignBottom(10)
		pan:AlignLeft(10)
	end
	pan:SetDeleteOnClose(true)
	pan:SetSizable(true)
	pan:SetMinHeight(math.max(265, 0.2 * ScrH()))
	pan:SetMinWidth(250)
	function pan:OnClose()
		showRadius = val
	end

	local scr = pan:Add('DListView')
	scr:Dock(FILL)

	local p = scr:Add('DPanel')
	p:SetTall(70)
	p:Dock(TOP)
	p:DockMargin(0, 0, 0, 10)

	octolib.label(p, 'Выполнить в радиусе от точки прицела'):DockMargin(5, 2, 0, 2)

	local pp = p:Add('DPanel', 48)
	pp:Dock(TOP)
	pp:SetPaintBackground(false)
	pp:SetTall(24)
	local btn = pp:Add('DButton')
	btn:Dock(RIGHT)
	btn:SetWide(24)
	btn:SetIcon('icon16/transmit.png')
	btn:SetText('')
	function btn:DoClick()
	end
	btn.DoClick = performInRadius

	local slider = pp:Add('DNumSlider')
	slider:Dock(FILL)
	slider:DockMargin(5, 0, 0, 0)
	slider:SetMinMax(0, 2000)
	slider:SetDecimals(1)
	slider:SetText('Радиус:')

	local show = octolib.checkBox(p, 'Показать')
	show:DockMargin(5, 5, 0, 2)
	function show:OnChange(val)
		showRadius = val
	end
	function slider:OnValueChanged(val)
		radius = val
	end

	for _,v in ipairs(gmpanel.groups.groups) do
		local b = scr:Add('DButton')
		b:Dock(TOP)
		b:SetTall(32)
		b:SetText(v.name)
		b.players = v.players
		b.DoClick = performForGroup
		b:DockMargin(0,5,0,0)
	end

	local activeScenarios = pan:Add('DPanel')
	activeScenarios:Dock(BOTTOM)
	activeScenarios:SetTall(100)

	local lbl = octolib.label(activeScenarios, 'Активные сценарии')
	lbl:DockMargin(0, 5, 0, 5)
	lbl:SetContentAlignment(5)

	local lst = activeScenarios:Add('DListView')
	lst:Dock(FILL)
	lst:AddColumn('Время'):SetWidth(20)
	lst:AddColumn('Прогресс'):SetWidth(40)
	lst:AddColumn('Название')
	lst:AddColumn('Группа')
	lst:SetHideHeaders(true)
	lst:SetMultiSelect(false)

	local function updateScenarios()
		if not IsValid(lst) then return timer.Remove('gmpanel.quick.updateScenarios') end
		lst:Clear()
		for uid, scenData in SortedPairs(gmpanel.scenarios.active) do
			local time = math.Round(timer.TimeLeft('gmpanel.scenario.' .. uid) or 0)
			lst:AddLine(time, scenData[1], scenData[2], scenData[3]).uid = uid
		end
	end
	timer.Create('gmpanel.quick.updateScenarios', 1, 0, updateScenarios)
	updateScenarios()

	function lst:OnRowRightClick(_, line)
		local uid = line.uid
		local menu = DermaMenu()
			menu:AddOption('Отменить', function()
				gmpanel.scenarios.active[uid] = nil
				timer.Remove('gmpanel.scenario.' .. uid)
				octolib.notify.show('Выполнение сценария отменено')
			end):SetIcon(octolib.icons.silk16('cross'))
		menu:Open()
	end

end

function gmpanel.quick.update()
	if not IsValid(pan) then return end
	build(pan:GetWide(), pan:GetTall(), pan:GetPos())
end

gmpanel.quick.close()

gmpanel.quick.open = build
