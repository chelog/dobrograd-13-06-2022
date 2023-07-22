include('shared.lua')

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.RenderGroup 		= RENDERGROUP_BOTH

function ENT:Draw()
	self:DrawModel()
	render.DrawBubble(self, Vector(0, 0.45, 7), Angle(0, 180, 90), L.work_in_police, 200, 200)
end

net.Receive('dbg-police.menu', function(len)

	local ply = LocalPlayer()

	local f = vgui.Create 'DFrame'
	f:SetSize(400, 600)
	f:SetTitle(L.work_in_police)
	f:DockPadding(8,28,8,8)
	f:Center()
	f:MakePopup()

	do -- apply
		local l = vgui.Create 'DLabel'
		l:SetParent(f)
		l:Dock(TOP)
		l:DockMargin(5,0,5,0)
		l:SetTall(30)
		l:SetText(L.get_job)
		l:SetFont('f4.normal')

		local p = vgui.Create 'DPanel'
		p:SetParent(f)
		p:Dock(TOP)
		p:DockPadding(5, 5, 5, 5)
		p:SetTall(125)

		local l2 = vgui.Create 'DLabel'
		l2:SetParent(p)
		l2:Dock(TOP)
		l2:DockMargin(2,0,2,5)
		l2:SetTall(45)
		l2:SetWrap(true)
		l2:SetText(L.job_police)

		local c = vgui.Create 'DComboBox'
		c:SetParent(p)
		c:Dock(TOP)
		c:DockMargin(0,0,0,5)
		c:SetValue(L.career_objective)
		c:SetTall(30)
		c:SetSortItems(false)
		for i, job in ipairs(RPExtraTeams) do
			if job.police and not job.noPBoard then
				c:AddChoice(job.name, job.command)
			end
		end

		local b = vgui.Create 'DButton'
		b:SetParent(p)
		b:Dock(TOP)
		b:DockMargin(0,0,0,5)
		b:SetText(L.application_send)
		b:SetTall(30)
		b:SetEnabled(false)
		local function apply(self, d, text)
			net.Start('dbg-police.apply')
			net.WriteString(d)
			if text then net.WriteString(text) end
			net.SendToServer()

			self:SetText(L.application_sent)
			self:SetEnabled(false)
			c:SetEnabled(false)
		end

		function b:DoClick()
			local v, d = c:GetSelected()
			if d == 'chief' or d == 'mayor' then
				local stored = octolib.vars.get('dbg-police.speech.' .. d) or ''
				Derma_StringRequest('Предвыборная речь',
					'Ты собираешься избираться на очень важную должность.\nВозможно, избирателям будет проще сформировать свое мнение о тебе,\nесли ты напишешь предвыборную речь', stored,
					function(text)
						octolib.vars.set('dbg-police.speech.' .. d, string.Trim(text))
						apply(self, d, text)
					end, nil, 'Отправить', 'Отмена')
			else
				apply(self, d)
			end
		end
		function c:OnSelect(i, val, data)
			b:SetEnabled(true)
		end
	end

	if ply:GetNetVar('dbg-police.job', '') ~= '' then -- quit
		local l = vgui.Create 'DLabel'
		l:SetParent(f)
		l:Dock(TOP)
		l:DockMargin(5,10,5,0)
		l:SetTall(30)
		l:SetText(L.retire)
		l:SetFont('f4.normal')

		local p = vgui.Create 'DPanel'
		p:SetParent(f)
		p:Dock(TOP)
		p:DockPadding(5, 5, 5, 5)
		p:SetTall(90)

		local l2 = vgui.Create 'DLabel'
		l2:SetParent(p)
		l2:Dock(TOP)
		l2:DockMargin(2,0,2,5)
		l2:SetTall(45)
		l2:SetWrap(true)
		l2:SetText(L.retire_hint)

		local b = vgui.Create 'DButton'
		b:SetParent(p)
		b:Dock(TOP)
		b:DockMargin(0,0,0,5)
		b:SetText(L.retire)
		b:SetTall(30)
		function b:DoClick()
			net.Start('dbg-police.quit')
			net.SendToServer()

			f:Remove()
		end
	end

	if ply:GetNetVar('dbg-police.job', '') == 'chief' or ply:GetNetVar('dbg-police.job', '') == 'mayor' then -- fire
		local l = vgui.Create 'DLabel'
		l:SetParent(f)
		l:Dock(TOP)
		l:DockMargin(5,10,5,0)
		l:SetTall(30)
		l:SetText(L.control)
		l:SetFont('f4.normal')

		local p = vgui.Create 'DPanel'
		p:SetParent(f)
		p:Dock(TOP)
		p:DockPadding(5, 5, 5, 5)
		p:SetTall(125)

		local l2 = vgui.Create 'DLabel'
		l2:SetParent(p)
		l2:Dock(TOP)
		l2:DockMargin(2,0,2,5)
		l2:SetTall(45)
		l2:SetWrap(true)
		l2:SetText(L.you_executive_position)

		local c = vgui.Create 'DComboBox'
		c:SetParent(p)
		c:Dock(TOP)
		c:DockMargin(0,0,0,5)
		c:SetValue(L.choose_worker)
		c:SetTall(30)
		for i, target in ipairs(player.GetAll()) do
			if target ~= ply and target:GetNetVar('dbg-police.job', '') ~= '' and target:Team() ~= TEAM_DPD then
				local job = DarkRP.getJobByCommand(target:GetNetVar('dbg-police.job', ''))
				c:AddChoice(target:Name() .. ' (' .. (job and job.name or L.unknown) .. ')', target)
			end
		end

		local b = vgui.Create 'DButton'
		b:SetParent(p)
		b:Dock(TOP)
		b:DockMargin(0,0,0,5)
		b:SetText(L.demote_player)
		b:SetTall(30)
		b:SetEnabled(false)
		function b:DoClick()
			net.Start('dbg-police.fire')
				net.WriteEntity(self.target)
			net.SendToServer()
			f:Remove()
		end

		function c:OnSelect(i, val, data)
			b.target = data
			b:SetEnabled(true)
		end
	end

end)
