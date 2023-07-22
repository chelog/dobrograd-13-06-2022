 -- thanks gmod update
RunConsoleCommand('hud_draw_fixed_reticle', '0')
RunConsoleCommand('hud_quickinfo', '0')

local plyMeta = FindMetaTable 'Player'
function plyMeta:isMedic()
	local job = self:getJobTable()
	return job and job.medic or false
end

local hideHUDElements = {
	CMapOverwview = true,
	DarkRP_Hungermod = true,
	CHudHealth = true,
	CHudBattery = true,
	CHudSuitPower = true,
	CHudDamageIndicator = true,
	CHudChat = true,
}

hook.Add('HUDShouldDraw', 'HideDefaultDarkRPHud', function(name)
	if hideHUDElements[name] then return false end
end)

hook.Add('StartChat', 'crim-compat', function(t)

	netstream.Start('isTyping', true)

end)

hook.Add('FinishChat', 'crim-compat', function()

	netstream.Start('isTyping', false)

end)

local showhelp = CreateClientConVar('dbg_help_login', 1, true, false)
hook.Add('Think', 'dbg-help', function()

	hook.Remove('Think', 'dbg-help')

	if IsValid(DBG_TUTORIAL) then DBG_TUTORIAL:Remove() end
	local f = vgui.Create 'DFrame'
	DBG_TUTORIAL = f

	f:SetSize(350, 524)
	f:DockPadding(0,24,0,0)
	f:AlignTop(5)
	f:AlignRight(5)
	f:ShowCloseButton(false)
	f:SetTitle(L.training)
	f:SetVisible(showhelp:GetBool())

	local w = f:Add 'DButton'
	w:SetTall(18)
	w:SetText(L.open_wiki)
	w:SizeToContentsX(12)
	w:AlignTop(3)
	w:AlignRight(3)
	function w:DoClick()
		octoesc.OpenURL('https://wiki.octothorp.team')
	end

	local html = f:Add 'DHTML'
	html:Dock(FILL)
	html:OpenURL('https://old.octothorp.team/dobrograd/help')

	local GM = GM or GAMEMODE
	function GM:ShowHelp()
		if IsValid(DBG_TUTORIAL) then
			DBG_TUTORIAL:SetVisible(not DBG_TUTORIAL:IsVisible())
		end
	end

end)

local function run()
if not GAMEMODE then return end
-- function GAMEMODE:GrabEarAnimation(ply)

-- 	ply.ChatGestureWeight = ply.ChatGestureWeight || 0

-- 	if ply:IsPlayingTaunt() then return end

-- 	if ply:IsTyping() and not ply:IsUsingTalkie() then
-- 		ply.ChatGestureWeight = math.Approach(ply.ChatGestureWeight, 1, FrameTime() * 5.0)
-- 	else
-- 		ply.ChatGestureWeight = math.Approach(ply.ChatGestureWeight, 0, FrameTime() * 5.0)
-- 	end

-- 	if ply.ChatGestureWeight > 0 then

-- 		ply:AnimRestartGesture(GESTURE_SLOT_VCD, ACT_GMOD_IN_CHAT, true)
-- 		ply:AnimSetGestureWeight(GESTURE_SLOT_VCD, ply.ChatGestureWeight)

-- 	end

-- end

function GAMEMODE:CalcMainActivity( ply, velocity )

	ply.CalcIdeal = ACT_MP_STAND_IDLE
	ply.CalcSeqOverride = -1

	self:HandlePlayerLanding( ply, velocity, ply.m_bWasOnGround )

	if ( self:HandlePlayerNoClipping( ply, velocity ) ||
		self:HandlePlayerDriving( ply ) ||
		self:HandlePlayerVaulting( ply, velocity ) ||
		self:HandlePlayerJumping( ply, velocity ) ||
		self:HandlePlayerSwimming( ply, velocity ) ||
		self:HandlePlayerDucking( ply, velocity ) ) then
	else
		local len2d = velocity:Length2DSqr()
		if ( len2d > 22500 ) then ply.CalcIdeal = ACT_MP_RUN elseif ( len2d > 0.25 ) then ply.CalcIdeal = ACT_MP_WALK end
	end

	ply.m_bWasOnGround = ply:IsOnGround()
	ply.m_bWasNoclipping = ( ply:GetMoveType() == MOVETYPE_NOCLIP && !ply:InVehicle() )

	return ply.CalcIdeal, ply.CalcSeqOverride

end

hook.Add('UpdateAnimation', 'drp', function(ply, velocity, maxseqgroundspeed)
	local len = velocity:Length()
	local movement = 1.0

	if ( len > 0.2 ) then
		movement = ( len / maxseqgroundspeed )
	end

	local rate = math.min( movement, 2 )

	-- if we're under water we want to constantly be swimming..
	if ( ply:WaterLevel() >= 2 ) then
		rate = math.max( rate, 0.5 )
	elseif ( !ply:IsOnGround() && len >= 1000 ) then
		rate = 0.1
	end

	ply:SetPlaybackRate( rate )

	if ( ply:InVehicle() ) then

		local Vehicle = ply:GetVehicle()

		-- We only need to do this clientside..
		if ( CLIENT ) then
			--
			-- This is used for the 'rollercoaster' arms
			--
			local Velocity = Vehicle:GetVelocity()
			local fwd = Vehicle:GetUp()
			local dp = fwd:Dot( Vector( 0, 0, 1 ) )
			local dp2 = fwd:Dot( Velocity )

			ply:SetPoseParameter( 'vertical_velocity', ( dp < 0 && dp || 0 ) + dp2 * 0.005 )

			-- Pass the vehicles steer param down to the player
			local steer = Vehicle:GetPoseParameter( 'vehicle_steer' )
			steer = steer * 2 - 1 -- convert from 0..1 to -1..1
			if ( Vehicle:GetClass() == 'prop_vehicle_prisoner_pod' ) then steer = 0 ply:SetPoseParameter( 'aim_yaw', math.NormalizeAngle( ply:GetAimVector():Angle().y - Vehicle:GetAngles().y - 90 ) ) end
			ply:SetPoseParameter( 'vehicle_steer', steer )

		end

	end

	--	GAMEMODE:GrabEarAnimation( ply )
	GAMEMODE:MouthMoveAnimation( ply )
end)
GAMEMODE.UpdateAnimation = octolib.func.zero

function GAMEMODE:AdjustMouseSensitivity()

	local ply = LocalPlayer()
	if ( !IsValid( ply ) ) then return -1 end

	local wep = ply:GetActiveWeapon()
	if ( IsValid(wep) && wep.AdjustMouseSensitivity ) then
		return wep:AdjustMouseSensitivity()
	end

	return -1

end
GAMEMODE.DrawDeathNotice = octolib.func.zero
end
hook.Add('darkrp.loadModules', 'dobrograd', run)
run()
