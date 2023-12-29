local function addElement(p, k, field)
	local p_f = p:Add 'DPanel'
	p_f:Dock(TOP)
	p_f:DockMargin(0,0,0,5)
	p_f:DockPadding(5,5,5,5)
	p_f:SetPaintBackground(false)
	function p_f:PerformLayout()
		if IsValid(self) then
			self:SizeToChildren(false, true)
		end
	end

	if field.name then
		local l = p_f:Add 'DLabel'
		l:Dock(TOP)
		l:DockMargin(5,0,5,5)
		l:SetTall(25)
		l:SetFont('octolib.normal')
		l:SetText(field.name)
	end

	if field.desc then
		local l = p_f:Add 'DLabel'
		l:Dock(TOP)
		l:DockMargin(5,0,5,0)
		l:SetText(field.desc)
		l:SetWrap(true)
		function l:PerformLayout()
			self:SizeToContentsY()
		end
	end

	if field.type == 'strShort' then
		local e = p_f:Add 'DTextEntry'
		e:Dock(TOP)
		e:SetTall(30)
		e:SetUpdateOnType(true)
		if field.numeric then e:SetNumeric(true) end
		if field.ph then e:SetPlaceholderText(field.ph) end
		e.OnKeyCode = function(e)
			e.prevCaret = e:GetCaretPos()
		end
		e.OnValueChange = function(e, val)
			if field.len and utf8.len(val) > field.len then
				local caret = e.prevCaret or utf8.len(val)
				if utf8.len(p.cache[k] or '') < field.len then
					val = utf8.sub(val, 1, field.len)
					caret = field.len
				else val = p.cache[k] or utf8.sub(val, 1, field.len) end
				e:SetText(val)
				e:SetCaretPos(caret)
			end
			e.prevVal = p.cache[k]
			val = string.Trim(val)
			p.cache[k] = val ~= '' and val or nil
			p.checkFields()
			if val ~= field.default then
				p.saved = false
			end
		end
		if field.default then
			e:SetValue(field.default)
		end
		p.updateFuncs[k] = function(val)
			if val ~= nil then e:SetValue(val)
			elseif field.default ~= nil then e:SetValue(field.default)
			else e:SetValue('') end
		end
	elseif field.type == 'strLong' then
		local e = p_f:Add 'DTextEntry'
		e:Dock(TOP)
		e:SetTall(field.tall or 200)
		e:SetUpdateOnType(true)
		e:SetMultiline(true)
		e:SetWrap(true)
		e:SetContentAlignment(7)
		if field.ph then e:SetPlaceholderText(field.ph) end
		e.OnKeyCode = function(e)
			e.prevCaret = e:GetCaretPos()
		end
		e.OnValueChange = function(e, val)
			if field.len and utf8.len(val) > field.len then
				local caret = e.prevCaret or utf8.len(val)
				if utf8.len(p.cache[k] or '') < field.len then
					val = utf8.sub(val, 1, field.len)
					caret = field.len
				else val = p.cache[k] or utf8.sub(val, 1, field.len) end
				e:SetText(val)
				e:SetCaretPos(caret)
			end
			e.prevVal = p.cache[k]
			val = string.Trim(val)
			p.cache[k] = val ~= '' and val or nil
			p.checkFields()
			if val ~= field.default then
				p.saved = false
			end
		end
		if field.default then
			e:SetValue(field.default)
		end
		p.updateFuncs[k] = function(val)
			if val ~= nil then e:SetValue(val)
			elseif field.default ~= nil then e:SetValue(field.default)
			else e:SetValue('') end
		end
	elseif field.type == 'numSlider' then
		local e = p_f:Add 'DNumSlider'
		e:Dock(TOP)
		e:DockMargin(5,5,5,5)
		e:SetTall(30)
		e:SetDecimals(field.dec or 2)
		e:SetText(field.txt or L.choose_value)
		e:SetMin(field.min or 0)
		e:SetMax(field.max or 100)
		e:SetValue(field.val or field.min or 0)
		e.OnValueChanged = function(e, val)
			p.cache[k] = val or nil
			p.checkFields()
			if val ~= field.default then
				p.saved = false
			end
		end
		if field.default then
			e:SetValue(field.default)
		end
		p.updateFuncs[k] = function(val)
			if val ~= nil then e:SetValue(val)
			elseif field.default ~= nil then e:SetValue(field.default)
			elseif field.min ~= nil then e:SetValue(field.min)
			else e:SetValue(0) end
		end
	elseif field.type == 'comboBox' then
		local e = p_f:Add 'DComboBox'
		e:Dock(TOP)
		e:SetTall(30)
		e:SetSortItems(false)
		e.OnSelect = function(e, i, v, val)
			p.cache[k] = val ~= '' and val or nil
			p.checkFields()
			if val ~= field.default then
				p.saved = false
			end
		end
		if field.opts then
			for i, v in ipairs(field.opts) do
				e:AddChoice(unpack(v))
			end
		end
		p.updateFuncs[k] = function(val)
			if val == nil then val = field.default end
			for k,v in pairs(e.Data) do
				if v == val or val == nil then
					e:ChooseOptionID(k)
					return
				end
			end
		end
	elseif field.type == 'check' then
		local e = p_f:Add 'DCheckBoxLabel'
		e:Dock(TOP)
		e:DockMargin(0,5,0,5)
		e:SetTall(30)
		e:SetChecked(field.check or false)
		e:SetText(field.txt or L.there_is)
		e.OnChange = function(e, val)
			p.cache[k] = val
			p.checkFields()
			if val ~= field.default then
				p.saved = false
			end
		end
		e:SetValue(field.default or false)
		p.updateFuncs[k] = function(val)
			if val ~= nil then e:SetValue(val)
			elseif field.default ~= nil then e:SetValue(field.default)
			else e:SetValue(false) end
		end
	elseif field.type == 'color' then
		local e = p_f:Add 'DColorMixer'
		e:Dock(TOP)
		e:DockMargin(0,5,0,5)
		e:SetTall(120)
		e:SetAlphaBar(true)
		e:SetWangs(true)
		e:SetPalette(false)
		e.ValueChanged = function(e, col)
			p.cache[k] = col
			p.checkFields()
			if col ~= field.default then
				p.saved = false
			end
		end
		e:SetColor(field.default or Color(255,255,255, 255))
		p.updateFuncs[k] = function(val)
			if val ~= nil then e:SetColor(val)
			elseif field.default ~= nil then e:SetColor(field.default)
			else e:SetColor(Color(255,255,255, 255)) end
		end
	elseif field.type == 'iconPicker' then
		local e = octolib.textEntryIcon(p_f, nil, field.path)
		e:SetTall(30)
		e:SetUpdateOnType(true)
		e.OnValueChange = function(e)
			local val = string.Trim(e:GetText())
			p.cache[k] = val ~= '' and val or nil
			p.checkFields()
			if val ~= field.default then
				p.saved = false
			end
		end
		if field.default then
			e:SetValue(field.default)
		end
		p.updateFuncs[k] = function(val)
			if val ~= nil then e:SetValue(val)
			elseif field.default ~= nil then e:SetValue(field.default)
			else e:SetValue('') end
		end
	end
end

function octolib.entries.gui(title, data, res, close)

	local f = vgui.Create('DFrame')
	f:SetSize(600, 500)
	f:Center()
	f:MakePopup()
	f:SetTitle(title)

	local l = f:Add('DListView')
	l:Dock(LEFT)
	l:DockMargin(0, 0, 5, 0)
	l:SetWide(200)
	l:AddColumn('Название')
	l:SetHideHeaders(true)
	l:SetMultiSelect(false)

	local p = f:Add 'DScrollPanel'
	p:Dock(FILL)
	p.cache = {}
	p.updateFuncs = {}
	p.saved = true

	local bp = f:Add 'DPanel'
	bp:Dock(BOTTOM)
	bp:SetTall(30)
	bp:SetPaintBackground(false)

	local entries, curID, bAdd = {}
	local function refresh(selectID)
		l:Clear()
		for i, entry in ipairs(entries) do
			local line = l:AddLine(entry[data.labelIndex])
			line.entryID = i
		end
		p:SetVisible(#l.Sorted > 0)
		bp:SetVisible(#l.Sorted > 0)
		bAdd:SetEnabled(#entries < (data.maxEntries or 10))
		l:ClearSelection()
		l:SelectItem(l.Sorted[selectID or #l.Sorted])
		curID = selectID or #l.Sorted
	end

	local function save()
		p.saved = true
		if not curID then return end

		entries[curID] = table.Copy(p.cache)
		res(entries)
		refresh(curID)
	end

	local bSave = octolib.button(bp, 'Сохранить', save)
	bSave:Dock(LEFT)
	bSave:SetWide(190)

	local bRemove = octolib.button(bp, 'Удалить', function()
		if not curID then return end

		local upd = entries[curID].__new
		table.remove(entries, curID)
		if not upd then res(entries) end
		refresh()
		p.saved = true
	end)
	bRemove:Dock(RIGHT)
	bRemove:SetWide(190)

	function p.checkFields()
		for k, field in pairs(data.fields) do
			if field.required and (not p.cache[k] or string.Trim(p.cache[k]) == '') then
				bSave:SetEnabled(false)
				bSave:SetText(L.fill_required)
				return
			end
		end

		bSave:SetEnabled(true)
		bSave:SetText('Сохранить')
	end

	for k,v in pairs(data.fields) do
		addElement(p, k, v)
	end

	for _,entry in ipairs(data.entries) do
		entries[#entries + 1] = entry
	end

	local function load(id)
		local entry = id and entries[id]
		if not entry then return end
		curID = id
		for k,v in pairs(p.updateFuncs) do
			v(entry[k])
		end
		p.saved = true
	end

	function l:OnRowSelected(i, line)
		local id = line.entryID
		if not p.saved then
			octolib.confirmDialog(f, 'Сохранить изменения?', function(b)
				p.saved = true
				if b then save() end
				load(id)
				self:ClearSelection()
				self:SelectItem(self.Sorted[id])
			end)
		else load(id) end
	end

	bAdd = octolib.button(l, 'Создать', function()
		if not curID then return end
		if not p.saved then
			octolib.confirmDialog(f, 'Сохранить изменения?', function(b)
				p.saved = true
				if b then save() end
				entries[#entries + 1] = {[data.labelIndex] = data.fields[data.labelIndex].default or 'Новая запись', __new = true}
				refresh()
			end)
		else
			entries[#entries + 1] = {[data.labelIndex] = data.fields[data.labelIndex].default or 'Новая запись', __new = true}
			refresh()
		end
	end)
	bAdd:Dock(BOTTOM)
	bAdd:SetTall(20)

	refresh()

	local oClose = f.Close
	function f:Close()
		if not p.saved then
			octolib.confirmDialog(self, 'Сохранить изменения?', function(b)
				p.saved = true
				if b then save() end
				oClose(self)
			end)
		else oClose(self) end
	end

	function f:OnClose()
		if isfunction(close) then close() end
	end

end

netstream.Hook('octolib.guiEntries', function(id, title, data)
	octolib.entries.gui(title, data, function(res)
		netstream.Start('octolib.guiEntries', id, res)
	end, function()
		netstream.Start('octolib.guiEntries.close', id)
	end)
end)
