local month_calendar = awful.widget.calendar_popup.month( {
    start_sunday = true,
    style_month = {
        border_width = 0,
        bg_color = xrdb.background,
        padding = 4,
    },
    style_focus = {
        markup = function(t) 
            return string.format('<span style="text-align:center">%s</span>', text)
        end,
        border_width = 0,
        fg_color = xrdb.background,
        bg_color = xrdb.foreground,
        shape = gears.shape.circle,
        padding = 2,
    }
}) 

-- Textclock widget
local clockButtons =  gears.table.join( 
        awful.button({ }, 2, function() awful.spawn.with_shell("xdg-open https://calendar.google.com") end),
        awful.button({ }, 3, function() 
            month_calendar:call_calendar (0, "tr", awful.screen.focused())
            month_calendar:toggle() 
        end)
)

local simple_clock_widget = wibox.widget{
    {
        left   = 5,
        top    = 3,
        bottom = 3,
        right  = 0,
        widget = wibox.container.margin,
        {   
            image = clockIcon,
            widget = wibox.widget.imagebox
        },    
    },
    {
        wibox.widget.textclock("%a %b %d, %I:%M %p"),
        left   = 5,
        top    = 2,
        bottom = 2,
        right  = 0,
        widget = wibox.container.margin,
    },
    layout = wibox.layout.fixed.horizontal,
    widget  = wibox.container.background,
    buttons = clockButtons
}

return simple_clock_widget