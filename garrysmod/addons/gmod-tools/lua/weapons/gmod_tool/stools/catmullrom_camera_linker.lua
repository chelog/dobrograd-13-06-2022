TOOL.Category   = "Behavior Modifiers"
TOOL.Name	   = "Linker"
TOOL.Command	= nil
TOOL.ConfigName	= nil
TOOL.Tab		= "CRCCams"


function TOOL:LeftClick(trace)
	return CatmullRomCams.SToolMethods.Linker.LeftClick(self, trace)
end

function TOOL:RightClick(trace)
	return CatmullRomCams.SToolMethods.Linker.RightClick(self, trace)
end

function TOOL:Reload(trace)
	return CatmullRomCams.SToolMethods.Linker.Reload(self, trace)
end

function TOOL:Think()
	return CatmullRomCams.SToolMethods.Linker.Think(self)
end

function TOOL:ValidTrace(trace)
	return CatmullRomCams.SToolMethods.ValidTrace(trace)
end

function TOOL.BuildCPanel(panel)
	return CatmullRomCams.SToolMethods.Linker.BuildCPanel(panel)
end

