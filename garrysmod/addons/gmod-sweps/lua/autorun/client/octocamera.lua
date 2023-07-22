CreateClientConVar('octocam_speed', '1', true, true)
CreateClientConVar('octocam_lerp_pos', '0.5', true, false)
CreateClientConVar('octocam_lerp_ang', '0.5', true, false)
CreateClientConVar('octocam_lerp_fov', '0.5', true, false)

local function sbMenu(p)

	p:NumSlider('Скорость движения', 'octocam_speed', 0.05, 3, 2)
	p:NumSlider('Сглаживание позиции', 'octocam_lerp_pos', 0.05, 2, 2)
	p:NumSlider('Сглаживание угла', 'octocam_lerp_ang', 0.05, 2, 2)
	p:NumSlider('Сглаживание FOV', 'octocam_lerp_fov', 0.05, 2, 2)

end

hook.Add('PopulateToolMenu', 'octocam', function()
	spawnmenu.AddToolMenuOption('Options', 'Player', 'Camera', 'OctoCamera', '', '', sbMenu)
end)