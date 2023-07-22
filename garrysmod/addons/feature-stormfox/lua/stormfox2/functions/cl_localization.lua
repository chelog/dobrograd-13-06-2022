-- This is a localization backup, in case the file didn't transferre.
if not file.Exists("resource/localization/en/stormfox.properties", "GAME") then return end
local str = [[
	#StormFox2.weather = weather
	# https://github.com/Facepunch/garrysmod/blob/master/garrysmod/resource/localization/en/community.properties Check this first
	# weather, day, night, sun, lightning, snow, cloud
	
	#Misc
	sf_auto=Auto
	sf_customization=Customization
	sf_window_effects=Window Effects
	footprints=footprints
	temperature=temperature
	fog=Fog
	
	#Weather
	sf_weather.clear=Clear
	sf_weather.clear.windy=Windy
	sf_weather.cloud=Cloudy
	sf_weather.cloud.thunder=Thunder
	sf_weather.cloud.storm=Storm
	sf_weather.rain=Raining
	sf_weather.rain.sleet=Sleet
	sf_weather.rain.snow=Snowing
	sf_weather.rain.thunder=Thunder
	sf_weather.rain.storm=Storm
	sf_weather.fog.low=Haze
	sf_weather.fog.medium=Fog
	sf_weather.fog.high=Thick Fog
	sf_weather.lava=Lava
	sf_weather.fallout=Nuclear Fallout
	
	#Tool
	sf_tool.name=StormFox2 Tool
	sf_tool.desc=Allows you to edit StormFox2 map settings.
	sf_tool.surface_editor=Surface Editor
	sf_tool.surface_editor.desc=Allows you to edit surface-types.
	sf_tool.light_editor=Light Editor
	sf_tool.light_editor.desc=Allows you to add/remove sf-lights.
	sf_enable_breath=Enables breath
	sf_enable_breath.desc=Makes players breath visible in cold.
	
	#Settings
	sf_enable=Enable StormFox
	sf_enable.desc=Enable / Disable StormFox 2
	sf_clenable=Enable StormFox
	sf_clenable.desc=Enable / Disable StormFox 2. Requires sf_allow_csenable.
	sf_allow_csenable=Allow Clients to disable StormFox 2
	sf_allow_csenable.desc=Enabling this will allow clients to disable StormFox 2.
	
	sf_mthreadwarning=These settings can boost your FPS:\n%s\nWarning\: This Might crash on some older AMD CPUs!
	sf_holdc=Hold C
	sf_weatherpercent=Weather Amount
	sf_setang=Set Angle
	sf_setang.desc=Sets the wind-angle to your view.
	sf_setwind=Sets the windspeed in m/s
	sf_wcontoller=SF Controller
	sf_map.light_environment.check=This map support fast lightchanges.
	sf_map.light_environment.problem=This map will cause lagspikes for clients, when the light changes.
	sf_map.env_wind.none=This map doesn't support windgusts.
	sf_map.logic_relay.check=This map has custom day/night relays.
	sf_map.logic_relay.none=This map doens't have custom day/night relays.
	sf_windmove_players=Affect players
	sf_windmove_players.desc=Affect player movment in strong wind.
	sf_windmove_foliate=Affect Foliate
	sf_windmove_foliate.desc=Foliate moves with the wind.
	sf_windmove_props=Affect Props
	sf_windmove_props.desc=Props will move with the wind. This can cause lag!
	sf_windmove_props_break=Damage Props
	sf_windmove_props_break.desc=Props will take damage in the wind.
	sf_windmove_props_makedebris=Change CollisionGroup
	sf_windmove_props_makedebris.desc=Will make props change collisiongroup, reducing lag.
	sf_windmove_props_unfreeze=Unfreeze props.
	sf_windmove_props_unfreeze.desc=Unfreeze props being moved by the wind.
	sf_windmove_props_unweld=Unweld props.
	sf_windmove_props_unweld.desc=Unweld props being moved by the wind.
	sf_windmove_props_max=Max props being moved.
	sf_windmove_props_max.desc=Max amount of props moving. This can cause lag!
	
	sf_enable_fogz=Overwrite farZ fog
	sf_enable_fogz.desc=Overwrites the maps farZ fog. This might look bad on some maps.
	sf_enable_ice=Enable ice
	sf_enable_ice.desc=Creates ice over water.
	sf_overwrite_fogdistance=Default fog-distance.
	sf_overwrite_fogdistance.desc=Overwrites the default fog-distance.
	sf_hide_forecast=Hide Forecast
	sf_hide_forecast.desc=Stops clients from updating the forecast.
	sf_allow_weather_lightchange=Allow weather maplight
	sf_allow_weather_lightchange.desc=Allows the weather to modify the maplight.
	sf_addnight_temp=Add Night Temperature
	sf_addnight_temp.desc=The amount the temperature drops doing night.
	sf_apply_settings=Apply settings.
	sf_reset_settings=Reset settings.
	sf_enable_skybox=Enable Skybox
	sf_enable_skybox.desc=Allows StormFox to use the skybox.
	sf_use_2dskybox=Use 2D Skybox
	sf_use_2dskybox.desc=Makes StormFox use 2D skyboxes instead.
	sf_overwrite_2dskybox=Overwrite 2D skybox
	sf_overwrite_2dskybox.desc=Overwrites the 2D skybox with another.
	sf_darken_2dskybox=Darken 2D Skybox
	sf_darken_2dskybox.desc=Match the skybox brightness with the map.
	sf_random_round_weather=Random weather each round.
	sf_random_round_weather.desc=Gamemodes like TTT will have random weathers between each round.
	sf_quickselect=Quick Select.
	sf_quickselect.desc=Quick select time settings.
	sf_depthfilter=Depth Filter
	sf_depthfilter.desc=Render 2D weather-effects on clients screen.
	
	
	#Details
	sf_quality_target=FPS Target
	sf_quality_target.desc=Adjusts the quality to reach targeted FPS.
	sf_quality_ultra=Ultra Quality
	sf_quality_ultra.desc=Allows for more effects.
	sf_12h_display=Time Display
	sf_12h_display.disc=Choose 12-hour or 24-hour clock.
	sf_display_temperature=Temperature Units
	sf_display_temperature.desc=Choose a temperature unit.
	sf_use_monthday=Date Display
	sf_use_monthday.disc=Choose MM/DD or DD/MM.
	
	#Wind
	sf_wind=Wind
	sf_winddescription.calm=Calm
	sf_winddescription.light_air=Light Air
	sf_winddescription.light_breeze=Light Breeze
	sf_winddescription.gentle_breeze=Gentle Breeze
	sf_winddescription.moderate_breeze=Moderate Breeze
	sf_winddescription.fresh_breeze=Fresh Breeze
	sf_winddescription.strong_breeze=Strong Breeze
	sf_winddescription.near_gale=Near Gale
	sf_winddescription.gale=Gale
	sf_winddescription.strong_gale=Strong Gale
	sf_winddescription.storm=Storm
	sf_winddescription.violent_storm=Violent Storm
	#Hurricane is also known as Category 1
	sf_winddescription.hurricane=Hurricane
	sf_winddescription.cat2=Category 2
	sf_winddescription.cat3=Category 3
	sf_winddescription.cat4=Category 4
	sf_winddescription.cat5=Category 5
	
	#Time
	sf_continue_time=Continuous Time
	sf_continue_time.desc=Continue time from last time.
	sf_real_time=Real time
	sf_real_time.desc=Use the servers OS Time.
	sf_start_time=Start time
	sf_start_time.desc=Sets the start time.
	sf_random_time=Random time
	sf_random_time.desc=Sets the time randomly on server-launch.
	sf_day_length=Day Length
	sf_day_length.desc=How long the day is in minutes.
	sf_night_length=Night Length
	sf_night_length.desc=How long the night is in minutes.
	
	#Sun
	sf_sunrise=SunRise
	sf_sunrise.desc=Sets the time the sun rises.
	sf_sunset=SunSet
	sf_sunset.desc=Sets the time the sun sets.
	sf_sunyaw=SunYaw
	sf_sunyaw.desc=Sets the yaw for the sun.
	#Moon
	sf_moonsize=Moon Size
	sf_moonsize.desc=The default moon size.
	sf_moonphase=Moon Phases
	sf_moonphase.desc=Enable Moon Phases.
	sf_moonlock=Moon Lock
	sf_moonlock.desc=Locks the moon to the sun's rotation.
	
	
	
	#'Maplight
	sf_maplight_max=Max Maplight
	sf_maplight_max.desc=The max lightlevel. You can adjust this if the map is too bright/dark.
	sf_maplight_min=Min Maplight
	sf_maplight_min.desc=The min lightlevel. You can adjust this if the map is too bright/dark.
	
	sf_maplight_smooth=Maplight Lerp.
	sf_maplight_smooth.desc=Enables smooth light transitions.
	sf_maplight_updaterate=Maplight UpdateRate
	sf_maplight_updaterate.desc=The max amount of times StormFox will update the maplight doing transitions. Will cause lag on large maps!
	
	sf_maplight_auto.desc=Select the best/fastes option for the map.
	sf_maplight_lightenv.desc=Enable light_environment.
	sf_maplight_colormod.desc=Enable colormod.
	sf_maplight_dynamic.desc=Enable dynamic light/shadows.
	sf_maplight_lightstyle.desc=Enable lightstyle.
	
	sf_modifyshadows=Modify shadows
	sf_modifyshadows.desc=Modify default shadows to follow the sun.
	sf_modifyshadows_rate=Modify shadow rate
	sf_modifyshadows_rate.desc=The seconds between each shadow-update.
	
	sf_extra_lightsupport=Extra Lightsupport
	sf_extra_lightsupport.desc=Utilize engine.LightStyle to change the map-light. This can cause lag-spikes, but required on certain maps.
	
	#Effects
	sf_enable_fog=Enable Fog
	sf_enable_fog.desc=Allow StormFox to edit the fog.
	sf_allow_fog_change=Allow clients to toggle fog.
	sf_allow_fog_change.desc=Enabling this will allow clients to toggle fog.
	sf_footprint_enabled=Enable Footprints
	sf_footprint_enabled.desc=Enable footprint effects.
	sf_footprint_playeronly=Player Footprints Only.
	sf_footprint_playeronly.desc=Only players make footprints.
	sf_footprint_distance=Footprint Render Distance
	sf_footprint_distance.desc=Max render distance for footprints.
	sf_footprint_max=Max Footprints
	sf_footprint_max.desc=Max amount of footprints
	
	sf_edit_tonemap=Enable tonemap
	sf_edit_tonemap.desc=Allow StormFox to edit the tonemap.
	sf_enable_wateroverlay=Render water overlay
	sf_enable_wateroverlay.desc=Enables water-overlay for weather-types.
	
	sf_extra_darkness=Extra Darkness
	sf_extra_darkness.desc=Adds a darkness-filter to make bright maps darker.
	sf_extra_darkness_amount=Extra Darkness Amount
	sf_extra_darkness_amount.desc=Scales the darkness-filter.
	
	sf_overwrite_extra_darkness=Overwrite Extra Darkness
	sf_overwrite_extra_darkness.desc=Overwrites the players sf_extra_darkness.
	sf_footprint_enablelogic=Enables Serverside Footprints
	sf_footprint_enablelogic.desc=Enables server-side footprints.
	
	sf_window_enable=Enable window effects
	sf_window_enable.desc=Enables window weather effects.
	sf_window_distance=Window Render Distance
	sf_window_distance.desc=The render distance for breakable windows.
	sf_override_foliagesway=Override Foliagesway
	sf_override_foliagesway.desc=Overrides and applies foliagesway to most foliage on launch.
	
	#Weather
	sf_auto_weather=Auto weather
	sf_auto_weather.desc=Automatically change weather over time.
	sf_max_weathers_prweek=Max Weathers Pr Week
	sf_max_weathers_prweek.desc=Max amount of weathers pr week.
	sf_temp_range=Temperature range
	sf_temp_range.desc=The min and max temperature.
	sf_temp_acc=Temperature change.
	sf_temp_acc.desc=The max temperature changes pr day.	
]]

for k, v in ipairs( string.Explode("\n", str)) do
	if string.match(v, "%s-#") then continue end
	local a,b = string.match(v, "%s*(.+)=(.+)")
	if not a or not b then continue end
	language.Add(a, b)
end
