local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local user = require("popups.user_profile")

-- Function to set the wallpaper for each screen
local function set_wallpaper(s)
    awful.wallpaper {
        screen = s,
        widget = {
            horizontal_fit_policy = "fit",
            vertical_fit_policy   = "fit",
            {
                {
                    {
                        image                 = user.wallpaper,
                        resize                = true,
                        widget                = wibox.widget.imagebox,
                        forced_height         = 1080,
                        forced_width          = 1920,
                        horizontal_fit_policy = "fit",
                        vertical_fit_policy   = "fit"
                    },
                    widget = wibox.container.background,
                    bg = "#1a1b26",
                    shape = function(cr, width, height)
                        gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, 12)
                    end,
                },
                widget = wibox.container.background,
                bg = "#1a1b26"
            },
            valign = "center",
            halign = "center",
            tiled  = false,
            widget = wibox.container.tile,
        }
    }
end

-- Apply the wallpaper to each screen
screen.connect_signal("request::wallpaper", function(s)
    set_wallpaper(s)
end)

-- Re-apply the wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    set_wallpaper(s)
end)

-- Apply wallpaper to each screen on startup
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
end)

