local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

-- Volume Widget
simple_volume_widget = require("widgets/simple_volume_widget")

-- taglist
local function taglist_with_icons(s)
  -- Taglist with custom update function
  local taglist = awful.widget.taglist {
    screen = s,
    filter = awful.widget.taglist.filter.all,
    update_function = function(tags)
      local items = {}
      local current_tag = awful.tag.getselected(s)
      -- Add current tag name
      items[#items + 1] = {
        text = current_tag.name,
        fg = s.theme.taglist_fg_focus,
        buttons = awful.util.table.join(
          awful.button({ }, awful.tag.viewtoggle, current_tag)
        )
      }
      -- Add application icons for current tag
      for _, client in ipairs(awful.client.getclients(current_tag)) do
        items[#items + 1] = {
          widget = wibox.widget.image {
            image = client.icon,
            fg = s.theme.taglist_fg_occupied,
            click_action = function()
              client.focus()
            end
          },
          buttons = awful.util.table.join(
            awful.button({ }, awful.client.focus, client, { action = true })
          )
        }
      end
      return items
    end,
    layout = wibox.layout.fixed.horizontal,
  }
  return taglist
end

-- -- volume progress bar
-- volume_progress = awful.popup {
--     widget =  wibox.widget {
--         max_value     = 1,
--         value         = 0.33,
--         forced_height = 20,
--         forced_width  = 100,
--         shape         = gears.shape.rounded_bar,
--         border_width  = 2,
--         border_color  = beautiful.border_color,
--         widget        = wibox.widget.progressbar,
--     },
--     border_color = "#00ff00",
--     border_width = 5,
--     placement    = awful.placement.top_left,
--     shape        = gears.shape.rounded_rect,
--     visible      = true,
-- }

-- Net Speed Widget
local net_speed_widget = require("awesome-wm-widgets.net-speed-widget.net-speed")

-- Separator
local separator = wibox.widget.textbox("  ")

-- Ram Widget
local simple_ram_widget = require("widgets/simple_ram_widget")

-- Keyboard map indicator and switcher
-- mykeyboardlayout = awful.widget.keyboardlayout()

-- Calender Widget
local simple_clock_widget = require("widgets/simple_clock_widget")


-- System tray widget
local systray = wibox.widget {
    {
        wibox.widget.systray(),
        left   = 5,
        top    = 2,
        bottom = 2,
        right  = 5,
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
	   -- awful.spawn.with_shell("~/.config/awesome/scripts/pywal.sh -f")
        -- awful.spawn.with_shell("feh --bg-fill $(echo \"$(cat ~/.cache/wal/wal)\")")
        --gears.wallpaper.maximized(wall .. "black_hole.jpg", s, false)
        -- gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- For screen swapping
     s:connect_signal("swapped", function(self, other, is_source)
        if not is_source then return end

        local st = self.selected_tag
        local sc = st:clients() -- NOTE: this is only here for convenience
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
        -- Create the wibox
        s.mywibox = awful.wibar({ position = "top", screen = s, height = 23, opacity = 0.8})
        tags = { " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " >_< "}
        awful.tag(tags, s, awful.layout.layouts[2])
    else
        -- Create the wibox
        --s.mywibox = awful.wibar({ position = "top", screen = s, height = 23, opacity = 1, bg = xrdb.background .. "00", fg = xrdb.foreground})
        s.mywibox = awful.wibar({ position = "top", screen = s, height = 23, opacity = 0.8}) --, bg = xrdb.background .. "00", fg = xrdb.foreground})
        if herbstMode then
            tags2 = {" 9 "}
        else
            tags2 = tags
        end
        awful.tag(tags2, s, awful.layout.layouts[1])
    end

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt{
        prompt = "~>: ",
        with_shell = true
    }

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
    }

    --s.mytasklist = awful.widget.tasklist {
    --screen   = s,
    --filter   = awful.widget.tasklist.filter.currenttags,
    --buttons  = tasklist_buttons,
    --style    = {
    --    shape_border_width = 1,
    --    shape_border_color = '#777777',
    --    shape  = gears.shape.rounded_bar,
    --},
    --layout   = {
    --    spacing = 10,
    --    spacing_widget = {
    --        {
    --            forced_width = 5,
    --            shape        = gears.shape.circle,
    --            widget       = wibox.widget.separator
    --        },
    --        valign = 'center',
    --        halign = 'center',
    --        widget = wibox.container.place,
    --    },
    --    layout  = wibox.layout.flex.horizontal
    --},
    ---- Notice that there is *NO* wibox.wibox prefix, it is a template,
    ---- not a widget instance.
    --widget_template = {
    --    {
    --        {
    --            {
    --                {
    --                    id     = 'icon_role',
    --                    widget = wibox.widget.imagebox,
    --                },
    --                margins = 2,
    --                widget  = wibox.container.margin,
    --            },
    --            {
    --                id     = 'text_role',
    --                widget = wibox.widget.textbox,
    --            },
    --            layout = wibox.layout.fixed.horizontal,
    --        },
    --        left  = 10,
    --        right = 10,
    --        widget = wibox.container.margin
    --    },
    --    id     = 'background_role',
    --    widget = wibox.container.background,
    --  },
    --}


    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        -- style = {
        --     shape_border_width = 1,
        --     shape_border_color = '#777777',
		--     align = "center"
        --     --shape  = gears.shape.rounded_bar,
        -- },
        -- layout = {
        --     --spacing = 10,
        --     spacing_widget = {
        --         {
        --             forced_width = 5,
        --             shape        = gears.shape.circle,
        --             widget       = wibox.widget.separator
        --         },
        --         valign = 'center',
        --         halign = 'center',
        --         widget = wibox.container.place,
        --     },
        --     layout  = wibox.layout.flex.horizontal
        -- },
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
                    -- expand = "outside",
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 10,
                right = 10,
                widget = wibox.container.place,
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
    }

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            separator,
            s.mytaglist,
            s.mypromptbox,
        },
        -- { -- Middle widget
            s.mytasklist,
        --     align = "center",
        --     expand = "outside",
        --     layout = wibox.layout.align.horizontal,
        -- },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- mykeyboardlayout,
            systray,
            net_speed_widget(),
            --taglist_with_icons,
            simple_ram_widget,
            separator,
            separator,
            simple_volume_widget,
		    -- volume_widget{
		  	--     widget_type='icon_and_text'
		    -- },
		    separator,
            simple_clock_widget,
		    separator,
            -- s.mylayoutbox,
        },
    }
end)
