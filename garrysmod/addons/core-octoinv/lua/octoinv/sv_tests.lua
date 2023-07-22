local ent, bot

local entityTests = {
	{
		name = 'Create entity',
		run = function(finish)
			ent = ents.Create('prop_physics')
			ent:SetModel('models/chairs/armchair.mdl')
			ent:SetPos(Vector(0,0,30))
			ent:Spawn()
			if not IsValid(ent) then return finish('Entity is not valid') end

			finish()
		end,
	}, {
		name = 'Import inventory',
		run = function(finish)
			ent:ImportInventory({ cont = { name = 'Container', volume = 50 }})
			finish()
		end,
	}, {
		name = 'Add items',
		run = function(finish)
			ent:AddItem('money', 1000)
			ent:AddItem('souvenir', { name = 'OctoRP', volume = 40 })
			finish()
		end,
	}, {
		name = 'Check given items',
		run = function(finish)
			if ent:HasItem('money') ~= 1000 then return finish('Money amount mismatch') end
			if ent:FindItem({ class = 'souvenir' }):GetData('volume') ~= 40 then return finish('Item volume mismatch') end
			if ent:FindItem({ class = 'souvenir' }):GetData('name') ~= 'OctoRP' then return finish('Item name mismatch') end
			finish()
		end,
	}, {
		name = 'Remove entity',
		run = function(finish)
			ent:GetInventory():Remove()
			if ent:GetInventory() ~= nil then return finish('Inventory not removed') end

			ent:Remove()
			finish()
		end,
	},
}

octolib.registerTests({
	name = 'octoinv',
	children = {
		{
			name = 'Entities',
			children = entityTests,
		},
	},
})
