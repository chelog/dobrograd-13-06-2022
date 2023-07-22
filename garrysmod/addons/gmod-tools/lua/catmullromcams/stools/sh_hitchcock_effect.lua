local STool = {}

CatmullRomCams.SToolMethods.HitchcockEffect = STool

local function Calc(width, end_fov)
	return (width / (2 * math.tan(math.pi * (end_fov / 360))))
end

local function MakeLabel()
	return ("Distance required for shot: " .. Calc(STool.DurationSlider:GetValue(), STool.EndFOVSlider:GetValue()) .. " Meters")
end

local function CreateNode(ply, plyID, key, pos, ang, fov, width)
	local track_index = #CatmullRomCams.Tracks[plyID][key] + 1
	print(track_index)
	local camera = ents.Create("sent_catmullrom_camera")
	if not (camera and camera.IsValid and camera:IsValid()) then return end
	
	camera:SetAngles(ang)
	camera:SetPos(pos)
	camera:Spawn()
	
	camera:SetPlayer(ply)
	
	CatmullRomCams.Tracks[plyID][key][track_index - 1]:DeleteOnRemove(camera) -- Because we don't want to have broken chains let's daisy chain them to self destruct
	CatmullRomCams.Tracks[plyID][key][track_index - 1]:SetNetVar("ChildCamera", camera)
	
	CatmullRomCams.Tracks[plyID][key][track_index] = camera
	
	camera:SetFaceTravelDir(false)
	
	camera:SetBankOnTurn(false)
	camera:SetBankDeltaMax(1)
	camera:SetBankMultiplier(1)
	
	camera:SetZoom(fov)
	camera:SetEnableRoll(false)
	camera:SetRoll(0)
	
	camera:SetNetVar("MasterController", CatmullRomCams.Tracks[plyID][key][1])
	
	camera.UndoData = {}
	camera.UndoData.PID = plyID
	camera.UndoData.Key = key
	camera.UndoData.TrackIndex = track_index
	
	ply:AddCleanup("catmullrom_cameras", camera)
	
	return {camera, constraint.NoCollide(camera, CatmullRomCams.Tracks[plyID][key][1], 0, 0)}
end

function STool.CheckDistances(pos, aim, dist, ply)
	local endpos = pos + (aim * (CatmullRomCams.SH.MetersToUnits(dist) * -1 - 20))
	local trace  = {}
	trace.start  = pos
	trace.endpos = endpos
	trace.mask   = MASK_NPCWORLDSTATIC
	
	trace = util.TraceLine(trace)
	
	local dist_a   = CatmullRomCams.SH.UnitsToMeters(pos:Distance(trace.HitPos))
	
	if (trace.Fraction == 1) then return true end
	print(trace.Fraction)
	print(dist_a)
	print(dist)
	print(CatmullRomCams.SH.MetersToUnits(dist) * -1 - 20)
	local TextA = "Error: You do not have enough clearance room to make this shot!"
	local TextB = "Error: Clearance is " .. math.Round(dist_a) .. " of " .. math.Round(dist) .. " meters. An additional " .. ((1 - trace.Fraction) * dist) .. " meters is required."
	
	ply:SendLua("GAMEMODE:AddNotify('" .. TextA .. "', NOTIFY_GENERIC, 10)")
	ply:SendLua("GAMEMODE:AddNotify('" .. TextB .. "', NOTIFY_GENERIC, 10)")
	
	ply:SendLua("surface.PlaySound('ambient/water/drip" .. math.random(1, 4) .. ".wav')")
end

local function UndoHitchcock(ent)
	if ent and ent.IsValid and ent:IsValid() and ent.SetHitchcockEffect then
		ent:SetHitchcockEffect(nil)
	end
end

function STool.LeftClick(self, trace)
	if not self:ValidTrace(trace) then return end
	
	local ply   = self:GetOwner()
	local plyID = ply:UniqueID()
	local pos   = trace.Entity:GetPos()
	local aim   = trace.Entity:GetForward()
	local ang   = trace.Entity:GetAngles()
	local fov   = self:GetClientNumber("endfov")
	local width = self:GetClientNumber("width")
	local dist  = Calc(width, fov)
	
	if not STool.CheckDistances(pos, aim, dist, ply) then return end
	if CLIENT then return true end
	
	local key = trace.Entity.UndoData.Key
	
	print(width)
	trace.Entity:SetHitchcockEffect(width)
	
	undo.Create("CatmullRomCamsHitchcockEffect")
		for i = 1, 2 do
			local pos = (i == 1) and (pos + (aim * CatmullRomCams.SH.MetersToUnits(dist) * -1)) or (pos + (aim * (CatmullRomCams.SH.MetersToUnits(dist) * -1 - 20)))
			local tbl = CreateNode(ply, plyID, key, pos, ang, fov, width)
			
			undo.AddEntity(tbl[1])
			undo.AddEntity(tbl[2])
		end
		
		undo.AddFunction(UndoHitchcock, trace.Entity)
		undo.SetPlayer(ply)
	undo.Finish()
	
	return true
end

function STool.RightClick(self, trace)
end

function STool.Reload(self, trace)
end

function STool.Think(self)
end

function STool.BuildCPanel(panel)
	STool.DurationSlider = panel:AddControl("Slider", {Label = "Scene Width (Meters): ",		  Type = "Float", Min = "0.1", Max = "25",  Command = "catmullrom_camera_hitchcock_width"})
	STool.EndFOVSlider   = panel:AddControl("Slider", {Label = "End FOV: ", Type = "Float", Min = "0.1", Max = "110", Command = "catmullrom_camera_hitchcock_endfov"})
	STool.ETDLabel	   = panel:AddControl("Label",  {Text = MakeLabel(), Description = "How much space do we need for this shot?"})
	
	function STool.DurationSlider:OnValueChanged(val)
		return STool.ETDLabel:SetText(MakeLabel())
	end
	
	function STool.EndFOVSlider:OnValueChanged(val)
		return STool.ETDLabel:SetText(MakeLabel())
	end
end