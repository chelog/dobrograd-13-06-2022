AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

ENT.Model = 'models/props/de_nuke/nucleartestcabinet.mdl'
ENT.CollisionGroup = COLLISION_GROUP_NONE
ENT.Physics = true
ENT.Containers = {
	utilizer = {
		name = 'Утилизатор', icon = octolib.icons.color('inbox'), volume = 300,
		hooks = {
			{'canMoveIn', 'utilizer', function(cont, ply, item)
				if item and item.class ~= 'zip' and item.class ~= 'body_mat' then
					return false, 'Это запрещено загружать в утилизатор'
				end
			end},
		},
	},
	analyzer = { name = L.analyzer, icon = octolib.icons.color('microscope'), volume = 0.5,
		hooks = {
			{'canMoveIn', 'analyzer', function(cont, ply, item)
				if item and item.class ~= 'body_mat' then
					return false, 'Это запрещено загружать в анализатор'
				end
			end},
		},
	},
}

ENT.progressAnalysis = 0
ENT.progressUtilize = 0

function ENT:FinishAnalysis(item)

	if os.time() < item:GetData('expire') then
		local criminals = item:GetData('criminals')
		local text = #criminals > 0
			and L.analyzer_prints:format(table.concat(criminals, ', '))
			or L.analyzer_no_prints
		item:SetData('criminalsStr', text)
	else
		item:SetData('criminalsStr', L.analyzer_old_prints)
	end

	item:SetData('analysed', true)
	item:GetParent():QueueSync()
	self.progressAnalysis = 0
	self:EmitSound('weapons/ar2/ar2_reload_push.wav', 65)

end

function ENT:NextItem()
	local item = self.inv.conts.utilizer:GetItem(1)
	if not item or self.utilizerBusy then return end
	self.inv.conts.utilizer:TakeItem(item)
	self.progressUtilize = 0
	self.utilizerBusy = true
end

function ENT:Think()

	local item = self.inv.conts.analyzer:GetItem(1)
	if item and not item:GetData('analysed') then
		self.progressAnalysis = self.progressAnalysis + 0.05
		if self.progressAnalysis >= 1 then
			self:FinishAnalysis(item)
		else
			self:EmitSound('weapons/ar2/ar2_reload_rotate.wav', 65)
		end
	else
		self.progressAnalysis = 0
	end

	if self.utilizerBusy then
		self.progressUtilize = self.progressUtilize + 0.1
		if self.progressUtilize >= 1 then
			self.utilizerBusy = nil
			self:EmitSound('items/suitchargeno1.wav', 80)
			self:NextItem()
		else
			self:EmitSound('items/medshotno1.wav', 90)
		end
	end

	self:NextThink(CurTime() + 3)
	return true

end
