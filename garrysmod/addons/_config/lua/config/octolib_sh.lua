---------------------------------------------------------------------
-- GENERAL
---------------------------------------------------------------------
if CLIENT then
	netstream.Hook('octolib.cfg', function(cfg)
		table.Merge(CFG, cfg)
		hook.Run('octolib.configLoaded', CFG)
	end)
end

CFG.serverLang = 'ru'
CFG.serverGroupID = 'dbg_dev'
CFG.serverID = 'dbg_dev'
CFG.serverGroupIDvars = 'dbg'

CFG.disabledModules = {
	-- moduleName = true,
}

CFG.useDist = 84
CFG.useDistSqr = CFG.useDist * CFG.useDist
CFG.radioChatDistance = 250

---------------------------------------------------------------------
-- AFK
---------------------------------------------------------------------
CFG.afkTime = 60 * 3
CFG.afkKickTime = 60 * 30
CFG.afkAdminNotActive = 60 * 15
CFG.drawOverlay = true

---------------------------------------------------------------------
-- PLAYER
---------------------------------------------------------------------
CFG.playerTickTime = 1
hook.Add('octolib.eyeTraceFilter', 'dobrograd', function(ply, filter)
	filter[#filter + 1] = ply:GetNetVar('dragging')

	local job = ply:getJobTable()
	if job and not job.seesGhosts then
		for _, ghost in ipairs(player.GetGhosts()) do
			filter[#filter + 1] = ghost
		end
	end
end)

hook.Add('dbg-score.hidePlayer', 'launcher', function(ply)
	if not ply:GetNetVar('launcherActivated') then
		return true
	end
end)

CFG.reflectionTint = (game.GetMap():find('evocity') or game.GetMap():find('riverden')) and Color(255,255,255) or Color(0,0,0)

if CLIENT then
	---------------------------------------------------------------------
	-- SKIN
	---------------------------------------------------------------------
	local cols = {
		b = Color(65,132,209, 255),
		y = Color(240,202,77, 255),
		r = Color(222,91,73, 255),
		g = Color(102,170,170, 255),
		o = Color(170,119,102, 255),

		bg = Color(85,68,85, 255),
	}

	cols.bg95 = Color(cols.bg.r, cols.bg.g, cols.bg.b, 241)
	cols.bg60 = Color(cols.bg.r, cols.bg.g, cols.bg.b, 150)
	cols.bg50 = Color(cols.bg.r / 2, cols.bg.g / 2, cols.bg.b / 2, 255)

	cols.bg_d = Color(70,54,70, 255)
	cols.bg_l = Color(cols.bg.r * 1.25, cols.bg.g * 1.25, cols.bg.b * 1.25, 255)
	cols.bg_grey = Color(180,180,180, 255)
	cols.g_d = Color(cols.g.r * 0.75, cols.g.g * 0.75, cols.g.b * 0.75, 255)
	cols.r_d = Color(cols.r.r * 0.75, cols.r.g * 0.75, cols.r.b * 0.75, 255)

	cols.hvr = Color(0,0,0, 50)
	cols.dsb = Color(255,255,255, 50)

	CFG.skinColors = cols
end
