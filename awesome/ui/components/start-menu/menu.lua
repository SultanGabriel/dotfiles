local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local app_scanner = require("ui.components.start-menu.app_scanner")

local start_menu = {}
local panel

-- Panel Size (4:3 centered)
local function panel_geometry()
    local screen_geo = awful.screen.focused().geometry
    local width  = math.floor(screen_geo.width * 0.50)
    local height = math.floor(screen_geo.height * 0.50)

    return {
        x = screen_geo.x + (screen_geo.width - width) / 2,
        y = screen_geo.y + (screen_geo.height - height) / 2,
        width = width,
        height = height
    }
end

-- Single item widget
local function build_app_item(app)
    local icon_widget = wibox.widget{
        widget = wibox.widget.imagebox,
        image = app.icon,
        resize = true,
        forced_height = 24,
        forced_width  = 24
    }

    local text_widget = wibox.widget{
        widget = wibox.widget.textbox,
        text = app.name,
        valign = "center",
        halign = "left"
    }

    local row = wibox.widget{
        {
            icon_widget,
            text_widget,
            spacing = 10,
            layout = wibox.layout.fixed.horizontal,
        },
        margins = 8,
        widget = wibox.container.margin
    }

    row:connect_signal("button::press", function()
        awful.spawn(app.exec)
        start_menu.close()
    end)

    return row
end

-- Build full scrollable list
local function build_list_widget()
    local apps = app_scanner.scan()

    local list = wibox.widget{
        layout = wibox.layout.fixed.vertical,
        spacing = 2
    }

    for _, app in ipairs(apps) do
        list:add(build_app_item(app))
    end

    -- Scroll container
    return wibox.widget{
        list,
        layout = wibox.layout.fixed.vertical,
        widget = wibox.container.scroll.vertical
    }
end

-- Build entire start menu panel
local function build_panel()
    local geo = panel_geometry()

    local p = wibox({
        x = geo.x,
        y = geo.y,
        width = geo.width,
        height = geo.height,
        bg = beautiful.bg_normal .. "dd",
        ontop = true,
        visible = false,
        shape = function(cr,w,h)
            gears.shape.rounded_rect(cr,w,h, 14)
        end
    })

    p:setup{
        {
            {
                widget = wibox.widget.textbox,
                text = "Applications",
                font = beautiful.title_font or "Sans Bold 12",
                align = "center",
                valign = "center"
            },
            margins = 12,
            widget = wibox.container.margin
        },

        {
            build_list_widget(),
            margins = 10,
            widget = wibox.container.margin
        },

        layout = wibox.layout.align.vertical
    }

    return p
end

-- Public API
function start_menu.open()
    if not panel then
        panel = build_panel()
    end
    panel.visible = true
end

function start_menu.close()
    if panel then
        panel.visible = false
    end
end

return start_menu

