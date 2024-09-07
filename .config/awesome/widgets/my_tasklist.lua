local awful = require("awful")
local wibox = require("wibox")
local gear = require("gears")
local beautiful = require("beautiful")

local mytasklist = wibox.widget {
    widget = wibox.container.margin,
    margins = 5,
    layout = wibox.layout.fixed.vertical,
}

local function update_tasklist()
    mytasklist:clear()

    for _, c in ipairs(client.get()) do
        local task = wibox.widget {
            widget = wibox.container.margin,
            margins = 4,
            layout = wibox.layout.fixed.horizontal,
        }

        local icon = wibox.widget.imagebox {
            image = c.icon,
            resize = "fill",
            width = 16,
            height = 16,
        }

        local label = wibox.widget.textbox {
            text = c.name,
            align = "left",
            valign = "center",
        }

        task:add(icon)
        task:add(label)

        task:buttons(awful.button({ }, 1, function()
            c:activate()
            c:raise()
        end))

        mytasklist:add(task)
    end
end

client.connect_signal("manage", function(c)
    update_tasklist()
end)

client.connect_signal("unmanage", function(c)
    update_tasklist()
end)

return mytasklist
