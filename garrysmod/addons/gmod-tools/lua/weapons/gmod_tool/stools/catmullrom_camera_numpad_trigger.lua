TOOL.Category   = "Event Triggering"
TOOL.Name	   = "Numpad Trigger Editor"
TOOL.Command	= nil
TOOL.ConfigName	= nil
TOOL.Tab		= "CRCCams"


TOOL.ClientConVar["keys"] = "-1"
TOOL.ClientConVar["hold"] = "0"

function TOOL:LeftClick(trace)
	return CatmullRomCams.SToolMethods.NumPadTrigger.LeftClick(self, trace)
end

function TOOL:RightClick(trace)
	return CatmullRomCams.SToolMethods.NumPadTrigger.RightClick(self, trace)
end

function TOOL:Reload(trace)
	return CatmullRomCams.SToolMethods.NumPadTrigger.Reload(self, trace)
end

function TOOL:Think()
	return CatmullRomCams.SToolMethods.NumPadTrigger.Think(self)
end

function TOOL:ValidTrace(trace)
	return CatmullRomCams.SToolMethods.ValidTrace(trace)
end

function TOOL.BuildCPanel(panel)
	return CatmullRomCams.SToolMethods.NumPadTrigger.BuildCPanel(panel)
end
