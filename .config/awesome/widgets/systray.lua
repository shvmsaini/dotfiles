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

return systray
