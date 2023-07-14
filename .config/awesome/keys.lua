local naughty = require("naughty")
local awful = require("awful")
local gears = require("gears")
require("awful.autofocus")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
local menubar = require("menubar")

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({modkey}, 4, awful.tag.viewnext),
    awful.button({modkey}, 5, awful.tag.viewprev),
    awful.button({}, 1, function() mymainmenu:hide() end)
))
-- }}}
-- 

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey, }, "slash",      hotkeys_popup.show_help,
              {description = "show help", group="awesome"}),
    -- Navigation
    awful.key({ modkey, }, "Left",  function () awful.client.focus.global_bydirection("left") end,
              {description = "view left client", group = "tag"}),
    awful.key({ modkey, }, "Right", function () awful.client.focus.global_bydirection("right") end,
              {description = "view right client", group = "tag"}),
    awful.key({ modkey, }, "Up",  function () awful.client.focus.bydirection("up") end,
              {description = "view above client", group = "tag"}),
    awful.key({ modkey, }, "Down", function () awful.client.focus.bydirection("down") end,
              {description = "view below client", group = "tag"}),

    awful.key({ modkey, }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
    awful.key({ modkey, }, "grave",   awful.tag.viewnext,
              {description = "view next tag", group = "tag"}),
    awful.key({ modkey, "Shift" }, "grave",  awful.tag.viewprev,
              {description = "view prev tag", group = "tag"}),

    awful.key({ modkey, }, "j", function () awful.client.focus.byidx( 1) end,
              {description = "focus next by index", group = "client"}),
    awful.key({ modkey, }, "k", function () awful.client.focus.byidx(-1) end,
              {description = "focus previous by index", group = "client"}),

    awful.key({ modkey, }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"}, "j", function () awful.client.swap.byidx(1) end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"}, "k", function () awful.client.swap.byidx(-1) end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey }, "BackSpace", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,}, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey,}, "KP_Enter", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Mod1"}, "f", function () awful.spawn("firefox") end,
              {description = "Opens Firefox", group = "launcher"}),
    awful.key({ modkey, "Mod1"       }, "n", function () 
                local matcher = function(c)
                    return awful.rules.match(c, {class = 'Nemo'})
                end
                awful.client.run_or_raise('nemo', matcher)
            end,
              {description = "Opens Nemo", group = "launcher"}),
    awful.key({ modkey, "Mod1"       }, "l", function ()
                local matcher = function(c)
                    return awful.rules.match(c, {class = 'Logseq'})
                end
                awful.client.run_or_raise('logseq', matcher)
             end, {description = "Run or Raise Logseq", group = "launcher"}),
    awful.key({ modkey, "Mod1"       }, "t", function ()
                local matcher = function(c)
                    return awful.rules.match(c, {class = 'Tor Browser'})
                end
                awful.client.run_or_raise('torbrowser-launcher', matcher)
            end, {description = "Run or Raise Tor Browser", group = "launcher"}),
    awful.key({ modkey,}, "d", function () awful.spawn.with_shell("rofi -show drun") end,
              {description = "Opens Rofi", group = "launcher"}),
    awful.key({ modkey, "Mod1"}, "r", function () awful.spawn.with_shell(termexec .. "ranger") end,
              {description = "Opens Ranger", group = "launcher"}),
    awful.key({ modkey, "Mod1"}, "h", function () awful.spawn.with_shell(termexec .. "htop") end,
              {description = "Opens htop", group = "launcher"}),
    awful.key({ modkey, "Mod1"}, "b",
          function ()
            awful.spawn("brave", {tag =  awful.screen.focused().selected_tag})
          end, {description = "Opens Brave Browser", group = "launcher"}),
    awful.key({ "Ctrl", "Shift"}, "Print", function () awful.spawn.with_shell("flameshot gui") end,
              {description = "Opens Screenshot window", group = "launcher"}),
    awful.key({ }, "Print", function () awful.spawn.with_shell("flameshot launcher") end,
              {description = "Opens Screenshot window", group = "launcher"}),

    awful.key({ "Ctrl", "Mod1"}, "h", function () awful.spawn("clipmenu") end,
              {description = "Opens Clipboard History", group = "launcher"}),
    awful.key({ }, "Scroll_Lock", 
        function () 
              awful.spawn(termexec .. "python3", {
                floating  = true,
                tag       = mouse.screen.selected_tag,
                width = 500,
                ontop = true,
                x = 1366 - 500 - 3, -- Otherwise not placed right after closing a client and then spawning
                placement = awful.placement.maximize_vertically + awful.placement.right
              })
        end, {description = "Opens Python as calculator", group = "launcher"}),
    awful.key({ modkey, "Shift"}, "F10", function () awful.spawn(scripts .. "dictionary.sh") end,
              {description = "Opens Dictionary script", group = "launcher"}),
    awful.key({ modkey, "Shift"}, "F11", function () awful.spawn(scripts .. "privatebin.sh") end,
              {description = "Opens Privatebin client", group = "launcher"}),
    awful.key({ modkey, "Shift"}, "F12", function () awful.spawn(scripts .. "tesseract.sh") end,
              {description = "Opens Tesseract script", group = "launcher"}),

    -- Scratchpads
    awful.key({modkey, "Shift"}, "Return",
        function() 
            --     pointX = 200
            --     if awful.screen.focused() == screen[2] then
            --         pointX = 1366 + 200
            --     end

            --     local myrule = "rule = { class = { "kitty" } }, properties = { floating = true }"

            --     local matcher = function(c)
            --         return awful.rules.match(c, myrule)
            --     end 

            --     if matcher then
            --         naughty.notify { preset = naughty.config.presets.critical, title = "booom" }
                  
            --         for c in awful.client.iterate(matcher) do  
            --             c.minimized = true
            --         end
            --     else
            --     --     for c in awful.client.iterate(matcher) do  
            --     --         c.minimized = false
            --     --     end
            --     -- end
            --   awful.spawn(terminal, {
            --     floating  = true,
            --     tag       = mouse.screen.selected_tag,
            --     width = 1000,
            --     height = 500,
            --     ontop = true,
            --     sticky = true,
            --     x = pointX,
            --     placement = awful.placement.top
            --   })  
            -- end
        end, {description = "Opens terminal scratchpad", group = "launcher"}),

	-- Volume Controls
    awful.key({ modkey, }, "minus", function () awful.spawn.with_shell( scripts .. "volume.sh down") end,
              {description = "Decreases volume by 5%", group = "launcher"}),
    awful.key({ modkey, }, "KP_Subtract", function () awful.spawn.with_shell(scripts .. "volume.sh down") end,
              {description = "Decreases volume by 5%", group = "launcher"}),
    awful.key({ modkey, }, "equal", function () awful.spawn.with_shell(scripts .. "volume.sh up") end,
              {description = "Increases volume by 5%", group = "launcher"}),
    awful.key({ modkey, }, "KP_Add", function () awful.spawn.with_shell(scripts .. "volume.sh up") end,
              {description = "Increases volume by 5%", group = "launcher"}),
		    
    
    awful.key({modkey, }, "t",
        function() 
            awful.screen.focused().mywibox.visible = not awful.screen.focused().mywibox.visible 
        end, {description = "Toggle Wibox on visible screen", group = "awesome"}),

    awful.key({ modkey, "Shift"   }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "e",
        function()
            awful.spawn.with_shell("$conf/awesome/scripts/exit.sh")
        end, {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey, }, "l", function () awful.tag.incmwfact( 0.05) end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey, }, "h", function () awful.tag.incmwfact(-0.05) end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift" }, "l", function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift" }, "h", function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol( 1, nil, true) end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol(-1, nil, true) end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,}, "space", function () awful.layout.inc( 1) end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1) end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

    -- Hide All
    awful.key({}, "Pause",
        function() 
            local awful = require("awful")

            tag1 = awful.tag.find_by_name(screen[1], "umm..")
            tag2 = awful.tag.find_by_name(screen[2], "ok")

            if tag1 then
                tag1:delete()
                tag2:delete()
            else
                awful.tag.add("umm..", {
                    screen = 1
                }):view_only()
                
                awful.tag.add("ok", {
                    screen = 2
                }):view_only()

            end
        end, {description = "Hide everything from screen", group = "launcher"}),

    -- Swap Screen
    awful.key({ modkey, "Control" }, "BackSpace",
        function ()
            local focused_screen = awful.screen.focused()
            local s = focused_screen.get_next_in_direction(focused_screen, "right")
        
            -- FIXME: this only makes sense for two screens
            if not s then
                s = focused_screen.get_next_in_direction(focused_screen, "left")
            end
        
            if not s then 
                naughty.notify { preset = naughty.config.presets.critical, title = "could not get other screen" }
                return
            end
            focused_screen:swap(s)
        end, {description = "swap screens", group = "layout"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,}, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill() end,
              {description = "close", group = "client"}),
    -- awful.key({ modkey, "Shift" }, "f", awful.client.floating.toggle,
            --   {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Shift" }, "f",
            function(c)
                c.floating = not c.floating
                -- table = {}
                -- table[1] = 100
                -- table[2] = 100
                -- c:geometry(table)
            end,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "s", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,  "Shift"  }, "BackSpace",      function (c) c:move_to_screen() end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey, }, "o",      function (c) c.ontop = not c.ontop end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey, }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey, }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"}),
    awful.key({ modkey}, "s",
        function (c)
            c.sticky = not c.sticky
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"}),
        -- Move Client to tag in another screen
        awful.key({ modkey, "Mod1" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                            ind = 1
                            if (client.focus.screen == screen[1]) then
                                ind = 2
                            end
                          local tag = screen[ind].tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i.. " in other screen", group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end),
    awful.button({ modkey }, 2, function (c)
        c:kill()
    end),
    awful.button({ modkey }, 4, function (t)
        awful.tag.viewnext(t.screen)
    end),
    awful.button({ modkey }, 5, function (t)
        awful.tag.viewprev(t.screen)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}
