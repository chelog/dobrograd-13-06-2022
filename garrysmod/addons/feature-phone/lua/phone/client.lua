function req(title, desc, func)
	return function()
		Derma_StringRequest(title, desc, '', func, nil, L.ok, L.cancel)
	end
end

local function sms()
	local text, tgtName, check = '', ''
	local f = vgui.Create 'DFrame'
	f:SetSize(400, 135)
	f:SetTitle(L.send_sms)
	f:Center()
	f:MakePopup()
	f:SetBackgroundBlur(true)

	local b = f:Add 'DButton'
	b:Dock(BOTTOM)
	b:SetTall(30)
	b:SetText(L.send)
	b:SetEnabled(false)
	function b:DoClick()
		netstream.Start('chat', ('/sms "%s" %s'):format(tgtName, text))
		f:Remove()
	end

	local function check()
		b:SetEnabled(tgtName ~= '' and string.Trim(text) ~= '')
	end

	local c = f:Add 'DComboBox'
	c:Dock(TOP)
	c:SetTall(30)
	c:DockMargin(0, 0, 0, 5)
	c:SetValue(L.recipient)
	for i, v in ipairs(player.GetAll()) do if v ~= LocalPlayer() then c:AddChoice(v:Name(), v:Name()) end end
	function c:OnSelect(i, val, data)
		tgtName = data
		check()
	end

	local e = f:Add 'DTextEntry'
	e:Dock(TOP)
	e:SetTall(20)
	e:DockMargin(5, 5, 5, 10)
	e:SetUpdateOnType(true)
	e:SetPlaceholderText(L.text_msg)
	e.PaintOffset = 5
	function e:OnValueChange(val)
		text = val
		check()
	end
end

local function anyOfTeam(func)
	for _, v in ipairs(player.GetAll()) do
		if func(v) then return true end
	end
	return false
end
local function doCommand(start)
	return function(s)
		octochat.say(start .. (s and (' ' .. s) or ''))
	end
end

netstream.Hook('dbg-phone.open', function(center, ent)

	gui.EnableScreenClicker(true)

	local menu = DermaMenu()
		local pm, smo = menu:AddSubMenu(L.call_hint)

		pm:AddOption(L.ems_hint, req(L.call_ems, 'На вызов могут отреагировать полицейские, медики и спасатели.\n' .. L.desc_sit_and_place,
			function(s) netstream.Start('dbg-phone.cr', ent, s) end)):SetIcon(octolib.icons.silk16('asterisk_yellow'))

		if anyOfTeam(DarkRP.isMedic) then
			pm:AddOption(L.medic, req(L.call_medic, 'На вызов могут отреагировать медики и фармацевты.\n' .. L.desc_sit_and_place,
				doCommand('/callmed'))):SetIcon(octolib.icons.silk16('user_medical'))
		end
		if anyOfTeam(DarkRP.isFirefighter) then
			pm:AddOption('Спасателей', req('Вызов спасателей', L.desc_sit_and_place, doCommand('/callfire'))):SetIcon(octolib.icons.silk16('user_firefighter'))
		end
		if anyOfTeam(DarkRP.isMech) then
			pm:AddOption(L.mechanic2, req(L.call_mech, L.desc_sit_and_place, doCommand('/callmech'))):SetIcon(octolib.icons.silk16('car'))
		end
		if anyOfTeam(DarkRP.isWorker) then
			pm:AddOption('Городского рабочего', req('Вызов городского рабочего', L.desc_sit_and_place, doCommand('/callworker'))):SetIcon(octolib.icons.silk16('wrench'))
		end
		if anyOfTeam(DarkRP.isTaxist) then
			pm:AddOption('Такси', req('Вызов такси', 'Опиши местоположение и место назначения', doCommand('/calltaxi'))):SetIcon(octolib.icons.silk16('car_taxi'))
		end

		smo:SetIcon(octolib.icons.silk16('phone_handset'))
		menu:AddOption('Проверить баланс', function() netstream.Start('chat', '/getbank')  end):SetIcon(octolib.icons.silk16('money'))
		menu:AddOption(L.send_sms, sms):SetIcon(octolib.icons.silk16('oms_new_text_message'))
		menu:AddOption(L.make_advert, req(L.make_advert, L.text_advert,
			function(s) netstream.Start('chat', '/ad ' .. s) end)):SetIcon(octolib.icons.silk16('advertising'))
		menu:AddOption(L.make_order, function() F4:OpenWindow('shop') end):SetIcon(octolib.icons.silk16('cart_add'))
	menu:Open()

	if center then menu:Center() end

	gui.EnableScreenClicker(false)

end)

local phone = phone or {}

local phoneAnim = {
    default = {
        Bip01_L_Hand = { ang = Angle(15, 10, -35) },
        Bip01_L_Forearm = { ang = Angle(0, -100, -40) },
        Bip01_L_Clavicle = { ang = Angle(0, 0, 0) },
        Bip01_L_UpperArm = { ang = Angle(-20, -30, 0) },

        Bip01_L_Finger0 = { ang = Angle(-5, -28, 0) },
        Bip01_L_Finger02 = { ang = Angle(0, -20, 0) },
        Bip01_L_Finger1 = { ang = Angle(5, -18, -30) },
        Bip01_L_Finger12 = { ang = Angle(0, -10, 0) },
        Bip01_L_Finger2 = { ang = Angle(10, -18, -30) },
        Bip01_L_Finger22 = { ang = Angle(0, -10, 0) },

        Bip01_Head1 = { ang = Angle(0,-10,0) },
        fov = 0.55,
    },

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
        fov = 0.2,
    },
}

local phonePos = {
	pos = Vector(1.4, 0, 1),
	ang = Angle(-240, -10, 80)
}

hook.Add('UpdateAnimation', 'dbg-phone.UpdateAnimation', function(ply, vel)

	if not IsValid(ply) then return end
	if ply:InVehicle() then return end
	if ply:GetModel() == 'models/error.mdl' then return end
	ply.PhoneAnimWeight = math.Approach(
		ply.PhoneAnimWeight or 0,
		(ply:IsUsingPhone() and ply:OnGround()) and (1 - vel:LengthSqr() / 50000) or 0,
		FrameTime() * 5
	)

	local weight = ply.PhoneAnimWeight or 0 
	if weight > 0 then
		local anim = phone.getProperAnim(ply)
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

		local state = (IsValid(ply:GetVehicle()) and 'sitting') or 'normal'

		if not IsValid(ply.Phone) then
		  phone.createDummy(ply)
		elseif ply.lastState ~= state then
		  phone.removeDummy(ply)
		  ply.lastState = state
		  return
		end

	else
		if IsValid(ply.Phone) then phone.removeDummy(ply) end
	end

end)

function phone.getProperAnim(ply)
	local veh = ply:GetVehicle()
	local weapon = ply:GetActiveWeapon()

	if IsValid(veh) then
		return phoneAnim.sitting
	elseif ply:Crouching() then
		return phoneAnim.crouching
	else
		return phoneAnim.default
	end

end

function phone.createDummy(ply)

	if IsValid(ply) and not IsValid(ply.Phone) then
		local attID = ply:LookupAttachment('anim_attachment_LH')

		local phone_m = octolib.createDummy('models/lt_c/tech/cellphone.mdl')
		phone_m:SetParent(ply, attID)
		phone_m:SetLocalPos(phonePos.pos)
		phone_m:SetLocalAngles(phonePos.ang)
		phone_m:SetModelScale(ply:GetModelScale())
		phone_m:SetSkin(5)

		ply.Phone = phone_m
	end

end

function phone.removeDummy(ply)

	if IsValid(ply) and IsValid(ply.Phone) then
		ply.Phone:Remove()
		ply.Phone = nil
		for bone,data in pairs(phone.getProperAnim(ply)) do
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
		if IsValid(ply) and IsValid(ply.Phone) and (not ply:Alive() or ply:GetNoDraw() or not ply:IsUsingPhone()) then
			phone.removeDummy(ply)
		end
	end):Then(done)
end)

local usingPhone = false
local function stopTyping(ply)
	if usingPhone then
		usingPhone = false
	end
end

hook.Add('KeyDown', 'dbg-phone.noJump', function(ply, key)
	if (key == IN_WALK) and IsFirstTimePredicted() and usingPhone then
		stopTyping(ply)
		phone.removeDummy(ply)
	end
end)

local cmds = {'/sms '}
hook.Add('ChatTextChanged', 'dbg-phone', function(txt)
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if ply:GetVelocity():LengthSqr() > 0 then return end

	local showPhone
	for _, cmd in ipairs(cmds) do
		if txt:StartWith(cmd) then
			showPhone = true
			break
		else
			showPhone = false
		end
	end

	if showPhone then
		if txt:sub(6) then netstream.Start('dbg-phone.typingSMS') end
		if not usingPhone then
			netstream.Start('dbg-phone.updateTypeStatus', true)
			usingPhone = true
		end
	elseif usingPhone then
		netstream.Start('dbg-phone.updateTypeStatus', false)
		stopTyping(ply)
	end
end)

netstream.Hook('dbg-phone.remove', function(data)
	if data and data:IsPlayer() and IsValid(data.Phone) then
		phone.removeDummy(data)
		if data == LocalPlayer() then
			stopTyping(data)
		end
	end
end)