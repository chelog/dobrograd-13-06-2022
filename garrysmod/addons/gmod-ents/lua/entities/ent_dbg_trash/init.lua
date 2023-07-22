AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'

include 'shared.lua'

local maxItems = 2
local regenTime = 5 * 60
local searchTime = 15

function ENT:Initialize()

	self.BaseClass.Initialize(self)

	self.items = maxItems
	self.innerCont = self:GetInventory():AddContainer('trashInner', { volume = 0 })

	self.onUserRemove = function(cont, ply)
		if ply == self then return end -- player isn't trash .__.
		for _, item in ipairs(cont.items) do
			self.innerCont:AddItem(item)
			hook.Run('dbg-trash.add', self, ply, item)
		end
		cont:Remove()
	end

end

function ENT:NonHoboUse(ply)

	local sid = ply:SteamID()
	local inv = self:GetInventory()
	local cont = inv:GetContainer(sid) or inv:AddContainer(sid, {
		name = 'Мусорка',
		volume = 999,
		icon = octolib.icons.color('trash'),
	}):Hook('userRemove', 'flushTrash', self.onUserRemove)
	ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
	timer.Simple(0.5, function()
		if not (IsValid(self) and IsValid(ply)) then return end
		ply:OpenInventory(inv, { sid })
	end)

end

function ENT:Use(ply)

	if self.pendingWorker == ply then
		local volume = math.min(100, (-self.innerCont:FreeSpace()) / 10)
		if not (ply.inv and ply.inv.conts._hand and ply.inv.conts._hand:FreeSpace() >= volume) then
			return ply:Notify('warning', 'Освободи руки, чтобы собрать мусор')
		end
		ply:ClearMarkers('work1')
		ply:DelayedAction('work', 'Сбор мусора', {
			time = 8,
			check = function() return octolib.use.check(ply, self) and ply.inv and ply.inv.conts._hand and ply.inv.conts._hand:FreeSpace() >= volume end,
			succ = function()
				self.innerCont:Clear()
				ply.inv.conts._hand:AddItem('souvenir', {
					name = 'Мусор',
					desc = 'Заполненный мусорный мешок',
					model = 'models/props_junk/garbage_bag001a.mdl',
					icon = octolib.icons.color('trash_pile'),
					mass = math.min(volume / 10, 10),
					volume = volume,
					expire = os.time() + 60 * 60
				})
				ply:Notify('Теперь отнеси этот мешок в указанную точку на утилизацию')
				self.pendingWorker = nil
				hook.Run('dbg-trash.empty', self, ply)
			end,
		}, {
			time = 1.5,
			inst = true,
			action = function()
				ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
				self:EmitSound('physics/cardboard/cardboard_box_strain'..math.random(1,3)..'.wav', 60, 100, 0.75)
			end,
		})
		return
	end

	if not ply:getJobTable().hobo then
		return self:NonHoboUse(ply)
	end

	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) or wep:GetClass() ~= 'dbg_hands' then
		ply:Notify('warning', L.trash_can_search)
		return
	end

	ply:DelayedAction('trash', L.trash_search, {
		time = searchTime,
		check = function() return octolib.use.check(ply, self) end,
		succ = function()
			if self.items <= 0 and not self.innerCont.items[1] then
				ply:Notify('warning', L.trash_nothing)
				return
			end

			local item
			if self.innerCont.items[1] then
				item = { self.innerCont.items[1].class, self.innerCont.items[1]:Export() }
				self.innerCont:TakeItem(self.innerCont.items[1])
			end
			if not item then
				item = octoinv.getRandomLoot({mode = 'trash', flatten = math.Clamp(ply:GetKarma() or 0, -1000, 1000) / 2000}).item
				self.items = self.items - 1
			end
			ply.inv.conts._hand:AddItem(unpack(item))
			hook.Run('dbg-trash.loot', self, ply, item)
			ply:Notify((L.trash_searched):format(octoinv.itemStr(item)))
		end,
	}, {
		time = 1.5,
		inst = true,
		action = function()
			ply:DoAnimation(ACT_GMOD_GESTURE_ITEM_PLACE)
		end,
	})

end

function ENT:Think()

	if self.items >= maxItems then return end

	self.items = self.items + 1
	self:NextThink(CurTime() + regenTime)
	return true

end
