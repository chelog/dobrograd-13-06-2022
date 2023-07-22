ENT.Type = "anim"
ENT.Base = "durgz_base"
ENT.PrintName = "Cigarette"
ENT.Category = "Drugs"
ENT.Nicknames = {"wimpy cigars", "cigarettes"}
ENT.OverdosePhrase = {"got cancer from"}
ENT.Author = "John Siler"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Information	 = "This stuff makes you look badass."

ENT.TRANSITION_TIME = 4

--function for high visuals

if(CLIENT)then

	killicon.Add("durgz_cigarette","killicons/durgz_cigarette_killicon",Color( 255, 80, 0, 255 ))
	local TRANSITION_TIME = ENT.TRANSITION_TIME; --transition effect from sober to high, high to sober, in seconds how long it will take etc.


	local function DoCigarette()
		if(!DURGZ_LOST_VIRGINITY)then return; end
		local pl = LocalPlayer();



		if( pl:GetNetVar("durgz_cigarette_high_start", 0) && pl:GetNetVar("durgz_cigarette_high_end", 0) > CurTime() )then

			local pf = 1;


			if( pl:GetNetVar("durgz_cigarette_high_start", 0) + TRANSITION_TIME > CurTime() )then

				local s = pl:GetNetVar("durgz_cigarette_high_start", 0);
				local e = s + TRANSITION_TIME;
				local c = CurTime();
				pf = (c-s) / (e-s);
			elseif( pl:GetNetVar("durgz_cigarette_high_end", 0) - TRANSITION_TIME < CurTime() )then

				local e = pl:GetNetVar("durgz_cigarette_high_end", 0);
				local s = e - TRANSITION_TIME;
				local c = CurTime();
				pf = 1 - (c-s) / (e-s);
			end

			local a = pf*255;
			local say = "You smoke. Therefore you are cool."
			draw.DrawText(say, DURGZ_HUD_FONT, ScrW() / 2+1 , ScrH()*0.6+1, Color(255,255,255,a),TEXT_ALIGN_CENTER)
			draw.DrawText(say, DURGZ_HUD_FONT, ScrW() / 2-1 , ScrH()*0.6-1, Color(255,255,255,a),TEXT_ALIGN_CENTER)
			draw.DrawText(say, DURGZ_HUD_FONT, ScrW() / 2-1 , ScrH()*0.6+1, Color(255,255,255,a),TEXT_ALIGN_CENTER)
			draw.DrawText(say, DURGZ_HUD_FONT, ScrW() / 2+1 , ScrH()*0.6-1, Color(255,255,255,a),TEXT_ALIGN_CENTER)
			draw.DrawText(say, DURGZ_HUD_FONT, ScrW() / 2 , ScrH()*0.6, Color(255,9,9,255),TEXT_ALIGN_CENTER)
		end
	end
	hook.Add("HUDPaint", "durgz_cigarette_msg", DoCigarette)



	local TRANSITION_TIME = ENT.TRANSITION_TIME; --transition effect from sober to high, high to sober, in seconds how long it will take etc.

	local function DoCigarettePP()
		if(!DURGZ_LOST_VIRGINITY)then return; end
		--self:SetNetVar( "SprintSpeed"
		local pl = LocalPlayer();



		if( pl:GetNetVar("durgz_cigarette_high_start", 0) && pl:GetNetVar("durgz_cigarette_high_end", 0) > CurTime() )then

			if( pl:GetNetVar("durgz_cigarette_high_start", 0) + TRANSITION_TIME > CurTime() )then

				local s = pl:GetNetVar("durgz_cigarette_high_start", 0);
				local e = s + TRANSITION_TIME;
				local c = CurTime();
				local pf = (c-s) / (e-s);

				//DrawBloom( 0.65, pf*5, 0.40, 0.40, 1, 1, 255, 255, 255 )
				DrawSharpen(pf,1)

			elseif( pl:GetNetVar("durgz_cigarette_high_end", 0) - TRANSITION_TIME < CurTime() )then

				local e = pl:GetNetVar("durgz_cigarette_high_end", 0);
				local s = e - TRANSITION_TIME;
				local c = CurTime();
				local pf = 1 - (c-s) / (e-s);

				//DrawBloom( 0.65, pf*5, 0.40, 0.40, 1, 1, 255, 255, 255 )
				DrawSharpen(pf,1)

			else

				//DrawBloom(0.65, 5, 0.40, 0.40, 1, 1, 255,255,255)
				DrawSharpen(1,1)

			end


		end
	end
	hook.Add("RenderScreenspaceEffects", "durgz_cigarette_high", DoCigarettePP)

end
