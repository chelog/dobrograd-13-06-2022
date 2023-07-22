include 'shared.lua'
local headOffset = Vector(0,0,10)

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end
	if IsValid(self.target) then netstream.Start('dbg-punisher.kick', self.target) end
	self:SetNextPrimaryFire(CurTime() + 0.5)
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end
	if IsValid(self.target) then netstream.Start('dbg-punisher.mute', self.target) end
	self:SetNextSecondaryFire(CurTime() + 0.5)
end

local sidCopied = 'SteamID игрока %s (%s) скопирован в буфер обмена'
SWEP.nextReload = 0
function SWEP:Reload()
	if not IsFirstTimePredicted() or CurTime() < self.nextReload then return end
	local target = self.target
	if not IsValid(target) then return end
	local sid = target:SteamID()
	SetClipboardText(sid)
	octolib.notify.show(sidCopied:format(target:Name(), sid))
	self.nextReload = CurTime() + 0.5
end

hook.Add('Think', 'dbg-punisher', function()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	local wep = ply:GetActiveWeapon()
	if not (IsValid(wep) and wep:GetClass() == 'dbg_punisher') then return end
	local target = ply:GetEyeTrace().Entity
	if IsValid(target) and target:IsPlayer() then wep.target = target
	else wep.target = nil end
end)

SWEP.DrawWorldModel = octolib.func.no
SWEP.DrawWorldModelTranslucent = octolib.func.no

local function drawText(txt, font, xOffset, yOffset)
	draw.SimpleText(txt, font .. '-sh', xOffset, yOffset, color_black, TEXT_ALIGN_RIGHT)
	draw.SimpleText(txt, font, xOffset, yOffset, color_white, TEXT_ALIGN_RIGHT)
end

function SWEP:DrawHUD()
	local sw = ScrW()
	drawText('Режим пушки-наказушки', 'f4.medium', sw - 10, 5)
	drawText('ЛКМ - кик', 'f4.normal', sw - 10, 45)
	drawText('ПКМ - мут', 'f4.normal', sw - 10, 65)
	drawText('R - SteamID', 'f4.normal', sw - 10, 85)
	local target = self.target
	if not IsValid(target) then return end

	cam.Start3D()
		local mins, maxs = target:GetCollisionBounds()
		render.DrawWireframeBox(target:GetPos(), target:GetAngles(), mins, maxs, color_red)
	cam.End3D()

	local boneID = target:LookupBone('ValveBiped.Bip01_Head1')
	if not boneID then return end
	local pos = target:GetBonePosition(boneID)
	pos:Add(headOffset)
	local data = pos:ToScreen()
	draw.SimpleText(target:Name(), 'dbg-hud.normal-sh', data.x, data.y, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(target:Name(), 'dbg-hud.normal', data.x, data.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end
