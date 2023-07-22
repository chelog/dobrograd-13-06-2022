local colBG = Color(0,0,0, 200)
local function paintToolbar(self, w, h)
	draw.RoundedBox(4, 0, 0, w, h, colBG)
end

hook.Add('octogui.f4-tabs', 'octomap', function()

	octogui.addToF4({
		order = 11.5,
		id = 'map',
		name = 'Карта',
		icon = Material('octoteam/icons/map.png'),
		build = function(f)
			f:SetSize(800, 600)
			f:SetSizable(true)
			f:DockPadding(0, 24, 0, 4)
			f:SetMinWidth(400)
			f:SetMinHeight(300)

			local map = f:Add 'octomap'
			map:SetOptions({ paddingR = 200 })

			local sb = map:Add 'DPanel'
			map.sidebar = sb
			sb:Dock(RIGHT)
			sb:SetWide(190)
			sb:DockMargin(5, 5, 5, 5)

			local lv = sb:Add 'DListView'
			lv:Dock(FILL)
			lv:DockMargin(3, 4, 3, 4)
			lv:AddColumn(''):SetFixedWidth(24) -- icon
			lv:AddColumn('Название')
			lv:SetHideHeaders(true)
			lv:SetDataHeight(24)
			lv:SetMultiSelect(false)
			function lv:OnRowSelected(i, line)
				local marker = octomap.getMarker(line.markerID)
				if not marker or not IsValid(map) then return end

				local sbID = marker.sidebarData.id
				if sbID then
					local l = map.sidebarIDs[sbID]
					marker = l[1]
					-- move marker to end of list to enable "scrolling through"
					if marker then
						table.remove(l, 1)
						l[#l + 1] = marker
					end
				end

				map:GoTo(marker.x, marker.y, octomap.config.scaleMax)
			end


			function lv:OnRowRightClick(i, line)

				local lp = LocalPlayer()
				local marker = octomap.getMarker(line.markerID)
				if not marker or not IsValid(map) then return end
				local m = DermaMenu()

				if marker.temp then
					m:AddOption('Удалить метку', function()
						octolib.markers.clear(marker.id)
						marker:Remove()
					end):SetIcon(octolib.icons.silk16('map_delete'))
				end
				if lp:query('DBG: Телепорт по команде') and (lp:Team() == TEAM_ADMIN) then
					m:AddOption('Телепортироваться', function()
						local pos = Vector(marker:GetPos()) + Vector(0, 0, 70)
						-- pos.z = octolib.space.getMapZ(pos.x, pos.y)
						netstream.Start('octologs.goto', pos, lp:GetAngles())
					end):SetIcon(octolib.icons.silk16('map_go'))
				end
				m:Open()
			end
			sb.list = lv

			local hasSidebarData = { sidebarData = { _exists = true }}

			sb.Paint = paintToolbar
			function sb:Refresh()
				local markers = octolib.table.toKeyVal(octolib.table.filterQuery(octomap.markers, hasSidebarData))
				table.sort(markers, function(a, b)
					if a[2].sort or b[2].sort then
						return (a[2].sort or 1000) < (b[2].sort or 1000)
					else
						return a[2].sidebarData.name < b[2].sidebarData.name
					end
				end)

				self.list:Clear()
				map.markerLines = {}
				map.sidebarIDs = {}

				local function createMarker(id, marker)
					local line = self.list:AddLine('', marker.sidebarData.name)
					local ip = vgui.Create 'DPanel'
					ip:SetPaintBackground(false)
					line:SetColumnText(1, ip)
					line.markerID = id
					map.markerLines[id] = line

					local icon = ip:Add 'DImage'
					icon:Dock(FILL)
					icon:DockMargin(6, 4, 2, 4)
					icon:SetImage(marker.iconPath)
				end

				for _, data in ipairs(markers) do
					local id, marker = unpack(data)

					local sbID = marker.sidebarData.id
					if sbID then
						if not map.sidebarIDs[sbID] then
							-- create only one line for grouped by sidebarID
							createMarker(id, marker)
							map.sidebarIDs[sbID] = { marker }
						else
							-- add reference for the rest
							local l = map.sidebarIDs[sbID]
							l[#l + 1] = marker
							map.markerLines[id] = map.markerLines[l[1].id]
						end
					else
						createMarker(id, marker)
					end
				end
			end

			function map:GetMarkerLine(marker)
				return self.markerLines[marker.id]
			end

			sb:Refresh()
			hook.Add('octomap.addedToSidebar', 'dbg-map', function(marker)
				if not IsValid(sb) then return hook.Remove('octomap.addedToSidebar', 'dbg-map') end
				sb:Refresh()
			end)

			local tb = map:Add 'DPanel'
			tb:Dock(LEFT)
			tb:DockMargin(5,5,5,5)
			tb:SetWide(23)
			tb:SetPaintBackground(false)

			local tbb = tb:Add 'DPanel'
			tbb.Paint = paintToolbar
			tbb:Dock(BOTTOM)
			tbb:SetTall(46)

			local zIn = tbb:Add 'DImageButton'
			zIn:SetPos(4, 4)
			zIn:SetSize(16, 16)
			zIn:SetImage(octolib.icons.silk16('magnifier_zoom_in'))
			function zIn:DoClick() map:Zoom(1, map:FromPanelToMap(map:GetViewCenter())) end

			local zOut = tbb:Add 'DImageButton'
			zOut:SetPos(4, 26)
			zOut:SetSize(16, 16)
			zOut:SetImage(octolib.icons.silk16('magnifier_zoom_out'))
			function zOut:DoClick() map:Zoom(-1, map:FromPanelToMap(map:GetViewCenter())) end

			octomap.pnl = map
		end,
	})

end)
