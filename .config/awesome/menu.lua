scripts = scripts
-- Create a launcher widget and a main menu
myawesomemenu = {
  { "hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "manual",      terminal .. " -e man awesome" },
  { "edit config", termexec .. editor .. " " .. home .. ".config/awesome/rc.lua" },
  { "restart",     awesome.restart },
  { "quit",        function() awesome.quit() end },
}

powermenu = {
  { "Shutdown", scripts .. "powermenu.sh shutdown" },
  { "Reboot",   scripts .. "powermenu.sh reboot" },
  { "Sleep",    scripts .. "powermenu.sh sleep" },
}

menu_scripts = {
  { "Scan QR Code", scripts .. "qrcode.sh" },
  { "Scan text (Tesseract)",   scripts .. "tesseract.sh" },
  { "Kill ram hog",   scripts .. "kill_ram_hog.sh" },
  { "Show emojis",    scripts .. "dmoji.sh" },
}

mymainmenu = awful.menu({
  items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
    { "open terminal", terminal,      termIcon },
    { "change wallpaper",
      function()
        awful.spawn.with_shell("~/.config/awesome/scripts/pywal.sh -f")
      end,
      wallIcon },
    { "scripts", menu_scripts, commandIcon  },
    { "power", powermenu, powerIcon }
  }
})

mylauncher = wibox.widget {
  left   = 1,
  top    = 1,
  bottom = 1,
  right  = 0,
  widget = wibox.container.margin,
  {
    widget = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })
  }
}

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
