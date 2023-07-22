ENT.Type = "anim"
ENT.Base = "durgz_base"
ENT.PrintName = "Mushroom"
ENT.Nicknames = {"'shrooms", "magic mushrooms", "mushrooms", "Psilocybin", "Psilocin", "the greatest drug on earth", "lysol", "Eminem's drug of choice"}
ENT.OverdosePhrase = {"ate too many", "consumed a lot of"}
ENT.Author = "Matt Malone"
ENT.Category = "Drugs"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Information	 = "*Insert mario reference here*"

ENT.TRANSITION_TIME = 6

--function for high visuals

if(CLIENT)then

	killicon.Add("durgz_mushroom","killicons/durgz_mushroom_killicon",Color( 255, 80, 0, 255 ))

	local MOVE_FACE_DOWN = 0;
	local MOVE_FACE_UP = 1;
	local MOVE_FACE_LEFT = 2;
	local MOVE_FACE_RIGHT = 3;

	local TRANSITION_TIME = ENT.TRANSITION_TIME; --transition effect from sober to high, high to sober, in seconds how long it will take etc.
	local HIGH_INTENSITY = 0.77; --1 is max, 0 is nothing at all
	local TIME_TO_GO_ACROSS_SCREEN = 3;
	local whichWay = 2;
	local startawesomefacemove = 0;

	local function DoMushrooms()
		if(!DURGZ_LOST_VIRGINITY)then return; end
		--self:SetNetVar( "SprintSpeed"
		local pl = LocalPlayer();


		local shroom_tab = {}
		shroom_tab[ "$pp_colour_addr" ] = 0
		shroom_tab[ "$pp_colour_addg" ] = 0
		shroom_tab[ "$pp_colour_addb" ] = 0
		//shroom_tab[ "$pp_colour_brightness" ] = 0
		//shroom_tab[ "$pp_colour_contrast" ] = 1
		shroom_tab[ "$pp_colour_mulr" ] = 0
		shroom_tab[ "$pp_colour_mulg" ] = 0
		shroom_tab[ "$pp_colour_mulb" ] = 0


		if( pl:GetNetVar("durgz_mushroom_high_start", 0) && pl:GetNetVar("durgz_mushroom_high_end", 0) > CurTime() )then

			if( pl:GetNetVar("durgz_mushroom_high_start", 0) + TRANSITION_TIME > CurTime() )then

				local s = pl:GetNetVar("durgz_mushroom_high_start", 0);
				local e = s + TRANSITION_TIME;
				local c = CurTime();
				local pf = (c-s) / (e-s);

				shroom_tab[ "$pp_colour_colour" ] =   1 - pf*0.37
				shroom_tab[ "$pp_colour_brightness" ] = -pf*0.15
				shroom_tab[ "$pp_colour_contrast" ] = 1 + pf*1.57
				//DrawMotionBlur( 1 - 0.18*pf, 1, 0);
				DrawColorModify( shroom_tab )
				DrawSharpen( 8.32,1.03*pf )

			elseif( pl:GetNetVar("durgz_mushroom_high_end", 0) - TRANSITION_TIME < CurTime() )then

				local e = pl:GetNetVar("durgz_mushroom_high_end", 0);
				local s = e - TRANSITION_TIME;
				local c = CurTime();
				local pf = 1 - (c-s) / (e-s);

				shroom_tab[ "$pp_colour_colour" ] = 1 - pf*0.37
				shroom_tab[ "$pp_colour_brightness" ] = -pf*0.15
				shroom_tab[ "$pp_colour_contrast" ] = 1 + pf*1.57
				//DrawMotionBlur( 1 - 0.18*pf, 1, 0);
				DrawColorModify( shroom_tab )
				DrawSharpen( 8.32,1.03*pf )

			else

				shroom_tab[ "$pp_colour_colour" ] = 0.63
				shroom_tab[ "$pp_colour_brightness" ] = -0.15
				shroom_tab[ "$pp_colour_contrast" ] = 2.57
				//DrawMotionBlur( 0.82, 1, 0);
				DrawColorModify( shroom_tab )
				DrawSharpen( 8.32,1.03 )

			end


		end
	end
	local function DoMushroomsFace()
		if(!DURGZ_LOST_VIRGINITY)then return; end
		local pl = LocalPlayer();
		if( file.Exists("../materials/VGUI/durgzmod/awesomeface.vmt","GAME") && pl:GetNetVar("durgz_mushroom_high_start", 0) && pl:GetNetVar("durgz_mushroom_high_end", 0) > CurTime() )then
			local pf = 1;
			if( pl:GetNetVar("durgz_mushroom_high_start", 0) + TRANSITION_TIME > CurTime() )then

				local s = pl:GetNetVar("durgz_mushroom_high_start", 0);
				local e = s + TRANSITION_TIME;
				local c = CurTime();
				pf = (c-s) / (e-s);

			elseif( pl:GetNetVar("durgz_mushroom_high_end", 0) - TRANSITION_TIME < CurTime() )then

				local e = pl:GetNetVar("durgz_mushroom_high_end", 0);
				local s = e - TRANSITION_TIME;
				local c = CurTime();
				pf = 1 - (c-s) / (e-s);

			end


			if( startawesomefacemove + TIME_TO_GO_ACROSS_SCREEN < CurTime() )then
				startawesomefacemove = CurTime();
				whichWay = math.random(0,3);
			end


			local pfscr = (CurTime() - startawesomefacemove) / TIME_TO_GO_ACROSS_SCREEN;

			local ScrH = ScrH()

			local x, y;
			if( whichWay == MOVE_FACE_DOWN )then
				x = (ScrW() - ScrH)/2
				y = (2*pfscr-1)*ScrH
			elseif( whichWay == MOVE_FACE_LEFT )then
				x = (1-2*pfscr)*ScrW()
				y = 0;
			elseif( whichWay == MOVE_FACE_UP )then
				x = (ScrW() - ScrH)/2
				y = (1-2*pfscr)*ScrH
			else
				x = (2*pfscr-1)*ScrW();
				y = 0;
			end
			surface.SetTexture(surface.GetTextureID("VGUI/durgzmod/awesomeface"))
			surface.SetDrawColor(255, 255, 255, pf*180)
			surface.DrawTexturedRect(x, y, ScrH, ScrH) --gets your screen resolution
		end
	end
	hook.Add("RenderScreenspaceEffects", "durgz_mushroom_high", DoMushrooms)
	hook.Add("HUDPaint", "durgz_mushroom_awesomeface", DoMushroomsFace)

end




/*




Motion Blur
	add: 0.82 (default 1)
	draw: 1
	delay: 0
Color Mod
	bright: -0.21
	contrast: 2.57
	color mul: 0.37
Sharpen
	distance: 1.03 (default 0)
	contrast: 8.32




*/
