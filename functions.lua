-- Return the default tag for a specific screen index.
-- The default tag is the first tag object on that screen.
function default_tag_for_screen(screenindex)
	return awful.tag.gettags(screenindex)[1]
end

-- Return the default tag for another tag.
-- The default tag is the first tag on the screen of the given tag.
function default_tag_for_tag(tag)
	return default_tag_for_screen(awful.tag.getscreen(tag))
end

-- Limit clients (see below)
local tag_limits = {}

client.connect_signal("tagged", function(c, t)
	local move_client = function()
		if #c:tags() <= 1 then
			-- We have only one or less tags on the client
			-- so we do need to move it
			local alternative_tag = default_tag_for_tag(t)
			awful.client.movetotag(alternative_tag, c)
			awful.tag.viewmore({ alternative_tag }, awful.tag.getscreen(alternative_tag))
			client.focus = c
			c:raise()
		end
	end

	-- Allow floating, ontop clients everywhere
	if awful.client.floating.get(c) and c.skip_taskbar then
		return
	end

	-- Filter the client
	local filter = tag_limits[t]
	if not filter then return end -- No filter defined for that tag
	for k,v in pairs(filter) do
		-- If client doesn't match specific rule move it
		if c[k] ~= v then
			move_client()
			return
		end
	end
end)

-- Limit clients that can be attached to a specific tag.
-- Every client that is attached to the given tag is checked
-- against the given filter. If it doesn't match the filter
-- it won't be attached to the tag. If it has other tags left,
-- nothing will happen, if no other tags are attached, it will be
-- tagged with the default tag of the screen it was created on.
function limit_tag(tag, filter)
	tag_limits[tag] = filter
end

-- Starts a program, if it isn't already running, when switching
-- to a specific tag.
function start_on_tag(tag, cmd)
	local proc = cmd:sub(0, cmd:find(" "))
	tag:connect_signal("property::selected", function(t)
		if t.selected then
			local pid = tonumber(awful.util.pread("pidof " .. proc))
			if not pid then
				awful.util.spawn(cmd)
			end
		end
	end)
end

-- {{{ Run programm once
local function processwalker()
   local function yieldprocess()
      for dir in lfs.dir("/proc") do
        -- All directories in /proc containing a number, represent a process
        if tonumber(dir) ~= nil then
          local f, err = io.open("/proc/"..dir.."/cmdline")
          if f then
            local cmdline = f:read("*all")
            f:close()
            if cmdline ~= "" then
              coroutine.yield(cmdline)
            end
          end
        end
      end
    end
    return coroutine.wrap(yieldprocess)
end

function run_once(process, cmd)
   assert(type(process) == "string")
   local regex_killer = {
      ["+"]  = "%+", ["-"] = "%-",
      ["*"]  = "%*", ["?"]  = "%?" }

   for p in processwalker() do
      if p:find(process:gsub("[-+?*]", regex_killer)) then
	 return
      end
   end
   return awful.util.spawn(cmd or process)
end
-- }}}
