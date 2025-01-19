-- Widget to record
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local notRecordingText = " [ N ]"

local text_widget = wibox.widget {
  text   = notRecordingText,
  align  = "center",
  valign = "center",
  widget = wibox.widget.textbox,
}

local bg_widget = wibox.container.background(text_widget)
--local margin_widget = wibox.container.margin(bg_widget, 10, 10, 10, 10)

-- Variable to track the process
local process = nil

local popup_menu = nil

-- Mark widget
local function markRecording()
  text_widget.text = " [*] "
  text_widget.markup = '<span foreground="#000000"> [ Y ] </span>'
  bg_widget.bg = "#DF5774" -- Red color
end

local function markNotRecording()
  text_widget.text = notRecordingText
  process = nil
  bg_widget.bg = nil
end

local function toggle_command(command)
  if process then
    -- If the process is running, kill it
    process = nil
    awful.spawn.with_shell("killall ffmpeg")
    markNotRecording()
  else
    -- Mark as recording as ffmpeg will keep running we won't get a callback until it is killed, that's why we are stopping the recording
    markRecording()
    process = ""
    awful.spawn.easy_async(command, function(stdout, stderr, reason, exit_code)
      process = nil
      markNotRecording()
    end)
  end
end

local function openDir()
  awful.spawn("xdg-open /tmp")
end

local function show_popup_menu()
  if popup_menu then
    popup_menu:hide()
    popup_menu = nil
    return
  end

  local menu_items = {
    { "First",   function() toggle_command("fish -c 'record first'") end },
    { "Second",  function() toggle_command("fish -c 'record second'") end },
    { "Portion", function() toggle_command("fish -c 'record portion'") end },
  }

  if process then
    menu_items = {
      { "Stop recording", function() toggle_command("") end }
    }
  end

  popup_menu = awful.menu({ items = menu_items })
  popup_menu:show({ keygrabber = true })
end

text_widget:buttons(gears.table.join(
  awful.button({}, 1, function() toggle_command("fish -c 'record first'") end),
  awful.button({}, 2, function() openDir() end),
  awful.button({}, 3, function() show_popup_menu() end)
))

return bg_widget
