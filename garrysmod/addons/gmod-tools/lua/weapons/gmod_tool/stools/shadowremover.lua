
--[[-----------------------------------------------------------------------------------

		Tool Creator - SnowredWolf | STEAM_0:0:41063225 | https://SnowredWolf.net
		Tool Purpose - Remove shadows from props

-------------------------------------------------------------------------------------]]


--[[-------------------------------------------------------------------------
		Default tool stuff
---------------------------------------------------------------------------]]
	TOOL.Category = "Render"
	TOOL.Author = "SnowredWolf"
	TOOL.Name = "#tool.shadowremover.name"
	TOOL.Desc = "#tool.shadowremover.desc"
	TOOL.ConfigName = ""

	TOOL.ClientConVar[ "colorspeed" ] = 10

--[[-------------------------------------------------------------------------
		Variables and networking
---------------------------------------------------------------------------]]
	shadowremovertool = {}
	shadowremovertool.proplist = shadowremovertool.proplist or {}


--[[-------------------------------------------------------------------------
		Setting up the tool options
---------------------------------------------------------------------------]]
	if CLIENT then
		TOOL.Information = {
			{ name = "info", stage = 1 },
			{ name = "left" },
			{ name = "right" },
			{ name = "left_reload", icon2 = "gui/r.png"},
			{ name = "right_reload", icon2 = "gui/r.png"}
		}

		language.Add("tool.shadowremover.name", "Shadow Remover")
		language.Add("tool.shadowremover.left", "Remove shadows on the prop you are looking at")
		language.Add("tool.shadowremover.right", "Add shadows to the prop you are looking at")
		language.Add("tool.shadowremover.left_reload", "Make the prop darker" )
		language.Add("tool.shadowremover.right_reload", "Make the prop brighter" )
		language.Add("tool.shadowremover.desc", "Used to disable map shadows from props, making you able to avoid pitch black props!")
	end

--[[-------------------------------------------------------------------------
		Handle what happens when using left click
---------------------------------------------------------------------------]]
	function TOOL:LeftClick(trace)
		local ent = trace.Entity

		if IsEntity(ent) and (ent:GetClass() == "prop_physics" or ent:GetClass() == "prop_ragdoll") then
			if CLIENT then return true end
			if not self:GetOwner():KeyDown(IN_RELOAD) then
				shadowremovertool.removepropshadow(ent)
			else
				shadowremovertool.makedarker(self, ent)
			end

			return true
		end

		return false
	end

--[[-------------------------------------------------------------------------
		Handle what happens when using right click
---------------------------------------------------------------------------]]
	function TOOL:RightClick(trace)
		local ent = trace.Entity
		if IsEntity(ent) and (ent:GetClass() == "prop_physics" or ent:GetClass() == "prop_ragdoll") then
			if CLIENT then return true end
			if not self:GetOwner():KeyDown(IN_RELOAD) then
				shadowremovertool.addpropshadows(ent)
			else
				shadowremovertool.makebrighter(self, ent)
			end
			return true
		end

		return false
	end


--[[-------------------------------------------------------------------------
		Handle what happens when pressing reload
---------------------------------------------------------------------------]]
	function TOOL:Reload(trace) return false end

--[[-------------------------------------------------------------------------
		Serverside functions to handle shadows
---------------------------------------------------------------------------]]
	if SERVER then
		local colnew
		local h, s, v
		local entcolor

		function shadowremovertool.removepropshadow(ent)
			shadowremovertool.proplist[ent] = true
			ent.originalcolor = ent:GetColor()
			duplicator.StoreEntityModifier( ent, "shadow", {true} )
			netstream.Start(nil, "propshadow", { ent }, true)
		end

		function shadowremovertool.addpropshadows(ent)
			if not shadowremovertool.proplist[ent] then return false end
			shadowremovertool.proplist[ent] = nil
			ent:SetColor(ent.originalcolor)
			ent.originalcolor = nil
			duplicator.ClearEntityModifier( ent, "shadow" )

			netstream.Start(nil, "propshadow", { ent }, false)
		end

		function shadowremovertool.makedarker(self, ent)
			if not shadowremovertool.proplist[ent] then return false end
			entcolor = ent:GetColor()
			h, s, v = ColorToHSV(entcolor)
			if v == 0.1 then return end

			if 0.1 < v - self:GetClientNumber( "colorspeed", 10) / 100  then
				v = v - self:GetClientNumber( "colorspeed", 10) / 100
			else
				v = 0.1
			end

			colnew = HSVToColor(h, s, v)
			ent:SetColor(colnew)
			duplicator.StoreEntityModifier( ent, "shadow", {true, colnew} )
		end

		function shadowremovertool.makebrighter(self, ent)
			if not shadowremovertool.proplist[ent] then return false end
			entcolor = ent:GetColor()
			h, s, v = ColorToHSV(entcolor)
			if v == 0.99 then return end

			if 0.99 > self:GetClientNumber( "colorspeed", 10) / 100 + v then
				v = v + self:GetClientNumber( "colorspeed", 10) / 100
			else
				v = 0.99
			end

			colnew = HSVToColor(h, s, v)
			ent:SetColor(colnew)
		end

		function shadowremovertool.loadpropshadowsonjoin(ply)
			timer.Simple(12, function()
				if not IsValid(ply) then return end
				netstream.Heavy(ply, "propshadow", table.GetKeys(shadowremovertool.proplist), true)
			end)
		end

		hook.Add("PlayerFinishedLoading", "RemoveShadowsWhenInitialSpawn", shadowremovertool.loadpropshadowsonjoin)
	end

--[[-------------------------------------------------------------------------
		Build the tool panel
---------------------------------------------------------------------------]]
	function TOOL.BuildCPanel(panel)
		panel:AddControl("label", {
			text = "How fast should a prop become darker/brighter in %?"
		})

		panel:AddControl("Slider", {
			Label = "Percentage: ",
			Type = "Float",
			Min = "1",
			Max = "100",
			Command = "shadowremover_colorspeed"
		})
	end

--[[-------------------------------------------------------------------------
		Clientside networking
---------------------------------------------------------------------------]]
	local noShadow = function(self) render.SuppressEngineLighting(true) self:DrawModel() render.SuppressEngineLighting(false) end
	netstream.Hook('propshadow', function(ents, enable)
		octolib.whenNotNull(ents, function(ent, i)
			ent.RenderOverride = enable and noShadow or nil
		end, 900)
	end)

duplicator.RegisterEntityModifier("shadow", function(ply, ent, data)

	local override = hook.Run('CanTool', ply, { Entity = ent }, 'shadowremover')
	if override == false then return end

	if data then
		if data[1] then
			shadowremovertool.removepropshadow(ent)
		end
		if data[2] then
			ent:SetColor(data[2])
		end
	end

end)