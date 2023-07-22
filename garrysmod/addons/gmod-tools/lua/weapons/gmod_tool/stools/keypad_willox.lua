if (SERVER) then
	CreateConVar('sbox_maxkeypads', 10)
end

TOOL.Category = "Dobrograd"
TOOL.Name = "Кейпады"
TOOL.Command = nil

TOOL.ClientConVar['weld'] = '1'
TOOL.ClientConVar['freeze'] = '1'

TOOL.ClientConVar['password'] = '1234'
TOOL.ClientConVar['secure'] = '0'

TOOL.ClientConVar['repeats_granted'] = '0'
TOOL.ClientConVar['repeats_denied'] = '0'

TOOL.ClientConVar['length_granted'] = '0.1'
TOOL.ClientConVar['length_denied'] = '0.1'

TOOL.ClientConVar['delay_granted'] = '0'
TOOL.ClientConVar['delay_denied'] = '0'

TOOL.ClientConVar['init_delay_granted'] = '0'
TOOL.ClientConVar['init_delay_denied'] = '0'

TOOL.ClientConVar['key_granted'] = '0'
TOOL.ClientConVar['key_denied'] = '0'

cleanup.Register("keypads")

if CLIENT then
	language.Add("tool.keypad_willox.name", "Кейпады")
	language.Add("tool.keypad_willox.left", "Создать новый кейпад")
	language.Add("tool.keypad_willox.right", "Обновить существующий")
	language.Add("tool.keypad_willox.desc", "Создает кодовые замки")

	language.Add("Undone_Keypad", "Кейпад удален")
	language.Add("Cleanup_keypads", "Кейпады")
	language.Add("Cleaned_keypads", "Удалены все кейпады")

	language.Add("SBoxLimit_keypads", "Достигнут лимит кейпадов!")
end

function TOOL:SetupKeypad(ent, pass)
	local data = {
		Password = pass,

		RepeatsGranted = self:GetClientNumber("repeats_granted"),
		RepeatsDenied = self:GetClientNumber("repeats_denied"),

		LengthGranted = self:GetClientNumber("length_granted"),
		LengthDenied = self:GetClientNumber("length_denied"),

		DelayGranted = self:GetClientNumber("delay_granted"),
		DelayDenied = self:GetClientNumber("delay_denied"),

		InitDelayGranted = self:GetClientNumber("init_delay_granted"),
		InitDelayDenied = self:GetClientNumber("init_delay_denied"),

		KeyGranted = self:GetClientNumber("key_granted"),
		KeyDenied = self:GetClientNumber("key_denied"),

		Secure = util.tobool(self:GetClientNumber("secure")),

		Owner = self:GetOwner():SteamID()
	}

	ent:SetData(data)
end

function TOOL:RightClick(tr)
	if not IsValid(tr.Entity) or not tr.Entity:GetClass():lower() == "keypad" or not tr.Entity.KeypadData then return false end

	if CLIENT then return true end

	local ply = self:GetOwner()
	local password = tonumber(ply:GetInfo("keypad_willox_password"))

	local spawn_pos = tr.HitPos
	local trace_ent = tr.Entity

	if password == nil or (string.len(tostring(password)) > 4) or (string.find(tostring(password), "0")) then
		ply:PrintMessage(3, "Пароль должен состоять не более чем из четырех цифр и не содержать 0!")
		return false
	end

	if trace_ent.KeypadData.Owner == ply:SteamID() then
		self:SetupKeypad(trace_ent, password)
		return true
	end
end

function TOOL:LeftClick(tr)
	if IsValid(tr.Entity) and tr.Entity:GetClass():lower() == "player" then return false end

	if CLIENT then return true end

	local ply = self:GetOwner()
	local password = self:GetClientNumber("password")

	local spawn_pos = tr.HitPos + tr.HitNormal
	local trace_ent = tr.Entity

	if password == nil or (string.len(tostring(password)) > 4) or (string.find(tostring(password), "0")) then
		ply:PrintMessage(3, "Пароль должен состоять не более чем из четырех цифр и не содержать 0!")
		return false
	end

	if not self:GetWeapon():CheckLimit("keypads") then return false end

	local ent = ents.Create("keypad")
	ent:SetPos(spawn_pos)
	ent:SetAngles(tr.HitNormal:Angle())
	ent:Spawn()

	ent:SetPlayer(ply)

	local freeze = util.tobool(self:GetClientNumber("freeze"))
	local weld = util.tobool(self:GetClientNumber("weld"))

	if freeze or weld then
		local phys = ent:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end

	-- if weld then
	-- 	local weld = constraint.Weld(ent, trace_ent, 0, 0, 0, true, false)
	-- end

	self:SetupKeypad(ent, password)

	undo.Create("Keypad")
		undo.AddEntity(ent)
		undo.SetPlayer(ply)
	undo.Finish()

	ply:AddCount("keypads", ent)
	ply:AddCleanup("keypads", ent)

	return true
end


if CLIENT then
	local function ResetSettings(ply)
		ply:ConCommand("keypad_willox_repeats_granted 0")
		ply:ConCommand("keypad_willox_repeats_denied 0")
		ply:ConCommand("keypad_willox_length_granted 0.1")
		ply:ConCommand("keypad_willox_length_denied 0.1")
		ply:ConCommand("keypad_willox_delay_granted 0")
		ply:ConCommand("keypad_willox_delay_denied 0")
		ply:ConCommand("keypad_willox_init_delay_granted 0")
		ply:ConCommand("keypad_willox_init_delay_denied 0")
	end

	concommand.Add("keypad_willox_reset", ResetSettings)

	function TOOL.BuildCPanel(CPanel)
		local r, l = CPanel:TextEntry("Код доступа", "keypad_willox_password")
		r:SetTall(22)

		CPanel:ControlHelp("Максимальная длина: 4\nРазрешены цифры 1-9")

		CPanel:CheckBox("Не показывать код на экране", "keypad_willox_secure")
		CPanel:CheckBox("Приварить", "keypad_willox_weld")
		CPanel:CheckBox("Закрепить", "keypad_willox_freeze")

		local ctrl = vgui.Create("CtrlNumPad", CPanel)
			ctrl:SetConVar1("keypad_willox_key_granted")
			ctrl:SetConVar2("Keypad_willox_key_denied")
			ctrl:SetLabel1("Если код верен, нажать")
			ctrl:SetLabel2("Если код неверен, нажать")
		CPanel:AddPanel(ctrl)

		local granted = vgui.Create("DForm")
			granted:SetName("Поведение при правильном коде")

			granted:NumSlider("Длина [1]", "keypad_willox_length_granted", 0.1, 10, 2)
			granted:NumSlider("Перв. задерж. [2]", "keypad_willox_init_delay_granted", 0, 10, 2)
			granted:NumSlider("Доп. задерж. [3]", "keypad_willox_delay_granted", 0, 10, 2)
			granted:NumSlider("Доп. активаций [4]", "keypad_willox_repeats_granted", 0, 5, 0)
		CPanel:AddItem(granted)

		local denied = vgui.Create("DForm")
			denied:SetName("Поведение при неправильном коде")

				denied:NumSlider("Длина [1]", "keypad_willox_length_denied", 0.1, 10, 2)
				denied:NumSlider("Перв. задерж. [2]", "keypad_willox_init_delay_denied", 0, 10, 2)
				denied:NumSlider("Доп. задерж. [3]", "keypad_willox_delay_denied", 0, 10, 2)
				denied:NumSlider("Доп. активаций [4]", "keypad_willox_repeats_denied", 0, 5, 0)
		CPanel:AddItem(denied)

		CPanel:Button("Настройки по умолчанию", "keypad_willox_reset")

		CPanel:Help("")

		local faq = CPanel:Help("Справка")
			faq:SetFont("GModWorldtip")

		CPanel:Help("[1] Сколько времени удерживать кнопку зажатой?")
		CPanel:Help("[2] Через сколько времени после активации нажать кнопку первый раз?")
		CPanel:Help("[3] Через сколько времени после предыдущего отжатия кнопки нажать ее еще раз?")
		CPanel:Help("[4] Сколько раз дополнительно нужно нажать эту кнопку? ([3] - задержка между нажатиями)")

		CPanel:Help("")

		CPanel:Help("Используй цифры на клавиатуре для ввода кода.")

		CPanel:Help("")

		CPanel:Help("Создано Willox (http://steamcommunity.com/id/wiox)")
		CPanel:Help("Модифицировано Octothorp Team (https://octothorp.team)")
	end
end
