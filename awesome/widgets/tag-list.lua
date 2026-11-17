-----------------------------------------------------------
-- NUMBERED TAGLIST with TAG LIMIT (Awesome-Rice Style)
-----------------------------------------------------------

local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

local M = {}

-----------------------------------------------------------
-- CONFIG
-----------------------------------------------------------

M.max_tags = 5   -- you can change this in your pastel/mirage config

-----------------------------------------------------------
-- UPDATE TAG APPEARANCE
-----------------------------------------------------------

local function update(item, tag)
    local bg_color
    local fg_color

    if tag.selected then
        bg_color = beautiful.taglist_bg_focus or "#5a82f299"
        fg_color = beautiful.fg_focus or "#ffffff"

    elseif #tag:clients() > 0 then
        bg_color = beautiful.taglist_bg_occupied or "#ffffff22"
        fg_color = beautiful.fg_normal or "#dddddd"

    else
        bg_color = beautiful.taglist_bg_empty or "#00000015"
        fg_color = beautiful.fg_minimize or "#888888"
    end

    item.bg_widget.bg = bg_color
    item.number_widget.markup =
        "<span foreground='" .. fg_color .. "'>" .. tag.index .. "</span>"
end

-----------------------------------------------------------
-- CREATE TAGLIST FOR SCREEN
-----------------------------------------------------------

M.create = function(s)
    return awful.widget.taglist {
        screen  = s,
        filter  = function(t)
            -- Limit number of tags shown
            return t.index <= M.max_tags
        end,

        layout  = wibox.layout.fixed.horizontal,
        spacing = dpi(8),

        widget_template = {
            {
                {
                    id     = "number_widget",
                    widget = wibox.widget.textbox,
                    align  = "center",
                    valign = "center",
                },
                forced_width  = dpi(26),
                forced_height = dpi(26),
                widget = wibox.container.place,
            },

            id     = "bg_widget",
            shape  = gears.shape.rounded_bar,
            widget = wibox.container.background,

            create_callback = function(self, tag, _, _)
                self.number_widget = self:get_children_by_id("number_widget")[1]
                self.bg_widget     = self

                update(self, tag)
            end,

            update_callback = function(self, tag, _, _)
                update(self, tag)
            end,
        },

        buttons = gears.table.join(
            awful.button({}, 1, function(t) t:view_only() end),
            awful.button({ beautiful.modkey }, 1, function(t)
                if client.focus then client.focus:move_to_tag(t) end
                t:view_only()
            end),
            awful.button({}, 3, awful.tag.viewtoggle),
            awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end)
        ),
    }
end

return M

