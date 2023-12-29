octolib.time = octolib.time or {}

local rulesTime = {
	{1, 'секунда', 'секунды', 'секунд'},
	{60, 'минута', 'минуты', 'минут'},
	{60 * 60, 'час', 'часа', 'часов'},
	{60 * 60 * 24, 'день', 'дня', 'дней'},
	{60 * 60 * 24 * 7, 'неделя', 'недели', 'недель'},
	{60 * 60 * 24 * 30, 'месяц', 'месяца', 'месяцев'},
	{60 * 60 * 24 * 365, 'год', 'года', 'лет'},
} octolib.rulesTime = rulesTime

function octolib.time.formatDuration(sec, rulesOverride)
	return octolib.string.formatCountExt(sec, rulesOverride or rulesTime)
end

local rulesTimeIn = table.Copy(rulesTime)
rulesTimeIn[1][2] = 'секунду'
rulesTimeIn[2][2] = 'минуту'
rulesTimeIn[5][2] = 'неделю'

function octolib.time.formatIn(sec, short)
	if short then
		return octolib.string.formatCountExt(sec, rulesTimeIn)
	else
		return 'через ' .. octolib.string.formatCountExt(sec, rulesTimeIn)
	end
end

local multipliers = {}

multipliers.seconds = 1
multipliers.second = multipliers.seconds
multipliers.sec = multipliers.seconds
multipliers.s = multipliers.seconds

multipliers.minutes = multipliers.seconds * 60
multipliers.minute = multipliers.minutes
multipliers.min = multipliers.minutes
multipliers.m = multipliers.minutes

multipliers.hours = multipliers.minutes * 60
multipliers.hour = multipliers.hours
multipliers.hr = multipliers.hours
multipliers.h = multipliers.hours

multipliers.days = multipliers.hours * 24
multipliers.day = multipliers.days
multipliers.d = multipliers.days

multipliers.weeks = multipliers.days * 7
multipliers.week = multipliers.weeks
multipliers.w = multipliers.weeks

multipliers.months = multipliers.days * 30
multipliers.month = multipliers.months
multipliers.mo = multipliers.months

multipliers.years = multipliers.days * 365
multipliers.year = multipliers.years
multipliers.yr = multipliers.years
multipliers.y = multipliers.years

function octolib.time.toSeconds(...)
	local total = 0

	local args = {...}
	for i = 1, #args, 2 do
		total = total + args[i] * multipliers[args[i + 1]]
	end

	return total
end
