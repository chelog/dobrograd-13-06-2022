local function run()
if not GAMEMODE then return end
hook.Add('Think', 'dbg-score', function()
if not IsValid(LocalPlayer()) then return end

if IsValid(dbgScore) then dbgScore:Remove() end

local maxH = ScrH() - 80
local p = vgui.Create 'DFrame'
dbgScore = p

local icons = {}
local function updateIcons()
	for rank, data in pairs(serverguard.ranks.stored) do
		icons[rank] = Material(data.texture)
	end
end
hook.Add('PlayerIsLoaded', 'dbg-score', updateIcons)

local function convert_rank_to_img(ply)

	local icon = icons[ply:GetUserGroup()]
	if not icon then
		updateIcons()
		return convert_rank_to_img(ply)
	end

	return icon

end

local function niceMinutes(num)

	local word = L.minutes_hint
	if num < 5 or (num % 100) > 20 then
		local lastDigit = num % 10
		if lastDigit == 1 then
			word = word .. 'у'
		elseif lastDigit > 1 and lastDigit < 5 then
			word = word .. 'ы'
		end
	end

	return num .. word

end

local function canSeeHisJob(ply)
	local lp = LocalPlayer()
	if ply == lp then return true end
	local job = ply:getJobTable()
	local myJob = lp:getJobTable()

	if myJob.admin ~= 0 then return true end
	if job.command == 'fbi' and myJob.command ~= 'fbi' then return false end
	if myJob.police ~= job.police then return false end
	if not myJob.police then return false end

	return true
end

local function canSeeHisLicense(ply)
	local lp, license = LocalPlayer(), ply:GetNetVar('HasGunlicense')
	if not license then return false end
	if ply == lp then return true end

	local myJob = lp:getJobTable()

	if myJob.admin ~= 0 then return true end
	if myJob.seesLicense then return true end
	if myJob.police then return true end

	return false
end

surface.CreateFont('dbg-score.large', {
	font = 'Calibri',
	extended = true,
	size = 27,
	weight = 350,
})

surface.CreateFont('dbg-score.normal', {
	font = 'Calibri',
	extended = true,
	size = 22,
	weight = 350,
})

surface.CreateFont('dbg-score.small', {
	font = 'Calibri',
	extended = true,
	size = 18,
	weight = 350,
})

p:SetSize(800, 600)
p:Center()
p:MakePopup()
p:SetMouseInputEnabled(true)
p:SetKeyboardInputEnabled(false)
p:SetTitle('')
p:DockPadding(0,0,0,0)
p:ShowCloseButton(false)

p.canvas = vgui.Create 'DScrollPanel'
p.canvas:SetParent(p)
p.canvas:Dock(FILL)
p.canvas:SetPaintBackground(false)
p.canvas.VBar.btnUp.Paint = function() end
p.canvas.VBar.btnDown.Paint = function() end
p.canvas.VBar.Paint = function(self, w, h)
	draw.RoundedBox(4, w/2 - 3, 18, 6, h - 36, Color(43,34,43, 180))
end
p.canvas.VBar.btnGrip.Paint = function(self, w, h)
	local col = (self.Hovered or self.Depressed) and Color(238,238,238, 255) or Color(238,238,238, 100)
	draw.RoundedBox(4, w/2 - 4, 0, 8, h, col)
end

p.al = 0
p.playerNum = 0

local function ease( t, b, c, d )

	t = t / d;
	return -c * t * (t - 2) + b

end

local function paintTag(self, w, h)

	surface.SetDrawColor(255,255,255, 255)
	surface.SetMaterial(self.icon)
	surface.DrawTexturedRect(4, 4, 16, 16)

end

local vipMat = Material(octolib.icons.silk16('heart'))
local function paintButton(self, w, h)

	local al = self.anim
	local ply = self.ply

	local col = Color(43,34,43, 180 + al * 70)
	draw.RoundedBox(4, 0, 0, w, h, col)

	surface.SetDrawColor(255,255,255, 255)
	surface.SetMaterial(convert_rank_to_img(ply))
	surface.DrawTexturedRect(12, 12, 16, 16)

	-- draw.SimpleText(team.GetName(ply:Team()), 'dbg-score.normal', w - 10, h/2 - 1, Color(238,238,238), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	draw.SimpleText(ply:Name(), 'dbg-score.large', 38, h/2 - 1, Color(238,238,238), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	if al > 0 then
		al = ease(al, 0, 1, 1)
		local tw, th = surface.GetTextSize(ply:Name())
		local x, y = math.floor(28 + tw + al * 20), h/2
		if ply:GetNetVar('os_dobro') then
			surface.SetDrawColor(255,255,255, al*150)
			surface.SetMaterial(vipMat)
			surface.DrawTexturedRect(x, y-7, 16, 16)
			x = x + 20
		end
		draw.SimpleText(ply:SteamName(), 'dbg-score.small', x, y, Color(238,238,238, al * 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

end

local function thinkButton(self)

	if not IsValid(self.ply) then return self:Remove() end
	local steamID = self.ply:SteamID()

	if self.Hovered or self:IsChildHovered(true) then
		self.anim = math.Approach( self.anim, 1, FrameTime() / 0.1 )
	else
		self.anim = math.Approach( self.anim, 0, FrameTime() / 0.2 )
	end

	-- job
	local name, icon, overridden
	local job = self.ply:getJobTable()
	if job.displayAs and not canSeeHisJob(self.ply) then
		job = DarkRP.getJobByCommand(job.displayAs)
		overridden = true
	end

	if job then name, icon = job.name, octolib.icons.silk16(job.icon or 'error') end
	if not overridden then
		local customJob = self.ply:GetNetVar('customJob')
		if customJob then name, icon = unpack(customJob) end
	end

	if self.j and (self.j.hint ~= name or self.j.iconPath ~= icon) then
		self.j.hint = name
		self.j.icon = Material(icon)
		self.j.iconPath = icon
	end

	-- friend
	if self.fs then
		if FPP.Buddies[steamID] == nil then
			self.fs[2]:Remove()
			self.fs = nil
		end
	elseif FPP.Buddies[steamID] ~= nil then
		local fs = vgui.Create 'DPanel'
		fs:SetParent(self)
		fs:Dock(RIGHT)
		fs:SetWide(24)
		fs:SetCursor('hand')
		fs.icon = Material(octolib.icons.silk16('personals'))
		fs.Paint = paintTag
		fs:AddHint(L.your_friend)
		fs.DoClick = function(fs)
			self:DoClick()
		end
		self.fs = {true, fs}
	end

	-- afk
	local isAFK = self.ply:IsAFK()
	if self.afk then
		if not isAFK then
			self.afk[2]:Remove()
			self.afk = nil
		end
	elseif isAFK then
		local afk = vgui.Create 'DPanel'
		afk:SetParent(self)
		afk:Dock(RIGHT)
		afk:SetWide(24)
		afk:SetCursor('hand')
		afk.icon = Material(octolib.icons.silk16('time'))
		afk.Paint = paintTag
		afk:AddHint(function() return 'AFK: ' .. niceMinutes(math.floor(self.ply:GetAFKTime() / 60)) end)
		afk.DoClick = function(afk)
			self:DoClick()
		end
		self.afk = {true, afk}
	end

	-- gun license
	local license = self.ply:GetNetVar('HasGunlicense')
	if self.gl then
		if not license or not canSeeHisLicense(self.ply) then
			self.gl[2]:Remove()
			self.gl = nil
		end
	elseif canSeeHisLicense(self.ply) then
		local gl = vgui.Create 'DPanel'
		gl:SetParent(self)
		gl:Dock(RIGHT)
		gl:SetWide(24)
		gl:SetCursor('hand')
		gl.icon = Material(octolib.icons.silk16('page_white_text'))
		gl.Paint = paintTag
		gl:AddHint(function() local l = self.ply:GetNetVar('HasGunlicense') return (isstring(l) and string.Trim(l) ~= '') and L.license_hint2 .. l or L.have_license end)
		gl.DoClick = function(gl)
			self:DoClick()
		end
		self.gl = {true, gl}
	end

	-- police
	local isPolice = self.ply:GetNetVar('dbg-police.job', '') ~= '' and canSeeHisJob(self.ply)
	if self.pj then
		if not isPolice then
			self.pj[2]:Remove()
			self.pj = nil
		end
	elseif isPolice then
		local pj = vgui.Create 'DPanel'
		pj:SetParent(self)
		pj:Dock(RIGHT)
		pj:SetWide(24)
		pj:SetCursor('hand')
		pj.icon = Material(octolib.icons.silk16('baton'))
		pj.Paint = paintTag
		pj:AddHint(L.working_in_police)
		pj.DoClick = function(pj)
			self:DoClick()
		end
		self.pj = {true, pj}
	end

	-- wanted
	if self.w then
		if not self.ply:GetNetVar('wanted') then
			self.w[2]:Remove()
			self.w = nil
		end
	elseif self.ply:GetNetVar('wanted') then
		local w = vgui.Create 'DPanel'
		w:SetParent(self)
		w:Dock(RIGHT)
		w:SetWide(24)
		w:SetCursor('hand')
		w.icon = Material(octolib.icons.silk16('exclamation'))
		w.Paint = paintTag
		local reason = self.ply:GetNetVar('wanted')
		w:AddHint(L.wanted_hint:format(reason))
		w.DoClick = function(w)
			self:DoClick()
		end
		self.w = {true, w}
	end

end

p.Paint = function(self, w, h)

	if h == maxH then
		local drawUpper = self.canvas.VBar:GetScroll() ~= 0
		local drawLower = self.canvas.VBar:GetScroll() ~= self.canvas.VBar.CanvasSize

		surface.DisableClipping(true)
		surface.SetDrawColor(0,0,0, 100)
		if drawUpper then surface.DrawLine(-5, -1, w - 11, -1) end
		if drawLower then surface.DrawLine(-5, h, w - 11, h) end
		surface.DisableClipping(false)
	end

end

p.UpdatePlayerList = function(self)

	self.canvas:Clear()

	local plys = player.GetAll()
	table.sort(plys, function(a, b)
		return a:Name() < b:Name()
	end)

	for i, ply in ipairs(plys) do
		if hook.Run('dbg-score.hidePlayer', ply) == true then continue end

		local b = vgui.Create 'DButton'
		b:SetParent(self.canvas)
		b:Dock(TOP)
		b:DockMargin(0,0,0,5)
		b:DockPadding(8,8,8,8)
		b:SetText('')
		b:SetTall(40)
		b.ply = ply
		b.anim = 0
		b.Paint = paintButton
		b.Think = thinkButton
		b.DoClick = function(self)
			local steamID = ply:SteamID()
			local menu = DermaMenu()

			if ply ~= LocalPlayer() then
				local types = {'physgun','gravgun','toolgun','playeruse','entitydamage'}
				if FPP.Buddies[steamID] ~= nil then
					menu:AddOption(L.remove_friend, function()
						for k, acessType in pairs( types ) do
							FPP.SaveBuddy(steamID, ply:Name(), acessType, 0)
						end
					end):SetIcon(octolib.icons.silk16('heart_delete'))
				else
					menu:AddOption(L.add_friend, function()
						for k, acessType in pairs( types ) do
							FPP.SaveBuddy(steamID, ply:Name(), acessType, 1)
						end
					end):SetIcon(octolib.icons.silk16('heart'))
				end
			end

			menu:AddSpacer()

			hook.Run('dbg-admin.getActions', menu, ply, 'score')

			menu:Open()
		end

		local r = vgui.Create 'DPanel'
		r:SetParent(b)
		r:Dock(LEFT)
		r:SetWide(24)
		r:SetCursor('hand')
		r.icon = convert_rank_to_img(ply)
		r.Paint = paintTag
		r:AddHint(serverguard.ranks.stored[ply:GetUserGroup()].name)
		r.DoClick = function()
			b:DoClick()
		end

		local job = ply:getJobTable()
		if job.displayAs and not canSeeHisJob(ply) then
			job = DarkRP.getJobByCommand(job.displayAs)
		end

		local j = vgui.Create 'DPanel'
		j:SetParent(b)
		j:Dock(RIGHT)
		j:SetWide(24)
		j:SetCursor('hand')
		j.icon = Material(octolib.icons.silk16(job and job.icon or 'error'))
		j.Paint = paintTag
		j:AddHint(function()
			return j.hint
		end)
		j.DoClick = function()
			b:DoClick()
		end
		b.j = j
	end

	self:SetTall(math.min(player.GetCount() * 45 - 5, maxH))
	self:Center()

end

p.PerformLayout = function() end
p.Think = function( self )

	if self.playerNum ~= player.GetCount() then
		self:UpdatePlayerList()
		self.playerNum = player.GetCount()
	end

	self.al = math.Approach( self.al, self.active and 1 or 0, FrameTime() / 0.3 )
	self:SetAlpha(self.al * 255)

	if self:IsVisible() and self.al == 0 then
		self:SetVisible(false)
	end

	if LocalPlayer():IsAdmin() and not IsValid(self.adminBut1) then
		local b1 = vgui.Create 'DButton'
		b1:SetText('')
		b1:SetSize(24,24)
		b1:SetPos(ScrW() / 2 - 40, ScrH() - 32)
		b1.icon = Material(octolib.icons.silk16('shield'))
		b1.Paint = paintTag
		b1.Think = function(self2)
			self2:SetAlpha(self.al * 255)
		end
		b1:AddHint(L.admin_mode)
		function b1:DoClick()
			RunConsoleCommand('dbg_admin')
		end

		local b2 = vgui.Create 'DButton'
		b2:SetText('')
		b2:SetSize(24,24)
		b2:SetPos(ScrW() / 2 - 12, ScrH() - 32)
		b2.icon = Material(octolib.icons.silk16('gear_in'))
		b2.Paint = paintTag
		b2.Think = function(self2)
			self2:SetAlpha(self.al * 255)
		end
		b2:AddHint(L.admin_menu)
		function b2:DoClick()
			RunConsoleCommand('serverguard_menu_toggle')
		end

		local b3 = vgui.Create 'DButton'
		b3:SetText('')
		b3:SetSize(24,24)
		b3:SetPos(ScrW() / 2 + 16, ScrH() - 32)
		b3.icon = Material(octolib.icons.silk16('page_white_magnify'))
		b3.Paint = paintTag
		b3.Think = function(self2)
			self2:SetAlpha(self.al * 255)
		end
		b3:AddHint(L.hud_logs)
		function b3:DoClick()
			octoesc.OpenURL('https://octothorp.team/logs')
		end

		self.adminBut1 = b1
		self.adminBut2 = b2
		self.adminBut3 = b3

		self.OnRemove = function()
			b1:Remove()
			b2:Remove()
			b3:Remove()
		end
	end

end

netstream.Hook('dbg-score.update', function()
	p.playerNum = -1
end)

function GAMEMODE:ScoreboardShow()

	p.active = true
	p.holding = true
	p:SetMouseInputEnabled(true)
	p:SetVisible(true)

end

function GAMEMODE:ScoreboardHide()

	if not p.active then return end
	p.active = false
	p.holding = false
	p:SetMouseInputEnabled(false)

end

local blur = Material( 'pp/blurscreen' )
local colors = CFG.skinColors
hook.Add( 'RenderScreenspaceEffects', 'dbg-scoreboard', function()

	local state = p.al
	local a = 1 - math.pow( 1 - state, 2 )

	if a > 0 then
		local colMod = {
			['$pp_colour_addr'] = 0,
			['$pp_colour_addg'] = 0,
			['$pp_colour_addb'] = 0,
			['$pp_colour_mulr'] = 0,
			['$pp_colour_mulg'] = 0,
			['$pp_colour_mulb'] = 0,
			['$pp_colour_brightness'] = -a * 0.2,
			['$pp_colour_contrast'] = 1 + 0.5 * a,
			['$pp_colour_colour'] = 1 - a,
		}

		if GetConVar('octolib_blur'):GetBool() then
			DrawColorModify(colMod)

			surface.SetDrawColor( 255, 255, 255, a * 255 )
			surface.SetMaterial( blur )

			for i = 1, 3 do
				blur:SetFloat( '$blur', a * i * 2 )
				blur:Recompute()

				render.UpdateScreenEffectTexture()
				surface.DrawTexturedRect( -1, -1, ScrW() + 2, ScrH() + 2 )
			end
		else
			colMod['$pp_colour_brightness'] = -0.4 * a
			colMod['$pp_colour_contrast'] = 1 + 0.2 * a
			DrawColorModify(colMod)
		end

		draw.NoTexture()
		local col = colors.bg
		surface.SetDrawColor(col.r, col.g, col.b, a * 100)
		surface.DrawRect(-1, -1, ScrW() + 1, ScrH() + 1)
	end

end)

hook.Remove('Think', 'dbg-score')
end)
end
hook.Add('darkrp.loadModules', 'dbg-score', run)
run()
