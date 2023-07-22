include 'shared.lua'

function SWEP:Precache()

	util.PrecacheSound('npc/zombie/zombie_voice_idle1.wav')
	util.PrecacheSound('npc/zombie/zombie_voice_idle2.wav')
	util.PrecacheSound('npc/zombie/zombie_voice_idle3.wav')
	util.PrecacheSound('npc/zombie/zombie_voice_idle4.wav')
	util.PrecacheSound('npc/zombie/zombie_voice_idle5.wav')
	util.PrecacheSound('npc/zombie/zombie_voice_idle6.wav')
	util.PrecacheSound('npc/zombie/zombie_voice_idle7.wav')
	util.PrecacheSound('npc/zombie/zombie_voice_idle8.wav')
	util.PrecacheSound('npc/zombie/zombie_voice_idle9.wav')
	util.PrecacheSound('npc/zombie/zombie_voice_idle10.wav')
	util.PrecacheSound('npc/zombie/zombie_voice_idle11.wav')
	util.PrecacheSound('npc/zombie/zombie_voice_idle12.wav')
	util.PrecacheSound('npc/zombie/zombie_voice_idle13.wav')
	util.PrecacheSound('npc/zombie/zombie_voice_idle14.wav')
	util.PrecacheSound('npc/zombie/claw_strike1.wav')
	util.PrecacheSound('npc/zombie/claw_strike2.wav')
	util.PrecacheSound('npc/zombie/claw_strike3.wav')
	util.PrecacheSound('npc/zombie/claw_miss1.wav')
	util.PrecacheSound('npc/zombie/claw_miss2.wav')

end

function SWEP:Initialize()

	self:Precache()

	hook.Add('RenderScreenspaceEffects', 'dbg-zombie', function()

		if not LocalPlayer():GetNetVar('zombie') then return end
		DrawColorModify({
			['$pp_colour_addr'] = 0,
			['$pp_colour_addg'] = 0.3,
			['$pp_colour_addb'] = 0,
			['$pp_colour_mulr'] = 0,
			['$pp_colour_mulg'] = 0,
			['$pp_colour_mulb'] = 0,
			['$pp_colour_brightness'] = -0.1,
			['$pp_colour_contrast'] = 0.8,
			['$pp_colour_colour'] = 0.2,
		})

	end)

end
