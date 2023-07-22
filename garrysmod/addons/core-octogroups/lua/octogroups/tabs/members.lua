local colDefault, colHover = Color(0,0,0, 50), Color(0,0,0, 70)
og.tabBuilds['members'] = function(ps, g)

	local gID = g.id
	
	local p = vgui.Create 'DCategoryList'
	ps:AddSheet('Участники', p, 'icon16/user_gray.png')

	if og.hasPerm(gID, 'setMember') then
		local b = vgui.Create 'DButton'
		p:AddItem(b)
		b:SetTall(30)
		b:SetText('Пригласить в организацию')
		b:DockMargin(0, 0, 0, 10)
		function b:DoClick()
			local opts = {}
			for i, ply in ipairs(player.GetAll()) do
				local sID = ply:SteamID()
				if not g.members[sID] then
					opts[#opts + 1] = {ply:Name(), nil, function()
						netstream.Start('og.setMember', gID, sID)
					end}
				end
			end
			octolib.menu(opts):Open()
		end
	end

	local ranks = {}
	ranks.owner = p:Add('Глава', 'icon16/star.png')
	for rankID, r in SortedPairsByMemberValue(g.ranks, 'order', true) do
		ranks[rankID] = p:Add(r.name or 'Ранг', r.icon or 'icon16/status_offline.png')
	end
	ranks.member = p:Add('Без ранга', 'icon16/status_offline.png')
	for rankID, cat in pairs(ranks) do
		cat:DockMargin(0, 0, 0, 15)
		cat:SetPaintBackground(true)
	end

	local function memberPaint(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, self.Hovered and colHover or colDefault)
	end

	local function memberClick(self)
		local opts = {
			{'Открыть профиль', 'icon16/report_user.png', function()
				F4:Hide()
				gui.ActivateGameUI()
				octoesc.OpenURL('https://steamcommunity.com/profiles/' .. util.SteamIDTo64(self.sID))
			end},
		}

		if og.hasPerm(gID, 'setRank') then
			local my, his = og.getOrder(gID, LocalPlayer():SteamID()), og.getOrder(gID, self.sID)
			if my > his then
				local rankOpts = {}
				for rID, r in SortedPairsByMemberValue(g.ranks, 'order', true) do
					if my > r.order then
						rankOpts[#rankOpts + 1] = {r.name or '???', r.icon or 'icon16/error.png', function() netstream.Start('og.setRank', gID, self.sID, rID) end}
					end
				end
				if g.members[self.sID].rank ~= 'member' then
					rankOpts[#rankOpts + 1] = {'Без ранга', 'icon16/status_offline.png', function() netstream.Start('og.setRank', gID, self.sID, 'member') end}
				end
				if #rankOpts >= 0 then opts[#opts + 1] = {'Ранг', 'icon16/user_go.png', rankOpts} end

				opts[#opts + 1] = {'Исключить', 'icon16/delete.png', function() netstream.Start('og.setRank', gID, self.sID, nil) end}
			end
		end

		octolib.menu(opts):Open()
	end

	for sID, m in pairs(g.members) do
		local ply = player.GetBySteamID(sID)
		local cat = ranks[m.rank or 'member'] or ranks.member
		local b = vgui.Create('DButton', cat)
		b:Dock(TOP)
		b:DockMargin(2,0,2,0)
		b:SetTall(32)
		b:SetText('...')
		b:SetContentAlignment(4)
		b:SetTextInset(40, 0)
		b:SetFont('og.normal')
		b.Paint = memberPaint
		b.DoClick = memberClick
		b.m = m
		b.sID = sID

		local sID64 = util.SteamIDTo64(sID)
		steamworks.RequestPlayerInfo(sID64, function(name)
			b:SetText(('%s (%s)'):format(IsValid(ply) and ply:Name() or '-', name))
		end)

		local bA = b:Add 'AvatarImage'
		bA:Dock(LEFT)
		bA:SetWide(b:GetTall())
		bA:SetSteamID(sID64, 64)
		bA:SetMouseInputEnabled(false)
	end

end
