local awful = require("awful")

tag1 = awful.tag.find_by_name(screen[1], "umm..")
tag2 = awful.tag.find_by_name(screen[2], "ok")

if not tag1 and tag2 then

    awful.tag.add("ummm..", {
        screen = 1
    })
    
    awful.tag.add("ok", {
        screen = 2
    })
else
    tag1:delete()
    tag2:delete()
end