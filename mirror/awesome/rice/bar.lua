--         _                _       _   _       
--   ___  | |__   __ _ _ __| | ___ | |_| |_ ___ 
--  / __ | '_ \ / _` | '__| |/ _ \| __| __/ _ \
-- | (__| | | | (_| | |  | | (_) | |_| ||  __/
-- \___|_| |_|\__,_|_|  |_|\___/ \__|\__\___|
--
-- charlotte's awesome awesome wm config

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Widget and layout library
local wibox = require("wibox")
local lain = require("lain")

-- Theme handling library
local beautiful = require("beautiful")

-- Clock
local clock = wibox.widget.textclock()

-- CPU activity
local cpu = lain.widget.cpu {
    settings = function()
        usage = " " .. cpu_now.usage .. " "
        widget:set_markup(lain.util.markup("#ffffff", usage))
    end
}

-- Volume widget
volume = lain.widget.pulse {
    timeout  = 5,
    settings = function()
        vlevel = "  " .. volume_now.left .. " "
        if volume_now.muted == "yes" then
            vlevel = " muted "
        end
        widget:set_markup(lain.util.markup("#ffffff", vlevel))
    end
}

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
                                if client.focus then
                                    client.focus:move_to_tag(t)
                                end
                            end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
                                if client.focus then
                                    client.focus:toggle_tag(t)
                                end
                            end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.screen.connect_for_each_screen(function(s)
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.layoutbox = awful.widget.layoutbox(s)
    s.layoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    
    -- Create a taglist widget
    s.taglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create the wibox
    s.wibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.wibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.taglist,
            s.promptbox,
        },
        nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            clock,
            volume,
            cpu,
            wibox.widget.systray(),
            s.layoutbox,
        },
    }
end)
-- }}}