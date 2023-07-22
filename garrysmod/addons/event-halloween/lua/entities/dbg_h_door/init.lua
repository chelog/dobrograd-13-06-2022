AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

local sweets = {10, 20}

local plyPhrases = {
	'Сладость или гадость!',
	'Кошелек или жизнь!',
	--'Это ограбление, живо весь шоколад на пол! И смотри мне, чтобы без орешков - от них мне хочется слушать Грин Дей',
}

local template = 'sound/dobrohalloween/day%s.wav'
local entPhrases = {
--	{'path to sound file', length in seconds}
	{'1/1', 11},
	{'1/2', 8},
	{'1/3', 9},
	{'1/4', 10},
	{'1/5', 12},
	{'1/6', 8},
	{'1/7', 6},
	{'1/8', 10},
	{'1/9', 9},
	{'1/10', 10},
	{'1/11', 13},
	{'2/1', 8},
	{'2/2', 8},
	{'2/3', 7},
	{'2/5', 9},
	{'2/6', 11},
	{'2/7', 12},
	{'2/8', 8},
	{'2/9', 13},
	{'2/10', 9},
	{'2/12', 15},
	{'2/13', 10},
	{'2/14', 15},
	{'2/15', 9},
	{'2/custom1', 10},
	{'2/custom2', 14},
	{'2/custom3', 13},
	{'2/custom4', 17},
	{'2/custom5', 20},
}
octolib.array.shuffle(entPhrases)

local function doKnock(ply)

	ply:EmitSound('physics/wood/wood_crate_impact_hard' .. math.random(2, 3) .. '.wav', 40, math.random(90, 110))
	ply:DoAnimation(ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST)

end

local lastTaken = 0

function ENT:Initialize()

	return self:Remove()
	-- self:SetModel('models/props_c17/door01_left.mdl')
	-- self:SetBodygroup(1, 1)
	-- self:PhysicsInit(SOLID_VPHYSICS)
	-- self:SetMoveType(MOVETYPE_VPHYSICS)
	-- self:SetSolid(SOLID_VPHYSICS)
	-- self:SetUseType(SIMPLE_USE)

	-- lastTaken = lastTaken % #entPhrases + 1
	-- self.phrase = {template:format(entPhrases[lastTaken][1]), entPhrases[lastTaken][2]}
	-- self.sweetsTaken, self.sweetsWaiting = {}, {}
end

function ENT:GiveSweets(ply, sid)
	self.sweetsWaiting[sid] = nil
	if not IsValid(ply) then return end
	if ply:GetShootPos():DistToSqr(self:NearestPoint(ply:GetShootPos())) <= CFG.useDistSqr then
		local amount = math.random(unpack(sweets))
		ply:AddSweets(amount)
		self.sweetsTaken[sid] = true
		hook.Run('dbg-halloween.gotSweets', ply, amount, self)
	end
	ply.wantsSweets = nil
end

function ENT:Act(ply, sid)

	if not IsValid(ply) then return end
	netstream.Start(ply, 'dbg-halloween.playPhrase', self, self.phrase[1])
	timer.Simple(self.phrase[2] * 0.75, function()
		if IsValid(self) then self:GiveSweets(ply, sid) elseif IsValid(ply) then ply.wantsSweets = nil end
	end)

end

function ENT:Use(ply)

	if not ply:IsPlayer() then return end
	local sid = ply:SteamID()
	if self.sweetsWaiting[sid] or self.sweetsTaken[sid] then return end
	if ply.wantsSweets then return end
	if not ply.halloweenTheme then
		return ply:Notify('warning', 'А как же хэллоуинское настроение? Активируй его во вкладке "Хэллоуин" в F4-меню!')
	end

	self.sweetsWaiting[sid] = true
	ply.wantsSweets = true
	doKnock(ply)
	timer.Simple(0.3, function() doKnock(ply) end)
	timer.Simple(0.6, function() doKnock(ply) end)
	ply:Say(plyPhrases[math.random(#plyPhrases)])

	timer.Simple(2, function()
		if IsValid(self) then self:Act(ply, sid) elseif IsValid(ply) then ply.wantsSweets = nil end
	end)

end
