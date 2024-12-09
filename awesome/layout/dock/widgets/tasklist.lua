--Standard Modules
local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--color and icons
local color = require("layout.dock.color")
local user = require("popups.user_profile")
local icon_path = user.icon_theme_path

-- tasklist buttons
local deco = {
    -- wallpaper = require("deco.wallpaper"),
    taglist = require("deco.taglist"),
    tasklist = require("deco.tasklist"),
}

local taglist_buttons = deco.taglist()
local tasklist_buttons = deco.tasklist()

--Tasklist Widget
local tasklist_widget = awful.widget.tasklist({
    screen = screen[1],
    filter = awful.widget.tasklist.filter.allscreen,
    buttons = tasklist_buttons,
    margins = {
        top = dpi(20),
        bottom = dpi(20),
        left = dpi(20),
        right = dpi(20),
    },
    style = {
        shape = gears.shape.rounded_rect,
    },
    layout = {
        margins = dpi(5),
        spacing = dpi(15),
        forced_num_rows = 1,
        layout = wibox.layout.grid.horizontal,
    },
    widget_template = {
        {
            {
                id = "clienticon",
                widget = awful.widget.clienticon,
                resize = true,
            },
            margins = dpi(8),
            widget = wibox.container.margin,
        },
        id = "background_role",
        forced_width = dpi(40),
        forced_height = dpi(40),
        widget = wibox.container.background,
        create_callback = function(self, c, index, objects)
            self:get_children_by_id("clienticon")[1].client = c
            if c.minimized then
                self.bg = color.background_darkest
            else
                self.bg = color.background_dark
            end
            self:connect_signal("mouse::enter", function()
                if not c.minimized then
                    self.bg = color.background_lighter
                else
                    self.bg = color.background_darkest
                end
            end)
            self:connect_signal("mouse::leave", function()
                if not c.minimized then
                    self.bg = color.background_dark
                else
                    self.bg = color.background_darkest
                end
            end)
        end,
        update_callback = function(self, c, index, objects)
            if c.minimized then
                self.bg = color.background_darkest
            else
                self.bg = color.background_dark
            end
        end,
    },
})

return tasklist_widget

