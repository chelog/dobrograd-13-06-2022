local maps = {
	rp_evocity_dbg_220222 = {
		{
			name = 'Причал',
			icon = 'octoteam/icons-16/clown_fish.png',
			pos = Vector(-6853, 13605, 188),
		}, {
			name = 'Банкомат',
			icon = 'octoteam/icons-16/card_money.png',
			sort = 1200,
			pos = {
				Vector(-6734, -11709, 137),
				Vector(-10355, -12781, 138),
				Vector(-5726, -9718, 135),
				Vector(4329, 5759, 132),
				Vector(-4791, -6135, 263),
			},
		}, {
			name = 'Шахта',
			icon = 'octoteam/icons-16/helmet_mine.png',
			sort = 1200,
			pos = Vector(11329, 5403, 185),
		},
	},
	rp_eastcoast_v4c = {
		{
			name = 'Банкомат',
			icon = 'octoteam/icons-16/card_money.png',
			sort = 1200,
			pos = Vector(911, 113, 32),
		},
	},
	rp_truenorth_v1a = {
		{
			name = 'Шахта',
			icon = 'octoteam/icons-16/helmet_mine.png',
			sort = 1200,
			pos = Vector(10388, -5966, 5377),
		}, {
			name = 'Банкомат',
			icon = 'octoteam/icons-16/card_money.png',
			sort = 1200,
			pos = {
				Vector(12134, 9322, 0),
				Vector(7143, 2718, 0),
				Vector(7834, 12721, 0),
				Vector(-8404, -9142, 0),
			},
		},
	},
	rp_riverden_dbg_220313 = {
		{
			name = 'Шахта',
			icon = 'octoteam/icons-16/helmet_mine.png',
			sort = 1200,
			pos = Vector(6888, 1590, 70),
		}, {
			name = 'Церковь',
			icon = 'octoteam/icons-16/church.png',
			sort = 1201,
			pos = Vector(-10078, 6336, -192),
		}, {
			name = 'Вокзал',
			icon = 'octoteam/icons-16/train_metro.png',
			sort = 1202,
			pos = Vector(-12800, 13504, 64),
		}, {
			name = 'Заправка',
			icon = 'octoteam/icons-16/gas.png',
			sort = 1203,
			pos = {
				Vector(-656, 13246, 64),
				Vector(-9439, 2595, -192),
				Vector(6656, -13696, 868),
			},
		}, {
			name = 'Банкомат',
			icon = 'octoteam/icons-16/card_money.png',
			sort = 1204,
			pos = {
				Vector(-12268, 14650, 0),
				Vector(-13808, 3936, -255),
				Vector(-4381, 1807, -255),
				Vector(-4623, 10204, 0),
				Vector(-9536, 10992, 0),
			},
		},
	},
}

local mapMarkers = maps[game.GetMap()] or {}

function octomap.sidebarMarkerClick(self, map)

	if not map.GetMarkerLine then return end

	local line = map:GetMarkerLine(self)
	if not IsValid(line) then return end

	line:GetListView():OnClickLine(line, true)
	line:OnSelect()

end

hook.Add('Think', 'octomap.addMarkers', function()

	hook.Remove('Think', 'octomap.addMarkers')

	for i, v in ipairs(mapMarkers) do
		if istable(v.pos) then
			for i2, pos in ipairs(v.pos) do
				local m = octomap.createMarker('dbg' .. i .. '_' .. i2)
					:SetIcon(v.icon)
					:SetPos(pos)
					:SetClickable(true)
					:AddToSidebar(v.name, 'dbg' .. i)

				m.sort = v.sort
				m.LeftClick = octomap.sidebarMarkerClick
			end
		else
			local m = octomap.createMarker('dbg' .. i)
				:SetIcon(v.icon)
				:SetPos(v.pos)
				:SetClickable(true)
				:AddToSidebar(v.name)

			m.sort = v.sort
			m.LeftClick = octomap.sidebarMarkerClick
		end
	end

	local ply = octomap.createMarker('__me')
		:SetIcon('octoteam/icons-16/bullet_red.png')
		:AddToSidebar('Ты')

	ply.sort = -1000

	local lp = LocalPlayer()
	function ply:Paint(x, y, map)

		local scale = map.scale
		self:SetPos(lp:GetPos())

		local p = {
			{ x = 0, y = 0 },
			{ x = 100 * scale, y = -50 * scale },
			{ x = 100 * scale, y = 50 * scale },
		}

		octolib.poly.rotate(p, -lp:GetAngles().y)
		octolib.poly.translate(p, x, y)

		draw.NoTexture()
		surface.SetDrawColor(0,0,0, 50)
		surface.DrawPoly(p)

		octomap.metaMarker.Paint(self, x, y, scale)

	end

end)
