local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local xrdb = xresources.get_current_theme()

local tray = wibox.widget.systray()
tray.screen = screen[2]

local systray = wibox.widget {
  {
    tray,
    left   = 5,
    top    = 3,
    bottom = 3,
    right  = 5,
    widget = wibox.container.margin,
  },
  widget = wibox.container.background,
}

return systray
