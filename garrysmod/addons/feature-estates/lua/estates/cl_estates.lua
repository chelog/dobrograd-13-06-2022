dbgEstates = dbgEstates or {}
local empty = {}

local function data()
	return netvars.GetNetVar('dbg-estates', empty)
end

--[[
	(table)
	Returns a data about estate,
	or an empty table if data is missing.
]]
function dbgEstates.getData(estIdx)
	return estIdx and data()[estIdx] or empty
end

--[[
	(bool)
	Returns wether estate with this id exists
]]
function dbgEstates.exists(estIdx)
	return data()[estIdx] ~= nil
end

local permaMarkers = {}
hook.Add('octolib.netVarUpdate', 'dbg-estates', function(_, name, data)
	if name == 'dbg-estates' then
		for k,v in pairs(permaMarkers) do
			if not data[k] or not data[k].marker or not data[k].marker.perma then
				v:Remove()
			end
		end
		for k,v in pairs(data) do
			if v.marker and v.marker.perma then
				local mData = v.marker
				if not permaMarkers[k] or permaMarkers[k].removed then
					permaMarkers[k] = octomap.createMarker('est_' .. k):SetClickable(true)
					permaMarkers[k].LeftClick = octomap.sidebarMarkerClick
				end
				permaMarkers[k]:SetIcon(mData.icon):SetPos(mData.pos):AddToSidebar(mData.name, mData.group or ('est_' .. k))
				permaMarkers[k].sort = mData.sort
			end
		end
	end
end)
