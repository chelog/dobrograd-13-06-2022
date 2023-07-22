local STool = {}

CatmullRomCams.SToolMethods.Linker = STool

STool.EntA = nil

local Hackz = {}

function STool.LeftClick(self, trace)
	if not self:ValidTrace(trace) then return end
	if CLIENT then return true end
	
	local ply   = self:GetOwner()
	local plyID = ply:UniqueID()
	
	if not trace.Entity.UndoData.PID == plyID then return end
	
	if not Hackz[ply] then
		Hackz[ply] = trace.Entity.UndoData.Key
		
		self:SetStage(1)
		
		return true
	else
		local newkey		= trace.Entity.UndoData.Key
		
		local newcontroller = CatmullRomCams.Tracks[plyID][newkey][1]
		local newtrackcount = #CatmullRomCams.Tracks[plyID][newkey]
		
		local tbl_track	 = {} -- so we don't instate side effects
		
		for k, v in ipairs(CatmullRomCams.Tracks[plyID][Hackz[ply]]) do
			if k == 1 then -- remove 'is controller' flag & set it to be a child of the last node of the other track
				v:SetNetVar("IsMasterController", false)
				v:SetNetVar("ControllingPlayer", NULL)
				
				local last_cam = CatmullRomCams.Tracks[plyID][newkey][newtrackcount]
				last_cam:DeleteOnRemove(v) -- Because we don't want to have broken chains let's daisy chain them to self destruct
				last_cam:SetNetVar("ChildCamera", v)
			end
			
			-- change key, change track id & update controller
			v.UndoData.Key = newkey
			v.UndoData.TrackIndex = newtrackcount + k
			
			v:SetNetVar("MasterController", newcontroller)
			
			tbl_track[newtrackcount + k] = v
		end
		
		CatmullRomCams.Tracks[plyID][Hackz[ply]] = {}
		
		table.Merge(CatmullRomCams.Tracks[plyID][Hackz[ply]], tbl_track)
		
		self:SetStage(0)
		Hackz[ply] = nil
		
		return true
	end
end

function STool.RightClick(self, trace)
	if not self:ValidTrace(trace) then return end
end

function STool.Reload(self, trace)
	if self:GetStage() == 1 then
		self:SetStage(0)
		
		Hackz[self:GetOwner()] = nil
		
		return true
	end
end

function STool.Think(self)
	if SERVER then return end
end

function STool.BuildCPanel(panel)
end