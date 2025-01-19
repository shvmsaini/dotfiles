local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local xresources = require("beautiful.xresources")
local xrdb = xresources.get_current_theme()
local transparency = transparency
if transparency == nil then
  transparency = ""
end
local foreground = xrdb.foreground .. transparency
local background = xrdb.background .. transparency
local text_foreground = xrdb.foreground
local text_background = xrdb.background
local hover = xrdb.color2

local function create_tag_widget(screen)
  local tag_widget = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
  }

  local function update_tag_widget()
    tag_widget:reset() -- Clear existing tags

    for _, tag in ipairs(screen.tags) do
      local bg_container = wibox.container.background()
      local margin_container = wibox.container.margin(2, 2, 2, 2)
      local container = wibox.layout.fixed.horizontal()

      -- Create a tag icon with a textbox for the tag name
      local tag_icon = wibox.widget {
        {
          id = "text",
          widget = wibox.widget.textbox(),
        },
        top = 2, bottom = 2, left = 2, right = 2,
        widget = wibox.container.margin,
      }

      -- Set colors and text based on tag selection
      if tag.selected then
        bg_container.bg = foreground
        bg_container.opacity = 1
        tag_icon:get_children_by_id("text")[1].markup = "<span foreground='" ..
            text_background .. "'><b>" .. tag.name .. "</b></span>"
      else
        bg_container.bg = background
        bg_container.opacity = 0.9
        tag_icon:get_children_by_id("text")[1].markup = "<span foreground='" ..
            text_foreground .. "'>" .. tag.name .. "</span>"
      end

      -- Mouse hover effects
      bg_container:connect_signal("mouse::enter", function()
        if not tag.selected then bg_container.bg = hover .. "99" end
      end)
      bg_container:connect_signal("mouse::leave", function()
        if not tag.selected then bg_container.bg = background end
      end)

      -- Click events for tag navigation
      bg_container:buttons(gears.table.join(
        awful.button({}, 1, function() tag:view_only() end),
        awful.button({}, 4, function() awful.tag.viewnext(tag.screen) end),
        awful.button({}, 5, function() awful.tag.viewprev(tag.screen) end)
      ))

      -- Add the tag icon to the container
      container:add(tag_icon)

      -- Add client icons to the tag
      for _, client in ipairs(tag:clients()) do
        local client_icon = wibox.widget {
          image = client.icon or ramIcon, -- Default icon if none
          resize = true,
          widget = wibox.widget.imagebox,
        }

        -- Click events for client icons
        client_icon:buttons(gears.table.join(
          awful.button({}, 1, function() client:activate({ context = "tasklist", raise = true }) end),
          awful.button({}, 2, function() client:kill() end),
          awful.button({}, 3, function()
            local current_tag = awful.screen.focused().selected_tag
            if client and #client:tags() > 1 then
              for _, ctag in ipairs(client:tags()) do
                if ctag == current_tag then
                  client:toggle_tag(current_tag)
                  return
                end
              end
            end
            client:toggle_tag(current_tag)
          end)
        ))

        local margin_container1 = wibox.container.margin(client_icon, 2, 2, 2, 2)
        container:add(margin_container1)
      end

      margin_container:set_widget(container)
      bg_container:set_widget(margin_container)
      tag_widget:add(bg_container)
    end
  end

  -- Connect signals to update the widget
  tag.connect_signal("tag::history::update", update_tag_widget)
  --screen.connect_signal("tag::history::update", update_tag_widget)
  tag.connect_signal("property::selected", update_tag_widget)
  tag.connect_signal("property::name", update_tag_widget)
  client.connect_signal("tagged", update_tag_widget)
  client.connect_signal("untagged", update_tag_widget)

  return tag_widget
end

return create_tag_widget
