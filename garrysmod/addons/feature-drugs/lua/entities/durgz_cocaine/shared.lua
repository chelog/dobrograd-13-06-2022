ENT.Type = "anim"
ENT.Base = "durgz_base"
ENT.PrintName = "Cocaine"
ENT.Nicknames = {"coke", "cocaine", "candy cane", "the big C"}
ENT.OverdosePhrase = {"overdosed on", "snorted too much", "took too much"}
ENT.Author = "Arash Ansari"
ENT.Category = "Drugs"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Information	 = "Looks like sugar to me..."

--function for high visuals

ENT.TRANSITION_TIME = 5


if(CLIENT)then

	killicon.Add("durgz_cocaine","killicons/durgz_cocaine_killicon",Color( 255, 80, 0, 255 ))

	local cdw, cdw2, cdw3
	cdw2 = -1
	local TRANSITION_TIME = ENT.TRANSITION_TIME; --transition effect from sober to high, high to sober, in seconds how long it will take etc.
	local HIGH_INTENSITY = 0.8; --1 is max, 0 is nothing at all
	local STROBE_PACE = 1

	local function DoCocaine()
		if(!DURGZ_LOST_VIRGINITY)then return; end
		--self:SetNetVar( "SprintSpeed"
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


		if( pl:GetNetVar("durgz_cocaine_high_start", 0) && pl:GetNetVar("durgz_cocaine_high_end", 0) > CurTime() )then

			if( pl:GetNetVar("durgz_cocaine_high_start", 0) + TRANSITION_TIME > CurTime() )then

				local s = pl:GetNetVar("durgz_cocaine_high_start", 0);
				local e = s + TRANSITION_TIME;
				local c = CurTime();
				pf = (c-s) / (e-s);

				pf = pf*HIGH_INTENSITY



			elseif( pl:GetNetVar("durgz_cocaine_high_end", 0) - TRANSITION_TIME < CurTime() )then

				local e = pl:GetNetVar("durgz_cocaine_high_end", 0);
				local s = e - TRANSITION_TIME;
				local c = CurTime();
				pf = 1 - (c-s) / (e-s);

				pf = pf*HIGH_INTENSITY

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

			DrawMaterialOverlay("highs/shader3",  pf*ich*0.05	)
			DrawSharpen(pf*ich*5, 2)

		end
	end
	hook.Add("RenderScreenspaceEffects", "durgz_cocaine_high", DoCocaine)
end
