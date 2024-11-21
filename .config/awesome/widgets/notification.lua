local naughty = require("naughty")
local notification = require("naughty.notification")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local tags = MY_TAGS
local client = client

local my_button = wibox.widget {
  {
    {
      text = "Dismiss",
      widget = wibox.widget.textbox
    },
    top = 10, bottom = 10, left = 10, right = 10,
    widget = wibox.container.margin
  },
  bg = '#4C566A', -- basic
  --bg = '#12670000', --tranparent
  shape_border_width = 2,
  shape_border_color = '#4C566A', -- outline
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 2)
  end,
  widget = wibox.container.background
}

my_button:connect_signal("button::press", function(c)
  naughty.destroy_all_notifications(nil, 1)
end)

local noti_buttons = gears.table.join(
  awful.button({}, 3, function(n)
    if n then
      --n:destroy("dismissed_by_user")
    end
    naughty.destroy_all_notifications(nil, 1)
  end))


naughty.connect_signal("request::display", function(n)
  n.timeout = n.timeout
  -- if not n.timeout then
  -- 	n.timeout = 5
  -- end
  --   if not n.app_icon then
  --     n.app_icon = beautiful.notification_icon
  --   end

  --   n.title = "<span font='" .. beautiful.font_name .. "10'><b>" .. n.title .. "</b></span>"

  --   local time = os.date "%H:%M"

  naughty.layout.box {
    notification = n,
    type = "notification",
    widget_template = {
      {
        {
          {
            {
              {
                naughty.widget.icon,
                {
                  naughty.widget.title,
                  naughty.widget.message,
                  spacing = 4,
                  layout = wibox.layout.fixed.vertical,
                },
                fill_space = true,
                spacing = 10,
                layout = wibox.layout.fixed.horizontal,
              },
              naughty.list.actions,
              -- spacing = 10,
              layout = wibox.layout.fixed.vertical,
            },
            margins = 10,
            -- bottom = 10,
            widget = wibox.container.margin,
          },
          id = "background_role",
          widget = naughty.container.background,
        },
        buttons = noti_buttons,
        --{
        --  widget = my_button
        --},
        layout = wibox.layout.fixed.vertical

        -- layout = wibox.layout.horizontal,
      },
      strategy = "max",
      width = 600,
      widget = wibox.container.constraint,
    },
  }
end)
