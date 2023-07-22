local meta = FindMetaTable 'Player'

local markerId = 1

function meta:AddMarker(data)
	if not data.id then
		data.id = 'marker_' .. markerId
		markerId = markerId + 1
	end
	netstream.Start(self, 'octolib.markers.add', data)

end

function meta:ClearMarkers(id)

	netstream.Start(self, 'octolib.markers.clear', id)

end
