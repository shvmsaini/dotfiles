-- Rules to apply to new clients (through the "manage" signal).
local awful = require("awful")
local beautiful = require("beautiful")
local scr = 2 --screen.count()
local tags = MY_TAGS

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = clientkeys,
        buttons = clientbuttons,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap+awful.placement.no_offscreen,
        size_hints_honor = true,
        size_hints = { min_width = 1000, min_height = 100}
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
          "file_properties",
          "pamac-manager",
        },
        class = {
          "Arandr",
          "baobab",
          "Blueman-manager",
          "htop",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "GParted",
          "gnome-logs",
          "Pavucontrol",
          "Otpclient",
          "Sxiv",
         -- "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          -- "vlc",
          "gl",
          "mpv",
          "xtightvncviewer",
          "org.cryptomator.launcher.Cryptomator$MainApp",
          --"Zenity"
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          --"Picture in picture",
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true, placement = awful.placement.centered, ontop = true }
    },

    -- No titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog", "utility" }
      }, properties = { titlebars_enabled = false, placement = awful.placement.centered }
    },

    -- Set Logseq to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Logseq" },
    --   properties = { screen = scr, tag = tags[2] }
    -- },
    { rule = { class = "firefox" },
      properties = { tag = tags[1] }
    },
    { rule = { class = "zen-alpha" },
      properties = { tag = tags[2] }
    },
    -- Thunderbird
    { rule_any = { class = { "thunderbird", "eu.betterbird.Betterbird" } },
      properties = { tag = tags[9] }
    },
    -- Code
    { rule_any = { class = { "jetbrains-studio"}}, --"jetbrains-idea-ce" } },
      properties = { screen = scr, tag = tags[4], titlebars_enabled = false}
    },
    -- Code
    { rule_any = { class = { "code-oss", "Code" }}, --"jetbrains-idea-ce" } },
      properties = { screen = scr, tag = tags[5], titlebars_enabled = false}
    },
    -- Qbittorrent
    { rule = { class = "qBittorrent" },
      properties = { screen = 1, tag = tags[8]}
    },
    -- Insomnia
    { rule = { class = "Insomnia" },
      properties = { screen = scr, tag = tags[6]}
    },
    -- Tor
    { rule = { class = "Tor Browser" },
      properties = { screen = scr, tag = tags[8]}
    },
    -- Zenity
    { rule = { class = "zenity" },
      properties = { ontop = true, titlebars_enabled = false }
    },
    -- Emulator
    {
      rule = {name = "Running Devices"},
      properties = {width = 380, height = 850, floating = true}
    },
    -- Logcat
    {
      rule = {name = "Logcat"},
      properties = {screen = 1, tag = tags[1]}
    },
    -- Gparted
    {
      rule = {class = "GParted"},
      properties = {placement = awful.placement.centered, width = 980, height = 650, floating = true}
    },
    -- Gimp
    { rule = { class = "Gimp" },
      properties = { screen = scr, tag = tags[9] }
    },
    -- LibreOffice and Xournal
    { rule_any = { class = { "libreoffice-startcenter", "Com.github.xournalpp.xournalpp" } },
      properties = { screen = scr, tag = tags[9] }
    },
    -- Plank
    {
      rule = {class = "Plank"},
      properties = {border_width = 0, ontop = true}
    },
    -- Vlc
    {
      rule = {class = "vlc"},
      properties = {floating = true, placement = awful.placement.no_overlap+awful.placement.no_offscreen, width = 700, height = 500} -- vlc doesnt respect width and height
    },
    -- Google meet
    {
      rule = {name = "meet.google.com is sharing your screen."},
      properties = {placement = awful.placement.bottom, border_width = 0, titlebars_enabled = false}
    },
    -- Bitwarden
    {
      rule = {class = "Bitwarden"},
      properties = {floating = true, placement = awful.placement.centered, width = 1100, height = 650, titlebars_enabled = false}
    },
    -- Stremio
    {
      rule = {class = "Stremio"},
      properties = { maximized = true }
    },
    -- Scratchpad
    {
      rule_any = { class = { "scratchpad" , "termSP", "fileSP", "calcSP", "htop" }},
      properties = {
          sticky = true,
          placement = function(...)
            return awful.placement.centered(...) -- https://github.com/awesomeWM/awesome/issues/2497
          end,
          skip_taskbar = true,
          width = 1200,
          ontop = true,
          height = 750,
          floating = true,
      },
    },
    {
      rule = { class = "termSP" },
      properties = { width = 1200, height = 700 },
    },
    {
      rule_any = { name = { "Picture-in-Picture", "Picture in picture" } },
      properties = { screen = 1, floating = false },
    },
    {
      rule = { class = "calcSP" },
      properties = {
        width = 800,
        height = 400,
        placement =  function(...)
          return awful.placement.top(...)
        end,
      },
    },
}
