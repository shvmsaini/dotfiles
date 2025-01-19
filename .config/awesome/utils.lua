local awful = require("awful")
local naughty = require("naughty")

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
  awful.spawn("zen-browser --profile /home/shvmpc/.zen/7eeaixjy/")
  awful.spawn("betterbird")
  awful.spawn("android-studio")
end
