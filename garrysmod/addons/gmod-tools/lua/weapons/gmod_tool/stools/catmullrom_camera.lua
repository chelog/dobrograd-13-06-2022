TOOL.Category   = "Main"
TOOL.Name	   = "Camera Layout"
TOOL.Command	= nil
TOOL.ConfigName	= nil
TOOL.Tab		= "CRCCams"



TOOL.ClientConVar["key"] = "-1"

TOOL.ClientConVar["facetraveldir"] = "0"

TOOL.ClientConVar["bankonturn"]	= "1"
TOOL.ClientConVar["bankdelta_max"] = "1"
TOOL.ClientConVar["bank_multi"]	= "1"

TOOL.ClientConVar["zoom"] = "75"

TOOL.ClientConVar["enable_roll"] = "0"
TOOL.ClientConVar["roll"]		= "0"

--TOOL.ClientConVar["enable_stay_on_end"] = "0"
--TOOL.ClientConVar["enable_looping"]	 = "0"

function TOOL:LeftClick(trace)
	return CatmullRomCams.SToolMethods.Layout.LeftClick(self, trace)
end

function TOOL:RightClick(trace)
	return CatmullRomCams.SToolMethods.Layout.RightClick(self, trace)
end

function TOOL:Reload(trace)
	return CatmullRomCams.SToolMethods.Layout.Reload(self, trace)
end

function TOOL:Think()
	return CatmullRomCams.SToolMethods.Layout.Think(self)
end

function TOOL:ValidTrace(trace)
	return CatmullRomCams.SToolMethods.ValidTrace(trace)
end

function TOOL.BuildCPanel(panel)
	return CatmullRomCams.SToolMethods.Layout.BuildCPanel(panel)
end

