TOOL.Category		= "Construction"
TOOL.Name			= "#tool.nocollideeverything.name"

TOOL.ClientConVar["noshadow"] = "0"
TOOL.ClientConVar["noself"]   = "0"

if CLIENT then
	TOOL.Information = {
		{name = "info"},
		{name = "left"},
		{name = "right"},
		{name = "reload"}
	}

	language.Add("tool.nocollideeverything.name", "No Collide Everything")
	language.Add("tool.nocollideeverything.desc", "Make an object have no collisions at all")
	language.Add("tool.nocollideeverything.0", "Hold shift to turn off self-collision on ragdolls")
	language.Add("tool.nocollideeverything.left", "Turn off collisions with everything but the world")
	language.Add("tool.nocollideeverything.right", "Turn off collisions with everything including the world")
	language.Add("tool.nocollideeverything.reload", "Enable collisions")
end


local function canTool(entity)
	if not entity
	or not entity:IsValid()
	or entity:IsPlayer()
	or not entity:GetPhysicsObject():IsValid() then
	return false
	else return true end
end


local function applyNoColldeEverything(player, entity, data)
	if not SERVER then return end

	local override = hook.Run('CanTool', player, { Entity = entity }, 'nocollideeverything')
	if override == false then return end

	timer.Simple(0, function()
		if not IsValid(entity) then return end
		local phys	  = entity:GetPhysicsObject()
		local physCount = entity:GetPhysicsObjectCount()
		local noShadow  = data.noShadow
		local noWorld   = data.noWorld
		local noSelf	= data.noSelf

		if not phys:IsValid() then return end

		if physCount == 1 then
			if noWorld then phys:EnableCollisions(false)
			else phys:EnableCollisions(true) end
		end

		if physCount > 1 then
			for num = 0, physCount - 1 do
			curPhys = entity:GetPhysicsObjectNum(num)
				if curPhys:IsValid() then
					if noSelf and not noWorld then curPhys:AddGameFlag(FVPHYSICS_NO_SELF_COLLISIONS)
					else curPhys:ClearGameFlag(FVPHYSICS_NO_SELF_COLLISIONS) end

					if noWorld then curPhys:EnableCollisions(false)
					else curPhys:EnableCollisions(true) end
				end
			end
		end

		timer.Simple(1, function() -- APG changes collision group
			if IsValid(entity) then entity:SetCollisionGroup(COLLISION_GROUP_WORLD) end
		end)
		entity:DrawShadow(not noShadow)

		duplicator.StoreEntityModifier(entity, "ncEverything", data)
	end)
end
duplicator.RegisterEntityModifier("ncEverything", applyNoColldeEverything)


local function removeNoColldeEverything(entity, ply)
	if not SERVER then return end
	if entity.APG_Ghosted then return APG.entUnGhost(entity, ply) end

	local phys	  = entity:GetPhysicsObject()
	local physCount = entity:GetPhysicsObjectCount()

	if physCount == 1 then
		phys:EnableCollisions(true)
	end

	if physCount > 1 then
		for num = 0, physCount - 1 do
		curPhys = entity:GetPhysicsObjectNum(num)
			if curPhys:IsValid() then
				curPhys:ClearGameFlag(FVPHYSICS_NO_SELF_COLLISIONS)
				curPhys:EnableCollisions(true)
			end
		end
	end

	entity:SetCollisionGroup(COLLISION_GROUP_NONE)
	entity:DrawShadow(true)

	duplicator.ClearEntityModifier(entity, "ncEverything")
end


function TOOL:LeftClick(trace)
	if CLIENT then return true end

	local entity	= trace.Entity
	local owner	 = self:GetOwner()
	local shift	 = owner:KeyDown(IN_SPEED)
	local noShadow  = tobool(self:GetClientNumber("noshadow"))
	if not canTool(entity) then return false end

	local data = {
		noShadow = noShadow,
		noWorld  = false,
		noSelf   = shift
	}

	applyNoColldeEverything(owner, entity, data)
	return true
end


function TOOL:RightClick(trace)
	if CLIENT then return true end

	local entity	= trace.Entity
	local owner	 = self:GetOwner()
	local shift	 = owner:KeyDown(IN_SPEED)
	local noShadow  = tobool(self:GetClientNumber("noshadow"))
	if not canTool(entity) then return false end

	local data = {
		noShadow = noShadow,
		noWorld  = true,
		noSelf   = shift
	}

	applyNoColldeEverything(owner, entity, data)
	return true
end


function TOOL:Reload(trace)
	if CLIENT then return true end
	local entity = trace.Entity
	removeNoColldeEverything(entity, self:GetOwner())
	return true
end


function TOOL.BuildCPanel(ControlPanel)
	ShadowBox = vgui.Create("DCheckBoxLabel", ControlPanel)
	ShadowBox:SetPos(10, 30)
	ShadowBox:SetText("Disable shadow")
	ShadowBox:SetConVar("nocollideeverything_noshadow")
	ShadowBox:SetValue(0)
	ShadowBox:SizeToContents()
end

/*
function TOOL:DrawToolScreen( width, height )

end
*/
