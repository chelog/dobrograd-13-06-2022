octogui.cmenu.registerItem('clothes', 'gasmask', {
	text = function(ply)
		local mask = ply:GetNetVar('hMask')
		return ('%s противогаз'):format(mask and mask[1] == 'gasmask' and 'Снять' or 'Надеть')
	end,
	icon = octolib.icons.silk16('arrow_rotate_clockwise'),
	check = function(ply)
		return ply:GetActiveRank('dpd') == 'swat' or ply:GetActiveRank('wcso') == 'seb'
	end,
	say = '/gasmask',
})

octogui.cmenu.registerItem('clothes', 'medmask', {
	text = function(ply)
		local mask = ply:GetNetVar('hMask')
		return ('%s мед. маску'):format(mask and mask[1] == 'medical_mask' and 'Снять' or 'Надеть')
	end,
	icon = octolib.icons.silk16('arrow_rotate_clockwise'),
	check = function(ply)
		return ply:isMedic()
	end,
	say = '/medmask',
})

octogui.cmenu.registerItem('clothes', 'takeoff', {
	text = 'Снять',
	icon = octolib.icons.silk16('attach'),
	check = function(ply)
		if ply:isArrested() then return false end
		if ply:GetNetVar('hMask') ~= nil and ply:CanUnmask() then return true end
		if ply:GetNetVar('customClothes') ~= nil then return true end
		return false
	end,
	options = {
		{
			text = 'Маску',
			cmd = {'dbg_unmask'},
			check = function(ply) return ply:GetNetVar('hMask') ~= nil and ply:CanUnmask() end,
		}, {
			text = 'Одежду',
			cmd = {'dbg_clothesoff'},
			check = function(ply) return ply:GetNetVar('customClothes') ~= nil end,
		},
	}
})
