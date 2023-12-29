surface.CreateFont('octolib.normal', {
	font = 'Calibri',
	extended = true,
	size = 27,
	weight = 350,
})

function octolib.request.open(data, done)

	local f = vgui.Create 'DFrame'
	f:SetBackgroundBlur(true)
	f:SetSize(400, 55)
	f:SetTitle(L.request)
	f:SetAlpha(1)
	f:Center()
	f:MakePopup()
	function f.btnClose:DoClick()
		done(false)
		f:Remove()
	end

	local p = f:Add 'DScrollPanel'
	p:Dock(FILL)
	timer.Simple(0.5, function()
		if not IsValid(f) then return end
		local x, y = f:GetPos()
		local h = math.min(p.pnlCanvas:GetTall() + 70, 600)
		f:SizeTo(400, h, 0.5, 0, 0.5)
		f:MoveTo(x, (ScrH() - h) / 2, 0.5, 0, 0.5)
		f:AlphaTo(255, 0.5)
	end)

	local b = f:Add 'DButton'
	b:Dock(BOTTOM)
	b:DockMargin(0,4,0,0)
	b:SetTall(30)
	b:SetText(L.send)

	local cache, empty = {}, {}
	local function checkFields()
		for k, field in pairs(data) do
			if field.required and empty[k] then
				b:SetEnabled(false)
				b:SetText(L.fill_required)
				return
			end
		end

		b:SetEnabled(true)
		b:SetText(L.ready)
	end

	function b:DoClick()
		done(cache)
		f:Remove()
	end

	for k, field in pairs(data) do
		local p_f = p:Add 'DPanel'
		p_f:Dock(TOP)
		p_f:DockMargin(0,0,0,5)
		p_f:DockPadding(5,5,5,5)
		function p_f:PerformLayout()
			timer.Simple(0.2, function()
				if IsValid(self) then
					self:SizeToChildren(false, true)
				end
			end)
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
			e.OnValueChange = function(e)
				local val = string.Trim(e:GetText())
				cache[k] = val ~= '' and val or nil
				empty[k] = (not cache[k] or string.Trim(cache[k]) == '')
				checkFields()
			end
			if field.default then
				e:SetValue(field.default)
			end
		elseif field.type == 'strLong' then
			local e = p_f:Add 'DTextEntry'
			e:Dock(TOP)
			e:SetTall(200)
			e:SetUpdateOnType(true)
			e:SetMultiline(true)
			e:SetWrap(true)
			e:SetContentAlignment(7)
			if field.ph then e:SetPlaceholderText(field.ph) end
			e.OnValueChange = function(e)
				local val = string.Trim(e:GetText())
				cache[k] = val ~= '' and val or nil
				empty[k] = (not cache[k] or string.Trim(cache[k]) == '')
				checkFields()
			end
			if field.default then
				e:SetValue(field.default)
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
				cache[k] = val or nil
				empty[k] = (not cache[k])
				checkFields()
			end
			if field.default then
				e:SetValue(field.default)
			end
		elseif field.type == 'comboBox' then
			local e = p_f:Add 'DComboBox'
			e:Dock(TOP)
			e:SetTall(30)
			e:SetSortItems(false)
			e.OnSelect = function(e, i, v, val)
				cache[k] = val ~= '' and val or nil
				empty[k] = (not cache[k])
				checkFields()
			end
			if field.opts then
				for i, v in ipairs(field.opts) do
					e:AddChoice(unpack(v))
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
				cache[k] = val
				empty[k] = (not cache[k])
				checkFields()
			end
			e:SetValue(field.default or false)
		elseif field.type == 'checkGroup' then
			local e = p_f:Add 'DScrollPanel'
			e:Dock(TOP)
			e:SetTall(150)

			for i, data in ipairs(field.opts) do
				local check = e:Add 'DCheckBoxLabel'
				check:Dock(TOP)
				check:DockMargin(0,5,0,5)
				check:SetTall(30)
				check:SetChecked(data[3] or false)
				check:SetText(data[1])

				cache[k] = cache[k] or {}
				cache[k][data[2]] = data[3]

				local tbl = cache[k]
				check.OnChange = function(e, val)
					tbl[data[2]] = val == true or nil
					cache[k] = table.GetKeys(tbl)
					empty[k] = (not cache[k])
					checkFields()
				end
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
				cache[k] = col
				empty[k] = (not cache[k])
				checkFields()
			end
			e:SetColor(field.default or Color(255,255,255, 255))
		elseif field.type == 'player' then
			local sp = p_f:Add 'DPanel'
			sp:Dock(TOP)
			sp:DockMargin(0,5,0,5)
			sp:SetTall(30)
			sp.Paint = function() end

			local e = sp:Add 'DTextEntry'
			e:Dock(FILL)
			e:SetTall(30)
			e.OnChange = function(e)
				local val = string.Trim(e:GetText())
				cache[k] = val ~= '' and val or nil
				empty[k] = (not cache[k] or string.Trim(cache[k]) == '')
				checkFields()
			end

			local b = sp:Add 'DButton'
			b:Dock(RIGHT)
			b:DockMargin(3,3,0,3)
			b:SetWide(24)
			b:SetText('')
			b:SetImage('icon16/user_go.png')
			b.DoClick = function(b)
				local m = DermaMenu()
				for i, ply in ipairs(player.GetAll()) do
					m:AddOption(ply:Name(), function()
						e:SetValue(string.format('%s (%s)', ply:Name(), ply:SteamID()))
						e:OnChange()
					end)
				end
				m:Open()
			end
		elseif field.type == 'iconPicker' then
			local e = octolib.textEntryIcon(p_f, nil, field.path)
			e:SetTall(30)
			e:SetUpdateOnType(true)
			e.OnValueChange = function(e)
				local val = string.Trim(e:GetText())
				cache[k] = val ~= '' and val or nil
				checkFields()
			end
			if field.default then
				e:SetValue(field.default)
			end
		elseif field.type == 'item' and octoinv then
			local sp = p_f:Add 'DScrollPanel'
			sp:Dock(TOP)
			sp:SetTall(150)
			sp:SetPaintBackground(false)

			local il = sp:Add 'DIconLayout'
			il:Dock(FILL)
			il:SetSpaceX(4)
			il:SetSpaceY(4)

			local function click(pnl)
				if not field.single and cache[k] then cache[k] = octolib.array.toKeys(cache[k]) end

				if IsValid(pnl.selectedIcon) then
					pnl.selectedIcon:Remove()
					if field.single then
						cache[k] = nil
					else
						cache[k][pnl.id] = nil
					end
					if cache[k] and table.Count(cache[k]) < 1 then cache[k] = nil end
					checkFields()
				else
					if field.single then
						for _, p in ipairs(pnl:GetParent():GetChildren()) do
							if IsValid(p.selectedIcon) then p.selectedIcon:Remove() end
						end
						cache[k] = nil
					end

					local icon = pnl:Add 'DImage'
					icon:SetMouseInputEnabled(false)
					icon:SetImage('icon16/tick.png')
					icon:SetSize(16, 16)
					icon:AlignLeft(4)
					icon:AlignTop(2)
					pnl.selectedIcon = icon
					if field.single then
						cache[k] = pnl.id
					else
						cache[k] = cache[k] or {}
						cache[k][pnl.id] = true
					end
					checkFields()
				end

				if not field.single and cache[k] then cache[k] = table.GetKeys(cache[k]) end
			end

			for id, item in pairs(field.items) do
				local p = octoinv.createItemPanel(il, item)
				p.id = id
				p.DoClick = click
			end
		end

		if field.buttonURL then
			local btn = octolib.button(p_f, field.buttonText or 'Открыть', function()
				octoesc.OpenURL(field.buttonURL)
			end)
			btn:DockMargin(0,5,0,5)
		end
	end

	checkFields()

end

netstream.Hook('octolib.request', function(id, data)
	octolib.request.open(data, function(data)
		netstream.Start('octolib.request', id, data)
	end)
end)
