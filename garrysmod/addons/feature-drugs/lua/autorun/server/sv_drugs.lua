util.AddNetworkString("UpdateBuffs")
util.AddNetworkString("SendBuffs")


--Drugmod_Buffs = {}

-- this is c+p from my populi gamemode, please for the love of god do not run this addon on a populi server or you'll screw everything up
local plymeta = FindMetaTable("Player")

function plymeta:AddBuff( buff, duration )

	if !self:IsValid() or !self:Alive() then return end
	if !Drugmod_Buffs[buff] then ErrorNoHalt( "Drugmod Error: attempting to give "..self:Nick().." an invalid drug effect: "..buff.."\n" ) return end

	if self.Buffs[buff] then
		self.Buffs[buff] = math.Clamp(self.Buffs[buff] + duration, CurTime(), CurTime() + Drugmod_Buffs[buff].MaxDuration )
	else
		self.Buffs[buff] = math.Clamp(CurTime() + duration, CurTime(), CurTime() + Drugmod_Buffs[buff].MaxDuration )
		if Drugmod_Buffs[buff].InitializeOnce then
			local s, e = pcall( Drugmod_Buffs[buff].InitializeOnce, self )
			if !s then print("Drugmod InitializeOnce error in buff: "..k.." on player "..ply:Nick().." : "..e) end
		end
	end

	self.OldBuffs = self.OldBuffs or {}
	self.OldBuffs[buff] = self.Buffs[buff] + 20 * 60

	local s, e = pcall( Drugmod_Buffs[buff].Initialize, self )
	if !s then print("Drugmod Initialize error in buff: "..k.." on player "..ply:Nick().." : "..e) end

	self:CheckOverdose()

	net.Start("UpdateBuffs")
	net.WriteTable(self.Buffs)
	net.Send(self)

end

function plymeta:RemoveBuff( buff )

	if !self:IsValid() or !self:Alive() then return end
	if !Drugmod_Buffs[buff] then ErrorNoHalt( "Drugmod Error: attempting to remove invalid buff from "..self:Nick().."\n" ) return end

	if self.Buffs[buff] then self.Buffs[buff] = nil end

	net.Start("UpdateBuffs")
	net.WriteTable(self.Buffs)
	net.Send(self)

end

function plymeta:ClearBuffs()

	if self.Buffs then
		for k,v in pairs(self.Buffs) do
			local s, e = pcall(Drugmod_Buffs[k].Terminate, self) -- run the end of buff function
			if not s then print("Drugmod terminate error in buff: "..k.." on player "..self:Nick().." : "..e) end
		end
	end
	self.Buffs = {}
	self.OldBuffs = {}
	net.Start("UpdateBuffs")
	net.WriteTable(self.Buffs)
	net.Send(self)

end

function plymeta:HasBuff( name )
	if self.Buffs[name] then return true else return false end
end

function plymeta:CountBuffs()
	return table.Count(self.Buffs)
end

function plymeta:CheckOverdose()
	if Drugmod_Config["Overdose Threshold"] < 1 then return end
	if self:CountBuffs() > Drugmod_Config["Overdose Threshold"] then
		self:ClearBuffs()
		self:AddBuff( "Overdose", 30 )
	end
end

hook.Add("PlayerDeath", "NoFunAllowedAfterYouDie", function( ply ) ply:ClearBuffs() end)
hook.Add("PlayerSpawn", "CopyPastedHook1", function( ply ) ply:ClearBuffs() end)
hook.Add("PlayerInitialSpawn", "CopyPastedHook2", function( ply ) ply:ClearBuffs() end)

local function BuffsLogic()

	octolib.func.throttle(player.GetAll(), 10, 0.1, function(ply)
		if not IsValid(ply) then return end
		if not ply.Buffs then
			ply.Buffs = {}
			doUpdate = true
		end

		local doUpdate = false
		for k, v in pairs(ply.Buffs) do
			if isfunction(Drugmod_Buffs[k].Iterate) then
				local s, e = pcall( Drugmod_Buffs[k].Iterate, ply, v - CurTime() )
				if not s then print("Drugmod iterate error in buff: "..k.." on player "..ply:Nick().." : "..e) end
			end

			if v <= CurTime() then
				ply.Buffs[k] = nil  -- delete the buff from their active buffs table
				doUpdate = true
				local s, e = pcall( Drugmod_Buffs[k].Terminate, ply ) -- run the end of buff function
				if not s then print("Drugmod terminate error in buff: "..k.." on player "..ply:Nick().." : "..e) end
			end
		end

		if ply.OldBuffs then
			for k, v in pairs(ply.OldBuffs) do
				if v <= CurTime() then
					ply.OldBuffs[k] = nil
				end
			end
		end

		if doUpdate then
			net.Start("UpdateBuffs")
			net.WriteTable(ply.Buffs)
			net.Send(ply)
		end
	end)

end
timer.Create("drugmod_bufflogic", 3, 0, BuffsLogic)

hook.Add("SetupMove", "DoubleJumpHook", function(ply, cmd)

	if !ply:HasBuff( "DoubleJump" ) then return end

	if ply:OnGround() then ply:SetNetVar("jumplevel", 0) return end
	if !cmd:KeyPressed(IN_JUMP) then return end

	ply:SetNetVar("jumplevel", ply:GetNetVar("jumplevel", 0) + 1 )

	if ply:GetNetVar("jumplevel", 0) > 1 then return end

	local vel = ply:GetVelocity()

	vel.z = ply:GetJumpPower()

	cmd:SetVelocity(vel)

	ply:DoCustomAnimEvent(PLAYERANIMEVENT_JUMP, -1)

end)

local function DMOD_TakeDamage( ent, dmg )
	if ent:IsPlayer() then
		local atk = dmg:GetAttacker()
		local amt = dmg:GetDamage()
		local hp = ent:Health()

		if atk:IsValid() and atk:IsPlayer() and atk:Alive() then

			if atk:HasBuff( "Gunslinger" ) and dmg:IsBulletDamage() then
				dmg:ScaleDamage( 1.25 )
			end

			if atk:HasBuff( "Meth" ) and atk:GetActiveWeapon():GetClass() == "weapon_fists" then
				dmg:ScaleDamage( 2.5 )
			end

			if atk:HasBuff( "Vampire" ) then
				atk:SetHealth(math.Clamp(atk:Health() + amt / 4, 0, atk:GetMaxHealth() ) )
			end

			if ent:HasBuff( "Painkillers" ) and !dmg:IsFallDamage() and dmg:GetDamageType() != DMG_DROWN then
				dmg:ScaleDamage( 0.8 )
			end

			if ent:HasBuff( "Drunk" ) and !dmg:IsFallDamage() and dmg:GetDamageType() != DMG_DROWN then
				dmg:ScaleDamage( 0.9 )
			end

		end

		if dmg:IsFallDamage() and ent:HasBuff( "Muscle Relaxant" ) then
			dmg:ScaleDamage( 0.5 )
		end

		if ent:HasBuff( "Preserver" ) and hp - amt < 1 then
			ent:EmitSound( "items/gift_drop.wav", 80, 100 )
			dmg:ScaleDamage( 0 )
			dmg:SetDamage( 0 )
			ent:SetHealth( 25 )
			ent:RemoveBuff( "Preserver" )

			for i = 1, 6 do
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector( math.random( -10, 10), math.random( -10, 10), math.random( 0, 60) ) )
				util.Effect( "cball_bounce", effectdata )
			end

		end

	end
end
hook.Add("EntityTakeDamage", "DMOD_TakeDamage", DMOD_TakeDamage)

hook.Add( "OnPlayerChangedTeam", "DM_fixjobchange", function(ply) ply:ClearBuffs() end)

hook.Add('PlayerSay', 'zzzdrug-booze', function(ply, text, t)

	if ply:HasBuff('Drunk') then
		if ply:GetInfo('cl_dbg_alcohol_effect') ~= '1' then return end
		if ply.sayOverride or text:sub(1,1):find('[%!%~%/]') then return end
		local r = ''
		for c in string.gmatch(text, utf8.charpattern) do
			if math.random(5) == 1 and not c:find('%p') then
				for i = 1, math.random(2,4) do
					r = r .. (math.random(3) == 1 and utf8.upper(c) or utf8.lower(c))
				end
			else
				r = r .. c
			end
		end
		return r:gsub('%s+', ' ')
	end

end)
