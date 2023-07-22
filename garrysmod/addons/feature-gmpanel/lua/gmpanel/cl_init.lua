local permission, permissionGlobal = 'DBG: Панель ивентов', 'DBG: Расширенный доступ к панели ивентов'

gmpanel = gmpanel or {}
gmpanel.index = gmpanel.index or {}

local index = nil

function gmpanel.index.close()
	if (index ~= nil and IsValid(index)) then index:Close() end
end

local function rebuildIndex()
	gmpanel.index.close()

	index = vgui.Create('DFrame')
	index:SetSize(200, 240)
	index:SetTitle('Панель гейм-мастера')
	index:Center()
	index:MakePopup()
	index:SetDeleteOnClose(true)

	local b = index:Add('DButton')
	b:Dock(TOP)
	b:SetTall(30)
	b:DockMargin(0, 10, 0, 0)
	b:SetText('Кнопки')
	b.DoClick = gmpanel.quick.open

	b = index:Add('DButton')
	b:Dock(TOP)
	b:SetTall(30)
	b:DockMargin(0, 10, 0, 0)
	b:SetText('Группы')
	b.DoClick = gmpanel.groups.open

	b = index:Add('DButton')
	b:Dock(TOP)
	b:SetTall(30)
	b:DockMargin(0, 10, 0, 0)
	b:SetText('Действия')
	b.DoClick = gmpanel.actions.open

	b = index:Add('DButton')
	b:Dock(TOP)
	b:SetTall(30)
	b:DockMargin(0, 10, 0, 0)
	b:SetText('Сценарии')
	b.DoClick = gmpanel.scenarios.open

	b = index:Add('DButton')
	b:Dock(TOP)
	b:SetTall(30)
	b:DockMargin(0, 10, 0, 0)
	b:SetText('Настройки')
	b.DoClick = gmpanel.global.open
end

function gmpanel.index.open()
	rebuildIndex()
end

concommand.Add('gmpanel', function()
	if not LocalPlayer():query(permission) and not LocalPlayer():query(permissionGlobal)  then
		octolib.notify.show('warning', L.not_have_access)
		return
   end
	rebuildIndex()
end)

concommand.Add('+gmpanel', function()
	if not LocalPlayer():query(permission) and not LocalPlayer():query(permissionGlobal)  then
		octolib.notify.show('warning', L.not_have_access)
		return
   end
	rebuildIndex()
end)

concommand.Add('-gmpanel', function()
	gmpanel.index.close()
end)
