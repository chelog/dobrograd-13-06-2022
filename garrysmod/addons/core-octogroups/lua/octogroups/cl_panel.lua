og.tabBuilds = og.tabBuilds or {}

surface.CreateFont('og.normal', {
	font = 'Calibri',
	extended = true,
	size = 27,
	weight = 350,
})

local pnl = nil
local curGID, curTab = -1, 'Новости'

local function setupGroup(g)

	if not IsValid(pnl) then return end
	if IsValid(pnl.ps) then pnl.ps:Remove() end

	local ps = pnl:Add 'DPropertySheet'
	ps:Dock(FILL)
	pnl.ps = ps

	for i, tab in ipairs({
		'news',
		'members',
		'storage',
		'ranks',
		'settings',
	}) do
		local build = og.tabBuilds[tab]
		if build then build(ps, g) end
	end

	ps.OnActiveTabChanged = function(self, old, new) curTab = new:GetText() end
	ps:SwitchToName(curTab)

	-- octolib.fStringRequest('Снять деньги', 'Укажи сумму (деньги придут тебе в банк):', '0', function(val)
	-- 	og.addMoney(gID, tonumber('-' .. val))
	-- end, nil, 'Снять', 'Отмена')

end

local function bClick(self)
	local g = og.groupsOwn[self.gID or -1]
	if g then
		setupGroup(g)
		curGID = self.gID
	end
end

local colors = CFG.skinColors
local function bPaint(self, w, h)
	local selected = curGID == self.gID

	if selected then draw.RoundedBox(0, 0, 0, w, h, colors.bg) end
	surface.SetDrawColor(255,255,255, (self.Hovered or selected) and 255 or 150)
	surface.SetMaterial(self.icon)
	surface.DrawTexturedRect((w - 64) / 2, (h - 64) / 2, 64, 64)
end

local function pnlUpdate()

	if not IsValid(pnl) then return end

	local m = pnl.menu
	m:Clear()

	for gID, g in pairs(og.groupsOwn) do
		if not og.groupsOwn[curGID] then curGID = gID end

		local b = m:Add 'DButton'
		b:Dock(TOP)
		b:SetTall(70)
		b:SetText('')
		b.icon = Material(g.icon or octolib.icons.color('group3'))
		b.gID = gID
		b.DoClick = bClick
		b.Paint = bPaint
		b:SetTooltip(g.name or 'Group')
		if curGID == gID then b:DoClick() end
	end

end
hook.Add('octogroups.syncedOwn', 'octogroups.gui', pnlUpdate)

local function pnlBuild(f)

	pnl = f

	f:SetSize(600, 500)
	f:DockPadding(0, 20, 0, 0)

	local m = f:Add 'DScrollPanel'
	m:DockMargin(0, 4, 0, 0)
	m:Dock(LEFT)
	m:SetWide(70)
	m.pnlCanvas:DockPadding(0, 16, 0, 0)

	local col = Color(0,0,0, 80)
	function m:Paint(w, h) draw.RoundedBoxEx(4, 0, 0, w, h, col, false, false, true, false) end
	f.menu = m

	pnlUpdate()

end

hook.Add('octogui.f4-tabs', 'octogroups', function()

	octogui.addToF4 {
		id = 'groups',
		order = 11.5,
		name = 'Организации',
		icon = Material('octoteam/icons/buildings3.png'),
		build = pnlBuild,
	}

end)
octogui.reloadF4()
