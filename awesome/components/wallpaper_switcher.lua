local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local lfs = require("lfs")

local wallpaper = require("components.pastel.wallpaper")

-- Configuration
local wallpaper_dir = gears.filesystem.get_configuration_dir() .. "wallpaper/"
local preview_size = 150

local function get_directory_items(dir)
    local items = {}
    for file in lfs.dir(dir) do
        if file ~= "." and file ~= ".." then
            table.insert(items, file)
        end
    end
    return items
end

-- Wallpaper data
local all_wallpapers = get_directory_items(wallpaper_dir)
local filtered_wallpapers = gears.table.clone(all_wallpapers)

-- Create the popup
local popup = awful.popup {
    widget = {
        {
            {
                id = "search_bar",
                widget = wibox.widget {
                    {
                        {
                            id = "search_input",
                            widget = wibox.widget.textbox,
                            font = "Monospace 12",
                            forced_height = 40,
                            placeholder_text = "Search wallpapers...",
                        },
                        left = 10,
                        right = 10,
                        widget = wibox.container.margin,
                    },
                    bg = beautiful.bg_focus,
                    shape = gears.shape.rounded_rect,
                    widget = wibox.container.background,
                },
            },
            {
                id = "wallpaper_grid",
                layout = wibox.layout.grid,
                spacing = 10,
                forced_num_cols = 5,
                forced_num_rows = 5,
            },
            layout = wibox.layout.fixed.vertical,
        },
        margins = 10,
        widget = wibox.container.margin,
    },
    ontop = true,
    visible = false,
    shape = gears.shape.rounded_rect,
    forced_width = 800,
    forced_height = 600,
    placement = awful.placement.centered,
    bg = beautiful.bg_normal,
}

-- Function to update the wallpaper grid
local function update_wallpaper_grid(query)
    local grid = popup.widget:get_children_by_id("wallpaper_grid")[1]
    grid:reset()

    filtered_wallpapers = {}

    for _, file in ipairs(all_wallpapers) do
        if not query or file:lower():match(query:lower()) then
            table.insert(filtered_wallpapers, file)
        end
    end

    for _, file in ipairs(filtered_wallpapers) do
        local full_path = wallpaper_dir .. file
        local preview = wibox.widget {
            {
                {
                    image = full_path,
                    resize = true,
                    forced_width = preview_size,
                    forced_height = preview_size,
                    widget = wibox.widget.imagebox,
                },
                margins = 5,
                widget = wibox.container.margin,
            },
            bg = beautiful.bg_focus,
            shape = gears.shape.rounded_rect,
            widget = wibox.container.background,
            buttons = gears.table.join(awful.button({}, 1, function()
                wallpaper.set_wallpaper(full_path)
                popup.visible = false
            end)),
        }
        grid:add(preview)
    end
end

-- Handle search input
local function handle_search_input(input)
    update_wallpaper_grid(input)
end

-- Handle keyboard navigation
local function handle_navigation(key)
    -- Implement navigation logic here
    naughty.notify({ title = "Key pressed", text = key })
end

-- Open function
local function open()
    if popup.visible then
        popup.visible = false
    else
        popup.visible = true
        popup.screen = awful.screen.focused({ coords = mouse.coords() })
        update_wallpaper_grid()
    end
end

-- Connect search bar to input handler
popup.widget:get_children_by_id("search_bar")[1]:connect_signal("property::text", function(_, text)
    handle_search_input(text)
end)

-- Add keygrabber for navigation
awful.keygrabber {
    start_callback = function()
        popup.visible = true
    end,
    stop_callback = function()
        popup.visible = false
    end,
    keybindings = {
        { {}, "Up", function() handle_navigation("Up") end },
        { {}, "Down", function() handle_navigation("Down") end },
        { {}, "Left", function() handle_navigation("Left") end },
        { {}, "Right", function() handle_navigation("Right") end },
        { {}, "Return", function() handle_navigation("Select") end },
    },
}

-- Signal to open popup
awesome.connect_signal("wallpaper_switcher::open", function()
    open()
end)

-- Export the open function
return {
    open = open,
}

