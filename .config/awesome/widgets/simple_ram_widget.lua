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
                image = ramIcon,
                widget = wibox.widget.imagebox
            },    
        },
        {
            widget = awful.widget.watch('bash -c "~/.config/scripts/ram.sh"')
        },
        buttons = ramButtons,
        layout = wibox.layout.fixed.horizontal,
    },
    -- fg = xrdb.foreground,
    bg = xrdb.background,
    widget = wibox.container.background,
}

return simple_ram_widget