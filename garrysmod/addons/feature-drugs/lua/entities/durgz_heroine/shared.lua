--I know the folder "heroine" isn't right but I wanted the files to overwrite instead of having two files, heroine and heroin. So I just kept it as-is.


ENT.Type = "anim"
ENT.Base = "durgz_base"
ENT.PrintName = "Heroin"
ENT.Nicknames = {"heroin"}
ENT.OverdosePhrase = {"overdosed on", "injected too much", "took too much"}
ENT.Author = "I don't know anyone who has done Heroin."
ENT.Category = "Drugs"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Information	 = "Put this stuff in your arm."

--function for high visuals

ENT.TRANSITION_TIME = 5


if(CLIENT)then

	killicon.Add("durgz_heroine","killicons/durgz_heroine_killicon",Color( 255, 80, 0, 255 ))

	local cdw, cdw2, cdw3
	cdw2 = -1
	local TRANSITION_TIME = ENT.TRANSITION_TIME; --transition effect from sober to high, high to sober, in seconds how long it will take etc.
	local HIGH_INTENSITY = 0.8; --1 is max, 0 is nothing at all
	local STROBE_PACE_TOTAL = 1

	local tab = {}
	tab[ "$pp_colour_addg" ] = 0
	tab[ "$pp_colour_addb" ] = 0
	tab[ "$pp_colour_brightness" ] = 0
	tab[ "$pp_colour_contrast" ] = 1
	tab[ "$pp_colour_colour" ] = 1
	tab[ "$pp_colour_mulg" ] = 0
	tab[ "$pp_colour_mulb" ] = 0
	tab[ "$pp_colour_mulr" ] = 0

	local function DoHeroine()
		if(!DURGZ_LOST_VIRGINITY)then return; end
		--self:SetNetVar( "SprintSpeed"
		local pl = LocalPlayer();
		local pf;

		local STROBE_PACE = STROBE_PACE_TOTAL



		if( pl:GetNetVar("durgz_heroine_high_start", 0) && pl:GetNetVar("durgz_heroine_high_end", 0) > CurTime() )then




			if( pl:GetNetVar("durgz_heroine_high_start", 0) + TRANSITION_TIME > CurTime() )then

				local s = pl:GetNetVar("durgz_heroine_high_start", 0);
				local e = s + TRANSITION_TIME;
				local c = CurTime();
				pf = (c-s) / (e-s);

				pf = pf*HIGH_INTENSITY



			elseif( pl:GetNetVar("durgz_heroine_high_end", 0) - TRANSITION_TIME < CurTime() )then

				local e = pl:GetNetVar("durgz_heroine_high_end", 0);
				local s = e - TRANSITION_TIME;
				local c = CurTime();

				STROBE_PACE = 0.5

				pf = 1 - (c-s) / (e-s);

				pf = pf*HIGH_INTENSITY




			else

				pf = HIGH_INTENSITY;

			end



			if( !cdw || cdw < CurTime() )then
				cdw = CurTime() + STROBE_PACE;
				cdw2 = cdw2*-1;
			end
			if( cdw2 == -1 )then
				cdw3 = 2;
			else
				cdw3 = 0;
			end
			local ich = (cdw2*((cdw - CurTime())*(2/STROBE_PACE)))+cdw3 - 1;




			local gah = pf*(ich+1);
			tab[ "$pp_colour_addr" ] = gah	;

			DrawMaterialOverlay("highs/shader3",  pf*ich*0.05	);
			DrawColorModify(tab);

		end
	end
	hook.Add("RenderScreenspaceEffects", "durgz_heroine_high", DoHeroine)

	local cdww, cdww2, cdww3
	cdww2 = -1

	local STROBE_PACE_2 = 1;

	local function HeroinNotice()
		if(!DURGZ_LOST_VIRGINITY)then return; end
		local pl = LocalPlayer();
		if( pl:GetNetVar("durgz_heroine_high_end", 0) && pl:GetNetVar("durgz_heroine_high_start", 0) != 0 && pl:GetNetVar("durgz_heroine_high_end", 0) > CurTime() && pl:GetNetVar("durgz_heroine_high_end", 0) - TRANSITION_TIME < CurTime() )then


			if !cdww || cdww < CurTime() then
				cdww = CurTime() + STROBE_PACE_2
				cdww2 = cdww2*-1
			end
			if cdww2 == -1 then
				cdww3 = 255
			else
				cdww3 = 0
			end
			local ich = (cdww2*((cdww - CurTime())*(255/STROBE_PACE_2)))+cdww3
			local say = "You need more heroin";



			draw.SimpleText( say, DURGZ_HUD_FONT, ScrW()/2, ScrH()*3/4, Color( 255, 255, 255, ich ), TEXT_ALIGN_CENTER )
			draw.SimpleText( say, DURGZ_HUD_FONT, ScrW()/2+1, ScrH()*3/4+1, Color( 0, 0, 0, ich ), TEXT_ALIGN_CENTER )

		end
	end
	hook.Add("HUDPaint", "durgz_heroine_notice", HeroinNotice);
end
