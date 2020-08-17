--       _                _       _   _       
--  ____| |__   __ _ _ __| | ___ | |_| |_ ___ 
-- /  __| '_ \ / _` | '__| |/ _ \| __| __/ _ \
-- | (__| | | | (_| | |  | | (_) | |_| ||  __/
-- \____|_| |_|\__,_|_|  |_|\___/ \__|\__\___|
--
-- charlotte's awesome awesome wm config

-- Standard awesome library
local awful = require("awful")

-- Helper function to run a program once
-- Taken from JavaCafe01's dotfiles, thanks :)
local function run_once(cmd)
    local findme = cmd
    local firstspace = cmd:find(' ')
    if firstspace then
        findme = cmd:sub(0, firstspace - 1)
    end
    awful.spawn.with_shell(string.format('pgrep -u $USER -x %s > /dev/null || (%s)', findme, cmd), false)
end

-- Launch some useful programs
run_once("picom")

return autostart