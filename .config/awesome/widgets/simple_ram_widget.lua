local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
--local xrdb = require("xrdb")

local htopSP = htopSP
local ramIcon = ramIcon

local ramButtons = gears.table.join(
        awful.button({ }, 2, function()
            if htopSP and htopSP.valid then
                htopSP.minimized = not htopSP.minimized
                client.focus = htopSP
                htopSP:raise()
            else
                awful.spawn.with_shell(terminal .. " --class \"htop\" -e htop")
            end    
        end))

local simple_ram_widget = wibox.widget{
    {
        {
            left   = 5,
            top    = 1.5,
            bottom = 1.5,
            right  = 0,
            widget = wibox.container.margin,
            {
                markup = '<span font=\"Sans 18\" color=\"' .. '#FFFFFF' .. '\"> 󰍛 </span>',
                --font = "Sans 14",
                --image = ramIcon,
                widget = wibox.widget.textbox
                --widget = wibox.widget.imagebox
            },
        },
        {
            widget = awful.widget.watch('bash -c "~/.config/scripts/ram.sh"')
        },
        buttons = ramButtons,
        layout = wibox.layout.fixed.horizontal,
    },
    -- fg = xrdb.foreground,
    --bg = xrdb.background .. "00",
    widget = wibox.container.background,
}

return simple_ram_widget
