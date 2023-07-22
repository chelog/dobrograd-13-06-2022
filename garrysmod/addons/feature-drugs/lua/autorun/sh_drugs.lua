Drugmod_Config = {
	["Overdose Threshold"] = 3, -- more than 3 active drugs will cause you to overdose and die, set to 0 for unlimited drug effects
}

Drugmod_Buffs = {

	["Weed"] = {
		ItemName = L.marijuana,
		Description = "Duuuuude",
		Col = Color(155, 255, 155),
		MaxDuration = 180,
		Initialize = function(ply) end,
		Terminate = function(ply) end,
		Iterate = function( ply, duration ) ply:SetHealth(math.Clamp(ply:Health() + 3, 0, ply:GetMaxHealth() ) ) end,
		ColorModify = {
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = 0,
			["$pp_colour_contrast"] = 1.5,
			["$pp_colour_colour"] = 1.5,
			["$pp_colour_mulr"] = 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0
		},
		Illegal = true,
--		SobelEffect = 20,
	},

	["HealthRecovery"] = {
		ItemName = L.healthrecovery,
		Description = "You feel healthy!",
		Col = Color(55, 255, 55),
		MaxDuration = 60,
		Initialize = function(ply) end,
		Terminate = function(ply) end,
		Iterate = function( ply, duration ) ply:SetHealth(math.Clamp(ply:Health() + 3, 0, ply:GetMaxHealth() ) ) end,
	},

	["DoubleJump"] = {
		ItemName = L.cocaine,
		Description = "You can jump again in midair",
		Col = Color(255, 255, 55),
		MaxDuration = 180,
		Initialize = function(ply) end,
		Terminate = function(ply) end,
		Iterate = function( ply, duration ) end,
	},

	["Volatile"] = {
		ItemName = L.volatile,
		Description = "Explode upon death",
		Col = Color(255, 85, 55),
		MaxDuration = 180,
		Initialize = function(ply) end,
		Terminate = function(ply) end,
		Iterate = function( ply, duration ) if ply:Health() < 2 then ply:Kill() else ply:SetHealth(math.Clamp(ply:Health() - 2, 0, ply:GetMaxHealth() ) ) end end,
		Illegal = true,
	},

	["Dextradose"] = {
		ItemName = L.dextradose,
		Description = "40% faster lockpicking",
		Col = Color(155, 55, 155),
		MaxDuration = 180,
		Initialize = function(ply) end,
		Terminate = function(ply) end,
		Iterate = function( ply, duration ) end,
		Illegal = true,
	},

	["Steroids"] = {
		ItemName = L.roids,
		Description = "20% faster run speed",
		Col = Color(255, 125, 125),
		MaxDuration = 180,
		Initialize = function(ply) end,
		InitializeOnce = function(ply) ply:MoveModifier('drug2', { runmul = 1.2 }) end,
		Terminate = function(ply) ply:MoveModifier('drug2', nil) end,
		Iterate = function( ply, duration ) end,
		Illegal = true,
	},

	["Vampire"] = {
		ItemName = L.vampire,
		Description = "Leech enemies life force",
		Col = Color(195, 55, 55),
		MaxDuration = 180,
		Initialize = function(ply) end,
		Terminate = function(ply) end,
		Iterate = function( ply, duration ) end,
		Illegal = true,
	},

	["Painkillers"] = {
		ItemName = L.painkiller,
		Description = "20% damage resist",
		Col = Color(205, 205, 255),
		MaxDuration = 180,
		Initialize = function(ply) end,
		Terminate = function(ply) end,
		Iterate = function( ply, duration ) end,
	},

	["Drunk"] = {
		ItemName = L.drunk,
		Description = "You are having a gooood time",
		Col = Color(55, 55, 255),
		MaxDuration = 180,
		Initialize = function(ply) ply:SetNetVar('Drunk', true) end,
		Terminate = function(ply) ply:SetNetVar('Drunk') end,
		Iterate = function( ply, duration ) end,
	},

	["Gunslinger"] = {
		ItemName = L.gunslinger,
		Description = "25% increased gun damage",
		Col = Color(255, 155, 55),
		MaxDuration = 180,
		Initialize = function(ply) end,
		Terminate = function(ply) end,
		Iterate = function( ply, duration ) end,
		Illegal = true,
	},

	["Muscle Relaxant"] = {
		ItemName = L.relaxant,
		Description = "Greatly reduced impact damage",
		Col = Color(255, 155, 255),
		MaxDuration = 180,
		Initialize = function(ply) end,
		Terminate = function(ply) end,
		Iterate = function( ply, duration ) end,
	},

	["Meth"] = {
		ItemName = L.steroids,
		Description = "Fists of fury!",
		Col = Color(5, 185, 245),
		MaxDuration = 180,
		Initialize = function(ply) end,
		Terminate = function(ply) end,
		Iterate = function( ply, duration ) end,
		ColorModify = {
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0.1,
			["$pp_colour_brightness"] = 0,
			["$pp_colour_contrast"] = 1.3,
			["$pp_colour_colour"] = 1,
			["$pp_colour_mulr"] = 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0
		},
		MotionBlur = { 0.3, 0.8, 0.01 },
		Illegal = true,
	},

	["Pingaz"] = {
		ItemName = L.pingaz,
		Description = "Get your bounce on",
		Col = Color(255, 225, 5),
		MaxDuration = 180,
		Initialize = function(ply)
			local playerClass = baseclass.Get(player_manager.GetPlayerClass(ply))
			ply:SetJumpPower(playerClass.JumpPower * 1.5)
		end,
		Terminate = function(ply)
		 	local playerClass = baseclass.Get(player_manager.GetPlayerClass(ply))
			ply:SetJumpPower(playerClass.JumpPower)
		end,
		Iterate = function( ply, duration ) end,
		ColorModify = {
			["$pp_colour_addr"] = 0.1,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0.1,
			["$pp_colour_brightness"] = 0,
			["$pp_colour_contrast"] = 1.5,
			["$pp_colour_colour"] = 2,
			["$pp_colour_mulr"] = 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0
		},
		Sharpen = { 1.2, 1.2 },
		Illegal = true,
	},

	["Preserver"] = {
		ItemName = L.preserver,
		Description = "Save yourself from lethal damage",
		Col = Color(150, 255, 195),
		MaxDuration = 180,
		Initialize = function(ply) end,
		Terminate = function(ply) end,
		Iterate = function( ply, duration ) end,
	},

	["Overdose"] = {
		ItemName = L.overdose,
		Description = "Now you fucked up!",
		Col = Color(255, 0, 0),
		MaxDuration = 180,
		Initialize = function(ply) ply:EmitSound("vo/npc/male01/moan0"..math.random(1,5)..".wav") end,
		Terminate = function(ply) end,
		Iterate = function( ply, duration )
			local d = DamageInfo()
			d:SetDamage( 5 )
			d:SetDamageType( DMG_PARALYZE )
			d:SetAttacker( game.GetWorld() )
			d:SetInflictor( game.GetWorld() )
			ply:TakeDamageInfo( d )
		if math.random(1,10) > 8 then ply:EmitSound("vo/npc/male01/moan0"..math.random(1,5)..".wav") end
		end,
		ColorModify = {
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = 0,
			["$pp_colour_contrast"] = 1,
			["$pp_colour_colour"] = 0.2,
			["$pp_colour_mulr"] = 5,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0
		},
		MotionBlur = { 0.4, 0.8, 0.01 },
	},

	["Nicotine"] = {
		ItemName = L.nicotine,
		Description = "You feel relaxed",
		Col = Color(80, 80, 80),
		MaxDuration = 180,
		Initialize = function(ply) end,
		Terminate = function(ply) end,
		Iterate = function( ply, duration ) end,
		ColorModify = {
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = 0,
			["$pp_colour_contrast"] = 0.95,
			["$pp_colour_colour"] = 0.95,
			["$pp_colour_mulr"] = 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0
		},
		Sharpen = { 1.1, 1.1 },
	},


}

local function DMOD_DoPlayerDeath( ply, attacker, dmg )
	if ply:HasBuff( "Volatile" ) then
	local pos = ply:GetPos()
	timer.Simple( 0.3, function()
	util.BlastDamage( ply, ply, pos, 350, 125 )

	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
	util.Effect("Explosion", effectdata)
	ply:ClearBuffs()
	end)
	end
end
hook.Add("DoPlayerDeath", "DMOD_DoPlayerDeath", DMOD_DoPlayerDeath)
