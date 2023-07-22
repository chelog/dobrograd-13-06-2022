properties.Add('demote', {
	MenuLabel = L.c_language_demote,
	Order = 3,
	MenuIcon = octolib.icons.silk16('user_delete'),
	Filter = function(self, ent, ply)
		return IsValid(ent) and ent:IsPlayer()
		and not ent:GetNetVar('Ghost') and not ply:GetNetVar('Ghost')
	end,
	Action = function(self, ent)
		Derma_StringRequest(L.c_language_demote, L.c_language_demote_description, nil, function(a)
			octochat.say('/demote', ent:UserID(), a)
		end)
	end
})
