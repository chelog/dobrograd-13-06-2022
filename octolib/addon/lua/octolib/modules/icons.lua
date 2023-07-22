--[[
	Namespace: octolib

	Group: icons
]]
octolib.icons = octolib.icons or {}

local function iconGeneratorFunc(suffix)
	return function(name, mat)
		local str = ('octoteam/icons%s/%s.png'):format(suffix or '', name)
		return mat and Material(str, mat) or str
	end
end

octolib.icons.color = iconGeneratorFunc()
octolib.icons.silk16 = iconGeneratorFunc('-16')
octolib.icons.silk32 = iconGeneratorFunc('-32')

local maxSize = 64

--[[
	Function: iconPicker
		Creates simple icon picker window executing callback
		function when user selects an icon

	Arguments:
		<function> callback - Function to call after user clicks the icon
		<string> cur = '' - Currently active icon path, highlights icon in the list
		<string> path = 'materials/octoteam/icons' - folder to search icons in

	Returns:
		<Panel> - Created DFrame
]]
function octolib.icons.picker(callback, cur, path)

	local w = vgui.Create 'DFrame'
	w:SetSize(600, 600)
	w:SetTitle(L.chooseicon)
	w:Center()
	w:MakePopup()

	local sp = w:Add 'DScrollPanel'
	sp:Dock(FILL)

	local l = sp:Add 'DIconLayout'
	l:Dock(FILL)
	l:SetSpaceX(5)
	l:SetSpaceY(5)

	local function paint(self, w, h)
		if self.active then draw.RoundedBox(4, 0, 0, w, h, Color(0,0,0, 80)) end
		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(self.mat)
		surface.DrawTexturedRect(0, 0, w, h)
	end

	local function click(self)
		callback(self.icon:sub(11))
		w:Remove()
	end

	path = path or 'materials/octoteam/icons/'
	local fls = file.Find(path .. '*.png', 'GAME')
	for i, v in ipairs(fls) do
		local i = l:Add 'DButton'
		i.icon = path .. v
		i.mat = Material(i.icon)
		i.active = cur == i.icon
		i:SetSize(math.min(i.mat:Width(), maxSize), math.min(i.mat:Height(), maxSize))
		i:SetText('')
		i.Paint = paint
		i.DoClick = click
	end

	return w

end

if CLIENT then
	local toReload = {}
	local fileFind = file.Find
	local function scanDir(dir)
		dir = dir .. '/'
		local fls, fds = fileFind(dir .. '/*', 'GAME')
		if fls then
			for _, fl in pairs(fls) do
				if fl and fl ~= '' and fl:sub(-4) == '.png' then
					toReload[#toReload + 1] = dir .. fl:gsub('%.png', '')
				end
			end
		end
		if fds then
			for _, fd in pairs(fds) do
				if fd ~= '/' then
					scanDir(dir .. fd)
				end
			end
		end
	end

	hook.Add('Think', 'octolib.icons', function()
		hook.Remove('Think', 'octolib.icons')

		timer.Simple(30, function()
			scanDir('materials/octoteam')
			octolib.func.throttle(toReload, 5, 0.05, function(mat)
				RunConsoleCommand('mat_reloadmaterial', mat)
			end)
		end)
	end)
end
