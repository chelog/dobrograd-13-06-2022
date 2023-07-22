TOOL.Category = 'Dobrograd'
TOOL.Name = 'Image Screen'
TOOL.Command = nil

TOOL.Information = {
	{ name = 'left' },
}

cleanup.Register('imgscreens')

if CLIENT then
	octolib.vars.init('tools.imgscreen.url', 'https://i.imgur.com/lQb95Kc.jpg')
	octolib.vars.init('tools.imgscreen.w', 350)
	octolib.vars.init('tools.imgscreen.h', 350)
	octolib.vars.init('tools.imgscreen.fade', 300)
	octolib.vars.init('tools.imgscreen.color', Color(255,255,255, 255))
else
	CreateConVar('sbox_maximgscreens', 10)
end

local allowedExt = octolib.array.toKeys {'.jpg', '.png'}
function TOOL:LeftClick(tr)

	if CLIENT then return true end

	local ply = self:GetOwner()
	local extended = ply:query('DBG: Расширенный Image Screen')
	ply:GetClientVar({
		'tools.imgscreen.url',
		'tools.imgscreen.w',
		'tools.imgscreen.h',
		'tools.imgscreen.fade',
		'tools.imgscreen.color',
	}, function(vars)
		local url, w, h, col, fade =
			tostring(vars['tools.imgscreen.url']) or 'https://i.imgur.com/lQb95Kc.jpg',
			math.Clamp(tonumber(vars['tools.imgscreen.w']) or 16, 16, extended and 16384 or 2048),
			math.Clamp(tonumber(vars['tools.imgscreen.h']) or 16, 16, extended and 16384 or 2048),
			vars['tools.imgscreen.color'] or Color(255,255,255, 255),
			extended and math.Clamp(tonumber(vars['tools.imgscreen.fade']) or 300, 10, 2000) or nil

		if url:sub(1, 20) ~= 'https://i.imgur.com/' then
			ply:Notify('warning', 'Можно использовать только ссылки с Imgur')
			return
		end

		if not allowedExt[url:sub(-4)] then
			ply:Notify('warning', 'Неправильный формат ссылки')
			return
		end

		local ent = tr.Entity
		if not IsValid(ent) or ent:GetClass() ~= 'imgscreen' then
			if not ply:CheckLimit('imgscreens') then return false end

			local pos, ang = LocalToWorld(Vector(0.1,0,0), Angle(90,0,0), tr.HitPos, tr.HitNormal:Angle())
			ent = ents.Create('imgscreen')
			ent:SetPos(pos)
			ent:SetAngles(ang)
			ent:Spawn()
			ent:Activate()

			ply:AddCount('imgscreens', ent)
			ply:AddCleanup('imgscreens', ent)

			undo.Create('imgscreen')
				undo.AddEntity(ent)
				undo.SetPlayer(ply)

				if IsValid(tr.Entity) then
					ent:PhysicsInit(SOLID_VPHYSICS)
					ent:SetSolid(SOLID_VPHYSICS)
					ent:SetMoveType(MOVETYPE_VPHYSICS)
					local ph = ent:GetPhysicsObject()
					ph:SetMass(1)
					ph:EnableCollisions(false)
					ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
					ent.nocollide = true

					local weld = constraint.Weld(ent, tr.Entity, 0, tr.PhysicsBone, 0, true, true)
					undo.AddEntity(weld)
				else
					ent:GetPhysicsObject():EnableMotion(false)
				end
			undo.Finish()
		end

		ent.imgURL = url
		ent.imgW = w
		ent.imgH = h
		ent.imgFade = fade and fade*fade or nil
		ent.imgColor = col
		ent:UpdateImage()

	end)

	return true
end

function TOOL:RightClick(tr)

	return false

end

function TOOL:BuildCPanel()

	local extended = LocalPlayer():query('DBG: Расширенный Image Screen')
	self:AddControl('Header', {
		Text = 'Image Screens',
		Description = 'Используй этот тул для размещения картинок в игровом мире. Например, его можно использовать для вывесок или граффити' .. (extended and '. Ты используешь расширенную версию инструмента' or ''),
	})

	octolib.vars.presetManager(self, 'tools.imgscreen', {'tools.imgscreen.url', 'tools.imgscreen.w', 'tools.imgscreen.h', 'tools.imgscreen.color'})

	octolib.vars.textEntry(self, 'tools.imgscreen.url', '')
	self:ControlHelp('Принимаются только ссылки с Imgur формата https://i.imgur.com/многобукв.png\nПоддерживаются форматы .png и .jpg')

	octolib.vars.slider(self, 'tools.imgscreen.w', L.width, 16, extended and 16384 or 2048, 0)
	octolib.vars.slider(self, 'tools.imgscreen.h', L.height, 16, extended and 16384 or 2048, 0)
	if extended then
		octolib.vars.slider(self, 'tools.imgscreen.fade', 'Расстояние затухания', 10, 2000, 0)
	end
	octolib.vars.colorPicker(self, 'tools.imgscreen.color', L.color)

	-- fuck DForm
	for _, pnl in ipairs(self:GetChildren()) do
		pnl:DockPadding(10, 0, 10, 0)
	end

end

if CLIENT then
	language.Add('Tool.imgscreen.name', 'Image Screens')
	language.Add('Tool.imgscreen.desc', 'Картинки по ссылке в игровом мире')
	language.Add('Tool.imgscreen.left', 'Поставить картинку')
	language.Add('Undone_imgscreen', 'Картинка удалена')
	language.Add('Cleanup_imgscreens', 'Картинки очищены')
	language.Add('Cleaned_imgscreens', 'Картинки очищены')
	language.Add('SBoxLimit_imgscreens', 'Достигнут лимит картинок')
end
