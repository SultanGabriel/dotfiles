local awful      = require("awful")
local wibox      = require("wibox")
local gears      = require("gears")
local beautiful  = require("beautiful")
local dpi        = beautiful.xresources.apply_dpi

-- widgets
local task_list  = require("widgets.task-list")
local tag_list  = require("widgets.tag-list")
local calendar   = require("widgets.calendar")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
local volume_widget      = require("awesome-wm-widgets.volume-widget.volume")
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")
local network_widget     = require("widgets.network")
local layout_box         = require("widgets.layout-box")

local cpu_widget_config = {
  width        = 45,
  step_width   = 2,
  step_spacing = 0,
  color        = "#434c5e",
}

local brightness_widget_config = {
  program = "light",
  type = "arc",
  tooltip = true,
  step = 5,
  timeout = 420, -- no reason to update to often, FIXME KEEP IN MIND THAT YOU DO THIS.
  rmb_set_max = true
}

local topbar = {}

-- small helper for uniform padding inside blocks
local function inner(widget)
  return wibox.container.margin(widget, dpi(8), dpi(8), dpi(4), dpi(4))
end

topbar.create = function(s)
  --------------------------------------------------------------------
  -- 1) Base wibar: full width, transparent; only used as a canvas
  --------------------------------------------------------------------
  local panel_height = beautiful.top_panel_height or dpi(24)

  local bar = awful.wibar({
    screen = s,
    position = "top",
    height = panel_height,
    bg = "#00000000",          -- fully transparent, segments draw their own bg
    ontop = true,
  })

  local total_w = s.geometry.width
  local left_w  = math.floor(total_w * 0.35)
  local mid_w   = math.floor(total_w * 0.15)
  local right_w = math.floor(total_w * 0.35)

  --------------------------------------------------------------------
  -- 2) LEFT segment – anchored to left
  --------------------------------------------------------------------
  local left_block = wibox.widget {
    {
      -- your actual left content
      inner(tag_list.create(s)),
      inner(task_list.create(s)),
      layout = wibox.layout.fixed.horizontal,
      spacing = dpi(6),
    },
    bg = beautiful.bg_normal .. "CC",
    shape = gears.shape.rounded_bar,
    widget = wibox.container.background,
  }

  local left_section = wibox.widget {
    left_block,
    forced_width = left_w,
    halign = "left",
    valign = "center",
    widget = wibox.container.place,
  }

  --------------------------------------------------------------------
  -- 3) MIDDLE segment – centered
  --------------------------------------------------------------------
  local middle_block = wibox.widget {
    inner(calendar.create(s)),
    -- bg = beautiful.bg_normal .. "CC",
    bg = beautiful.bg_normal .. "CC",
    shape = gears.shape.rounded_bar,
    widget = wibox.container.background,
  }

  local middle_section = wibox.widget {
    middle_block,
    forced_width = mid_w,
    halign = "center",
    valign = "center",
    widget = wibox.container.place,
  }

  --------------------------------------------------------------------
  -- 4) RIGHT segment – anchored to right
  --------------------------------------------------------------------
  local right_content = wibox.widget {
    inner(wibox.widget.systray()),
    inner(volume_widget()),
    inner(cpu_widget(cpu_widget_config)),
    inner(ram_widget()),
    brightness_widget(brightness_widget_config),
    -- inner(network_widget()),
    -- inner(logout_menu_widget()),
    inner(layout_box.create(s)),
    layout = wibox.layout.fixed.horizontal,
    spacing = dpi(6),
  }

  local right_block = wibox.widget {
    right_content,
    bg = beautiful.bg_normal .. "CC",
    shape = gears.shape.rounded_bar,
    widget = wibox.container.background,
  }

  local right_section = wibox.widget {
    right_block,
    forced_width = right_w,
    halign = "right",
    valign = "center",
    widget = wibox.container.place,
  }

  --------------------------------------------------------------------
  -- 5) Layout: stack + place → L/C/R anchored, gaps in between
  --------------------------------------------------------------------
  bar:setup({
    {
      layout = wibox.layout.stack,
      left_section,
      middle_section,
      right_section,
    },
    top = dpi(2),
    -- bottom = dpi(16),
    left = dpi(16),
    right = dpi(16),
    widget = wibox.container.margin

  })

  --------------------------------------------------------------------
  -- 6) Hide bar when fullscreen
  --------------------------------------------------------------------
  local function change_panel_visibility(c)
    if c.screen == s then
      bar.ontop = not c.fullscreen
      bar.visible = not c.fullscreen
    end
  end

  client.connect_signal("property::fullscreen", change_panel_visibility)
  client.connect_signal("focus", change_panel_visibility)
end

return topbar
