include 'shared.lua'

function ENT:Initialize()

	local size = self:GetNetVar('size') or Vector(1,1,1)
	local side = Vector(size.x / 2, size.y / 2, size.z / 2)
	self:SetRenderBounds(-side, side)

end

function ENT:Draw()

	-- self:DrawModel()

	-- local size = self:GetNetVar('size') or Vector(1,1,1)
	-- local side = Vector(size.x / 2, size.y / 2, size.z / 2)

	-- render.SetColorMaterial()
	-- render.CullMode(MATERIAL_CULLMODE_CW)
	-- render.DrawBox(self:GetPos(), self:GetAngles(), -side, side, Color(255,255,255, 50), true)
	-- render.CullMode(MATERIAL_CULLMODE_CCW)
	-- render.DrawBox(self:GetPos(), self:GetAngles(), -side, side, Color(255,255,255, 50), true)

	if not octolib.vars.get('tools.trigger.draw') then return end
	local wepclass = LocalPlayer():GetActiveWeaponClass()
	if wepclass ~= "gmod_tool" then return end
	local ang = Angle()

	cam.Start3D()
		local tpos = self:GetPos()
		local size = (self:GetNetVar('size') or Vector(1,1,1)) / 2
		render.DrawWireframeBox(tpos, ang, -size, size, color_white, false)
		if self:GetNetVar('sound3dpos') then
			local pos, ang = unpack(self:GetNetVar('sound3dpos'))
			if IsValid(self.soundMdl) then
				self.soundMdl:SetPos(pos)
				self.soundMdl:SetAngles(ang + Angle(90,0,0))
				self.soundMdl:DrawModel()
			else self:CreateSoundModel() end
			render.DrawLine(pos, tpos, color_white)
		end
		cam.Start2D()
			local spos = tpos:ToScreen()
			local x, y = math.ceil(spos.x), math.ceil(spos.y)
			surface.SetDrawColor(255, 255, 255, 55)
			surface.DrawRect(x - 15, y - 10, 25, 25)
			local title, text = self:GetNetVar('title') or L.loading, self:GetNetVar('text') or L.loading
			if utf8.len(text) > 64 then text = utf8.sub(text, 1, 64) .. '...' end
			draw.SimpleText(title, 'DermaDefault', x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(text, 'DermaDefault', x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		cam.End2D()
	cam.End3D()

end

function ENT:CreateSoundModel()
	if self.creatingModel or IsValid(self.soundMdl) then return end
	self.creatingModel = true
	timer.Simple(0, function()
		self.soundMdl = octolib.createDummy('models/cheeze/wires/speaker.mdl')
		self.soundMdl:SetNoDraw(true)
		self.creatingModel = true
	end)
end

local activeSounds = {}

local function tryCreateSound(id, path, vol, stopsound)
	local st = CreateSound(LocalPlayer(), path)
	if not st then
		return octolib.notify.show('warning', L.noplay, 'Звук не найден')
	end
	st:ChangeVolume(vol)
	st:SetSoundLevel(75)
	st:Play()
	if IsValid(activeSounds[id]) then
		activeSounds[id]:Stop()
	end
	if activeSounds[id] and activeSounds[id].IsPlaying and activeSounds[id]:IsPlaying() then
		activeSounds[id]:Stop()
	end
	activeSounds[id] = st
	for _,v in ipairs(stopsound or {}) do
		if IsValid(activeSounds[v]) then
			activeSounds[v]:Stop()
		end
		if activeSounds[v] and activeSounds[v].IsPlaying and activeSounds[v]:IsPlaying() then
			activeSounds[v]:Stop()
		end
		activeSounds[v] = nil
	end
end

netstream.Hook('trigger_sound', function(id, url, path, vol, pos, stopsound)

	if not path or path == '' or vol == 0 then return end
	local method = sound['Play' .. (url and 'URL' or 'File')]
	if not url then path = 'sound/' .. path end
	local playFunc = function(st, code, err)
		if not IsValid(st) then
			if code == 2 and not url then
				return tryCreateSound(id, path:sub(7), vol, stopsound)
			end
			return octolib.notify.show('warning', L.noplay, err)
		end
		if st:GetLength() == 0 then
			return octolib.notify.show('warning', 'Потоковые аудио не поддерживаются')
		end
		st:SetVolume(vol or 1)
		if pos then
			st:SetPos(unpack(pos))
		end
		if IsValid(activeSounds[id]) then activeSounds[id]:Stop() end
		if activeSounds[id] and activeSounds[id].IsPlaying and activeSounds[id]:IsPlaying() then
			activeSounds[id]:Stop()
		end
		st:Play()
		activeSounds[id] = st
		for _,v in ipairs(stopsound or {}) do
			if IsValid(activeSounds[v]) then
				activeSounds[v]:Stop()
			end
			if activeSounds[v] and activeSounds[v].IsPlaying and activeSounds[v]:IsPlaying() then
				activeSounds[v]:Stop()
			end
			activeSounds[v] = nil
		end
	end
	method(path, 'noplay' .. (pos and ' 3d' or ''), playFunc)

end)

netstream.Hook('trigger_stop', function(id)
	if IsValid(activeSounds[id]) then activeSounds[id]:Stop() end
	activeSounds[id] = nil
end)
