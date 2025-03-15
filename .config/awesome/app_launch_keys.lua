require("awful.ewmh")
local awful = require("awful")
local wibox = require("wibox")
local modkey = modkey
local xresources = require("beautiful.xresources")
local xrdb = xresources.get_current_theme()
local altkey = altkey

local appKeys = gears.table.join(
  awful.key({ modkey, altkey }, "f", function() awful.spawn(mainbrowser) end,
    { description = "Opens " .. mainbrowser, group = "launcher" }),
  awful.key({ modkey, altkey }, "z", function()
    run_or_raise('zen', 'zen-browser')
  end, { description = "Opens " .. "zen browser", group = "launcher" }),
  awful.key({ modkey, altkey }, "m", function() awful.spawn("/opt/mullvad-browser/Browser/mullvadbrowser") end,
    { description = "Opens Mullvad browser", group = "launcher" }),
  awful.key({ modkey, altkey }, "p", function() awful.spawn("pavucontrol") end,
    { description = "Opens Pavucontrol", group = "launcher" }),
  awful.key({ modkey, altkey }, "e", function() awful.spawn(termexec .. "nvim " .. home .. "/todo.md") end,
    { description = "Opens Neovim TODO", group = "launcher" }),
  awful.key({ modkey, altkey }, "n", function()
    run_or_raise('Nemo', 'nemo')
  end, { description = "Opens Nemo", group = "launcher" }),
  awful.key({ modkey, altkey }, "d", function()
    run_or_raise('eu.betterbird.Betterbird', 'betterbird')
  end, { description = "Opens Betterbird Mail Client", group = "launcher" }),
  awful.key({ modkey, altkey }, "g", function()
    run_or_raise('Logseq', '/run/media/shvmpc/forlinuxuse/Appimage/Logseq.AppImage')
  end, { description = "Run or Raise Logseq", group = "launcher" }),
  awful.key({ modkey, altkey }, "t", function()
    run_or_raise('Tor Browser', 'torbrowser-launcher')
  end, { description = "Run or Raise Tor Browser", group = "launcher" }),
  awful.key({ modkey, altkey }, "r", function()
    if fileSP and fileSP.valid then
      fileSP.minimized = not fileSP.minimized
      client.focus = fileSP
      fileSP:raise()
    else
      awful.spawn(terminal .. " --class fileSP -e ranger")
    end
  end, { description = "Opens Ranger", group = "launcher" }),
  awful.key({ modkey, altkey }, "h", function()
    if htopSP and htopSP.valid then
      htopSP.minimized = not htopSP.minimized
      client.focus = htopSP
      htopSP:raise()
    else
      awful.spawn.with_shell(terminal .. " --class \"htop\" -e htop")
    end
  end, { description = "Opens htop", group = "launcher" }),
  awful.key({ modkey, altkey }, "c", function()
    awful.spawn(terminal .. " --class CountDown -e fish -c 'countdown 10'",
      {
        floating = true,
        width = 200,
        height = 150,
        titlebars_enabled = false,
        ontop = true,
        sticky = true,
        placement =
            awful.placement.top_left,
        x = 0,
        y = 0
      })
  end, { description = "swap screens", group = "layout" }),

  -- Brave Profiles
  awful.key({ modkey, altkey }, "b", function()
    awful.spawn(browser .. " --disable-application-cache --media-cache-size=1 --disk-cache-size=1",
      { tag = awful.screen.focused().selected_tag })
  end, { description = "Opens Brave Browser with personal profile", group = "launcher" }),
  awful.key({ modkey, altkey }, "w", function()
    awful.spawn(browser .. " --disable-application-cache --media-cache-size=1 --disk-cache-size=1",
      { tag = awful.screen.focused().selected_tag })
  end, { description = "Opens Brave Browser with work profile", group = "launcher" })
)

return appKeys
