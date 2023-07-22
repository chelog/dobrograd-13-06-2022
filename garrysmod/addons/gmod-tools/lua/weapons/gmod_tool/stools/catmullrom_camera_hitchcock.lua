TOOL.Category   = "Behavior Modifiers"
TOOL.Name	   = "Hitchcock Effect"
TOOL.Command	= nil
TOOL.ConfigName	= nil
TOOL.Tab		= "CRCCams"


TOOL.ClientConVar["width"]  = "4"
TOOL.ClientConVar["endfov"] = "25"

function TOOL:LeftClick(trace)
	return CatmullRomCams.SToolMethods.HitchcockEffect.LeftClick(self, trace)
end

function TOOL:RightClick(trace)
	return CatmullRomCams.SToolMethods.HitchcockEffect.RightClick(self, trace)
end

function TOOL:Reload(trace)
	return CatmullRomCams.SToolMethods.HitchcockEffect.Reload(self, trace)
end

function TOOL:Think()
	return CatmullRomCams.SToolMethods.HitchcockEffect.Think(self)
end

function TOOL:ValidTrace(trace)
	return CatmullRomCams.SToolMethods.ValidTrace(trace)
end

function TOOL.BuildCPanel(panel)
	return CatmullRomCams.SToolMethods.HitchcockEffect.BuildCPanel(panel)
end

