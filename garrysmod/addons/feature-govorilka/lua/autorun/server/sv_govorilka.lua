hook.Add('PlayerInitialSpawn', 'govorilka.initialSpawn', function(ply)
	timer.Simple(3, function()
		if not IsValid(ply) then return end
		ply:SetVoice(ply:GetInfo('cl_govorilka_voice'))
		ply:SetNetVar('govorilka_mute', ply:GetDBVar('govorilka_mute'))
	end)
end)

-- hook.Add('octolib.db.init', 'govorilka.init', function()
-- 	octolib.db:RunQuery([[
-- 		CREATE TABLE IF NOT EXISTS `govorilka_stats` (
-- 			`id` INT NOT NULL AUTO_INCREMENT,
-- 			`performDate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
-- 			`val` INT NOT NULL DEFAULT 0,
-- 			`premium` TINYINT(1) DEFAULT 0,
-- 				PRIMARY KEY (`id`)
-- 		);
-- 	]])
-- end)

local plyMeta = FindMetaTable 'Player'

function plyMeta:SetVoice(voice)
	if isstring(voice) then
		self:SetNetVar('govorilka_voice', voice)
	end
end

netstream.Hook('govorilka.changeVoice', plyMeta.SetVoice)

local entMeta = FindMetaTable 'Entity'
function entMeta:DoVoice(text, voice, recipients)

	netstream.Start(recipients, 'govorilka.play', self, text, voice)

	-- local mul = recipients and isentity(recipients) and 1 or istable(recipients) and #recipients or player.GetAll()
	-- local premium = self:IsPlayer() and self:GetNetVar('os_dobro') and 1 or 0
	-- octolib.db:PrepareQuery([[INSERT INTO govorilka_stats (val, premium) VALUES (?, ?)]], {utf8.len(text) * mul, premium})

end
