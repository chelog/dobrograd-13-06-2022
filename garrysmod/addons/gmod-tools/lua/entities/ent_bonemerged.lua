
AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH

--[[
function ENT:Initialize() end
function ENT:Think() end
function ENT:PreEntityCopy() end
function ENT:PostEntityCopy() end
function ENT:PostEntityPaste() end
]]

if ( SERVER ) then return end

function ENT:Draw() self:DrawModel() end
function ENT:DrawTranslucent() self:Draw() end