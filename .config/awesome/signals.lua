local naughty = require("naughty")
local awful = require("awful")
local wibox = require("wibox")
local tags = MY_TAGS
local client = client

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end

  if c.class then
    if c.class == 'fileSP' then
      fileSP = c
    elseif c.class == 'termSP' then
      termSP = c
    elseif c.class == 'calcSP' then
      calcSP = c
    elseif c.class == 'htop' then
      htopSP = c
    elseif c.class == 'code-oss' or c.class == 'Code' then
      -- Set 4th tag layout to max
      local fourth_tag = awful.tag.find_by_name(s, tags[4])
      awful.layout.set(awful.layout.suit.max, fourth_tag)
    elseif c.name == 'Logcat' then
      SPs[1] = c
      c.floating = false
    elseif c.name == 'Running Devices' then
      SP = c
      SP.sticky = true
      SP.ontop = true
    end
  end

  -- Special tag for cyrptomator
  if c.class and c.class == "org.cryptomator.launcher.Cryptomator$MainApp" then
    local focused_screen = awful.screen.focused()
    local mytag = awful.tag.find_by_name(focused_screen, " ")
    if not mytag then
      mytag = awful.tag.add(" ", { layout = awful.layout.suit.tile.left })
    end
    c:move_to_tag(mytag)
    -- Delete tag after cryptomator closes and move existing clients to tag[9]
    c:connect_signal("unmanage", function()
      if mytag then
        local clients = mytag:clients()
        for _, c2 in ipairs(clients) do
          c2:move_to_tag(awful.screen.focused().tags[9])
        end
        mytag:delete()
      end
    end)
  end

  -- Special tag for Logseq
  if c.class and c.class == "Logseq" then
    local focused_screen = awful.screen.focused()
    local mytag = awful.tag.find_by_name(focused_screen, "LOG")
    if not mytag then
      mytag = awful.tag.add("LOG", { layout = awful.layout.suit.tile.left })
    end
    c:move_to_tag(mytag)
    c:connect_signal("unmanage", function()
      if mytag then
        local clients = mytag:clients()
        for _, c2 in ipairs(clients) do
          c2:move_to_tag(awful.screen.focused().tags[9])
        end
        mytag:delete()
      end
    end)
  end
  -- awful.client.movetoscreen(c, mouse.screen)
  -- awful.client.movetoscreen(c, client.focus.screen)
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button({}, 1, function()
      c:emit_signal("request::activate", "titlebar", { raise = true })
      awful.mouse.client.move(c)
    end),
    awful.button({}, 3, function()
      c:emit_signal("request::activate", "titlebar", { raise = true })
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c):setup {
    {     -- Left
      forced_width = 10,
      buttons      = buttons,
      layout       = wibox.layout.fixed.horizontal,
    },
    {     -- Middle
      {
        {
          {
            awful.titlebar.widget.iconwidget(c),
            align  = "right",
            layout = wibox.layout.fixed.horizontal
          },
          top    = 3,
          bottom = 3,
          left   = 3,
          right  = 3,
          widget = wibox.container.margin
        },
        {         -- Title
          widget = awful.titlebar.widget.titlewidget(c)
        },
        layout = wibox.layout.fixed.horizontal
      },
      buttons = buttons,
      widget = wibox.container.place,
    },
    {
      {       -- Right
        -- awful.titlebar.widget.ontopbutton    (c),
        -- awful.titlebar.widget.floatingbutton (c),
        -- awful.titlebar.widget.stickybutton   (c),
        awful.titlebar.widget.minimizebutton(c),
        awful.titlebar.widget.maximizedbutton(c),
        awful.titlebar.widget.closebutton(c),
        align  = "right",
        layout = wibox.layout.fixed.horizontal,
      },
      top    = 3.1,
      bottom = 3.1,
      left   = 3.1,
      right  = 3.1,
      widget = wibox.container.margin
    },
    layout = wibox.layout.align.horizontal
  }
end)

-- Floating
client.connect_signal("property::floating", function(c)
  if c and c.valid and c.floating and not c.fullscreen and not c.maximized then
    if c.class == "Com.github.johnfactotum.Foliate" or
        c.name == "win.*" or
        c.class == "jetbrains-idea-ce" or
        c.class == "CountDown" then
      return
    end
    awful.titlebar.show(c)
  else
    awful.titlebar.hide(c)
  end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", { raise = false })
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

    local file = io.open('/tmp/.awesomewm-last-selected-tags', 'w+')

    for s in screen do
      file:write(s.selected_tag.index, '\n')
    end

    file:close()

    -- Resetting Scratchpad
    if SP and SP.valid then
      SP.sticky = false
      SP.skip_taskbar = false
      SP.floating = false
    end
  end)

awesome.connect_signal('startup',
  function()
    local file = io.open('/tmp/.awesomewm-last-selected-tags', 'r')
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
      if t then
        t:view_only()
      end
    end

    file:close()
  end)
