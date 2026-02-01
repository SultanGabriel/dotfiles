--      ████████╗ ██████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗
--      ╚══██╔══╝██╔═══██╗██╔══██╗    ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║
--         ██║   ██║   ██║██████╔╝    ██████╔╝███████║██╔██╗ ██║█████╗  ██║
--         ██║   ██║   ██║██╔═══╝     ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║
--         ██║   ╚██████╔╝██║         ██║     ██║  ██║██║ ╚████║███████╗███████╗
--         ╚═╝    ╚═════╝ ╚═╝         ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

-- import widgets
local task_list = require("widgets.task-list")
-- local tag_list = require("widgets.tag-list-top")
local tag_list = require("widgets.tag-list")

-- define module table
local top_panel = {}

-- ===================================================================
-- Bar Creation
-- ===================================================================

local ram_widget = require("libs.awesome-wm-widgets.ram-widget.ram-widget")
local cpu_widget = require("libs.awesome-wm-widgets.cpu-widget.cpu-widget")
local logout_menu_widget = require("libs.awesome-wm-widgets.logout-menu-widget.logout-menu")
local volume_widget = require("libs.awesome-wm-widgets.volume-widget.volume")

local cpu_widget_config = {
	width = 70,
	step_width = 2,
	step_spacing = 0,
	color = "#434c5e",
}

top_panel.create = function(s)
	local panel = awful.wibar({
		screen = s,
		position = "top",
		ontop = true,
		height = beautiful.top_panel_height,
		width = s.geometry.width,
	})

	panel:setup({
		expand = "none",
		layout = wibox.layout.align.horizontal,
         -- add taglist widget
    {
      layout = wibox.layout.fixed.horizontal,
      spacing = 8,
      -- tag_list.create(s),
      task_list.create(s),
    },

		
    {
        layout = wibox.container.margin,
        left = 16,
        right = 16,

 
        {
            id = "#middle",
            layout = wibox.layout.fixed.horizontal,
            spacing = 8,
            require("widgets.calendar").create(s)
        },
    },

		{
      layout = wibox.layout.fixed.horizontal,
      spacing = 8,
			-- layout = wibox.layout.fixed.horizontal,
			wibox.layout.margin(wibox.widget.systray(), dpi(5), dpi(5), dpi(5), dpi(5)),
			-- require("widgets.bluetooth"),
      volume_widget(),
			cpu_widget(cpu_widget_config),
			ram_widget(),
			require("widgets.network")(),
      logout_menu_widget(),
			-- require("widgets.battery"),
			wibox.layout.margin(require("widgets.layout-box").create(s), dpi(5), dpi(5), dpi(5), dpi(5)),
		},
	})

	-- ===================================================================
	-- Functionality
	-- ===================================================================

	-- hide panel when client is fullscreen
	local function change_panel_visibility(client)
		if client.screen == s then
			panel.ontop = not client.fullscreen
		end
	end

	-- connect panel visibility function to relevant signals
	client.connect_signal("property::fullscreen", change_panel_visibility)
	client.connect_signal("focus", change_panel_visibility)
end

return top_panel
