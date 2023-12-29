if CFG.disabledModules.use then return end

netstream.Hook('octolib.use', function(ent, data)
	local opts = { }
	if data then
		for useID, useData in pairs(data) do
			table.insert(opts, { useData[1] or L.action, useData[2], function()
				if useData[3] then
					local m = DermaMenu()
					if #useData[3] > 0 then
						for i, opt in ipairs(useData[3]) do
							m:AddOption(opt[1], function()
								netstream.Start('octolib.use', ent, useID, {unpack(opt, 2)})
							end)
						end

					else
						m:AddOption(L.empty)
					end
					m:Open()
					m:Center()
				else
					netstream.Start('octolib.use', ent, useID)
				end
			end })
		end
	end

	if #opts < 1 then
		table.insert(opts, { 'Нет действий', 'octoteam/icons/emote_question.png', function() end })
	end

	octogui.circularMenu(opts)
end)

octolib.use.classes = octolib.use.classes or {}
netstream.Hook('octolib.use.classes', function(classes)

	for i, class in ipairs(classes) do
		octolib.use.classes[class] = true
	end

end)

octolib.include.prefixed('/config/octolib-use', {
	'hooks',
	'*',
})
