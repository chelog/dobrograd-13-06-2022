--Tool by NotAKid, it is probably shit soz

TOOL.Category = "Render"
TOOL.Name = "Proxy Color"

--add each material proxy we support
TOOL.ClientConVar[ "cs1_r" ] = 255
TOOL.ClientConVar[ "cs1_g" ] = 255
TOOL.ClientConVar[ "cs1_b" ] = 255
TOOL.ClientConVar[ "cs2_r" ] = 255
TOOL.ClientConVar[ "cs2_g" ] = 255
TOOL.ClientConVar[ "cs2_b" ] = 255
TOOL.ClientConVar[ "cs3_r" ] = 255
TOOL.ClientConVar[ "cs3_g" ] = 255
TOOL.ClientConVar[ "cs3_b" ] = 255
TOOL.ClientConVar[ "cs4_r" ] = 255
TOOL.ClientConVar[ "cs4_g" ] = 255
TOOL.ClientConVar[ "cs4_b" ] = 255
TOOL.ClientConVar[ "cs5_r" ] = 255
TOOL.ClientConVar[ "cs5_g" ] = 255
TOOL.ClientConVar[ "cs5_b" ] = 255
TOOL.ClientConVar[ "cs6_r" ] = 255
TOOL.ClientConVar[ "cs6_g" ] = 255
TOOL.ClientConVar[ "cs6_b" ] = 255
TOOL.ClientConVar[ "cs7_r" ] = 255
TOOL.ClientConVar[ "cs7_g" ] = 255
TOOL.ClientConVar[ "cs7_b" ] = 255
TOOL.CurEntity = nil

if CLIENT then
	language.Add("proxycolor", "Proxy Color")
	language.Add("tool.proxycolor.name", "Proxy Color")
	language.Add("tool.proxycolor.desc", "Set colors for a supported object")
	language.Add("tool.proxycolor.Color multiplier.help", "Easy shade/intensity")
	language.Add("tool.proxycolor.reload", "Reset color scheme")
	language.Add("tool.proxycolor.right", "Copy color scheme")
	language.Add("tool.proxycolor.left", "Select object")
end

TOOL.Information = {
	{ name = "left", stage = 0},
	{ name = "right" },
	{ name = "reload" }
}

function TOOL:LeftClick( trace )
	local ent = trace.Entity
	--I honestly dont know what this means, it was a part of the normal color tool
	if ( IsValid( ent.AttachedEntity ) ) then ent = ent.AttachedEntity end

	--if the entity is a Simfphys wheel, set the fake Ghost wheel as the selected entity (the ghostwheel is the visual one)
	if ent:GetClass() == "gmod_sent_vehicle_fphysics_wheel" then
		ent = ent:GetChildren()[2]
	end

	--The entity is valid and isn't worldspawn
	if IsValid( ent ) then

		if self:GetWeapon():GetNWEntity("CurEntity") != ent then --the select then apply code
			self:GetWeapon():SetNWEntity("CurEntity",ent)
			self:GetWeapon():EmitSound( "garrysmod/content_downloaded.wav", 75, 100, 1, CHAN_WEAPON)
			if CLIENT then
				Entity(1):PrintMessage(HUD_PRINTTALK, "[Proxy Color] Rebuilt panel, check your menu!")
			end
			return
		end
		if ( CLIENT ) then return true end

		local ColorTable = {}
		for i=1,7 do
			local cs_r		= self:GetClientNumber( "cs"..i.."_r", 0 )
			local cs_g	= self:GetClientNumber( "cs"..i.."_g", 0 )
			local cs_b	= self:GetClientNumber( "cs"..i.."_b", 0 )
			table.insert(ColorTable, i, Color(cs_r,cs_g,cs_b) )
		end

		ent:SetProxyColors( ColorTable )
		return true
	end
end


function TOOL:RightClick( trace )
	local ent = trace.Entity
	if ( IsValid( ent.AttachedEntity ) ) then ent = ent.AttachedEntity end

	if ent:GetClass() == "gmod_sent_vehicle_fphysics_wheel" then
		ent = ent:GetChildren()[2]
	end

	if IsValid( ent ) then
		local CT = ent:GetProxyColors()
		if !CT then return end

		for i=1,7 do
			if CT[i] == nil then CT[i] = Vector(1,1,1) end
			self:GetOwner():ConCommand( "proxycolor_cs"..i.."_r " .. CT[i].r*255 )
			self:GetOwner():ConCommand( "proxycolor_cs"..i.."_g " .. CT[i].g*255 )
			self:GetOwner():ConCommand( "proxycolor_cs"..i.."_b " .. CT[i].b*255 )
		end

		return true
	end
end

function TOOL:Reload( trace )
	local ent = trace.Entity
	if ( IsValid( ent.AttachedEntity ) ) then ent = ent.AttachedEntity end

	if ent:GetClass() == "gmod_sent_vehicle_fphysics_wheel" then --resets simfphys vehicle wheel colors
		ent = ent:GetChildren()[2]
	end

	if CLIENT then return true end

	if IsValid( ent ) then
		--reset everything to white
		local ColorTable = {}
		for i=1,7 do
			table.insert(ColorTable, i, Color(255,255,255) )
		end

		ent:SetProxyColors( ColorTable )
		return true
	end
end

function TOOL:Think()
	if CLIENT then
		local netEnt = self:GetWeapon():GetNWEntity("CurEntity")
		if (netEnt != self.CurEntity) then
			self.CurEntity = self:GetWeapon():GetNWEntity("CurEntity")
			self:UpdateControlPanel()
		end
	end
end

function TOOL:UpdateControlPanel()
	local CPanel = controlpanel.Get( "proxycolor" )
	CPanel:ClearControls()
	self.BuildCPanel( CPanel, self.CurEntity )
end

local function HackyListGenThingIdk(i,Selected,CPanel,name)
	if name == nil then return end

	--CREATES THE COLLAPSABLE PART OF THE MENU, NAMES IT THE MATERIALS NAME
	local collapse = vgui.Create("DCollapsibleCategory")
	collapse:SetLabel(name)
	CPanel:AddItem(collapse) --adds the collapsable part of the menu to the panel

	local list = vgui.Create("DPanelList",collapse)
	list:SetHeight(250)
	list:SetPadding(10)

	list:Dock(TOP)
	collapse:InvalidateLayout(true)
	--CREATES THE COLOR MIXER PART OF THE MENU, PARENTS TO THE NEW COLLAPBABLE PART OF THE MENU
	local ColorSlot = vgui.Create( "DColorMixer" )
	ColorSlot:SetLabel(name)
	ColorSlot:SetPalette( true )
	ColorSlot:SetAlphaBar( false )
	ColorSlot:SetWangs( true )
	ColorSlot:SetConVarR("proxycolor_cs"..i.."_r")
	ColorSlot:SetConVarG("proxycolor_cs"..i.."_g")
	ColorSlot:SetConVarB("proxycolor_cs"..i.."_b")
	list:AddItem(ColorSlot)
	collapse:SetExpanded(true)
end

local ConVarsDefault = TOOL:BuildConVarList() -- used to get the saved presets
function TOOL.BuildCPanel( CPanel, Selected ) -- the control area of the tool, gonna have to work on it to make multiple proxies easier to use
	CPanel:AddControl( "Header", { Description = "#tool.proxycolor.desc" } )
	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "proxycolor", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	if !Selected then return end

	--could use a for loop, but in testing i think this was slightly faster
	if ( Selected.ColorSlot1 ) then HackyListGenThingIdk(1,Selected,CPanel,Selected.ColorSlot1Name) end
	if ( Selected.ColorSlot2 ) then HackyListGenThingIdk(2,Selected,CPanel,Selected.ColorSlot2Name) end
	if ( Selected.ColorSlot3 ) then HackyListGenThingIdk(3,Selected,CPanel,Selected.ColorSlot3Name) end
	if ( Selected.ColorSlot4 ) then HackyListGenThingIdk(4,Selected,CPanel,Selected.ColorSlot4Name) end
	if ( Selected.ColorSlot5 ) then HackyListGenThingIdk(5,Selected,CPanel,Selected.ColorSlot5Name) end
	if ( Selected.ColorSlot6 ) then HackyListGenThingIdk(6,Selected,CPanel,Selected.ColorSlot6Name) end
	if ( Selected.ColorSlot7 ) then HackyListGenThingIdk(7,Selected,CPanel,Selected.ColorSlot7Name) end
end
