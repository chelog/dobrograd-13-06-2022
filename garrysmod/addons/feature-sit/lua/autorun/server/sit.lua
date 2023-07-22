--Oh my god I can sit anywhere! by Xerasin--
local NextUse = setmetatable({},{__mode='k'})
--[[local SitOnEnts = CreateConVar("sitting_can_sit_on_ents","1",{FCVAR_NOTIFY})
local PlayerEnts = CreateConVar("sitting_can_sit_on_player_ents","1",{FCVAR_NOTIFY})
local PlayerOtherEnts = CreateConVar("sitting_can_sit_on_other_player_ents","1",{FCVAR_NOTIFY})]]
local SitOnEntsMode = CreateConVar("sitting_ent_mode","3", {FCVAR_NOTIFY})
--[[
	0 - Can't sit on any ents
	1 - Can't sit on any player ents
	2 - Can only sit on your own ents
	3 - Any
]]
local SittingOnPlayer = CreateConVar("sitting_can_sit_on_players","1",{FCVAR_NOTIFY})
local SittingOnPlayer2 = CreateConVar("sitting_can_sit_on_player_ent","1",{FCVAR_NOTIFY})
local PlayerDamageOnSeats = CreateConVar("sitting_can_damage_players_sitting","0",{FCVAR_NOTIFY})
local AllowWeaponsInSeat = CreateConVar("sitting_allow_weapons_in_seat","0",{FCVAR_NOTIFY})
local AdminOnly = CreateConVar("sitting_admin_only","0",{FCVAR_NOTIFY})
local META = FindMetaTable("Player")
local EMETA = FindMetaTable("Entity")

local function ShouldAlwaysSit(ply)
	if not ms then return end
	if not ms.GetTheaterPlayers then return end
	if not ms.GetTheaterPlayers() then return end
	return ms.GetTheaterPlayers()[ply]
end


local disabledClasses = octolib.array.toKeys({'prop_ragdoll', 'player'})
local forcedClasses = octolib.array.toKeys({'prop_dynamic'})

local sittingPlayers = {}

local function Sit(ply, pos, ang, parent, parentbone, func, exit)
	if hook.Run('dbg-sit.allow', ply, parent, pos, ang) == false then return end
	if IsValid(parent) and not forcedClasses[parent:GetClass()] and IsValid(parent:GetPhysicsObject()) and parent:GetPhysicsObject():IsMotionEnabled() then return end
	if ply:GetVelocity():Length() > 0 or ply:KeyDown( IN_DUCK ) or
	ply:KeyDown( IN_WALK ) or !ply:IsOnGround() then return end

	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and wep:GetClass() == "weapon_physgun" then return end

	local up = ply:GetAngles():Up()
	local tr = util.QuickTrace( pos + up*20, up*37, ply )
	if !tr.Hit then
		ply:ExitVehicle()
		local vehicle = ents.Create("prop_vehicle_prisoner_pod")
		vehicle:SetAngles(ang)
		pos = pos + vehicle:GetUp()*(10 + 8 * ply:GetModelScale())
		vehicle:SetPos(pos)
		vehicle:SetThirdPersonMode( true )

		vehicle.playerdynseat=true
		vehicle.oldpos = ply:GetPos()
		vehicle.oldang = ply:EyeAngles()

		vehicle:SetModel("models/nova/airboat_seat.mdl") -- DO NOT CHANGE OR CRASHES WILL HAPPEN

		vehicle:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
		vehicle:SetKeyValue("limitview","0")
		vehicle:Spawn()
		vehicle:Activate()

		-- Let's try not to crash
		vehicle:SetMoveType(MOVETYPE_PUSH)
		vehicle:GetPhysicsObject():Sleep()
		vehicle:SetCollisionGroup(COLLISION_GROUP_NONE)

		vehicle:SetNotSolid(true)
		vehicle:GetPhysicsObject():Sleep()
		vehicle:GetPhysicsObject():EnableGravity(false)
		vehicle:GetPhysicsObject():EnableMotion(false)
		vehicle:GetPhysicsObject():EnableCollisions(false)
		vehicle:GetPhysicsObject():SetMass(1)

		-- Visibles
		vehicle:DrawShadow(false)
		vehicle:SetColor(Color(0,0,0,0))
		vehicle:SetRenderMode(RENDERMODE_TRANSALPHA)
		vehicle:SetNoDraw(true)

		vehicle.VehicleName = "Airboat Seat"
		vehicle.ClassOverride = "prop_vehicle_prisoner_pod"

		if parent and parent:IsValid() then
			local r = math.rad(ang.yaw+90)
			vehicle.plyposhack = vehicle:WorldToLocal(pos + Vector(math.cos(r)*2,math.sin(r)*2,2))

			vehicle:SetParent(parent)
			vehicle.parent=parent

		else
			vehicle.OnWorld = true
		end

		ply:SetAllowWeaponsInVehicle(true)

		ply:EnterVehicle(vehicle)
		sittingPlayers[#sittingPlayers + 1] = ply

		if PlayerDamageOnSeats:GetBool() then
			ply:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		end
		--print("VEHICLE",vehicle,"<-",ply,"PARENT:",vehicle:GetParent(),"D:",vehicle:GetPos():Distance(ply:GetPos()))

		vehicle.removeonexit = true
		vehicle.exit = exit
		--print("enter vehicle",ply,vehicle)

		local ang = vehicle:GetAngles()
		ply:SetEyeAngles(Angle(0,90,0))
		if func then
			func(ply)
		end

		-- used in hook
		if parent then
			vehicle.parent.exitOnUnfroze = true
			vehicle.parent.seats = vehicle.parent.seats or {}
			table.insert( vehicle.parent.seats, vehicle )
		end

		vehicle:SetNetVar( "saw", true )

		return vehicle
	else
		return nil
	end
end

hook.Add( "CanExitVehicle", "CustomExit",function( veh, ply )
	if veh:GetNetVar( "saw" ) then return false end
end)
hook.Add( "Think", "CustomExit", function()
	local toRem = {}
	for i = #sittingPlayers, 1, -1 do
		local ply = sittingPlayers[i]
		if not IsValid(ply) or not IsValid(ply:GetVehicle()) or not ply:GetVehicle():GetNetVar('saw') then
			toRem[#toRem + 1] = ply
			table.remove(sittingPlayers, i)
			continue
		end

		local veh = ply:GetVehicle()
		if ply:KeyDown(IN_JUMP) or veh.prevPos and veh.prevPos ~= veh:GetPos() then
			veh.oldang = ply:EyeAngles()
			toRem[#toRem + 1] = ply
			table.remove(sittingPlayers, i)
			continue
		else veh.prevPos = veh:GetPos() end

		if ply:KeyDown( IN_USE ) then
			if ply.sitUsed then return end

			local tr = octolib.use.getTrace(ply)
			if tr.Hit and IsValid(tr.Entity) and hook.Run('PlayerUse', ply, tr.Entity) ~= false then
				tr.Entity:Use(ply, ply, 1, 0)
			end

			ply.sitUsed = true
		else
			ply.sitUsed = false
		end
	end
	for _, v in ipairs(toRem) do
		if IsValid(v) and IsValid(v:GetVehicle()) and v:GetVehicle():GetNetVar('saw') then
			v:ExitVehicle()
		end
	end
end)

local function dropDriver( ent )
	for i,seat in ipairs( ent.seats ) do
		if IsValid(seat) and IsValid(seat:GetDriver()) then
			seat:GetDriver():ExitVehicle()
		end
	end

	table.remove( ent.seats, i )
end

hook.Add( "PhysgunPickup", "DisableSitOnPickup", function( ply, ent )
	if ent.exitOnUnfroze then dropDriver( ent ) end
end)

hook.Add( "OnPhysgunPickup", "DisableSitOnPickup", function( ply, ent )
	if ent.exitOnUnfroze then dropDriver( ent ) end
end)

hook.Add( "PlayerUnfrozeObject", "ExitOnUnfroze", function( ply, ent, physobj )
	if ent.exitOnUnfroze then dropDriver( ent ) end
end)

--[[
-- WHY DOES THIS NOT CRAHSH --
local vehicle = ents.Create("prop_vehicle_prisoner_pod")
	vehicle:SetPos(here)
	vehicle:SetModel("models/nova/airboat_seat.mdl") -- BECAUSE SIMPLE COLLISION MODEL D:
	vehicle:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
	vehicle:Spawn()
	vehicle:Activate()
	vehicle:SetMoveType(MOVETYPE_PUSH)
	vehicle:Phys():Sleep()
	vehicle:SetCollisionGroup(COLLISION_GROUP_NONE)
	vehicle:SetNotSolid(true)

	vehicle:Phys():EnableGravity(false)
	vehicle:Phys():EnableMotion(false)
	vehicle:Phys():EnableCollisions(false)
	vehicle:Phys():SetMass(1)
local this=this
		vehicle:SetParent(this)
		--vehicle:SetLocalPos(Vector(0,0,20))
	me:EnterVehicle(vehicle)--]]

local d=function(a,b) return math.abs(a-b) end

local SittingOnPlayerPoses =
{

	{
		Pos = Vector(-33,13,7),
		Ang = Angle(0,90,90),
		FindAng = 90,
	},
	{
		Pos = Vector(33,13,7),
		Ang = Angle(0,270,90),
		Func = function(ply)
			if(not ply:LookupBone("ValveBiped.Bip01_R_Thigh")) then return end
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Thigh"), Angle(0,90,0))
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Thigh"), Angle(0,90,0))
		end,
		OnExitFunc = function(ply)
			if(not ply:LookupBone("ValveBiped.Bip01_R_Thigh")) then return end
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Thigh"), Angle(0,0,0))
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Thigh"), Angle(0,0,0))
		end,
		FindAng = 270,
	},
	{
		Pos = Vector(0, 16, -15),
		Ang = Angle(0, 180, 0),
		Func = function(ply)
			if(not ply:LookupBone("ValveBiped.Bip01_R_Thigh")) then return end
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Thigh"), Angle(45,0,0))
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Thigh"), Angle(-45,0,0))
		end,
		OnExitFunc = function(ply)
			if(not ply:LookupBone("ValveBiped.Bip01_R_Thigh")) then return end
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Thigh"), Angle(0,0,0))
			ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Thigh"), Angle(0,0,0))
		end,
		FindAng = 0,
	},
	{
		Pos = Vector(0, 8, -18),
		Ang = Angle(0, 0, 0),
		FindAng = 180,
	},

}

local lookup={}
for k,v in pairs(SittingOnPlayerPoses) do
	table.insert(lookup,{v.FindAng,v})
	table.insert(lookup,{v.FindAng+360,v})
	table.insert(lookup,{v.FindAng-360,v})
end

local function FindPose(this,me)
	local avec=me:GetAimVector()
		avec.z=0
		avec:Normalize()
	local evec=this:GetRight()
		evec.z=0
		evec:Normalize()
	local derp=avec:Dot(evec)

	local avec=me:GetAimVector()
		avec.z=0
		avec:Normalize()
	local evec=this:GetForward()
		evec.z=0
		evec:Normalize()
	local herp=avec:Dot(evec)
	local v=Vector(derp,herp,0)
	local a=v:Angle()

	local ang=a.y
	assert(ang>=0)
	assert(ang<=360)
	ang=ang+90+180
	ang=ang%360

	table.sort(lookup,function(aa,bb)
		return 	d(ang,aa[1])<d(ang,bb[1])
	end)
	return lookup[1][2]
end


local blacklist = { ["gmod_wire_keyboard"] = true }
local model_blacklist = {  -- I need help finding out why these crash
	--[[["models/props_junk/sawblade001a.mdl"] = true,
	["models/props_c17/furnitureshelf001b.mdl"] = true,
	["models/props_phx/construct/metal_plate1.mdl"] = true,
	["models/props_phx/construct/metal_plate1x2.mdl"] = true,
	["models/props_phx/construct/metal_plate1x2_tri.mdl"] = true,
	["models/props_phx/construct/metal_plate1_tri.mdl"] = true,
	["models/props_phx/construct/metal_plate2x2.mdl"] = true,
	["models/props_phx/construct/metal_plate2x2_tri.mdl"] = true,
	["models/props_phx/construct/metal_plate2x4.mdl"] = true,
	["models/props_phx/construct/metal_plate2x4_tri.mdl"] = true,
	["models/props_phx/construct/metal_plate4x4.mdl"] = true,
	["models/props_phx/construct/metal_plate4x4_tri.mdl"] = true,]]
}

function META.Sit(ply, EyeTrace, ang, parent, parentbone, func, exit)
	if EyeTrace == nil then
		EyeTrace = ply:GetEyeTrace()
	end
	if type(EyeTrace)=="Vector" then
		return Sit(ply, EyeTrace, ang or Angle(0,0,0), parent, parentbone or 0, func, exit)
	end
	if not EyeTrace.Hit then return end
	--[[Player on player]]
	if EyeTrace.HitPos:Distance(EyeTrace.StartPos) > 100 then return end
	local sitting_disallow_on_me = false
	if SittingOnPlayer:GetBool() then
		for k,v in pairs(ents.FindInSphere(EyeTrace.HitPos, 5)) do
			local safe=256 -- maxplayers engine supports anyway
			while IsValid(v.SittingOnMe) and safe>0 do
				safe=safe - 1
				v=v.SittingOnMe
			end
			if(v:GetClass() == "prop_vehicle_prisoner_pod"
			and v:GetModel() ~= "models/vehicles/prisoner_pod_inner.mdl"
			and v:GetDriver()
			and v:GetDriver():IsValid()
			and not v.PlayerSitOnPlayer
			) then
				if v:GetDriver():GetInfoNum("sitting_disallow_on_me",0)~=0 then
					return
				end

				if sitting_disallow_on_me then
					ply:ChatPrint(L.cant_sit_on_players)
					return
				end

				local pose = FindPose(v,ply) -- SittingOnPlayerPoses[math.random(1, #SittingOnPlayerPoses)]
				local pos = v:GetDriver():GetPos()
				if(v.plyposhack) then
					pos = v:LocalToWorld(v.plyposhack)
				end
				local vec,ang = LocalToWorld(pose.Pos, pose.Ang, pos, v:GetAngles())
				if v:GetParent() == ply then return end
				local ent = Sit(ply, vec, ang, v, 0, pose.Func, pose.OnExitFunc)
				--print("sit",ply,ent,v:GetDriver(),v)
				if IsValid(ent) then
					ent.PlayerOnPlayer = true
					v.SittingOnMe = ent
				end
				return ent
			end
		end
	else
		for k,v in pairs(ents.FindInSphere(EyeTrace.HitPos, 5)) do
			if(v.removeonexit) then
				return
			end
		end
	end

	if(not EyeTrace.HitWorld and SitOnEntsMode:GetInt() == 0) then return end
	if(not EyeTrace.HitWorld and blacklist[string.lower(EyeTrace.Entity:GetClass())]) then return end
	if(not EyeTrace.HitWorld and EyeTrace.Entity:GetModel() and model_blacklist[string.lower(EyeTrace.Entity:GetModel())]) then return end
	if(EMETA.CPPIGetOwner) then
		--print(SitOnEntsMode:GetInt())
		if(SitOnEntsMode:GetInt() >= 1) then
			if(SitOnEntsMode:GetInt() == 1) then
				if(not EyeTrace.HitWorld) then
					local owner = EyeTrace.Entity:CPPIGetOwner()
					if(owner ~= nil and owner:IsValid() and owner:IsPlayer()) then
						return
					end
				end
			end
			if(SitOnEntsMode:GetInt() == 2) then
				if(not EyeTrace.HitWorld) then
					local owner = EyeTrace.Entity:CPPIGetOwner()
					if(owner ~= nil and owner:IsValid() and owner:IsPlayer() and owner ~= ply) then
						return
					end
				end
			end
		end
	end
	local ang = EyeTrace.HitNormal:Angle() + Angle(-270, 0, 0)
	if(math.abs(ang.pitch) <= 15) then
		local ang = Angle()
		local filter = player.GetAll()
		local dists = {}
		local distsang = {}
		local ang_smallest_hori = nil
		local smallest_hori = 90000
		for I=0,360,15 do
			local rad = math.rad(I)
			local dir = Vector(math.cos(rad), math.sin(rad), 0)
			local trace = util.QuickTrace(EyeTrace.HitPos + dir*20 + Vector(0,0,5), Vector(0,0,-15000), filter)
			trace.HorizontalTrace = util.QuickTrace(EyeTrace.HitPos + Vector(0,0,5), (dir) * 1000, filter)
			trace.Distance  =  trace.StartPos:Distance(trace.HitPos)
			trace.Distance2 = trace.HorizontalTrace.StartPos:Distance(trace.HorizontalTrace.HitPos)
			trace.ang = I

			if((not trace.Hit or trace.Distance > 14) and (not trace.HorizontalTrace.Hit or trace.Distance2 > 20)) then
				table.insert(dists,trace)

			end
			if(trace.Distance2 < smallest_hori and (not trace.HorizontalTrace.Hit or trace.Distance2 > 3)) then
				smallest_hori = trace.Distance2
				ang_smallest_hori = I
			end
			distsang[I] = trace
		end
		local infront = ((ang_smallest_hori or 0) + 180) % 360

		if(ang_smallest_hori and distsang[infront].Hit and distsang[infront].Distance > 14 and smallest_hori <= 16) then
			local hori = distsang[ang_smallest_hori].HorizontalTrace
			ang.yaw = (hori.HitNormal:Angle().yaw - 90)
			local ent = nil
			if not EyeTrace.HitWorld then
				ent = EyeTrace.Entity
				if ent:IsPlayer() and not SittingOnPlayer2:GetBool() then return end

				if ent:IsPlayer() and ent:GetInfoNum("sitting_disallow_on_me",0)==1 then
					return
				end
				if sitting_disallow_on_me then
					ply:ChatPrint(L.cant_sit_on_players)
					return
				end
			end
			local vehicle = Sit(ply, EyeTrace.HitPos-Vector(0,0,20), ang, ent, EyeTrace.PhysicsBone or 0)
			--print("sit3",ply,"->",vehicle,ply:GetPos():Distance(EyeTrace.Entity:GetPos()))
			return vehicle
		else
			table.sort(dists, function(a,b) return b.Distance < a.Distance end)
			local wants = {}
			local eyeang = ply:EyeAngles() + Angle(0,180,0)
			for I=1,#dists do
				local trace = dists[I]
				local behind = distsang[(trace.ang + 180) % 360]
				if behind.Distance2 > 3 then
					local cost = 0
					if(trace.ang % 90 ~= 0) then cost = cost + 12 end
					--[[if(ShouldAlwaysSit(ply)) then
						if(trace.ang ~= 180) then cost = cost + 100 end
					end]]
					if(math.abs(eyeang.yaw - trace.ang) > 12) then
						cost = cost + 30
					end
					local tbl = {
						cost = cost,
						ang = trace.ang,
					}
					table.insert(wants, tbl)
				end
			end
			table.sort(wants,function(a,b) return b.cost > a.cost end)
			if(#wants == 0) then return end
			ang.yaw = (wants[1].ang - 90)
			local ent = nil
			if not EyeTrace.HitWorld then
				ent = EyeTrace.Entity
				if ent:IsPlayer() and not SittingOnPlayer2:GetBool() then return end
				if ent:IsPlayer() and IsValid(ent:GetVehicle()) and ent:GetVehicle():GetParent() == ply then return end

				if ent:IsPlayer() and ent:GetInfoNum("sitting_disallow_on_me",0)==1 then
					return
				end
				if sitting_disallow_on_me then
					ply:ChatPrint(L.cant_sit_on_players)
					return
				end
			end
			local vehicle = Sit(ply, EyeTrace.HitPos - Vector(0,0,20), ang, ent, EyeTrace.PhysicsBone or 0)

			return vehicle
		end

	end

end


local function sitcmd(ply)
	if ply:InVehicle() then return end
	if AdminOnly:GetBool() then
		if not ply:IsAdmin() then return end
	end
	local now=CurTime()

	local nextuse = NextUse[ply] or now

	if nextuse>now then
		--ply:ChatPrint("Can not sit again that fast")
		return
	end

	-- do want to prevent player getting off right after getting in but how :C
	if ply:Sit() then
		--ply:ChatPrint("You sat down")
		nextuse=now + 1
	end

	NextUse[ply] = nextuse + 0.1

end


-- hook.Add("CanExitVehicle","noinstaleave",function(veh,ply)

-- 	if not veh.playerdynseat then return end

-- 	local now=CurTime()

-- 	local nextuse = NextUse[ply] or now

-- 	if nextuse > now then
-- 		--ply:ChatPrint("Can not leave just yet")
-- 			return false
-- 		--else
-- 		--ply:ChatPrint("You stopped sitting")
-- 	end

-- 	veh.oldang = ply:EyeAngles()
-- end)

concommand.Add("sit",function(ply, cmd, args)
	sitcmd(ply)
end)

hook.Add("KeyPress","seats_use",function(ply,key)
	if key ~= IN_USE then return end

	local walk = ply:KeyDown( IN_SPEED ) or ShouldAlwaysSit(ply)
	if not walk then return end

	sitcmd(ply)

end)


hook.Add("PlayerLeaveVehicle","Remove_Seat",function(ply,self)
	if(self.removeonexit and self:GetClass()=="prop_vehicle_prisoner_pod") then
		NextUse[ply] = CurTime() + 1
		if(self.exit) then
			self.exit(ply)
		end

		if ply then
			ply:SetPos(self.oldpos)
			ply:SetEyeAngles(self.oldang)
			if ply.UnStuck then
				--[[timer.Simple(0,function()
					ply:UnStuck()
				end)]]
			end
		end

		self:Remove()
	end
end)


hook.Add("AllowPlayerPickup","Nopickupwithalt",function(ply)
	if(ply:KeyDown(IN_SPEED)) then
		return false
	end
end)

hook.Add("PlayerDeath","SitSeat",function(pl)
	for k,v in ipairs(player.GetAll()) do
		local veh = v:GetVehicle()
		if veh:IsValid() and veh.playerdynseat and veh:GetParent()==pl then
			veh:Remove()
		end
	end
end)

hook.Add("PlayerEnteredVehicle","unsits",function(pl,veh)
	for k,v in ipairs(player.GetAll()) do
		if v~=pl and v:InVehicle() and v:GetVehicle():IsValid() and v:GetVehicle():GetParent()==pl then
			v:ExitVehicle()
		end
	end

	DropEntityIfHeld( veh )

	if veh:GetParent():IsValid() then
		DropEntityIfHeld( veh:GetParent() )
	end

end)

hook.Add("EntityRemoved","Sitting_EntityRemoved",function(ent)
	for k,v in ipairs(ents.FindByClass("prop_vehicle_prisoner_pod")) do
		if(v:GetParent() == ent) then
			if IsValid(v:GetDriver()) then
				v:GetDriver():ExitVehicle()
				v:Remove()
			end
		end
	end
end)

timer.Create("RemoveSeats",15,0,function()
	for k,v in pairs(ents.FindByClass("prop_vehicle_prisoner_pod")) do
		if(v.removeonexit and (v:GetDriver() == nil or not v:GetDriver():IsValid() or v:GetDriver():GetVehicle() ~= v --[[???]])) then
			v:Remove()
		end
	end
end)

hook.Add("InitPostEntity", "SAW_CompatFix", function()
	if hook.GetTable()["CanExitVehicle"]["PAS_ExitVehicle"] and PM_SendPassengers then
		local function IsSCarSeat( seat )
			if IsValid(seat) and seat.IsScarSeat and seat.IsScarSeat == true then
					return true
			end
			return false
		end
		hook.Add("CanExitVehicle", "PAS_ExitVehicle", function( veh, ply )
			if !IsSCarSeat( veh ) and not veh.playerdynseat and veh.vehicle then
				// L+R
				if ply:VisibleVec( veh:LocalToWorld(Vector(80, 0, 5) )) then
						ply:ExitVehicle()
						ply:SetPos( veh:LocalToWorld(Vector(75, 0, 5) ))
						if veh:GetClass() == "prop_vehicle_prisoner_pod" && !(ply == veh.vehicle:GetDriver()) then PM_SendPassengers( veh.vehicle:GetDriver() ) end
						return false
				end

				if ply:VisibleVec( veh:LocalToWorld(Vector(-80, 0, 5) )) then
						ply:ExitVehicle()
						ply:SetPos( veh:LocalToWorld(Vector(-75, 0, 5) ))
						if veh:GetClass() == "prop_vehicle_prisoner_pod" && !(ply == veh.vehicle:GetDriver()) then PM_SendPassengers( veh.vehicle:GetDriver() ) end
						return false
				end
			end
			--return false --//YOU SHOULDNT RETURN HERE! THIS WILL OVERRIDE THE HOOKS FOR ALL OTHER MOUNTED ADDONS
		end)
	end
end)

--[[_duplicatorCopy = _duplicatorCopy or duplicator.Copy
function duplicator.Copy(...)
	local tab = _duplicatorCopy(...)
	if(tab and tab.Entities and tab.Constraints) then
		for k,v in pairs(tab.Entities) do
			if(v.removeonexit) then
				tab.Entities[k] = nil
			end
		end
		for k,v in pairs(tab.Constraints) do
			if(v.Entity) then
				if (v.Entity[1] and v.Entity[1].Entity and v.Entity[1].Entity.removeonexit) or (v.Entity[2] and v.Entity[2].Entity and v.Entity[2].Entity.removeonexit) then
					tab.Constraints[k] = nil
				end
			end
		end
	end
	return tab
end]]
