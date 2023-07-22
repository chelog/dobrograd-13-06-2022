local footsteps = {
	['dirt'] = {
		'player/footsteps/dirt1.wav',
		'player/footsteps/dirt2.wav',
		'player/footsteps/dirt3.wav',
		'player/footsteps/dirt4.wav',
	},
	['concrete_block'] = {
		'player/footsteps/concrete1.wav',
		'player/footsteps/concrete2.wav',
		'player/footsteps/concrete3.wav',
		'player/footsteps/concrete4.wav',
	},
	['paper'] = {
		'physics/plaster/ceiling_tile_step1.wav',
		'physics/plaster/ceiling_tile_step2.wav',
		'physics/plaster/ceiling_tile_step3.wav',
		'physics/plaster/ceiling_tile_step4.wav',
	},
	['wood'] = {
		'player/footsteps/wood1.wav',
		'player/footsteps/wood2.wav',
		'player/footsteps/wood3.wav',
		'player/footsteps/wood4.wav',
	},
	['ice'] = {
		'physics/plaster/ceiling_tile_step1.wav',
		'physics/plaster/ceiling_tile_step2.wav',
		'physics/plaster/ceiling_tile_step3.wav',
		'physics/plaster/ceiling_tile_step4.wav',
	},
	['metal'] = {
		'player/footsteps/metal1.wav',
		'player/footsteps/metal2.wav',
		'player/footsteps/metal3.wav',
		'player/footsteps/metal4.wav',
	},
	['zombieflesh'] = {
		'physics/flesh/flesh_impact_hard1.wav',
		'physics/flesh/flesh_impact_hard2.wav',
		'physics/body/body_medium_impact_soft3.wav',
		'physics/body/body_medium_impact_soft4.wav',
	},
	['metal_bouncy'] = {
		'player/footsteps/metal1.wav',
		'player/footsteps/metal2.wav',
		'player/footsteps/metal3.wav',
		'player/footsteps/metal4.wav',
	},
	['rubber'] = {
		'player/footsteps/rubber.wav',
	},
	['slipperyslime'] = {
		'player/footsteps/mud1.wav',
		'player/footsteps/mud2.wav',
		'player/footsteps/mud3.wav',
		'player/footsteps/mud4.wav',
	},
	['glass'] = {
		'physics/glass/glass_sheet_step1.wav',
		'physics/glass/glass_sheet_step2.wav',
		'physics/glass/glass_sheet_step3.wav',
		'physics/glass/glass_sheet_step4.wav',
	},
	['gmod_ice'] = {
		'physics/plaster/ceiling_tile_step1.wav',
		'physics/plaster/ceiling_tile_step2.wav',
		'physics/plaster/ceiling_tile_step3.wav',
		'physics/plaster/ceiling_tile_step4.wav',
	},
	['gmod_bouncy'] = {
		'physics/flesh/flesh_impact_hard1.wav',
		'physics/flesh/flesh_impact_hard2.wav',
		'physics/body/body_medium_impact_soft3.wav',
		'physics/body/body_medium_impact_soft4.wav',
	},
	['fence'] = {
		'player/footsteps/chainlink1.wav',
		'player/footsteps/chainlink2.wav',
		'player/footsteps/chainlink3.wav',
		'player/footsteps/chainlink4.wav',
	},
	['grass'] = {
		'player/footsteps/grass1.wav',
		'player/footsteps/grass2.wav',
		'player/footsteps/grass3.wav',
		'player/footsteps/grass4.wav',
	},
	['gravel'] = {
		'player/footsteps/gravel1.wav',
		'player/footsteps/gravel2.wav',
		'player/footsteps/gravel2.wav',
		'player/footsteps/gravel3.wav',
	},
	['metal_grate'] = {
		'player/footsteps/metalgrate1.wav',
		'player/footsteps/metalgrate2.wav',
		'player/footsteps/metalgrate3.wav',
		'player/footsteps/metalgrate4.wav',
	},
	['sand'] = {
		'player/footsteps/sand1.wav',
		'player/footsteps/sand2.wav',
		'player/footsteps/sand3.wav',
		'player/footsteps/sand4.wav',
	},
	['water_slosh'] = {
		'player/footsteps/slosh1.wav',
		'player/footsteps/slosh2.wav',
		'player/footsteps/slosh3.wav',
		'player/footsteps/slosh4.wav',
	},
	['water_wade'] = {
		'player/footsteps/wade1.wav',
		'player/footsteps/wade2.wav',
		'player/footsteps/wade3.wav',
		'player/footsteps/wade4.wav',
		'player/footsteps/wade5.wav',
		'player/footsteps/wade6.wav',
		'player/footsteps/wade7.wav',
		'player/footsteps/wade8.wav',
	},
	['tile'] = {
		'player/footsteps/tile1.wav',
		'player/footsteps/tile2.wav',
		'player/footsteps/tile3.wav',
		'player/footsteps/tile4.wav',
	},
	['wood_panel'] = {
		'player/footsteps/woodpanel1.wav',
		'player/footsteps/woodpanel2.wav',
		'player/footsteps/woodpanel3.wav',
		'player/footsteps/woodpanel4.wav',
	},
	['duct_metal'] = {
		'player/footsteps/duct1.wav',
		'player/footsteps/duct2.wav',
		'player/footsteps/duct3.wav',
		'player/footsteps/duct4.wav',
	},
	['wood_box'] = {
		'physics/wood/wood_box_footstep1.wav',
		'physics/wood/wood_box_footstep2.wav',
		'physics/wood/wood_box_footstep3.wav',
		'physics/wood/wood_box_footstep4.wav',
	},
	['wood_box'] = {
		'physics/wood/ladder1.wav',
		'physics/wood/ladder2.wav',
		'physics/wood/ladder3.wav',
		'physics/wood/ladder4.wav',
	},
}

hook.Add('PlayerFootstep', 'dbg-physfootsteps', function(ply)
	local ent = ply:GetGroundEntity()
	if IsValid(ent) and not ent:IsWorld() then
		local physprop = ent:GetNetVar('physprop', nil)
		if not physprop then return end

		local sound = footsteps[physprop] and table.Random(footsteps[physprop])
		if not sound then return end

		if SERVER then
			ply:EmitSound(sound, 35)
		end

		return true
	end
end)

-- player meta

local plyMeta = FindMetaTable 'Player'
function plyMeta:isMedic()
	local job = self:getJobTable()
	return job and job.medic or false
end

function plyMeta:isEMS()
	if not IsValid(self) then return false end
	if self:isCP() then return true end
	if RPExtraTeams[self:Team()].ems then return true end
	return false
end

function plyMeta:isGov()
	if not IsValid(self) then return false end
	if self:isEMS() or DarkRP.isFirefighter(self) then return true end
	return false
end

DarkRP = DarkRP or {}

function DarkRP.isAdmin(ply)
	return ply:IsAdmin(), L.this_only_admin
end

function DarkRP.isSuperAdmin(ply)
	return ply:IsSuperAdmin()
end

function DarkRP.isAdminTeam(ply)
	return ply:Team() == TEAM_ADMIN
end

function DarkRP.isMayor(ply)
	return ply:isMayor() or false, L.can_do_only_mayor
end

function DarkRP.isChief(ply)
	return ply:isChief() or false, 'Это может делать только лейтенант полиции'
end

function DarkRP.isCop(ply)
	return ply:isCP() or false, L.this_only_police
end

function DarkRP.isMedic(ply)
	return ply:getJobTable().medic or false
end

function DarkRP.isMech(ply)
	return ply:getJobTable().mech or false
end

function DarkRP.isFirefighter(ply)
	return ply:Team() == TEAM_FIREFIGHTER
end

function DarkRP.isGov(ply)
	return ply:isGov() or false
end

function DarkRP.isWorker(ply)
	return ply:getJobTable().worker or false
end

function DarkRP.isTaxist(ply)
	return ply:Team() == TEAM_TAXI
end

function DarkRP.freeze(ply, ent, callback)
	local pos = ent:GetPos()
	timer.Simple(1, function()
		if ent:GetPos():DistToSqr(pos) > 1 then
			if isfunction(callback) then
				callback(false, L.unstable)
			end
			return
		end
		ent:GetPhysicsObject():EnableMotion(false)
		ent.static = true
		if isfunction(callback) then
			callback(true, L.item_freezed)
		end
		hook.Run('PlayerFrozeObject', ply, ent, ent:GetPhysicsObject())
	end)
end

function DarkRP.unfreeze(ply, ent)
	local ph = ent:GetPhysicsObject()
	ph:EnableMotion(true)
	ent.static = nil
	hook.Run('PlayerUnfrozeObject', ply, ent, ph)
end