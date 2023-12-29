local notifyMap = {
	[NOTIFY_GENERIC] = 'rp',
	[NOTIFY_ERROR] = 'warning',
	[NOTIFY_CLEANUP] = 'ooc',
	[NOTIFY_HINT] = 'hint',
	[NOTIFY_UNDO] = 'hint',
}

function GM:AddNotify(str, type)

	octolib.notify.show(notifyMap[type], str)

end

GM.PaintNotes = octolib.func.zero
