local angle_zero = Angle(0, 0, 0)

local plyMeta = FindMetaTable 'Player'
function plyMeta:IsMaskVisible()
	if self.maskVisible ~= nil then return self.maskVisible end
	return self ~= LocalPlayer()
end
function plyMeta:SetMaskVisible(vis)
	self.maskVisible = vis
	if IsValid(self.hMask) then self.hMask:SetNoDraw(not self:IsMaskVisible()) end
end
netstream.Hook('dbg-mask.SetMaskVisible', plyMeta.SetMaskVisible)

local maskEnts = {}
local maxDist = 2250000
timer.Create('dbg-masks', 1, 0, function()

	local me = LocalPlayer()
	if not IsValid(me) then return end

	local pos = me:EyePos()
	for _, ply in ipairs(player.GetAll()) do

		local class = ply:GetMaskId()
		local mask = ply.hMask

		if not class or IsValid(mask) and mask.maskClass ~= class or ply:GetPos():DistToSqr(pos) > maxDist or ply:GetNoDraw() or ply:GetNetVar('Ghost') then
			if IsValid(ply.hMask) then ply.hMask:Remove() end
			continue
		end

		if not IsValid(mask) then
			local data = CFG.masks[class]
			if not data then continue end

			mask = octolib.createDummy(data.mdl)
			mask.maskClass = class
			ply.hMask = mask

			mask:SetParent(ply, ply:LookupAttachment('eyes') or 1)
			mask:SetLocalPos(data.pos)
			mask:SetLocalAngles(data.ang or angle_zero)
			if data.scale then mask:SetModelScale(data.scale) end
			if data.skin then mask:SetSkin(data.skin) end
			mask:SetPredictable(true)

			table.insert(maskEnts, mask)
			mask:SetNoDraw(not ply:IsMaskVisible())
		end
	end

	for i = #maskEnts, 1, -1 do
		local mask = maskEnts[i]
		if IsValid(mask) and not IsValid(mask:GetParent()) then
			mask:Remove()
		end
		if not IsValid(mask) then table.remove(maskEnts, i) end
	end

end)
