local awful = require('awful')
local lunaconf = require('lunaconf')
local config = require("lunaconf.config")

-- Use i3lock to lock the screen (requires package x11-misc/i3lock)
local lock_cmd = scriptpath .. "lockscreen.sh"
-- lockout time in minutes
local screensaver_timeout = 10

-- Use lock_cmd as a screensaver (requires x11-misc/xautolock)
local pid = tonumber(awful.util.pread("pidof xautolock"))
if not pid then
	awful.util.spawn("xautolock -time " .. screensaver_timeout .. " -locker '" .. lock_cmd .. "'")
end

-- Add shortcut for config.MOD + l to lock the screen
lunaconf.keys.globals(awful.key({ config.MOD }, "l", function() awful.util.spawn(lock_cmd) end))
