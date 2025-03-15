local awful = require("awful")
local naughty = require("naughty")
local xresources = require("beautiful.xresources")
local xrdb = xresources.get_current_theme()
htopSP = nil
fileSP = nil
calcSP = nil
termSP = nil
SP = nil
SPs = {}
for i = 1, 12 do
  SPs[i] = nil        -- SP itself
  SPs[i + 12] = false -- SP Property
end


-- Function to check if a client is running
run_or_raise = function(title, cmd)
  local notification

  for _, c in ipairs(client.get()) do
    if c.class == title then
      c:emit_signal("request::activate", "utils", { raise = true })
      return
    end
  end

  notification = naughty.notify({
    title = title .. " started",
    text = title .. " is now running.",
    timeout = 0,
  })

  awful.spawn.with_shell(cmd)

  -- Dismiss the notification when the client is managed
  client.connect_signal("manage", function(c)
    if c.class == title then
      naughty.destroy(notification)
    end
  end)
end

run_work_workspace = function()
  awful.spawn("zen-browser --profile /home/shvmpc/.zen/7eeaixjy.Default Profile/")
  awful.spawn("betterbird")
  awful.spawn("android-studio")
end

notifyMark = function(title, text)
  local icon = nil
  if title == "Marked" then
    icon = "/usr/share/icons/breeze/actions/32/bookmarks-bookmarked.svg"
  else
    icon = "/usr/share/icons/breeze/actions/32/bookmarks.svg"
  end
  naughty.notify({
    title = title,
    text = text,
    timeout = 1,
    icon = icon,
    bg = xrdb.foreground,
    fg = xrdb.background,
    position = "bottom_middle",
    border_width = 1,
    border_color = xrdb.background
  })
end

makeSP = function(c, i, m)
  c = client
  if m then
    if SPs[i] and SPs[i].valid then
      SPs[i].minimized = not SPs[i].minimized
      c.focus = SPs[i]
      SPs[i]:raise()
    else
      if not c.focus then
        return
      end
      notifyMark("Marked", "Marked client on F" .. i)
      SPs[i] = c.focus
      c.focus.sticky = true
      SPs[i].sticky = true
      if not SPs[i].floating then
        SPs[i + 12] = false
        SPs[i].floating = true
        SPs[i].width = 1100
        SPs[i].height = 800
        SPs[i].placement = awful.placement.centered(client.focus)
      else
        SPs[i + 4] = true
      end
      SPs[i].ontop = true
      SPs[i].skip_taskbar = true
      -- SPs[i].placement = function(...)
      --     return awful.placement.centered(...)
      -- end
      -- SPs[i]:geometry({width = 900, height = 900})
    end
  else
    if SPs[i] and SPs[i].valid then
      notifyMark("Unmarked", "Unmarked client on F" .. i)
      SPs[i].sticky = false
      SPs[i].skip_taskbar = false
      if SPs[i + 12] == true then
        SPs[i].floating = true
      else
        SPs[i].floating = false
      end
      SPs[i].ontop = false
    end
    SPs[i] = nil
  end
end
