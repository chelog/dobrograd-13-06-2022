AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'
include 'shared.lua'

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS

end

function ENT:Initialize()

	self:SetModel('models/props_junk/popcan01a.mdl')
	self:DrawShadow(false)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:UpdateSize()
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

	self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
	self:SetTrigger(true)

	self:UpdateNetworkVars()
	self.done = self.mode == 0 and {} or 0
	self.uid = octolib.string.uuid()

end

function ENT:UpdateSize()

	local size = self.size or Vector(1,1,1)
	local side = Vector(size.x / 2, size.y / 2, size.z / 2)
	self:SetCollisionBounds(-side, side)

end

function ENT:UpdateNetworkVars()

	self:SetNetVar('title', self.title)
	self:SetNetVar('text', self.text)
	self:SetNetVar('size', self.size)

end

function ENT:StartTouch(ent)

	if ent:IsPlayer() then
		if self.times > 0 then
			local done = self.done
			if self.mode == 0 then
				done = self.done[ent] or 0
			end
			if done >= self.times then return end
			done = done + 1
			if self.mode == 0 then
				self.done[ent] = done
			else
				self.done = done
			end
		end
		self:DoTrigger(ent)
	end
end

local function numpadToggle(ent)
	if not ent.bPressed then
		numpad.Activate( ent:GetPlayerSteamID(), ent.bind, true )
		ent.bPressed = true
	else
		numpad.Deactivate( ent:GetPlayerSteamID(), ent.bind, true )
		ent.bPressed = false
	end
end

function ENT:DoTrigger(ent)

	if self.sound3d and not self:GetNetVar('sound3dpos') then return end

	local time = (self.duration or 0)
	local title = string.Trim(self:GetNetVar('title') or '')
	local text = string.Trim(self:GetNetVar('text') or '')

	if self.bind then
		numpadToggle(self)
	end

	if time > 0 and title ~= '' or text ~= '' then
		if self.method == 'chat' then
			if title == '' then
				title = text
				text = ''
			end
			octochat.talkTo(ent, octochat.textColors.rp, title, ' ', color_white, text)
		elseif self.method == 'notify' then
			ent:Notify(text)
		elseif self.method == 'center' then
			if title ~= '' or text ~= '' then
				ent:Notify('admin', time, title, text)
			end
		end
	end

	local url = self.urlsound and string.Trim(self.urlsound) ~= ''
	if url or (self.gamesound and string.Trim(self.gamesound) ~= '') then
		netstream.Start(ent, 'trigger_sound', self.uid, url, string.Trim(url and self.urlsound or self.gamesound), self.volume or 1, self:GetNetVar('sound3dpos'), self.stopsounds)
	end

end

function ENT:OnRemove()
	netstream.Start(nil, 'trigger_stop', self.uid)
end

local tosave = {'size', 'duration', 'times', 'text', 'volume', 'title', 'method', 'gamesound', 'urlsound', 'mode'}
duplicator.RegisterEntityClass('octo_trigger', function(ply, data)

	if IsValid(ply) then
		if not ply:CheckLimit('octo_triggers') then
			return false
		end

		if not ply:query(L.permissions_trigger_url) then data.urlsound = nil end
	end

	local ent = duplicator.GenericDuplicatorFunction(ply, data)

	ent:UpdateSize()
	ent:UpdateNetworkVars()

	if IsValid(ply) then
		ply:AddCount('octo_triggers', ent)
		ply:AddCleanup('octo_triggers', ent)
	end

	return ent

end, 'Data', unpack(tosave))
