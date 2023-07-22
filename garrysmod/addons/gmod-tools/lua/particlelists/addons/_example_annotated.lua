"EffectList"
{



	//At the beginning of the file is an Info table that gives the tool some information it needs - 
	//what to name the category, which effects should attach to two points, which effects should show the color selector, and that sort of thing.

	"Info"
	{
		//This is the name of the category that all of your particle lists will get dropped into
		"CategoryName" "Example Category"
	
		"EffectOptions"
		{
			//List of effects that should be attached to two separate points, like beams or bullet tracers, by moving the first two controlpoints (0 and 1 in the particle editor)
			"Beams"
			"
			electricity_yellow
			electricity_white
			custombulleteffect01
			custombulleteffect01a
			custombulleteffect02
			custombulleteffect02a
			laserbeam_colorable01
			laserbeam_colorable01a
			laserbeam_colorable01b
			!UTILEFFECT!internalname
			"

			//Not every effect is colorable - these two lists are for effects that you've designed to be colorable by linking the particle color to the location of a controlpoint
			//(util effects aren't colorable, don't add them to these lists)

			//Colorable effects that use a color value out of 1 - i.e. light red should move the color controlpoint(s) to (1 0.5 0.5).
			"Color1"
			"
			flame_colorable
			"

			//Colorable effects that use a color value out of 255 - i.e. light red should move the color controlpoint(s) to (255 127 127).
			"Color255"
			"
			laserbeam_colorable01
			laserbeam_colorable01a
			laserbeam_colorable01b
			"

			//List of effects that should be available in the Tracer tool's browser. Generally, any 'beam' effect will also work as a tracer effect, 
			//but you should probably avoid adding big, flashy, or permanent effects that you don't want players to be spamming a whole bunch of.
			"Tracers"
			"
			electricity_yellow
			electricity_white
			custombulleteffect01
			custombulleteffect01a
			custombulleteffect02
			custombulleteffect02a
			laserbeam_colorable01
			laserbeam_colorable01a
			laserbeam_colorable01b
			!UTILEFFECT!internalname
			"
		}

		//This next table is used to add a separate "Scripted Effects" list, used for Lua scripted effects (NOT .pcf effects) that should be played with the util.Effect() function.
		//If you only want to add .pcf effects, you can safely remove this table.
		//Even though these are different from .pcf effects, they should still be added to the Beams or Tracer list if you want the tool to use that feature.
		"UtilEffects"
		{
			"Display Name"		"!UTILEFFECT!internalname"   //remember to add the !UTILEFFECT! flag to the beginning
		}
	}



//After the Info table are your particle lists - the format is just a string with the name of your .pcf file (this'll get game.AddParticles()'d by the addon),
//and then another string, containing all the effect names in the list, with one name per line.
//You don't need to indent these if you don't want to - keeping it all like this makes it a lot easier to copy-paste in big lists of particle names.

//NOTE: Due to a limitation with GMod's keyvalue-reading function, the game stops reading these list strings after 4095 characters. To get around this, you can add a continuation by adding 
//another list with the the same name, followed by _cont (and then anything else after that, so you can have multiple continuations for the same list), and the addon will stitch them 
//together automatically when reading the file. For example, if "particle_file.pcf" has gotten too big, you can continue it in another list called "particle_file.pcf_cont1".
//This works for the list strings inside of the EffectOptions table, too - just put the continuations inside of the EffectOptions table as well.

//Remember to check the console when you're testing out your particle list - it'll tell you if there were any problems reading the file, and if any of your lists need to be split up.

"example_particle_file.pcf"
"
effect_1
effect_two
effect_the_third_one
another_dang_effect
etc
effects with spaces in their names work too
//you can comment effects out by putting two slashes in front of them
yet_another_effect //you can also add comments after them, it'll ignore everything on that line after the two slashes
"



"whoa_more_particles.pcf"
"
flame01
flame02
flame02_a
flame_colorable
bigexplosion01
electricity_yellow
electricity_white
custombulleteffect01
custombulleteffect01a
custombulleteffect02
custombulleteffect02a
laserbeam_colorable01
laserbeam_colorable01a
laserbeam_colorable01b
"



"you_get_the_idea.pcf"
"
rain_ambient_01
rain_ambient_02
im_gonna_stop_making_up_effect_names_now
"



}