local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local xresources = require("beautiful.xresources")
local xrdb = xresources.get_current_theme()
local client = client

awesome.set_preferred_icon_size(64)

-- Create a rounded rectangle shape
local function create_rounded_rect(radius)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, radius)
  end
end

local always_show_apps = {
  { name = "Nemo",   command = "nemo",           icon = "/home/shvmpc/.local/share/icons/Papirus/48x48/categories/nemo.svg" },
  { name = "Studio", command = "android-studio", icon = "/home/shvmpc/.local/share/icons/Papirus/48x48/categories/android-studio.svg" },
  { name = "Mails",  command = "android-studio", icon = "/home/shvmpc/.local/share/icons/Papirus/48x48/categories/betterbird.svg" }
}

local function create_app_button(app)
  local icon_and_name = wibox.layout.fixed.vertical()
  local icon = wibox.widget {
    {
      resize = true,
      align = awful.placement.center,
      forced_height = 50,
      forced_width = 50,
      widget = wibox.widget.imagebox(app.icon)
    },
    bottom = 4,
    left = 4,
    right = 4,
    widget = wibox.container.margin
  }

  icon:buttons(awful.util.table.join(
    awful.button({}, 1, function()
      -- Check if the application is running
      local clients = client.get()
      local is_running = false
      for _, c in ipairs(clients) do
        if c.class == app.name then
          is_running = true
          c:emit_signal("request::activate", "dock", { raise = true })
          break
        end
      end
      -- If not running, launch the application
      if not is_running then
        awful.spawn(app.command)
      end
    end)
  ))

  local name_and_tag_container = wibox.container.background()
  name_and_tag_container.bg = xrdb.foreground
  name_and_tag_container.shape = create_rounded_rect(14)

  local name_label = wibox.widget.textbox()
  name_label:set_font("sans 10")
  name_label.markup = '<span foreground="#000"> ' .. app.name .. " </span>"
  name_label:set_align("center")
  name_and_tag_container:set_widget(name_label)

  icon_and_name:add(icon)
  icon_and_name:add(name_and_tag_container)

  return icon_and_name
end

-- Main Container
local dock = wibox {
  screen = awful.screen.focused(),
  --width = 1,
  height = 80,
  fg = xrdb.foreground,
  bg = xrdb.background,
  ontop = false,
  visible = false,
  type = "dock",
  shape = create_rounded_rect(15),   -- Set the corner radius
}

local dock_layout = wibox.layout.fixed.horizontal()
local margins = wibox.container.margin(dock_layout, 2, 4, 2, 2)
local outer_container = {
  {
    widget = margins
  },
  bg = xrdb.background,
  border_color = xrdb.foreground,
  border_width = 1,
  shape = create_rounded_rect(15),
  widget = wibox.container.background()
}
dock:set_widget(outer_container)

-- Function to update the dock with client buttons
local function update_dock()
  dock_layout:reset()   -- Clear previous widgets

  -- Add always-show applications
  for _, app in ipairs(always_show_apps) do
    local app_button = create_app_button(app)
    local wrapper_margin = wibox.container.margin(app_button, 2, 2, 2, 2)
    dock_layout:add(wrapper_margin)
  end

  -- Running clients
  local clients = client.get()
  if #clients == 0 then
    dock.visible = false
    return
  end
  for _, c in ipairs(clients) do
    local icon_and_name = wibox.layout.fixed.vertical()
    local clientIcon = c.icon
    if not c.icon then
      clientIcon = ramIcon
    end
    local icon = wibox.widget {
      {
        resize = true,
        align = awful.placement.center,
        forced_height = 50,
        forced_width = 50,
        widget = wibox.widget.imagebox(clientIcon)
      },
      bottom = 4,
      left = 4,
      right = 4,
      widget = wibox.container.margin
    }
    icon:buttons(awful.util.table.join(
      awful.button({}, 1, function() c:emit_signal("request::activate", "dock", { raise = true }) end),
      awful.button({}, 2, function() c:kill() end),
      awful.button({}, 3, function()
        local current_tag = awful.screen.focused().selected_tag           -- Get the current tag

        if current_tag then                                               -- Check if the current tag is valid
          local is_on_current_tag = c:tags()[current_tag.index]           -- Check if the client is on the current tag
          local tag_count = #c:tags()                                     -- Get the number of tags the client is on

          if is_on_current_tag then
            if tag_count > 1 then                             -- Only remove from current tag if it's on more than one tag
              c:tags()[current_tag.index] = nil               -- Remove the client from the current tag
            end
          else
            c:tags()[#c:tags() + 1] = current_tag             -- Add the client to the current tag
          end

          c.minimized = false                                                  -- Ensure the client is not minimized
          c:emit_signal("request::activate", "dock", { raise = true })         -- Activate the client
        else
          -- Handle the case where there is no current tag (optional)
          print("No current tag available.")
        end
      end)
    ))

    local name_and_tag_container = wibox.container.background()
    name_and_tag_container.bg = xrdb.foreground
    name_and_tag_container.shape = create_rounded_rect(14)

    local name_label = wibox.widget.textbox()
    name_label:set_font("sans 10")
    name_label.markup = '<span foreground="#000"> ' .. string.sub(c.name, 1, 6) .. ".. </span>"
    name_label:set_align("center")
    name_and_tag_container:set_widget(name_label)

    icon_and_name:add(icon)
    icon_and_name:add(name_and_tag_container)

    -- Add the button to the dock
    local wrapper_margin = wibox.container.margin(icon_and_name, 2, 2, 2, 2)
    dock_layout:add(wrapper_margin)
  end

  local client_count = #clients + #always_show_apps
  dock.width = client_count * 65
  if client_count == 0 then
    outer_container.visible = false
    dock.visible = false
  else
    outer_container.visible = true
    dock.visible = true
  end
  awful.placement.bottom(dock, { margins = { bottom = 0 } })   -- Adjust margins as needed
end

-- Position the dock at the bottom of the screen
dock:geometry({
  --x = (screen.geometry.width - dock_widget.width) / 2,
  x = 1366 + (1920 / 2) - dock.width,
  y = awful.screen.focused().geometry.height - dock.height,
})

-- Function to hide the dock
local function hide_dock()
  dock.ontop = false
end

-- Timer for hiding the dock
local hide_timer = gears.timer {
  timeout = 0.5,
  autostart = true,
  single_shot = true,
  callback = function()
    hide_dock()
  end
}

local delay = gears.timer {
  timeout = 0.2,
  autostart = false,
  single_shot = true,
  callback = function()
    update_dock()
  end
}

-- Function to show the dock
local function show_dock()
  dock.ontop = true
  hide_timer:stop()
end

-- Connect mouse enter and leave events
dock:connect_signal("mouse::enter", function()
  show_dock()
end)

dock:connect_signal("mouse::leave", function()
  hide_timer:start()
end)

-- Update the dock when clients are added or removed
client.connect_signal("manage", function()
  delay:start()
end)

client.connect_signal("unmanage", function()
  delay:start()
end)

-- Update the dock initially
delay:start()
