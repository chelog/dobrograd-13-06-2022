octogui.cmenu.registerItem('rp', 'demote', {
	text = L.demote,
	icon = octolib.icons.silk16('user_delete'),
	build = function(sm)
		local plys = player.GetAll()
		table.sort(plys, function(a, b) return a:GetName() < b:GetName() end)

		local me = LocalPlayer()
		for _, v in ipairs(plys) do
			if v ~= me then
				sm:AddOption(v:Name(), octolib.fStringRequest(L.c_language_demote, L.c_language_demote_description, '', function(s)
					octochat.say('/demote', v:UserID(), s)
				end, nil, L.ok, L.cancel)):SetColor(v:getJobTable().color)
			end
		end
	end,
})
