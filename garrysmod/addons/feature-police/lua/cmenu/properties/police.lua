properties.Add('wanted', {
	MenuLabel = L.c_language_wanted,
	Order = 4,
	MenuIcon = 'icon16/flag_red.png',
	Filter = function(self, ent, ply)
		return IsValid(ent) and ent:IsPlayer() and not ent:isWanted() and GAMEMODE.CivilProtection[ply:Team()]
	end,
	Action = function(self, ent)
		Derma_StringRequest(L.c_language_wanted, L.c_language_wanted_description, nil, function(a)
			octochat.say('/wanted', ent:UserID(), a)
		end)
	end
})

properties.Add('unwanted', {
	MenuLabel = L.c_language_unwanted,
	Order = 5,
	MenuIcon = 'icon16/flag_green.png',
	Filter = function(self, ent, ply)
		return IsValid(ent) and ent:IsPlayer() and ent:isWanted() and ply:isCP()
	end,
	Action = function(self, ent)
		Derma_StringRequest(L.c_language_unwanted, L.c_language_unwanted_description, nil, function(a)
			octochat.say('unwanted', ent:UserID(), a)
		end)
	end
})

-- properties.Add('warrant', {
-- 	MenuLabel = L.c_language_warrant,
-- 	Order = 6,
-- 	MenuIcon = 'icon16/door_in.png',

-- 	Filter = function(self, ent, ply)
-- 		return IsValid(ent) and ent:IsPlayer() and ply:isCP()
-- 	end,
-- 	Action = function(self, ent)
-- 		Derma_StringRequest(L.c_language_warrant, L.c_language_warrant_description, nil, function(a)
-- 		octochat.say('/warrant', ent:UserID(), a)
-- 		end)
-- 	end
-- })

local function isInCharge(ply)

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
		if not (ply:isMayor() or ply:GetActiveRank('gov') == 'worker') then return false end
	elseif chief then
		if not ply:isChief() then return false end
	elseif serg then
		if ply:getJobTable().command ~= 'cop2' then return false end
	elseif cop then
		if not ply:isCP() then return false end
	elseif not ply:IsAdmin() then
		return false
	end

	return true

end

properties.Add('givelicense', {
	MenuLabel = L.c_language_give_license,
	Order = 7,
	MenuIcon = 'icon16/page_add.png',
	Filter = function(self, ent, ply)
		return IsValid(ent) and ent:IsPlayer() and not ent:GetNetVar('HasGunlicense') and isInCharge(ply)
	end,
	Action = function(self, ent)
		Derma_StringRequest(L.license_give, L.license_hint, L.gun, function(s)
			if string.Trim(s) == '' then return octolib.notify.show('warning', L.need_hint_license) end
			octochat.say('/givelicense', s)
		end, nil, L.issue, L.cancel)
	end,
})


properties.Add('takelicense', {
	MenuLabel = L.license_withdraw,
	Order = 7,
	MenuIcon = 'icon16/page_delete.png',
	Filter = function(self, ent, ply)
		return IsValid(ent) and ent:IsPlayer() and ent:GetNetVar('HasGunlicense') and isInCharge(ply)
	end,
	Action = function(self, ent)
		octochat.say('/takelicense')
	end,
})

properties.Add('warrantbyprop', {
	MenuLabel = L.c_language_warrant_prop,
	Order = 8,
	MenuIcon = 'icon16/door_in.png',
	Filter = function(self, ent, ply)
		return IsValid(ent) and IsValid(ent:CPPIGetOwner()) and ent:CPPIGetOwner():IsPlayer() and ply:isCP()
	end,
	Action = function(self, ent)
		Derma_StringRequest(L.c_language_warrant, L.c_language_warrant_description, nil, function(a)
			octochat.say('/warrant', ent:CPPIGetOwner():UserID(), a)
		end)
	end
})
