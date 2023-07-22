
-- Copyright (C) 2018-2020 DBotThePony

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do so,
-- subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all copies
-- or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
-- DEALINGS IN THE SOFTWARE.


gui.misc.apply = 'Применить'
gui.misc.cancel = 'Отмена'
gui.misc.yes = 'Да'
gui.misc.no = 'Нет'

gui.entry.invalidsymbol = 'Символ не разрешен.'
gui.entry.limit = 'Превышена максимальная длинна значения.'

gui.dlib.hudcommons.reset = 'Сбросить'

info.dlib.tformat.seconds = 'секунд'
info.dlib.tformat.minutes = 'минут'
info.dlib.tformat.hours = 'часов'
info.dlib.tformat.days = 'дней'
info.dlib.tformat.weeks = 'недель'
info.dlib.tformat.months = 'месяцев'
info.dlib.tformat.years = 'лет'
info.dlib.tformat.centuries = 'веков'

info.dlib.tformat.long = 'Никогда™'
info.dlib.tformat.now = 'Прямо сейчас'
info.dlib.tformat.past = 'В прошлом'

local function define(from, to, target, form1, form2, form3)
	for i = from, to do
		local div = i % 10

		if i == 0 or i > 9 and i < 19 or div > 4 or div == 0 then
			target[tostring(i)] = i .. ' ' .. form1
		elseif div == 1 then
			target[tostring(i)] = i .. ' ' .. form2
		elseif div == 2 or div == 3 or div == 4 then
			target[tostring(i)] = i .. ' ' .. form3
		end
	end
end

define(1, 60, info.dlib.tformat.countable.second, 'секунд', 'секунда', 'секунды')
define(1, 60, info.dlib.tformat.countable.minute, 'минут', 'минута', 'минуты')
define(1, 24, info.dlib.tformat.countable.hour, 'часов', 'час', 'часа')
define(1, 7, info.dlib.tformat.countable.day, 'день', 'дня', 'дней')
define(1, 4, info.dlib.tformat.countable.week, 'неделя', 'недели', 'недель')
define(1, 12, info.dlib.tformat.countable.month, 'месяц', 'месяца', 'месяцев')
define(1, 100, info.dlib.tformat.countable.year, 'год', 'года', 'лет')
define(1, 100, info.dlib.tformat.countable.century, 'век', 'века', 'веков')

define(1, 60, info.dlib.tformat.countable_ago.second, 'секунд', 'секунду', 'секунды')
define(1, 60, info.dlib.tformat.countable_ago.minute, 'минут', 'минуту', 'минуты')
define(1, 24, info.dlib.tformat.countable_ago.hour, 'часов', 'час', 'часа')
define(1, 7, info.dlib.tformat.countable_ago.day, 'дней', 'день', 'дня')
define(1, 4, info.dlib.tformat.countable_ago.week, 'недель', 'неделю', 'недели')
define(1, 12, info.dlib.tformat.countable_ago.month, 'месяцев', 'месяц', 'месяца')
define(1, 100, info.dlib.tformat.countable_ago.year, 'лет', 'год', 'года')
define(1, 100, info.dlib.tformat.countable_ago.century, 'веков', 'век', 'века')

info.dlib.tformat.ago = '%s тому назад'
info.dlib.tformat.ago_inv = 'Через %s'

gui.dlib.friends.title = 'DLib друзья'
gui.dlib.friends.open = 'Отрыть меню друзей'

gui.dlib.friends.edit.add_title = 'Добавление %s <%s> как друга'
gui.dlib.friends.edit.edit_title = 'Редактирование настроек друга %s <%s>'
gui.dlib.friends.edit.going = 'Вы будете другом с %s в...'
gui.dlib.friends.edit.youare = 'Вы являетесь другом с %s в...'
gui.dlib.friends.edit.remove = 'Удалить друга'

gui.dlib.friends.invalid.title = 'Неверный SteamID'
gui.dlib.friends.invalid.ok = 'Окай :('
gui.dlib.friends.invalid.desc = '%q не выглядит как SteamID!'

gui.dlib.friends.settings.steam = 'Считать Steam друзей как DLib друзей'
gui.dlib.friends.settings.your = 'Ваши друзья ->'
gui.dlib.friends.settings.server = 'Игроки на сервере ->'

gui.dlib.friends.settings.foreign = '[Внешний] '

gui.dlib.donate.top = 'DLib: Сделаете пожертвование?'
gui.dlib.donate.button.yes = 'Так и сделать (Яндекс.Деньги)!'
gui.dlib.donate.button.paypal = 'Так и сделать, только на PayPal!'
gui.dlib.donate.button.no = 'Спросить меня позже'
gui.dlib.donate.button.never = 'Больше никогда не спрашивать'
gui.dlib.donate.button.learnabout = 'Прочитать про "Donationware"...'
gui.dlib.donate.button.learnabout_url = 'https://ru.wikipedia.org/wiki/Donationware'

message.dlib.hudcommons.edit.notice = 'Нажмите ESC для выхода из режима редактирования'

gui.dlib.donate.text = [[Привет! Как я вижу, Вы были долго не за клавиатурой, чтож... Я хотел бы Вас попросить:
Сделайте пожалуйста пожертвование! DLib как и аддоны котороые базируются на нем являются Donationware
Тоесть, данное ПО существует только из-за энтузиазма и (возможно) регулярных пожертвований пользователей
для поддержания автора данного ПО! Я понимаю, что времена сейчас тугие, и не прошу вас "Пожертвуй сейчас!"
Но хотел что бы Вы хотя бы прочитали данное обращение. Как вы знаете - что к примеру 50₽ это мало,
примерно столько же стоит проезд в автобусе в Москве, но давайте вдумаемся в статистику: если сейчас
абсолютно все, кто использует DLib и другие аддоны пожертвуют 50₽ каждый, то этого будет достаточно
что бы покрыть все кредиты моих родителей, а так же помочь моей Матери, которая работает с 5 утра до 22 вечера
ради того, что бы придти потом домой поспать и не высыпаться на следующий рабочий день.
Если вы сделаете пожертвование, это окажет помощь следующим аддонам, которые используются:
DLib%s]]

gui.dlib.donate.more = ' и еще %i аддонов!..'
