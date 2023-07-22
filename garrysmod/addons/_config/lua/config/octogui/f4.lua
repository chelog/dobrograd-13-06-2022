CreateClientConVar('dbg_name', L.name_and_surname, true, true)
local cvModel = CreateClientConVar('dbg_model', 'models/humans/octo/male_01_01.mdl', true, true)
local cvSkin = CreateClientConVar('dbg_skin', '0', true, true)
local cvJob = CreateClientConVar('dbg_job', 'citizen', false, true)
local cvDesc = CreateClientConVar('dbg_desc', '', true, true)

local plyModels = {
	{'models/humans/octo/female_01.mdl', L.woman .. ' 1', {20}},
	{'models/humans/octo/female_02.mdl', L.woman .. ' 2', {6,21}},
	{'models/humans/octo/female_03.mdl', L.woman .. ' 3', {6,21}},
	{'models/humans/octo/female_04.mdl', L.woman .. ' 4', {6,21}},
	{'models/humans/octo/female_06.mdl', L.woman .. ' 6', {6,21}},
	{'models/humans/octo/female_07.mdl', L.woman .. ' 7', {6,21}},
	{'models/humans/octo/male_01_01.mdl', L.male .. ' 1' .. ' (' .. L.variant .. ' 1' .. ')'},
	{'models/humans/octo/male_01_02.mdl', L.male .. ' 1' .. ' (' .. L.variant .. ' 2' .. ')'},
	{'models/humans/octo/male_01_03.mdl', L.male .. ' 1' .. ' (' .. L.variant .. ' 3' .. ')'},
	{'models/humans/octo/male_02_01.mdl', L.male .. ' 2' .. ' (' .. L.variant .. ' 1' .. ')'},
	{'models/humans/octo/male_02_02.mdl', L.male .. ' 2' .. ' (' .. L.variant .. ' 2' .. ')'},
	{'models/humans/octo/male_02_03.mdl', L.male .. ' 2' .. ' (' .. L.variant .. ' 3' .. ')'},
	{'models/humans/octo/male_03_01.mdl', L.male .. ' 3' .. ' (' .. L.variant .. ' 1' .. ')'},
	{'models/humans/octo/male_03_02.mdl', L.male .. ' 3' .. ' (' .. L.variant .. ' 2' .. ')'},
	{'models/humans/octo/male_03_03.mdl', L.male .. ' 3' .. ' (' .. L.variant .. ' 3' .. ')'},
	{'models/humans/octo/male_03_04.mdl', L.male .. ' 3' .. ' (' .. L.variant .. ' 4' .. ')'},
	{'models/humans/octo/male_03_05.mdl', L.male .. ' 3' .. ' (' .. L.variant .. ' 5' .. ')'},
	{'models/humans/octo/male_03_06.mdl', L.male .. ' 3' .. ' (' .. L.variant .. ' 6' .. ')'},
	{'models/humans/octo/male_03_07.mdl', L.male .. ' 3' .. ' (' .. L.variant .. ' 7' .. ')'},
	{'models/humans/octo/male_04_01.mdl', L.male .. ' 4' .. ' (' .. L.variant .. ' 1' .. ')'},
	{'models/humans/octo/male_04_02.mdl', L.male .. ' 4' .. ' (' .. L.variant .. ' 2' .. ')'},
	{'models/humans/octo/male_04_03.mdl', L.male .. ' 4' .. ' (' .. L.variant .. ' 3' .. ')'},
	{'models/humans/octo/male_04_04.mdl', L.male .. ' 4' .. ' (' .. L.variant .. ' 4' .. ')'},
	{'models/humans/octo/male_05_01.mdl', L.male .. ' 5' .. ' (' .. L.variant .. ' 1' .. ')'},
	{'models/humans/octo/male_05_02.mdl', L.male .. ' 5' .. ' (' .. L.variant .. ' 2' .. ')'},
	{'models/humans/octo/male_05_03.mdl', L.male .. ' 5' .. ' (' .. L.variant .. ' 3' .. ')'},
	{'models/humans/octo/male_05_04.mdl', L.male .. ' 5' .. ' (' .. L.variant .. ' 4' .. ')'},
	{'models/humans/octo/male_05_05.mdl', L.male .. ' 5' .. ' (' .. L.variant .. ' 5' .. ')'},
	{'models/humans/octo/male_06_01.mdl', L.male .. ' 6' .. ' (' .. L.variant .. ' 1' .. ')'},
	{'models/humans/octo/male_06_02.mdl', L.male .. ' 6' .. ' (' .. L.variant .. ' 2' .. ')'},
	{'models/humans/octo/male_06_03.mdl', L.male .. ' 6' .. ' (' .. L.variant .. ' 3' .. ')'},
	{'models/humans/octo/male_06_04.mdl', L.male .. ' 6' .. ' (' .. L.variant .. ' 4' .. ')'},
	{'models/humans/octo/male_06_05.mdl', L.male .. ' 6' .. ' (' .. L.variant .. ' 5' .. ')'},
	{'models/humans/octo/male_07_01.mdl', L.male .. ' 7' .. ' (' .. L.variant .. ' 1' .. ')'},
	{'models/humans/octo/male_07_02.mdl', L.male .. ' 7' .. ' (' .. L.variant .. ' 2' .. ')'},
	{'models/humans/octo/male_07_03.mdl', L.male .. ' 7' .. ' (' .. L.variant .. ' 3' .. ')'},
	{'models/humans/octo/male_07_04.mdl', L.male .. ' 7' .. ' (' .. L.variant .. ' 4' .. ')'},
	{'models/humans/octo/male_07_05.mdl', L.male .. ' 7' .. ' (' .. L.variant .. ' 5' .. ')'},
	{'models/humans/octo/male_07_06.mdl', L.male .. ' 7' .. ' (' .. L.variant .. ' 6' .. ')'},
	{'models/humans/octo/male_08_01.mdl', L.male .. ' 8' .. ' (' .. L.variant .. ' 1' .. ')'},
	{'models/humans/octo/male_08_02.mdl', L.male .. ' 8' .. ' (' .. L.variant .. ' 2' .. ')'},
	{'models/humans/octo/male_08_03.mdl', L.male .. ' 8' .. ' (' .. L.variant .. ' 3' .. ')'},
	{'models/humans/octo/male_08_04.mdl', L.male .. ' 8' .. ' (' .. L.variant .. ' 4' .. ')'},
	{'models/humans/octo/male_09_01.mdl', L.male .. ' 9' .. ' (' .. L.variant .. ' 1' .. ')'},
	{'models/humans/octo/male_09_02.mdl', L.male .. ' 9' .. ' (' .. L.variant .. ' 2' .. ')'},
	{'models/humans/octo/male_09_03.mdl', L.male .. ' 9' .. ' (' .. L.variant .. ' 3' .. ')'},
	{'models/humans/octo/male_09_04.mdl', L.male .. ' 9' .. ' (' .. L.variant .. ' 4' .. ')'},
}

-- defkey, cvar, userinfo, name
local k_list = {
	{L.character},
	{KEY_G, 'cl_dbg_key_look', false, L.look},
	{KEY_LALT, 'cl_dbg_key_freeview', false, L.freeview},
	{MOUSE_MIDDLE, 'cl_dbg_key_sights', false, 'Смотреть в прицел'},
	{KEY_C, 'cl_dbg_key_bend', false, 'Целиться из-за угла'},
	{KEY_V, 'radio_bind_key', false, L.speak_in_radio},
	{KEY_H, 'dbg_emotions_key', false, 'Меню эмоций'},

	{L.car},
	{KEY_W, 'cl_simfphys_keyforward', true, L.key_w},
	{KEY_S, 'cl_simfphys_keyreverse', true, L.key_s},
	{KEY_A, 'cl_simfphys_keyleft', true, L.key_a},
	{KEY_D, 'cl_simfphys_keyright', true, L.key_d},
	{KEY_I, 'cl_simfphys_keyengine', true, L.key_i},
	{KEY_LALT, 'cl_simfphys_keyclutch', true, L.key_lalt},
	{KEY_LSHIFT, 'cl_simfphys_keywot', true, L.key_lshift},
	{MOUSE_LEFT, 'cl_simfphys_keygearup', true, L.key_mouse_left},
	{MOUSE_RIGHT, 'cl_simfphys_keygeardown', true, L.key_mouse_right},
	{KEY_SPACE, 'cl_simfphys_keyhandbrake', true, L.key_space},
	{KEY_R, 'cl_simfphys_keyhandbrake_toggle', true, L.key_r},
	{MOUSE_MIDDLE, 'cl_simfphys_keymousesteer', true, L.key_mouse_middle},
	{KEY_F, 'cl_simfphys_lights', true, L.key_f},
	{KEY_H, 'cl_simfphys_keyhorn', true, L.key_h},
	{KEY_M, 'cl_simfphys_emssiren', true, L.key_m},
	{KEY_N, 'cl_simfphys_emslights', true, L.key_n},
	{KEY_COMMA, 'cl_simfphys_key_turnmenu', true, L.key_comma},
	{KEY_J, 'cl_simfphys_key_lock', true, L.key_j},
	{KEY_LCONTROL, 'cl_simfphys_key_mirror', false, L.key_lcontrol},
	{KEY_B, 'cl_simfphys_key_belt', true, L.key_b},
	{KEY_V, 'cl_simfphys_special', true, 'Лебедка тягача'},
}
for _, v in ipairs(k_list) do
	if isnumber(v[1]) then
		CreateClientConVar(v[2], v[1], true, v[3])
	end
end

CreateClientConVar('cl_octolib_sticky_handbrake', '1', true, true)
CreateClientConVar('cl_dbg_turnsignaloff', '1', true, true)
CreateClientConVar('dbg_emotions_key', KEY_H, true)
CreateClientConVar('cl_dbg_voiceicon', '1', true)
CreateClientConVar('cl_dbg_enter', '1', true, true)
CreateClientConVar('cl_dbg_alcohol_effect', '1', true, true)

hook.Add('PlayerButtonDown', 'dbg-emotions.bind', function(ply, key)
	if key ~= GetConVar('dbg_emotions_key'):GetInt() then return end

	local opts = {{ 'Нейтральность', nil, function() netstream.Start('player-flex', {}) end }}
	for _, row in ipairs(octolib.vars.get('faceposes') or {}) do
		table.insert(opts, { row.name, nil, function()
			netstream.Start('player-flex', row.flexes)
		end })
	end
	octogui.circularMenu(opts)
end)

local function buildBinder(parent, data)

	local cv = GetConVar(data[2])

	local p = parent:Add 'DPanel'
	p:SetSize(400, 40)

	local b = p:Add 'DBinder'
	b:Dock(RIGHT)
	b:SetWide(80)
	b:SetValue(cv:GetInt() or data[1])
	function b:SetSelectedNumber(num)
		self.m_iSelectedNumber = num
		self:ConVarChanged(num)
		self:UpdateText()
		self:OnChange(num)
		cv:SetInt(num)
	end

	local l = p:Add 'DLabel'
	l:Dock(FILL)
	l:DockMargin(8, 0, 0, 0)
	l:SetContentAlignment(4)
	l:SetText(data[4])

	function p:Reset()
		b:SetValue(data[1])
	end

	return p

end

local function paintIconInCenter(self, w, h)
	local mat = self:GetMaterial()
	local matW, matH = mat:Width(), mat:Height()
	surface.SetMaterial(mat)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect((w-matW) / 2, (h-matH) / 2, matW, matH)
end

-- FANCY CHECKBOX WITH DESCRIPTION
local function cbLayout(self)
	local x = self.m_iIndent or 0
	self.Button:SetSize(15, 15)
	self.Button:SetPos(x, math.floor((self:GetTall() - self.Button:GetTall()) / 2))
	self.Label:SizeToContents()
	self.Label:SetPos(x + self.Button:GetWide() + 9, math.floor((self:GetTall() - self.Label:GetTall()) / 2) - 1)
end
local function sizeToContents(self)
	self:SizeToChildren(false, true)
end
local function fancifyCheckbox(p, cb, desc)
	local cont = p:Add 'DPanel'
	cont:Dock(TOP)
	cont:SetPaintBackground(false)
	cont:DockMargin(0, 8, 0, 8)
	cont.PerformLayout = sizeToContents

	cb:SetParent(cont)
	cb.PerformLayout = cbLayout
	cb:InvalidateLayout(true)
	if not desc then return cb end

	local lbl = octolib.label(cont, desc)
	lbl:DockMargin(28, -5, 0, 7)
	lbl:SetMultiline(true)
	lbl:SetWrap(true)
	lbl:SetAutoStretchVertical(true)
	lbl:SetAlpha(100)

	return cb
end
local function fancyCheckbox(p, title, desc)
	return fancifyCheckbox(p, octolib.checkBox(p, title), desc)
end
local function fancyVarCheckbox(p, var, title, desc)
	return fancifyCheckbox(p, octolib.vars.checkBox(p, var, title), desc)
end

-- FANCY NUMSLIDER WITH DESCRIPTION
local function slider_pl(self)
	self.Label:SetWide(15)
end
local function fancyNumSlider(p, title, desc, min, max, prc)
	local cont = p:Add 'DPanel'
	cont:Dock(TOP)
	cont:SetPaintBackground(false)
	cont:DockMargin(0, 8, 0, 8)
	cont.PerformLayout = sizeToContents

	local t = octolib.label(cont, title)
	t:SetAutoStretchVertical(true)
	if desc then
		local d = octolib.label(cont, desc)
		d:SetMultiline(true)
		d:SetWrap(true)
		d:SetAlpha(100)
		d:DockMargin(5, 3, 0, 5)
		d:SetAutoStretchVertical(true)
	end

	local sl = octolib.slider(cont, '↔', min, max, prc)
	sl:DockMargin(0, -7, 0, 0)
	sl.PerformLayout = slider_pl

	return sl
end

octogui.reloadGovorilka = octogui.reloadGovorilka or octolib.func.zero

local options = {{
	id = 'character',
	name = L.character,
	icon = Material('octoteam/icons/man_m.png'),
	build = function(f)
		f:SetSize(800, 600)
		local ply = LocalPlayer()
		local skinCount = 1

		local l = vgui.Create 'DLabel'
		l:SetParent(f)
		l:SetPos(13, 33)
		l:SetSize(250, 30)
		l:SetText(L.view)
		l:SetFont('f4.normal')

		local modelPnl = vgui.Create 'DPanel'
		modelPnl:SetParent(f)
		modelPnl:Dock(LEFT)
		modelPnl:DockMargin(5,35,5,5)
		modelPnl:SetWide(250)

		local mdl = vgui.Create 'DModelPanel'
		mdl:SetParent(modelPnl)
		mdl:Dock(FILL)
		mdl:SetCamPos(Vector(90,0,55))
		mdl:SetLookAng(Angle(10,180,0))
		mdl:SetFOV(25)
		mdl:SetCursor('none')
		function mdl:LayoutEntity(mdl)
			mdl:SetAngles(Angle(0, 5, 0))
			mdl.GetPlayerColor = function() return ply:GetPlayerColor() end
			return
		end
		function mdl:UpdateDBGData()
			self:SetModel(cvModel:GetString())
			self.Entity:SetSkin(cvSkin:GetInt())
			skinCount = self.Entity:SkinCount()
		end
		mdl:UpdateDBGData()

		local pnl = vgui.Create 'DPanel'
		pnl:SetParent(f)
		pnl:Dock(LEFT)
		pnl:DockPadding(5, 5, 5, 5)
		pnl:SetWide(250)
		pnl:SetPaintBackground(false)

		do -- name
			local l = vgui.Create 'DLabel'
			l:SetParent(pnl)
			l:Dock(TOP)
			l:DockMargin(5,0,5,0)
			l:SetTall(30)
			l:SetText(L.name_character)
			l:SetFont('f4.normal')

			local e = vgui.Create 'DTextEntry'
			e:SetParent(pnl)
			e:Dock(TOP)
			e:DockMargin(5,5,5,20)
			e:SetTall(20)
			e:SetDrawLanguageID(false)
			e:SetConVar('dbg_name')
			e:SetUpdateOnType(true)
			e.OnValueChange = function(self, text)
				local oldC = self:GetCaretPos()
				local oldLen = utf8.len(self:GetText())
				text = utf8.sub(text, 1, 35)
				self:SetText(octolib.string.camel(octolib.string.stripNonWord(text)) .. (text:endsWith(' ') and ' ' or ''))
				self:SetCaretPos(oldC - (utf8.len(self:GetText()) ~= oldLen and 1 or 0))
			end
			e.PaintOffset = 5

			f.e_name = e
		end

		do -- short description
			if (cvDesc:GetString() or '') ~= '' then
				octolib.vars.set('dbg_desc', cvDesc:GetString())
				cvDesc:SetString('')
			end

			local e, l = octolib.textEntry(pnl, L.desc_appereance)
			e:SetDrawLanguageID(false)
			e:SetText(octolib.vars.get('dbg_desc') or '')
			l:SetTall(30)
			l:SetFont('f4.normal')
			l:DockMargin(5,0,5,0)
			e:DockMargin(5,5,5,20)
			e:SetUpdateOnType(true)
			function e:OnValueChange(text)
				local oldC = self:GetCaretPos()
				local oldLen = utf8.len(self:GetText())
				text = utf8.sub(text, 1, 350)
				text = octolib.string.stripNonWord(text, ',:%.0-9-;%(%)%/%"%\'a-zA-Z')
				self:SetText(text)
				self:SetCaretPos(oldC - (utf8.len(self:GetText()) ~= oldLen and 1 or 0))
				octolib.vars.set('dbg_desc', text)
			end
			e.PaintOffset = 5

			f.e_desc = e
		end

		do -- model
			local l = vgui.Create 'DLabel'
			l:SetParent(pnl)
			l:Dock(TOP)
			l:DockMargin(5,0,5,0)
			l:SetTall(30)
			l:SetText(L.appearance)
			l:SetFont('f4.normal')

			local ep = pnl:Add 'DPanel'
			ep:SetPaintBackground(false)
			ep:Dock(TOP)
			ep:DockMargin(0,0,0,15)
			ep:SetTall(30)

			local epb = ep:Add 'DPanel'
			epb:SetPaintBackground(false)
			epb:Dock(RIGHT)
			epb:DockMargin(5,0,0,0)
			epb:SetWide(20)

			local e = ep:Add 'DComboBox'
			e:Dock(FILL)
			e:SetSortItems(false)
			for _, v in ipairs(plyModels) do
				e:AddChoice(v[2], {v[1], v[3]}, v[1] == cvModel:GetString())
			end
			function e:OnSelect(i, v, data)
				cvModel:SetString(data[1])
				if cvSkin:GetInt() > skinCount - 1 or (istable(data[2]) and table.HasValue(data[2], cvSkin:GetInt())) then
					cvSkin:SetInt(0)
				end
				mdl:UpdateDBGData()
				f.e_skin:UpdateDBGData(data[2])
			end

			local b1 = epb:Add 'DButton'
			b1:Dock(TOP)
			b1:SetTall(14)
			b1:SetFont('dbg-icons2')
			b1:SetText(utf8.char(0xf077))
			b1:SetPaintBackground(false)
			function b1:DoClick()
				local newID = e:GetSelectedID() - 1
				if newID < 1 then newID = #plyModels end
				e:ChooseOptionID(newID)
			end

			local b2 = epb:Add 'DButton'
			b2:Dock(BOTTOM)
			b2:SetTall(14)
			b2:SetFont('dbg-icons2')
			b2:SetText(utf8.char(0xf078))
			b2:SetPaintBackground(false)
			function b2:DoClick()
				local newID = e:GetSelectedID() + 1
				if newID > #plyModels then newID = 1 end
				e:ChooseOptionID(newID)
			end

			f.e_model = e
		end

		do -- skin
			local l = vgui.Create 'DLabel'
			l:SetParent(pnl)
			l:Dock(TOP)
			l:DockMargin(5,0,5,0)
			l:SetTall(30)
			l:SetText(L.skin)
			l:SetFont('f4.normal')

			local ep = pnl:Add 'DPanel'
			ep:SetPaintBackground(false)
			ep:Dock(TOP)
			ep:DockMargin(0,0,0,15)
			ep:SetTall(30)

			local epb = ep:Add 'DPanel'
			epb:SetPaintBackground(false)
			epb:Dock(RIGHT)
			epb:DockMargin(5,0,0,0)
			epb:SetWide(20)

			local e = ep:Add 'DComboBox'
			e:Dock(FILL)
			e:SetSortItems(false)
			function e:OnSelect(i, v, data)
				cvSkin:SetInt(data)
				mdl:UpdateDBGData()
			end
			function e:UpdateDBGData(excluded)
				self:Clear()
				for i = 0, skinCount - 1 do
					if not istable(excluded) or not table.HasValue(excluded, i) then
						self:AddChoice(L.skin2 .. i + 1, i, i == cvSkin:GetInt())
					end
				end
			end
			e:UpdateDBGData()

			local b1 = epb:Add 'DButton'
			b1:Dock(TOP)
			b1:SetTall(14)
			b1:SetFont('dbg-icons2')
			b1:SetText(utf8.char(0xf077))
			b1:SetPaintBackground(false)
			function b1:DoClick()
				local newID = e:GetSelectedID() - 1
				if newID < 1 then newID = skinCount end
				e:ChooseOptionID(newID)
			end

			local b2 = epb:Add 'DButton'
			b2:Dock(BOTTOM)
			b2:SetTall(14)
			b2:SetFont('dbg-icons2')
			b2:SetText(utf8.char(0xf078))
			b2:SetPaintBackground(false)
			function b2:DoClick()
				local newID = e:GetSelectedID() + 1
				if newID > skinCount then newID = 1 end
				e:ChooseOptionID(newID)
			end

			f.e_skin = e
		end

		do -- job
			local l = vgui.Create 'DLabel'
			l:SetParent(pnl)
			l:Dock(TOP)
			l:DockMargin(5,0,5,0)
			l:SetTall(30)
			l:SetText(L.citizen_work)
			l:SetFont('f4.normal')

			local e = vgui.Create 'DComboBox'
			e:SetParent(pnl)
			e:Dock(TOP)
			e:DockMargin(0,0,0,15)
			e:SetTall(30)
			e:SetSortItems(false)
			e.jobs = {}
			for _, job in ipairs(RPExtraTeams) do
				if not job.noPreference and (not job.hidden or isfunction(job.customCheck) and select(1, job.customCheck(ply))) then
					e:AddChoice(job.name, job.command, job.command == cvJob:GetString())
					table.insert(e.jobs, job)
				end
			end
			function e:OnSelect(i, v, data)
				cvJob:SetString(data)
			end

			cvars.RemoveChangeCallback('dbg_job', 'dbg_job.change.listener')
			cvars.AddChangeCallback('dbg_job', function(name, old, new)
				local newj = DarkRP.getJobByCommand(new)
				if not newj then cvJob:SetString(old) return end
				if not newj.customCheck then return end
				local a, b = newj.customCheck(ply)
				if not a then cvJob:SetString(old) return end
				e:SetValue(newj.name)
			end, 'dbg_job.change.listener')

			local oldOpen = e.OpenMenu
			function e:OpenMenu()
				oldOpen(self)
				for k, but in pairs(self.Menu:GetCanvas():GetChildren()) do
					local job = self.jobs[k]
					local limit = job.max == 0 or team.NumPlayers(job.team) < math.ceil(player.GetCount() * job.max)
					if not limit then
						but:SetEnabled(false)
						but:SetColor(Color(160,160,160))
						but:SetText(but:GetText() .. L.limit_hint)
					elseif isfunction(job.customCheck) then
						local can, reason = job.customCheck(ply)
						if not can then
							if not reason then reason = L.reason_unavailable end
							if reason:find(L.reason_find_dobro) then reason = L.reason_dobro end
							if reason:find(L.reason_play) then reason = L.need_play .. reason:gsub('[^%d]', '') .. 'ч' end
							but:SetEnabled(false)
							but:SetColor(Color(160,160,160))
							but:SetText(but:GetText() .. ' (' .. reason .. ')')
						end
					end
					but:SetIcon(octolib.icons.silk16(job.icon or 'error'))
				end
			end

			f.e_job = e
		end

		do -- voice
			local l = vgui.Create 'DLabel'
			l:SetParent(pnl)
			l:Dock(TOP)
			l:DockMargin(5,0,5,0)
			l:SetTall(30)
			l:SetText(L.voice)
			l:SetFont('f4.normal')

			local e = vgui.Create 'DComboBox'
			e:SetParent(pnl)
			e:Dock(TOP)
			e:DockMargin(0,0,0,15)
			e:SetTall(30)
			e:SetSortItems(false)
			function octogui.reloadGovorilka()
				if not IsValid(e) then return end
				if ply:GetNetVar('os_govorilka') then
					e:SetEnabled(true)
					e:SetValue(ply:GetVoiceName())
					for _, add in ipairs(govorilka.voices) do
						e:AddChoice(add.ru_name, add.en_name)
					end
					function e:OnSelect(_, _, name)
						netstream.Start('govorilka.changeVoice', name)
						RunConsoleCommand('cl_govorilka_voice', name)
					end
				else
					e:SetValue(L.buy_govorilka)
					e:SetEnabled(false)
				end
			end
			octogui.reloadGovorilka()
		end

		do -- respawn
			local cont = vgui.Create 'DPanel'
			cont:SetParent(pnl)
			cont:Dock(BOTTOM)
			cont:DockPadding(5,5,5,5)
			cont:SetTall(85)

			local l = vgui.Create 'DLabel'
			l:SetParent(cont)
			l:Dock(TOP)
			l:DockMargin(5,0,5,0)
			l:SetTall(40)
			l:SetWrap(true)

			local e = vgui.Create 'DButton'
			e:SetParent(cont)
			e:Dock(TOP)
			e:DockMargin(0,5,0,0)
			e:SetTall(30)
			e:SetEnabled(true)
			function e:DoClick()
				netstream.Start('dbg-char.respawn', not cont.state)
			end

			cont.state = false -- is respawn mode active
			cont.UpdateDBGData = function(self)
				l:SetText(self.state and L.run_in_discreet_place or L.settings_in_respawn )
				e:SetText(self.state and L.cancel_changes or L.change_character)
			end
			netstream.Hook('dbg-char.updateState', function(state)
				cont.state = state
				cont:UpdateDBGData()
			end)
			cont:UpdateDBGData()

		end

		local pnl2 = vgui.Create 'DPanel'
		pnl2:SetParent(f)
		pnl2:Dock(FILL)
		pnl2:DockPadding(5, 5, 5, 5)
		pnl2:SetPaintBackground(false)

		do -- description
			local l = vgui.Create 'DLabel'
			l:SetParent(pnl2)
			l:Dock(TOP)
			l:DockMargin(5,0,5,0)
			l:SetTall(30)
			l:SetText(L.desc_character)
			l:SetFont('f4.normal')

			local e = vgui.Create 'DTextEntry'
			e:SetParent(pnl2)
			e:Dock(FILL)
			e:DockMargin(5,5,5,5)
			e:SetTall(30)
			e:SetMultiline(true)
			e:SetText(L.working_at)
			e:SetEnabled(false)
			e.PaintOffset = 5

			f.e_fulldesc = e
		end
	end,
},{
	id = 'shop',
	name = L.shop,
	icon = Material('octoteam/icons/shop.png'),
	build = function(f)
		octoinv.pnlShop:SetVisible(true)
		octoinv.pnlShop:SetPos(0, 19)
		octoinv.pnlShop.btnClose:SetVisible(false)
		f:DockPadding(0, 0, 0, 0)
		f:Add(octoinv.pnlShop)
		f:SizeToChildren(true, true)
		function f:OnRemove()
			octoinv.createShop()
		end
	end,
	show = function(f, st)
		if st then octoinv.updateShop() end
		octoinv.pnlShop:SetVisible(st)
	end,
},{
	id = 'craft',
	name = L.directory,
	icon = Material('octoteam/icons/blueprint.png'),
	build = function(f)
		if not IsValid(octoinv.helpPnl) then octoinv.initHelp() end

		octoinv.helpPnl:SetVisible(true)
		octoinv.helpPnl:SetPos(3, 22)
		f:DockPadding(3, 22, 3, 3)
		f:Add(octoinv.helpPnl)
		f:SizeToChildren(true, true)
		function f:OnRemove()
			octoinv.helpPnl:SetParent(vgui.GetWorldPanel())
			octoinv.helpPnl:SetVisible(false)
		end
	end,
},{
	id = 'donate',
	name = L.donate,
	icon = Material('octoteam/icons/coin_stacks.png'),
	build = function(f)
		octoshop.pnl:SetVisible(true)
		octoshop.pnl:SetPos(0, 19)
		octoshop.pnl.cl:SetVisible(false)
		f:DockPadding(0, 0, 0, 0)
		f:Add(octoshop.pnl)
		f:SizeToChildren(true, true)
		function f:OnRemove()
			octoshop.pnl:SetParent(vgui.GetWorldPanel())
			octoshop.pnl.cl:SetVisible(true)
		end
	end,
	show = function(f, st)
		if st then
			net.Start('octoshop.rInventory')
			net.SendToServer()
		end
	end,
},{
	id = 'settings',
	name = L.settings,
	icon = Material('octoteam/icons/cog.png'),
	build = function(f)
		f:SetSize(650, 500)
		f:DockPadding(0, 21, 0, 0)

		local function pl(self) self:SizeToChildren(false, true) end
		local function title(p, txt)
			local l = p:Add 'DLabel'
			l:Dock(TOP)
			l:DockMargin(0,5,0,15)
			l:SetTall(32)
			l:SetText(txt)
			l:SetContentAlignment(5)
			l:SetFont('f4.medium')
			return l
		end
		local function childPanel(p)
			local cp = p:Add 'DPanel'
			cp:Dock(TOP)
			cp:DockMargin(0, 0, 0, 5)
			cp:DockPadding(5, 5, 5, 10)
			cp.PerformLayout = pl
			return cp
		end

		local menuList = f:Add 'DListView'
		menuList:Dock(LEFT)
		menuList:SetWide(150)
		menuList:AddColumn('Icon'):SetFixedWidth(48)
		menuList:AddColumn('Name')
		menuList:SetHideHeaders(true)
		menuList:SetDataHeight(42)
		menuList:DockMargin(2, 7, 0, 3)
		menuList:SetMultiSelect(false)

		local scr
		function menuList:OnRowSelected(_, row)
			if IsValid(scr) then scr:Remove() end
			scr = f:Add 'DScrollPanel'
			scr:Dock(FILL)
			scr:DockMargin(5, 3, 5, 0)
			scr.pnlCanvas:DockPadding(20, 5, 25, 20)
			title(scr, row:GetColumnText(2))

			local container = row.build(scr)
			if IsValid(container) then
				scr:Remove()
				container:SetParent(f)
				container:Dock(FILL)
				container:DockMargin(15, 5, 5, 5)
				scr = container
			end
		end

		local function addCategory(name, icon, build)
			local iconPnl = vgui.Create 'DImage'
			iconPnl:SetImage(octolib.icons.silk32(icon))
			iconPnl.Paint = paintIconInCenter
			menuList:AddLine(iconPnl, name).build = build
		end

		addCategory('Графика', 'picture', function(p)
			local cp = childPanel(p)
			cp:DockPadding(10, 0, 10, 10)

			local e = octolib.comboBox(cp, 'Разрешение прицела', octolib.array.map({ 128, 256, 512, 1024 }, function(side)
				return { side .. 'x' .. side, side, GetConVar('octoweapons_sight_resolution'):GetInt() == side }
			end))
			e:SetSortItems(false)
			function e:OnSelect(_, _, side)
				GetConVar('octoweapons_sight_resolution'):SetInt(side)
			end

			fancyCheckbox(cp, 'Счетчик FPS', 'Показатель количества кадров в секунду в верхнем правом углу экрана'):SetConVar('cl_showfps')
			fancyCheckbox(cp, 'Размытие фона', 'Эффект размытия некоторых прозрачных частей интерфейса. Красиво, но довольно требовательно к ресурсам компьютера'):SetConVar('octolib_blur')
			fancyCheckbox(cp, '3D-скайбокс', 'Отображение неигровой зоны карты за ее пределами. Отключение может незначительно повысить производительность'):SetConVar('r_3dsky')
			fancyCheckbox(cp, 'Моя тень', 'Тень под твоим персонажем при использовании физгана, тулгкана или камеры'):SetConVar('cl_drawownshadow')
			fancyCheckbox(cp, 'Тени высокого качества', 'Отображение полных силуэтов объектов в тенях'):SetConVar('r_shadowrendertotexture')
			fancyCheckbox(cp, 'Свет высокого качества', 'Динамическое освещение, создаваемое некоторыми объектами'):SetConVar('r_dynamic')
			fancyCheckbox(cp, 'Мелкие частицы', 'Например, осколки от поверхности при попадании в нее пули'):SetConVar('r_drawflecks')
			fancyCheckbox(cp, 'Декали на объектах', 'Например, следы крови на персонажах и машинах'):SetConVar('r_drawmodeldecals')
			fancyCheckbox(cp, 'Отражение в воде', 'Отображение игрового мира в воде. Если выключить, может понадобиться перезайти на сервер'):SetConVar('r_WaterDrawReflection')
			fancyCheckbox(cp, 'Тени от фар автомобилей', 'Высокое качество освещения от фар автомобилей. Сильно влияет на производительность. Настройка применяется после включения фар'):SetConVar('cl_simfphys_shadows')

			title(p, 'Погода')

			local cp = childPanel(p)
			cp:DockPadding(10, 10, 10, 10)

			local cont = childPanel(cp)
			cont:SetPaintBackground(false)
			cont:DockMargin(0, 0, 0, 15)

			local fps = StormFox2.Menu.FPSRing()
			cont:Add(fps)
			fps:SetY(0)

			local qu = StormFox2.Menu.QualityRing()
			cont:Add(qu)
			qu:SetY(0)

			local sup = StormFox2.Menu.SupportRing()
			cont:Add(sup)
			sup:SetY(0)

			local mth = StormFox2.Menu.MThreadRing()
			cont:Add(mth)
			mth:SetY(0)

			function cont:PerformLayout(w, h)
				local maxH, sumW = 0, 0
				for _, v in ipairs(self:GetChildren()) do
					maxH = math.max(maxH, v:GetTall())
					sumW = sumW + v:GetWide()
				end
				self:SetTall(maxH)
				local x = (w-sumW) / (#self:GetChildren()+1)
				fps:SetX(x)
				qu:SetX(fps:GetX()+fps:GetWide() + x)
				sup:SetX(qu:GetX()+qu:GetWide() + x)
				mth:SetX(sup:GetX()+sup:GetWide() + x)
			end

			octolib.label(cp, 'Желаемый FPS')
			local fpsTarget = StormFox2.Menu.FPSTarget()
			cp:Add(fpsTarget)
			fpsTarget:Dock(TOP)
			fpsTarget:DockMargin(0, -15, 0, 0)
			fpsTarget.label_name:Remove()
			fpsTarget.description:Remove()

			local function shittyCheckbox(name, desc, setting)
				local cb = fancyCheckbox(cp, name, desc)
				local obj = StormFox2.Setting.GetObject(setting)
				obj:AddCallback(function(val)
					cb:SetChecked(val)
				end, cb)
				function cb:OnChange(val)
					obj:SetValue(val)
				end
			end
			shittyCheckbox('Ультра-качество', 'Добавляет ещё больше эффектов', 'quality_ultra')

			local function shittyNumSlider(name, desc, min, max, prec, setting)
				local ns = fancyNumSlider(cp, name, desc, min, max, prec)
				local obj = StormFox2.Setting.GetObject(setting)
				obj:AddCallback(function(val)
					ns:SetValue(val)
				end, cb)
				function ns:OnValueChanged(val)
					obj:SetValue(val)
				end
			end
			shittyNumSlider('Множитель темноты', 'Чем больше значение, тем темнее ночи', 0, 1, 2, 'extra_darkness_amount')
		end)

		addCategory('Геймплей', 'bricks', function(p)
			local cp = childPanel(p)
			cp:DockPadding(10, 0, 10, 10)

			fancyCheckbox(cp, L.dbg_help_login, 'Автоматически открывать F1-справку при входе на сервер'):SetConVar('dbg_help_login')
			fancyCheckbox(cp, L.voicemods, 'Возможность шептать или кричать в голосовой чат при удерживании Alt или Shift вместе с кнопкой разговора'):SetConVar('dbg_voicemods')

			if LocalPlayer():GetNetVar('halloweenTheme') then
				local cb = fancyCheckbox(cp, 'Хэллоуинская тема', 'Цвета интерфейса меняются на черно-оранжевый, как на Хэллоуин')
				function cb:OnChange(val)
					if val then
						octolib.changeSkinColor(Color(52,49,52), Color(222,132,38), 0.5)
					else
						octolib.changeSkinColor(Color(85,68,85), Color(102,170,170), 0.5)
					end
				end
			end

			fancyCheckbox(cp, 'Иконка голосового чата над головой', 'Пригодится для записи видео, но можно запутаться, кто говорит'):SetConVar('cl_dbg_voiceicon')
			fancyCheckbox(cp, 'Текст подключения игроков в чате', 'Пригодится для записи видео, но можно пропустить вход друга'):SetConVar('cl_dbg_enter')
			fancyCheckbox(cp, 'Эффект опьянения в чате', 'Если ты под воздействием алкоголя, твои сообщения в ролевом чате будут измеЕеенееЕЕны вооООт таааак'):SetConVar('cl_dbg_alcohol_effect')
			fancyCheckbox(cp, 'Эффект рыбьего глаза на глазках', 'Чем ближе человек за дверью к глазку, тем шире ты его видишь в дверном глазке. Прямо как в реальной жизни! Но может мешать'):SetConVar('cl_dbg_fisheyeonpeepholes')
			fancyCheckbox(cp, 'Отображать ники говорящих в рацию', 'Когда кто-то начнет говорить в рацию на твоей волне, слева снизу ты увидишь его ролевое имя, как в обычном Sandbox'):SetConVar('cl_dbg_talkienotifies')
		end)

		addCategory('Управление', 'keyboard', function(p)
			local l = octolib.label(p, 'В этом меню ты можешь назначить горячие клавиши. Чтобы убрать назначение, кликни правой кнопкой мыши')
			l:SetTall(35)
			l:SetContentAlignment(5)
			l:SetWrap(true)

			for _, v in ipairs(k_list) do
				if isstring(v[1]) then
					local l = p:Add 'DLabel'
					l:Dock(TOP)
					l:DockMargin(0,5,0,5)
					l:SetTall(30)
					l:SetText(v[1])
					l:SetContentAlignment(5)
					l:SetFont('f4.normal')
				else
					local b = buildBinder(p, v)
					b:Dock(TOP)
					b:SetTall(25)
					b:DockMargin(0, 0, 0, 5)
				end
			end
		end)

		addCategory('Бинды', 'key', function(p)
			local cont = vgui.Create('octolib_binds')
			local t = title(cont, 'Бинды')
			t:SetParent()
			function cont:RebuildList()
				t:SetParent()
				self:Clear()
				self:Add(t)

				for i = 1, #octolib.bindCache do
					local row = self:Add 'octolib_binds_row'
					row:SetBind(i)
				end

				octolib.button(self, 'Создать', function()
					octolib.setBind(nil, KEY_SPACE, 'chat', 'Привет!')
				end)

			end

			return cont
		end)

		addCategory('Автомобиль', 'small_car', function(p)
			local cp = childPanel(p)
			cp:DockPadding(10, 0, 10, 5)

			fancyCheckbox(cp, 'Выключать поворотники автоматически', 'При повороте в противоположную сторону выключать поворотники'):SetConVar('cl_dbg_turnsignaloff')
			fancyNumSlider(cp, 'Скорость поворота руля', 'Скорость, с которой движение мышью изменяет положение руля', 0.1, 5, 2):SetConVar('dbg_cars_ms_sensitivity')
			fancyNumSlider(cp, 'Мертвая зона руля', 'Размер области, в которой поворот считается нулевым (машина едет прямо)', 0, 0.3, 2):SetConVar('dbg_cars_ms_deadzone')
			fancyNumSlider(cp, 'Возврат руля', 'Скорость, с которой руль возвращается в положение прямо', 0, 2, 2):SetConVar('dbg_cars_ms_return')
		end)

		addCategory('Физган', 'transform_move', function(p)
			local cp = childPanel(p)
			cp:DockPadding(10, 10, 10, 10)

			fancyVarCheckbox(cp, 'hideMyBeam', 'Не показывать мне луч моего физгана', 'Другие игроки всё равно будут видеть луч твоего физгана, если тоже возьмут физган/тулган в руки')
			fancyVarCheckbox(cp, 'hidePhysgunHalos', 'Скрыть обводку предметов, взятых физганом', 'Подойдет, если ты хочешь уменьшить количество мистики в этом городе. Иногда может увеличить производительность')

			local t = octolib.label(cp, 'Цвет физгана')
			t:SetFont('f4.normal')
			t.PerformLayout = sizeToContents
			local d = octolib.label(cp, 'Доступно только обладателям плюшки "Строитель"')
			d:SetMultiline(true)
			d:SetWrap(true)
			d:DockMargin(5, 5, 0, 5)
			d.PerformLayout = sizeToContents
			local cb = octolib.vars.colorPicker(cp, 'physgunColor', nil, false, true)
			cb:DockMargin(5,5,5,5)
			cb:SetTall(200)
		end)

		addCategory('Другое', 'cog', function(p)
			p:GetCanvas():Clear()

			title(p, 'Залипание')
			local cp = childPanel(p)
			cp:DockPadding(10, 10, 10, 10)

			local lbl = octolib.label(cp, 'Двойное нажатие на клавиши заменяет их удерживание')
			lbl:SetMultiline(true)
			lbl:SetWrap(true)
			lbl:SetAutoStretchVertical(true)
			lbl:SetAlpha(100)
			lbl:DockMargin(0, 0, 0, 5)

			octolib.checkBox(cp, 'Приседание'):SetConVar('cl_octolib_sticky_duck')
			octolib.checkBox(cp, 'Прицел'):SetConVar('cl_octolib_sticky_attack2')
			octolib.checkBox(cp, 'Ручной тормоз'):SetConVar('cl_octolib_sticky_handbrake')

			title(p, 'Цвет прицела')
			local cp = childPanel(p)
			local cb = octolib.vars.colorPicker(cp, 'dbg-crosshair.color', nil, false, true)
			cb:DockMargin(5,5,5,5)
			cb:SetTall(200)

			title(p, 'Фиксы')
			local cp = childPanel(p)
			cp:DockPadding(5, 5, 5, 5)
			local function fix(title, click)
				local b = cp:Add 'DButton'
				b:Dock(TOP)
				b:DockMargin(0,0,0,5)
				b:SetTall(30)
				b:SetText(title)
				b.DoClick = click
			end
			fix('Отпустить все кнопки залипания', function() RunConsoleCommand('-duck') RunConsoleCommand('-attack2') end)
			fix('Остановить все звуки', function() RunConsoleCommand('stopsound') end)
			fix('Перезагрузить F4-меню', function() RunConsoleCommand('octogui_reloadf4') end)
		end)

		menuList:SelectFirstItem()

	end,
}}

hook.Add('octogui.f4-tabs', 'f4', function()

	for i, opt in ipairs(options) do
		opt.order = i + 10
		octogui.addToF4(opt)
	end

end)
