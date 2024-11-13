local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local xresources = require("beautiful.xresources")
local xrdb = xresources.get_current_theme()

-- Path to the file
local file_path = os.getenv("HOME") .. "/.config/awesome/text_box_content.txt"

-- Function to read the file content
local function read_file()
    local file = io.open(file_path, "r")
    if file then
        local content = file:read("*all")
        file:close()
        return content or ""
    end
    return ""
end

-- Function to write content to the file
local function write_file(content)
    local file = io.open(file_path, "w")
    if file then
        file:write(content)
        file:close()
        naughty.notify({ text = "File saved!", timeout = 2 })
    else
        naughty.notify({ text = "Failed to save file!", timeout = 2 })
    end
end

-- Create a textbox widget
local textbox = wibox.widget {
    text = read_file(),
    widget = wibox.widget.textbox,
    forced_width = 300,
    forced_height = 200,
    shape = gears.shape.rounded_rect,
}

-- Create a wibox to hold the textbox
local my_wibox = wibox {
    screen = 2,
    width = 300,
    height = 200,
    visible = true,
    ontop = false,
    bg = xrdb.background,
    shape = gears.shape.rounded_rect,
}

-- Set the position of the wibox
my_wibox:setup {
    textbox,
    layout = wibox.layout.align.vertical,
}

-- Position the wibox below the wibar
awful.placement.top_right(my_wibox, { margins = { top = 30, right = 10 } })

-- Connect a signal to save the content when the textbox is edited
textbox:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then  -- Left mouse button
        awful.prompt.run {
            prompt = "Edit file: ",
            textbox = textbox,
            exe_callback = function(input)
                textbox.text = input
                write_file(input)
            end,
            history_path = awful.util.get_cache_dir() .. "/history_file.txt",
        }
    end
end)

-- Load the initial content
textbox.text = read_file()

