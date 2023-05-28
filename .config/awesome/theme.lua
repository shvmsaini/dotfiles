-- Theme handling library
local beautiful = require("beautiful")
local gears = require("gears")
xresources = require("beautiful.xresources")
xrdb = xresources.get_current_theme() -- For pywal

-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

beautiful.awesome_icon = "/home/shvmpc/.local/share/icons/arch_white.svg"

beautiful.useless_gap = 2
beautiful.master_width_factor = 0.555

-- Menu
beautiful.menu_height = 24 
beautiful.menu_width = 300 
beautiful.menu_bg_focus = xrdb.foreground
beautiful.menu_fg_focus = xrdb.background
beautiful.menu_bg_normal = xrdb.background
beautiful.menu_fg_normal = xrdb.foreground

-- All font
beautiful.font = "FreeSans 9"
beautiful.menu_font = "Hack Nerd Font Mono 11"
beautiful.hotkeys_font = "Hack Nerd Font Mono 11" 
beautiful.hotkeys_description_font = "Hack Nerd Font Mono 11"

-- Client
beautiful.border_focus = xrdb.foreground
beautiful.border_normal = xrdb.background
beautiful.border_width = 1

-- Tasklist Widget
beautiful.tasklist_bg_focus = xrdb.foreground
beautiful.tasklist_fg_focus = xrdb.background
beautiful.tasklist_bg_normal = xrdb.background
beautiful.tasklist_fg_normal = xrdb.foreground

-- Notification
beautiful.notification_font = "Hack Nerd Font Mono 14"
beautiful.notification_border_color = xrdb.foreground
beautiful.notification_border_width = 2
beautiful.notification_icon_size = 80

-- Wibar
beautiful.wibar_bg = xrdb.background

-- Taglist Widget
beautiful.taglist_bg_focus = xrdb.foreground
beautiful.taglist_fg_focus = xrdb.background

-- Systray
beautiful.bg_systray = xrdb.background