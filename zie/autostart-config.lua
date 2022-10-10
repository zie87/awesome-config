-----------------------------------------------------------------------------------------------------------------------
--                                              Autostart app list                                                   --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful = require("awful")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local autostart = {}

-- Application list function
--------------------------------------------------------------------------------
function autostart.run()
	-- environment

	-- gnome environment
	awful.spawn.with_shell("/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1")

	-- firefox sync

	-- utils

	-- apps
	awful.spawn.with_shell("/usr/bin/nm-applet")
	-- awful.spawn.with_shell("$HOME/.dropbox-dist/dropboxd")
	-- awful.spawn.with_shell("/usr/bin/megasync")
end

-- Read and commands from file and spawn them
--------------------------------------------------------------------------------
function autostart.run_from_file(file_)
	local f = io.open(file_)
	for line in f:lines() do
		if line:sub(1, 1) ~= "#" then awful.spawn.with_shell(line) end
	end
	f:close()
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return autostart
