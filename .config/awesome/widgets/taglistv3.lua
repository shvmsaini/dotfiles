local awful = require("awful")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local xrdb = xresources.get_current_theme()

local function create_tag_widget(screen)
  local tag_widget = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
  }

  local function update_tag_widget()
    -- Clear the existing tag widget
    tag_widget:reset()

    -- Iterate through all tags
    for _, tag in ipairs(screen.tags) do
      local bg_container = wibox.container.background()
      local margin_container = wibox.container.margin(2, 2, 2, 2)
      local container = wibox.layout.fixed.horizontal()

      local tag_icon = wibox.widget {
        {
          {
            id = "text",
            widget = wibox.widget.textbox(),
          },
          layout = wibox.layout.fixed.horizontal,
        },
        top = 2,
        bottom = 2,
        left = 2,
        right = 2,
        widget = wibox.container.margin,
        buttons = gears.table.join(awful.button({}, 3, function()
          awful.tag.viewtoggle(tag)
        end))
      }
      if tag.selected then
        bg_container.bg = xrdb.foreground
        tag_icon:get_children_by_id("text")[1].markup = "<span foreground='" ..
            xrdb.background .. "'><b>" .. tag.name .. "</b></span>"
      else
        bg_container.bg = xrdb.background
        tag_icon:get_children_by_id("text")[1].markup = "<span foreground='" ..
            xrdb.foreground .. "'>" .. tag.name .. "</span>"
      end
      bg_container:connect_signal("mouse::enter", function()
        if not tag.selected then
          bg_container.bg = xrdb.color2 .. "80"
        end
      end)
      bg_container:connect_signal("mouse::leave", function()
        if not tag.selected then
          bg_container.bg = xrdb.background
        end
      end)

      -- Add the tag widget to the layout
      container:add(tag_icon)

      -- Add a click event to switch to the tag when clicked
      bg_container:buttons(awful.util.table.join(
        awful.button({}, 1, function()
          tag:view_only()
        end)
      ))

      --add_icons(tag, tag_icon.get_children_by_id("icons")[1])
      -- Inside the for loop where you iterate over clients in the tag
      for _, c in ipairs(tag:clients()) do
        local margin_container1 = wibox.container.margin(2, 2, 2, 2)

        -- Create the client icon
        local client_icon = wibox.widget {
          image = c.icon or ramIcon, -- Use a default icon if none is available
          resize = true,
          widget = wibox.widget.imagebox,
        }

        -- Create a line to indicate the active client
        local active_line = wibox.widget {
          forced_height = 2,
          background_color = "#FF0000", -- Set the color of the line
          widget = wibox.container.background,
        }

        -- Create a container to hold the client icon and the line
        local client_container = wibox.layout.fixed.vertical()
        client_container:add(active_line) -- Add the line first
        client_container:add(client_icon) -- Add the client icon below the line

        -- Check if the client is active and show the line if it is
        if c == client.focus then
          active_line.visible = true
        else
          active_line.visible = false
        end

        -- Add a click event to focus the client when clicked
        client_icon:buttons(awful.util.table.join(
          awful.button({}, 1, function()
            c:activate({ context = "tasklist", raise = true }) -- Activate and raise the client
          end),
          awful.button({}, 2, function()
            c:kill()
          end),
          awful.button({}, 3, function()
            local current_tag = awful.screen.focused().selected_tag
            if c and #c.tags > 1 then
              if current_tag then
                for _, ctag in ipairs(c.tags) do
                  if ctag == current_tag then
                    c:toggle_tag(current_tag)
                    return
                  end
                end
              end
            end
            if c and c.first_tag == awful.screen.focused().selected_tag then
              -- The client is in current tag, minimize it
              c.minimized = not c.minimized
              return
            end
            if c and c.first_tag then
              c:toggle_tag(awful.screen.focused().selected_tag)
            end
          end)
        ))

        -- Add the client container to the margin container
        margin_container1:set_widget(client_container)
        container:add(margin_container1)
      end

      margin_container:set_widget(container)
      bg_container:set_widget(margin_container)
      tag_widget:add(bg_container)
    end
  end

  -- Connect signals to update the tag widget when clients are added or removed
  --client.connect_signal("manage", update_tag_widget)
  --client.connect_signal("unmanage", update_tag_widget)
  tag.connect_signal("property::selected", update_tag_widget)
  tag.connect_signal("property::name", update_tag_widget)
  tag.connect_signal("tag::history::update", update_tag_widget)
  client.connect_signal("tagged", update_tag_widget)
  client.connect_signal("untagged", update_tag_widget)

  return tag_widget
end

return create_tag_widget
