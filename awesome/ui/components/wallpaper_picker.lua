-- ui/components/wallpaper_picker.lua
local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful")

local library   = require("modules.wallpaper_library")
local wallpaper = require("modules.wallpaper")

local M = {}

local preview = 140

-- SEARCH BAR
local search = wibox.widget.textbox()
search.font = "Monospace 12"
search.forced_height = 35
search.text = "Search..."

local grid = wibox.widget {
    layout = wibox.layout.grid,
    spacing = 10,
    forced_num_cols = 5
}

local popup = awful.popup {
    visible  = false,
    ontop    = true,
    bg       = beautiful.bg_normal,
    shape    = gears.shape.rounded_rect,
    placement = awful.placement.centered,
    minimum_width  = 900,
    minimum_height = 600,
    widget = wibox.widget { layout = wibox.layout.fixed.vertical }
}

-- BUILD GRID
local function rebuild(query)
    print("Rebuilding with:", query)
    grid:reset()

    for _, file in ipairs(library.search(query)) do
        local full = library.fullpath(file)

        local thumb = wibox.widget {
            {
                image = full,
                resize = true,
                forced_width  = preview,
                forced_height = preview,
                widget = wibox.widget.imagebox
            },
            bg = "#333333",
            shape = gears.shape.rounded_rect,
            widget = wibox.container.background,
            buttons = gears.table.join(
                awful.button({}, 1, function()
                    wallpaper.set(full)
                    popup.visible = false
                end)
            )
        }

        grid:add(thumb)
    end
end

-- POPUP LAYOUT
popup.widget = wibox.widget {
    {
        search,
        widget = wibox.container.margin,
        top = 10, bottom = 10, left = 10, right = 10,
    },
    {
        grid,
        widget = wibox.container.margin,
        left = 10, right = 10, bottom = 10,
    },
    layout = wibox.layout.fixed.vertical
}

-- SEARCH SIGNAL
search:connect_signal("property::text", function(_, text)
    rebuild(text)
end)

-- OPEN FUNCTION
function M.open()
    popup.visible = not popup.visible
    rebuild("")
end

return M

