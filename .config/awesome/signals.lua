-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
    -- awful.client.movetoscreen(c, mouse.screen)
    -- awful.client.movetoscreen(c, client.focus.screen)
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Focus urgent clients automatically
client.connect_signal("property::urgent", function(c)
    c.minimized = false
    c:jump_to()
end)

-- Preserve tags on restart
awesome.connect_signal('exit', 
    function(reason_restart)
        if not reason_restart then
            return
        end

    local file = io.open('/tmp/awesomewm-last-selected-tags', 'w+')

    for s in screen do
        file:write(s.selected_tag.index, '\n')
    end

    file:close()
end)

awesome.connect_signal('startup',
    function()
        local file = io.open('/tmp/awesomewm-last-selected-tags', 'r')
        if not file then
            return
        end

    local selected_tags = {}

    for line in file:lines() do
        table.insert(selected_tags, tonumber(line))
    end

    for s in screen do
        local i = selected_tags[s.index]
        local t = s.tags[i]
        t:view_only()
    end

    file:close()
end)

