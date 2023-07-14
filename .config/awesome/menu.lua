pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", termexec .. editor .. " " .. home .. ".config/awesome/rc.lua" },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

powermenu = {
    { "Shutdown", scripts .. "shutdown.sh"},
    { "Reboot", scripts .. "reboot.sh"},
    { "Sleep", scripts .. "sleep.sh"},
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal, termIcon },
                                    { "change wallpaper",
                                        function() 
								            awful.spawn.with_shell("~/.config/awesome/scripts/pywal.sh -f") 
                                        end,
                                        wallIcon},
                                    { "power", powermenu, powerIcon}
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it