-- Volume Widget
-- need to make this non global and return it to local
local volume_before_mute = 0
local volume_widget, volume_timer = awful.widget.watch('bash -c "~/.config/scripts/volume_simple.sh"', 15)
local mute = false
local icon = wibox.widget.imagebox()
icon:set_image(volumeHighIcon)

local changeIcon = function() 
    if mute or volume_before_mute == 0 then
        icon:set_image(volumeMuteIcon)
    elseif volume_before_mute < 30 then
        icon:set_image(volumeLowIcon)
    elseif volume_before_mute < 70 then
        icon:set_image(volumeMedIcon)
    else
        icon:set_image(volumeHighIcon)
    end
    volume_timer:emit_signal("timeout")
end

local increaseVolume = function()
    if mute then 
        awful.spawn("amixer set Master " .. volume_before_mute .. "%")
        mute = false
        changeIcon()
        return
    end

    if not volume_before_mute then 
        volume_before_mute = 0
    end

    volume_before_mute = volume_before_mute + 5
    if volume_before_mute > 100 then
        volume_before_mute = 100
    end
    awful.spawn("amixer set Master 5%+")
    volume_timer:emit_signal("timeout")
    changeIcon()
end

local decreaseVolume = function()
    if mute then 
        awful.spawn("amixer set Master " .. volume_before_mute .. "%")
        mute = false
        changeIcon()
        return
    end

    if not volume_before_mute then 
        volume_before_mute = 0
    end
    volume_before_mute = volume_before_mute - 5
    if volume_before_mute < 0 then
        volume_before_mute = 0
    end
    awful.spawn("amixer set Master 5%-")
    volume_timer:emit_signal("timeout")
    changeIcon()
end

local simple_volume_widget_buttons = gears.table.join(
        awful.button({ }, 1, function()
            if mute then
                awful.spawn("amixer set Master " .. volume_before_mute .. "%")
            else 
                -- awful.spawn("amixer set Master mute")
                awful.spawn("amixer set Master 0%")
            end
            mute = not mute
           changeIcon()
        end), 
        awful.button({ }, 2, function()
            awful.spawn("pavucontrol")
        end), 
        awful.button({ }, 4, function()
            increaseVolume()            
        end), 
        awful.button({ }, 5, function()
            decreaseVolume()            
        end)
    )

local simple_volume_widget = wibox.widget{
    {
        {
            left   = 5,
            top    = 2.5,
            bottom = 2.5,
            right  = 2,
            widget = wibox.container.margin,
            {   
                widget = icon
            },    
        },
        {
            {
                widget = volume_widget,
            },
            {
                text = "%",
                widget = wibox.widget.textbox
            },
            layout = wibox.layout.fixed.horizontal
        },
        buttons = simple_volume_widget_buttons,
        layout = wibox.layout.fixed.horizontal,
    },
    -- fg = xrdb.foreground,
  --  bg = xrdb.background,
    widget = wibox.container.background,
}

simple_volume_widget:connect_signal("decrease", function()
    decreaseVolume()
end) 

simple_volume_widget:connect_signal("increase", function()
    increaseVolume()
end) 

awful.spawn.easy_async({'bash', '-c', "~/.config/scripts/volume_simple.sh"}, function(stdout)
        if stdout then
            volume_before_mute = tonumber(stdout)
            changeIcon()
        end
    end)

return simple_volume_widget
