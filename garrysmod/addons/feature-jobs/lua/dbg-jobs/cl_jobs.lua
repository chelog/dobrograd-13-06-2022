surface.CreateFont('dbg-jobs.title', {
	font = 'Calibri',
	extended = true,
	size = 27,
	weight = 350,
})

hook.Add('octogui.f4-tabs', 'dbg-jobs', function()

	octogui.addToF4({
		order = 12.3,
		id = 'jobs',
		name = 'Задания',
		icon = Material('octoteam/icons/case_brief.png'),
		build = function(f)
			f:SetSize(400, 600)
			f:DockPadding(0, 19, 0, 0)

			local jobs = f:Add 'dbg_jobs_main'
			jobs:Dock(FILL)
		end,
		show = function(f, st)
			netstream.Start('dbg-jobs.subscribe', st)
		end,
	})

end)
