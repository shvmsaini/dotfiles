local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local volumeHighIcon = volumeHighIcon
local volumeMedIcon = volumeMedIcon
local volumeLowIcon = volumeLowIcon
local volumeMuteIcon = volumeMuteIcon

local current_vol = tonumber(0)
local mute = false
local icon = wibox.widget.imagebox()
local volume = wibox.widget.textbox()

local updateUI = function()
  volume:set_text(current_vol)
  --if not  then
  --  current_vol = tonumber(0)
  --end
  if mute or current_vol == 0 then
    icon:set_image(volumeMuteIcon)
  elseif current_vol < 30 then
    icon:set_image(volumeLowIcon)
  elseif current_vol < 70 then
    icon:set_image(volumeMedIcon)
  else
    icon:set_image(volumeHighIcon)
  end
end
local current_notification = nil

local notifyVolume = function()
  local v = tonumber(current_vol)
  local text = "Volume: " .. v .. "% " .. string.rep("󰹞", v // 4) .. string.rep("󰹟", 100 // 4 - v // 4)
  --local text = "Volume: " .. v .. "% " .. string.rep("󰧟", v//4) .." 󰮯 " .. string.rep("", 25 - v//4)
  current_notification = naughty.notify({
    text = text,
    font = "Hack 13",
    timeout = 2,
    replaces_id = current_notification
  }).id
end

local changeVolume = function(decrease)
  if not mute then
    current_vol = math.max(0, math.min(current_vol + (decrease and -5 or 5), 100))
  end
  notifyVolume()
  mute = false
  awful.spawn("amixer set Master " .. current_vol .. "%")
  updateUI()
end

local simple_volume_widget_buttons = gears.table.join(
  awful.button({}, 1, function()
    mute = not mute
    updateUI()
    if not mute then
      awful.spawn("amixer set Master " .. current_vol .. "%")
    else
      volume:set_text("0")
      awful.spawn("amixer set Master 0%")
    end
  end),
  awful.button({}, 2, function()
    awful.spawn("pavucontrol")
  end),
  awful.button({}, 4, function()
    simple_volume_widget:emit("decrease")
  end),
  awful.button({}, 5, function()
    simple_volume_widget:emit("increase")
  end)
)

local simple_volume_widget = wibox.widget {
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
      { 'bash', '-c', "~/.config/scripts/get_volume.sh" },
      function(out)
        if not mute then
          current_vol = tonumber(out)
          updateUI()
        end
      end
    )
  end
}

simple_volume_widget:connect_signal("decrease", function()
  changeVolume(true)
end)

simple_volume_widget:connect_signal("increase", function()
  changeVolume()
end)


return simple_volume_widget
