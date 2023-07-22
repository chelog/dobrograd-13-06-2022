-- halloween = halloween or {}

-- timer.Simple(0, function()
-- 	if CFG.dev then
-- 		octolib.client('halloween/cl_dev')
-- 	end
-- end)
-- octolib.client('halloween/cl_config')
-- octolib.client('halloween/cl_images')
octolib.client('halloween/cl_textures')
-- octolib.server('halloween/sv_images')

-- octolib.server('halloween/sv_sweets')
-- octolib.client('halloween/cl_halloween')

-- octolib.server('halloween/sv_rewards')
-- octolib.client('halloween/cl_rewards')
-- octolib.server('config/sweets-items')
hook.Add('dbg-char.firstSpawn', 'dbg-halloween.theme', function(ply)
	if ply:GetDBVar('halloweenTheme') then
		ply:SetLocalVar('halloweenTheme', true)
		ply:ConCommand('octogui_reloadf4')
	end
end)
