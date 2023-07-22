--[[

	well, if you're reading this, you probably tried to steal the code
	luckily, I can properly split realms and you get not working clientside code

	- chelog

]]

include('shared.lua')

SWEP.DrawCrosshair = true

function SWEP:PrimaryAttack()

	if not IsFirstTimePredicted() then return end

	if not self.Owner:KeyDown(IN_ATTACK2) then
		local aim = self.Owner:EyeAngles():Forward()
		local should = true
		local tr = util.TraceLine({
			start = self.Owner:EyePos(),
			endpos = self.Owner:EyePos() + aim * 100,
			filter = self.Owner
		})
		if tr.Entity:IsPlayer() then
			should = not tr.Entity:GetNetVar('Ghost') and tr.Entity:Crouching()
				and IsValid(tr.Entity:GetActiveWeapon()) and tr.Entity:GetActiveWeapon():GetHoldType() == 'pistol'
		end
		local veh = self.Owner:GetVehicle()
		if IsValid(veh) and IsValid(veh:GetParent()) then return end
		if IsValid(tr.Entity) and not self.doNotDrag[tr.Entity:GetClass()] and tr.Entity:GetClass() ~= 'prop_ragdoll' and not tr.Entity:IsDoor() and should then
			self.pickedEnt = tr.Entity
			self.pickedEntOffset = tr.Entity:WorldToLocal( tr.HitPos )
			self.isHolding = true
		end
	end

end

function SWEP:SecondaryAttack()

	-- keep calm and do nothing

end

function SWEP:Reload()

	if self.Owner:InVehicle() then return end
	if not self.NextToggleCrosshair or self.NextToggleCrosshair <= CurTime() then
		self.DrawCrosshair = not self.DrawCrosshair
		self.NextToggleCrosshair = CurTime() + 0.5
		octolib.notify.show('rp', L.crosshair, ' ', self.DrawCrosshair and L.enabled or L.disabled)
	end

end

function SWEP:DrawWorldModel()

	return false

end

function SWEP:DrawWorldModelTranslucent()

	return false

end

local nextPunch = 0
function SWEP:Think()

	local owner = self.Owner
	local meleetime = self:GetNextMeleeAttack()
	if ( meleetime > 0 and CurTime() > meleetime and owner:KeyDown(IN_ATTACK2) and CurTime() > nextPunch ) then
		owner:SetAnimation(PLAYER_ATTACK1)
		nextPunch = CurTime() + 0.2
	end

	if not owner:InVehicle() and self.isHolding then
		if not IsValid(self.pickedEnt) or (not input.IsMouseDown(MOUSE_LEFT) or input.IsMouseDown(MOUSE_RIGHT)) then
			self.isHolding = nil
			self.pickedEnt = nil
			self.pickedEntOffset = nil
		end
	end

	HAND_DRAGGING = self.isHolding

end

local curStep, target = 1, nil
local bones = {
	'ValveBiped.Bip01_Head1',
	'ValveBiped.Bip01_Spine',
	'ValveBiped.Bip01_L_UpperArm',
	'ValveBiped.Bip01_R_UpperArm',
}

local function priestThingies( self )

	if self.Owner:KeyDown(IN_ATTACK) then
		local x, y = ScrW()/2, ScrH()/2

		if not IsValid(target) then
			local pos = self.Owner:GetPos()
			local r = Vector(150,150,150)
			for i, ent in ipairs(ents.FindInBox(pos - r, pos + r)) do
				if IsValid(ent) and ent:IsPlayer() and ent:GetNetVar('Ghost') and ent:GetPos():DistToSqr(self.Owner:GetPos()) < 6000 then
					target = ent
				end
			end
		end

		if IsValid(target) and bones[curStep] then
			if target:GetPos():DistToSqr(self.Owner:GetPos()) > 6000 then
				target = nil
				return
			end

			local bone = target:LookupBone(bones[curStep])
			if bone then
				local pos, ang = target:GetBonePosition(bone)
				pos = pos:ToScreen()
				draw.RoundedBox(8, pos.x-8, pos.y-8, 16, 16, color_white)
				surface.SetDrawColor(255,255,255)
				surface.DrawLine(x, y, pos.x, pos.y)

				if math.abs(pos.x - x) < 8 and math.abs(pos.y - y) < 8 then
					curStep = curStep + 1
				end
			end
		end

		if curStep == 5 and IsValid(target) then
			net.Start('dbg-revive')
				net.WriteEntity(target)
			net.SendToServer()

			curStep = curStep + 1
		end
	else
		curStep = 1
		target = nil
	end

end

function SWEP:DrawHUD()

	if self.Owner:Team() == TEAM_PRIEST then
		priestThingies( self )
	end

end

local dragging, isHands
hook.Add('PostDrawTranslucentRenderables', 'dbg-hands', function()

	local wep = LocalPlayer():GetActiveWeapon()
	if IsValid(wep) and wep:GetClass() == 'dbg_hands' then
		if IsValid(wep.pickedEnt) then
			local pos1 = wep.Owner:EyePos() + wep.Owner:GetAimVector() * 80
			local pos2 = wep.pickedEnt:LocalToWorld( wep.pickedEntOffset )
			wep.pos1 = pos1
			wep.pos2 = pos2

			cam.Start3D()
				render.DrawLine(pos1, pos2, Color(255,255,255), true)
				render.DrawLine(pos1, pos2, Color(255,255,255, 10), false)
			cam.End3D()

			dragging = {pos1, (EyePos() - pos1):GetNormalized()}
		else
			dragging = nil
		end
		isHands = wep
	else
		isHands = nil
	end

end)

hook.Add('dbg-view.chShouldDraw', 'dbg_hands', function()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	local wep = ply:GetActiveWeapon()
	if ply:InVehicle() and IsValid(wep) and wep:GetClass() == 'dbg_hands' then return false end
end)

local iconOn, iconOff = Material('octoteam/icons/hand_fist.png'), Material('octoteam/icons/hand.png')
hook.Add('dbg-view.chOverride', 'dbg_hands', function(tr)

	if dragging then
		tr.HitPos = dragging[1]
		tr.HitNormal = dragging[2]
		tr.Fraction = 0.05
		return iconOn, 255, 0.35
	elseif isHands and tr.Fraction < 0.05 then
		local ent = tr.Entity
		if IsValid(ent) and isHands.doNotDrag and not isHands.doNotDrag[ent:GetClass()] then
			return iconOff, 255, 0.35
		end
	end

end)

netstream.Hook('dbg_hands.StopDragging', function()

	local wep = LocalPlayer():GetActiveWeapon()
	if IsValid(wep) and wep:GetClass() == 'dbg_hands' and wep.isHolding then
		wep.isHolding = nil
		wep.pickedEnt = nil
		wep.pickedEntOffset = nil
	end

end)
