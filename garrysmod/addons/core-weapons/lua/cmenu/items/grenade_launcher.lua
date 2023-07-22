octogui.cmenu.registerItem('inv', 'glauncher', {
	text = 'Гранатомет',
	icon = octolib.icons.silk16('grenade_launcher'),
	check = function()
		local wep = LocalPlayer():GetActiveWeapon()
		return IsValid(wep) and wep:GetClass() == 'weapon_octo_grenade_launcher'
	end,
	build = function(sm)
		local wep = LocalPlayer():GetActiveWeapon()
		local charges, cfg = wep:GetNetVar('charges', {}), wep.ChargeTypes
		local curCharge = wep:GetNetVar('charge')
		local delayed = wep:GetNetVar('chargeDelayed')
		for k, v in pairs(cfg) do
			local mo, pm = sm:AddSubMenu(('%s (%d/%d%s)'):format(v.name, charges[k] or 0, v.max, curCharge == k and ', заряжен' or ''))
				mo:AddOption('Мгновенного действия', function()
					netstream.Start('dbg-glauncher.applyCharge', k, false)
				end):SetChecked(curCharge == k and not delayed)
				mo:AddOption('Замедленного действия', function()
					netstream.Start('dbg-glauncher.applyCharge', k, true)
				end):SetChecked(curCharge == k and delayed)
			pm:SetIcon(octolib.icons.silk16(v.icon))
		end
	end,
})
