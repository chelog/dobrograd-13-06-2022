TOOL.Category   = "Event Triggering"
TOOL.Name	   = "Map I/O Editor"
TOOL.Command	= nil
TOOL.ConfigName	= nil
TOOL.Tab		= "CRCCams"


TOOL.ClientConVar["user1"] = "0"
TOOL.ClientConVar["user2"] = "0"
TOOL.ClientConVar["user3"] = "0"
TOOL.ClientConVar["user4"] = "0"

function TOOL:LeftClick(trace)
	return CatmullRomCams.SToolMethods.MapIOEditor.LeftClick(self, trace)
end

function TOOL:RightClick(trace)
	return CatmullRomCams.SToolMethods.MapIOEditor.RightClick(self, trace)
end

function TOOL:Reload(trace)
	return CatmullRomCams.SToolMethods.MapIOEditor.Reload(self, trace)
end

function TOOL:Think()
	return CatmullRomCams.SToolMethods.MapIOEditor.Think(self)
end

function TOOL:ValidTrace(trace)
	return CatmullRomCams.SToolMethods.ValidTrace(trace)
end

function TOOL.BuildCPanel(panel)
	return CatmullRomCams.SToolMethods.MapIOEditor.BuildCPanel(panel)
end

