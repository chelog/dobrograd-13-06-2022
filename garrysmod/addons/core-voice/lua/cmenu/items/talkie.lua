octogui.cmenu.registerItem('talkie', 'stations', {
	text = 'Настройки рации',
	icon = octolib.icons.silk16('transmit_blue'),
	options = {
		{
			text = 'Частота',
			icon = octolib.icons.silk16('textfield_rename'),
			build = function(sm)
				local ply = LocalPlayer()

				for _, v in SortedPairsByMemberValue(talkie.activeChannels, 2) do
					local inUse = v[1] == ply:GetFrequency()
					local option = sm:AddOption(v[2] or 'Неопознанная частота', inUse and octolib.func.zero or function()
						RunConsoleCommand('set_talkie_channel', v[1])
					end)

					if inUse then option:SetImage(octolib.icons.silk16('bullet_green')) end
				end

				local civilOption = sm:AddOption('Гражданская частота', octolib.fStringRequest(L.change_radio, L.talkie_hint:format(ply:GetFrequency()), '', function(s)
					RunConsoleCommand('set_talkie_channel', s)
				end, nil, L.ok, L.cancel))

				if ply:GetFrequency():find('^(%d%d%d%.%d)$') then
					civilOption:SetImage(octolib.icons.silk16('bullet_green'))
				end
			end,
		}, {
			text = 'Слышать основную частоту',
			icon = function(ply)
				if not ply:GetNetVar('NoTalkieParenting') then
					return octolib.icons.silk16('tick')
				end
			end,
			netstream = 'dbg-talkie.toggleParenting',
		},
	},
})

octogui.cmenu.registerItem('talkie', 'toggle', {
	text = function(ply)
		return ply:IsTalkieDisabled() and L.c_language_radio_enable or L.c_language_radio_disable
	end,
	icon = function(ply)
		return octolib.icons.silk16(ply:IsTalkieDisabled() and 'transmit_blue' or 'transmit')
	end,
	cmd = {'toggle_talkie'},
})
