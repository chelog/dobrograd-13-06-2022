AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


function ENT:Initialize()
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	self:SetMaterial("models/effects/vol_light001")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetMoveType(MOVETYPE_NONE)
	self:DrawShadow(false)
	self.heldby = 0
end

function ENT:PhysicsUpdate(phys)
	if self.heldby <= 0 then
		phys:Sleep()
	end
end

local function textScreenPickup(ply, ent)
	if IsValid(ent) and ent:GetClass() == "textscreen" then
		ent.heldby = ent.heldby + 1
	end
end
hook.Add("PhysgunPickup", "textScreensPreventTravelPickup", textScreenPickup)

local function textScreenDrop(ply, ent)
	if IsValid(ent) and ent:GetClass() == "textscreen" then
		ent.heldby = ent.heldby - 1
	end
end
hook.Add("PhysgunDrop", "textScreensPreventTravelDrop", textScreenDrop)

local function textScreenCanTool(ply, trace, tool)
	if IsValid(trace.Entity) and trace.Entity:GetClass() == "textscreen" then
		if !(tool == "textscreen" or tool == "remover") then
			return false
		end
	end
end
hook.Add("CanTool", "textScreensPreventTools", textScreenCanTool, -5)

function ENT:SetLine(line, text, color, size, font)
	if string.len(text) > 180 then
		text = string.sub(text, 1, 180) .. "..."
	end

	self.lines = self.lines or {}
	self.lines[tonumber(line)] = {
		["text"] = text,
		["color"] = color,
		["font"] = font,
		["size"] = size
	}

	self:SetNetVar("lines", self.lines)
end

duplicator.RegisterEntityClass('textscreen', function(ply, data)

	if IsValid(ply) and not ply:CheckLimit('textscreens') then return false end

	local ent = duplicator.GenericDuplicatorFunction(ply, data)
	ent:SetNetVar('lines', ent.lines)

	if IsValid(ply) then
		ply:AddCount('textscreens', ent)
		ply:AddCleanup('textscreens', ent)
	end

	return ent

end, 'Data', 'lines')
