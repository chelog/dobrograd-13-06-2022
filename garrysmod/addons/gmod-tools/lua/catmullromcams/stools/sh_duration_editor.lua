local STool = {}

CatmullRomCams.SToolMethods.DurationEditor = STool

function STool.LeftClick(self, trace)
	if not self:ValidTrace(trace) then return end
	if CLIENT then return true end

	local dur = self:GetClientNumber("duration") or 2

	if self:GetOwner():KeyDown(IN_SPEED) and CatmullRomCams.Tracks[trace.Entity.UndoData.PID][trace.Entity.UndoData.Key][trace.Entity.UndoData.TrackIndex + 1] then
		dur = CatmullRomCams.SH.UnitsToMeters(trace.Entity:GetPos():Distance(CatmullRomCams.Tracks[trace.Entity.UndoData.PID][trace.Entity.UndoData.Key][trace.Entity.UndoData.TrackIndex + 1]:GetPos())) / self:GetClientNumber("duration_mps")
	end

	trace.Entity:SetNetVar("Duration", (dur > 0.001) and dur or 0.001)

	return true
end

function STool.RightClick(self, trace)
	if not self:ValidTrace(trace) then return end

	local dur = trace.Entity:GetNetVar("Duration") or 2

	self:GetOwner():ConCommand("catmullrom_camera_duration_duration " .. ((dur > 0) and dur or 2) .. "\n")

	return true
end

function STool.Reload(self, trace)
	if not self:ValidTrace(trace) then return end

	trace.Entity:SetNetVar("Duration", 2)

	return true
end

function STool.Think(self)
	if SERVER then return end

	local ply = LocalPlayer()
	local tr = ply:GetEyeTrace()

	if not self:ValidTrace(tr) then return end

	local dur = tr.Entity:GetNetVar("Duration", 0)
	dur = (dur ~= 0) and dur or 2

	AddWorldTip(tr.Entity:EntIndex(), "Duration: " .. dur, 0.5, tr.Entity:GetPos(), tr.Entity )
end

function STool.BuildCPanel(panel)
	panel:AddControl("Slider", {Label = "Node Duration: ", Type = "Float", Min = "0.001", Max = "10", Command = "catmullrom_camera_duration_duration"})
	panel:AddControl("Slider", {Label = "Node Duration, Meters Per Seconds: ", Type = "Float", Min = "0.001", Max = "10", Command = "catmullrom_camera_duration_duration_mps"})
end
