local function nameAsc(a, b)
	return a:GetName() < b:GetName()
end

local function getSortedPlayers()
	local plys = player.GetAll()
	table.sort(plys, nameAsc)
	return plys
end

octogui.cmenu.registerItem('departments', 'police', {
	text = L.police,
	check = DarkRP.isCop,
	icon = octolib.icons.silk16('set_security_question'),
	options = {
		{
			text = 'Розыск',
			icon = octolib.icons.silk16('flag_flyaway_blue'),
			options = {
				{
					text = L.c_language_wanted,
					icon = octolib.icons.silk16('flag_flyaway_red'),
					build = function(sm)
						local me = LocalPlayer()
						for _, v in ipairs(getSortedPlayers()) do
							if v == me or v:isWanted() then continue end

							sm:AddOption(v:Name(), octolib.fStringRequest(L.make_wanted, L.reason_wanted, '', function(s)
								octochat.say('/wanted', v:UserID(), s)
							end, nil, L.ok, L.cancel)):SetColor(v:getJobTable().color)
						end
					end,
				}, {
					text = L.c_language_unwanted,
					icon = octolib.icons.silk16('flag_flyaway_green'),
					build = function(sm)
						for _, v in ipairs(getSortedPlayers()) do
							if not v:isWanted() then continue end

							sm:AddOption(v:Name(), octolib.fStringRequest(L.c_language_unwanted, L.c_language_unwanted_description, '', function(a)
								octochat.say('/unwanted', v:UserID(), a)
							end, nil, L.ok, L.cancel)):SetColor(v:getJobTable().color)
						end
					end,
				}
			},
		}, {
			text = 'Лицензия',
			icon = octolib.icons.silk16('page'),
			check = function(ply)
				local mayor, chief, serg, cop
				for _,v in ipairs(player.GetAll()) do
					if v:isMayor() or v:GetActiveRank('gov') == 'worker' then
						mayor = true
						break
					elseif v:isChief() then
						chief = true
					elseif v:getJobTable().command == 'cop2' then
						serg = true
					elseif v:isCP() then cop = true end
				end
				if mayor then
					return ply:isMayor() or ply:GetActiveRank('gov') == 'worker'
				elseif chief then
					return ply:isChief()
				elseif serg then
					return ply:getJobTable().command == 'cop2'
				elseif cop then
					return ply:isCP()
				else return ply:IsAdmin() end
			end,
			options = {
				{
					text = 'Выдать',
					icon = octolib.icons.silk16('page_add'),
					action = octolib.fStringRequest(L.license_give, L.license_hint, L.gun, function(s)
						if string.Trim(s) == '' then return octolib.notify.show('warning', L.need_hint_license) end
						octochat.say('/givelicense', s)
					end, nil, L.ok, L.cancel),
				}, {
					text = 'Забрать',
					icon = octolib.icons.silk16('page_delete'),
					say = '/takelicense',
				},
			}
		}, {
			text = 'Проверить автомобиль',
			icon = octolib.icons.silk16('car_add'),
			say = '/carcheck',
		}, {
			text = L.request_backup,
			icon = octolib.icons.silk16('shield_add'),
			action = octolib.fStringRequest(L.request_backup, L.request_backup_query, '', function(s)
				octochat.say('/callhelp', s)
			end, nil, L.ok, L.cancel),
		}, {
			text = L.show_codes,
			icon = octolib.icons.silk16('document_inspector'),
			action = function()
				octogui.cmenu.window(L.codes_hint, LocalPlayer():Team() == TEAM_DPD and L.dpd_codes_help or L.codes_help)
			end,
		}
	},
})

octogui.cmenu.registerItem('departments', 'gr', {
	text = L.speaker,
	check = DarkRP.isGov,
	icon = octolib.icons.silk16('events'),
	action = octolib.fStringRequest(L.speaker_say, L.write_text, '', function(s)
		octochat.say('/gr', s)
	end, nil, L.ok, L.cancel),
})

octogui.cmenu.registerItem('departments', 'panicbtn', {
	text = L.panic_button_press,
	check = DarkRP.isGov,
	icon = octolib.icons.silk16('alarm_bell'),
	say = '/panicbutton',
})

local function canUse(ply)
	return DarkRP.isTaxist(ply) or ply:Team() == TEAM_ALPHA
end

octogui.cmenu.registerItem('departments', 'alphabtn', {
	text = L.panic_button_press,
	check = canUse,
	icon = octolib.icons.silk16('alarm_bell'),
	say = '/alphabutton',
})