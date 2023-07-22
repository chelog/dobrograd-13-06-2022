
TOOL.Category = "Dobrograd"
TOOL.Name = "SubMaterial"--"#tool.material.name"
if CLIENT then
	language.Add( "tool.submaterial.name", "SubMaterial Tool" )
	language.Add( "tool.submaterial.desc", "Allow to override submaterials of model." )
	language.Add( "tool.submaterial.0", "Wheel Up/Down: Select target part, Primary: Apply material, Secondary: Set default material, Reload: Copy material" )
	language.Add( "tool.submaterial.help", "Select material here, type known material string or use HUD to copy materials" )
end
TOOL.ClientConVar[ "override" ] = "debug/env_cubemap_model"
TOOL.ClientConVar[ "index" ] = 0

--
-- Duplicator function
--
local function SetSubMaterial( Player, Entity, Data )

	if ( SERVER ) then
		local Mats=Entity:GetMaterials()
		local MatCount=table.Count(Mats)
		for i=0,MatCount-1 do
			local si="SubMaterialOverride_"..tostring(i)
			-- Block exploitable material in multiplayer and remove empty strings
			if Data[si] and ((!game.SinglePlayer() && string.lower(Data[si]) == "pp/copy" ) or Data[si] == "" ) then
				Data[si]=nil
			end
			Entity:SetSubMaterial( i, Data[si] or "")
		end
		duplicator.ClearEntityModifier( Entity, "submaterial")
		if (table.Count(Data) > 0) then duplicator.StoreEntityModifier( Entity, "submaterial", Data ) end
	end

	return true

end
duplicator.RegisterEntityModifier( "submaterial", SetSubMaterial )

local function UpdateSubMat(Player, Entity, Index, Material)
	local Mats=Entity:GetMaterials()
	local MatCount=table.Count(Mats)
	if Index < 0 or Index >= MatCount then return end
	local Data={}
	for i=0,MatCount-1 do
		local mat=Entity:GetSubMaterial(i)
		if i==Index then mat=Material end
		if mat and mat ~= "" then Data["SubMaterialOverride_"..tostring(i)]=mat end
	end
	return SetSubMaterial(Player, Entity, Data)
end


-- Original set material funct
local function SetMaterial( Player, Entity, Data )

	if ( SERVER ) then

		--
		-- Make sure this is in the 'allowed' list in multiplayer - to stop people using exploits
		--
		--if ( !game.SinglePlayer() && !list.Contains( "OverrideMaterials", Data.MaterialOverride ) && Data.MaterialOverride != "" ) then return end
		if not Data.MaterialOverride or (Data.MaterialOverride and (!game.SinglePlayer() && string.lower(Data.MaterialOverride) == "pp/copy" )) then
			return
		end
		Entity:SetMaterial( Data.MaterialOverride )
		duplicator.StoreEntityModifier( Entity, "material", Data )
	end

	return true

end
--and we will override it because original function eats most of materials even not exploitable! :(
duplicator.RegisterEntityModifier( "material", SetMaterial )


--
-- Left click applies the current material
--
function TOOL:LeftClick( trace )
	if not IsValid(trace.Entity) then trace.Entity = self:GetOwner() end
	local mat = self:GetClientInfo( "override" )
	if IsValid(trace.Entity) and trace.Entity:IsPlayer() then
		local override = hook.Run('submaterial.canUseOnPlayer', self:GetOwner(), trace.Entity, mat)
		if override == false then trace.Entity = nil end
	end
	if not IsValid(trace.Entity) then return end

	if ( CLIENT ) then return true end

	local ent = trace.Entity
	if ( IsValid( ent.AttachedEntity ) ) then ent = ent.AttachedEntity end

	local index = self:GetClientNumber( "index" , 0)
	if index < 1 then
		SetMaterial( self:GetOwner(), ent, { MaterialOverride = mat } )
	else
		UpdateSubMat( self:GetOwner(), ent, index-1, mat )
	end
	return true

end

hook.Add('submaterial.canUseOnPlayer', 'submaterial', function(ply, target, mat)
	if not ply:query('DBG: Применять тулы на игроках') then return false end
end)

--
-- Right click reverts the material
--
function TOOL:RightClick( trace )

	if ( !IsValid( trace.Entity ) ) then trace.Entity = self:GetOwner() end
	if IsValid(trace.Entity) and trace.Entity:IsPlayer() and not self:GetOwner():query('DBG: Применять тулы на игроках') then trace.Entity = nil end
	if not IsValid(trace.Entity) then return end

	if ( CLIENT ) then return true end

	local ent = trace.Entity
	if ( IsValid( ent.AttachedEntity ) ) then ent = ent.AttachedEntity end
	local index = self:GetClientNumber( "index" , 0)
	if index < 1 then
		SetMaterial( self:GetOwner(), ent, { MaterialOverride = "" } )
	else
		UpdateSubMat( self:GetOwner(), ent, index-1, "" )
	end
	return true

end


----- Damn Dirty fix... Thx for Wire Advanced tool developer

local function get_active_tool(ply, tool)
	-- find toolgun
	local activeWep = ply:GetActiveWeapon()
	if not IsValid(activeWep) or activeWep:GetClass() ~= "gmod_tool" or activeWep.Mode ~= tool then return end

	return activeWep:GetToolObject(tool)
end

if game.SinglePlayer() then -- wtfgarry (these functions don't get called clientside in single player so we need this hack to fix it)
	if SERVER then
		util.AddNetworkString( "submaterial_wtfgarry" )
		local function send( ply, funcname )
			net.Start( "submaterial_wtfgarry" )
				net.WriteString( funcname )
			net.Send( ply )
		end

		--function TOOL:LeftClick() send( self:GetOwner(), "LeftClick" ) end
		--function TOOL:RightClick() send( self:GetOwner(), "RightClick" ) end
		function TOOL:Reload() send( self:GetOwner(), "Reload" ) end
	elseif CLIENT then
		net.Receive( "submaterial_wtfgarry", function( len )
			local funcname = net.ReadString()
			local tool = get_active_tool( LocalPlayer(), "submaterial" )
			if not tool then return end
			tool[funcname]( tool, LocalPlayer():GetEyeTrace() )
		end)
	end
end
-----------------------------
if CLIENT then


	TOOL.AimEnt = nil
	TOOL.HudData = {}
	TOOL.SelIndx = 1
	TOOL.ToolMatString = ""

	function TOOL:Reload( trace )

		if ( !IsValid( trace.Entity ) ) then trace.Entity = self:GetOwner() end
		if IsValid(trace.Entity) and trace.Entity:IsPlayer() and not self:GetOwner():query('DBG: Применять тулы на игроках') then trace.Entity = nil end
		if not IsValid(trace.Entity) then return end

		--if ( CLIENT ) then return true end

			local ent = trace.Entity
			if ( IsValid( ent.AttachedEntity ) ) then ent = ent.AttachedEntity end

			--local index = self:GetClientNumber( "index" , 0)
			local mat=self.HudData.EntCurMatString--""

			if !mat or mat ~= "" then
				RunConsoleCommand("submaterial_override",mat)
			end
			--LocalPlayer():ChatPrint("Material ".. (((self.SelIndx < 1) and "[Global]") or tostring(self.SelIndx)).." copied: "..mat)
			--else LocalPlayer():ChatPrint("Empty material!") end
		--end
		return true

	end



	function TOOL:Scroll(trace,dir)
		if !IsValid(self.AimEnt) then return end
		local Mats=self.AimEnt:GetMaterials()
		local MatCount=table.Count(Mats)
		self.SelIndx = self.SelIndx + dir
		if(self.SelIndx<0) then self.SelIndx = MatCount end
		if(self.SelIndx>MatCount) then self.SelIndx = 0 end
		RunConsoleCommand("submaterial_index",tostring(self.SelIndx))
		return true
		--self.HudData.EntCurMat=Material(self.AimEnt:GetMaterials()[self.SelIndx])

	end
	function TOOL:ScrollUp(trace) return self:Scroll(trace,-1) end
	function TOOL:ScrollDown(trace) return self:Scroll(trace,1) end



---- Thx wire_adv dev again...
	local function hookfunc( ply, bind, pressed )
		if not pressed then return end
		if bind == "invnext" then
			local self = get_active_tool(ply, "submaterial")
			if not self then return end

			return self:ScrollDown(ply:GetEyeTraceNoCursor())
		elseif bind == "invprev" then
			local self = get_active_tool(ply, "submaterial")
			if not self then return end

			return self:ScrollUp(ply:GetEyeTraceNoCursor())
		end
	end

	if game.SinglePlayer() then -- wtfgarry (have to have a delay in single player or the hook won't get added)
		timer.Simple(5,function() hook.Add( "PlayerBindPress", "submat_tool_playerbindpress", hookfunc ) end)
	else
		hook.Add( "PlayerBindPress", "submat_tool_playerbindpress", hookfunc )
	end
--------------------------------------------------


	local function FixVertexLitMaterial(Mat)

		--
		-- If it's a vertexlitgeneric material we need to change it to be
		-- UnlitGeneric so it doesn't go dark when we enter a dark room
		-- and flicker all about
		--
		if not Mat then return Mat end
		local strImage = Mat:GetName()

		if ( string.find( Mat:GetShader(), "VertexLitGeneric" ) || string.find( Mat:GetShader(), "Cable" ) ) then

			local t = Mat:GetString( "$basetexture" )

			if ( t ) then

				local params = {}
				params[ "$basetexture" ] = t
				params[ "$vertexcolor" ] = 1
				params[ "$vertexalpha" ] = 1

				Mat = CreateMaterial( strImage .. "_hud_fx", "UnlitGeneric", params )

			end

		end

		return Mat

	end

	function TOOL:Think( )
		local ent=LocalPlayer():GetEyeTraceNoCursor().Entity
		if not IsValid(ent) then ent = LocalPlayer() end
		if ( IsValid( ent.AttachedEntity ) ) then ent = ent.AttachedEntity end
		if IsValid(ent) and ent:IsPlayer() and not LocalPlayer():query('DBG: Применять тулы на игроках') then ent = nil end
		if self.AimEnt ~= ent then

			self.AimEnt=ent
			if IsValid(self.AimEnt) then
				self.SelIndx=0
				RunConsoleCommand("submaterial_index",tostring(self.SelIndx))
				self.HudData.Mats=self.AimEnt:GetMaterials()

			end
			--print("ThinkUpdate "..tostring(self.AimEnt))
		end

			if IsValid(self.AimEnt) then
				self.HudData.CurMats=table.Copy(self.HudData.Mats)
				self.HudData.OvrMats={}

				local MatCount=table.Count(self.HudData.Mats)
				for i=1,MatCount do
					local mat=self.AimEnt:GetSubMaterial(i-1)
					if mat and mat ~= "" then self.HudData.OvrMats[i]=mat end
				end
				table.Merge(self.HudData.CurMats,self.HudData.OvrMats)
				self.HudData.GlobalMat=self.AimEnt:GetMaterial()
				local EntCurMatString=self.HudData.GlobalMat
				local EntOrigMatString=self.HudData.GlobalMat
				if self.SelIndx > 0 then EntCurMatString=self.HudData.CurMats[self.SelIndx]; EntOrigMatString=self.HudData.Mats[self.SelIndx] end
				if self.HudData.EntCurMatString~=EntCurMatString then
					self.HudData.EntCurMatString=EntCurMatString
					self.HudData.EntCurMat=FixVertexLitMaterial(Material(EntCurMatString))
				end
				if self.HudData.EntOrigMatString~=EntOrigMatString then
					self.HudData.EntOrigMatString=EntOrigMatString
					self.HudData.EntOrigMat=FixVertexLitMaterial(Material(EntOrigMatString))
				end
			end

		if IsValid(self.AimEnt) and self.ToolMatString~=GetConVarString("submaterial_override") then
			self.ToolMatString=GetConVarString("submaterial_override")
 			self.HudData.ToolMat=FixVertexLitMaterial(Material(self.ToolMatString))
		end

	end
	function TOOL:DrawHUD( )
		if IsValid(self.AimEnt) then

			---- List
			local Rg=ScrW()/2-50
			local MaxW = 0
			local TextH = 0
			surface.SetFont("ChatFont")
			local Hdr=tostring(self.AimEnt)..": "..tostring(table.Count(self.HudData.Mats)).." materials"
			MaxW,TextH=surface.GetTextSize(Hdr)
			local HdrH = TextH+5
			for _,s in pairs(self.HudData.CurMats) do
				local ts,_=surface.GetTextSize(s)
				if MaxW<ts then MaxW=ts end
			end
			local LH=4*2+HdrH+TextH*(1+table.Count(self.HudData.Mats))
			local LW=4*2+MaxW
			local LL=Rg-LW
			local LT=ScrH()/2-LH/2
			surface.SetDrawColor(Color(64,64,95,191))
			--surface.SetMaterial(self.HudData.EntCurMat)
			surface.DrawRect(LL, LT, LW, LH)
			surface.SetTextColor(Color(255,255,255,255))
			surface.SetTextPos(LL+4,LT+4)
			surface.DrawText(Hdr)
			surface.SetDrawColor(Color(255,255,255,255))
			surface.DrawLine(LL+3,LT+4+TextH+3,Rg-3,LT+4+TextH+3)

			surface.SetDrawColor(Color(0,127,0,191))
			surface.DrawRect(LL+3, LT+4+HdrH+TextH*self.SelIndx, LW-3-3, TextH)

			local s="<none>"
			if not self.HudData.GlobalMat or self.HudData.GlobalMat == "" then
				surface.SetTextColor(Color(255,255,255,255))
			else surface.SetTextColor(Color(0,0,255,255)); s=self.HudData.GlobalMat end

			surface.SetTextPos(LL+4,LT+4+HdrH)
			surface.DrawText(s)



			for i,s in pairs(self.HudData.CurMats) do
				if self.HudData.OvrMats[i] then surface.SetTextColor(Color(255,0,0,255)) else surface.SetTextColor(Color(255,255,255,255)) end
				surface.SetTextPos(LL+4,LT+4+HdrH+TextH*i)
				surface.DrawText(s)
			end
			---- Info box


			--local MaxW = 0
			local StrToolInfo = "Tool material:"
			local StrOrigMatInfo = "Model original material:"
			local StrCurMatInfo = "Model current material:"
			local MaxW,_=surface.GetTextSize(StrToolInfo)
			local ts,_=surface.GetTextSize(StrOrigMatInfo)
			if MaxW<ts then MaxW=ts end
			local ts,_=surface.GetTextSize(StrCurMatInfo)
			if MaxW<ts then MaxW=ts end
			local ts,_=surface.GetTextSize(self.ToolMatString)
			if MaxW<ts then MaxW=ts end
			local ts,_=surface.GetTextSize(self.HudData.EntOrigMatString)
			if MaxW<ts then MaxW=ts end
			local ts,_=surface.GetTextSize(self.HudData.EntCurMatString)
			if MaxW<ts then MaxW=ts end

			local IL=ScrW()/2+50
			local IH=4*4+(64)*3
			local IT=ScrH()/2-IH/2
			surface.SetDrawColor(Color(64,64,95,191))
			surface.DrawRect(IL, IT, 76+MaxW, IH)	-- 4+64+4+MaxW+4

			surface.SetTextColor(Color(255,255,255,255))

			surface.SetDrawColor(Color(255,255,255,255))
			if self.HudData.ToolMat  then
				surface.SetMaterial(self.HudData.ToolMat)
				surface.DrawTexturedRect(IL+4, IT+4, 64, 64)
			end
			surface.SetTextPos(IL+4+64+4,IT+8)
			surface.DrawText(StrToolInfo)
			surface.SetTextPos(IL+4+64+4,IT+8+TextH)
			surface.DrawText(self.ToolMatString)
			surface.SetTextPos(IL+4+64+4,IT+8+TextH*2)
			surface.DrawText(self.SelIndx==0 and "[Global]" or "Index: "..self.SelIndx-1)



			if self.HudData.EntOrigMat  then
				surface.SetMaterial(self.HudData.EntOrigMat)
				surface.DrawTexturedRect(IL+4, IT+4+(64+4), 64, 64)
			end
			surface.SetTextPos(IL+4+64+4,IT+8+64+4)
			surface.DrawText(StrOrigMatInfo)
			surface.SetTextPos(IL+4+64+4,IT+8+64+4+TextH)
			surface.DrawText(self.HudData.EntOrigMatString)

			if self.HudData.EntCurMat  then
				surface.SetMaterial(self.HudData.EntCurMat)
				surface.DrawTexturedRect(IL+4, IT+4+(64+4)*2, 64, 64)
			end
			surface.SetTextPos(IL+4+64+4,IT+8+(64+4)*2)
			surface.DrawText(StrCurMatInfo)
			surface.SetTextPos(IL+4+64+4,IT+8+(64+4)*2+TextH)
			surface.DrawText(self.HudData.EntCurMatString)


--			surface.SetMaterial(nil)


			--draw.RoundedBox( 2, ScrW()/2-50, ScrH()/2-50, 100, 100, Color(255,255,255,255) )

		--	print("DrawHUD "..tostring(self.AimEnt))
		end
	end


end

local ConVarsDefault = TOOL:BuildConVarList()
function TOOL.BuildCPanel( CPanel )

	--CPanel:AddControl( "Slider", { Label = "Index", Command = "submaterial_index", Type = "Integer", Min = 0, Max = 15} )
	CPanel:AddControl( "Header", { Description = "#tool.submaterial.help" } )
	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "submaterial", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "TextBox", { Label = "Mat:", Command = "submaterial_override", MaxLength = "48"} )
	CPanel:MatSelect( "submaterial_override", list.Get( "OverrideMaterials" ), true, 64, 64 )

end
