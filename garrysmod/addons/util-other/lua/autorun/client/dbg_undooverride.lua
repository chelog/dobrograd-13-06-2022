local clientUndos = {}
local shouldUpdate = true
undo = undo or {}

function undo.GetTable()
	return clientUndos
end

local function updateUI()

	local panel = controlpanel.Get('Undo')
	if not IsValid(panel) then return end

	panel:ClearControls()
	panel:AddControl('Header', {Description = '#spawnmenu.utilities.undo.help'})

	local box = vgui.Create('DListView')
	panel:AddPanel(box)
	box:Dock(TOP)
	box:SetTall(500)
	box:AddColumn('1')
	box:SetHideHeaders(true)
	function box:OnRowSelected(_, pnl)
		RunConsoleCommand('gmod_undonum', pnl.key)
	end

	local limit = 100
	for _,v in ipairs(clientUndos) do

		local item = box:AddLine(tostring(v.name))
		item.key = tostring(v.key)

		limit = limit - 1
		if limit <= 0 then break end

	end

end

net.Receive('Undo_AddUndo', function()
	local k = net.ReadInt(16)
	local v = net.ReadString()
	table.insert(clientUndos, 1, {key = k, name = v})
	shouldUpdate = true
end)

net.Receive('Undo_Undone', function()
	local key, newUndo = net.ReadInt(16), {}
	for _,v in ipairs(clientUndos) do
		if v.key ~= key then
			newUndo[#newUndo+1] = v
		end
	end
	clientUndos = newUndo
	newUndo = nil
	shouldUpdate = true
end)

hook.Add('PostReloadToolsMenu', 'BuildUndoUI', function()
	local undoPanel = controlpanel.Get('Undo')
	if not IsValid(undoPanel) then return end
	function undoPanel:Think()
		if shouldUpdate then
			timer.Simple(0, updateUI)
			shouldUpdate = false
		end
	end
end)
