
--[[
Stungun SWEP Created by Donkie (http://steamcommunity.com/id/Donkie/)
For personal/server usage only, do not resell or distribute!
]]

AddCSLuaFile("shared.lua")
AddCSLuaFile("config/stungun.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

local ragdolls = {}

function SWEP:Equip( ply )
	self.BaseClass.Equip(self,ply)
	self.lastowner = ply
end

util.AddNetworkString("tazerondrop")
function SWEP:OnDrop()
	self.BaseClass.OnDrop(self)
	if IsValid(self.lastowner) then
		net.Start("tazerondrop")
			net.WriteEntity(self)
		net.Send(self.lastowner)
	end
end


--[[
Makes a hull trace the size of a player.
]]
local hulltrdata = {}
function STUNGUN.PlayerHullTrace(pos, ply, filter)
	hulltrdata.start = pos
	hulltrdata.endpos = pos
	hulltrdata.filter = filter

	return util.TraceEntity( hulltrdata, ply )
end

--[[
Attemps to place the player at this position or as close as possible.
]]
-- Directions to check
local directions = {
	Vector(0,0,0), Vector(0,0,1), -- Center and up
	Vector(1,0,0), Vector(-1,0,0), Vector(0,1,0), Vector(0,-1,0) -- All cardinals
	}
for deg = 45, 315, 90 do -- Diagonals
	local r = math.rad(deg)
	table.insert(directions, Vector(math.Round(math.cos(r)), math.Round(math.sin(r)), 0))
end

local magn = 15 -- How much increment for each iteration
local iterations = 2 -- How many iterations
function STUNGUN.PlayerSetPosNoBlock( ply, pos, filter )
	local tr

	local dirvec
	local m = magn
	local i = 1
	local its = 1
	repeat
		dirvec = directions[i] * m
		i = i + 1
		if i > #directions then
			its = its + 1
			i = 1
			m = m + magn
			if its > iterations then
				ply:SetPos(pos) -- We've done as many checks as we wanted, lets just force him to get stuck then.
				return false
			end
		end

		tr = STUNGUN.PlayerHullTrace(dirvec + pos, ply, filter)
	until tr.Hit == false

	ply:SetPos(pos + dirvec)
	return true
end

--[[
Sets the player invisible/visible
]]
function STUNGUN.PlayerInvis( ply, bool )
	ply:SetNoDraw(bool)
	ply:DrawShadow(not bool)
	ply:SetCollisionGroup(bool and COLLISION_GROUP_IN_VEHICLE or COLLISION_GROUP_PLAYER)
	ply:SetNotSolid(bool)
	ply:DrawWorldModel(not bool)
	ply._stungunfrozen = bool

	if bool then
		ply:Lock()
	else
		ply:UnLock()
	end
end

octolib.func.loop(function(done)
	octolib.func.throttle(player.GetAll(), 10, 0.2, function(ply)
		if IsValid(ply) and ply._stungunfrozen then
			ply:DrawWorldModel(false)
		end
	end):Then(done)
end)

--[[
Deploy player ragdoll
]]
function STUNGUN.Ragdoll( ply, pushdir )
	local plyphys = ply:GetPhysicsObject()
	local plyvel = Vector(0,0,0)
	if plyphys:IsValid() then
		plyvel = plyphys:GetVelocity()
	end

	ply.tazedpos = ply:GetPos() -- Store pos incase the ragdoll is missing when we're to unrag him.

	if IsValid(ply:GetVehicle()) then
		ply:ExitVehicle()
	end

	local weapon = ply:GetActiveWeapon()
	if IsValid(weapon) and not (GAMEMODE.Config.DisallowDrop[ weapon:GetClass() ] or ply:jobHasWeapon(weapon:GetClass())) then
		ply:dropDRPWeapon( weapon )
	end

	local mdl, sk, bg = ply:GetModel(), ply:GetSkin(), ply:GetBodyGroups()
	if STUNGUN.BrokenModels[mdl] then
		mdl, sk, bg = STUNGUN.DefaultModel, 0, '0'
	end

	local rag = ents.Create("prop_ragdoll")
		rag:SetModel(mdl)
		rag:SetSkin(sk)
		rag:SetBodyGroups(bg)
		rag:SetPos(ply:GetPos())
		rag:SetAngles(Angle(0,ply:GetAngles().y,0))
		rag:SetColor(ply:GetColor())
		rag:SetMaterial(ply:GetMaterial())
		rag:Spawn()
		rag:Activate()
		rag:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	ragdolls[rag] = true

	if not IsValid(rag:GetPhysicsObject()) then
		SafeRemoveEntity(rag)

		if STUNGUN.DefaultModel then
			rag = ents.Create("prop_ragdoll")
				rag:SetModel(STUNGUN.DefaultModel)
				rag:SetPos(ply:GetPos())
				rag:SetAngles(Angle(0,ply:GetAngles().y,0))
				rag:SetColor(ply:GetColor())
				rag:SetMaterial(ply:GetMaterial())
				rag:Spawn()
				rag:Activate()
		else
			MsgN("A tazed player didn't get a valid ragdoll. Model (" .. ply:GetModel() .. ")!")
			return false
		end
	end

	rag.tazesnd = CreateSound(rag, "stungun/tazer.wav")
	rag.tazesnd:PlayEx(1, 70)

	-- Lower inertia makes the ragdoll have trouble rolling. Citizens have 1,1,1 as default, while combines have 0.2,0.2,0.2.
	rag:GetPhysicsObject():SetInertia(Vector(1,1,1))

	-- Set mass of all limbs, forces and shit are weird if mass is not same.
	-- for i = 1, rag:GetPhysicsObjectCount() do
	-- 	if IsValid(rag:GetPhysicsObject(i-1)) then
	-- 		rag:GetPhysicsObject(i-1):SetMass(12.7)
	-- 	end
	-- end

	-- Push him back abit
	plyvel = plyvel + pushdir * 50

	-- Code copied from TTT
	local num = rag:GetPhysicsObjectCount() - 1
	for i = 0, num do
		local bone = rag:GetPhysicsObjectNum(i)
		if IsValid(bone) then
			local bp, ba = ply:GetBonePosition(rag:TranslatePhysBoneToBone(i))
			if bp and ba then
				bone:SetPos(bp)
				bone:SetAngles(ba)
			end

			bone:SetVelocity(plyvel)
		end
	end

	-- Prevents any kind of pickup if user don't want him to
	rag.CanPickup = STUNGUN.CanPickup

	-- Handcuff support
	local cuffs = ply:GetWeapon("weapon_cuffed")
	if IsValid(cuffs) then
		-- if cuffs:GetIsLeash() then
		-- 	rag.isleashed = true
		-- 	rag.leashowner = cuffs:GetKidnapper()
		-- 	rag.ropelength = cuffs:GetRopeLength()
		-- else
			rag.iscuffed = true
		-- end

		-- rag:SetNWBool("cuffs_isleash", rag.isleashed)
	end

	-- Make him follow the ragdoll, if the player gets away from the ragdoll he won't get stuff rendered properly.
	ply:SetParent(rag)

	-- Make the player invisible.
	STUNGUN.PlayerInvis(ply, true)

	ply.tazeragdoll = rag
	rag.tazeplayer = ply
	rag:SetDTEntity(1, ply) -- Used to gain instant access to player on client

	ply:SetNWEntity("tazerviewrag", rag)
	rag:SetNWEntity("plyowner", ply)
	ply:SetNWBool("tazefrozen", true)
	ply:SetNetVar('DeathRagdoll', rag)

	return true
end

function STUNGUN.UnRagdoll( ply )
	local ragvalid = IsValid(ply.tazeragdoll)
	local pos
	if ragvalid then -- Sometimes the ragdoll is missing when we want to unrag, not good!
		if ply.tazeragdoll.hasremoved then return end -- It has already been removed.

		pos = ply.tazeragdoll:GetPos()
		-- ply:SetModel(ply.tazeragdoll:GetModel())
		if ply.tazeragdoll.tazesnd then
			ply.tazeragdoll.tazesnd:Stop()
			ply.tazeragdoll.tazesnd = nil
		end
		ply.tazeragdoll.hasremoved = true
	else
		pos = ply.tazedpos -- Put him at the place he got tazed, works great.
	end
	ply:SetParent()

	STUNGUN.PlayerSetPosNoBlock(ply, pos, {ply, ply.tazeragdoll})

	timer.Simple(0,function()
		SafeRemoveEntity(ply.tazeragdoll)
		STUNGUN.PlayerInvis(ply, false)
	end)

	net.Start("tazeendview")
	net.Send(ply)
end


util.AddNetworkString("tazestartview")
util.AddNetworkString("tazeendview")

function STUNGUN.Electrolute( ply, pushdir )
	if ply.tazeimmune then return end

	-- Ragdoll
	STUNGUN.Ragdoll(ply, pushdir)

	-- Gag
	ply.tazeismuted = true

	ply:SetNetVar('Tased', true)

	local id = ply:UserID()
	timer.Create("Unelectrolute" .. id, STUNGUN.ParalyzedTime, 1, function()
		if IsValid(ply) then STUNGUN.UnElectrolute( ply ) end
	end)
	timer.Create("tazeUngag" .. id, STUNGUN.MuteTime, 1, function()
		if IsValid(ply) then STUNGUN.UnMute( ply ) end
	end)

	timer.Create("HurtingTimer" .. id,2,0,function()
		if not IsValid(ply) or not IsValid(ply.tazeragdoll) then timer.Remove("HurtingTimer" .. id) return end
		ply.tazeragdoll:EmitSound(STUNGUN.PlayHurtSound(ply), 70, 100, 1)
	end)

	hook.Call("PlayerHasBeenTazed", GAMEMODE, ply, ply.tazeragdoll)
end

function STUNGUN.UnMute( ply )
	ply.tazeismuted = false
end

function STUNGUN.UnElectrolute( ply )
	STUNGUN.UnRagdoll( ply )
	timer.Remove("HurtingTimer" .. ply:UserID())

	hook.Call("PlayerUnTazed", GAMEMODE, ply)

	local unfreezef = function()
		ply:SetNWBool("tazefrozen", false)

		hook.Call("PlayerTazeUnFrozen", GAMEMODE, ply)
	end
	if (STUNGUN.FreezeTime or 0) > 0 then
		timer.Create("StungunPlayerFreeze" .. ply:UserID(), STUNGUN.FreezeTime, 1, unfreezef)
	else
		unfreezef()
	end

	if STUNGUN.Immunity > 0 then
		ply.tazeimmune = true
		timer.Simple(STUNGUN.Immunity, function()
			if IsValid(ply) then
				ply.tazeimmune = false
			end
		end)
	end

	ply:SetNetVar('Tased', nil)
end
STUNGUN.Unelectrolute = STUNGUN.UnElectrolute

hook.Add("PlayerSay", "Tazer", function(ply, str)
	if ply.tazeismuted then return "" end
end)

util.AddNetworkString("tazersendhealth")
hook.Add("Think", "Tazer", function()
	for ragdoll, _ in pairs(ragdolls) do
		if IsValid(ragdoll) and IsValid(ragdoll.tazeplayer) then
			local v = ragdoll.tazeplayer
			local mode = 0
			if STUNGUN.PhysEffect then
				mode = STUNGUN.PhysEffect
			elseif STUNGUN.ShouldRoll != nil then
				mode = STUNGUN.ShouldRoll and 1 or 0
			end

			if mode > 0 then
				local rag = ragdoll
				local phys = rag:GetPhysicsObjectNum(0)
				if phys:IsValid() then
					if mode == 1 then
						phys:AddAngleVelocity(Vector(0,math.sin(CurTime()) * 1200 * FrameTime(),0))
					elseif mode == 2 then
						local vel = VectorRand() * 5
						for i = 1, rag:GetPhysicsObjectCount() do
							if IsValid(rag:GetPhysicsObject(i-1)) then
								rag:GetPhysicsObjectNum(i-1):AddVelocity(vel)
							end
						end
					end

					-- Pulls the hands together if he's cuffed
					if rag.iscuffed then
						local lhandbonenum = rag:LookupBone("ValveBiped.Bip01_L_Hand")
						local rhandbonenum = rag:LookupBone("ValveBiped.Bip01_R_Hand")
						if lhandbonenum and rhandbonenum then
							local lhandnum = rag:TranslateBoneToPhysBone(lhandbonenum)
							local rhandnum = rag:TranslateBoneToPhysBone(rhandbonenum)

							if lhandnum and rhandnum then
								local lhand = rag:GetPhysicsObjectNum(lhandnum)
								local rhand = rag:GetPhysicsObjectNum(rhandnum)

								if lhand and rhand then
									local vel = (rhand:GetPos() - lhand:GetPos()) * 2
									lhand:AddVelocity(vel)
									rhand:AddVelocity(-vel)
								end
							end
						end
					elseif IsValid(rag.leashowner) then
						local headpos = rag:GetPos()
						local physent = phys
						local bone = rag:LookupBone("ValveBiped.Bip01_Neck1")
						if bone then
							local matrix = rag:GetBoneMatrix(bone)
							if matrix then
								headpos = matrix:GetTranslation()
							end

							if rag:TranslateBoneToPhysBone(bone) then
								physent = rag:GetPhysicsObjectNum(rag:TranslateBoneToPhysBone(bone))
							end
						end

						local kidnapper = rag.leashowner
						local TargetPoint = (kidnapper:IsPlayer() and kidnapper:GetShootPos()) or kidnapper:GetPos()
						local MoveDir = (TargetPoint - headpos):GetNormal()
						local Dist = rag.ropelength

						local distFromTarget = headpos:Distance( TargetPoint )
						if distFromTarget <= Dist + 5 then return end

						local TargetPos = TargetPoint - (MoveDir * Dist)

						local vel = (TargetPos - headpos) * 1
						physent:AddVelocity(vel)
					end
				end
			end
		else
			ragdolls[ragdoll] = nil
		end
	end
end)

hook.Add("EntityTakeDamage", "Tazer", function(ent, dmginfo)
	if ent:IsPlayer() and IsValid(ent.tazeragdoll) and not ent.ragdolldamage then -- If we're hitting the player somehow we won't let, the ragdoll should take the damage.
		dmginfo:SetDamage(0)
		return
	end

	if STUNGUN.AllowDamage and IsValid(ent.tazeplayer) and IsValid(dmginfo:GetAttacker()) and (dmginfo:GetAttacker() != game.GetWorld()) then -- Worldspawn appears to be very eager to damage ragdolls. Don't!
		if STUNGUN.IsDarkRP and dmginfo:GetAttacker():IsPlayer() and IsValid(dmginfo:GetAttacker():GetActiveWeapon()) and dmginfo:GetAttacker():GetActiveWeapon().ClassName == "stunstick" then -- Negate stunstick damage
			return
		end

		local ply = ent.tazeplayer
		-- To prevent infiniteloop and other trickery, we need to know if it was ragdamage.
		ply.ragdolldamage = true
		ply:TakeDamageInfo(dmginfo) -- Apply all ragdoll damage directly to the player.
		ply.ragdolldamage = false

		if dmginfo:GetDamage() > 0 and STUNGUN.bLogs then
			local atkrname, atkr
			if dmginfo:GetAttacker():IsPlayer() then
				atkr = dmginfo:GetAttacker()
				atkrname = bLogs.GetName(atkr)
			else
				atkrname = dmginfo:GetAttacker():GetClass()
			end

			bLogs.Log({
				module = "Stungun",
				log = string.format("%s took %i damage from %s while being ragdolled.", bLogs.GetName(ply), dmginfo:GetDamage(), atkrname),
				involved = {ply, atkr}
			})
		end

		if dmginfo:GetDamage() > 0 and STUNGUN.pLogs then
			local data = {
				["Name"]	= ply:Name(),
				["SteamID"] = ply:SteamID(),
				["Damage"]  = dmginfo:GetDamage(),
			}

			local atkrname
			if dmginfo:GetAttacker():IsPlayer() then
				atkrname = dmginfo:GetAttacker():NameID()
				data["Attacker Name"]	= dmginfo:GetAttacker():Name()
				data["Attacker SteamID"] = dmginfo:GetAttacker():SteamID()
			else
				atkrname = dmginfo:GetAttacker():GetClass()
			end

			plogs.PlayerLog(ply, "Stungun", string.format("%s took %i damage from %s while being ragdolled.", ply:NameID(), dmginfo:GetDamage(), atkrname), data)
		end
	end
end)

function STUNGUN.CleanupParalyze(ply)
	if IsValid(ply.tazeragdoll) then
		if ply.tazeragdoll.tazesnd then
			ply.tazeragdoll.tazesnd:Stop()
			ply.tazeragdoll.tazesnd = nil
		end
		timer.Simple(0,function()
			SafeRemoveEntity(ply.tazeragdoll)
		end)

		timer.Remove("HurtingTimer" .. ply:UserID())
		timer.Remove("Unelectrolute" .. ply:UserID())
		timer.Remove("tazeUngag" .. ply:UserID())
		timer.Remove("StungunPlayerFreeze" .. ply:UserID())
		net.Start("tazeendview")
		net.Send(ply)

		ply:SetNWBool("tazefrozen", false)

		-- While he'll respawn and get this reset, his deadbody won't be visible so we need to reset it here.
		STUNGUN.PlayerInvis(ply, false)

		-- If he's respawning the immediate un-invisible won't have any effect. We need some delay.
		timer.Simple(.5,function()
			STUNGUN.PlayerInvis(ply, false)
		end)
	end

	ply.tazeismuted = false
end

-- If someone removes the ragdoll, untaze the player.
hook.Add("EntityRemoved", "Tazer", function(ent)
	if IsValid(ent.tazeplayer) and not ent.hasremoved then
		STUNGUN.UnRagdoll(ent.tazeplayer)
	end
end)

-- Some code directly respawns the player using :Spawn() without even killing him. We need to remove shit then.
hook.Add("PlayerSpawn", "Tazer", function(ply)
	STUNGUN.CleanupParalyze(ply)
end)
-- If he dies, clean up.
hook.Add("DoPlayerDeath", "Tazer", function(ply, inf, atk)
	STUNGUN.CleanupParalyze(ply)
end)

hook.Add("PlayerCanSeePlayersChat", "Tazer", function(text, teamOnly, listener, talker)
	if (not STUNGUN.IsTTT or GetRoundState() == ROUND_ACTIVE) and talker.tazeismuted then
		return false
	end
end)

hook.Add("PlayerCanHearPlayersVoice", "Tazer", function(listener, talker)
	if (not STUNGUN.IsTTT or GetRoundState() == ROUND_ACTIVE) and talker.tazeismuted then
		return false,false
	end
end)

hook.Add("CanPlayerSuicide", "Tazer", function(ply)
	if not STUNGUN.ParalyzeAllowSuicide and IsValid(ply.tazeragdoll) then return false end
	if not STUNGUN.MuteAllowSuicide and ply.tazeismuted then return false end
end)

hook.Add("PlayerCanPickupWeapon", "Tazer", function(ply, wep)
	if IsValid(ply.tazeragdoll) then return false end
end)

hook.Add("CuffsCanHandcuff", "Tazer", function(ply, target)
	if IsValid(target.tazeragdoll) then return false end
end)

gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "Tazer", function(data)
	local ply = Player(data.userid)
	if not IsValid(ply) then return end

	-- Taken from CleanupParalyze, slightly simplified though
	if IsValid(ply.tazeragdoll) then
		if ply.tazeragdoll.tazesnd then
			ply.tazeragdoll.tazesnd:Stop()
			ply.tazeragdoll.tazesnd = nil
		end

		SafeRemoveEntity(ply.tazeragdoll)

		timer.Remove("HurtingTimer" .. ply:UserID())
		timer.Remove("Unelectrolute" .. ply:UserID())
		timer.Remove("tazeUngag" .. ply:UserID())
	end
end)

local function DoFallDmg(ply, vel, veldir, umph)
	local dmg = math.floor(hook.Call("GetFallDamage", GAMEMODE, ply, vel))
	if dmg != 0 then
		local dmginfo = DamageInfo()
			dmginfo:SetDamageType(DMG_FALL)
			dmginfo:SetDamage(dmg)
			dmginfo:SetDamageForce(vel * veldir)
			dmginfo:SetDamagePosition(ply.tazeragdoll:GetPos())
			dmginfo:SetAttacker(game.GetWorld())
			dmginfo:SetInflictor(game.GetWorld())

		ply.ragdolldamage = true
		ply:TakeDamageInfo(dmginfo)
		ply.ragdolldamage = false
	end
end

hook.Add("Think", "TazerDoRagDmg", function()
	if not STUNGUN.Falldamage then return end

	for k,v in pairs(ents.FindByClass("prop_ragdoll")) do
		if IsValid(v.tazeplayer) then
			local phys = v:GetPhysicsObject()
			local vel = phys:GetVelocity():Length()

			if not v.lastfallvel then
				v.lastfallvel = vel
			end

			if vel >= v.lastfallvel then
				v.lastfallvel = vel
			else
				local deltavel = (v.lastfallvel - vel)
				local umph = deltavel * FrameTime() -- Retardation
				umph = umph * umph -- More realistic when squared
				if umph > 50 then
					DoFallDmg(v.tazeplayer, deltavel, phys:GetVelocity():GetNormal(), umph)
					v.lastfallvel = 0
				end
			end
		end
	end
end)

--[[
DarkRP specifics
]]
-- I'm not sure of the differences between these but one of them lets me put a nice message, while the other takes account in all cases. So I use both.
hook.Add("canChangeJob", "Tazer", function(ply, job)
	if IsValid(ply.tazeragdoll) then
		return false, "You can't change job while paralyzed!"
	end
end)
hook.Add("playerCanChangeTeam", "Tazer", function(ply)
	if IsValid(ply.tazeragdoll) then
		return false
	end
end)

--[[
TTT Specifics
]]
function SWEP:WasBought(buyer)
	if not self.InfiniteAmmo then
		buyer:GiveAmmo(math.max(0, self.Ammo - 1), "ammo_stungun")
	end
end

--[[
bLogs
]]
local function InitbLogs()
	bLogs.DefineLogger("Stungun","Extras")

	STUNGUN.bLogs = true
	MsgN("[STUNGUN] bLogs detected.")
end

if bLogsInit then
	InitbLogs()
else
	hook.Add("bLogsInit","stungun_waitforblogs",InitbLogs)
end
