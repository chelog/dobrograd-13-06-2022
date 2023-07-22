TOOL.Category   = "Behavior Modifiers"
TOOL.Name	   = "Duration Editor"
TOOL.Command	= nil
TOOL.ConfigName	= nil
TOOL.Tab		= "CRCCams"


TOOL.ClientConVar["duration"] = "2"
TOOL.ClientConVar["duration_mps"] = "1"

function TOOL:LeftClick(trace)
	return CatmullRomCams.SToolMethods.DurationEditor.LeftClick(self, trace)
end

function TOOL:RightClick(trace)
	return CatmullRomCams.SToolMethods.DurationEditor.RightClick(self, trace)
end

function TOOL:Reload(trace)
	return CatmullRomCams.SToolMethods.DurationEditor.Reload(self, trace)
end

function TOOL:Think()
	return CatmullRomCams.SToolMethods.DurationEditor.Think(self)
end

function TOOL:ValidTrace(trace)
	return CatmullRomCams.SToolMethods.ValidTrace(trace)
end

function TOOL.BuildCPanel(panel)
	return CatmullRomCams.SToolMethods.DurationEditor.BuildCPanel(panel)
end

