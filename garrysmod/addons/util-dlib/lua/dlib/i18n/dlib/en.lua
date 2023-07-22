
-- Copyright (C) 2018-2020 DBotThePony

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do so,
-- subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all copies
-- or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
-- DEALINGS IN THE SOFTWARE.


gui.misc.apply = 'Apply'
gui.misc.ok = 'OK'
gui.misc.cancel = 'Cancel'
gui.misc.yes = 'Yes'
gui.misc.no = 'No'

gui.entry.invalidsymbol = 'Symbol is not allowed.'
gui.entry.limit = 'Field limit exceeded.'

gui.dlib.hudcommons.reset = 'Reset'

gui.dlib.colormixer.palette = 'Palette'
gui.dlib.colormixer.save_color = 'Save current color into this square'
gui.dlib.colormixer.reset_palette = 'Reset palette'
gui.dlib.colormixer.reset_palette_confirm = 'Really?'
gui.dlib.colormixer.palette_window = 'Palette window'
gui.dlib.colormixer.palette_regular = 'Regular palette'
gui.dlib.colormixer.palette_extended = 'Extended palette'
gui.dlib.colormixer.copy_color = 'Copy color in RGB format'
gui.dlib.colormixer.copy_hex_color = 'Copy color in HEX format'

info.dlib.tformat.seconds = 'seconds'
info.dlib.tformat.minutes = 'minutes'
info.dlib.tformat.hours = 'hours'
info.dlib.tformat.days = 'days'
info.dlib.tformat.weeks = 'weeks'
info.dlib.tformat.months = 'months'
info.dlib.tformat.years = 'years'
info.dlib.tformat.centuries = 'centuries'

info.dlib.tformat.long = 'Never™'
info.dlib.tformat.now = 'Right now'
info.dlib.tformat.past = 'The past'

local function define(from, to, target, form1, form2)
	for i = from, to do
		local div = i % 10

		if div == 1 and i ~= 11 then
			target[tostring(i)] = i .. ' ' .. form1
		else -- when you encounter that english is way too simple
			target[tostring(i)] = i .. ' ' .. form2
		end
	end
end

for _, thing in ipairs({info.dlib.tformat.countable, info.dlib.tformat.countable_ago}) do
	define(1, 60, thing.second, 'second', 'seconds')
	define(1, 60, thing.minute, 'minute', 'minutes')
	define(1, 24, thing.hour, 'hour', 'hours')
	define(1, 7, thing.day, 'day', 'days')
	define(1, 4, thing.week, 'week', 'weeks')
	define(1, 12, thing.month, 'month', 'months')
	define(1, 100, thing.year, 'year', 'years')
	define(1, 100, thing.century, 'century', 'centuries')
end

info.dlib.tformat.ago = '%s ago'
info.dlib.tformat.ago_inv = '%s in future'

gui.dlib.friends.title = 'DLib Friends'
gui.dlib.friends.open = 'Open Friends Menu'

gui.dlib.friends.edit.add_title = 'Adding %s <%s> as friend'
gui.dlib.friends.edit.edit_title = 'Editing %s <%s> friend settings'
gui.dlib.friends.edit.going = 'You are going to be a friend with %s in...'
gui.dlib.friends.edit.youare = 'You are friend with %s in...'
gui.dlib.friends.edit.remove = 'Remove friend'

gui.dlib.friends.invalid.title = 'Invalid SteamID'
gui.dlib.friends.invalid.ok = 'Okay :('
gui.dlib.friends.invalid.desc = '%q doesnt look like valid steamid!'

gui.dlib.friends.settings.steam = 'Consider Steam friends as DLib friends'
gui.dlib.friends.settings.your = 'Your friends ->'
gui.dlib.friends.settings.server = 'Server players ->'

gui.dlib.friends.settings.foreign = '[Foreign] '

gui.dlib.donate.top = 'DLib: Make a donation?'
gui.dlib.donate.button.yes = 'Make a donation!'
gui.dlib.donate.button.paypal = 'Make a donation, but on PayPal!'
gui.dlib.donate.button.no = 'Ask me later'
gui.dlib.donate.button.never = 'Never ask again'
gui.dlib.donate.button.learnabout = 'Read about "Donationware"...'
gui.dlib.donate.button.learnabout_url = 'https://en.wikipedia.org/wiki/Donationware'

message.dlib.hudcommons.edit.notice = 'Press ESC to close the editor'

gui.dlib.donate.text = [[Hello there! I see you were AFK for a long time (if you slept all these time, good morning... or whatever),
but so, if you are awake, i want to ask you: Can you please make a dontation?
DLib and all official addons on top of it are Donationware!
Just a bit of donation! Even if you can only give 1$ or 1€, thats great if you would ask! Just imagine:
If everyone who is subscribed to my addons will donate money for a cup of tea it will be enough to cover
all my parent's credits. It could also help a lot to my mother who spend entire days on her job.
Currently, the only thing i do is developing these free addons just for you!
Just for community! For free and it is even open source with easy way of contribution! If you could just
make a small donation you will support next addons:
DLib%s]]

gui.dlib.donate.more = ' and %i more addons!..'

gui.dlib.hudcommons.positions = '%s positions'
gui.dlib.hudcommons.fonts = '%s fonts'
gui.dlib.hudcommons.colors = '%s colors'
gui.dlib.hudcommons.font = 'Font'
gui.dlib.hudcommons.font_label = 'Settings for %s'
gui.dlib.hudcommons.save_hint = 'Don\'t forget to host_writeconfig in\nconsole after you did all your changes!'
gui.dlib.hudcommons.weight = 'Weight'
gui.dlib.hudcommons.size = 'Size'

gui.dlib.notify.families_loading = 'Expect lag, DLib is baking a cake\n(searching for installed font families)'

-- yotta    Y    10008      1024   1000000000000000000000000    septillion      quadrillion    1991
-- zetta    Z    10007      1021   1000000000000000000000   sextillion      trilliard  1991
-- exa      E    10006      1018   1000000000000000000      quintillion     trillion   1975
-- peta     P    10005      1015   1000000000000000     quadrillion     billiard   1975
-- tera     T    10004      1012   1000000000000    trillion    billion    1960
-- giga     G    10003      109    1000000000   billion     milliard   1960
-- mega     M    10002      106    1000000      million    1873
-- kilo     k    10001      103    1000     thousand   1795
-- hecto    h    10002/3     102    100      hundred    1795
-- deca     da   10001/3     101    10   ten    1795

-- deci     d    1000−1/3    10−1   0.1      tenth  1795
-- centi    c    1000−2/3    10−2   0.01     hundredth  1795
-- milli    m    1000−1      10−3   0.001    thousandth     1795
-- micro    μ    1000−2      10−6   0.000001     millionth  1873
-- nano     n    1000−3      10−9   0.000000001      billionth   milliardth     1960
-- pico     p    1000−4      10−12  0.000000000001   trillionth      billionth  1960
-- femto    f    1000−5      10−15  0.000000000000001    quadrillionth   billiardth (Proposed)  1964
-- atto     a    1000−6      10−18  0.000000000000000001     quintillionth   trillionth     1964
-- zepto    z    1000−7      10−21  0.000000000000000000001      sextillionth    trilliardth    1991
-- yocto    y    1000−8      10−24  0.000000000000000000000001   septillionth    quadrillionth  1991

local prefix = {
	{'yocto', 'y'},
	{'zepto', 'z'},
	{'atto', 'a'},
	{'femto', 'f'},
	{'pico', 'p'},
	{'nano', 'n'},
	{'micro', 'μ'},
	{'milli', 'm'},
	{'centi', 'c'},
	{'deci', 'd'},
	{'kilo', 'k'},
	{'mega', 'M'},
	{'giga', 'G'},
	{'tera', 'T'},
	{'peta', 'P'},
	{'exa', 'E'},
	{'zetta', 'Z'},
	{'yotta', 'Y'},
}

local units = [[hertz    Hz  frequency   1/s     s−1
radian   rad     angle   m/m     1
steradian    sr  solid angle     m2/m2   1
newton   N   force, weight   kg⋅m/s2     kg⋅m⋅s−2
pascal   Pa  pressure, stress    N/m2    kg⋅m−1⋅s−2
joule    J   energy, work, heat  N⋅m, C⋅V, W⋅s   kg⋅m2⋅s−2
watt     W   power, radiant flux     J/s, V⋅A    kg⋅m2⋅s−3
coulomb  C   electric charge or quantity of electricity  s⋅A, F⋅V    s⋅A
volt     V   voltage, electrical potential difference, electromotive force   W/A, J/C    kg⋅m2⋅s−3⋅A−1
farad    F   electrical capacitance  C/V, s/Ω    kg−1⋅m−2⋅s4⋅A2
ohm  Ω   electrical resistance, impedance, reactance     1/S, V/A    kg⋅m2⋅s−3⋅A−2
siemens  S   electrical conductance  1/Ω, A/V    kg−1⋅m−2⋅s3⋅A2
weber    Wb  magnetic flux   J/A, T⋅m2   kg⋅m2⋅s−2⋅A−1
tesla    T   magnetic induction, magnetic flux density   V⋅s/m2, Wb/m2, N/(A⋅m)  kg⋅s−2⋅A−1
henry    H   electrical inductance   V⋅s/A, Ω⋅s, Wb/A    kg⋅m2⋅s−2⋅A−2
degree Celsius   °C  temperature relative to 273.15 K    K   K
lumen    lm  luminous flux   cd⋅sr   cd
lux  lx  illuminance     lm/m2   cd⋅sr/m2
becquerel    Bq  radioactivity (decays per unit time)    1/s     s−1
gray     Gy  absorbed dose (of ionizing radiation)   J/kg    m2⋅s−2
sievert  Sv  equivalent dose (of ionizing radiation)     J/kg    m2⋅s−2
katal    kat     catalytic activity  mol/s   s−1⋅mol]]

for i, row in ipairs(prefix) do
	info.dlib.si.prefix[row[1]].name = row[3] or row[1]:formatname()
	info.dlib.si.prefix[row[1]].prefix = row[2]
end

for i, row in ipairs(units:split('\n')) do
	local measure, NaM = row:match('(%S+)%s+(%S+)')

	if measure and NaM then
		info.dlib.si.units[measure].name = measure:formatname()
		info.dlib.si.units[measure].suffix = NaM
	end
end

info.dlib.si.units.kelvin.name = 'Kelvin'
info.dlib.si.units.kelvin.suffix = 'K'

info.dlib.si.units.celsius.name = 'Celsius'
info.dlib.si.units.celsius.suffix = 'C'

info.dlib.si.units.fahrenheit.name = 'Fahrenheit'
info.dlib.si.units.fahrenheit.suffix = 'F'

info.dlib.si.units.gram.name = 'Gram'
info.dlib.si.units.gram.suffix = 'g'

info.dlib.si.units.metre.name = 'Metre'
info.dlib.si.units.metre.suffix = 'm'

info.dlib.si.units.litre.name = 'Litre'
info.dlib.si.units.litre.suffix = 'L'

-- seems like that on server install required files are corrupted

info.entity.ammo_357.name = "357 Ammo"
info.entity.ammo_9mmar.name = "9mm Ammo"
info.entity.ammo_9mmbox.name = "9mm Ammo Box"
info.entity.ammo_9mmclip.name = "9mm Ammo"
info.entity.ammo_argrenades.name = "MP5 Grenades"
info.entity.ammo_buckshot.name = "Shotgun Ammo"
info.entity.ammo_crossbow.name = "Crossbow Bolts"
info.entity.ammo_egonclip.name = "Uranium"
info.entity.ammo_gaussclip.name = "Gauss Ammo"
info.entity.ammo_glockclip.name = "Glock Ammo"
info.entity.ammo_mp5clip.name = "MP5 Ammo"
info.entity.ammo_mp5grenades.name = "MP5 Grenades"
info.entity.ammo_rpgclip.name = "RPG Rockets"
info.entity.base_ai.name = "AI"
info.entity.base_anim.name = "Animated Entity"
info.entity.base_brush.name = "Brush"
info.entity.base_edit.name = "Editor"
info.entity.base_entity.name = "Entity"
info.entity.base_gmodentity.name = "Entity"
info.entity.base_nextbot.name = "Nextbot"
info.entity.basehl1combatweapon.name = "Weapon"
info.entity.basehl1mpcombatweapon.name = "Weapon"
info.entity.basehl2mpcombatweapon.name = "Weapon"
info.entity.basehlcombatweapon.name = "Weapon"
info.entity.bmortar.name = "Big Momma Mortar Shot"
info.entity.bounce_bomb.name = "Bouncy Grenade"
info.entity.combine_bouncemine.name = "Combine Bouncy Mine"
info.entity.combine_mine.name = "Combine Mine"
info.entity.concussiveblast.name = "Concussion Explosion"
info.entity.controller_energy_ball.name = "Energy Ball"
info.entity.controller_head_ball.name = "Energy Ball"
info.entity.crane_tip.name = "Crane Magnet"
info.entity.crossbow_bolt_hl1.name = "Crossbow Bolt"
info.entity.crossbow_bolt.name = "Crossbow Bolt"
info.entity.dynamic_prop.name = "Dynamic Prop"
info.entity.edit_fog.name = "Fog Editor"
info.entity.edit_sky.name = "Sky Editor"
info.entity.edit_sun.name = "Sun Editor"
info.entity.ent_watery_leech.name = "Water Leech"
info.entity.entityflame.name = "Fire"
info.entity.env_beam.name = "Beam"
info.entity.env_explosion.name = "Explosion"
info.entity.env_fire.name = "Fire"
info.entity.env_headcrabcanister.name = "Headcrab Canister"
info.entity.env_laser.name = "Laser"
info.entity.env_physexplosion.name = "Physics Explosion"
info.entity.env_physimpact.name = "Impact"
info.entity.env_physwire.name = "Wire"
info.entity.func_brush.name = "Brush"
info.entity.func_button.name = "Button"
info.entity.func_conveyor.name = "Conveyer"
info.entity.func_door_rotating.name = "Door"
info.entity.func_door.name = "Door"
info.entity.func_movelinear.name = "Moving Object"
info.entity.func_pendulum.name = "Pendulum"
info.entity.func_physbox_multiplayer.name = "Physics Object"
info.entity.func_physbox.name = "Physics Object"
info.entity.func_plat.name = "Moving Object"
info.entity.func_platrot.name = "Moving Object"
info.entity.func_pushable.name = "Physics Object"
info.entity.func_recharge.name = "Suit Recharger"
info.entity.func_rot_button.name = "Button"
info.entity.func_rotating.name = "Moving Object"
info.entity.func_tank_combine_cannon.name = "Combine Autogun"
info.entity.func_tank.name = "Mounted Gun"
info.entity.func_tankairboatgun.name = "Airboat Gun"
info.entity.func_tankapcrocket.name = "APC Rocket"
info.entity.func_tanklaser.name = "Tank Laser"
info.entity.func_tankmortar.name = "Tank Mortar"
info.entity.func_tankphyscannister.name = "Tank Canister"
info.entity.func_tankpulselaser.name = "Tank Pulse"
info.entity.func_tankrocket.name = "Tank Rocket"
info.entity.func_tracktrain.name = "Moving Object"
info.entity.func_train.name = "Moving Object"
info.entity.func_wall_toggle.name = "Wall"
info.entity.func_wall.name = "Wall"
info.entity.garg_stomp.name = "Energy"
info.entity.generic_actor.name = "Generic Actor"
info.entity.gmod_anchor.name = "Anchor"
info.entity.gmod_balloon.name = "Balloon"
info.entity.gmod_button.name = "Button"
info.entity.gmod_camera.name = "Camera"
info.entity.gmod_cameraprop.name = "Camera"
info.entity.gmod_dynamite.name = "Dynamite"
info.entity.gmod_emitter.name = "Emitter"
info.entity.gmod_ghost.name = "Ghost"
info.entity.gmod_hoverball.name = "Hoverball"
info.entity.gmod_lamp.name = "Lamp"
info.entity.gmod_light.name = "Light"
info.entity.gmod_thruster.name = "Thruster"
info.entity.gmod_tool.name = "Tool Gun"
info.entity.gmod_wheel.name = "Wheel"
info.entity.grenade_ar2.name = "SMG Grenade"
info.entity.grenade_beam.name = "Mortar Beam"
info.entity.grenade_hand.name = "Hand Grenade"
info.entity.grenade_helicopter.name = "Helicopter Bomb"
info.entity.grenade_homer.name = "Homing Grenade"
info.entity.grenade_mp5.name = "MP5 Grenade"
info.entity.grenade_pathfollower.name = "Pathfollowing Grenade"
info.entity.grenade_spit.name = "Antlion Spit"
info.entity.grenade.name = "Grenade"
info.entity.hl2mp_ragdoll.name = "Ragdoll"
info.entity.hornet.name = "Hornet"
info.entity.hunter_flechette.name = "Flechette"
info.entity.item_ammo_357_large.name = "Large .357 Ammo"
info.entity.item_ammo_357.name = ".357 Ammo"
info.entity.item_ammo_ar2_altfire.name = "Combine Energy Ball"
info.entity.item_ammo_ar2_large.name = "Large AR2 Ammo"
info.entity.item_ammo_ar2.name = "AR2 Ammo"
info.entity.item_ammo_crate.name = "Ammo Crate"
info.entity.item_ammo_crossbow.name = "Crossbow Bolts"
info.entity.item_ammo_pistol_large.name = "Large Pistol Ammo"
info.entity.item_ammo_pistol.name = "Pistol Ammo"
info.entity.item_ammo_smg1_grenade.name = "SMG Grenade"
info.entity.item_ammo_smg1_large.name = "Large SMG Ammo"
info.entity.item_ammo_smg1.name = "SMG Ammo"
info.entity.item_ar2_grenade.name = "SMG Grenade"
info.entity.item_battery.name = "Armor Battery"
info.entity.item_box_buckshot.name = "Shotgun Ammo"
info.entity.item_box_lrounds.name = "Small AR2 Ammo"
info.entity.item_box_mrounds.name = "Small SMG Ammo"
info.entity.item_box_srounds.name = "Small Pistol Ammo"
info.entity.item_dynamic_resupply.name = "Dynamic Resupply"
info.entity.item_flare_round.name = "Flare"
info.entity.item_grubnugget.name = "Grub Nugget"
info.entity.item_healthcharger.name = "Health Charger"
info.entity.item_healthkit.name = "Health Kit"
info.entity.item_healthvial.name = "Health Vial"
info.entity.item_item_crate.name = "Item Crate"
info.entity.item_large_box_lrounds.name = "Large AR2 Ammo"
info.entity.item_large_box_mrounds.name = "Large SMG Ammo"
info.entity.item_large_box_srounds.name = "Large Pistol Ammo"
info.entity.item_longjump.name = "Long Jump Module"
info.entity.item_ml_grenade.name = "RPG Round"
info.entity.item_rpg_round.name = "RPG Round"
info.entity.item_suit.name = "Suit"
info.entity.item_suitcharger.name = "Suit Charger"
info.entity.logic_choreographed_scene.name = "Choreographed Scene"
info.entity.manhack_welder.name = "Manhack Gun"
info.entity.momentary_door.name = "Door"
info.entity.momentary_rot_button.name = "Button"
info.entity.monster_alien_controller.name = "Controller"
info.entity.monster_alien_grunt.name = "Alien Grunt"
info.entity.monster_alien_slave.name = "Alien Slave"
info.entity.monster_apache.name = "Apache Helicopter"
info.entity.monster_babycrab.name = "Baby Crab"
info.entity.monster_barnacle.name = "Barnacle"
info.entity.monster_barney_dead.name = "Dead Security Officer"
info.entity.monster_barney.name = "Security Officer"
info.entity.monster_bigmomma.name = "Gonarch"
info.entity.monster_bloater.name = "Floater"
info.entity.monster_bullchicken.name = "Bullsquid"
info.entity.monster_cockroach.name = "Cockroach"
info.entity.monster_flyer_flock.name = "Flyer Flock"
info.entity.monster_flyer.name = "Flyer"
info.entity.monster_furniture.name = "Actor"
info.entity.monster_gargantua.name = "Gargantua"
info.entity.monster_generic.name = "Actor"
info.entity.monster_gman.name = "G-Man"
info.entity.monster_grunt_repel.name = "Repelling Grunt"
info.entity.monster_headcrab.name = "Headcrab"
info.entity.monster_hevsuit_dead.name = "Dead Researcher"
info.entity.monster_hgrunt_dead.name = "Dead Grunt"
info.entity.monster_houndeye.name = "Houndeye"
info.entity.monster_human_assassin.name = "Assassin"
info.entity.monster_human_grunt.name = "Grunt"
info.entity.monster_ichthyosaur.name = "Ichthyosaur"
info.entity.monster_leech.name = "Leech"
info.entity.monster_miniturret.name = "Mini Turret"
info.entity.monster_mortar.name = "Mortar"
info.entity.monster_nihilanth.name = "Nihilanth"
info.entity.monster_osprey.name = "Osprey"
info.entity.monster_satchel.name = "Satchel Charge"
info.entity.monster_scientist_dead.name = "Dead Scientist"
info.entity.monster_scientist.name = "Scientist"
info.entity.monster_sentry.name = "Sentry"
info.entity.monster_sitting_scientist.name = "Scientist"
info.entity.monster_snark.name = "Snark"
info.entity.monster_tentacle.name = "Tentacle"
info.entity.monster_tripmine.name = "Tripmine"
info.entity.monster_turret.name = "Heavy Turret"
info.entity.monster_zombie.name = "Zombie"
info.entity.mortarshell.name = "Combine Suppression Device"
info.entity.nihilanth_energy_ball.name = "Energy Ball"
info.entity.npc_advisor.name = "Advisor"
info.entity.npc_alyx.name = "Alyx"
info.entity.npc_antlion_grub.name = "Antlion Grub"
info.entity.npc_antlion_worker.name = "Antlion Worker"
info.entity.npc_antlion.name = "Antlion"
info.entity.npc_antlionguard.name = "Antlion Guard"
info.entity.npc_barnacle_tongue_tip.name = "Barnacle Tongue"
info.entity.npc_barnacle.name = "Barnacle"
info.entity.npc_barney.name = "Barney"
info.entity.npc_breen.name = "Breen"
info.entity.npc_bullseye.name = "Target"
info.entity.npc_citizen.name = "Citizen"
info.entity.npc_clawscanner.name = "Claw Scanner"
info.entity.npc_combine_s.name = "Combine Soldier"
info.entity.npc_combine.name = "Combine"
info.entity.npc_combinedropship.name = "Dropship"
info.entity.npc_combinegunship.name = "Gunship"
info.entity.npc_concussiongrenade.name = "Concussion Grenade"
info.entity.npc_contactgrenade.name = "Contact Grenade"
info.entity.npc_crow.name = "Crow"
info.entity.npc_cscanner.name = "City Scanner"
info.entity.npc_dog.name = "Dog"
info.entity.npc_eli.name = "Eli"
info.entity.npc_enemyfinder_combinecannon.name = "Combine Cannon"
info.entity.npc_enemyfinder.name = "Enemy Finder"
info.entity.npc_fastzombie_torso.name = "Fast Zombie Torso"
info.entity.npc_fastzombie.name = "Fast Zombie"
info.entity.npc_fisherman.name = "Fisherman"
info.entity.npc_furniture.name = "Actor"
info.entity.npc_gman.name = "G-Man"
info.entity.npc_grenade_bugbait.name = "Bugbait"
info.entity.npc_grenade_frag.name = "Grenade"
info.entity.npc_handgrenade.name = "Grenade"
info.entity.npc_headcrab_black.name = "Poison Headcrab"
info.entity.npc_headcrab_fast.name = "Fast Headcrab"
info.entity.npc_headcrab_poison.name = "Poison Headcrab"
info.entity.npc_headcrab.name = "Headcrab"
info.entity.npc_helicopter.name = "Helicopter"
info.entity.npc_hunter.name = "Hunter"
info.entity.npc_ichthyosaur.name = "Ichthyosaur"
info.entity.npc_kleiner.name = "Kleiner"
info.entity.npc_launcher.name = "Launcher"
info.entity.npc_magnusson.name = "Magnusson"
info.entity.npc_manhack.name = "Manhack"
info.entity.npc_metropolice.name = "Metro-Police"
info.entity.npc_missiledefense.name = "Missile Defense"
info.entity.npc_monk.name = "Father Grigori"
info.entity.npc_mossman.name = "Mossman"
info.entity.npc_pigeon.name = "Pigeon"
info.entity.npc_poisonzombie.name = "Poison Zombie"
info.entity.npc_rollermine.name = "Rollermine"
info.entity.npc_satchel.name = "Satchel Charge"
info.entity.npc_seagull.name = "Seagull"
info.entity.npc_sniper.name = "Sniper"
info.entity.npc_stalker.name = "Stalker"
info.entity.npc_strider.name = "Strider"
info.entity.npc_tripmine.name = "Tripmine"
info.entity.npc_turret_ceiling.name = "Ceiling Turret"
info.entity.npc_turret_floor.name = "Turret"
info.entity.npc_turret_ground.name = "Ground Turret"
info.entity.npc_vortigaunt.name = "Vortigaunt"
info.entity.npc_zombie_torso.name = "Zombie Torso"
info.entity.npc_zombie.name = "Zombie"
info.entity.npc_zombine.name = "Zombine"
info.entity.phys_magnet.name = "Magnet"
info.entity.physics_cannister.name = "Cannister"
info.entity.physics_prop_ragdoll.name = "Ragdoll"
info.entity.physics_prop.name = "Physics Prop"
info.entity.player.name = "Player"
info.entity.point_hurt.name = "Point Hurt"
info.entity.prop_combine_ball.name = "Combine Ball"
info.entity.prop_door_rotating.name = "Door"
info.entity.prop_dropship_container.name = "Dropship Container"
info.entity.prop_dynamic_ornament.name = "Dynamic Prop"
info.entity.prop_dynamic_override.name = "Dynamic Prop"
info.entity.prop_dynamic.name = "Dynamic Prop"
info.entity.prop_effect.name = "Effect"
info.entity.prop_physics_multiplayer.name = "Physics Prop"
info.entity.prop_physics_override.name = "Physics Prop"
info.entity.prop_physics_respawnable.name = "Physics Prop"
info.entity.prop_physics.name = "Physics Prop"
info.entity.prop_ragdoll_attached.name = "Ragdoll"
info.entity.prop_ragdoll.name = "Ragdoll"
info.entity.prop_sphere.name = "Sphere"
info.entity.prop_stickybomb.name = "Magnusson Device"
info.entity.prop_thumper.name = "Thumper"
info.entity.prop_vehicle_airboat.name = "Airboat"
info.entity.prop_vehicle_apc.name = "Combine APC"
info.entity.prop_vehicle_choreo_generic.name = "Vehicle"
info.entity.prop_vehicle_crane.name = "Crane"
info.entity.prop_vehicle_driveable.name = "Vehicle"
info.entity.prop_vehicle_jeep_old.name = "Vehicle"
info.entity.prop_vehicle_jeep.name = "Vehicle"
info.entity.prop_vehicle_prisoner_pod.name = "Pod"
info.entity.prop_vehicle.name = "Vehicle"
info.entity.proto_sniper.name = "Sniper"
info.entity.ragdoll_motion.name = "Ragdoll Controller"
info.entity.rpg_missile.name = "RPG Missile"
info.entity.rpg_rocket.name = "RPG Rocket"
info.entity.sent_ai.name = "AI"
info.entity.sent_anim.name = "Animated Entity"
info.entity.sent_ball.name = "Bouncy Ball"
info.entity.sent_brush.name = "Brush"
info.entity.sent_nextbot.name = "Nextbot"
info.entity.simple_bot.name = "Bot"
info.entity.simple_physics_brush.name = "Brush"
info.entity.simple_physics_prop.name = "Physics Prop"
info.entity.speaker.name = "Speaker"
info.entity.squidspit.name = "Bullsquid Spit"
info.entity.trigger_hurt.name = "Trigger Hurt"
info.entity.trigger_impact.name = "Impact"
info.entity.trigger_vphysics_motion.name = "Moving Object"
info.entity.trigger_waterydeath.name = "Water Leeches"
info.entity.trigger.name = "Trigger"
info.entity.weapon_357_hl1.name = ".357 Handgun"
info.entity.weapon_357.name = ".357 Magnum"
info.entity.weapon_alyxgun.name = "Alyx Gun"
info.entity.weapon_annabelle.name = "Annabelle"
info.entity.weapon_ar2.name = "AR2"
info.entity.weapon_bugbait.name = "Bugbait"
info.entity.weapon_citizenpackage.name = "Package"
info.entity.weapon_citizensuitcase.name = "Suitcase"
info.entity.weapon_crossbow_hl1.name = "Crossbow"
info.entity.weapon_crossbow.name = "Crossbow"
info.entity.weapon_crowbar_hl1.name = "Crowbar"
info.entity.weapon_crowbar.name = "Crowbar"
info.entity.weapon_cubemap.name = "Cubemaps"
info.entity.weapon_egon.name = "Gluon Gun"
info.entity.weapon_fists.name = "Fists"
info.entity.weapon_flechettegun.name = "Flechette Gun"
info.entity.weapon_frag.name = "Grenade"
info.entity.weapon_gauss.name = "Tau Cannon"
info.entity.weapon_glock.name = "9mm Handgun"
info.entity.weapon_hl2mp_base.name = "Weapon"
info.entity.weapon_hornetgun.name = "Hornet Gun"
info.entity.weapon_medkit.name = "Medkit"
info.entity.weapon_mp5.name = "MP5"
info.entity.weapon_oldmanharpoon.name = "Harpoon"
info.entity.weapon_physcannon.name = "Gravity Gun"
info.entity.weapon_physgun.name = "Physics Gun"
info.entity.weapon_pistol.name = "Pistol"
info.entity.weapon_rpg_hl1.name = "RPG Launcher"
info.entity.weapon_rpg.name = "RPG"
info.entity.weapon_satchel.name = "Satchel Charges"
info.entity.weapon_shotgun_hl1.name = "Shotgun"
info.entity.weapon_shotgun.name = "Shotgun"
info.entity.weapon_slam.name = "S.L.A.M"
info.entity.weapon_smg1.name = "SMG1"
info.entity.weapon_snark.name = "Snarks"
info.entity.weapon_striderbuster.name = "Magnusson Device"
info.entity.weapon_stunstick.name = "Stunstick"
info.entity.weapon_swep.name = "Scripted Weapon"
info.entity.weapon_tripmine.name = "Tripmines"
info.entity.weaponbox.name = "Weapon Box"
info.entity.worldspawn.name = "World"
info.entity.xen_hair.name = "Xen Hair"
info.entity.xen_hull.name = "Large Xen Spore"
info.entity.xen_plantlight.name = "Xen Plant"
info.entity.xen_spore_large.name = "Large Xen Spore"
info.entity.xen_spore_medium.name = "Medium Xen Spore"
info.entity.xen_spore_small.name = "Small Xen Spore"
info.entity.xen_tree.name = "Xen Tree"
