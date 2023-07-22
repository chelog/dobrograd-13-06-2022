-- Teleporter STool
-- By Anya O'Quinn / Slade Xanthas

AddCSLuaFile()

if SERVER then
	CreateConVar("sbox_maxteleporters_adv", 20)
end

if CLIENT then
	language.Add("tool.teleporter_adv.name", 	"Teleporter")
	language.Add("tool.teleporter_adv.desc", 	"Spawn a Teleporter")
	language.Add("tool.teleporter_adv.0", 		"Primary: Create/Update Teleporter you're looking at, Spawn two teleporters to make a set. Secondary: Changes the teleporter model to what you're looking at.")
	language.Add("Cleanup_teleporters_adv", 	"Teleporters")
	language.Add("Cleaned_teleporters_adv", 	"Cleaned up all Teleporters")
	language.Add("Undone_teleporter_adv", 		"Undone Teleporter")
	language.Add("SBoxLimit_teleporters_adv", 	"You've hit Teleporter limit!")
end

TOOL.Name							= "#tool.teleporter_adv.name"
TOOL.Category						= "Construction"
TOOL.ConfigName						= ""
TOOL.ClientConVar["model"] 			= "models/Items/combine_rifle_ammo01.mdl"
TOOL.ClientConVar["sound"] 			= "ambient/levels/citadel/weapon_disintegrate2.wav"
TOOL.ClientConVar["effect"] 		= "sparks"
TOOL.ClientConVar["radius"] 		= "100"
TOOL.ClientConVar["ontouch"] 		= "0"
TOOL.ClientConVar["onuse"] 			= "0"
TOOL.ClientConVar["showbeam"] 		= "1"
TOOL.ClientConVar["showradius"] 	= "1"
TOOL.ClientConVar["shake"]		 	= "1"
TOOL.ClientConVar["delay"]		 	= "1"
TOOL.ClientConVar["height"]		 	= "50"
TOOL.ClientConVar["key"] 			= "1"

cleanup.Register("teleporters_adv")

list.Set("TeleporterModels", "models/hunter/plates/plate.mdl", {})
list.Set("TeleporterModels", "models/props_c17/lockers001a.mdl", {})
list.Set("TeleporterModels", "models/props_c17/door01_left.mdl", {})
list.Set("TeleporterModels", "models/props_c17/clock01.mdl", {})
list.Set("TeleporterModels", "models/items/item_item_crate.mdl", {})
list.Set("TeleporterModels", "models/props/cs_militia/footlocker01_closed.mdl", {})
list.Set("TeleporterModels", "models/props_junk/trashdumpster01a.mdl", {})
list.Set("TeleporterModels", "models/Items/combine_rifle_ammo01.mdl", {})
list.Set("TeleporterModels", "models/props_junk/sawblade001a.mdl", {})
list.Set("TeleporterModels", "models/props_combine/combine_mine01.mdl", {})
list.Set("TeleporterModels", "models/props_wasteland/prison_toilet01.mdl", {})
list.Set("TeleporterModels", "models/props_lab/teleplatform.mdl", {})
list.Set("TeleporterModels", "models/props_wasteland/laundry_basket002.mdl", {})

list.Set("TeleporterSounds", "NONE", 				{teleporter_adv_sound = ""})
list.Set("TeleporterSounds", "Ammocrate", 			{teleporter_adv_sound = "items/ammocrate_open.wav"})
list.Set("TeleporterSounds", "Door 1", 				{teleporter_adv_sound = "doors/door_metal_medium_open1.wav"})
list.Set("TeleporterSounds", "Door 2", 				{teleporter_adv_sound = "doors/door_metal_large_open1.wav"})
list.Set("TeleporterSounds", "Door 3", 				{teleporter_adv_sound = "doors/door1_stop.wav"})
list.Set("TeleporterSounds", "Gate", 				{teleporter_adv_sound = "doors/door_metal_gate_close1.wav"})
list.Set("TeleporterSounds", "Thunder", 			{teleporter_adv_sound = "stormfox2/amb/thunder_strike.ogg"})
list.Set("TeleporterSounds", "Weapon", 				{teleporter_adv_sound = "buttons/weapon_confirm.wav"})
list.Set("TeleporterSounds", "Lever", 				{teleporter_adv_sound = "buttons/lever1.wav"})
list.Set("TeleporterSounds", "Revive", 				{teleporter_adv_sound = "dbg/revive.ogg"})
list.Set("TeleporterSounds", "Drugs", 				{teleporter_adv_sound = "drugs/insufflation.wav"})
list.Set("TeleporterSounds", "Pain", 				{teleporter_adv_sound = "hostage/hpain/hpain5.wav"})
list.Set("TeleporterSounds", "Crate close", 		{teleporter_adv_sound = "items/ammocrate_close.wav"})
list.Set("TeleporterSounds", "Drop", 				{teleporter_adv_sound = "items/gift_drop.wav"})
list.Set("TeleporterSounds", "Crow", 				{teleporter_adv_sound = "npc/crow/idle2.wav"})
list.Set("TeleporterSounds", "Teleport1", 			{teleporter_adv_sound = "ambient/machines/teleport1.wav"})
list.Set("TeleporterSounds", "Teleport2", 			{teleporter_adv_sound = "ambient/machines/teleport2.wav"})
list.Set("TeleporterSounds", "Teleport3", 			{teleporter_adv_sound = "ambient/machines/teleport3.wav"})
list.Set("TeleporterSounds", "Zap1", 				{teleporter_adv_sound = "ambient/machines/zap1.wav"})
list.Set("TeleporterSounds", "Zap2", 				{teleporter_adv_sound = "ambient/machines/zap2.wav"})
list.Set("TeleporterSounds", "Zap3", 				{teleporter_adv_sound = "ambient/machines/zap3.wav"})
list.Set("TeleporterSounds", "Spark", 				{teleporter_adv_sound = "DoSpark"})
list.Set("TeleporterSounds", "Whiteflash", 			{teleporter_adv_sound = "ambient/energy/whiteflash.wav"})
list.Set("TeleporterSounds", "BM Teleport", 		{teleporter_adv_sound = "BMS_objects/portal/portal_In_01.wav"})
list.Set("TeleporterSounds", "Disintegrate1", 		{teleporter_adv_sound = "ambient/levels/citadel/weapon_disintegrate1.wav"})
list.Set("TeleporterSounds", "Disintegrate2", 		{teleporter_adv_sound = "ambient/levels/citadel/weapon_disintegrate2.wav"})
list.Set("TeleporterSounds", "Disintegrate3", 		{teleporter_adv_sound = "ambient/levels/citadel/weapon_disintegrate3.wav"})
list.Set("TeleporterSounds", "Disintegrate4", 		{teleporter_adv_sound = "ambient/levels/citadel/weapon_disintegrate4.wav"})
list.Set("TeleporterSounds", "TF2 Teleporter Send ", 	{teleporter_adv_sound = "weapons/teleporter_send.wav"})
list.Set("TeleporterSounds", "TF2 Teleporter Receive ", {teleporter_adv_sound = "weapons/teleporter_receive.wav"})
list.Set("TeleporterSounds", "TF2 Teleporter Ready ", {teleporter_adv_sound = "weapons/teleporter_ready.wav"})
list.Set("TeleporterSounds", "TFC Teleporter Send ", 	{teleporter_adv_sound = "misc/teleport_in.wav"})
list.Set("TeleporterSounds", "TFC Teleporter Receive ", {teleporter_adv_sound = "misc/teleport_out.wav"})
list.Set("TeleporterSounds", "TFC Teleporter Ready ", {teleporter_adv_sound = "misc/teleport_ready.wav"})

list.Set("TeleporterEffects", "Prop Spawn", 		{teleporter_adv_effect = "propspawn"})
list.Set("TeleporterEffects", "Explosion", 			{teleporter_adv_effect = "explosion"})
list.Set("TeleporterEffects", "Silent Explosion", 	{teleporter_adv_effect = "helicoptermegabomb"})
list.Set("TeleporterEffects", "Sparks", 			{teleporter_adv_effect = "sparks"})
list.Set("TeleporterEffects", "Combineball Bounce", {teleporter_adv_effect = "cball_bounce"})
list.Set("TeleporterEffects", "None", 				{teleporter_adv_effect = ""})

local function MakeTeleporter(ply, pos, Ang, model, skin, bgs, sound, effect, radius, ontouch, onuse, showbeam, showradius, shake, delay, height, key)

	if not SERVER then return end
	if IsValid(ply) and not ply:CheckLimit("teleporters_adv") then return false end

	local teleporter = ents.Create("gmod_advteleporter")
	if not IsValid(teleporter) then return false end
	timer.Simple(0, function()
		teleporter:GetPhysicsObject():EnableMotion(false)
	end)

	teleporter:SetAngles(Ang)
	teleporter:SetPos(pos)
	teleporter:SetModel(Model(model))
	teleporter:SetSkin(skin or 0)
	for k, v in pairs(bgs or {}) do
		teleporter:SetBodygroup(k, v)
	end
	teleporter:Spawn()
	teleporter.Owner = ply
	teleporter:Setup(model, sound, effect, radius, ontouch, onuse, showbeam, showradius, shake, delay, height, key)

	if IsValid(ply) then
		numpad.OnDown(ply, key, "Teleporter_On", teleporter)
		numpad.OnUp(ply, key, "Teleporter_Off", teleporter)
	end

	local ttable = {
		model = model,
		sound = sound,
		effect = effect,
		radius = radius,
		ontouch = ontouch,
		onuse = onuse,
		showbeam = showbeam,
		showradius = showradius,
		shake = shake,
		delay = delay,
		height = height,
		key = key,
	}

	table.Merge(teleporter:GetTable(), ttable)
	if IsValid(ply) then ply:AddCount("teleporters_adv", teleporter) end
	DoPropSpawnedEffect(teleporter)

	return teleporter

end

duplicator.RegisterEntityClass("gmod_advteleporter", MakeTeleporter, "pos", "ang", "model", "Skin", "BodyG", "sound", "effect", "radius", "ontouch", "onuse", "showbeam", "showradius", "shake", "delay", "height", "key")

function TOOL:LeftClick(trace)

	if not trace.Hit then return false end

	local ent = trace.Entity

	if IsValid(ent) and ent:IsPlayer() then return false end
	if SERVER and not util.IsValidPhysicsObject(ent,trace.PhysicsBone) then return false end
	if CLIENT then return true end

	local ply = self:GetOwner()
	local model = self:GetClientInfo("model")
	local sound = self:GetClientInfo("sound")
	local effect = self:GetClientInfo("effect")
	local radius = math.Clamp(self:GetClientNumber("radius"),8,512)
	local ontouch = (self:GetClientNumber("ontouch") == 1)
	local onuse = (self:GetClientNumber("onuse") == 1)
	local showbeam = (self:GetClientNumber("showbeam") == 1)
	local showradius = (self:GetClientNumber("showradius") == 1)
	local shake = (self:GetClientNumber("shake") == 1)
	local delay = math.Clamp(self:GetClientNumber("delay"),0.5,10)
	local height = math.Clamp(self:GetClientNumber("height"),0,128)
	local key = self:GetClientNumber("key")

	if IsValid(ent) and ent:GetClass() == "gmod_advteleporter" then

		ent:Setup(model, sound, effect, radius, ontouch, onuse, showbeam, showradius, shake, delay, height, key)

		local ttable = {
			model = model,
			sound = sound,
			effect = effect,
			radius = radius,
			ontouch = ontouch,
			onuse = onuse,
			showbeam = showbeam,
			showradius = showradius,
			shake = shake,
			delay = delay,
			height = height,
			key = key,
		}

		table.Merge(ent:GetTable(), ttable)
		return true

	end

	if not self:GetSWEP():CheckLimit("teleporters_adv") then return false end

	local pos = trace.HitPos
	local ang = trace.HitNormal:Angle()
	ang.pitch = ang.pitch + 90

	local teleporter = MakeTeleporter(ply, pos, ang, model, 0, {}, sound, effect, radius, ontouch, onuse, showbeam, showradius, shake, delay, height, key)

	if not IsValid(teleporter) then return end

	local min = teleporter:OBBMins()
	teleporter:SetPos(trace.HitPos - trace.HitNormal * min.z)

	if not teleporter:IsInWorld() then
		teleporter:Remove()
		return false
	end

	if trace.HitWorld then teleporter:GetPhysicsObject():EnableMotion(false) end

	if IsValid(ent) then
		local const = constraint.Weld(teleporter, ent, trace.PhysicsBone, 0, 0)
		local nocollide = constraint.NoCollide(teleporter, ent, 0, trace.PhysicsBone)
		ent:DeleteOnRemove(teleporter)
	end

	undo.Create("teleporter_adv")
		undo.AddEntity(teleporter)
		undo.AddEntity(const)
		undo.AddEntity(nocollide)
		undo.SetPlayer(ply)
	undo.Finish()

	ply:AddCleanup("teleporters_adv", teleporter)
	ply:AddCleanup("teleporters_adv", const)
	ply:AddCleanup("teleporters_adv", nocollide)

	return true

end

function TOOL:RightClick(trace)
	local tr_ent = trace.Entity
	if not tr_ent or not tr_ent:IsValid() then return false end

	local model = tr_ent:GetModel()
	if game.SinglePlayer() and SERVER then
		self:GetOwner():ConCommand( "teleporter_adv_model " .. model ) -- this will run serverside if SP
		self:GetOwner():ChatPrint( "Teleporter model changed to '" .. model .. "'" )
	elseif CLIENT then -- else we can just as well run it client side instead
		RunConsoleCommand("teleporter_adv_model", model)
		self:GetOwner():ChatPrint( "Teleporter model changed to '" .. model .. "'" )
	end
	return true
end

function TOOL:Reload(trace)
	return false
end

function TOOL:UpdateGhostEntity(ent, ply)

	if not IsValid(ent) then return end

	local tr = ply:GetEyeTrace()

	if not tr.Hit or IsValid(tr.Entity) and tr.Entity:GetClass() == "gmod_advteleporter" or tr.Entity:IsPlayer() then
		ent:SetNoDraw(true)
		return
	end

	local ang = tr.HitNormal:Angle()
	ang.pitch = ang.pitch + 90

	local min = ent:OBBMins()
	ent:SetPos(tr.HitPos - tr.HitNormal * min.z)
	ent:SetAngles(ang)

	ent:SetNoDraw(false)

end

function TOOL:Think()

	if not IsValid(self.GhostEntity) or (IsValid(self.GhostEntity) and self.GhostEntity:GetModel() ~= self:GetClientInfo("model")) then
		self:MakeGhostEntity(self:GetClientInfo("model"), Vector(0,0,0), Angle(0,0,0))
	end

	self:UpdateGhostEntity(self.GhostEntity, self:GetOwner())

end

function TOOL.BuildCPanel(CPanel)

	CPanel:AddControl("Header", {Text = "#Tool.teleporter_adv.name", Description = "#Tool.teleporter_adv.desc"})

	local Options = {
		Default = {
			teleporter_adv_model 		= "models/Items/combine_rifle_ammo01.mdl",
			teleporter_adv_sound 		= 0,
			teleporter_adv_ontouch		= 0,
			teleporter_adv_onuse 		= 0,
			teleporter_adv_key 			= 1
		}
	}

	local CVars = {
		"teleporter_adv_model",
		"teleporter_adv_sound",
		"teleporter_adv_effect",
		"teleporter_adv_ontouch",
		"teleporter_adv_onuse",
		"teleporter_adv_showbeam",
		"teleporter_adv_showradius",
		"teleporter_adv_shake",
		"teleporter_adv_delay",
		"teleporter_adv_height",
		"teleporter_adv_key"
	}

	CPanel:AddControl("ComboBox",
		{
			Label = "#Presets",
			MenuButton = 1,
			Folder = "teleporter_adv",
			Options = Options,
			CVars = CVars
		}
	)

	CPanel:AddControl("PropSelect",
		{
			Label = "Model:",
			ConVar = "teleporter_adv_model",
			Category = "Teleporters",
			Models = list.Get("TeleporterModels")
		}
	)

	CPanel:AddControl("Numpad",
		{
			Label = "Key:",
			Command = "teleporter_adv_key",
			ButtonSize = 22
		}
	)

 	CPanel:AddControl("Slider",
		{
			Label = "Teleport Radius:",
			Command = "teleporter_adv_radius",
			min = 16,
			max = 256
		}
	)

	CPanel:AddControl("Slider",
		{
			Label = "Teleport Delay:",
			Command = "teleporter_adv_delay",
			Type = "float",
			min = 0.5,
			max = 10
		}
	)

	CPanel:AddControl("Slider",
		{
			Label = "Teleport Height:",
			Command = "teleporter_adv_height",
			min = 0,
			max = 128
		}
	)


	CPanel:TextEntry("Teleport Sound", "teleporter_adv_sound")
	CPanel:Button("Sound Browser", "wire_sound_browser_open")

 	CPanel:AddControl("ComboBox",
		{
			Label = "Teleport Effect:",
			MenuButton = 0,
			Command = "teleporter_adv_effect",
			Options = list.Get("TeleporterEffects")
		}
	)

	CPanel:AddControl("CheckBox",
		{
			Label = "Teleport On Touch",
			Command = "teleporter_adv_ontouch"
		}
	)

	CPanel:AddControl("CheckBox",
		{
			Label = "Teleport On Use",
			Command = "teleporter_adv_onuse"
		}
	)

	CPanel:AddControl("CheckBox",
		{
			Label = "Show Beam",
			Command = "teleporter_adv_showbeam"
		}
	)

	CPanel:AddControl("CheckBox",
		{
			Label = "Show Teleport Radius",
			Command = "teleporter_adv_showradius"
		}
	)

	CPanel:AddControl("CheckBox",
		{
			Label = "Shake On Teleport",
			Command = "teleporter_adv_shake"
		}
	)

end

-- 37062385
