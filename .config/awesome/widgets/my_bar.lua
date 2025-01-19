local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local my_bar = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    style   = {
        shape = gears.shape.powerline
    },
    layout   = {
        spacing = -12,
        spacing_widget = {
            color  = "#dddddd",
            shape  = gears.shape.powerline,
            widget = wibox.widget.separator,
        },
        layout  = wibox.layout.fixed.horizontal
    },
    widget_template = {
        {
            {
                {
                    {
                        {
                            id     = "index_role",
                            widget = wibox.widget.textbox,
                        },
                        margins = 4,
                        widget  = wibox.container.margin,
                    },
                    bg     = "#dddddd",
                    shape  = gears.shape.circle,
                    widget = wibox.container.background,
                },
                {
                    {
                        id     = "icon_role",
                        widget = wibox.widget.imagebox,
                    },
                    margins = 2,
                    widget  = wibox.container.margin,
                },
                {
                    id     = "text_role",
                    widget = wibox.widget.textbox,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            left  = 18,
            right = 18,
            widget = wibox.container.margin
        },
        id     = "background_role",
        widget = wibox.container.background,
        -- Add support for hover colors and an index label
        create_callback = function(self, c3, index, objects) --luacheck: no unused args
            self:get_children_by_id("index_role")[1].markup = "<b> "..c3.index.." </b>"
            self:connect_signal("mouse::enter", function()
                if self.bg ~= "#ff0000" then
                    self.backup     = self.bg
                    self.has_backup = true
                end
                self.bg = "#ff0000"
            end)
            self:connect_signal("mouse::leave", function()
                if self.has_backup then self.bg = self.backup end
            end)
        end,
        update_callback = function(self, c3, index, objects) --luacheck: no unused args
            self:get_children_by_id("index_role")[1].markup = "<b> "..c3.index.." </b>"
        end,
    },
    buttons = taglist_buttons
}

return my_bar
