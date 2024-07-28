require("awful.ewmh")

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({modkey}, 4, awful.tag.viewnext),
    awful.button({modkey}, 5, awful.tag.viewprev),
    awful.button({}, 1, function() mymainmenu:hide() end)
))
-- }}}
-- 

-- Whether tags are in herbstluftwm mode (not very usable yet)
herbstMode = false

-- Scratchpads
SP = nil
SPs = {}
for i = 1, 12 do
  SPs[i] = nil -- SP itself 
  SPs[i + 12] = false -- SP Property
end
htopSP = nil
fileSP = nil
calcSP = nil
termSP = nil
SPkeys = nil

notify = function(title, text)
    naughty.notify({
        title = title,
        text = text,
        timeout = 1,
        icon = "/usr/share/icons/breeze/actions/32/bookmarks.svg",
        bg = xrdb.foreground,
        fg = xrdb.background,
        position = "bottom_middle",
        border_width = 1,
        border_color = xrdb.background
    })
end

makeSP = function(c, i, m)
    if m then
        if SPs[i] and SPs[i].valid then
            SPs[i].minimized = not SPs[i].minimized
            client.focus = SPs[i]
            SPs[i]:raise()
        else 
            if not client.focus then
                return
            end
            notify("Marked", "Marked client on F" .. i)
            SPs[i] = client.focus
		  client.focus.sticky = true
            SPs[i].sticky = true
            if not SPs[i].floating then
                SPs[i+12] = false
                SPs[i].floating = true
                SPs[i].width = 1100
                SPs[i].height = 800
                SPs[i].placement = awful.placement.centered(client.focus)
            else
                SPs[i+4] = true
            end
            SPs[i].ontop = true
            SPs[i].skip_taskbar = true
            -- SPs[i].placement = function(...)
            --     return awful.placement.centered(...)
            -- end
            -- SPs[i]:geometry({width = 900, height = 900})
        end
    else
        if SPs[i] and SPs[i].valid then
            notify("Unmarked", "Unmarked client on F" .. i)
            SPs[i].sticky = false
            SPs[i].skip_taskbar = false
            if SPs[i+12] == true then
                SPs[i].floating = true
            else
                SPs[i].floating = false
            end
            SPs[i].ontop = false
        end
        SPs[i] = nil
    end
end

for i = 1, 12 do
    SPkeys = gears.table.join(SPkeys,
        -- Mark
        awful.key({modkey}, "F"..i, function()
            makeSP(c, i, true)
        end, {description = "Mark client as scratchpad w/ F" .. i .. " key", group = "Scratchpad"}),
        -- Unmark
        awful.key({modkey, "Shift"}, "F" .. i, function()
            makeSP(c, i, nil)
        end, {description = "Unmark client as scratchpad w/ F" .. i .. " key", group = "Scratchpad"})
    )
end

createTerm = function() 
        if termSP and termSP.valid then
            termSP.minimized = not termSP.minimized
            client.focus = termSP
            termSP:raise()
        else
            --awful.spawn(terminal .. " --class termSP -e fish -c 'neofetch --kitty $(cat ~/.cache/wal/wal) --size 320; fish'")
            awful.spawn(terminal .. " --class termSP -e fish -c 'fastfetch --kitty $(cat ~/.cache/wal/wal); fish'")
        end
    end

swapScreen = function ()
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

        -- Swapping tag names as well
        if herbstluftwm then
            focused_screen.selected_tag.name, s.selected_tag.name = s.selected_tag.name, focused_screen.selected_tag.name
        end

        focused_screen:swap(s)
    end

    -- {{{ Key bindings
globalkeys = gears.table.join(SPkeys,
    awful.key({ modkey, }, "slash",      hotkeys_popup.show_help,
              {description = "show help", group="awesome"}),
    -- Navigation
    awful.key({ modkey, }, "Left",  function ()
            if awful.layout.get(awful.screen.focused()) == awful.layout.suit.max then
                awful.client.focus.byidx( -1)
            else 
                awful.client.focus.global_bydirection("left")
            end
        end,{description = "view left client", group = "tag"}),
    awful.key({ modkey, }, "Right", function () 
            if awful.layout.get(awful.screen.focused()) == awful.layout.suit.max then
                awful.client.focus.byidx( 1)
            else 
                awful.client.focus.global_bydirection("right")
            end
        end,{description = "view right client", group = "tag"}),
    awful.key({ modkey, }, "Up",  function () awful.client.focus.bydirection("up") end,
              {description = "view above client", group = "tag"}),
    awful.key({ modkey, }, "Down", function () awful.client.focus.bydirection("down") end,
              {description = "view below client", group = "tag"}),

    awful.key({ modkey, }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
    awful.key({ modkey, }, "grave",   awful.tag.viewnext,
              {description = "view next tag", group = "tag"}),
    awful.key({ modkey, "Ctrl" }, "Right",  awful.tag.viewnext,
              {description = "view prev tag", group = "tag"}),
    awful.key({ modkey, "Shift" }, "grave",  awful.tag.viewprev,
              {description = "view prev tag", group = "tag"}),
    awful.key({ modkey, "Ctrl" }, "Left",  awful.tag.viewprev,
              {description = "view prev tag", group = "tag"}),

    awful.key({ modkey, }, "j", function () awful.client.focus.byidx( 1) end,
              {description = "focus next by index", group = "client"}),
    awful.key({ modkey, }, "c", function () awful.client.focus.byidx( 1) end,
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
    awful.key({modkey, "Shift"}, "minus", function() awful.tag.incgap(-1) end,
            {description = "decrease tag's client gap by 1", group = "tag"}),
    awful.key({modkey, "Shift"}, "equal", function() awful.tag.incgap(1) end,
            {description = "Increase tag's client gap by 1", group = "tag"}),
    awful.key({modkey, "Shift"}, "x",
        function() 
            if awful.layout.get(awful.screen.focused()) == awful.layout.suit.max then
                if awful.screen.focused() == screen[0] then
                    awful.layout.set(awful.layout.suit.tile)
                else
                    awful.layout.set(awful.layout.suit.tile.left)
                end
            else
                awful.layout.set(awful.layout.suit.max)
                client.focus:raise()
            end
        end,
        {description = "Set layout to Max", group = "tag"}),

    -- Standard program
    awful.key({ modkey,}, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey,}, "KP_Enter", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, altkey}, "f", function () awful.spawn(mainbrowser) end,
              {description = "Opens " .. mainbrowser, group = "launcher"}),
    awful.key({ modkey, altkey}, "p", function () awful.spawn("pavucontrol") end,
              {description = "Opens Pavucontrol", group = "launcher"}),
    awful.key({ modkey, altkey}, "e", function () awful.spawn(termexec .. "nvim") end,
              {description = "Opens Neovim", group = "launcher"}),
    awful.key({ modkey, altkey}, "n", function () 
                local matcher = function(c)
                    return awful.rules.match(c, {class = 'Nemo'})
                end
                awful.client.run_or_raise('nemo', matcher)
                -- awful.spawn.raise_or_spawn('nemo', nil, matcher)
            end, {description = "Opens Nemo", group = "launcher"}),
    awful.key({ modkey, altkey}, "d", function () 
                local matcher = function(c)
                    return awful.rules.match(c, {class = 'Dolphin'})
                end
                awful.client.run_or_raise('dolphin', matcher)
                -- awful.spawn.raise_or_spawn('dolphin', nil, matcher)
            end, {description = "Opens Dolphin", group = "launcher"}),

    -- TODO: convert to raise_or_spawn
    awful.key({ modkey, altkey}, "g", function ()
                local matcher = function(c)
                    return awful.rules.match(c, {class = 'Logseq'})
                end
                awful.client.run_or_raise('logseq', matcher)
             end, {description = "Run or Raise Logseq", group = "launcher"}),
    awful.key({ modkey, altkey}, "t", function ()
                local matcher = function(c)
                    return awful.rules.match(c, {class = 'Tor Browser'})
                end
                awful.client.run_or_raise('torbrowser-launcher', matcher)
            end, {description = "Run or Raise Tor Browser", group = "launcher"}),
    awful.key({ modkey,}, "d", function () awful.spawn.with_shell("rofi -show drun") end,
              {description = "Opens Rofi", group = "launcher"}),
    awful.key({ modkey,}, "v", function () awful.spawn.with_shell("rofi -show window") end,
              {description = "Opens Rofi", group = "launcher"}),
    awful.key({ modkey, altkey}, "r", function ()
            if fileSP and fileSP.valid then
                fileSP.minimized = not fileSP.minimized
                client.focus = fileSP
                fileSP:raise()
            else
                awful.spawn(terminal .. " --class fileSP -e ranger")
            end
        end, {description = "Opens Ranger", group = "launcher"}),
    awful.key({ modkey, altkey}, "h", function ()
            if htopSP and htopSP.valid then
                htopSP.minimized = not htopSP.minimized
                client.focus = htopSP
                htopSP:raise()
            else
                awful.spawn.with_shell(terminal .. " --class \"htop\" -e htop")
            end
        end, {description = "Opens htop", group = "launcher"}),

    -- Miscelleneous programs and scripts
    awful.key({ modkey, "Shift"}, "Print", function () awful.spawn.with_shell("flameshot gui") end,
              {description = "Opens Screenshot window", group = "launcher"}),
    awful.key({ }, "Print", function () awful.spawn.with_shell("flameshot launcher") end,
              {description = "Opens Screenshot window", group = "launcher"}),
    awful.key({ "Ctrl", altkey}, "h", function ()
        awful.spawn("rofi -modi \"clipboard:greenclip print\" -show clipboard -run-command '{cmd}'")
        end, {description = "Opens Clipboard History", group = "launcher"}),
    awful.key({ modkey, "Shift"}, "p", function () awful.spawn(scripts .. "privatebin.sh") end,
              {description = "Opens Privatebin client", group = "launcher"}),
    awful.key({ modkey, "Shift"}, "t", function () awful.spawn(scripts .. "tesseract.sh") end,
              {description = "Opens Tesseract script", group = "launcher"}),
    awful.key({ modkey, altkey }, "c", function() awful.spawn(terminal .. " --class CountDown -e fish -c 'countdown 10'",
            {floating = true, width = 200, height = 150, titlebars_enabled = false, ontop = true, sticky = true, placement = awful.placement.top_left, x = 0, y = 0})
        end, {description = "swap screens", group = "layout"}),

    -- Brave Profiles
    awful.key({ modkey, altkey}, "b", function ()
        awful.spawn(browser .. " --disable-application-cache --media-cache-size=1 --disk-cache-size=1",
            {tag =  awful.screen.focused().selected_tag})
        end, {description = "Opens Brave Browser with personal profile", group = "launcher"}),

    awful.key({ modkey, altkey}, "w", function ()
        awful.spawn(browser .. " --disable-application-cache --media-cache-size=1 --disk-cache-size=1",
            {tag =  awful.screen.focused().selected_tag})
        end, {description = "Opens Brave Browser with work profile", group = "launcher"}),

    -- Scratchpads
    awful.key({modkey, "Shift"}, "Return", createTerm
        , {description = "Opens terminal scratchpad", group = "scratchpad"}),
    awful.key({modkey, "Shift"}, "KP_Enter", createTerm
        , {description = "Opens terminal scratchpad", group = "scratchpad"}),
    awful.key({ }, "Scroll_Lock", 
        function () 
            if calcSP and calcSP.valid then
                calcSP.minimized = not calcSP.minimized
                client.focus = calcSP
                calcSP:raise()
            else
                awful.spawn(terminal .. " --class calcSP -e python3")
            end
        end, {description = "Opens Python as calculator", group = "scratchpad"}),
    awful.key({modkey}, "a", function() 
            if SP and SP.valid then
                SP.minimized = not SP.minimized
                client.focus = SP
                SP:raise()
            else 
                notify("Marked", "Marked client on a")
                --makeSP(client.focus)
                if not client.focus then
                    return
                end
                SP = client.focus
                SP.sticky = true
                SP.floating = true
                SP.skip_taskbar = true
                SP.ontop = true
            end
        end, {description = "Makes focused client scratchpad", group = "scratchpad"}),
    awful.key({modkey, "Shift"}, "a", function()
            if SP and SP.valid then
                notify("Unmarked", "Unmarked client on a")
                SP.sticky = false
                SP.skip_taskbar = false
                SP.floating = false
                SP.ontop = false
            end
            SP = nil
        end, {description = "Removes client scratchpad if focused client is scratchpad", group = "scratchpad"}),

	-- Volume Controls
    -- awful.key({ modkey, }, "minus", function () awful.spawn.with_shell( scripts .. "volume.sh down") end,
    --           {description = "Decreases volume by 5%", group = "volume"}),
    -- awful.key({ modkey, }, "KP_Subtract", function () awful.spawn.with_shell(scripts .. "volume.sh down") end,
    --           {description = "Decreases volume by 5%", group = "volume"}),
    -- awful.key({ modkey, }, "equal", function () awful.spawn.with_shell(scripts .. "volume.sh up") end,
    --           {description = "Increases volume by 5%", group = "volume"}),
    -- awful.key({ modkey, }, "KP_Add", function () awful.spawn.with_shell(scripts .. "volume.sh up") end,
    --           {description = "Increases volume by 5%", group = "volume"}),
    awful.key({ modkey, }, "minus", function () 
        simple_volume_widget:emit_signal("decrease")
    end, {description = "Decreases volume by 5%", group = "volume"}),
    awful.key({ modkey, }, "KP_Subtract", function ()
        simple_volume_widget:emit_signal("decrease")
    end, {description = "Decreases volume by 5%", group = "volume"}),
    awful.key({ modkey, }, "equal", function ()
        simple_volume_widget:emit_signal("increase")
    end, {description = "Increases volume by 5%", group = "volume"}),
    awful.key({ modkey, }, "KP_Add", function ()
        simple_volume_widget:emit_signal("increase")
    end, {description = "Increases volume by 5%", group = "volume"}),


    -- Mouse click emulate
    awful.key({altkey}, "KP_Up", function ()
            awful.spawn.with_shell("sleep 0.1 && xdotool click 4")
        end,{description = "Mouse scroll up", group = "mouse"}),
    awful.key({altkey}, "KP_Down", function ()
            awful.spawn.with_shell("sleep 0.1 && xdotool click 5")
        end, {description = "Mouse scroll down", group = "mouse"}),
    awful.key({altkey }, "KP_Right", function () 
            awful.spawn.with_shell("sleep 0.1 && xdotool keydown alt key Right keyup alt")
        end, {description = "Mouse scroll up", group = "mouse"}),
    awful.key({altkey }, "KP_Left", function ()
            awful.spawn.with_shell("sleep 0.1 && xdotool keydown alt key Left keyup alt")
        end, {description = "Mouse scroll down", group = "mouse"}),
    
    awful.key({modkey, }, "t",
        function() 
            awful.screen.focused().mywibox.visible = not awful.screen.focused().mywibox.visible 
        end, {description = "Toggle Wibox on visible screen", group = "awesome"}),

    awful.key({ modkey, "Shift"   }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "e",
        function()
            awful.spawn.with_shell("~/.config/awesome/scripts/exit.sh")
        end, {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey, "Control", "Shift"   }, "k",
        function()
            awful.spawn.with_shell("~/.config/scripts/kill_ram_hog.sh")
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
                    c:emit_signal("request::activate", "key.unminimize", {raise = true})
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey }, "r", function()
            awful.prompt.run {
                prompt = "  : ",
                textbox = awful.screen.focused().mypromptbox.widget,
                exe_callback = function(command)
                    awful.spawn.with_shell(command)
                end,
                history_path = awful.util.get_cache_dir() .. "/history",
                history_max = 50,
                completion_callback = awful.completion.shell,
            }
        end, { description = "run prompt", group = "launcher" }),


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

    -- Hide all screens
    awful.key({}, "Pause",
        function() 
            for s in screen do
                tag = awful.tag.find_by_name(s, ">_<")
                if tag then
                    tag:delete()
                else
                    awful.tag.add(">_<", { screen = s }):view_only()
                end
            end
            -- Hide scratchpads
            for i = 1, 4 do
                if SPs[i] and SPs[i].valid then
                    SPs[i].minimized = true
                end
            end
            if SP and SP.valid then
                SP.minimized = true
            end
        end, {description = "Hide everything from screen", group = "launcher"}),

    -- Swap Screen
    awful.key({ modkey, "Control" }, "BackSpace", swapScreen
        , {description = "swap screens", group = "layout"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,}, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift" }, "q", function (c) c:kill() end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Shift" }, "f", awful.client.floating.toggle,
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
        {description = "Make client sticky", group = "client"}),
    awful.key({modkey}, "b",
        function(c)
            awful.titlebar.toggle(c)
        end ,
        {description = "Toggle titlebars", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        if not herbstluftwm then
                            local tag = awful.screen.focused().tags[i]
                            tag:view_only()
                        else 
                            local focused_screen = awful.screen.focused()
                            -- local tag = screen.tags[i]
                            local tag = awful.tag.find_by_name(focused_screen, " " .. i .. " ")
                            if tag then
                            tag:view_only()
                            else 
                                if focused_screen == screen[1] then
                                    local tag = awful.tag.find_by_name(screen[2], " " .. i .. " ")
                                    tag:view_only()
                                    swapScreen()
                                    tag:view_only()
                                    -- awful.screen.focus_relative(-1)
                                else 
                                    local tag = awful.tag.find_by_name(screen[1], " " .. i .. " ")
                                    tag:view_only()
                                    swapScreen()
                                    tag:view_only()
                                    -- awful.screen.focus_relative(-1)
                                end
                            end
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
        awful.key({ modkey, altkey }, "#" .. i + 9,
                  function ()
                      if client.focus then
                            local ind = 1
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
