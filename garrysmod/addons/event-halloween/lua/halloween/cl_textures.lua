do return end

local maps = {
	rp_eastcoast_v4c = {
		['de_tides/tides_grass_a'] = {'de_tides/tides_grass_a_fall'},
		['decals/ivy01'] = {'decals/ivy01_fall'},
		['nature/dirtfloor006a'] = {'nature/dirtfloor006a_fall'},
		['nature/blendgrassgravel001c'] = {'nature/dirtfloor006a_fall', true},
		['models/props_foliage/tree_springers_01a_lod'] = {'models/props_foliage/tree_springers_01a_lod-leaves'},
		['models/props_foliage/tree_springers_01a'] = {'models/props_foliage/tree_springers_01a_leaves'},
	},
	rp_evocity_dbg_210308 = {
		['nature/blendgrassgravel02'] = {'nature/forest_grass_01_fall'},
		['nature/forest_grass_01'] = {'nature/forest_grass_01_fall'},
		['maps/rp_evocity_dbg_210308/nature/blendgrassgravel02_wvt_patch'] = {'nature/forest_grass_01_fall'},
		['nature/blendgrassgravel_noprop_02'] = {'nature/forest_dirt_04_fall'},
		['nature/blendgrassgravel_noprop_01'] = {'nature/forest_grass_01_fall'},
		['nature/blendgrassdirt01_noprop'] = {'nature/forest_grass_01_fall'},
		['models/props_foliage/arbre01'] = {'models/props_foliage/arbre01_fall'},
		['models/props_park/pine_branches'] = {'models/props_park/pine_branches_fall'},
		['models/props_foliage/mall_trees_branches01'] = {'models/props_foliage/mall_trees_branches01_fall'},
		['models/msc/e_bigbush'] = {'models/msc/e_bigbush_fall'},
		['models/msc/e_bigbush3'] = {'models/msc/e_bigbush3_fall'},
		['nature/blendgrassdirt02_noprop'] = {'nature/forest_grass_01_fall', true},
		['nature/blendgrassdirt02_noprop'] = {'nature/forest_dirt_04_fall'},
		['nature/cliff03b'] = {'nature/cliff03b_fall'},
		['nature/clifftrees_cardboard02a'] = {'nature/clifftrees_cardboard02a_fall'},
		['maps/rp_evocity_dbg_210308/nature/blendgrassdirt01_noprop_wvt_patch'] = {'nature/forest_grass_01_fall'},
		['models/fork/tree_pine04_lowdetail_cluster_card'] = {'fork/tree_pine04_card_fall'},
		['de_cbble/grassdirt_blend'] = {'de_cbble/grassfloor01_fall'},
		['de_cbble/grassfloor01'] = {'de_cbble/grassfloor01_fall'},
		['maps/rp_evocity_dbg_210308/de_cbble/grassdirt_blend_wvt_patch'] = {'de_cbble/grassfloor01_fall'},
	},
}

hook.Add('PlayerFinishedLoading', 'halloween', function()

	local toReplace = maps[game.GetMap()]
	if toReplace then
		for matPath, data in pairs(toReplace) do
			local tex, second = unpack(data)
			local mat = Material(matPath)
			if second then
				mat:SetTexture('$basetexture2', tex)
			else
				mat:SetTexture('$basetexture', tex)
			end
		end
	end

end)
