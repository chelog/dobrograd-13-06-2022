TOOL.Category   = "Behavior Modifiers"
TOOL.Name	   = "Smart Look"
TOOL.Command	= nil
TOOL.ConfigName	= nil
TOOL.Tab		= "CRCCams"


TOOL.ClientConVar["block"]   = tostring(MASK_OPAQUE)
TOOL.ClientConVar["target"]  = "1"
TOOL.ClientConVar["range"]   = "512"
TOOL.ClientConVar["percent"] = "1"
TOOL.ClientConVar["closest"] = "0"

function TOOL:LeftClick(trace)
	return CatmullRomCams.SToolMethods.SmartLook.LeftClick(self, trace)
end

function TOOL:RightClick(trace)
	return CatmullRomCams.SToolMethods.SmartLook.RightClick(self, trace)
end

function TOOL:Reload(trace)
	return CatmullRomCams.SToolMethods.SmartLook.Reload(self, trace)
end

function TOOL:Think()
	return CatmullRomCams.SToolMethods.SmartLook.Think(self)
end

function TOOL:ValidTrace(trace)
	return CatmullRomCams.SToolMethods.ValidTrace(trace)
end

function TOOL.BuildCPanel(panel)
	return CatmullRomCams.SToolMethods.SmartLook.BuildCPanel(panel)
end

