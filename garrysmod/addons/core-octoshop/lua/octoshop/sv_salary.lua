timer.Create('octoshop.salary', 60, 0, function()

	octolib.func.throttle(player.GetAll(), 10, 0.2, function(ply)
		if not IsValid(ply) or ply:IsAFK() then return end

		ply.os_salaryPoints = (ply.os_salaryPoints or 0) + 1
		if ply.os_salaryPoints < octoshop.salaryPeriod then return end

		local amount = octoshop.salaryAmount[ply:GetUserGroup()]
		if not amount then return end

		ply:osAddMoney(amount)
		octoshop.notify(ply, 'ooc', L.you_got .. octoshop.formatMoney(amount) .. L.for_work_admin)

		ply.os_salaryPoints = 0
	end)

end)
