local function getClothes(mdl, clothesData)
	for prefix, clothes in pairs(clothesData) do
		if string.StartWith(mdl, prefix) then return clothes end
	end
end

local function reloadClothes()
	for id, org in pairs(simpleOrgs.orgs) do
		if not org.clothes then continue end
		octogui.cmenu.registerItem('clothes', id, {
			text = 'Форма',
			icon = octolib.icons.silk16(org.clothes.icon),
			check = function(ply)
				return ply:getJobTable().command == org.team and getClothes(ply:GetModel(), org.clothes) ~= nil
			end,
			build = function(sm)
				local ply = LocalPlayer()
				local clothes = getClothes(ply:GetModel(), org.clothes)
				if not clothes then return end
				for clID, data in pairs(clothes) do
					local bg, addsm, addpmo = ply:GetBodygroup(data.bodygroup)
					if data.sm then
						addsm, addpmo = sm:AddSubMenu(data.sm)
						addpmo:SetIcon(octolib.icons.silk16(data.icon))
					end
					for bgID, v in pairs(data.vals) do
						local sm2 = addsm or sm
						if bg ~= bgID then
							sm2:AddOption(v[1], function()
								netstream.Start('dbg-orgs.clothes', clID, bgID)
								octochat.say(v[3])
							end):SetIcon(octolib.icons.silk16(v[2]))
						end
					end
				end
			end,
		})
	end
end

hook.Add('simple-orgs.load', 'simple-orgs.org_clothes', reloadClothes)