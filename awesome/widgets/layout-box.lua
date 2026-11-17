--      ██╗      █████╗ ██╗   ██╗ ██████╗ ██╗   ██╗████████╗    ██████╗  ██████╗ ██╗  ██╗
--      ██║     ██╔══██╗╚██╗ ██╔╝██╔═══██╗██║   ██║╚══██╔══╝    ██╔══██╗██╔═══██╗╚██╗██╔╝
--      ██║     ███████║ ╚████╔╝ ██║   ██║██║   ██║   ██║       ██████╔╝██║   ██║ ╚███╔╝
--      ██║     ██╔══██║  ╚██╔╝  ██║   ██║██║   ██║   ██║       ██╔══██╗██║   ██║ ██╔██╗
--      ███████╗██║  ██║   ██║   ╚██████╔╝╚██████╔╝   ██║       ██████╔╝╚██████╔╝██╔╝ ██╗
--      ╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝  ╚═════╝    ╚═╝       ╚═════╝  ╚═════╝ ╚═╝  ╚═╝

-- ===================================================================
-- Initialization
-- ===================================================================


local clickable_container = require("widgets.clickable-container")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")


-- ===================================================================
-- Widget Creation
-- ===================================================================


local layout_box = {}

local layout_labels = {
   tile = "Tile",
   tileleft = "Tile Left",
   tilebottom = "Tile Bottom",
   tiletop = "Tile Top",
   fair = "Fair",
   fairhoriz = "Fair Horizontal",
   spiral = "Spiral",
   dwindle = "Spiral Dwindle",
   floating = "Floating",
   max = "Max",
   magnifier = "Magnifier"
}

local function layout_label(layout)
   if not layout then
      return "Layout"
   end
   local name = layout.name or ""
   if layout_labels[name] then
      return layout_labels[name]
   end
   if name ~= "" then
      return name
   end
   return "Layout"
end

local function build_menu_items(screen)
   local current_layout = awful.layout.get(screen)
   local items = {}

   for _, layout in ipairs(awful.layout.layouts or {}) do
      local label = layout_label(layout)
      local prefix = (layout == current_layout) and "* " or "  "
      table.insert(items, {
         prefix .. label,
         function()
            local tag = screen.selected_tag
            if tag then
               awful.layout.set(layout, tag)
            end
         end
      })
   end

   return items
end

layout_box.create = function(screen)
   -- Create an imagebox widget which will contains an icon indicating which layout we're using.
   -- We need one layoutbox per screen.
   local box = clickable_container(awful.widget.layoutbox(screen))
   local menu = nil

   local function toggle_menu()
      if menu and menu.visible then
         menu:hide()
         return
      end

      if menu then
         menu:hide()
         menu = nil
      end

      menu = awful.menu({
         items = build_menu_items(screen),
         theme = {
            width = 200,
            bg_normal = beautiful.bg_normal,
            bg_focus = beautiful.bg_focus,
            fg_normal = beautiful.fg_normal,
            fg_focus = beautiful.fg_focus,
            border_color = beautiful.border_focus,
            border_width = 1
         }
      })

      local coords = mouse.coords()
      menu:show({ coords = { x = coords.x, y = coords.y } })
   end

   box:buttons(
      gears.table.join(
         awful.button({}, 1, toggle_menu),
         awful.button({}, 3, function() awful.layout.inc(-1) end),
         awful.button({}, 4, function() awful.layout.inc(1) end),
         awful.button({}, 5, function() awful.layout.inc(-1) end)
      )
   )

   return box
end

return layout_box
