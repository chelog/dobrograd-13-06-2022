ENT.Type = "anim"
ENT.Base = "durgz_base"
ENT.PrintName = "Methamphetamine"
ENT.Nicknames = {"meth", "ice", "speed", "crystal", "tweak", "crank", "glass", "Blue Sky", "Desoxyn® Sisa"}
ENT.OverdosePhrase = {"overdosed on", "snorted too much", "took too much"}
ENT.Author = "metasync :D"
ENT.Category = "Drugs"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Information	 = "<breaking bad reference goes here>"

--function for high visuals

ENT.TRANSITION_TIME = 5


if(CLIENT)then

	killicon.Add("durgz_meth","killicons/durgz_meth_killicon",Color( 255, 80, 0, 255 ))

	local cdw, cdw2, cdw3
	cdw2 = -1
	local TRANSITION_TIME = ENT.TRANSITION_TIME; --transition effect from sober to high, high to sober, in seconds how long it will take etc.
	local HIGH_INTENSITY = 0.8; --1 is max, 0 is nothing at all
	local STROBE_PACE = 1

	local function DoMeth()
		if(!DURGZ_LOST_VIRGINITY)then return; end
		--self:SetNetVar( "SprintSpeed" )
		local pl = LocalPlayer();
		local pf;

		local tab = {}
		tab[ "$pp_colour_addr" ] = 0
		tab[ "$pp_colour_addg" ] = 0
		tab[ "$pp_colour_addb" ] = 0
		tab[ "$pp_colour_brightness" ] = 0
		tab[ "$pp_colour_contrast" ] = 1
		tab[ "$pp_colour_mulr" ] = 0
		tab[ "$pp_colour_mulg" ] = 0
		tab[ "$pp_colour_mulb" ] = 0


		if( pl:GetNetVar("durgz_meth_high_start", 0) && pl:GetNetVar("durgz_meth_high_end", 0) > CurTime() )then

			if( pl:GetNetVar("durgz_meth_high_start", 0) + TRANSITION_TIME > CurTime() )then

				local s = pl:GetNetVar("durgz_meth_high_start", 0);
				local e = s + TRANSITION_TIME;
				local c = CurTime();
				pf = (c-s) / (e-s);

				pf = pf*HIGH_INTENSITY

				pl:SetDSP(7)

				tab[ "$pp_colour_colour" ] =   1 - pf/0.3 //pf*4*HIGH_INTENSITY + 1
				tab[ "$pp_colour_brightness" ] = -pf/0.11
				tab[ "$pp_colour_contrast" ] = 1 + pf/1.62
				DrawMotionBlur( 0.03, pf, 0);
				DrawColorModify( tab )

			elseif( pl:GetNetVar("durgz_meth_high_end", 0) - TRANSITION_TIME < CurTime() )then

				local e = pl:GetNetVar("durgz_meth_high_end", 0);
				local s = e - TRANSITION_TIME;
				local c = CurTime();
				pf = 1 - (c-s) / (e-s);

				pf = pf*HIGH_INTENSITY

				tab[ "$pp_colour_colour" ] = 1 - pf/0.3
				tab[ "$pp_colour_brightness" ] = -pf/0.11
				tab[ "$pp_colour_contrast" ] = 1 + pf/1.62
				DrawMotionBlur( 0.03, pf, 0);
				DrawColorModify( tab )

				pl:SetDSP(1)

			else


				pf = HIGH_INTENSITY;

			end



			if( !cdw || cdw < CurTime() )then
				cdw = CurTime() + STROBE_PACE
				cdw2 = cdw2*-1
			end
			if( cdw2 == -1 )then
				cdw3 = 2
			else
				cdw3 = 0
			end
			local ich = (cdw2*((cdw - CurTime())*(2/STROBE_PACE)))+cdw3 - 1

			tab[ "$pp_colour_colour" ] = 0.77/2//5*HIGH_INTENSITY
			tab[ "$pp_colour_brightness" ] = -0.11/2
			tab[ "$pp_colour_contrast" ] = 2.62/2
			DrawMotionBlur( 0.03, pf, 0);
			DrawColorModify( tab )

			DrawMaterialOverlay("highs/invuln_overlay_blue",  pf*ich*0.05	)
			DrawMaterialOverlay("highs/shader3",  pf*ich*0.05	)
			DrawSharpen(pf*ich*5, 2)

		end
	end
	hook.Add("RenderScreenspaceEffects", "durgz_meth_high", DoMeth)
end
