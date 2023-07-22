octolib.vars.init('dbg.sticknotes', {})
octogui.cmenu.stickNotes = octogui.cmenu.stickNotes or {}

local saveStickNotes = octolib.func.debounce(function()
	local newData = {}
	for uid, pnl in pairs(octogui.cmenu.stickNotes) do
		if IsValid(pnl) then
			newData[uid] = {
				x = pnl:GetX(),
				y = pnl:GetY(),
				w = pnl:GetWide(),
				h = pnl:GetTall(),
				text = pnl.text:GetValue(),
			}
		else octogui.cmenu.stickNotes[uid] = nil end
	end
	octolib.vars.set('dbg.sticknotes', newData)
end, 0.5)

local function createSticknote(uid, x, y, w, h, text)
	uid = uid or octolib.string.uuid():sub(1, 8)
	if IsValid(octogui.cmenu.stickNotes[uid]) then
		octogui.cmenu.stickNotes[uid]:Remove()
	end
	local f = vgui.Create 'DFrame'
	f:DockPadding(4, 15, 4, 4)
	f:SetKeyboardInputEnabled(false)
	f:SetMouseInputEnabled(false)
	f:MakePopup()
	f:SetSize(w or 200, h or 200)
	f:SetSizable(true)
	f:SetTitle('')
	function f:OnRemove()
		octogui.cmenu.stickNotes[uid] = nil
		saveStickNotes()
	end
	if x then f:SetX(x)
	else f:AlignLeft(20) end
	if y then f:SetY(y)
	else f:CenterVertical() end
	f.btnMinim:SetVisible(false)
	f.btnMaxim:SetVisible(false)
	f.Paint = octolib.func.zero
	octogui.cmenu.stickNotes[uid] = f

	f.OnSizeChanged = saveStickNotes
	f.oldX, f.oldY = f:GetPos()
	f.oldThink = f.Think
	function f:Think()
		self:oldThink()
		if f.oldX ~= f:GetX() or f.oldY ~= f:GetY() then
			f.oldX, f.oldY = f:GetPos()
			saveStickNotes()
		end
	end

	local e = f:Add 'DTextEntry'
	e:Dock(FILL)
	e:SetMultiline(true)
	e:SetDrawLanguageID(false)
	e:SetText(text or L.sticknote_hint)
	f.text = e
	e.PaintOffset = 4
	function e:Think()
		if vgui.CursorVisible() then
			local cx, cy = gui.MousePos()
			local wx, wy, ww, wh = f:GetBounds()
			local show = (cx >= wx and cx <= wx + ww and cy >= wy and cy <= wy + wh)
			if f:IsKeyboardInputEnabled() ~= show then
				f:SetKeyboardInputEnabled(show)
				f:SetMouseInputEnabled(show)
			end
		end
	end
	e.OnChange = saveStickNotes
end

hook.Add('Think', 'dbg.sticknotes', function()
	hook.Remove('Think', 'dbg.sticknotes')
	for uid, note in pairs(octolib.vars.get('dbg.sticknotes')) do
		createSticknote(uid, note.x, note.y, note.w, note.h, note.text)
	end
end)

octogui.cmenu.registerItem('other', 'sticknote', {
	text = L.sticknote_create,
	icon = octolib.icons.silk16('note_add'),
	action = function() createSticknote() end,
})
