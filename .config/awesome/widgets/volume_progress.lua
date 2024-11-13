
local volume_pb_widget = awful.popup {
    widget =  wibox.widget {
        max_value     = 1,
        value         = 0.53,
        forced_height = 20,
        forced_width  = 100,
        shape         = gears.shape.rounded_bar,
        border_width  = 2,
        border_color  = beautiful.border_color,
        widget        = wibox.widget.progressbar,
    },
    border_color = "#999f00",
    border_width = 1,
    placement    = awful.placement.bottom_right,
    shape        = gears.shape.rounded_rect,
    visible      = true,
}

return volume_pb_widget
