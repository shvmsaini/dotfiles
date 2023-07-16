-- Volume Widget
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')

-- Net Speed Widget
local net_speed_widget = require("awesome-wm-widgets.net-speed-widget.net-speed")

-- Separator
local separator = wibox.widget.textbox("  ")

-- Ram Widget
local ramIcon = home .. ".local/share/icons/material/white/memory.svg"
local ramButtons = gears.table.join(
        awful.button({ }, 2, function() awful.spawn.with_shell(termexec .. "htop") end))
local ram = wibox.widget{
    {
        left   = 5,
        top    = 1,
        bottom = 1,
        right  = 0,
        widget = wibox.container.margin,
        {   
            image = ramIcon,
            widget = wibox.widget.imagebox
        },    
    },
   
    {
        widget = awful.widget.watch('bash -c "~/.config/scripts/ram.sh"')
    },
    buttons = ramButtons,
    layout = wibox.layout.fixed.horizontal,
}

-- Keyboard map indicator and switcher
-- mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
local clockButtons =  gears.table.join( 
       awful.button({ }, 2, function() awful.spawn.with_shell("firefox https://calendar.google.com") end)
    --    awful.button({ }, 3, function()  month_calendar:toggle()  end) -- Doesn't work
    )

local clock = wibox.widget{
    {
        wibox.widget.textclock(" %a %b %d, %I:%M %p"),
        left   = 5,
        top    = 2,
        bottom = 2,
        right  = 0,
        widget = wibox.container.margin,
    },
    widget  = wibox.container.background,
    buttons = clockButtons
}

-- TODO: Calender Widget
local cal = wibox.widget.calendar.month(os.date('*t'))
local month_calendar = awful.widget.calendar_popup.month() 
month_calendar:attach(clock, "tr", {on_hover = false})

beautiful.systray_icon_spacing = 10

local systray = wibox.widget {
    {
        wibox.widget.systray(),
        left   = 5,
        top    = 2,
        bottom = 2,
        right  = 0,
        widget = wibox.container.margin,
    },
    widget     = wibox.container.background,
}

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 2, function (c) c:kill() end),
                     awful.button({ }, 3, function() awful.menu.client_list({ theme = { width = 250 } }) end),
                     awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
                     awful.button({ }, 5, function () awful.client.focus.byidx(-1) end),
                     awful.button({ modkey }, 1, function (c)
                                c:emit_signal("request::activate", "mouse_click", {raise = true})
                                awful.mouse.client.move(c)
                                end))


local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        awful.spawn.with_shell("feh --bg-fill $(echo \"$(cat ~/.cache/wal/wal)\")")
        --gears.wallpaper.maximized(wall .. "black_hole.jpg", s, false)
        --gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- For screen swapping
     s:connect_signal("swapped", function(self, other, is_source)
        if not is_source then return end

        local st = self.selected_tag
        local sc = st:clients() -- NOTE: this is only here for convinience
        local ot = other.selected_tag
        local oc = ot:clients() -- but this HAS to be saved in a variable because we modify the client list in the process of swapping

        for _, c in ipairs(sc) do
        c:move_to_tag(ot)
        end

        for _, c in ipairs(oc) do
        c:move_to_tag(st)
        end
    end)

    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    if s == screen[1] then
        awful.tag({ " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 " }, s, awful.layout.layouts[1])
    else
        awful.tag({ " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 " }, s, awful.layout.layouts[2])
    end

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    -- s.mylayoutbox = awful.widget.layoutbox(s)
    -- s.mylayoutbox:buttons(gears.table.join(
      --                     awful.button({ }, 1, function () awful.layout.inc( 1) end),
      --                     awful.button({ }, 3, function () awful.layout.inc(-1) end),
        --                   awful.button({ }, 4, function () awful.layout.inc( 1) end),
          --                 awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style = {
            shape_border_width = 1,
            shape_border_color = '#777777',
		    align = "center"
            --shape  = gears.shape.rounded_bar,
        },
        layout   = {
            --spacing = 10,
            spacing_widget = {
                {
                    forced_width = 5,
                    shape        = gears.shape.circle,
                    widget       = wibox.widget.separator
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            layout  = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        margins = 2,
                        widget  = wibox.container.margin,
                    },
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 10,
                right = 10,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 22, opacity = 0.8, })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
     	s.mytasklist, 	 -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- mykeyboardlayout,
            systray,
		    net_speed_widget(),
            ram,
            separator,
            separator,
		    volume_widget{
		  	    widget_type='icon_and_text'
		    },
		    separator,
            clock,
		    separator,
            -- s.mylayoutbox,
        },
    }
end)