local STool = {}
  
local function BuildBitFlagMessage(keys)
	local key_data = 0
	
	for k, v in pairs(keys) do
		key_data = key_data + (2 ^ k)
	end
	print("Key data: ", key_data)
	return key_data
end

local function ExtractBitFlagMessage(key_data)
	local keys = {}
	
	for i = 15, 1, -1 do
		local bin_flag = 2 ^ i
		
		if (key_data and bin_flag) == bin_flag then
			key_data = key_data - bin_flag
			
			keys[i] = i
		end
	end
	
	return keys
end 

CatmullRomCams.SToolMethods.NumPadTrigger = STool

function STool.LeftClick(self, trace)
	if not self:ValidTrace(trace) then return end
	if not SERVER then return true end
	
	local key_data = self:GetClientNumber("keys")
	
	trace.Entity.OnNodeTriggerNumPadKey = {Keys = ExtractBitFlagMessage(key_data), Hold = (self:GetClientNumber("hold") == 1)}
	
	return true
end

function STool.RightClick(self, trace)
	if not self:ValidTrace(trace) then return end
	if CLIENT then return true end
	if not trace.Entity.OnNodeTriggerNumPadKey then return end
	
	self:GetOwner():SendLua("CatmullRomCams.SToolMethods.NumPadTrigger.CopyNumPadSettings(" .. BuildBitFlagMessage(trace.Entity.OnNodeTriggerNumPadKey.Keys) .. ");\n")
	
	return true
end

function STool.CopyNumPadSettings(key_data)
	return STool.CtrlNumPadMulti:SetupKeys(ExtractBitFlagMessage(key_data))
end

function STool.Reload(self, trace)
	if not self:ValidTrace(trace) then return end
	if not SERVER then return true end
	
	trace.Entity.OnNodeTriggerNumPadKey = nil
	
	return true
end

function STool.Think(self)
	if SERVER then return end
	
	local ply = LocalPlayer()
	local tr = ply:GetEyeTrace()
	
	if not self:ValidTrace(tr) then return end
	if not tr.Entity.OnNodeTriggerNumPadKey then return end
	
	--AddWorldTip(tr.Entity:EntIndex(), "Key To Trigger: " .. tostring(tr.Entity.OnNodeTriggerNumPadKey), 0.5, tr.Entity:GetPos(), tr.Entity)
end

function STool.BuildCPanel(panel)
	STool.CtrlNumPadMulti = vgui.Create("CtrlNumPadMulti", panel) -- DNumPadMulti
	STool.CtrlNumPadMulti:SetLabel("Keys To Trigger Then Node Is Reached: ")
	STool.CtrlNumPadMulti:SetConVar("catmullrom_camera_numpad_trigger_keys")
	panel:AddPanel(STool.CtrlNumPadMulti)
	
	panel:AddControl("CheckBox", {Label = "Hold Key", Description = "Should the just toggle the key or should it press it and then release it? (Careful with this!)", Command = "catmullrom_camera_numpad_trigger_hold"})
end

