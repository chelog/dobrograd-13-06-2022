local STool = {}

CatmullRomCams.SToolMethods.SmartLook = STool

function STool.LeftClick(self, trace)
	if not self:ValidTrace(trace) then return end
	if CLIENT then return true end
	
	trace.Entity:SetSmartLook(true)
	trace.Entity:SetSmartLookPerc(self:GetClientNumber("percent"))
	trace.Entity:SetSmartLookRange(self:GetClientNumber("range") or 512)
	trace.Entity:SetSmartLookTraceFilter(self:GetClientNumber("block") or 0)
	trace.Entity:SetSmartLookTargetFilter(self:GetClientNumber("target") or 1)
	trace.Entity:SetSmartLookClosest(self:GetClientNumber("closest") == 1)
	
	return true
end

function STool.RightClick(self, trace)
	if not self:ValidTrace(trace) then return end
	if CLIENT then return end
	
	--return true
end

function STool.Reload(self, trace)
	if not self:ValidTrace(trace) then return end
	if CLIENT then return true end
	
	trace.Entity:SetSmartLook(false)
	trace.Entity:SetSmartLookPerc(1)
	trace.Entity:SetSmartLookRange(512)
	trace.Entity:SetSmartLookTraceFilter(2)
	trace.Entity:SetSmartLookTargetFilter(1)
	
	return true
end

function STool.Think(self)
end

function STool.BuildCPanel(panel)
	local block_filter_listbox = {}
	block_filter_listbox.Label = "Filters For LOS: "
	block_filter_listbox.Options = {}
	block_filter_listbox.Options["NPC Static"]	  = {catmullrom_camera_looker_block = MASK_NPCWORLDSTATIC}
	block_filter_listbox.Options["Solid-To-NPC"]	= {catmullrom_camera_looker_block = MASK_NPCSOLID_BRUSHONLY}
	block_filter_listbox.Options["Solid-To-Player"] = {catmullrom_camera_looker_block = MASK_PLAYERSOLID_BRUSHONLY}
	block_filter_listbox.Options["Solid Brush"]	 = {catmullrom_camera_looker_block = MASK_SOLID_BRUSHONLY}
	block_filter_listbox.Options["Shot Hull"]	   = {catmullrom_camera_looker_block = MASK_SHOT_HULL}
	block_filter_listbox.Options["Shot"]			= {catmullrom_camera_looker_block = MASK_SHOT}
	block_filter_listbox.Options["Opaque"]		  = {catmullrom_camera_looker_block = MASK_OPAQUE}
	block_filter_listbox.Options["Water"]		   = {catmullrom_camera_looker_block = MASK_WATER}
	block_filter_listbox.Options["NPC Solid"]	   = {catmullrom_camera_looker_block = MASK_NPCSOLID}
	block_filter_listbox.Options["Player Solid"]	= {catmullrom_camera_looker_block = MASK_PLAYERSOLID}
	block_filter_listbox.Options["Solid"]		   = {catmullrom_camera_looker_block = MASK_SOLID}
	block_filter_listbox.Options["Everything"]	  = {catmullrom_camera_looker_block = MASK_ALL}
	block_filter_listbox.Options["Nothing"]		 = {catmullrom_camera_looker_block = 0}
	
	local target_filter_listbox = {}
	target_filter_listbox.Label = "Filters For Potential Targets: "
	target_filter_listbox.Options = {}
	target_filter_listbox.Options["Anything"]			 = {catmullrom_camera_looker_target = 1}
	target_filter_listbox.Options["Fire + Ignited Stuff"] = {catmullrom_camera_looker_target = 2}
	target_filter_listbox.Options["Props"]				= {catmullrom_camera_looker_target = 3}
	target_filter_listbox.Options["Has Physics Object"]   = {catmullrom_camera_looker_target = 4}
	target_filter_listbox.Options["NPCs"]				 = {catmullrom_camera_looker_target = 5}
	target_filter_listbox.Options["Players"]			  = {catmullrom_camera_looker_target = 6}
	target_filter_listbox.Options["Light Entities"]	   = {catmullrom_camera_looker_target = 7}
	target_filter_listbox.Options["Particle Systems"]	 = {catmullrom_camera_looker_target = 8}
	
	panel:AddControl("Label",  {Text = "Filters For LOS: ", Description = "What should block our line of sight check?"})
	panel:AddControl("listbox", block_filter_listbox) 
	
	panel:AddControl("Label",  {Text = "Filters For Potential Targets: ", Description = "What sort of things should we look for?"})
	panel:AddControl("listbox", target_filter_listbox) 
	
	panel:AddControl("Slider",  {Label = "Percent: ", Description = "How much should we apply the look?", Type = "Float", Min = ".01", Max = "1", Command = "catmullrom_camera_looker_percent"})
	panel:AddControl("Slider",  {Label = "Range: ", Description = "How far should we look?", Type = "Float", Min = "32", Max = "4096", Command = "catmullrom_camera_looker_range"})
	panel:AddControl("CheckBox", {Label = "Closest Target", Description = "Do I NEEED to look for the closest target? Or can I just pick the first one I find?", Command = "catmullrom_camera_looker_closest"})
end



