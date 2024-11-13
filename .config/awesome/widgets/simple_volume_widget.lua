local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local volumeHighIcon = volumeHighIcon
local volumeMuteIcon = volumeMuteIcon
local volumeLowIcon = volumeLowIcon
local volumeMedIcon = volumeMedIcon

local volume_before_mute = tonumber(0)
local mute = false
local icon = wibox.widget.imagebox()
local volume = wibox.widget.textbox()

local updateUI = function()
    volume:set_text(volume_before_mute)
    --if not volume_before_mute then
    --  volume_before_mute = tonumber(0)
    --end
    if mute or volume_before_mute == 0 then
        icon:set_image(volumeMuteIcon)
    elseif volume_before_mute < 30 then
        icon:set_image(volumeLowIcon)
    elseif volume_before_mute < 70 then
        icon:set_image(volumeMedIcon)
    else
        icon:set_image(volumeHighIcon)
    end
end

local increaseVolume = function()
    if not mute then
        volume_before_mute = math.min(volume_before_mute + 5, 100)
    end

    mute = false

    awful.spawn("amixer set Master " .. volume_before_mute .. "%")

    updateUI()
end

local decreaseVolume = function()
    if not mute then
        volume_before_mute = math.max(volume_before_mute - 5, 0)
    end

    mute = false

    awful.spawn("amixer set Master " .. volume_before_mute .. "%")

    updateUI()
end

local simple_volume_widget_buttons = gears.table.join(
        awful.button({ }, 1, function()
            mute = not mute
            updateUI()
            if not mute then
                awful.spawn("amixer set Master " .. volume_before_mute .. "%")
            else
                volume:set_text("0")
                awful.spawn("amixer set Master 0%")
            end
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
            left   = 4,
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
                text = "100",
                widget = volume,
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
    -- bg = xrdb.background,
    visible = true,
    widget = wibox.container.background,
}

gears.timer {
    timeout   = 3,
    call_now  = true,
    autostart = true,
    callback  = function()
        awful.spawn.easy_async(
            {'bash', '-c', "~/.config/scripts/volume_simple.sh"},
            function(out)
                if not mute then
                  volume_before_mute = tonumber(out)
                  updateUI()
                end
            end
          )
      end
  }


simple_volume_widget:connect_signal("decrease", function()
    decreaseVolume()
end)

simple_volume_widget:connect_signal("increase", function()
    increaseVolume()
end)

return simple_volume_widget
