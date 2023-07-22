octoradio = octoradio or {}

local function loadStations(lst, curOffset, data)
	if not IsValid(lst) then return end

	for _,v in ipairs(data) do
		lst:AddStation(v.name, v.place, v.country, v.id)
	end

	if #data == 25 then
		octoradio.btnNext:SetEnabled(true)
		function octoradio.btnNext:DoClick()
			lst:Clear()
			netstream.Request('octoradio.getByPlace', {'Dobrograd MI', 'United States', curOffset + 25}):Then(function(data)
				loadStations(lst, curOffset + 25, data)
			end):Catch(print)
		end
	else octoradio.btnNext:SetEnabled(false) end

	if curOffset > 0 then
		octoradio.btnPrev:SetEnabled(true)
		function octoradio.btnPrev:DoClick()
			lst:Clear()
			netstream.Request('octoradio.getByPlace', {'Dobrograd MI', 'United States', math.max(curOffset - 25, 0)}):Then(function(data)
				loadStations(lst, math.max(curOffset - 25, 0), data)
			end):Catch(print)
		end
	else octoradio.btnPrev:SetEnabled(false) end

	lst:InvalidateChildren()
end

function octoradio.populateDobrograd(pan)

	local lst = octoradio.createList(pan)
	netstream.Request('octoradio.getByPlace', {'Dobrograd MI', 'United States', 0}):Then(function(data)
		loadStations(lst, 0, data)
	end)

	local submit = octolib.button(pan, 'Добавить свою радиостанцию', function()
		octoesc.OpenURL('https://octo.gg/dbg-radio')
	end)
	submit:Dock(BOTTOM)

end
