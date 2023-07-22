AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

duplicator.RegisterEntityClass('ent_dbg_camera', function(ply, data)
	local ent = duplicator.GenericDuplicatorFunction(ply, data)
	local rotData = ent.rotationData
	ent:SetRotationData(rotData.p, rotData.center, rotData.r, rotData.v, rotData.viewDist)

	if IsValid(ply) then
		undo.Create('ent_dbg_camera')
		undo.AddEntity(ent)
		undo.SetPlayer(ply)
		undo.Finish()
		ply:AddCount('ent_dbg_cameras', ent)
		ply:AddCleanup('ent_dbg_cameras', ent)
	end

	return ent
end, 'Data', 'rotationData', 'notifyData')

local angCos = math.cos(math.rad(ENT.FOV))

local function isSuspicious(ply)
	if ply:isWanted() then return true, 'обнаружила разыскиваемого человека' end
	if ply.hacking or ply.lockpickCache then return true, 'зафиксировала попытку взлома' end
	if ply:GetActiveWeapon() ~= nil and ply:GetActiveWeapon().isScaring then return true, 'зафиксировала угрозу оружием' end
	if IsValid(ply:GetNetVar('dragging')) then
		local wep = ply:GetNetVar('dragging'):GetActiveWeapon()
		if wep.CuffType ~= 'weapon_cuff_police' then
			return true, 'зафиксировала похищение человека'
		end
	end
end

local function desc(ply)
	if not ply:GetNetVar('dbgDesc') then return end
	return string.Trim(ply:GetNetVar('dbgDesc')) ~= '' and ply:GetNetVar('dbgDesc') or L.desc_usual
end

local function findWitness(ply, includeBusy)
	local ct = CurTime()
	for _,v in ipairs(ents.FindInSphere(ply:GetPos(), 2000)) do
		if v:GetClass() ~= 'ent_dbg_camera' or (not includeBusy and v.lastCall + 120 > ct) then continue end
		if v:CanSee(ply, true) and v:GetPos():DistToSqr(ply:GetShootPos()) <= v:GetViewDist() * v:GetViewDist() then
			return v
		end
	end
end

local function handleDeath(vict, att)
	local vCam = findWitness(vict, true)
	if not vCam then return end
	local sawAtt = findWitness(att, true) ~= nil
	vCam:CameraReport('зафиксировала убийство', sawAtt and desc(att))
	hook.Run('dbg-camera.trigger', vCam, vict, 'зафиксировала убийство', sawAtt, att)
end

hook.Add('EntityDamage', 'dbg-camera', function(vict, att, wep, dmgInfo)
	if vict:IsPlayer() and IsValid(att) and att:IsPlayer() then
		if vict:Health() <= dmgInfo:GetDamage() then
			return handleDeath(vict, att)
		end
		local vCam = findWitness(vict)
		if not vCam then return end
		local sawAtt = findWitness(att) ~= nil
		vCam:CameraReport('зафиксировала нападение', sawAtt and desc(att))
		hook.Run('dbg-camera.trigger', vCam, vict, 'зафиксировала нападение', sawAtt, att)
	end
end)

local function addCameraMarker(ply, marker, text)
	ply:EmitSound('ambient/chatter/cb_radio_chatter_' .. math.random(1,3) .. '.wav', 45, 100, 0.5)
	ply:Notify('warning', text)
	ply:AddMarker(marker)
end

function ENT:CameraReport(reason, desc)
	if self:GetNetVar('broken') then return end
	local notifyData = self.notifyData
	if not notifyData then return end
	local text = self.camName .. ' ' .. reason
	if desc then
		text = text .. '. Внешность: ' .. desc
	end

	notifyData = octolib.array.toKeys(notifyData)

	local marker = {
		id = 'camera' .. self.camID,
		txt = 'Камера #' .. self.camID,
		pos = self:GetPos(),
		col = Color(235,120,120),
		des = {'timedist', {120, 300}},
		icon = 'octoteam/icons-16/exclamation.png',
	}

	for _,v in ipairs(player.GetAll()) do
		if notifyData[v.currentOrg] then
			addCameraMarker(v, marker, text)
		end
		if notifyData['cp'] and v:isCP() then
			addCameraMarker(v, marker, text)
		end
	end

	self.lastCall = CurTime()
	self:SetNetVar('rotationStart', CurTime() + 120)
end

function ENT:CanSee(target, checkDeg)
	if checkDeg and octolib.math.loopedDist(self:GetRotation(), self:GetRotationTo(target), -180, 180) > 45 then
		return false
	end
	if target:IsInvisible() then return false end

	local seat = target:GetVehicle()
	local vehicle = IsValid(seat) and seat:GetParent() or nil

	local att = target:GetAttachment(target:LookupAttachment('eyes'))
	if not att then return false end
	local tr = util.TraceLine({
		start = self:ScreenPos(),
		endpos = att.Pos,
		filter = {self, target, seat, vehicle},
	})
	return not tr.Hit
end

function ENT:SparkEffect(pos)
	local effect = ents.Create('env_spark')
	effect:SetKeyValue('targetname', 'target')
	effect:SetPos(pos or self:ScreenPos())
	effect:SetAngles(Angle())
	effect:Spawn()
	effect:SetKeyValue('spawnflags','128')
	effect:SetKeyValue('Magnitude',1)
	effect:SetKeyValue('TrailLength',0.2)
	effect:Fire('SparkOnce')
	effect:Fire('kill','',0.5)
end

local dmgDescriptions = {
	[DMG_GENERIC] = {
		'Кажется, просто перебои с электричеством',
		'Коротнуло. Это все',
		'Видимо, дождем залило. Вот и коротнуло',
	},
	[DMG_CRUSH] = {
		'Кажется, ее ударили чем-то тяжелым',
		'Камера едва держится. Ее чем-то сбили',
	},
	[DMG_BULLET] = {
		'На корпусе видны следы от пуль',
		'В нее явно стреляли',
	},
	[DMG_SLASH] = {
		'Кто-то перерезал провода',
		'Провода отрезаны',
	},
	[DMG_BURN] = {
		'Камера пахнет жженым пластиком. Либо она сгорела, либо ее подожгли',
		'Камера перегорела, или ее подожгли',
		'Корпус весь обгорел',
	},
	[DMG_CLUB] = {
		'Кто-то вырвал все провода',
	},
	[DMG_SHOCK] = {
		'Камера едва держится. Ее чем-то сбили',
	},
	[DMG_SONIC] = {
		'Кто-то перерезал провода',
		'Провода отрезаны',
		'Кто-то баловался острым предметом и отрезал провода',
	}
}

function ENT:Break(type)
	self:CameraReport('была выведена из строя')
	hook.Run('dbg-camera.destroy', self)
	self:SetNetVar('broken', true)
	self:SetColor(Color(64,64,64))
	self:SparkEffect()
	self:ManipulateBoneAngles(2, Angle(0,-60,0))
	timer.Create('dbg-camera.repair' .. self:EntIndex(), 60 * 30, 1, function()
		if IsValid(self) then
			self:Repair()
		end
	end)
	if type then
		type = bit.band(type, 1023)
		local reasonsTable = dmgDescriptions[type] or dmgDescriptions[DMG_GENERIC]
		self:SetNetVar('dbgLook', {
			name = '',
			desc = reasonsTable[math.random(#reasonsTable)],
			time = 4,
		})
	end
end

function ENT:GetRotationTo(ply)
	local ang = (ply:GetShootPos() - self:GetPos()):Angle()
	return (ang - self:GetAngles()).y
end

function ENT:FaceTo(ply)
	self:SetNetVar('freezeRotate', self:GetRotationTo(ply))
end

function ENT:Repair()
	self:SetNetVar('broken')
	self:SetNetVar('dbgLook')
	self:SetColor(Color(255,255,255))
	timer.Remove('dbg-camera.repair' .. self:EntIndex())
	self:SetNetVar('rotationStart', CurTime())
	self:RemoveAllDecals()
	self.health = 50
	self:ManipulateBoneAngles(2, Angle(0, self.rotationData and self.rotationData.p or 0))
end

function ENT:OnTakeDamage(info)
	self:SparkEffect(info:GetDamagePosition())
	if self.health <= 0 then return end
	self.health = self.health - info:GetDamage()
	if self.health <= 0 then
		self:Break(info:GetDamageType())
	else
		hook.Run('dbg-camera.damage', self, info:GetAttacker())
	end
end

function ENT:Initialize()

	self:SetModel('models/tobadforyou/surveillance_camera.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.lastCall = -math.huge
	self.camID = #ents.FindByClass('ent_dbg_camera')
	self.camName = 'Камера #' .. self.camID
	self:Repair()
	if not self.rotationData then
		self:SetRotationData(-25, 0, 0, 0, self.ViewDist)
	end

end

function ENT:SetRotationData(pitch, center, radius, speed, dist)
	local data = {p = pitch, center = center, r = radius, v = speed, viewDist = dist}
	self:SetNetVar('rotationData', data)
	self.rotationData = data
end

function ENT:Scan()

	local ct = CurTime()
	if ct - self.lastCall <= 120 then
		if ct - self.lastCall <= 5 then
			self:EmitSound('buttons/button17.wav', 75, 110, 1)
		end
		return 1
	end

	local pos, ang = self:ScreenPos()
	for _,v in ipairs(ents.FindInCone(pos, ang:Forward(), self:GetViewDist(), angCos)) do
		if not v:IsPlayer() then continue end
		local isSusp, suspMsg = isSuspicious(v)
		if not isSusp then continue end
		if self:CanSee(v) then
			hook.Run('dbg-camera.trigger', self, v, suspMsg)
			self:CameraReport(suspMsg, desc(v))
			self:FaceTo(v)
			self:EmitSound('buttons/button17.wav', 75, 110, 1)
			return 1
		end
	end
	return 2

end

function ENT:Think()

	if self:GetNetVar('broken') then
		if math.random(2) == 1 then
			self:SparkEffect()
		end
		self:NextThink(CurTime() + 0.5)
		return true
	end
	self:NextThink(CurTime() + self:Scan())
	return true

end
