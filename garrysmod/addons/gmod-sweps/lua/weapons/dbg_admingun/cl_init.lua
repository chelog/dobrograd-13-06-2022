local function playTime(time)

	local h, m, s
	h = math.floor(time / 60 / 60)
	m = math.floor(time / 60) % 60
	s = math.floor(time) % 60

	return string.format('%02i:%02i:%02i', h, m, s)

end

include 'shared.lua'

local weps = {
	'dbg_punisher',
	'weapon_octo_ak',
	'weapon_octo_aug',
	'weapon_octo_awp',
	'weapon_octo_deagle',
	'weapon_octo_dualelites',
	'weapon_octo_famas',
	'weapon_octo_fiveseven',
	'weapon_octo_g3sg1',
	'weapon_octo_galil',
	'weapon_octo_glock',
	'weapon_octo_knife',
	'weapon_octo_m249',
	'weapon_octo_m3',
	'weapon_octo_m4a1',
	'weapon_octo_mac10',
	'weapon_octo_mp5',
	'weapon_octo_p228',
	'weapon_octo_p90',
	'weapon_octo_scout',
	'weapon_octo_sg550',
	'weapon_octo_sg552',
	'weapon_octo_tmp',
	'weapon_octo_ump45',
	'weapon_octo_usp',
	'weapon_octo_xm1014',
	'weapon_octo_usps',
	'weapon_octo_357',
	'weapon_octo_knife',
	'weapon_octo_axe',
	'weapon_octo_shovel',
	'weapon_octo_hook',
	'weapon_flashlight',
	'keypad_cracker',
	'gmod_camera',
}

local logs = {
	dbg = 'dbg_cd',
	dbg2 = 'dbg_nd',
}

local warns = L.warns

hook.Add('dbg-admin.getActions', 'dbg-admingun', function(menu, ply, id)

	local steamID = ply:SteamID()
	if steamID == 'NULL' then steamID = 'BOT' end

	local name = ('%s (%s)'):format(ply:Name(), ply:SteamName())
	menu:AddOption(name, function()
		ply:ShowProfile()
	end):SetIcon(octolib.icons.silk16('user'))

	-- steamid
	menu:AddOption(L.action_copySteamID, function()
		SetClipboardText(steamID)
	end):SetIcon(octolib.icons.silk16('page_copy'))

	menu:AddSpacer()

	-- time
	local time1 = playTime(ply:GetTimeHere())
	menu:AddOption('Наиграно здесь: ' .. time1,function()
		SetClipboardText(time1)
	end):SetIcon(octolib.icons.silk16('clock'))
	local time2 = playTime(ply:GetTimeTotal())
	menu:AddOption('Наиграно всего: ' .. time2,function()
		SetClipboardText(time2)
	end):SetIcon(octolib.icons.silk16('clock_red'))

	if LocalPlayer():IsAdmin() then
		menu:AddSpacer()

		local sm, pmo = menu:AddSubMenu(L.teleport)
			sm:AddOption('Goto', function() RunConsoleCommand('sgs', 'goto', steamID) end)
			sm:AddOption('Bring', function() RunConsoleCommand('sgs', 'bring', steamID) end)
			sm:AddOption('Return', function() RunConsoleCommand('sgs', 'return', steamID) end)
			sm:AddOption('To Admin Zone', function() RunConsoleCommand('sgs', 'adminzone', steamID) end)
		pmo:SetIcon(octolib.icons.silk16('bullet_go'))

		local sm, pmo = menu:AddSubMenu(L.condition)
			sm:AddOption('100HP', function() RunConsoleCommand('sgs', 'hp', steamID, '100') end)
			sm:AddOption(L.hundred_energy, function() RunConsoleCommand('sgs', 'hunger', steamID, '100') end)
			sm:AddOption(L.spawn, function() netstream.Start('chat', '/spawn ' .. ply:Name()) end)
			sm:AddOption('Slay', function() RunConsoleCommand('sgs', 'slay', steamID) end)
		pmo:SetIcon(octolib.icons.silk16('pill'))

		local sm, pmo = menu:AddSubMenu(L.weapons)
			local sm2, pmo2 = sm:AddSubMenu(L.give_weapon)
			for i, wep in ipairs(weps) do
				sm2:AddOption(wep, function() RunConsoleCommand('sgs', 'give', steamID, wep) end)
			end

			sm:AddOption(L.give_ammo, function()
				Derma_StringRequest(L.give_ammo, L.give_ammo_hint, '', function(s)
					RunConsoleCommand('sgs', 'ammo', steamID, s)
				end, function() end, L.ok, L.cancel)
			end)
		pmo:SetIcon(octolib.icons.silk16('gun'))

		local sm, pmo = menu:AddSubMenu(L.warns)
			sm:AddOption('Редактировать', serverguard.editAdminTell):SetIcon(octolib.icons.silk16('pencil'))
			for i, v in ipairs(L.warns_list) do
				sm:AddOption(v[1], function() netstream.Start('AdminTell', ply, v[2], v[1], v[3]) end)
			end
		pmo:SetIcon(octolib.icons.silk16('warning'))

		menu:AddOption(L.ulogs_search, function()
			octoesc.OpenURL('https://octothorp.team/logs/' .. (logs[CFG.serverID] or CFG.serverID) .. '/search/' .. steamID)
		end):SetIcon(octolib.icons.silk16('page_white_magnify'))
		menu:AddOption(L.admingun_admintell, function() octochat.say('/admintell', steamID) end):SetIcon(octolib.icons.silk16('textfield'))
		menu:AddOption('Screenshot', function() RunConsoleCommand('sgs', 'capture', steamID) end):SetIcon(octolib.icons.silk16('photo_add'))
		menu:AddOption('Spectate', function() RunConsoleCommand('FSpectate', steamID) end):SetIcon(octolib.icons.silk16('eye'))
		menu:AddOption('Watchlist', function() RunConsoleCommand('sg', 'watch', steamID) end):SetIcon(octolib.icons.silk16('edit_recipient_list'))

		local sm, pmo = menu:AddSubMenu('Запретить игру...')

			sm:AddOption('За криминал', function()
				Derma_StringRequest('Срок запрета', 'Укажи срок запрета', '', function(s)
					RunConsoleCommand('sg', 'denycrime', steamID, s)
				end)
			end):SetIcon(octolib.icons.silk16('gun'))

			sm:AddOption('За полицию', function()
				Derma_StringRequest('Срок запрета', 'Укажи срок запрета', '', function(s)
					RunConsoleCommand('sg', 'denypolice', steamID, s)
				end)
			end):SetIcon(octolib.icons.silk16('baton'))

		pmo:SetIcon(octolib.icons.silk16('delete'))

		menu:AddOption('Kick', function()
			Derma_StringRequest(L.reason_kick,L.reason_kick_hint, '', function(s)
				RunConsoleCommand('sg', 'kick', steamID, s)
			end, function() end, L.ok, L.cancel)
		end):SetIcon(octolib.icons.silk16('delete'))

		menu:AddOption('Ban', function()
			Derma_StringRequest(L.length_ban, L.length_ban_hint, '', function(s1)
				Derma_StringRequest(L.reason_ban, L.reason_ban_hint, '', function(s2)
					RunConsoleCommand('sg', 'ban', steamID, s1, s2)
				end, function() end, L.ok, L.cancel)
			end, function() end, L.ok, L.cancel)
		end):SetIcon(octolib.icons.silk16('delete'))
	end

end)

function SWEP:PrimaryAttack()

	if not IsFirstTimePredicted() then return end

	gui.EnableScreenClicker( true )
	local menu = DermaMenu()

	local ply = self.Owner:GetEyeTrace().Entity
	if not IsValid(ply) or not ply:IsPlayer() then ply = LocalPlayer() end

	hook.Run('dbg-admin.getActions', menu, ply, 'admingun')

	menu:Open()
	gui.EnableScreenClicker( false )

end

function SWEP:SecondaryAttack()

	-- keep calm and do nothing

end

function SWEP:Reload()

	-- keep calm and do nothing

end
