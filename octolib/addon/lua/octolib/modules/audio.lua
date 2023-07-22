local running = {}

octolib.audio = octolib.audio or {}

function octolib.audio.play(data)
	if SERVER then
		local receivers
		if data.pos and data.dist then
			local pos = data.pos
			if IsValid(data.ent) then
				pos = data.ent:LocalToWorld(data.pos)
			end
			receivers = octolib.array.filter(ents.FindInSphere(pos, data.dist), function(ent) return ent:IsPlayer() end)
		end
		netstream.Start(receivers, 'octolib.sound', data)
		return
	end

	if data.url then
		local tags = data.tags or {'noplay'}
		if data.pos then tags[#tags + 1] = '3d' end

		sound.PlayURL(data.url, table.concat(tags, ' '), function(chan)
			if IsValid(chan) then
				chan:SetVolume(data.volume or 1)
				if data.pos then
					local pos = data.pos
					if IsValid(data.ent) then
						pos = data.ent:LocalToWorld(data.pos)
					end
					chan:SetPos(pos)
				end
				if data.dist then chan:Set3DFadeDistance(data.distInner or 0, data.dist) end
				chan:Play()
				running[chan] = data
			else
				octolib.notify.show('warning', 'Не удалось загрузить звук. Возможно, ссылка неправильная')
			end
		end)
	elseif data.file then
		local pos = data.pos
		if IsValid(data.ent) then
			pos = data.ent:LocalToWorld(data.pos)
		end
		sound.Play(data.file, pos or LocalPlayer():EyePos(), data.level or 70, data.pitch or 100, data.volume or 1)
	end
end

if CLIENT then
	netstream.Hook('octolib.sound', octolib.audio.play)

	hook.Add('Think', 'octolib.sound', function()
		for chan, data in pairs(running) do
			if IsValid(chan) then
				local pos = data.pos
				if pos and IsValid(data.ent) then
					pos = data.ent:LocalToWorld(data.pos)
					chan:SetPos(pos)
				end

				if data.dist and pos:Distance(LocalPlayer():EyePos()) > data.dist then
					chan:Stop()
					running[chan] = nil
				end
			else
				running[chan] = nil
			end
		end
	end)

	octolib.audio.streams = octolib.audio.streams or {}

	local function restartStream(stream)
		stream.stopped = nil

		sound.PlayFile('sound/stream_radio/noise.wav', '3d noplay', function(st)
			if IsValid(stream.noise) then stream.noise:Stop() end
			if stream.stopped then return end
			stream.noise = st
			stream:Play(true)
		end)
		sound.PlayURL(stream.url, '3d noplay', function(st)
			if IsValid(stream.st) then stream.st:Stop() end
			if stream.stopped then return end
			stream.st = st
			stream:Play(true)
			if IsValid(stream.noise) then stream.noise:Stop() end
		end)
	end

	hook.Add('Think', 'octolib.streams', function()
		local pos = LocalPlayer():GetShootPos()

		for _,v in pairs(octolib.audio.streams) do
			if not v.url then continue end

			if v.parent then
				if not IsValid(v.parent) then
					if not v.stopped then v:Stop() end
					continue
				else v:SetPos(v.parent:GetPos()) end
			end

			if not v.pos then continue end

			local dst = v.pos:DistToSqr(pos)
			if not v.stopped and dst > v.distSqr then
				v:Stop(true)
			elseif v.stopped and not v.customStop and dst <= v.distSqr then
				restartStream(v)
			end

		end
	end)

	octolib.audio.metaStream = octolib.audio.metaStream or {}

	local AudioStream = octolib.audio.metaStream
	AudioStream.__index = AudioStream

	local defaults = {
		volume = 0.2,
		distance = 600,
		distSqr = 360000,
		pos = Vector(0,0,0),
	}

	function octolib.audio.stream()
		local stream = table.Copy(defaults)
		setmetatable(stream, AudioStream)
		stream.uid = octolib.string.uuid()
		octolib.audio.streams[stream.uid] = stream

		return stream
	end

	local function setup(stream, st)
		if not IsValid(st) then return end
		st:SetVolume(stream.volume)
		st:Set3DFadeDistance(stream.distance / 3, stream.distance)
		st:Set3DEnabled(stream.pos ~= nil)
		if stream.pos ~= nil then
			st:SetPos(stream.pos)
		end
	end

	function AudioStream:SetParent(ent)
		self.parent = ent
	end

	function AudioStream:ForEachChannel(act)
		if IsValid(self.noise) then act(self.noise) end
		if IsValid(self.st) then act(self.st) end
	end

	function AudioStream:Play(upd)
		if not self:IsValid() then return end
		self:ForEachChannel(function(chan)
			if upd then setup(self, chan) end
			chan:Play()
		end)
	end

	function AudioStream:SetDistance(dist)
		if not isnumber(dist) then return end
		self.distance = dist
		self.distSqr = dist * dist
		self:ForEachChannel(function(chan)
			chan:Set3DFadeDistance(dist / 3, dist)
		end)
	end

	function AudioStream:SetURL(url)
		if not isstring(url) then
			return self:Stop()
		end
		self.url = url
		restartStream(self)
	end

	function AudioStream:SetVolume(vol)
		if not isnumber(vol) then return end
		self.volume = vol
		self:ForEachChannel(function(chan)
			chan:SetVolume(vol)
		end)
	end

	function AudioStream:SetPos(pos)
		if pos ~= nil and not isvector(pos) then return end
		self.pos = pos
		self:ForEachChannel(function(chan)
			chan:Set3DEnabled(pos ~= nil)
			if pos ~= nil then
				chan:SetPos(pos)
			end
		end)
	end

	function AudioStream:Stop(notCustom)
		self:ForEachChannel(function(chan)
			chan:Stop()
		end)
		self.stopped = true
		self.customStop = not notCustom
	end

	function AudioStream:Remove()
		octolib.audio.streams[self.uid] = nil
		self:Stop()
	end

	function AudioStream:IsValid()
		return octolib.audio.streams[self.uid] ~= nil
	end
end
