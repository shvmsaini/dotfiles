-- Theme handling library
local beautiful = require("beautiful")
local gears = require("gears")
-- xresources.get_current_theme () 

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.wibar_bg = "#000000" 
beautiful.useless_gap = 1
beautiful.master_width_factor = 0.555
-- beautiful.tasklist_bg_focus = Background
beautiful.menu_height = 24 
beautiful.menu_width = 300 
beautiful.font = "FreeSans 9"
beautiful.menu_font = "Hack Nerd Font Mono 11"
beautiful.hotkeys_font = "Hack Nerd Font Mono 11" 
beautiful.hotkeys_description_font = "Hack Nerd Font Mono 11"
beautiful.border_width = 2

beautiful.border_normal = "#222222"
-- beautiful.border_focus = "#222222"
beautiful.tasklist_bg_focus = "#333333"
beautiful.tasklist_bg_normal = "#000000"
beautiful.awesome_icon = "/home/shvmpc/.local/share/icons/arch_white.svg"

-- }}}
