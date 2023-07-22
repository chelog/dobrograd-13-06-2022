hook.Remove('PreDrawHalos', 'PropertiesHover')

hook.Add('GUIMousePressed', 'PropertiesClick', function(code, vector)
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if not IsValid(vgui.GetHoveredPanel()) or not vgui.GetHoveredPanel():IsWorldClicker() then return end

	if code == MOUSE_RIGHT and not input.IsButtonDown(MOUSE_LEFT) then
		properties.OnScreenClick(ply:GetShootPos(), vector)
	end
end)

local wasPressed = false
hook.Add('PreventScreenClicks', 'PropertiesPreventClicks', function()

	if not input.IsButtonDown( MOUSE_RIGHT) then wasPressed = false end
	if wasPressed and input.IsButtonDown(MOUSE_RIGHT) and not input.IsButtonDown(MOUSE_LEFT) then return true end
	if not IsValid(vgui.GetHoveredPanel()) or not vgui.GetHoveredPanel():IsWorldClicker() then return end

	local ply = LocalPlayer()
	if not IsValid(ply) then return end

	--
	-- Are we pressing the right mouse button?
	-- (We check whether we're pressing the left too, to allow for physgun freezes)
	--
	if input.IsButtonDown(MOUSE_RIGHT) and not input.IsButtonDown(MOUSE_LEFT) then
		--
		-- Are we hovering an entity? If so, then stomp the action
		--
		local hovered = properties.GetHovered(ply:GetShootPos(), ply:GetAimVector())

		if IsValid(hovered) then
			wasPressed = true
			return true
		end
	end

end)

local restrictedEnts = {
	gmod_sent_vehicle_fphysics_base = true,
	gmod_sent_vehicle_fphysics_wheel = true,
}

hook.Add('CanProperty', 'dbg-tools', function(ply, name, ent)
	if not IsValid(ent) then return end

	if ent:IsDoor() and name ~= 'collision' and name ~= 'bodygroups' and name ~= 'skin' then
		return false
	end
	if ent:GetClass() == 'prop_effect' and name == 'collision' then
		return false
	end
	if restrictedEnts[ent:GetClass()] and not (ply:query('DBG: Изменять автомобили') or name == 'skin' and ply:IsAdmin()) then
		return false
	end
	if GAMEMODE.Config.allowedProperties[name] then
		return true
	end
	if name == 'persist' and ply:IsSuperAdmin() then
		return true
	end

	return false
end)
