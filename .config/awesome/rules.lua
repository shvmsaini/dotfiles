-- Rules to apply to new clients (through the "manage" signal).
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
        placement = awful.placement.no_overlap+awful.placement.no_offscreen
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
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
         -- "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer",
          "org.cryptomator.launcher.Cryptomator$MainApp"
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true, placement = awful.placement.centered }
    },

    -- No titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog", "utility" }
      }, properties = { titlebars_enabled = false, placement = awful.placement.centered }
    },

    -- Set Logseq to always map on the tag named "2" on screen 1.
    { rule = { class = "Logseq" },
      properties = { screen = 2, tag = " 2 " }
    },
    -- Gimp
    { rule = { class = "Gimp-2.10" },
      properties = { screen = 2, tag = " 9 " }
    },
    -- Code
    { rule = { class = "code-oss" },
      properties = { screen = 2, tag = " 3 " }
    },
    -- Bitwarden
    {
      rule = {class = "Bitwarden"},
      properties = {floating = true, placement = awful.placement.centered, width = 1100, height = 650}
    }
}