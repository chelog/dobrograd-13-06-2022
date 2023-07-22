















--SERVER HOSTERS: Delete the lineeeee below if you don't want to make people have to download the DurgzMod models (or just put // in front of local).
local DURGZ_ADD_FILES = true;
--Remove the two slashes from the line below if you want the people joining your server the download that HUGE happy face that goes across your screen when you take mushrooms. This is NOT reccommended because the file is really big and it would probably add a good 1-2 minutes to the delay the person joining.
local ADD_AWESOME_FACE = true;
--Delete the line below if you don't want to make people have to download the spawn icons. (or just put // in front of local).
local ADD_SPAWN_ICONS = true;
--Delete the line below if you don't want to make people download sounds (or comment out with // or --).
local ADD_SOUNDS = true;



















--Ignore this stuff if you don't Lua code.


local function AddSIcon(materials)
	for k,v in pairs(materials)do
		resource.AddFile("materials/vgui/entities/"..v..".vmt");
		resource.AddFile("materials/vgui/entities/"..v..".vtf");
	end
end

local function r(materials, models)
	if(materials)then
		for k,v in pairs(materials)do
			resource.AddFile("materials/"..v);
		end
	end
	if(models)then
		for k,v in pairs(models)do
			resource.AddFile("models/"..v);
		end
	end
end

local function syringeMats(mats)
	for k,v in pairs(mats)do
		resource.AddFile("materials/katharsmodels/syringe_out/syringe_"..v);
	end
end

local function addShib(mat, modl)
	for k,v in pairs(mat)do
		resource.AddFile("materials/models/shibboro/"..v..".vmt")
		resource.AddFile("materials/models/shibboro/"..v..".vtf")
	end
	
	for k,v in pairs(modl)do
		resource.AddFile("models/"..v..".mdl");
	end

end

local function addKillicon(mat)
	for k,v in pairs(mat)do
		resource.AddFile("materials/killicons/durgz_"..v.."_killicon.vmt");
		resource.AddFile("materials/killicons/durgz_"..v.."_killicon.vtf");
	end
end

local function AddFiles()
	syringeMats(
		{
			"body.vmt",
			"grip.vmt",
			"liquid.vmt",
			"lowerstopper.vmt",
			"needle.vmt",
			"stopper.vmt",
			"tip.vmt",
			"body.vtf",
			"body_mask.vtf",
			"grip.vtf",
			"liquid.vtf",
			"lowerstopper.vtf",
			"needle.vtf",
			"stopper.vtf",
			"tip.vtf"
		}
	)

	r(
		{
			/*"models/shibcoffee/Cup.vmt",
			"models/shibcoffee/Cup.vtf",
			"models/shibcoffee/CupHOLD.vmt",
			"models/shibcoffee/CupHOLD.vtf",
			"models/shibcoffee/Holder.vmt",
			"models/shibcoffee/Holder.vtf",*/
			"models/marioragdoll/Super Mario Galaxy/star/starSS01.vmt",
			"models/marioragdoll/Super Mario Galaxy/star/starSS01.vtf",
			"models/marioragdoll/Super Mario Galaxy/star/starSS06.vmt",
			"models/marioragdoll/Super Mario Galaxy/star/starSS06.vtf",
			"models/marioragdoll/Super Mario Galaxy/star/yellow.vmt",
			"models/marioragdoll/Super Mario Galaxy/star/yellow.vtf",
			/*"neodement/ecstasy_bx.vmt",
			"neodement/ecstasy_bx.vtf",
			"neodement/ecstasy_bx_flake.vmt",
			"neodement/ecstasy_bx_flake.vtf",*/
			"katharsmodels/contraband/contraband_normal.vtf",
			"katharsmodels/contraband/contraband_one.vmt",
			"katharsmodels/contraband/contraband_one.vtf",
			"katharsmodels/contraband/contraband_two.vmt",
			"ipha/mushd.vmt",
			"ipha/mushd.vtf",
			"models/drug/drug.vmt",
			"models/drug/drug.vtf",
			"models/druggg_mod/PopCan01a.vmt",
			"models/druggg_mod/PopCan01a.vtf",
			"jaanus/aspbtl_a.vmt",
			"jaanus/aspbtl_a.vtf",
			"jaanus/aspirin_.vtf",
			"jaanus/aspirin_.vmt",
			"models/drug/waterbottl/water_bottle.vmt",
			"models/drug/waterbottl/water_bottle.vtf",
			"models/drug/waterbottl/water_bottle_ref.vtf",
			"smile/smile.vmt",
			"smile/smile.vtf"
		},
		
		{
			"cocn.mdl",
			"shibcuppyhold.mdl",
			"ipha/mushroom_small.mdl",
			"drug_mod/alcohol_can.mdl",
			"drug_mod/the_bottle_of_water.mdl",
			"katharsmodels/contraband/zak_wiet/zak_wiet.mdl",
			"katharsmodels/syringe_out/syringe_out.mdl",
			"jaanus/aspbtl.mdl",
			"smile/smile.mdl",
			/*"drug_mod/ecstasy_crl.mdl",*/
			"marioragdoll/Super Mario Galaxy/star/star.mdl"
		}


	)


	addShib(
		{
			"cigsshib",
			"openyesshib"
		},
		
		{
			"boxopencigshib",
			"pissedmeoff"
		}
	)
	
	
	
end

local function AddFilesNoExceptions()
	if( ADD_SOUNDS ) then
		resource.AddFile("sound/drugs/insufflation.wav");	
	end

	if( ADD_AWESOME_FACE )then
		r({"vgui/durgzmod/awesomeface.vmt", "vgui/durgzmod/awesomeface.vtf"});
	end
	
	if( ADD_SPAWN_ICONS )then
		AddSIcon(
			{
				"durgz_cigarette",
				"durgz_cocaine",
				"durgz_weed",
				"durgz_lsd",
				"durgz_mushroom",
				"durgz_heroine",
				"durgz_water",
				"durgz_aspirin",
				/*"durgz_caffeine",
				"durgz_ecstasy",*/
				"durgz_meth",
				"durgz_pcp",
				"durgz_alcohol"//,
				//"durgz_opium"
			}
		)
	end
	
	AddSIcon({"weapon_durgz"});
	
	r(
		{
			"highs/shader3.vtf",
			"highs/shader3.vmt",
			"highs/shader3_dudv.vtf",
			"highs/shader3_dudv.vmt",
			"highs/shader3_normal.vtf",
			"highs/shader3_normal.vmt",
			//"highs/ecstasy_smile.vtf",
			//"highs/ecstasy_smile.vmt",
			"highs/invuln_overlay_normal.vtf",
			"highs/invuln_overlay_blue.vmt",
			"highs/invulnoverlay/invuln_overlay.vtf",
		}
	)
	
	
		local drugs = {
			"weed",
			"cocaine",
			"cigarette",
			"alcohol",
			"mushroom",
			"meth",
			/*"ecstasy",
			"caffeine",*/
			"pcp",
			"lsd"//,
			//"opium"
		}
		addKillicon(drugs)
	
end

if( DURGZ_ADD_FILES )then
	AddFiles()
end
AddFilesNoExceptions()
-- game.ConsoleCommand("sv_tags durgzmod2.2\n")  