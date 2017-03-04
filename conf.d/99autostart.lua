local awful = require('awful')
local lunaconf = require('lunaconf')
local naughty = require('naughty')

-- Use dex tool to start all desktop files from xdg autostart folders or show a warning
-- if dex isn't installed
lunaconf.utils.command_exists('dex', function(exists)
	if exists then
		awful.spawn.spawn("dex -a -e awesome")
	else
		naughty.notify({
			title = "dex missing",
			text = "Install dex to enable autostart"
		})
	end
end)
