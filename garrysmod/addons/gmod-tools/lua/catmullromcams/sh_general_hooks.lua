
if CLIENT then
	CatmullRomCams.CL.TunnelingTracer = {}
	--CatmullRomCams.CL.TunnelingTracer.mask = MASK_NPCWORLDSTATIC

	function CatmullRomCams.CL.CalcViewOverride(ply, origin, angles, fov)
		local weap = ply:GetActiveWeapon()

		local toolmode_active = (CatmullRomCams.SToolMethods.ToolObj and (GetConVar( "gmod_toolmode"):GetString() == "catmullrom_camera") and weap and weap:IsValid() and (weap:GetClass() == "gmod_tool"))
		local playing_track   = ply:GetNetVar("UnderControlCatmullRomCamera") and ply:GetNetVar("UnderControlCatmullRomCamera"):IsValid()

		if not (toolmode_active or playing_track) then return end

		local overrides = {}
		overrides.origin = origin
		overrides.angles = angles
		overrides.fov	= fov

		if playing_track then
			overrides.fov = ply.CatmullRomCamsTrackZoom or fov
		else
			overrides.fov	  =  CatmullRomCams.SToolMethods.ToolObj:GetClientNumber("zoom") or 75
			overrides.angles.r = (CatmullRomCams.SToolMethods.ToolObj:GetClientNumber("enable_roll") == 1) and CatmullRomCams.SToolMethods.ToolObj:GetClientNumber("roll") or angles.r
		end

		CatmullRomCams.CL.TunnelingTracer.start  = origin
		CatmullRomCams.CL.TunnelingTracer.endpos = origin-- + angles:Forward()

		return overrides
	end
	hook.Add("CalcView", "CatmullRomCams.CL.CalcViewOverride", CatmullRomCams.CL.CalcViewOverride)

	function CatmullRomCams.CL.HUDHide(element)
		local ply = LocalPlayer()

		if ply:GetNetVar("UnderControlCatmullRomCamera") and ply:GetNetVar("UnderControlCatmullRomCamera"):IsValid() then
			return false
		end
	end
	hook.Add("HUDShouldDraw", "CatmullRomCams.CL.HUDHide", CatmullRomCams.CL.HUDHide)

	function CatmullRomCams.CL.BlackenScreenDuringTunneling()
		local ply = LocalPlayer()

		if ply:GetNetVar("UnderControlCatmullRomCamera") and ply:GetNetVar("UnderControlCatmullRomCamera"):IsValid() then
			local tr = util.TraceLine(CatmullRomCams.CL.TunnelingTracer)

			if (tr.FractionLeftSolid == 1) then--and (tr.Entity == ents.GetByIndex(0)) then
				surface.SetDrawColor(0, 0, 0, 255)
				surface.DrawRect(0, 0, ScrW(), ScrH())
			end

			//return true
		end
	end
	hook.Add("RenderScreenspaceEffects", "CatmullRomCams.CL.BlackenScreenDuringTunneling", CatmullRomCams.CL.BlackenScreenDuringTunneling)
else
	function CatmullRomCams.SH.Toggle(sid, ent, idx, buttoned)
		local ply = player.GetBySteamID(sid)
		if ent and ply and ply.IsPlayer and ent.IsValid and ply:IsPlayer() and ent:IsValid() and (ent:GetClass() == "sent_catmullrom_camera") then
			return ent:Toggle(ply)
		end
	end
	numpad.Register("CatmullRomCamera_Toggle", CatmullRomCams.SH.Toggle)

	function CatmullRomCams.SH.GravGunPuntStopper(ply, ent)
		if ent and ent.IsValid and ent:IsValid() and (ent:GetClass() == "sent_catmullrom_camera") then
			return false
		end
	end
	hook.Add("GravGunPunt", "CatmullRomCams.SH.GravGunPuntStopper", CatmullRomCams.SH.GravGunPuntStopper)
end
