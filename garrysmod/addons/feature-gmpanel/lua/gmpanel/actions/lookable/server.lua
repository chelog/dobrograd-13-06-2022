gmpanel.registerAction('lookable', function(obj)
	netstream.Start(gmpanel.buildTargets(obj.players or {}), 'tools.lookable', obj.data)
end)
