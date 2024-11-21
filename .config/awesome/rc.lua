-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
cairo = require("lgi").cairo
-- Standard awesome library
gears = require("gears")
awful = require("awful")
require("awful.autofocus")
-- Theme handling library
-- Widget and layout library
wibox = require("wibox")
beautiful = require("beautiful")
-- Notification library
naughty = require("naughty")
menubar = require("menubar")
hotkeys_popup = require("awful.hotkeys_popup")
-- Hides Tmux keys
package.loaded["awful.hotkeys_popup.keys.tmux"] = {}
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err)
    })
    in_error = false
  end)
end
-- }}}

-- {{{ Variable definitions
terminal = "kitty"
termexec = terminal .. " -e "
editor = os.getenv("nvim") or "vim"
home = os.getenv("HOME") .. "/"
filemanager = "dolphin" or "nemo"
scripts = home .. ".config/scripts/"
browser = "brave-browser-beta"
mainbrowser = "firefox"
wall = "/run/media/shvmpc/forlinuxuse/Wallpapers/"
-- wall = "/mnt/forlinuxuse/Wallpapers/"

-- Default modkey.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
--awful.layout.layouts = {}
awful.layout.append_default_layouts({
  awful.layout.suit.tile.left,
  awful.layout.suit.tile,
})
-- }}}
--
awesome.set_preferred_icon_size(24)

-- Beautiful theme
require("theme")

-- Menu
require("menu")

-- Wibar
require("wibar")

-- Dock
-- require("widgets/dock")

-- Notes
-- require("widgets/notes")

-- Keys
require("keys")

-- Rules
require("rules")

-- Signals
require("signals")

-- Notification
require("widgets/notification")

-- Autostart
awful.spawn(scripts .. "autostart.sh")
