function octoshop.formatMoney(amount)

	return amount .. octolib.string.formatCount(amount, ' фишка', ' фишки', ' фишек')

end
