
function CatmullRomCams.CL.Tab()
	return spawnmenu.AddToolTab("CRCCams", "CRCCams", "icon16/camera.png")
end
hook.Add("AddToolMenuTabs", "CatmullRomCams.CL.Tab", CatmullRomCams.CL.Tab)
