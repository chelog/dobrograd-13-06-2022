file.CreateDir('octoinv/configs')
octoinv.mapConfig = util.JSONToTable(file.Read('octoinv/configs/' .. game.GetMap() .. '.json') or '{}') or {}
octoinv.mapConfig.collect = octoinv.mapConfig.collect or {}

function octoinv.saveMapConfig(data)
	if data then octoinv.mapConfig = data end
	file.Write('octoinv/configs/' .. game.GetMap() .. '.json', util.TableToJSON(octoinv.mapConfig))
end
