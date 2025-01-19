-- Widget to show and change status of microphon<D-F>
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local text_widget = wibox.widget {
    text = " 󱦉 ",
    align  = "center",
    valign = "center",
    widget = wibox.widget.textbox,
}

text_widget.font = "Sans 15"

local bg_widget = wibox.container.background(text_widget)
--local margin_widget = wibox.container.margin(bg_widget, 10, 10, 10, 10)

-- Function to update the microphone status
local function update_mic_status()
    local handle = io.popen("bash ~/.config/scripts/mic_control.sh status")
    if handle then
      local result = handle:read("*a")
      handle:close()
      local text = result:gsub("\n", "")  -- Remove newline character
      --naughty.notify { preset = naughty.config.presets.critical, title = "tet -> " .. text }
      if text == "Muted" then
        text_widget.markup = '<span foreground="#FFFFFF"> 󰍭 </span>'
        --bg_widget.bg = "#DF5774"
      else
        text_widget.markup = '<span foreground="#FFFFFF"> 󰍬 </span>'
        --bg_widget.bg = "#b8e994"
      end
    end
end

-- Function to toggle microphone mute/unmute
local function toggle_mic()
    local handle = io.popen("bash ~/.config/scripts/mic_control.sh toggle")
    if handle then
      handle:close()
    end
    update_mic_status()  -- Update the status after muting
end

-- Update the microphone status initially
gears.timer {
    timeout   = 2,
    call_now  = false,
    autostart = true,
    callback  = function()
        update_mic_status()
    end
}

text_widget:buttons(gears.table.join(
    awful.button({}, 1, function() toggle_mic() end)
))

return bg_widget
