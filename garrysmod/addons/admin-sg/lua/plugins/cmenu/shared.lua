local plugin = plugin;

plugin.name = "Context menu";
plugin.author = "chelog";
plugin.version = "1.0";
plugin.description = "Context menu -> RMB. By chelog.";
plugin.gamemodes = {"darkrp"};
plugin.permissions = {};

local function playTime(time)

	local h, m, s
	h = math.floor(time / 60 / 60)
	m = math.floor(time / 60) % 60
	s = math.floor(time) % 60

	return string.format("%02i:%02i:%02i", h, m, s)

end

properties.Add( "sg", {
	MenuLabel = L.admin_hint,
	Order = 999,
	MenuIcon = "icon16/wand.png",
	PrependSpacer = true,

	Filter = function( self, ent, ply )
		if not IsValid(ent) then return false end
		if not ent:IsPlayer() then return false end
		if not LocalPlayer():IsAdmin() then return false end

		return !ent:IsOnFire()
	end,
	Action = function( self, ent )

		timer.Simple(0, function()
			local rankData = serverguard.ranks:GetRank(serverguard.player:GetRank(ply))
			local commands = serverguard.command:GetTable()
			local rankData2 = serverguard.ranks:GetRank(serverguard.player:GetRank(v))

			local steamID = ent:SteamID()
			if steamID == 'NULL' then steamID = 'BOT' end

			gui.EnableScreenClicker( true )
			local menu = DermaMenu()
			menu:SetSkin('serverguard')

			-- rank
			menu:AddOption(L.rank_hint .. rankData2.name,function()
				SetClipboardText(rankData2.name);
			end):SetIcon(rankData2.texture)

			menu:AddSpacer()

			-- time
			menu:AddOption('Наиграно здесь: ' .. playTime(ent:GetTimeHere()),function()
				SetClipboardText(playTime(ent:GetTimeHere()))
			end):SetIcon('icon16/clock.png')
			menu:AddOption('Наиграно всего: ' .. playTime(ent:GetTimeTotal()),function()
				SetClipboardText(playTime(ent:GetTimeTotal()))
			end):SetIcon('icon16/clock.png')

			menu:AddSpacer()

			-- steamid
			menu:AddOption(L.copy_steamid, function()
				SetClipboardText(steamID)
			end):SetIcon('icon16/page_copy.png')

			-- return
			menu:AddOption('Return', function()
				RunConsoleCommand('sgs', 'return', steamID)
			end):SetIcon('icon16/wand.png')

			-- teleport to admin zone
			menu:AddOption('To admin zone', function()
				RunConsoleCommand('sgs', 'adminzone', steamID)
			end):SetIcon('icon16/wand.png')

			-- hp 100
			menu:AddOption('100HP', function()
				RunConsoleCommand('sgs', 'hp', steamID, '100')
			end):SetIcon('icon16/wand.png')

			-- slay
			menu:AddOption('Slay', function()
				RunConsoleCommand('sgs', 'slay', steamID)
			end):SetIcon('icon16/wand.png')

			-- respawn
			menu:AddOption('Respawn', function()
				netstream.Start('chat', '/spawn ' .. ent:Name())
			end):SetIcon('icon16/wand.png')

			local sm, pmo = menu:AddSubMenu("Mute")
			pmo:SetSkin("serverguard")
			pmo:SetIcon("icon16/wand.png")
			sm:AddOption(L.enable, function()
				RunConsoleCommand("sg", "mute", steamID)
			end)
			sm:AddOption(L.disable2, function()
				RunConsoleCommand("sg", "unmute", steamID)
			end)

			local sm, pmo = menu:AddSubMenu("Gag")
			pmo:SetSkin("serverguard")
			pmo:SetIcon("icon16/wand.png")
			sm:AddOption(L.enable, function()
				RunConsoleCommand("sg", "gag", steamID)
			end)
			sm:AddOption(L.disable2, function()
				RunConsoleCommand("sg", "ungag", steamID)
			end)

			-- kick
			menu:AddOption('Kick', function()
				Derma_StringRequest(L.reason_kick, L.reason_kick_hint, '', function(s)
					RunConsoleCommand('sg', 'kick', steamID, s)
				end, function() end, L.ok, L.cancel)
			end):SetIcon('icon16/delete.png')

			-- ban
			menu:AddOption('Ban', function()
				Derma_StringRequest(L.length_ban, L.length_ban_hint, '', function(s1)
					Derma_StringRequest(L.reason_ban, L.reason_ban_hint, '', function(s2)
						RunConsoleCommand('sg', 'ban', steamID, s1, s2)
					end, function() end, L.ok, L.cancel)
				end, function() end, L.ok, L.cancel)
			end):SetIcon('icon16/delete.png')

			menu:Open()
			gui.EnableScreenClicker( false )
		end)

	end
})
