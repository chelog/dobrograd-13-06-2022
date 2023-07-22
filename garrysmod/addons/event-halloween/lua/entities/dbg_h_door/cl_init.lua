include 'shared.lua'

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.RenderGroup 		= RENDERGROUP_BOTH

function ENT:Draw()

	self:DrawModel()

end

netstream.Hook('dbg-halloween.playPhrase', function(ent, snd)
	sound.PlayFile(snd, '3d', function(st)
		if IsValid(st) then
			st:SetPos(ent:LocalToWorld(ent:OBBCenter()))
			st:Set3DFadeDistance(55, 80)
			st:Play()
		end
	end)
end)
