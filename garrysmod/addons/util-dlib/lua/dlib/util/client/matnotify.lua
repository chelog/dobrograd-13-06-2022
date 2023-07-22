
-- Copyright (C) 2017-2020 DBotThePony

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

hook.Add('ScreenResolutionChanged', 'DLib.Рубат не хочет ничего фиксить', function(lw, lh, w, h)
	if lw == w and lh == h then return end
	hook.Run('InvalidateMaterialCache')
	hook.Run('MaterialVariableChanges')
end)

local сукападла = [[
mat_aaquality                            : 0        :                  :
mat_accelerate_adjust_exposure_down      : 3        : , "cheat"        :
mat_alphacoverage                        : 1        :                  :
mat_antialias                            : 8        :                  :
mat_autoexposure_max                     : 2        : , "cl"           :
mat_autoexposure_min                     : 0        : , "cl"           :
mat_bloom_scalefactor_scalar             : 1        : , "cl"           :
mat_bloomamount_rate                     : 0        : , "cheat", "cl"  :
mat_bloomscale                           : 1        : , "cl"           :
mat_bufferprimitives                     : 1        :                  :
mat_bumpbasis                            : 0        : , "cheat"        :
mat_bumpmap                              : 1        :                  :
mat_camerarendertargetoverlaysize        : 256      : , "cheat", "cl"  :
mat_clipz                                : 1        : , "cl"           :
mat_colcorrection_disableentities        : 0        :                  : Disable map color-correction entities
mat_color_projection                     : 0        : , "a"            :
mat_colorcorrection                      : 1        :                  :
mat_compressedtextures                   : 1        :                  :
mat_configcurrent                        : cmd      :                  : show the current video control panel config for the material system
mat_crosshair                            : cmd      :                  : Display the name of the material under the crosshair
mat_crosshair_edit                       : cmd      :                  : open the material under the crosshair in the editor defined by mat_crosshair_edit_editor
mat_crosshair_explorer                   : cmd      :                  : open the material under the crosshair in explorer and highlight the vmt file
mat_crosshair_printmaterial              : cmd      :                  : print the material under the crosshair
mat_crosshair_reloadmaterial             : cmd      :                  : reload the material under the crosshair
mat_debug_autoexposure                   : 0        : , "cheat", "cl"  :
mat_debug_bloom                          : 0        : , "cheat", "cl"  :
mat_debug_postprocessing_effects         : 0        : , "cl"           : 0 = off, 1 = show post-processing passes in quadrants of the screen, 2 = only apply post-processing to the centre of the screen
mat_debug_process_halfscreen             : 0        : , "cheat", "cl"  :
mat_debugalttab                          : 0        : , "cheat"        :
mat_debugdepth                           : 0        :                  :
mat_debugdepthmode                       : 0        :                  :
mat_debugdepthval                        : 128      :                  :
mat_debugdepthvalmax                     : 256      :                  :
mat_depthbias_decal                      : -262144  : , "cheat"        :
mat_depthbias_normal                     : 0        : , "cheat"        :
mat_depthbias_shadowmap                  : 0        :                  :
mat_diffuse                              : 1        : , "cheat"        :
mat_disable_bloom                        : 0        : , "cl"           :
mat_disable_d3d9ex                       : 0        : , "a"            : Disables Windows Aero DirectX extensions (may positively or negatively affect performance depending on video drivers)
mat_disable_fancy_blending               : 0        :                  :
mat_disable_lightwarp                    : 0        :                  :
mat_disable_ps_patch                     : 0        :                  :
mat_disablehwmorph                       : 0        :                  : Disables HW morphing for particular mods
mat_drawflat                             : 0        : , "cheat"        :
mat_drawTexture                          : 0        : , "cl"           : Enable debug view texture
mat_drawTextureScale                     : 1        : , "cl"           : Debug view texture scale
mat_drawTitleSafe                        : 0        :                  : Enable title safe overlay
mat_drawwater                            : 1        : , "cheat", "cl"  :
mat_dump_rts                             : 0        : , "cl"           :
mat_dxlevel                              : 95       :                  :
mat_dynamic_tonemapping                  : 1        : , "cheat"        :
mat_edit                                 : cmd      :                  : Bring up the material under the crosshair in the editor
mat_envmapsize                           : 128      :                  :
mat_envmaptgasize                        : 32       :                  :
mat_excludetextures                      : 0        :                  :
mat_exposure_center_region_x             : 0        : , "cheat", "cl"  :
mat_exposure_center_region_x_flashlight  : 0        : , "cheat", "cl"  :
mat_exposure_center_region_y             : 0        : , "cheat", "cl"  :
mat_exposure_center_region_y_flashlight  : 0        : , "cheat", "cl"  :
mat_fastclip                             : 0        : , "cheat"        :
mat_fastnobump                           : 0        : , "cheat"        :
mat_fastspecular                         : 1        :                  : Enable/Disable specularity for visual testing.  Will not reload materials and will not affect perf.
mat_fillrate                             : 0        : , "cheat"        :
mat_filterlightmaps                      : 1        :                  :
mat_filtertextures                       : 1        :                  :
mat_force_bloom                          : 0        : , "cheat", "cl"  :
mat_force_ps_patch                       : 0        :                  :
mat_force_tonemap_scale                  : 0        : , "cheat"        :
mat_forceaniso                           : 16       :                  :
mat_forcedynamic                         : 0        : , "cheat"        :
mat_forcehardwaresync                    : 1        :                  :
mat_forcemanagedtextureintohardware      : 0        :                  :
mat_frame_sync_enable                    : 1        : , "cheat"        :
mat_frame_sync_force_texture             : 0        : , "cheat"        : Force frame syncing to lock a managed texture.
mat_framebuffercopyoverlaysize           : 256      : , "cl"           :
mat_fullbright                           : 0        : , "cheat"        :
mat_hdr_enabled                          : cmd      :                  : Report if HDR is enabled for debugging
mat_hdr_level                            : 0        : , "a"            : Set to 0 for no HDR, 1 for LDR+bloom on HDR maps, and 2 for full HDR on HDR maps.
mat_hdr_manual_tonemap_rate              : 1        :                  :
mat_hdr_tonemapscale                     : 1        : , "cheat"        : The HDR tonemap scale. 1 = Use autoexposure, 0 = eyes fully closed, 16 = eyes wide open.
mat_hdr_uncapexposure                    : 0        : , "cheat", "cl"  :
mat_hsv                                  : 0        : , "cheat", "cl"  :
mat_info                                 : cmd      :                  : Shows material system info
mat_leafvis                              : 0        : , "cheat"        : Draw wireframe of current leaf
mat_levelflush                           : 1        :                  :
mat_lightmap_pfms                        : 0        :                  : Outputs .pfm files containing lightmap data for each lightmap page when a level exits.
mat_loadtextures                         : 1        : , "cheat"        :
mat_luxels                               : 0        : , "cheat"        :
mat_managedtextures                      : 1        : , "a"            : If set, allows Direct3D to manage texture uploading at the cost of extra system memory
mat_max_worldmesh_vertices               : 65536    :                  :
mat_maxframelatency                      : 1        :                  :
mat_measurefillrate                      : 0        : , "cheat"        :
mat_mipmaptextures                       : 1        :                  :
mat_monitorgamma                         : 2        :                  : monitor gamma (typically 2.2 for CRT and 1.7 for LCD)
mat_monitorgamma_tv_enabled              : 0        : , "a"            :
mat_monitorgamma_tv_exp                  : 2        :                  :
mat_monitorgamma_tv_range_max            : 255      :                  :
mat_monitorgamma_tv_range_min            : 16       :                  :
mat_morphstats                           : 0        : , "cheat"        :
mat_motion_blur_enabled                  : 1        :                  :
mat_motion_blur_falling_intensity        : 1        : , "cl"           :
mat_motion_blur_falling_max              : 20       : , "cl"           :
mat_motion_blur_falling_min              : 10       : , "cl"           :
mat_motion_blur_forward_enabled          : 1        : , "cl"           :
mat_motion_blur_percent_of_screen_max    : 4        :                  :
mat_motion_blur_rotation_intensity       : 1        : , "cl"           :
mat_motion_blur_strength                 : 1        : , "cl"           :
mat_non_hdr_bloom_scalefactor            : 0        : , "cl"           :
mat_norendering                          : 0        : , "cheat"        :
mat_normalmaps                           : 0        : , "cheat"        :
mat_normals                              : 0        : , "cheat"        :
mat_parallaxmap                          : 1        :                  :
mat_picmip                               : -1       :                  :
mat_postprocess_x                        : 4        : , "cl"           :
mat_postprocess_y                        : 1        : , "cl"           :
mat_postprocessing_combine               : 1        : , "cl"           : Combine bloom, software anti-aliasing and color correction into one post-processing pass
mat_powersavingsmode                     : 0        : , "a"            : Power Savings Mode
mat_proxy                                : 0        : , "cheat"        :
mat_queue_mode                           : 2        : , "a"            : The queue/thread mode the material system should use: -1=default, 0=synchronous single thread, 2=queued multithreaded
mat_queue_report                         : 0        : , "a"            : Report thread stalls.  Positive number will filter by stalls >= time in ms.  -1 reports all locks.
mat_reducefillrate                       : 0        :                  :
mat_reduceparticles                      : 0        :                  :
mat_reloadallmaterials                   : cmd      :                  : Reloads all materials
mat_reloadmaterial                       : cmd      :                  : Reloads a single material
mat_reloadtexture                        : cmd      :                  : Reloads a single texture
mat_reloadtextures                       : cmd      :                  : Reloads all textures
mat_remoteshadercompile                  : 127      : , "cheat"        :
mat_report_queue_status                  : 0        :                  :
mat_reporthwmorphmemory                  : cmd      :                  : Reports the amount of size in bytes taken up by hardware morph textures.
mat_reversedepth                         : 0        : , "cheat"        :
mat_savechanges                          : cmd      :                  : saves current video configuration to the registry
mat_setvideomode                         : cmd      :                  : sets the width, height, windowed state of the material system
mat_shadercount                          : cmd      :                  : display count of all shaders and reset that count
mat_shadowstate                          : 1        :                  :
mat_show_ab_hdr                          : 0        :                  :
mat_show_ab_hdr_hudelement               : 0        : , "cheat", "cl"  : HDR Demo HUD Element toggle.
mat_show_histogram                       : 0        : , "cl"           :
mat_show_texture_memory_usage            : 0        : , "cheat", "numeric" : Display the texture memory usage on the HUD.
mat_showcamerarendertarget               : 0        : , "cheat", "cl"  :
mat_showenvmapmask                       : 0        :                  :
mat_showframebuffertexture               : 0        : , "cheat", "cl"  :
mat_showlightmappage                     : -1       : , "cl"           :
mat_showlowresimage                      : 0        : , "cheat"        :
mat_showmaterials                        : cmd      :                  : Show materials.
mat_showmaterialsverbose                 : cmd      :                  : Show materials (verbose version).
mat_showmiplevels                        : 0        : , "cheat"        : color-code miplevels 2: normalmaps, 1: everything else
mat_showtextures                         : cmd      :                  : Show used textures.
mat_showwatertextures                    : 0        : , "cheat", "cl"  :
mat_slopescaledepthbias_decal            : 0        : , "cheat"        :
mat_slopescaledepthbias_normal           : 0        : , "cheat"        :
mat_slopescaledepthbias_shadowmap        : 2        :                  :
mat_software_aa_blur_one_pixel_lines     : 0        : , "a", "cl"      : How much software AA should blur one-pixel thick lines: (0.0 - none), (1.0 - lots)
mat_software_aa_debug                    : 0        : , "cl"           : Software AA debug mode: (0 - off), (1 - show number of 'unlike' samples: 0->black, 1->red, 2->green, 3->blue), (2 - show anti-a
mat_software_aa_edge_threshold           : 1        : , "a", "cl"      : Software AA - adjusts the sensitivity of the software AA shader's edge detection (default 1.0 - a lower value will soften more
mat_software_aa_quality                  : 0        : , "a", "cl"      : Software AA quality mode: (0 - 5-tap filter), (1 - 9-tap filter)
mat_software_aa_strength                 : 0        : , "a", "cl"      : Software AA - perform a software anti-aliasing post-process (an alternative/supplement to MSAA). This value sets the strength o
mat_software_aa_strength_vgui            : 1        : , "a", "cl"      : Same as mat_software_aa_strength, but forced to this value when called by the post vgui AA pass.
mat_software_aa_tap_offset               : 1        : , "a", "cl"      : Software AA - adjusts the displacement of the taps used by the software AA shader (default 1.0 - a lower value will make the im
mat_softwarelighting                     : 0        :                  :
mat_softwareskin                         : 0        : , "cheat"        :
mat_specular                             : 1        :                  : Enable/Disable specularity for perf testing.  Will cause a material reload upon change.
mat_spewvertexandpixelshaders            : cmd      :                  : Print all vertex and pixel shaders currently loaded to the console
mat_stub                                 : 0        : , "cheat", "cl"  :
mat_supportflashlight                    : 1        :                  : 0 - do not support flashlight (don't load flashlight shader combos), 1 - flashlight is supported
mat_surfaceid                            : 0        : , "cheat"        :
mat_surfacemat                           : 0        : , "cheat"        :
mat_texture_limit                        : -1       : , "numeric"      : If this value is not -1, the material system will limit the amount of texture memory it uses in a frame. Useful for identifying
mat_texture_list                         : 0        :                  : For debugging, show a list of used textures per frame
mat_texture_list_all                     : 0        : , "numeric"      : If this is nonzero, then the texture list panel will show all currently-loaded textures.
mat_texture_list_content_path            : 0        : , "a"            : The content path to the materialsrc directory. If left unset, it'll assume your content directory is next to the currently runn
mat_texture_list_txlod                   : cmd      :                  : Adjust LOD of the last viewed texture +1 to inc resolution, -1 to dec resolution
mat_texture_list_txlod_sync              : cmd      :                  : 'reset' - resets all run-time changes to LOD overrides, 'save' - saves all changes to material content files
mat_texture_list_view                    : 1        : , "numeric"      : If this is nonzero, then the texture list panel will render thumbnails of currently-loaded textures.
mat_texture_outline_fonts                : cmd      :                  : Outline fonts textures.
mat_texture_save_fonts                   : cmd      :                  : Save all font textures
mat_tonemap_algorithm                    : 1        : , "cheat"        : 0 = Original Algorithm 1 = New Algorithm
mat_tonemap_min_avglum                   : 3        : , "cheat", "cl"  :
mat_tonemap_percent_bright_pixels        : 2        : , "cheat", "cl"  :
mat_tonemap_percent_target               : 60       : , "cheat", "cl"  :
mat_tonemapping_occlusion_use_stencil    : 0        :                  :
mat_trilinear                            : 0        :                  :
mat_use_compressed_hdr_textures          : 1        :                  :
mat_viewportscale                        : 1        : , "a", "cl"      : Scale down the main viewport (to reduce GPU impact on CPU profiling)
mat_viewportupscale                      : 1        : , "a", "cl"      : Scale the viewport back up
mat_visualize_dof                        : 0        : , "cheat"        :
mat_vsync                                : 0        :                  : Force sync to vertical retrace
mat_wateroverlaysize                     : 256      : , "cl"           :
mat_wireframe                            : 0        : , "cheat"        :
mat_yuv                                  : 0        : , "cheat", "cl"  :
matchmakingport                          : 27025    :                  : Host Matchmaking port
material_override                        : 0        : , "user", "demo", "server_can_execute", "cl", "lua_client" :
]]

local пидорас = {
	'mat_fullbright',
	'mat_specular',
	'mat_aaquality',
	'mat_picmip',
	'mat_showlowresimage',
}

--[[
for i, дебил in ipairs(сукападла:split('\n')) do
	local cvar, cvalue = дебил:match('(%S+)%s+:%s(%S+)')
	cvar = cvar:trim()
	cvalue = cvalue:trim():tonumber()

	if cvalue then
		table.insert(пидорас, cvar)
	end
end
]]

for i, хуита in ipairs(пидорас) do
	cvars.AddChangeCallback(хуита, function()
		hook.Run('InvalidateMaterialCache')
	end, 'DLib.Фиксись блядь')
end

for i, дебил in ipairs(сукападла:split('\n')) do
	local хуйня, эточотакое = дебил:match('(%S+)%s+:%s(%S+)')

	if хуйня then
		хуйня = хуйня:trim()
		эточотакое = эточотакое:trim():tonumber()

		if эточотакое then
			cvars.AddChangeCallback(хуйня, function(хуйня, что_там_было, это_чото_новое)
				hook.Run('MaterialVariableChanges', хуйня, что_там_было, это_чото_новое)
			end, 'DLib.Все умрут')
		end
	end
end

--[[
	@doc
	@hook InvalidateMaterialCache

	@desc
	Called when engine invalidate material cache
	Redefine your !g:CreateMaterial materials after this hook run
	@enddesc
]]

--[[
	@doc
	@hook MaterialVariableChanges
	@args string cvar, string oldValue, string newValue

	@desc
	Called when mat_* variable changes.
	@enddesc
]]

--[[
	@doc
	@fname DLib.MaterialCacheHook
	@args string name, function func

	@desc
	func() + `hook.Add('InvalidateMaterialCache')`
	@enddesc
]]
function DLib.MaterialCacheHook(name, func)
	func()
	return hook.Add('InvalidateMaterialCache', name, func)
end

timer.Simple(0, function()
	hook.Run('InvalidateMaterialCache')
end)
