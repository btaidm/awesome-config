local awful = require('awful')
local naughty = require('naughty')
local gears = require('gears')
local lunaconf = require('lunaconf')
local MOD = lunaconf.config.MOD

-- Requires setxkbmap to be installed

local setkeymap = "setxkbmap"
local keyboard_layouts = lunaconf.config.get("keyboard_layouts", { "us" })
local current_layout = 1

local last_id = 0

local set_current_layout = function()
	lunaconf.utils.spawn(setkeymap .. " " .. keyboard_layouts[current_layout])
end

-- Initialize with primary keyboard layout
set_current_layout()

lunaconf.keys.globals(awful.key({ MOD }, "Tab", function()
	current_layout = ((current_layout) % #keyboard_layouts) + 1
	set_current_layout()
	local notif = naughty.notify({
		title = "Changed keyboard layout",
		text = keyboard_layouts[current_layout]:upper(),
		replaces_id = last_id
	})
	last_id = notif.id
end))

-- Enable X-server kill
lunaconf.utils.spawn(setkeymap .. " -option terminate:ctrl_alt_bksp")
