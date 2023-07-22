ENT.Type = "anim"
ENT.Base = "durgz_base"
ENT.PrintName = "PCP"
ENT.Nicknames = {"PCP"}
ENT.OverdosePhrase = {"overdosed on", "was like \"HOLY SHIT I THINK I CAN PUNCH THROUGH THIS WALL WITH MY DICK GUYS CHECK ME OUT\" while on" }
ENT.Author = "Jared DeVries"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Information	 = "GODLIKE!!!"
ENT.Category = "Drugs"
ENT.TRANSITION_TIME = 3

--function for high visuals

if(CLIENT)then

	killicon.Add("durgz_pcp","killicons/durgz_pcp_killicon",Color( 255, 80, 0, 255 ))

	local TRANSITION_TIME = ENT.TRANSITION_TIME; --transition effect from sober to high, high to sober, in seconds how long it will take etc.
	local HIGH_INTENSITY = 0.77; --1 is max, 0 is nothing at all


	local function DoPCP()
		if(!DURGZ_LOST_VIRGINITY)then return end

		local pl = LocalPlayer();

		local tab = {}
		tab[ "$pp_colour_addr" ] = 0
		tab[ "$pp_colour_addg" ] = 0
		tab[ "$pp_colour_addb" ] = 0
		tab[ "$pp_colour_brightness" ] = 0
		tab[ "$pp_colour_contrast" ] = 1
		tab[ "$pp_colour_colour" ] = 1
		tab[ "$pp_colour_mulr" ] = 0
		tab[ "$pp_colour_mulg" ] = 0
		tab[ "$pp_colour_mulb" ] = 0


		if( pl:GetNetVar("durgz_pcp_high_start", 0) && pl:GetNetVar("durgz_pcp_high_end", 0) > CurTime() )then

			  local pf = 1;

			if( pl:GetNetVar("durgz_pcp_high_start", 0) + TRANSITION_TIME > CurTime() )then

				local s = pl:GetNetVar("durgz_pcp_high_start", 0);
				local e = s + TRANSITION_TIME;
				local c = CurTime();
				pf = (c-s) / (e-s);

			elseif( pl:GetNetVar("durgz_pcp_high_end", 0) - TRANSITION_TIME < CurTime() )then

				local e = pl:GetNetVar("durgz_pcp_high_end", 0);
				local s = e - TRANSITION_TIME;
				local c = CurTime();
				pf = 1 - (c-s) / (e-s);

			end

				tab[ "$pp_colour_addr" ] = pf*math.random(0,1);
				tab[ "$pp_colour_addg" ] = pf*math.random(0,1);
				tab[ "$pp_colour_addb" ] = pf*math.random(0,1);
				DrawColorModify(tab);
		end
	end

	hook.Add("RenderScreenspaceEffects", "durgz_pcp_high", DoPCP)
end
