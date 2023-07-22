gmpanel.groups = gmpanel.groups or {}
gmpanel.groups.groups = gmpanel.groups or {}

local pan = pan or nil

function gmpanel.groups.close()
	if IsValid(pan) then
		pan:Close()
	end
end

function gmpanel.groups.isOpen()
	return IsValid(pan)
end

local players

local function addItem(ply)
	local cont = players:Add('DPanel')
	cont:Dock(TOP)
	cont:DockMargin(0, 1, 0, 0)

	local checkBox = cont:Add('DCheckBox')
	checkBox:Dock(LEFT)
	checkBox:SetWide(24)
	players.players[#players.players+1] = {checkBox, ply:SteamID(), cont,}

	local label = cont:Add('DLabel')
	label:SetText(ply:Nick()..' ('..ply:SteamName()..')')
	label:Dock(FILL)
	label:DockMargin(5, 0, 0, 0)

	return checkBox
end

local function comparator(p1, p2)
	return p1:Nick() < p2:Nick()
end

local function openGroup(i, panel)
	local info = gmpanel.groups.groups[i] or {name = 'Группа', players = {},}

	octolib.label(panel, 'Игроки'):DockMargin(5, 5, 0, 5)
	players = panel:Add('DScrollPanel')
	players.players = {}
	players:Dock(TOP)
	players:SetTall(250)
	players:DockMargin(5, 0, 0, 5)
	local function refresh(tbl)
		local sel = {}
		if tbl ~= nil then
			for _,p in ipairs(tbl) do
				sel[p] = true
			end
		else
			for _,p in ipairs(players.players) do
				if p[1]:GetChecked() then
					sel[p[2]]= true
				end
			end
		end
		for _,p in ipairs(players.players) do
			p[3]:Remove()
		end
		players.players = {}
		-- sort players by their nicknames
		local online = player.GetAll()
		table.sort(online, comparator)
		for _,ply in ipairs(online) do
			local cb = addItem(ply)
			if sel[ply:SteamID()] ~= nil then
				cb:SetChecked(true)
			end
		end
	end
	refresh(info.players)
	local function collectSelected()
		local ans = {}
		for _,p in ipairs(players.players) do
			if p[1]:GetChecked() then
				ans[#ans+1] = p[2]
			end
		end
		return ans
	end
	local b = panel:Add('DButton')
	b:Dock(TOP)
	b:DockMargin(5, 2, 5, 5)
	b:SetTall(30)
	b:SetText('Обновить')
	b.DoClick = function() refresh() end

	local name = octolib.textEntry(panel, 'Название группы')
	name:DockMargin(5, 0, 5, 5)
	name:SetValue(info.name or 'Группа')

	b = panel:Add('DPanel')
	b:Dock(BOTTOM)
	b:DockMargin(5, 0, 5, 5)
	b:SetTall(45)
	b:SetPaintBackground(false)
	b = b:Add('DButton')
	b:Dock(RIGHT)
	b:SetText('Сохранить')
	b:SetIcon('icon16/folder.png')
	b:SizeToContentsX(60)
	function b:DoClick()
		gmpanel.groups.groups[i] = {
			name = name:GetValue() or 'Группа',
			players = collectSelected(),
		}
		gmpanel.quick.update()
		gmpanel.groups.open()
	end
end

local function swap(a, b)
	gmpanel.groups.groups[a], gmpanel.groups.groups[b] = gmpanel.groups.groups[b], gmpanel.groups.groups[a]
end

local function build()
	gmpanel.groups.close()

	pan = vgui.Create('DFrame')
	pan:SetSize(700, 500)
	pan:SetTitle('Группы')
	pan:Center()
	pan:MakePopup()
	pan:SetDeleteOnClose(true)

	local groups = pan:Add('DListView')
	groups:Dock(LEFT)
	groups:SetWide(250)
	groups:SetHideHeaders(true)
	groups:DockMargin(0, 0, 5, 0)
	groups:AddColumn(''):SetFixedWidth(32)
	groups:AddColumn(L.title)
	groups:SetDataHeight(32)
	groups:SetMultiSelect(false)

	local right = pan:Add('DPanel')
	right:Dock(FILL)

	for _,v in ipairs(gmpanel.groups.groups) do
		local icon = vgui.Create('DImage')
		icon:SetImage('octoteam/icons/group2.png')
		groups:AddLine(icon, v.name)
	end
	local icon = vgui.Create('DImage')
	icon:SetImage('octoteam/icons/round_add.png')
	groups:AddLine(icon, 'Новая группа...')

	function groups:OnRowSelected(i, row)
		right:Clear()
		openGroup(i, right)
	end

	function groups:OnRowRightClick(i, row)
		if i > #gmpanel.groups.groups then return end
		local menu = DermaMenu()
		if i > 1 then menu:AddOption('Выше', function() swap(i, i-1) gmpanel.quick.update() build() end):SetIcon('icon16/arrow_up.png') end
		if i < #gmpanel.groups.groups then menu:AddOption('Ниже', function() swap(i, i+1) gmpanel.quick.update() build() end):SetIcon('icon16/arrow_down.png') end
		menu:AddSpacer()
		menu:AddOption('Удалить', function() table.remove(gmpanel.groups.groups, k) gmpanel.quick.update() build() end):SetIcon('icon16/cancel.png')
		menu:Open()
	end
end

function gmpanel.groups.open()
	build()
end
