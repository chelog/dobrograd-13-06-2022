dbgJobs = dbgJobs or {}

octolib.shared('dbg-jobs/sh_hooks')

octolib.server('dbg-jobs/sv_jobs')
octolib.server('dbg-jobs/sv_network')

octolib.client('dbg-jobs/vgui_main')
octolib.client('dbg-jobs/vgui_job_button')
octolib.client('dbg-jobs/vgui_job_overlay')
octolib.client('dbg-jobs/cl_jobs')
octolib.client('dbg-jobs/cl_editor')
