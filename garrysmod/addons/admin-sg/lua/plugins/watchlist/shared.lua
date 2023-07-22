local plugin = plugin;

plugin.name = 'Dobrograd Watchlist';
plugin.author = 'Wani4ka';
plugin.version = '1.0';
plugin.description = 'Особая фишка Доброграда';
plugin.gamemodes = {'darkrp'};
plugin.permissions = {
	'DBG: WatchLists',
};

serverguard.phrase:Add('english', 'watchlist', {
	SERVERGUARD.NOTIFY.GREEN, '[Watchlist] ', SERVERGUARD.NOTIFY.RED, '%s', ' (%s)', SERVERGUARD.NOTIFY.WHITE, ' зашел в игру:',
});
serverguard.phrase:Add('english', 'watchlist_note', {
	SERVERGUARD.NOTIFY.GREEN, '[Watchlist] ', SERVERGUARD.NOTIFY.WHITE, '%s'
});
