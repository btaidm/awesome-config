local awful = require('awful')
local wibox = require('wibox')
local common = require('lunaconf.widgets.common')
local log = require('lunaconf.log')

local tasklist = {}

local function new(self, screen_index, filter, buttons)
	local icon_widget_wrapper = function(...)
		log.info("WHat type is screen? %s", screen_index)
		common.icon_widgets(screen[screen_index], ...)
	end
	return awful.widget.taglist(screen_index, filter, buttons, nil, icon_widget_wrapper, wibox.layout.fixed.horizontal())
end

return setmetatable(tasklist, { __call = new })
