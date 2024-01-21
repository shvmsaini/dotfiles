-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    if c.class then
        if c.class == 'fileSP' then
            fileSP = c
        elseif c.class == 'termSP' then
            termSP = c
        elseif c.class == 'calcSP' then
            calcSP = c
        elseif c.class == 'htop' then
            htopSP = c
        elseif c.class == 'code-oss' or c.class == 'Code' then
            -- Set 4th tag layout to max
            local fourth_tag = awful.tag.find_by_name(s, tags[4])
            awful.layout.set(awful.layout.suit.max, fourth_tag)
		elseif c.name == 'Logcat' then
			SPs[1] = c
		elseif c.name == 'Running Devices' then
			SP = c
        end
    end

    -- Special tag for cyrptomator
    if c.class and c.class == "org.cryptomator.launcher.Cryptomator$MainApp" then
        local focused_screen = awful.screen.focused()
        local mytag = awful.tag.find_by_name(focused_screen, " ")
        if not mytag then
            mytag = awful.tag.add(" ", {layout = awful.layout.suit.tile.left})
        end
        c:move_to_tag(mytag)
        -- Delete tag after cryptomator closes and move existing clients to tag[9]
        c:connect_signal("unmanage", function()
            if mytag then
                local clients = mytag:clients()
                for _, c2 in ipairs(clients) do
                    c2:move_to_tag(awful.screen.focused().tags[9])
                end
                mytag:delete()
            end
        end)
    end

    -- Special tag for Logseq
    if c.class and c.class == "Logseq" then
        local focused_screen = awful.screen.focused()
        local mytag = awful.tag.find_by_name(focused_screen, "LOG")
        if not mytag then
            mytag = awful.tag.add("LOG", {layout = awful.layout.suit.tile.left})
        end
        c:move_to_tag(mytag)
        c:connect_signal("unmanage", function()
            if mytag then
                local clients = mytag:clients()
                for _, c2 in ipairs(clients) do
                    c2:move_to_tag(awful.screen.focused().tags[9])
                end
                mytag:delete()
            end
        end)
    end
    -- awful.client.movetoscreen(c, mouse.screen)
    -- awful.client.movetoscreen(c, client.focus.screen)
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            forced_width = 10,
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal,
        },
        { -- Middle
            {  
                {
                    {
                        awful.titlebar.widget.iconwidget(c),
                        align   = "right",
                        layout  = wibox.layout.fixed.horizontal
                    },
                    top     = 3,
                    bottom  = 3,
                    left    = 3,
                    right   = 3,
                    widget = wibox.container.margin
                },
                { -- Title
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                layout  = wibox.layout.fixed.horizontal
            },
            buttons = buttons,
            widget = wibox.container.place,
        },
        {
            { -- Right
                -- awful.titlebar.widget.ontopbutton    (c),
                -- awful.titlebar.widget.floatingbutton (c),
                -- awful.titlebar.widget.stickybutton   (c),
                awful.titlebar.widget.minimizebutton (c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.closebutton    (c),
                align   = "right",
                layout  = wibox.layout.fixed.horizontal,
            },
            top     = 3.1,
            bottom  = 3.1,
            left    = 3.1,
            right   = 3.1,
            widget = wibox.container.margin
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Floating
client.connect_signal("property::floating", function(c)
    if c and c.valid and c.floating and not c.fullscreen and not c.maximized then
        if c.class == "Com.github.johnfactotum.Foliate" or 
            c.name == "win.*" or 
            c.class == "jetbrains-idea-ce" or
			c.class == "CountDown" then
            return
        end
        awful.titlebar.show(c) 
    else 
        awful.titlebar.hide(c) 
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Focus urgent clients automatically
client.connect_signal("property::urgent", function(c)
    c.minimized = false
    c:jump_to()
end)

-- Preserve tags on restart
awesome.connect_signal('exit', 
    function(reason_restart)
        if not reason_restart then
            return
        end

    local file = io.open('/tmp/.awesomewm-last-selected-tags', 'w+')

    for s in screen do
        file:write(s.selected_tag.index, '\n')
    end

    file:close()
    
    -- Resetting Scratchpad
    if SP and SP.valid then
        SP.sticky = false
        SP.skip_taskbar = false
        SP.floating = false
    end
end)

awesome.connect_signal('startup',
    function()
        local file = io.open('/tmp/.awesomewm-last-selected-tags', 'r')
        if not file then
            return
        end

    local selected_tags = {}

    for line in file:lines() do
        table.insert(selected_tags, tonumber(line))
    end

    for s in screen do
        local i = selected_tags[s.index]
        local t = s.tags[i]
        if t then
            t:view_only()
        end
    end

    file:close()
end)

-- Notifications
-- naughty.connect_signal("request::display", function(n)
--     naughty.layout.box {
-- 		notification = n,
-- 		type = "notification",
-- 		bg = "#4343434",
--         buttons = gears.table.join(
--             awful.button({ }, 2, function()
--                 naughty.notify { preset = naughty.config.presets.critical, title = "could not get other screen" }
--                 -- n:destroy_all_notifications(nil, -1)
--             end)),
--         -- widget_template = {
        --     {
        --         {
        --             naughty.widget.title,
        --             forced_height = dpi(20),
        --             layout = wibox.layout.align.horizontal
        --         },
        --         left = dpi(15),
        --         right = dpi(15),
        --         top = dpi(10),
        --         bottom = dpi(10),
        --         widget = wibox.container.margin
        --     },
        --     bg = color.background_dark,
        --     widget = wibox.container.background
        -- }
		-- widget_template = {
		-- 	{
		-- 		{
		-- 			{
		-- 				{
		-- 					{
		-- 						{
		-- 							naughty.widget.title,
		-- 							font = "Ubuntu Nerd Font Bold 14",
		-- 							forced_height = dpi(20),
		-- 							layout = wibox.layout.align.horizontal
		-- 						},
		-- 						left = dpi(15),
		-- 						right = dpi(15),
		-- 						top = dpi(10),
		-- 						bottom = dpi(10),
		-- 						widget = wibox.container.margin
		-- 					},
		-- 					bg = color.background_dark,
		-- 					widget = wibox.container.background
		-- 				},
		-- 				strategy = "min",
		-- 				width = dpi(300),
		-- 				widget = wibox.container.constraint
		-- 			},
		-- 			strategy = "max",
		-- 			width = dpi(400),
		-- 			widget = wibox.container.constraint
		-- 		},
		-- 		{
		-- 			{
		-- 				{
		-- 					{
		-- 						resize_strategy = 'center',
		-- 						widget = naughty.widget.icon or
		-- 							os.getenv("HOME") .. '/.config/awesome/deco/icons/notif.png'
		-- 					},
		-- 					margins       = beautiful.notification_margin,
		-- 					widget        = wibox.container.margin,
		-- 					forced_height = dpi(70),
		-- 					forced_width  = dpi(100),
		-- 					top           = dpi(10),
		-- 					bottom        = dpi(10),
		-- 					left          = dpi(15),
		-- 					right         = dpi(10)
		-- 				},
		-- 				widget = wibox.container.background,
		-- 				bg = color.background_lighter

		-- 			},
		-- 			{
		-- 				{
		-- 					{
		-- 						naughty.widget.message,
		-- 						left = dpi(15),
		-- 						right = dpi(15),
		-- 						top = dpi(10),
		-- 						bottom = dpi(10),
		-- 						widget = wibox.container.margin
		-- 					},
		-- 					strategy = "min",
		-- 					height = dpi(60),
		-- 					widget = wibox.container.constraint
		-- 				},
		-- 				strategy = "max",
		-- 				width = dpi(400),
		-- 				widget = wibox.container.constraint
		-- 			},
		-- 			layout = wibox.layout.align.horizontal
		-- 		},
		-- 		{
		-- 			actions_template,
		-- 			widget = wibox.container.margin,
		-- 			top = 0,
		-- 			bottom = 5,
		-- 			left = 10,
		-- 			right = 10
		-- 		},
		-- 		layout = wibox.layout.align.vertical
		-- 	},
		-- 	id = "background_role",
		-- 	widget = naughty.container.background,
		-- 	bg = color.background_lighter
		-- }
-- 	}

-- end)
-- naughty.connect_signal("request::display", function (n)
	-- Main container of the notification
	-- local container = wibox.widget{
	-- 	spacing = beautiful.notification_margin,
	-- 	layout = wibox.layout.fixed.vertical
	-- }

	-- local icon = wibox.widget{
	-- 	resize_strategy = "scale",
	-- 	widget = naughty.widget.icon
	-- }

	-- local app_icon = function ()
	-- 	local widget = {}

	-- 	if not n.app_icon == nil  or not n.app_icon == '' then
	-- 		widget = wibox.widget{
	-- 			image = n.app_icon,
	-- 			resize = true,
	-- 			forced_height = dpi(16),
	-- 			forced_width = dpi(16),
	-- 			widget = wibox.widget.imagebox
	-- 		}
	-- 	elseif not n.image == nil or not n.image == '' then
	-- 		widget = wibox.widget{
	-- 			image = n.image,
	-- 			resize = true,
	-- 			forced_height = dpi(16),
	-- 			forced_width = dpi(16),
	-- 			widget = wibox.widget.imagebox
	-- 		}

	-- 	else
	-- 		widget = nil
	-- 	end

	-- 	return widget
	-- end


	-- local dismiss_button = wibox.widget{
	-- 	{
	-- 		{
	-- 			{
	-- 				image = beautiful.icon_times,
	-- 				resize = true,
	-- 				forced_height = dpi(16),
	-- 				forced_width = dpi(16),
	-- 				widget = wibox.widget.imagebox
	-- 			},
	-- 			margins = dpi(1),
	-- 			widget = wibox.container.margin
	-- 		},
	-- 		bg = beautiful.bg_button,
	-- 		border_width = beautiful.btn_border_width,
	-- 		border_color = beautiful.border_button,
	-- 		shape =  gears.shape.circle,
	-- 		widget = wibox.container.background
	-- 	},
	-- 	widget = clickable_container
	-- }

	-- dismiss_button:connect_signal("button::press", function (_,_,_,button)
	-- 	if button == 1 then
	-- 		n:destroy(nil, 1)
	-- 	end
	-- end)

	-- local app_name = wibox.widget{
	-- 	markup = n.app_name or "System Notification",
	-- 	font = "Ubuntu Bold 10",
	-- 	align = 'center',
	-- 	valign = 'center',
	-- 	widget = wibox.widget.textbox
	-- }

	-- local app_icon_with_name_and_dismiss_btn = wibox.widget{
	-- 	{
	-- 		app_icon(),
	-- 		app_name,
	-- 		spacing = beautiful.notification_margin,
	-- 		layout = wibox.layout.fixed.horizontal
	-- 	},
	-- 	nil,
	-- 	dismiss_button,
	-- 	expand = "inside",
	-- 	spacing = beautiful.notification_margin,
	-- 	layout = wibox.layout.align.horizontal
	-- }

	-- local action_list = wibox.widget {
	-- 	notification = n,
	-- 	base_layout = wibox.widget {
	-- 		spacing = beautiful.notification_margin,
	-- 		layout = wibox.layout.fixed.horizontal
	-- 	},
	-- 	widget_template = {
	-- 		{
	-- 			{
	-- 				{
	-- 					id = 'text_role',
	-- 					align = "center",
	-- 					valign = "center",
	-- 					widget = wibox.widget.textbox
	-- 				},
	-- 				top = dpi(4),
	-- 				bottom = dpi(4),
	-- 				left = dpi(10),
	-- 				right = dpi(10),
	-- 				widget = wibox.container.margin
	-- 			},
	-- 			bg = beautiful.bg_button,
	-- 			border_width = beautiful.btn_border_width,
	-- 			border_color = beautiful.border_button,
	-- 			shape = gears.shape.rounded_bar,
	-- 			widget = wibox.container.background,
	-- 		},
	-- 		widget  = clickable_container,
	-- 	},
	-- 	style = { underline_normal = false, underline_selected = true },
	-- 	widget = naughty.list.actions,
	-- }

	-- local title_area_and_message = wibox.widget{
	-- 	naughty.widget.title,
	-- 	naughty.widget.message,
	-- 	spacing = beautiful.notification_margin,
	-- 	layout = wibox.layout.fixed.vertical
	-- }


	-- local notibox = wibox.widget{
	-- 	app_icon_with_name_and_dismiss_btn,
	-- 	{
	-- 		icon,
	-- 		title_area_and_message,
	-- 		spacing = beautiful.notification_margin,
	-- 		layout = wibox.layout.fixed.horizontal
	-- 	},
	-- 	spacing = beautiful.notification_margin,
	-- 	layout = wibox.layout.fixed.vertical
	-- }


	-- naughty.layout.box {
	-- 	notification = n,
	-- 	bg = "#00000000",
	-- 	widget_template = {
	-- 		{
	-- 			{
	-- 				{
	-- 					notibox,
	-- 					action_list,
	-- 					widget = container
	-- 				},
	-- 				margins = beautiful.notification_margin,
	-- 				widget = wibox.container.margin
	-- 			},
	-- 			bg = beautiful.bg_normal,
	-- 			shape = beautiful.widget_shape,
	-- 			widget = wibox.container.background
	-- 		},
	-- 		strategy = "max",
	-- 		forced_width = beautiful.notification_max_width or dpi(300),
    -- 		widget = wibox.container.constraint
	-- 	}
	-- }

	-- local focused = awful.screen.focused()
	-- if _G.dont_disturb or
	-- 	(focused.central_panel and focused.central_panel.visible) then
	-- 	naughty.destroy_all_notifications(nil, 1)
	-- end

-- end)
local my_button = wibox.widget{
    {
        {
            text = "Dismiss",
            widget = wibox.widget.textbox
        },
        top = 10, bottom = 10, left = 10, right = 10,
        widget = wibox.container.margin
    },
    bg = '#4C566A', -- basic
    bg = '#12670000', --tranparent
    shape_border_width = 1, shape_border_color = '#4C566A', -- outline
    shape = function(cr, width, height) 
        gears.shape.rounded_rect(cr, width, height, 0) 
    end,
    widget = wibox.container.background
}

my_button:connect_signal("button::press", function(c)
	naughty.destroy_all_notifications(nil, 1)
end)

local noti_buttons = gears.table.join(
        awful.button({ }, 3, function(n)
			-- n:destroy(nil, 1)
			naughty.destroy_all_notifications(nil, 1)
		end))


naughty.connect_signal("request::display", function(n)
--   if not n.app_icon then
--     n.app_icon = beautiful.notification_icon
--   end

--   n.title = "<span font='" .. beautiful.font_name .. "10'><b>" .. n.title .. "</b></span>"

--   local time = os.date "%H:%M"

  naughty.layout.box {
    notification = n,
    type = "notification",
    widget_template = {
      {
		{
			{
				{
					{
						naughty.widget.icon,
						{
							naughty.widget.title,
							naughty.widget.message,
							spacing = 4,
							layout = wibox.layout.fixed.vertical,
						},
						fill_space = true,
						spacing = 10,
						layout = wibox.layout.fixed.horizontal,
					},
					naughty.list.actions,
					-- spacing = 10,
					layout = wibox.layout.fixed.vertical,
				},
				margins = 10,
				-- bottom = 10,
				widget = wibox.container.margin,
			},
			id = "background_role",
			widget = naughty.container.background,
		},
		buttons = noti_buttons,
		-- {
        --     widget = my_button
		-- },
		layout = wibox.layout.fixed.vertical

		-- layout = wibox.layout.horizontal,
      },
      strategy = "max",
      width = 600,
      widget = wibox.container.constraint,
    },
  }
end)


