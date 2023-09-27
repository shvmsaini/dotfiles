-- Pywal Integration
xresources = require("beautiful.xresources")
xrdb = xresources.get_current_theme()

-- Assets 
theme_assets = require("beautiful.theme_assets")

-- Themes define colours, icons, font and wallpapers.
--beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- Awesome variables
beautiful.useless_gap = 2
beautiful.master_width_factor = 0.555

-- Icons
iconFolder = home .. "/.local/share/icons/material/"
powerIcon = iconFolder .. "white/power.svg"
termIcon = iconFolder .. "white/terminal.svg"
wallIcon = iconFolder .. "white/wallpaper.svg"
arrowIcon = iconFolder .. "white/arrow_right.svg"
upIcon = iconFolder .. "white/arrow_upward.svg"
downIcon = iconFolder .. "white/arrow_downward.svg"
titlebarIcons = gears.filesystem.get_configuration_dir() .. "/assets/"

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
-- beautiful.font = "FreeSans 9"
beautiful.font = "Hermit Nerd Font Mono 9"
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
beautiful.notification_font = "Fira Code 12"
beautiful.notification_border_color = xrdb.foreground
beautiful.notification_border_width = 2
beautiful.notification_icon_size = 100
beautiful.notification_fg = xrdb.foreground
beautiful.notification_bg = xrdb.background
beautiful.notification_margin = 5
beautiful.notification_max_width = 1000
beautiful.notification_max_height = 100
--beautiful.notification_shape = gears.shape.rounded_rect

-- Wibar
beautiful.wibar_bg = xrdb.background

-- Taglist Widget
beautiful.taglist_bg_focus = xrdb.foreground
beautiful.taglist_fg_focus = xrdb.background
beautiful.taglist_bg_urgent = "#DF5774"
beautiful.taglist_fg_urgent = xrdb.background
beautiful.taglist_squares_sel = theme_assets.taglist_squares_sel(4, xrdb.color6)
beautiful.taglist_squares_unsel = theme_assets.taglist_squares_unsel(4, xrdb.color6)

-- Systray
beautiful.bg_systray = xrdb.background
beautiful.systray_icon_spacing = 5

-- Snap
awful.mouse.snap.edge_enabled = false
beautiful.snap_bg = xrdb.foreground
beautiful.snap_shape = gears.shape.rectangle

-- Prompt
beautiful.prompt_bg = "#DF5774"
beautiful.prompt_fg = xrdb.background

-- Titlebar
beautiful.titlebar_fg = xrdb.foreground .. "FF"
beautiful.titlebar_bg = xrdb.background .. "FF"

-- Close Button
beautiful.titlebar_close_button_normal = titlebarIcons .. 'normal.svg'
beautiful.titlebar_close_button_focus  = titlebarIcons .. 'close_focus.svg'
beautiful.titlebar_close_button_normal_hover = titlebarIcons .. 'close_focus_hover.svg'
beautiful.titlebar_close_button_focus_hover  = titlebarIcons .. 'close_focus_hover.svg'

-- Minimize Button
beautiful.titlebar_minimize_button_normal = titlebarIcons .. 'normal.svg'
beautiful.titlebar_minimize_button_focus  = titlebarIcons .. 'minimize_focus.svg'
beautiful.titlebar_minimize_button_normal_hover = titlebarIcons .. 'minimize_focus_hover.svg'
beautiful.titlebar_minimize_button_focus_hover  = titlebarIcons .. 'minimize_focus_hover.svg'

-- Maximized Button (While Window is Maximized)
beautiful.titlebar_maximized_button_normal_active = titlebarIcons .. 'normal.svg'
beautiful.titlebar_maximized_button_focus_active  = titlebarIcons .. 'maximized_focus.svg'
beautiful.titlebar_maximized_button_normal_active_hover = titlebarIcons .. 'maximized_focus_hover.svg'
beautiful.titlebar_maximized_button_focus_active_hover  = titlebarIcons .. 'maximized_focus_hover.svg'

-- Maximized Button (While Window is not Maximized)
beautiful.titlebar_maximized_button_normal_inactive = titlebarIcons .. 'normal.svg'
beautiful.titlebar_maximized_button_focus_inactive  = titlebarIcons .. 'maximized_focus.svg'
beautiful.titlebar_maximized_button_normal_inactive_hover = titlebarIcons .. 'maximized_focus_hover.svg'
beautiful.titlebar_maximized_button_focus_inactive_hover  = titlebarIcons .. 'maximized_focus_hover.svg'