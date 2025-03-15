SP = nil
SPs = {}
for i = 1, 12 do
  SPs[i] = nil        -- SP itself
  SPs[i + 12] = false -- SP Property
end
htopSP = nil
fileSP = nil
calcSP = nil
termSP = nil
local SPkeys = nil -- Scratchpad keybinds

local makeSP = function(c, i, m)
  if m then
    if SPs[i] and SPs[i].valid then
      SPs[i].minimized = not SPs[i].minimized
      client.focus = SPs[i]
      SPs[i]:raise()
    else
      if not client.focus then
        return
      end
      notifyMark("Marked", "Marked client on F" .. i)
      SPs[i] = client.focus
      client.focus.sticky = true
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

for i = 1, 12 do
  SPkeys = gears.table.join(SPkeys,
    -- Mark
    awful.key({ modkey }, "F" .. i, function()
      makeSP(c, i, true)
    end, { description = "Mark client as scratchpad w/ F" .. i .. " key", group = "Scratchpad" }),
    -- Unmark
    awful.key({ modkey, "Shift" }, "F" .. i, function()
      makeSP(c, i, nil)
    end, { description = "Unmark client as scratchpad w/ F" .. i .. " key", group = "Scratchpad" })
  )
end

local createTerm = function()
  if termSP and termSP.valid then
    termSP.minimized = not termSP.minimized
    client.focus = termSP
    termSP:raise()
  else
    awful.spawn(terminal ..
    " --class termSP -e fish -c 'fastfetch --kitty $(cat ~/.cache/wal/wal) --logo-preserve-aspect-ratio --logo-width 40 && wait; fish'")
  end
end

return createTerm, makeSP, SPkeys, notifyMark
