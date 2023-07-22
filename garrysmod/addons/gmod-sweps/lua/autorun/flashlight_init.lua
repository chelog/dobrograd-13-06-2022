-- Since people have had trouble with stuck flashlight spots
-- and I've failed to eliminate the problem so far, I'm adding
-- this as a temporary workaround.
cleanup.Register('flspot')

local disabledWeps = octolib.array.toKeys {'gmod_tool', 'weapon_physgun', 'dbg_admingun', 'gmod_camera'}

local function FlashlightBind(ply, ucmd)
	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) then return ucmd:SetImpulse(0) end
	if ucmd:GetImpulse() == 100 then
		if disabledWeps[wep:GetClass()] or wep.HasFlashlight then
			if ply:HasWeapon('weapon_flashlight') then return end
		else
			if wep:GetClass() == 'weapon_flashlight' then
				RunConsoleCommand('lastinv')
			else
				RunConsoleCommand('use', 'weapon_flashlight')
			end
		end
		ucmd:SetImpulse(0)
	end
end
hook.Add('StartCommand', 'SWEP FlashlightBind', FlashlightBind)

hook.Add('PlayerSwitchWeapon', 'dbg-flashlight', function(ply, old, new)
	if SERVER and ply:FlashlightIsOn() and not (disabledWeps[new:GetClass()] or new.HasFlashlight) then ply:Flashlight(false) end
end)

if (CLIENT) then
	local function LightOptions(CPanel)
		-- HEADER
		CPanel:AddControl('Header', { Description = 'Server Settings' } )
		CPanel:AddControl('Header', { Description = 'Client Settings' } )

		CPanel:AddControl('Checkbox', { Label = 'Refresh Light on Reload', Command = 'cl_flashlight_allow_refresh' })
	end

	hook.Add('PopulateToolMenu', 'AddFLMenu', function()
		spawnmenu.AddToolMenuOption('Options', 'Flashlight', 'FlashlightSettings', 'Settings', '', '', LightOptions)
	end)

	language.Add('cleanup_flspot', 'Flashlight Spots')
	language.Add('cleaned_flspot', 'Removed Flashlight Spots')

	RunConsoleCommand('r_shadows', 1)
end
