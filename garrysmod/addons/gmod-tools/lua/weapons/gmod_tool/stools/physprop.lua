TOOL.Category = "Construction"
TOOL.Name = "#tool.physprop.name"

TOOL.ClientConVar[ "gravity_toggle" ] = "1"
TOOL.ClientConVar[ "material" ] = "metal_bouncy"

TOOL.Information = { { name = "left" } }

function TOOL:LeftClick( trace )
	if ( !IsValid( trace.Entity ) ) then return false end
	if ( trace.Entity:IsPlayer() || trace.Entity:IsWorld() ) then return false end

	-- Make sure there's a physics object to manipulate
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end

	-- Client can bail out here and assume we're going ahead
	if ( CLIENT ) then return true end

	-- Get the entity/bone from the trace
	local ent = trace.Entity
	local Bone = trace.PhysicsBone

	-- Get client's CVars
	local gravity = self:GetClientNumber( "gravity_toggle" ) == 1
	local material = self:GetClientInfo( "material" )

	-- Set the properties
	construct.SetPhysProp( self:GetOwner(), ent, Bone, nil, { GravityToggle = gravity, Material = material } )
	-- Set netvar for dbg
	ent:SetNetVar("physprop", material)

	DoPropSpawnedEffect( ent )

	return true

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "physprop", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "ListBox", { Label = "#tool.physprop.material", Options = list.Get( "PhysicsMaterials" ) } )

	CPanel:AddControl( "CheckBox", { Label = "#tool.physprop.gravity", Command = "physprop_gravity_toggle" } )

end

list.Set( "PhysicsMaterials", "#physprop.metalbouncy", { physprop_material = "metal_bouncy" } )
list.Set( "PhysicsMaterials", "#physprop.metal", { physprop_material = "metal" } )
list.Set( "PhysicsMaterials", "Земля", { physprop_material = "dirt" } )
list.Set( "PhysicsMaterials", "Грязь", { physprop_material = "slipperyslime" } )
list.Set( "PhysicsMaterials", "#physprop.wood", { physprop_material = "wood" } )
list.Set( "PhysicsMaterials", "#physprop.glass", { physprop_material = "glass" } )
list.Set( "PhysicsMaterials", "#physprop.concrete", { physprop_material = "concrete_block" } )
list.Set( "PhysicsMaterials", "#physprop.ice", { physprop_material = "ice" } )
list.Set( "PhysicsMaterials", "#physprop.rubber", { physprop_material = "rubber" } )
list.Set( "PhysicsMaterials", "#physprop.paper", { physprop_material = "paper" } )
list.Set( "PhysicsMaterials", "#physprop.flesh", { physprop_material = "zombieflesh" } )
list.Set( "PhysicsMaterials", "#physprop.superice", { physprop_material = "gmod_ice" } )
list.Set( "PhysicsMaterials", "#physprop.superbouncy", { physprop_material = "gmod_bouncy" } )
-- Custom materials
list.Set( "PhysicsMaterials", "Забор", { physprop_material = "fence" } )
list.Set( "PhysicsMaterials", "Трава", { physprop_material = "grass" } )
list.Set( "PhysicsMaterials", "Гравий", { physprop_material = "gravel" } )
list.Set( "PhysicsMaterials", "Металлическая решетка", { physprop_material = "metal_grate" } )
list.Set( "PhysicsMaterials", "Песок", { physprop_material = "sand" } )
list.Set( "PhysicsMaterials", "Хлюпанье по воде", { physprop_material = "water_slosh" } )
list.Set( "PhysicsMaterials", "Плаванье в воде", { physprop_material = "water_wade" } )
list.Set( "PhysicsMaterials", "Кафельная плитка", { physprop_material = "tile" } )
list.Set( "PhysicsMaterials", "Деревянная панель", { physprop_material = "wood_panel" } )
list.Set( "PhysicsMaterials", "Металлическая труба", { physprop_material = "duct_metal" } )
list.Set( "PhysicsMaterials", "Деревянный ящик", { physprop_material = "wood_box" } )
list.Set( "PhysicsMaterials", "Металлическая лестница", { physprop_material = "wood_box" } )