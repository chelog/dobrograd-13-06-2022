
--[[
Stungun SWEP Created by Donkie (http://steamcommunity.com/id/Donkie/)
For personal/server usage only, do not resell or distribute!
]]

--[[
GENERAL INFORMATION

Weaponclass: "stungun"
Ammotype: "ammo_stungun"
The stungun is only being tested on Sandbox, DarkRP (latest & 2.4.3) and TTT (latest) before releases.
]]

--[[
CONFIG FILE
ONLY EDIT STUFF IN HERE
ANY EDITS OUTSIDE THIS FILE IS NOT MY RESPONSIBILITY
]]

--[[****************
BASIC SECTION
*****************]]

-- Ragdoll physics effect, replaces old "ShouldRoll"
-- Set to either 0, 1 or 2
-- 0: No effect
-- 1: Original comical rolling around
-- 2: NEW: Ragdoll shaking
STUNGUN.PhysEffect = 1

-- Can you un-taze people with rightclick?
STUNGUN.CanUntaze = true

-- Should it display in thirdperson view for the tazed player? (if false, firstperson)
STUNGUN.Thirdperson = true

-- If above is true, should users be able to press crouch button (default ctrl) to switch between third and firstperson?
STUNGUN.AllowSwitchFromToThirdperson = false

-- Should people be able to pick a tazed player using physgun?
STUNGUN.AllowPhysgun = false

-- Should people be able to use toolgun on tazed players?
STUNGUN.AllowToolgun = false

-- Should tazed players take falldamage? (Warning: experimental, not recommended to have if players can pick them up using physgun.)
STUNGUN.Falldamage = false

-- How much damage the tazer also does
-- Set to 0 to disable
STUNGUN.StunDamage = 0

-- Should it display name and HP on tazed players?
STUNGUN.ShowPlayerInfo = false

-- Can the player be damaged while he's tazed?
STUNGUN.AllowDamage = true

-- Can the player suicide while he's paralyzed?
STUNGUN.ParalyzeAllowSuicide = false

-- Can the player suicide while he's mute?
STUNGUN.MuteAllowSuicide = false

-- Amount of seconds the player is immune to stuns after he just got up from being paralyzed. -1 to disable.
STUNGUN.Immunity = -1

-- Can people of same team stungun each other? Check further below (in the advanced section) for the check-function.
-- The check function is by default set to ignore police trying to taze police.
STUNGUN.AllowFriendlyFire = true

-- If the ragdoll version of the playermodel does not spawn correctly (incorrectly made model) then the ragdoll will be this model.
-- When done rolling around the player will get back his default model.
-- Set this to "nil" (without quotes) if you want to disable this default model and just make it not work.
STUNGUN.DefaultModel = Model("models/player/group01/male_01.mdl")

-- Thirdperson holdtype. Put "revolver" to make him carry the gun in 2 hands, put "pistol" to make him one-hand the gun.
SWEP.HoldType = "revolver"

-- Default charge for the weapon, when the guy picks the gun up, should it be filled already or wait to be filled? 100 is max charge, 0 is uncharged.
SWEP.Charge = 100

-- Should we have infinite ammo (true) or finite ammo (false)?
-- Finite ammo makes it spawn with 1 charge, unless you're running TTT in which you can specify how much ammo it should start with down below.
SWEP.InfiniteAmmo = true

-- Recharge rate. How many seconds it takes to fill the gun back up.
SWEP.RechargeTime = 10
SWEP.ReadyDelay = 0.25

-- How long range the weapon has. Players beyond this range won't get hit.
-- To put in perspective, in darkrp, the above-head-playerinfo has a default range of 400.
SWEP.Range = 200

--[[
There's two seperate times for this. This is so the player has a chance to escape but the robbers still have a chance to re-taze him.
Put the paralyzetime and mutetime at same to make the player able to talk exactly when he's able to get up.
Put the mutetime slightly higher than paralyze time to make him wait a few seconds before he's able to talk after he got up.
]]

-- How many seconds the player is rolling around as a ragdoll.
STUNGUN.ParalyzedTime = 10

-- How many seconds the player is mute/gagged = Unable to speak/chat.
STUNGUN.MuteTime = 12

-- NEW: How many seconds after the player has been unragdolled that he still won't be able to move.
STUNGUN.FreezeTime = 3

-- What teams are immune to the stungun? (if any).
local immuneteams = {
	-- TEAM_MAYOR,
	-- TEAM_CHIEF,
	-- TEAM_POLICE2,
	-- TEAM_MEDCOP,
	-- TEAM_POLICE,
}

--[[****************
ADVANCED SECTION
Contact me if you need help with any function.
*****************]]
-- If you've found that specific models appear to break it, add them here and they will turn into the default model instead.
STUNGUN.BrokenModels = {
	["models/test/model.mdl"] = true
}

--[[
Hurt sounds
]]
local combinemodels = {["models/player/police.mdl"] = true, ["models/player/police_fem.mdl"] = true}
local females = {
	["models/player/alyx.mdl"] = true,["models/player/p2_chell.mdl"] = true,
	["models/player/mossman.mdl"] = true,["models/player/mossman_arctic.mdl"] = true}
function STUNGUN.PlayHurtSound( ply )
	local mdl = ply:GetModel()

	-- Combine
	if combinemodels[mdl] or string.find(mdl, "combine") then
		return "npc/combine_soldier/pain" .. math.random(1,3) .. ".wav"
	end

	-- Female
	if females[mdl] or string.find(mdl, "female") then
		return "vo/npc/female01/pain0" .. math.random(1,9) .. ".wav"
	end

	-- Male
	return "vo/npc/male01/pain0" .. math.random(1,9) .. ".wav"
end

--[[
Custom same-team function.
]]
function STUNGUN.SameTeam(ply1, ply2)
	if STUNGUN.IsDarkRP and ply1:isCP() and ply2:isCP() then
		return true
	end

	-- return (ply1:Team() == ply2:Team()) -- Probably dont want this in DarkRP, nor TTT, but maybe your custom TDM gamemode.
end

--[[
Custom Immunity function.
]]
function STUNGUN.IsPlayerImmune(ply)
	local job = ply:getJobTable()
	if job and job.police or ply:IsGhost() then return true end
	return false
end


--[[****************
DarkRP Specific stuff
Only care about these if you're running it on a DarkRP server.
*****************]]

-- Should the stungun charges be buyable in the f4 store?
-- If yes, put in a number above 0 as price, if no, put -1 to disable.
STUNGUN.AddAmmoItem = -1

-- Should it be allowed to use the arrest baton on stunned people?
STUNGUN.AllowArrestOnRag = true

-- Should it be allowed to use the unarrest baton on stunned people?
STUNGUN.AllowUnArrestOnRag = true

--[[****************
TTT Specific stuff
Only care about these if you're running it on a TTT server.
*****************]]

-- Can stunned players be picked up by magnetostick?
STUNGUN.CanPickup = false

-- Default ammo.
SWEP.Ammo = 3

-- Kind specifies the category this weapon is in. Players can only carry one of
-- each. Can be: WEAPON_... MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE.
-- Matching SWEP.Slot values: 0	  1	   2	 3	  4	  6	   7		8
SWEP.Kind = WEAPON_EQUIP1

-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2, then this gun can
-- be spawned as a random weapon.
SWEP.AutoSpawnable = false

-- CanBuy is a table of ROLE_* entries like ROLE_TRAITOR and ROLE_DETECTIVE. If
-- a role is in this table, those players can buy this.
SWEP.CanBuy = { ROLE_DETECTIVE }

-- InLoadoutFor is a table of ROLE_* entries that specifies which roles should
-- receive this weapon as soon as the round starts. In this case, none.
SWEP.InLoadoutFor = nil

-- If LimitedStock is true, you can only buy one per round.
SWEP.LimitedStock = false

-- If AllowDrop is false, players can't manually drop the gun with Q
SWEP.AllowDrop = true
