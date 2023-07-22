AddCSLuaFile()

ParticleListTable = {
	Games = {},
	Addons = {},
}

local doubleslash = "//"


local function AddToParticleListTable(filename,isaddon,icon)

	//Converts a list string, with one item per line, into a table, taking comments and empty strings into account. Returns nil if the table is empty.
	//The format of these tables is item1 = true, item2 = true, etc., not 1 = item1, 2 = item2, etc.; this is so we can use "if table["itemX"] then" to check if a value is inside of it.
	//
	//Instead of the arg being the string itself, the args are 1: the table containing the string, and 2: the key the string can be found at. 
	//This is so we can find continuations of the string, which'll be in the same table, but under separate keys.
	//
	local function ListStringToTable(listcontainer,listname)
		//Find the list string we're looking for inside the container, and explode it into its own table.
		local liststring = listcontainer[listname]
		if type(liststring) != "string" then MsgN("PARTICLE CONTROL ERROR: List string \"" .. listname .. "\" inside of \"" .. filename .. "\" doesn't seem to actually be a string! Check the file and make sure you've formatted everything correctly!") return end
		if #liststring == 4095 then MsgN("PARTICLE CONTROL ERROR: List string \"" .. listname .. "\" inside of \"" .. filename .. "\" is more than 4095 characters long - that's too long for the engine to read all of it! Split it up into multiple lists!") end
		local listtab = string.Explode("\n", liststring)

		//Also find any list strings that are continuations of our main list string, and explode them into the same table.
		for listname2, liststring2 in pairs (listcontainer) do
			if string.StartWith(listname2, listname .. "_cont") then
				if type(liststring) != "string" then MsgN("PARTICLE CONTROL ERROR: List string \"" .. listname2 .. "\" inside of \"" .. filename .. "\" doesn't seem to actually be a string! Check the file and make sure you've formatted everything correctly!") return end
				if #liststring2 == 4095 then MsgN("PARTICLE CONTROL ERROR: List string \"" .. listname2 .. "\" inside of \"" .. filename .. "\" is more than 4095 characters long - that's too long for the engine to read all of it! Split it up into multiple lists!") end
				table.Add(listtab, string.Explode("\n", liststring2) )
			end
		end

		//Finally, filter out any comments or blank spaces from the table.
		local listtabfiltered = {}
		for _, str in pairs (listtab) do
			//if there's a doubleslash in the string then remove it and everything after it
			local commentpos, _ = string.find(str, doubleslash)
			local resultstr = str
			if commentpos then
				resultstr = string.sub( str, 1, commentpos - 1 )
			end

			//trim any spaces from the string, and don't add it to the filtered table if it's just an empty string at this point
			resultstr = string.Trim(resultstr)
			if resultstr != "" then listtabfiltered[resultstr] = true end
		end
		if table.Count(listtabfiltered) > 0 then
			return listtabfiltered
		end
	end

	local filestr = file.Read(filename,"LUA")
	if !filestr then MsgN("PARTICLE CONTROL ERROR: Particle list file \"" .. filename .. "\" doesn't exist or isn't a readable file! Something went wrong!") return end
	local keyvalues = util.KeyValuesToTable( filestr, false, true )
	local resulttable = { Info = {}, Particles = {} }
	if !keyvalues or (table.Count(keyvalues) == 0) then MsgN("PARTICLE CONTROL ERROR: Particle list file \"" .. filename .. "\" isn't a valid keyvalue table and couldn't be read! Check the file and make sure you've formatted everything correctly!") return end
	if !keyvalues.Info then
		//On Mac/Linux systems, the keyvalues-to-table function messes up and returns the keyname "Info" as something else, like "inf", so it's possible that the info subtable is
		//still here, just under a different keyname. The info is the only thing in keyvalues that should be a table value, so we'll check for that:
		local foundinfo = false
		for k, v in pairs (keyvalues) do
			if type(v) == "table" then
				keyvalues.Info = v
				MsgN("(" .. filename .. ": Found Info table under keyname " .. tostring(k) .. ")")
				foundinfo = true
			end
		end
		//If there's no table value in keyvalues at all, then this is a probably a custom file where someone messed up the formatting.
		if !foundinfo then
			MsgN("PARTICLE CONTROL ERROR: Particle list file \"" .. filename .. "\" doesn't have an \"Info\" table that we can find! Check the file and make sure you've formatted everything correctly!")
			return
		end
	end
	if !keyvalues.Info.CategoryName then MsgN("PARTICLE CONTROL ERROR: Particle list file \"" .. filename .. "\"'s Info table doesn't have a \"CategoryName\" string that we can find! Check the file and make sure you've formatted everything correctly!") return end

	resulttable.Info.CategoryName = keyvalues.Info.CategoryName
	resulttable.Info.Icon = icon
	resulttable.Info.EffectOptions = {}
	if keyvalues.Info["EffectOptions"] then
		if keyvalues.Info.EffectOptions["Beams"] then
			resulttable.Info.EffectOptions["Beams"] = ListStringToTable(keyvalues.Info.EffectOptions, "Beams")
		end
		if keyvalues.Info.EffectOptions["Color1"] then
			resulttable.Info.EffectOptions["Color1"] = ListStringToTable(keyvalues.Info.EffectOptions, "Color1")
		end
		if keyvalues.Info.EffectOptions["Color255"] then
			resulttable.Info.EffectOptions["Color255"] = ListStringToTable(keyvalues.Info.EffectOptions, "Color255")
		end
		if keyvalues.Info.EffectOptions["Tracers"] then
			resulttable.Info.EffectOptions["Tracers"] = ListStringToTable(keyvalues.Info.EffectOptions, "Tracers")
		end
	end
	if keyvalues.Info["UtilEffects"] then
		resulttable.Info["UtilEffects"] = keyvalues.Info["UtilEffects"]
	end
	keyvalues.Info = nil


	for k, _ in pairs (keyvalues) do
		if !string.StartWith(k,doubleslash) and string.EndsWith(k, ".pcf") then   //ignore .pcf lists that start with a doubleslash; also ignore lists that don't end with .pcf since these are probably continuations
			local particlelist = ListStringToTable(keyvalues, k)
			if particlelist then
				game.AddParticles("particles/" .. k)
				resulttable.Particles[k] = particlelist
			end
		end
	end


	local subtablename = string.StripExtension( string.GetFileFromFilename(filename) )
	if isaddon then
		MsgN( "PARTICLE CONTROL: Added list for addon: " .. resulttable.Info.CategoryName )
		ParticleListTable.Addons[subtablename] = resulttable
	else
		MsgN( "PARTICLE CONTROL: Added list for game: " .. resulttable.Info.CategoryName )
		ParticleListTable.Games[subtablename] = resulttable
	end

end




//Source Engine / Garry's Mod
	AddToParticleListTable("particlelists/gmod.lua", false, "games/16/garrysmod.png")

//Team Fortress 2
if IsMounted("tf") then
	AddToParticleListTable("particlelists/tf2.lua", false, "games/16/tf.png") end

//Half-Life 2: Episode 1
if IsMounted("episodic") then
	AddToParticleListTable("particlelists/ep1.lua", false, "games/16/episodic.png")
end

//Half-Life 2: Episode 2
if IsMounted("ep2") then
	AddToParticleListTable("particlelists/ep2.lua", false, "games/16/ep2.png")
end

//Portal
if IsMounted("portal") then
	AddToParticleListTable("particlelists/portal.lua", false, "games/16/portal.png")
end

//Counter-Strike: Source
if IsMounted("cstrike") then
	AddToParticleListTable("particlelists/cstrike.lua", false, "games/16/cstrike.png")
end


//Find all list files in the particlelists/addons/ directory, and add them to their own section of the table
local alladdons, _ = file.Find( "lua/particlelists/addons/*.lua", "GAME" )
for _, filename in pairs (alladdons) do
	if !string.StartWith( filename, "_" ) then   //don't add files that start with an _, this is how we stop it from reading the example files
		AddToParticleListTable("particlelists/addons/" .. filename, true, "icon16/bricks.png")
	end
end




if CLIENT then

	//Favorites - this table is global because it's used by every Particle Browser panel on the client
	ParticleBrowserFavorites = {
		Effects = {},   //effects in the favorites list
		Children = {},  //all DTreeNode panels that are using this favorites list
	}

	local parctrlfavs_str = file.Read("particlecontrol_favorites.txt","DATA")
	if parctrlfavs_str then ParticleBrowserFavorites.Effects = util.JSONToTable(parctrlfavs_str) end


	function ParticleBrowserFavorites_UpdateEffect( effectdisplay, effectoptions )

		if effectoptions then
			//We're adding the effect
			ParticleBrowserFavorites.Effects[effectdisplay] = effectoptions
		else
			//We're removing the effect
			ParticleBrowserFavorites.Effects[effectdisplay] = nil
		end

		for _, panel in pairs (ParticleBrowserFavorites.Children) do
			if panel then
				ParticleBrowserFavorites_UpdateChildPanel( panel )
			end
		end

		file.Write( "particlecontrol_favorites.txt", util.TableToJSON(ParticleBrowserFavorites.Effects, true) )

	end


	function ParticleBrowserFavorites_UpdateChildPanel( panel )

		if !panel then return end

		if panel.FavoriteNodes then
			//Remove all of the nodes from the panel
			for k, node in pairs (panel.FavoriteNodes) do
				node:Remove()
				panel.FavoriteNodes[k] = nil
			end
		else
			panel.FavoriteNodes = {}
		end

		for effectdisplay, effectoptions in SortedPairs (ParticleBrowserFavorites.Effects) do
			local effect = effectoptions["InternalName"]

			panel.FavoriteNodes[effect] = panel:AddNode(effectdisplay)

			panel.FavoriteNodes[effect].EffectOptions = {}
			if effectoptions["Beam"] then 
				panel.FavoriteNodes[effect].EffectOptions["Beam"] = true 
			end
			if effectoptions["Colorable"] then 
				panel.FavoriteNodes[effect].EffectOptions["Colorable"] = true
			end
			if effectoptions["ColorOutOfOne"] then
				panel.FavoriteNodes[effect].EffectOptions["ColorOutOfOne"] = true
			end

			//Don't use the icons for features we're not using
			local beamicon = ( (panel.CommandInfo.mode_beam) and (panel.FavoriteNodes[effect].EffectOptions["Beam"] == true) )
			local coloricon = ( (panel.CommandInfo.color) and (panel.FavoriteNodes[effect].EffectOptions["Colorable"] == true) )
			//Set the effect icon:
			if beamicon and coloricon then
				panel.FavoriteNodes[effect].Icon:SetImage("icon16/fire_line_rainbow.png")
			elseif beamicon then
				panel.FavoriteNodes[effect].Icon:SetImage("icon16/fire_line.png")
			elseif coloricon then
				panel.FavoriteNodes[effect].Icon:SetImage("icon16/fire_rainbow.png")
			else
				panel.FavoriteNodes[effect].Icon:SetImage("icon16/fire.png")
			end

			panel.FavoriteNodes[effect].DoClick = function() 
				RunConsoleCommand( panel.CommandInfo.effectname, effect )

				if panel.CommandInfo.mode_beam then
					if panel.FavoriteNodes[effect].EffectOptions["Beam"] then
						RunConsoleCommand( panel.CommandInfo.mode_beam, "1" )
					else
						RunConsoleCommand( panel.CommandInfo.mode_beam, "0" )
					end
				end

				if panel.CommandInfo.color then
					if panel.FavoriteNodes[effect].EffectOptions["Colorable"] then
						RunConsoleCommand( panel.CommandInfo.color .. "_enabled", "1" )
					else
						RunConsoleCommand( panel.CommandInfo.color .. "_enabled", "0" )
					end

					if panel.FavoriteNodes[effect].EffectOptions["ColorOutOfOne"] then
						RunConsoleCommand( panel.CommandInfo.color .. "_outofone", "1" )
					else
						RunConsoleCommand( panel.CommandInfo.color .. "_outofone", "0" )
					end
				end
			end

			panel.FavoriteNodes[effect].DoRightClick = function()
				//We only need the remove option here, since it's already in the favorites list
				local menu = DermaMenu()

				local option = menu:AddOption( "Un-favorite \'\'" .. effectdisplay .. "\'\'", function()
					ParticleBrowserFavorites_UpdateEffect( effectdisplay )  //calling this function with no second arg tells it to remove this effect from the list
				end )
				option:SetImage("icon16/delete.png")

				menu:Open()
			end
		end

	end




	function AddParticleBrowser(panel,data)

		local self = {}

		//Data table contents:
		//{
		//name = "Effect" (name to show at the top of the panel)
		//commands =   (table of concommands that the panel uses)
		//	{
		//	effectname = "particlecontrol_effectname"
		//	mode_beam = "particlecontrol_mode_beam" (optional)
		//	color = "particlecontrol_color" (optional, assumes there are cvars derived from this name (X_enabled, X_r, X_g, X_b, X_outofone) )
		//	utileffect = "particlecontrol_utileffect" (optional, assumes there are cvars derived from this name (X_scale, X_magnitude, X_radius) )
		//
		//	enabled = "particlecontrol_enabled" (optional - toggles whether or not the panel is open using this cvar)
		//	}
		//}

		self.back = vgui.Create("DForm", panel)
		self.back:SetLabel(data.name)
		self.back.Paint = function()
			derma.SkinHook( "Paint", "CollapsibleCategory", self.back, self.back:GetWide(), self.back:GetTall() )
			surface.SetDrawColor( Color(0,0,0,70) )
				surface.DrawRect( 0, 0, self.back:GetWide(), self.back:GetTall() )
		end
		self.back.Header:SetImage("icon16/fire.png")
		self.back.Header.DoClick = function() end
		panel:AddPanel(self.back)




		self.tree = vgui.Create("DTree", self.back)
		self.tree:SetHeight(400)
		self.back:AddItem(self.tree)
		self.tree:GetParent():DockPadding(5,5,5,0)

		local function PopulateEffectList(parent, effectstab, effectoptions)
			for k, v in SortedPairs (effectstab) do
				local effect = k
				local effectdisplay = k
				//if v is another string instead of just a filler "true" value, then that means k is the display name and v is the internal name
				if isstring(v) then
					effect = v
				end

				parent[effect] = parent:AddNode(effectdisplay)

				parent[effect].EffectOptions = {}
				if effectoptions["Beams"] and effectoptions["Beams"][effect] then 
					parent[effect].EffectOptions["Beam"] = true 
				end
				if effectoptions["Color1"] and effectoptions["Color1"][effect] then 
					parent[effect].EffectOptions["Colorable"] = true
					parent[effect].EffectOptions["ColorOutOfOne"] = true
				end
				if effectoptions["Color255"] and effectoptions["Color255"][effect] then
					parent[effect].EffectOptions["Colorable"] = true
					parent[effect].EffectOptions["ColorOutOfOne"] = false
				end

				//Don't use the icons for features we're not using
				local beamicon = ( (data.commands.mode_beam) and (parent[effect].EffectOptions["Beam"] == true) )
				local coloricon = ( (data.commands.color) and (parent[effect].EffectOptions["Colorable"] == true) )
				//Set the effect icon:
				if beamicon and coloricon then
					parent[effect].Icon:SetImage("icon16/fire_line_rainbow.png")
				elseif beamicon then
					parent[effect].Icon:SetImage("icon16/fire_line.png")
				elseif coloricon then
					parent[effect].Icon:SetImage("icon16/fire_rainbow.png")
				else
					parent[effect].Icon:SetImage("icon16/fire.png")
				end

				//Left Click: Select the effect by setting its concommands
				parent[effect].DoClick = function() 
					RunConsoleCommand( data.commands.effectname, effect )

					if data.commands.mode_beam then
						if parent[effect].EffectOptions["Beam"] then
							RunConsoleCommand( data.commands.mode_beam, "1" )
						else
							RunConsoleCommand( data.commands.mode_beam, "0" )
						end
					end

					if data.commands.color then
						if parent[effect].EffectOptions["Colorable"] then
							RunConsoleCommand( data.commands.color .. "_enabled", "1" )
						else
							RunConsoleCommand( data.commands.color .. "_enabled", "0" )
						end

						if parent[effect].EffectOptions["ColorOutOfOne"] then
							RunConsoleCommand( data.commands.color .. "_outofone", "1" )
						else
							RunConsoleCommand( data.commands.color .. "_outofone", "0" )
						end
					end
				end

				//Right Click: Display an option to add/remove the effect from favorites
				parent[effect].DoRightClick = function()
					local menu = DermaMenu()

					if !ParticleBrowserFavorites.Effects[effectdisplay] then
						local option = menu:AddOption( "Favorite \'\'" .. effectdisplay .. "\'\'", function()
							ParticleBrowserFavorites_UpdateEffect( effectdisplay, {
								["InternalName"] = effect,
								["Beam"] = tobool(parent[effect].EffectOptions["Beam"]),
								["Colorable"] = tobool(parent[effect].EffectOptions["Colorable"]),
								["ColorOutOfOne"] = tobool(parent[effect].EffectOptions["ColorOutOfOne"]),
							} )
						end )
						option:SetImage("icon16/add.png")
					else
						local option = menu:AddOption( "Un-favorite \'\'" .. effectdisplay .. "\'\'", function()
							ParticleBrowserFavorites_UpdateEffect( effectdisplay )  //calling this function with no second arg tells it to remove this effect from the list
						end )
						option:SetImage("icon16/delete.png")
					end

					menu:Open()
				end
			end
		end
		
		//Games
		self.tree.games = self.tree:AddNode("Games")
		self.tree.games.Icon:SetImage("icon16/folder_database.png")
		self.tree.games:SetExpanded(true)
		//
		for tabname, tab in SortedPairs (ParticleListTable.Games) do
			self.tree.games[tabname] = self.tree.games:AddNode(tab.Info.CategoryName)
			self.tree.games[tabname].Icon:SetImage(tab.Info.Icon)

			//Create the utilfx list
			if tab.Info.UtilEffects then
				self.tree.games[tabname].UtilEffects = self.tree.games[tabname]:AddNode("Scripted Effects")
				self.tree.games[tabname].UtilEffects.Icon:SetImage("icon16/page_gear.png")

				self.tree.games[tabname].UtilEffects.IsPopulated = false
				self.tree.games[tabname].UtilEffects.DoClick = function()
					if self.tree.games[tabname].UtilEffects.IsPopulated == true then return end

					PopulateEffectList(self.tree.games[tabname].UtilEffects, tab.Info.UtilEffects, tab.Info.EffectOptions)

					self.tree.games[tabname].UtilEffects.IsPopulated = true
					self.tree.games[tabname].UtilEffects:SetExpanded(true)
				end
			end

			//Create the .pcf lists
			for pcfname, particles in SortedPairs (tab.Particles) do
				local pcftabname = string.StripExtension(pcfname)  //just in case having a dot in the key name causes problems
				self.tree.games[tabname][pcftabname] = self.tree.games[tabname]:AddNode(pcfname)
				self.tree.games[tabname][pcftabname].Icon:SetImage("icon16/page.png")

				self.tree.games[tabname][pcftabname].IsPopulated = false
				self.tree.games[tabname][pcftabname].DoClick = function()
					if self.tree.games[tabname][pcftabname].IsPopulated == true then return end

					PopulateEffectList(self.tree.games[tabname][pcftabname], particles, tab.Info.EffectOptions)

					self.tree.games[tabname][pcftabname].IsPopulated = true
					self.tree.games[tabname][pcftabname]:SetExpanded(true)
				end
			end
		end

		//Addons
		self.tree.addons = self.tree:AddNode("Addons")
		self.tree.addons.Icon:SetImage("icon16/folder_database.png")
		self.tree.addons:SetExpanded(true)
		//
		for tabname, tab in SortedPairs (ParticleListTable.Addons) do
			self.tree.addons[tabname] = self.tree.addons:AddNode(tab.Info.CategoryName)
			self.tree.addons[tabname].Icon:SetImage(tab.Info.Icon)

			//Create the utilfx list
			if tab.Info.UtilEffects then
				self.tree.addons[tabname].UtilEffects = self.tree.addons[tabname]:AddNode("Scripted Effects")
				self.tree.addons[tabname].UtilEffects.Icon:SetImage("icon16/page_gear.png")

				self.tree.addons[tabname].UtilEffects.IsPopulated = false
				self.tree.addons[tabname].UtilEffects.DoClick = function()
					if self.tree.addons[tabname].UtilEffects.IsPopulated == true then return end

					PopulateEffectList(self.tree.addons[tabname].UtilEffects, tab.Info.UtilEffects, tab.Info.EffectOptions)

					self.tree.addons[tabname].UtilEffects.IsPopulated = true
					self.tree.addons[tabname].UtilEffects:SetExpanded(true)
				end
			end

			//Create the .pcf lists
			for pcfname, particles in SortedPairs (tab.Particles) do
				local pcftabname = string.StripExtension(pcfname)  //just in case having a dot in the key name causes problems
				self.tree.addons[tabname][pcftabname] = self.tree.addons[tabname]:AddNode(pcfname)
				self.tree.addons[tabname][pcftabname].Icon:SetImage("icon16/page.png")

				self.tree.addons[tabname][pcftabname].IsPopulated = false
				self.tree.addons[tabname][pcftabname].DoClick = function()
					if self.tree.addons[tabname][pcftabname].IsPopulated == true then return end

					PopulateEffectList(self.tree.addons[tabname][pcftabname], particles, tab.Info.EffectOptions)

					self.tree.addons[tabname][pcftabname].IsPopulated = true
					self.tree.addons[tabname][pcftabname]:SetExpanded(true)
				end
			end
		end

		//Favorites
		self.tree.favorites = self.tree:AddNode("Favorites")
		self.tree.favorites.Icon:SetImage("icon16/star.png")
		self.tree.favorites:SetExpanded(true)
		//
		table.insert( ParticleBrowserFavorites.Children, self.tree.favorites )   //Add it to the Favorites table's list of child panels and let it do the rest of the work
		self.tree.favorites.CommandInfo = data.commands				 //Store the console command info in the panel so the UpdateChildPanel function can access it
		ParticleBrowserFavorites_UpdateChildPanel( self.tree.favorites )




		self.effectnameentry = vgui.Create( "DTextEntry", self.back )
		self.effectnameentry:SetConVar( data.commands.effectname )
		self.back:AddItem(self.effectnameentry)
		self.effectnameentry:GetParent():DockPadding(5,5,5,10)




		if data.commands.mode_beam then
			self.beam = vgui.Create("DForm", self.back)
			self.beam.Paint = function()
				derma.SkinHook( "Paint", "CollapsibleCategory", self.beam, self.beam:GetWide(), self.beam:GetTall() )
				surface.SetDrawColor( Color(0,0,0,110) )
					surface.DrawRect( 0, 0, self.beam:GetWide(), self.beam:GetTall() )
			end
			self.beam:Dock(TOP)
			self.back:AddItem(self.beam)
			self.beam:GetParent():DockPadding(5,0,5,0)

			//Modify the header and tweak things so it doesn't show up when the category is closed.
			self.beam.Header:SetText( "Beam" )
			self.beam.Header:SetImage("icon16/fire_line.png")
			self.beam.Header.DoClick = function() end
			self.beam.PerformLayout = function()
				local us = self.beam	//so when we copy this over to another dform we only have to change this one line
				local Padding = us:GetPadding() or 0
				if ( us.Contents ) then
					if ( us:GetExpanded() ) then
						us.Contents:InvalidateLayout( true )
						us.Contents:SetVisible( true )
					else
						us.Contents:SetVisible( false )
					end
				end
				if ( us:GetExpanded() ) then
					us:SizeToChildren( false, true )
				else
					us:SetTall(0)	//this is the only real change from the standard DForm:PerformLayout()
				end	
				-- Make sure the color of header text is set
				us.Header:ApplySchemeSettings()
				us.animSlide:Run()
				us:UpdateAltLines();
			end

			self.beam.text = vgui.Create("DLabel", self.beam)
			self.beam.text:SetColor( Color(60,60,60,255) )
			self.beam.text:SetText("This effect attaches to two points.")
			self.beam.text:SetWrap( true )
			self.beam.text:SetAutoStretchVertical( true )
			self.beam.text:Dock(TOP)
			self.beam.text:SizeToContents()
			self.beam:AddItem(self.beam.text)
			self.beam.text:GetParent():DockPadding( 15, 10, 15, 10 )
		end




		if data.commands.color then
			self.color = vgui.Create("DForm", self.back)
			self.color.Paint = function()
				derma.SkinHook( "Paint", "CollapsibleCategory", self.color, self.color:GetWide(), self.color:GetTall() )
				surface.SetDrawColor( Color(0,0,0,110) )
					surface.DrawRect( 0, 0, self.color:GetWide(), self.color:GetTall() )
			end
			self.color:Dock(TOP)
			self.back:AddItem(self.color)
			self.color:GetParent():DockPadding(5,0,5,0)

			//Modify the header and tweak things so it doesn't show up when the category is closed.
			self.color.Header:SetText( "Colorable" )
			self.color.Header:SetImage("icon16/fire_rainbow.png")
			self.color.Header.DoClick = function() end
			self.color.PerformLayout = function()
				local us = self.color	//so when we copy this over to another dform we only have to change this one line
				local Padding = us:GetPadding() or 0
				if ( us.Contents ) then
					if ( us:GetExpanded() ) then
						us.Contents:InvalidateLayout( true )
						us.Contents:SetVisible( true )
					else
						us.Contents:SetVisible( false )
					end
				end
				if ( us:GetExpanded() ) then
					us:SizeToChildren( false, true )
				else
					us:SetTall(0)	//this is the only real change from the standard DForm:PerformLayout()
				end	
				-- Make sure the color of header text is set
				us.Header:ApplySchemeSettings()
				us.animSlide:Run()
				us:UpdateAltLines();
			end

			self.color.text = vgui.Create("DLabel", self.color)
			self.color.text:SetColor( Color(60,60,60,255) )
			self.color.text:SetText("This effect is colorable.")
			self.color.text:SetWrap( true )
			self.color.text:SetAutoStretchVertical( true )
			self.color.text:Dock(TOP)
			self.color.text:SizeToContents()
			self.color:AddItem(self.color.text)
			self.color.text:GetParent():DockPadding( 15, 10, 15, 10 )


			self.color.selection = vgui.Create( "CtrlColor", self.color )
			self.color.selection:SetLabel( "" )
			self.color.selection:SetConVarR( data.commands.color .. "_r" )
			self.color.selection:SetConVarG( data.commands.color .. "_g" )
			self.color.selection:SetConVarB( data.commands.color .. "_b" )
			self.color.selection:SetConVarA( nil )
			self.color.selection:Dock(TOP)
			self.color:AddItem(self.color.selection)
			self.color.selection:GetParent():DockPadding( 10, 0, 10, 10 )
		end




		if data.commands.utileffect then
			self.utilfx = vgui.Create("DForm", self.back)
			self.utilfx.Paint = function()
				derma.SkinHook( "Paint", "CollapsibleCategory", self.utilfx, self.utilfx:GetWide(), self.utilfx:GetTall() )
				surface.SetDrawColor( Color(0,0,0,110) )
					surface.DrawRect( 0, 0, self.utilfx:GetWide(), self.utilfx:GetTall() )
			end
			self.utilfx:Dock(TOP)
			self.back:AddItem(self.utilfx)
			self.utilfx:GetParent():DockPadding(5,0,5,0)

			//Modify the header and tweak things so it doesn't show up when the category is closed.
			self.utilfx.Header:SetText( "Scripted Effect" )
			self.utilfx.Header:SetImage("icon16/cog.png")
			self.utilfx.Header.DoClick = function() end
			self.utilfx.PerformLayout = function()
				local us = self.utilfx	//so when we copy this over to another dform we only have to change this one line
				local Padding = us:GetPadding() or 0
				if ( us.Contents ) then
					if ( us:GetExpanded() ) then
						us.Contents:InvalidateLayout( true )
						us.Contents:SetVisible( true )
					else
						us.Contents:SetVisible( false )
					end
				end
				if ( us:GetExpanded() ) then
					us:SizeToChildren( false, true )
				else
					us:SetTall(0)	//this is the only real change from the standard DForm:PerformLayout()
				end	
				-- Make sure the color of header text is set
				us.Header:ApplySchemeSettings()
				us.animSlide:Run()
				us:UpdateAltLines();
			end

			self.utilfx.text = vgui.Create("DLabel", self.utilfx)
			self.utilfx.text:SetColor( Color(60,60,60,255) )
			self.utilfx.text:SetText("These options can be used to modify certain scripted effects in different ways depending on the effect being used.")
			self.utilfx.text:SetWrap( true )
			self.utilfx.text:SetAutoStretchVertical( true )
			self.utilfx.text:Dock(TOP)
			self.utilfx.text:SizeToContents()
			self.utilfx:AddItem(self.utilfx.text)
			self.utilfx.text:GetParent():DockPadding( 15, 10, 15, 5 )


			self.utilfx.slider1 = vgui.Create( "DNumSlider", self.utilfx )
			self.utilfx.slider1:SetText( "Util.Effect Scale" )
			self.utilfx.slider1:SetMinMax(0.2, 10)
			self.utilfx.slider1:SetDecimals(2)
			self.utilfx.slider1:SetConVar( data.commands.utileffect .. "_scale" )
			self.utilfx.slider1:SetHeight(15)
			self.utilfx.slider1:SizeToContents()
			self.utilfx.slider1:SetDark(true)
			self.utilfx:AddItem(self.utilfx.slider1)

			self.utilfx.slider2 = vgui.Create( "DNumSlider", self.utilfx )
			self.utilfx.slider2:SetText( "Util.Effect Magnitude" )
			self.utilfx.slider2:SetMinMax(1, 10)
			self.utilfx.slider2:SetDecimals(2)
			self.utilfx.slider2:SetConVar( data.commands.utileffect .. "_magnitude" )
			self.utilfx.slider2:SetHeight(15)
			self.utilfx.slider2:SizeToContents()
			self.utilfx.slider2:SetDark(true)
			self.utilfx:AddItem(self.utilfx.slider2)

			self.utilfx.slider3 = vgui.Create( "DNumSlider", self.utilfx )
			self.utilfx.slider3:SetText( "Util.Effect Radius" )
			self.utilfx.slider3:SetMinMax(10, 1000)
			self.utilfx.slider3:SetDecimals(2)
			self.utilfx.slider3:SetConVar( data.commands.utileffect .. "_radius" )
			self.utilfx.slider3:SetHeight(15)
			self.utilfx.slider3:SizeToContents()
			self.utilfx.slider3:SetDark(true)
			self.utilfx:AddItem(self.utilfx.slider3)
		end




		self.back.Think = function()
			if self.beam then
				if GetConVarNumber( data.commands.mode_beam ) > 0 then
					//expand it
					if self.beam:GetExpanded() == false then self.beam:Toggle() end
				else
					//contract it
					if self.beam:GetExpanded() == true then self.beam:Toggle() end
					self.beam:GetParent():SetTall(self.beam:GetTall())
				end
			end
			if self.color then
				if GetConVarNumber( data.commands.color .. "_enabled" ) > 0 then
					//expand it
					if self.color:GetExpanded() == false then self.color:Toggle() end
				else
					//contract it
					if self.color:GetExpanded() == true then self.color:Toggle() end
					self.color:GetParent():SetTall(self.color:GetTall())
				end
			end
			if self.utilfx then
				if string.StartWith( GetConVarString(data.commands.effectname), "!UTILEFFECT!" ) then
					//expand it
					if self.utilfx:GetExpanded() == false then self.utilfx:Toggle() end
				else
					//contract it
					if self.utilfx:GetExpanded() == true then self.utilfx:Toggle() end
					self.utilfx:GetParent():SetTall(self.utilfx:GetTall())
				end
			end


			if data.commands.enabled then
				if GetConVarNumber( data.commands.enabled ) > 0 then
					//expand it
					if self.back:GetExpanded() == false then self.back:Toggle() end
				else
					//contract it
					if self.back:GetExpanded() == true then self.back:Toggle() end
				end
			end
		end
		
	end













	//Favorites - this table is global too because this is all copied over from the standard Particle Browser, even though I don't suspect we'll ever have more than one of these
	ParticleBrowserTracerFavorites = {
		Effects = {},   //effects in the favorites list
		Children = {},  //all DTreeNode panels that are using this favorites list
	}

	local parctrltracerfavs_str = file.Read("particlecontrol_favorites_tracer.txt","DATA")
	if parctrltracerfavs_str then ParticleBrowserTracerFavorites.Effects = util.JSONToTable(parctrltracerfavs_str) end


	function ParticleBrowserTracerFavorites_UpdateEffect( effectdisplay, effectoptions )

		if effectoptions then
			//We're adding the effect
			ParticleBrowserTracerFavorites.Effects[effectdisplay] = effectoptions
		else
			//We're removing the effect
			ParticleBrowserTracerFavorites.Effects[effectdisplay] = nil
		end

		for _, panel in pairs (ParticleBrowserTracerFavorites.Children) do
			if panel then
				ParticleBrowserTracerFavorites_UpdateChildPanel( panel )
			end
		end

		file.Write( "particlecontrol_favorites_tracer.txt", util.TableToJSON(ParticleBrowserTracerFavorites.Effects, true) )

	end


	function ParticleBrowserTracerFavorites_UpdateChildPanel( panel )

		if !panel then return end

		if panel.FavoriteNodes then
			//Remove all of the nodes from the panel
			for k, node in pairs (panel.FavoriteNodes) do
				node:Remove()
				panel.FavoriteNodes[k] = nil
			end
		else
			panel.FavoriteNodes = {}
		end

		for effectdisplay, effectoptions in SortedPairs (ParticleBrowserTracerFavorites.Effects) do
			local effect = effectoptions["InternalName"]

			panel.FavoriteNodes[effect] = panel:AddNode(effectdisplay)

			panel.FavoriteNodes[effect].EffectOptions = {}
			if effectoptions["Colorable"] then 
				panel.FavoriteNodes[effect].EffectOptions["Colorable"] = true
			end
			if effectoptions["ColorOutOfOne"] then
				panel.FavoriteNodes[effect].EffectOptions["ColorOutOfOne"] = true
			end

			//Don't use the icons for features we're not using
			local coloricon = ( (panel.CommandInfo.color) and (panel.FavoriteNodes[effect].EffectOptions["Colorable"] == true) )
			//Set the effect icon:
			if coloricon then
				panel.FavoriteNodes[effect].Icon:SetImage("icon16/fire_line_rainbow.png")
			else
				panel.FavoriteNodes[effect].Icon:SetImage("icon16/fire_line.png")
			end

			panel.FavoriteNodes[effect].DoClick = function() 
				RunConsoleCommand( panel.CommandInfo.effectname, effect )

				if panel.CommandInfo.color then
					if panel.FavoriteNodes[effect].EffectOptions["Colorable"] then
						RunConsoleCommand( panel.CommandInfo.color .. "_enabled", "1" )
					else
						RunConsoleCommand( panel.CommandInfo.color .. "_enabled", "0" )
					end

					if panel.FavoriteNodes[effect].EffectOptions["ColorOutOfOne"] then
						RunConsoleCommand( panel.CommandInfo.color .. "_outofone", "1" )
					else
						RunConsoleCommand( panel.CommandInfo.color .. "_outofone", "0" )
					end
				end
			end

			panel.FavoriteNodes[effect].DoRightClick = function()
				//We only need the remove option here, since it's already in the favorites list
				local menu = DermaMenu()

				local option = menu:AddOption( "Un-favorite \'\'" .. effectdisplay .. "\'\'", function()
					ParticleBrowserTracerFavorites_UpdateEffect( effectdisplay )  //calling this function with no second arg tells it to remove this effect from the list
				end )
				option:SetImage("icon16/delete.png")

				menu:Open()
			end
		end

	end




	function AddParticleBrowserTracer(panel,data)

		local self = {}

		//Data table contents:
		//{
		//name = "Effect" (name to show at the top of the panel)
		//commands =   (table of concommands that the panel uses)
		//	{
		//	effectname = "particlecontrol_effectname"
		//	color = "particlecontrol_color" (optional, assumes there are cvars derived from this name (X_enabled, X_r, X_g, X_b, X_outofone) )
		//	}
		//}

		self.back = vgui.Create("DForm", panel)
		self.back:SetLabel(data.name)
		self.back.Paint = function()
			derma.SkinHook( "Paint", "CollapsibleCategory", self.back, self.back:GetWide(), self.back:GetTall() )
			surface.SetDrawColor( Color(0,0,0,70) )
				surface.DrawRect( 0, 0, self.back:GetWide(), self.back:GetTall() )
		end
		self.back.Header:SetImage("icon16/fire.png")
		self.back.Header.DoClick = function() end
		panel:AddPanel(self.back)




		self.tree = vgui.Create("DTree", self.back)
		self.tree:SetHeight(400)
		self.back:AddItem(self.tree)
		self.tree:GetParent():DockPadding(5,5,5,0)

		local function PopulateEffectList(parent, effectstab, effectoptions)
			for k, v in SortedPairs (effectstab) do
				local effect = k
				local effectdisplay = k
				//if v is another string instead of just a filler "true" value, then that means k is the display name and v is the internal name
				if isstring(v) then
					effect = v
				end

				parent[effect] = parent:AddNode(effectdisplay)

				parent[effect].EffectOptions = {}
				if effectoptions["Color1"] and effectoptions["Color1"][effect] then 
					parent[effect].EffectOptions["Colorable"] = true
					parent[effect].EffectOptions["ColorOutOfOne"] = true
				end
				if effectoptions["Color255"] and effectoptions["Color255"][effect] then
					parent[effect].EffectOptions["Colorable"] = true
					parent[effect].EffectOptions["ColorOutOfOne"] = false
				end

				//Don't use the icons for features we're not using
				local coloricon = ( (data.commands.color) and (parent[effect].EffectOptions["Colorable"] == true) )
				//Set the effect icon:
				if coloricon then
					parent[effect].Icon:SetImage("icon16/fire_line_rainbow.png")
				else
					parent[effect].Icon:SetImage("icon16/fire_line.png")
				end

				//Left Click: Select the effect by setting its concommands
				parent[effect].DoClick = function() 
					RunConsoleCommand( data.commands.effectname, effect )

					if data.commands.color then
						if parent[effect].EffectOptions["Colorable"] then
							RunConsoleCommand( data.commands.color .. "_enabled", "1" )
						else
							RunConsoleCommand( data.commands.color .. "_enabled", "0" )
						end

						if parent[effect].EffectOptions["ColorOutOfOne"] then
							RunConsoleCommand( data.commands.color .. "_outofone", "1" )
						else
							RunConsoleCommand( data.commands.color .. "_outofone", "0" )
						end
					end
				end

				//Right Click: Display an option to add/remove the effect from favorites
				parent[effect].DoRightClick = function()
					local menu = DermaMenu()

					if !ParticleBrowserTracerFavorites.Effects[effectdisplay] then
						local option = menu:AddOption( "Favorite \'\'" .. effectdisplay .. "\'\'", function()
							ParticleBrowserTracerFavorites_UpdateEffect( effectdisplay, {
								["InternalName"] = effect,
								["Colorable"] = tobool(parent[effect].EffectOptions["Colorable"]),
								["ColorOutOfOne"] = tobool(parent[effect].EffectOptions["ColorOutOfOne"]),
							} )
						end )
						option:SetImage("icon16/add.png")
					else
						local option = menu:AddOption( "Un-favorite \'\'" .. effectdisplay .. "\'\'", function()
							ParticleBrowserTracerFavorites_UpdateEffect( effectdisplay )  //calling this function with no second arg tells it to remove this effect from the list
						end )
						option:SetImage("icon16/delete.png")
					end

					menu:Open()
				end
			end
		end

		//Games
		self.tree.games = self.tree:AddNode("Games")
		self.tree.games.Icon:SetImage("icon16/folder_database.png")
		self.tree.games:SetExpanded(true)
		//
		for tabname, tab in SortedPairs (ParticleListTable.Games) do
			if tab.Info.EffectOptions.Tracers then
				self.tree.games[tabname] = self.tree.games:AddNode(tab.Info.CategoryName)
				self.tree.games[tabname].Icon:SetImage(tab.Info.Icon)

				//Create the utilfx list
				if tab.Info.UtilEffects then
					local tracerlist = {}
					for k, v in pairs (tab.Info.UtilEffects) do
						//in a utileffect table, the effect name is stored in the value
						if tab.Info.EffectOptions.Tracers[v] then tracerlist[k] = v end
					end
					if table.Count(tracerlist) > 0 then
						self.tree.games[tabname].UtilEffects = self.tree.games[tabname]:AddNode("Scripted Effects")
						self.tree.games[tabname].UtilEffects.Icon:SetImage("icon16/page_gear.png")

						self.tree.games[tabname].UtilEffects.IsPopulated = false
						self.tree.games[tabname].UtilEffects.DoClick = function()
							if self.tree.games[tabname].UtilEffects.IsPopulated == true then return end

							PopulateEffectList(self.tree.games[tabname].UtilEffects, tracerlist, tab.Info.EffectOptions)

							self.tree.games[tabname].UtilEffects.IsPopulated = true
							self.tree.games[tabname].UtilEffects:SetExpanded(true)
						end
					end
				end

				//Create the .pcf lists
				for pcfname, particles in SortedPairs (tab.Particles) do
					local tracerlist = {}
					for k, v in pairs (particles) do
						//in a particle table, the effect name is stored in the key
						if tab.Info.EffectOptions.Tracers[k] then tracerlist[k] = v end
					end
					if table.Count(tracerlist) > 0 then
						local pcftabname = string.StripExtension(pcfname)  //just in case having a dot in the key name causes problems
						self.tree.games[tabname][pcftabname] = self.tree.games[tabname]:AddNode(pcfname)
						self.tree.games[tabname][pcftabname].Icon:SetImage("icon16/page.png")

						self.tree.games[tabname][pcftabname].IsPopulated = false
						self.tree.games[tabname][pcftabname].DoClick = function()
							if self.tree.games[tabname][pcftabname].IsPopulated == true then return end

							PopulateEffectList(self.tree.games[tabname][pcftabname], tracerlist, tab.Info.EffectOptions)

							self.tree.games[tabname][pcftabname].IsPopulated = true
							self.tree.games[tabname][pcftabname]:SetExpanded(true)
						end
					end
				end
			end
		end

		//Addons
		self.tree.addons = self.tree:AddNode("Addons")
		self.tree.addons.Icon:SetImage("icon16/folder_database.png")
		self.tree.addons:SetExpanded(true)
		//
		for tabname, tab in SortedPairs (ParticleListTable.Addons) do
			if tab.Info.EffectOptions.Tracers then
				self.tree.addons[tabname] = self.tree.addons:AddNode(tab.Info.CategoryName)
				self.tree.addons[tabname].Icon:SetImage(tab.Info.Icon)

				//Create the utilfx list
				if tab.Info.UtilEffects then
					local tracerlist = {}
					for k, v in pairs (tab.Info.UtilEffects) do
						//in a utileffect table, the effect name is stored in the value
						if tab.Info.EffectOptions.Tracers[v] then tracerlist[k] = v end
					end
					if table.Count(tracerlist) > 0 then
						self.tree.addons[tabname].UtilEffects = self.tree.addons[tabname]:AddNode("Scripted Effects")
						self.tree.addons[tabname].UtilEffects.Icon:SetImage("icon16/page_gear.png")

						self.tree.addons[tabname].UtilEffects.IsPopulated = false
						self.tree.addons[tabname].UtilEffects.DoClick = function()
							if self.tree.addons[tabname].UtilEffects.IsPopulated == true then return end

							PopulateEffectList(self.tree.addons[tabname].UtilEffects, tracerlist, tab.Info.EffectOptions)

							self.tree.addons[tabname].UtilEffects.IsPopulated = true
							self.tree.addons[tabname].UtilEffects:SetExpanded(true)
						end
					end
				end

				//Create the .pcf lists
				for pcfname, particles in SortedPairs (tab.Particles) do
					local tracerlist = {}
					for k, v in pairs (particles) do
						//in a particle table, the effect name is stored in the key
						if tab.Info.EffectOptions.Tracers[k] then tracerlist[k] = v end
					end
					if table.Count(tracerlist) > 0 then
						local pcftabname = string.StripExtension(pcfname)  //just in case having a dot in the key name causes problems
						self.tree.addons[tabname][pcftabname] = self.tree.addons[tabname]:AddNode(pcfname)
						self.tree.addons[tabname][pcftabname].Icon:SetImage("icon16/page.png")

						self.tree.addons[tabname][pcftabname].IsPopulated = false
						self.tree.addons[tabname][pcftabname].DoClick = function()
							if self.tree.addons[tabname][pcftabname].IsPopulated == true then return end

							PopulateEffectList(self.tree.addons[tabname][pcftabname], tracerlist, tab.Info.EffectOptions)

							self.tree.addons[tabname][pcftabname].IsPopulated = true
							self.tree.addons[tabname][pcftabname]:SetExpanded(true)
						end
					end
				end
			end
		end

		//Favorites
		self.tree.favorites = self.tree:AddNode("Favorites (Tracers)")
		self.tree.favorites.Icon:SetImage("icon16/star.png")
		self.tree.favorites:SetExpanded(true)
		//
		table.insert( ParticleBrowserTracerFavorites.Children, self.tree.favorites )   //Add it to the Favorites table's list of child panels and let it do the rest of the work
		self.tree.favorites.CommandInfo = data.commands					   //Store the console command info in the panel so the UpdateChildPanel function can access it
		ParticleBrowserTracerFavorites_UpdateChildPanel( self.tree.favorites )




		self.effectnameentry = vgui.Create( "DTextEntry", self.back )
		self.effectnameentry:SetConVar( data.commands.effectname )
		self.back:AddItem(self.effectnameentry)
		self.effectnameentry:GetParent():DockPadding(5,5,5,10)




		if data.commands.color then
			self.color = vgui.Create("DForm", self.back)
			self.color.Paint = function()
				derma.SkinHook( "Paint", "CollapsibleCategory", self.color, self.color:GetWide(), self.color:GetTall() )
				surface.SetDrawColor( Color(0,0,0,110) )
					surface.DrawRect( 0, 0, self.color:GetWide(), self.color:GetTall() )
			end
			self.color:Dock(TOP)
			self.back:AddItem(self.color)
			self.color:GetParent():DockPadding(5,0,5,0)

			//Modify the header and tweak things so it doesn't show up when the category is closed.
			self.color.Header:SetText( "Colorable" )
			self.color.Header:SetImage("icon16/fire_rainbow.png")
			self.color.Header.DoClick = function() end
			self.color.PerformLayout = function()
				local us = self.color	//so when we copy this over to another dform we only have to change this one line
				local Padding = us:GetPadding() or 0
				if ( us.Contents ) then
					if ( us:GetExpanded() ) then
						us.Contents:InvalidateLayout( true )
						us.Contents:SetVisible( true )
					else
						us.Contents:SetVisible( false )
					end
				end
				if ( us:GetExpanded() ) then
					us:SizeToChildren( false, true )
				else
					us:SetTall(0)	//this is the only real change from the standard DForm:PerformLayout()
				end	
				-- Make sure the color of header text is set
				us.Header:ApplySchemeSettings()
				us.animSlide:Run()
				us:UpdateAltLines();
			end

			self.color.text = vgui.Create("DLabel", self.color)
			self.color.text:SetColor( Color(60,60,60,255) )
			self.color.text:SetText("This effect is colorable.")
			self.color.text:SetWrap( true )
			self.color.text:SetAutoStretchVertical( true )
			self.color.text:Dock(TOP)
			self.color.text:SizeToContents()
			self.color:AddItem(self.color.text)
			self.color.text:GetParent():DockPadding( 15, 10, 15, 10 )


			self.color.selection = vgui.Create( "CtrlColor", self.color )
			self.color.selection:SetLabel( "" )
			self.color.selection:SetConVarR( data.commands.color .. "_r" )
			self.color.selection:SetConVarG( data.commands.color .. "_g" )
			self.color.selection:SetConVarB( data.commands.color .. "_b" )
			self.color.selection:SetConVarA( nil )
			self.color.selection:Dock(TOP)
			self.color:AddItem(self.color.selection)
			self.color.selection:GetParent():DockPadding( 10, 0, 10, 10 )
		end




		self.back.Think = function()
			if self.color then
				if GetConVarNumber( data.commands.color .. "_enabled" ) > 0 then
					//expand it
					if self.color:GetExpanded() == false then self.color:Toggle() end
				else
					//contract it
					if self.color:GetExpanded() == true then self.color:Toggle() end
					self.color:GetParent():SetTall(self.color:GetTall())
				end
			end
		end
		
	end
end