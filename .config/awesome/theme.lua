-- Pywal Integration
xresources = require("beautiful.xresources")
xrdb = xresources.get_current_theme()
-- xrdb.foreground = xrdb.color4
-- xrdb.background = "#000000"
-- Assets 
theme_assets = require("beautiful.theme_assets")

-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- Awesome variables
beautiful.useless_gap = 2
beautiful.master_width_factor = 0.555

-- Icons
iconFolder = gears.filesystem.get_configuration_dir() .. "/assets/"
powerIcon = iconFolder .. "power.svg"
termIcon = iconFolder .. "terminal.svg"
wallIcon = iconFolder .. "wallpaper.svg"
arrowIcon = iconFolder .. "arrow_right.svg"
upIcon = iconFolder .. "arrow_upward.svg"
downIcon = iconFolder .. "arrow_downward.svg"
ramIcon = iconFolder .. "memory.svg"
cpuIcon = iconFolder .. "memory.svg"
volumeHighIcon =  gears.filesystem.get_configuration_dir() .. "/awesome-wm-widgets/volume-widget/icons/audio-volume-high-symbolic.svg"
volumeMedIcon =  gears.filesystem.get_configuration_dir() .. "/awesome-wm-widgets/volume-widget/icons/audio-volume-medium-symbolic.svg"
volumeLowIcon =  gears.filesystem.get_configuration_dir() .. "/awesome-wm-widgets/volume-widget/icons/audio-volume-low-symbolic.svg"
volumeMuteIcon =  gears.filesystem.get_configuration_dir() .. "/awesome-wm-widgets/volume-widget/icons/audio-volume-muted-symbolic.svg"

-- Wibar Awesome Icon
-- beautiful.awesome_icon = iconFolder .. "arch_white.svg"
beautiful.awesome_icon = iconFolder .. "icon-alien-symbolic.svg"
-- beautiful.awesome_icon = "/usr/share/icons/Papirus/32x32/apps/pacman.svg"

-- Menu
beautiful.menu_height = 30 
beautiful.menu_width = 200 
beautiful.menu_bg_focus = xrdb.foreground
beautiful.menu_fg_focus = xrdb.background
beautiful.menu_bg_normal = xrdb.background
beautiful.menu_fg_normal = xrdb.foreground
beautiful.menu_submenu_icon = arrowIcon

-- All font
beautiful.font = "FreeSans 12"
--beautiful.font = "SF Pro Display 11.3"
--beautiful.font = "SF Pro Display 11.3"
beautiful.menu_font = "Hack Nerd Font Mono 11"
beautiful.hotkeys_font = "Hack Nerd Font Mono 11" 
beautiful.hotkeys_description_font = "Hack Nerd Font Mono 11"

-- Client
beautiful.border_focus = xrdb.foreground
beautiful.border_normal = xrdb.background
beautiful.border_width = 2

-- Tasklist Widget
beautiful.tasklist_bg_focus = xrdb.foreground
beautiful.tasklist_fg_focus = xrdb.background
beautiful.tasklist_bg_normal = xrdb.background
beautiful.tasklist_fg_normal = xrdb.foreground
beautiful.tasklist_bg_minimize = "#232323"
beautiful.tasklist_fg_minimize = xrdb.foreground

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
beautiful.notification_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 5)
end

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
beautiful.titlebar_close_button_normal = iconFolder .. 'normal.svg'
beautiful.titlebar_close_button_focus  = iconFolder .. 'close_focus.svg'
beautiful.titlebar_close_button_normal_hover = iconFolder .. 'close_focus_hover.svg'
beautiful.titlebar_close_button_focus_hover  = iconFolder .. 'close_focus_hover.svg'

-- Minimize Button
beautiful.titlebar_minimize_button_normal = iconFolder .. 'normal.svg'
beautiful.titlebar_minimize_button_focus  = iconFolder .. 'minimize_focus.svg'
beautiful.titlebar_minimize_button_normal_hover = iconFolder .. 'minimize_focus_hover.svg'
beautiful.titlebar_minimize_button_focus_hover  = iconFolder .. 'minimize_focus_hover.svg'

-- Maximized Button (While Window is Maximized)
beautiful.titlebar_maximized_button_normal_active = iconFolder .. 'normal.svg'
beautiful.titlebar_maximized_button_focus_active  = iconFolder .. 'maximized_focus.svg'
beautiful.titlebar_maximized_button_normal_active_hover = iconFolder .. 'maximized_focus_hover.svg'
beautiful.titlebar_maximized_button_focus_active_hover  = iconFolder .. 'maximized_focus_hover.svg'

-- Maximized Button (While Window is not Maximized)
beautiful.titlebar_maximized_button_normal_inactive = iconFolder .. 'normal.svg'
beautiful.titlebar_maximized_button_focus_inactive  = iconFolder .. 'maximized_focus.svg'
beautiful.titlebar_maximized_button_normal_inactive_hover = iconFolder .. 'maximized_focus_hover.svg'
beautiful.titlebar_maximized_button_focus_inactive_hover  = iconFolder .. 'maximized_focus_hover.svg'
