local meta = FindMetaTable 'Player'

local function hasTalkie(ply)
	ply.hasTalkie = ply:HasItem('radio')
end
function meta:HasTalkie()
	if RPExtraTeams[self:Team()].hasTalkie then return true end
	if not self._updateHavingTalkie then
		self._updateHavingTalkie = octolib.func.debounceStart(hasTalkie, 0.5)
	end
	self:_updateHavingTalkie()
	return self.hasTalkie
end


local radioAnim = {
	sitting = {
		Bip01_L_Hand = { ang = Angle(-10, -45, -105) },
		Bip01_L_Forearm = { ang = Angle(0, -22, -60) },
		Bip01_L_Clavicle = { ang = Angle(0, 0, 0) },
		Bip01_L_UpperArm = { ang = Angle(-10, -30, 0) },

		Bip01_L_Finger0 = { ang = Angle(-15, -10, 0) },
		Bip01_L_Finger02 = { ang = Angle(0, -20, 0) },
		Bip01_L_Finger1 = { ang = Angle(20, -18, -30) },
		Bip01_L_Finger12 = { ang = Angle(0, -10, 0) },
		Bip01_L_Finger2 = { ang = Angle(15, -12, -10) },
		Bip01_L_Finger22 = { ang = Angle(0, -10, 0) },

		Bip01_Head1 = { ang = Angle(0,-10,0) },

		Bip01_R_Forearm = { ang = Angle(0, 0, 0) },
		Bip01_R_Hand = { ang = Angle(0, 0, 0) },
		fov = 0.3,
	},

	crouching = {
		Bip01_L_Hand = { ang = Angle(6, -30, -20) },
		Bip01_L_Forearm = { ang = Angle(0, 0, -40) },
		Bip01_L_Clavicle = { ang = Angle(5, 20, 0) },
		Bip01_L_UpperArm = { ang = Angle(30, -65, -5) },

		Bip01_L_Finger0 = { ang = Angle(-30, 0, 0) },
		Bip01_L_Finger02 = { ang = Angle(0, -15, 0) },
		Bip01_L_Finger1 = { ang = Angle(17, 23, 0) },
		Bip01_L_Finger12 = { ang = Angle(-10, 25, 0) },
		Bip01_L_Finger2 = { ang = Angle(15, 20, -10) },
		Bip01_L_Finger22 = { ang = Angle(0, 80, 30) },

		Bip01_Head1 = { ang = Angle(0,-10,0) },

		Bip01_R_Forearm = { ang = Angle(0, 0, 0) },
		Bip01_R_Hand = { ang = Angle(0, 0, 0) },
		fov = 0.2,
	},

	passive = {
		Bip01_L_Hand = { ang = Angle(0, 0, 80) },
		Bip01_L_Forearm = { ang = Angle(-5, -86, -8) },
		Bip01_L_Clavicle = { ang = Angle(0, 0, 0) },
		Bip01_L_UpperArm = { ang = Angle(0, 0, 0) },

		Bip01_L_Finger0 = { ang = Angle(0, 0, 0) },
		Bip01_L_Finger02 = { ang = Angle(0, 0, 0) },
		Bip01_L_Finger1 = { ang = Angle(8, 55, 0) },
		Bip01_L_Finger12 = { ang = Angle(-8, 1, 0) },
		Bip01_L_Finger2 = { ang = Angle(0, 49, 0) },
		Bip01_L_Finger21 = { ang = Angle(0, -15, 0) },
		Bip01_L_Finger22 = { ang = Angle(0, -5, -15) },

		Bip01_Head1 = { ang = Angle(0,-10,0) },

		Bip01_R_Forearm = { ang = Angle(-5, 76, 28) },
		Bip01_R_Hand = { ang = Angle(35, 0, 0) },
		fov = 0.2,
	},

	crouching_pas = {
		Bip01_L_Hand = { ang = Angle(0, 0, 80) },
		Bip01_L_Forearm = { ang = Angle(-5, -65, -8) },
		Bip01_L_Clavicle = { ang = Angle(0, 0, 0) },
		Bip01_L_UpperArm = { ang = Angle(0, 0, 0) },

		Bip01_L_Finger0 = { ang = Angle(0, 0, 0) },
		Bip01_L_Finger02 = { ang = Angle(0, 0, 0) },
		Bip01_L_Finger1 = { ang = Angle(8, 65, 0) },
		Bip01_L_Finger12 = { ang = Angle(-8, 1, 0) },
		Bip01_L_Finger2 = { ang = Angle(0, 49, 0) },
		Bip01_L_Finger21 = { ang = Angle(0, -15, 0) },
		Bip01_L_Finger22 = { ang = Angle(0, -5, -25) },

		Bip01_Head1 = { ang = Angle(0,-10,0) },

		Bip01_R_Forearm = { ang = Angle(0, 0, 0) },
		Bip01_R_Hand = { ang = Angle(0, 0, 0) },
		fov = 0.2,
	},
}

local radioPos = {
	pos = Vector(1.3, 0.7, 1),
	ang = Angle(-140, -15, 100)
}

local radio_sounds = {

	on = {
		'npc/combine_soldier/vo/on1.wav',
		'npc/combine_soldier/vo/on2.wav'
	},

	off = {
		'npc/combine_soldier/vo/off1.wav',
		'npc/combine_soldier/vo/off2.wav'
	}

}

local on = radio_sounds.on
local off = radio_sounds.off

hook.Add('UpdateAnimation', 'dbg-talkie.UpdateAnimation', function(ply, vel)

	if not IsValid(ply) then return end
	if ply:InVehicle() then return end
	if ply:GetModel() == 'models/error.mdl' then return end
	ply.TalkieAnimWeight = math.Approach(
		ply.TalkieAnimWeight or 0,
		(ply:IsUsingTalkie() and ply:OnGround()) and (1 - vel:LengthSqr() / 50000) or 0,
		FrameTime() * 5
	)

	local weight = ply.TalkieAnimWeight or 0

	if weight > 0 then
		local anim = talkie.getProperAnim(ply)
		for bone, data in pairs(anim) do
		  if bone ~= 'fov' then

		  	local weapon = ply:GetActiveWeapon()

		  	if IsValid(weapon) and weapon:GetClass():find('octo', 1, false) and (bone == 'Bip01_R_Forearm' or bone == 'Bip01_R_Hand') then continue end

			local id = ply:LookupBone('ValveBiped.' .. bone)
			if not id then continue end
			if data.pos then ply:ManipulateBonePosition(id, data.pos * weight) end
			if data.ang then ply:ManipulateBoneAngles(id, data.ang * weight) end
		  end
		end

		local state = (IsValid(ply:GetVehicle()) and 'sitting') or 'passive'

		if not IsValid(ply.Talkie) then
		  talkie.createDummy(ply)
		elseif ply.lastState ~= state then
		  talkie.removeDummy(ply)
		  ply.lastState = state
		  return
		end

	else
		if IsValid(ply.Talkie) then talkie.removeDummy(ply) end
	end

end)

function talkie.getProperAnim(ply)
	local veh = ply:GetVehicle()
	local weapon = ply:GetActiveWeapon()

	if IsValid(veh) then
		return radioAnim.sitting
	elseif IsValid(weapon) and ply:GetActiveWeapon():GetHoldType() == 'passive' then
		return ply:Crouching() and radioAnim.crouching_pas or radioAnim.passive
	elseif ply:Crouching() then
		return radioAnim.crouching
	else
		return radioAnim.passive
	end

end

function talkie.createDummy(ply)

	if IsValid(ply) and not IsValid(ply.Talkie) then
		local attID = ply:LookupAttachment('anim_attachment_LH')

		local radio_m = octolib.createDummy('models/handfield_radio.mdl')
		radio_m:SetParent(ply, attID)
		radio_m:SetLocalPos(radioPos.pos)
		radio_m:SetLocalAngles(radioPos.ang)
		radio_m:SetSkin(1)

		ply.Talkie = radio_m
	end

end

function talkie.removeDummy(ply)

	if IsValid(ply) and IsValid(ply.Talkie) then
		ply.Talkie:Remove()
		ply.Talkie = nil
		for bone,data in pairs(talkie.getProperAnim(ply)) do
			if bone ~= 'fov' then
				local id = ply:LookupBone('ValveBiped.' .. bone)
				if not id then continue end
				if data.pos then ply:ManipulateBonePosition(id, Vector()) end
				if data.ang then ply:ManipulateBoneAngles(id, Angle()) end
			end
		end
	end
end


octolib.func.loop(function(done)
	octolib.func.throttle(player.GetAll(), 10, 0.1, function(ply)

		if IsValid(ply) and IsValid(ply.Talkie) and (not ply:Alive() or ply:GetNoDraw() or not ply:IsUsingTalkie()) then
			talkie.removeDummy(ply)
		end

	end):Then(done)
end)

local usingTalkie = false
local function stopSpeaking(ply, disable_sounds)

	if usingTalkie then

		RunConsoleCommand('-talkie')
		usingTalkie = false
		permissions.EnableVoiceChat(false)

		if not disable_sounds then
			surface.PlaySound(off[math.random(1, #off)])
		end
	end
end

--local bind_key_convar = CreateClientConVar('radio_bind_key', 32, true, false, 'Биндит вашу кнопку на рацию')

hook.Add('PlayerButtonDown', 'dbg-talkie.bind', function(ply, key)

	local bind = GetConVar('radio_bind_key'):GetInt() or KEY_R

	if bind == key then
		if not ply:HasTalkie() or (ply:IsTalkieDisabled() or (ply:GetMoveType() ~= MOVETYPE_WALK and not IsValid(ply:GetVehicle()))) then return end

		if not usingTalkie then
			permissions.EnableVoiceChat(true)
			RunConsoleCommand('+talkie')
			usingTalkie = true
		end
	end
end)

hook.Add('PlayerButtonUp', 'dbg-talkie.bind', function(ply, key)

	local bind = GetConVar('radio_bind_key'):GetInt() or KEY_R
	if bind == key and usingTalkie then
		stopSpeaking(ply, true)
	end
end)

hook.Add('PlayerBindPress', 'dbg-talkie.bindOverride', function(ply, bind)
	if bind:find('voicerecord', nil, true) and usingTalkie then return true end
end)

hook.Add('KeyPress', 'dbg-talkie.noJump', function(ply, key)
	if (key == IN_JUMP) and IsFirstTimePredicted() and usingTalkie then
		stopSpeaking(ply)
	end
end)

local cmds = {'/r ', '/wr ', '/yr ', '/lr ', '/radio ', '/yradio ', '/wradio ', '/lradio '}
hook.Add('ChatTextChanged', 'dbg-talkie', function(txt)

	local ply = LocalPlayer()
	if not IsValid(ply) then return end

	local showRadio
	for _, cmd in ipairs(cmds) do
		if txt:StartWith(cmd) then
			showRadio = true
			break
		else
			showRadio = false
		end
	end

	if showRadio then
		if not usingTalkie and ply:HasTalkie() and not ply:IsTalkieDisabled() then
			netstream.Start('dbg-talkie.updateSpeakStatus', true)

			surface.PlaySound(on[math.random(1, #on)])
			usingTalkie = true
		end
	elseif usingTalkie then
		netstream.Start('dbg-talkie.updateSpeakStatus', false)

		stopSpeaking(ply, true)
	end
end)

netstream.Hook('dbg-talkie.remove', function(data)
	if data and data:IsPlayer() and IsValid(data.Talkie) then
		talkie.removeDummy(data)
		if data == LocalPlayer() then
			stopSpeaking(data)
		end
	end
end)

talkie.activeChannels = talkie.activeChannels or {}
netstream.Hook('dbg-talkie.sync', function(chans)
	talkie.activeChannels = chans
end)

-- VOICE PANELS
local displayNotifies = CreateClientConVar('cl_dbg_talkienotifies', '1', true)
talkie.voicePnls = talkie.voicePnls or {}

local function usingTalkie(ply)
	if LocalPlayer():GetPos():DistToSqr(ply:GetPos()) <= ply:GetNetVar('TalkRange', 150000) then return false end
	return ply:IsUsingTalkie()
end

local function endVoice(ply)
	local plyPnl = talkie.voicePnls[ply]
	if not IsValid(plyPnl) or plyPnl.fadeAnim then return end
	plyPnl.fadeAnim = Derma_Anim('FadeOut', plyPnl, plyPnl.FadeOut)
	plyPnl.fadeAnim:Start(2)
end
hook.Add('PlayerEndVoice', 'dbg-talkie.onEnd', endVoice)

hook.Add('PlayerStartVoice', 'dbg-talkie.onStart', function(ply)
	if not (usingTalkie(ply) and displayNotifies:GetBool()) then return end

	local vl = talkie.voiceListPnl
	if not IsValid(vl) then return end

	endVoice(ply)

	if IsValid(talkie.voicePnls[ply]) then
		if talkie.voicePnls[ply].fadeAnim then
			talkie.voicePnls[ply].fadeAnim:Stop()
			talkie.voicePnls[ply].fadeAnim = nil
		end
		talkie.voicePnls[ply]:SetAlpha(255)
		return
	end

	if not IsValid(ply) then return end

	local pnl = vl:Add('talkie_notify')
	pnl:Setup(ply)

	talkie.voicePnls[ply] = pnl

end)

local function cleanVoice()
	for k, v in pairs(talkie.voicePnls) do
		if not IsValid(k) then endVoice(k) end
	end
end
timer.Create('VoiceClean', 10, 0, cleanVoice)

hook.Add('InitPostEntity', 'CreateVoiceVGUI', function()
	if IsValid(talkie.voiceListPnl) then talkie.voiceListPnl:Remove() end
	talkie.voiceListPnl = vgui.Create('DPanel')
	talkie.voiceListPnl:ParentToHUD()
	talkie.voiceListPnl:SetPos(ScrW() - 300, 100)
	talkie.voiceListPnl:SetSize(250, ScrH() - 200)
	talkie.voiceListPnl:SetPaintBackground(false)
end)
