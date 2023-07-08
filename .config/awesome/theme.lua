-- Theme handling library
local beautiful = require("beautiful")
local gears = require("gears")

-- Pywal Integration
xresources = require("beautiful.xresources")
xrdb = xresources.get_current_theme()

-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- Awesome variables
beautiful.useless_gap = 2
beautiful.master_width_factor = 0.555

-- Icons
iconFolder = "/home/shvmpc/.local/share/icons/material"
powerIcon = iconFolder .. "/white/power.svg"
termIcon = iconFolder .. "/white/terminal.svg"
wallIcon = iconFolder .. "/white/wallpaper.svg"
arrowIcon = iconFolder .. "/white/arrow_right.svg"

beautiful.awesome_icon = iconFolder .. "/white/arch_white.svg"

-- Menu
beautiful.menu_height = 30 
beautiful.menu_width = 200 
beautiful.menu_bg_focus = xrdb.foreground
beautiful.menu_fg_focus = xrdb.background
beautiful.menu_bg_normal = xrdb.background
beautiful.menu_fg_normal = xrdb.foreground
beautiful.menu_submenu_icon = arrowIcon

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
beautiful.notification_font = "Hack Nerd Font Mono 12"
beautiful.notification_border_color = xrdb.foreground
beautiful.notification_border_width = 2
beautiful.notification_icon_size = 70
beautiful.notification_fg = xrdb.foreground
beautiful.notification_bg = xrdb.background
beautiful.notification_margin = 5
--beautiful.notification_shape = gears.shape.rounded_rect

-- Wibar
beautiful.wibar_bg = xrdb.background

-- Taglist Widget
beautiful.taglist_bg_focus = xrdb.foreground
beautiful.taglist_fg_focus = xrdb.background
beautiful.taglist_bg_urgent = "#DF5774"
beautiful.taglist_fg_urgent = xrdb.background

-- Systray
beautiful.bg_systray = xrdb.background
