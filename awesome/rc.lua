--       █████╗ ██╗    ██╗███████╗███████╗ ██████╗ ███╗   ███╗███████╗
--      ██╔══██╗██║    ██║██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔════╝
--      ███████║██║ █╗ ██║█████╗  ███████╗██║   ██║██╔████╔██║█████╗
--      ██╔══██║██║███╗██║██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝
--      ██║  ██║╚███╔███╔╝███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗
--      ╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝


-- Standard awesome libraries
local gears = require("gears")
local awful = require("awful")
local radical = require("radical")

local bling = require("bling")

--local wallpaper_picker = require("ui.components.wallpaper_picker")
-- ===================================================================
-- User Configuration
-- ===================================================================


local themes = {
   "pastel", -- 1
   -- "mirage"  -- 2
}

-- change this number to use the corresponding theme
local theme = themes[1]
local theme_config_dir = gears.filesystem.get_configuration_dir() .. "/configuration/" .. theme .. "/"

-- define default apps (global variable so other components can access it)
local rofi_dir="/home/sultan/.config/rofi/launchers/type-1"
local rofi_theme="style-2"

apps = {
   network_manager = "", -- recommended: nm-connection-editor FIXME ??? interesting ?
   power_manager = "", -- recommended: xfce4-power-manager
   terminal = "alacritty",
   lock = "i3lock",
   launcher = "rofi -show drun -theme " .. rofi_dir .. "/" .. rofi_theme .. ".rasi",
   screenshot = "scrot -e 'mv $f ~/Pictures/ 2>/dev/null'",
   filebrowser = "nautilus"
}

-- define wireless and ethernet interface names for the network widget
-- use `ip link` command to determine these
network_interfaces = {
   -- wlan = 'wlp1s0',
   lan = 'enp1s0'
}

-- List of apps to run on start-up
local run_on_start_up = {
   -- "picom --experimental-backends --config " .. theme_config_dir .. "picom.conf",
   "picom --experimental-backends --config ~/.config/picom/picom.conf",
   -- "redshift",
   -- "unclutter",
   -- "pgrep -f ulauncher-daemon > /dev/null || ulauncher --hide-window"
   --"ulauncher --hide-winodw &"
  "~/.xinit.sh" -- FIXME make this run automatically sometime
}


-- ===================================================================
-- Initialization
-- ===================================================================


-- Import notification appearance
require("components.notifications")

-- Run all the apps listed in run_on_start_up
for _, app in ipairs(run_on_start_up) do
   local findme = app
   local firstspace = app:find(" ")
   if firstspace then
      findme = app:sub(0, firstspace - 1)
   end
   -- pipe commands to bash to allow command to be shell agnostic
   awful.spawn.with_shell(string.format("echo 'pgrep -u $USER -x %s > /dev/null || (%s)' | bash -", findme, app), false)
end

-- Import theme
local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/" .. theme .. "-theme.lua")

-- Initialize theme
local selected_theme = require(theme)
selected_theme.initialize()
-- -- Custom Flash Focus (SIMPLE & ROBUST VERSION)
-- local function flash_focus(c)
--     if not c then return end
--     if not c.valid then return end
--
--     -- Skip wenn window eh schon transparent ist
--     local target_opacity = c.opacity or 1.0
--     if target_opacity < 0.9 then return end
--
--     -- Flash settings
--     local start_opacity = 0.5    -- Start bei 50%
--     local step_size = 0.05       -- Erhöhe um 5% pro tick
--     local tick_rate = 0.015      -- Alle 15ms (smooth)
--
--     c.opacity = start_opacity
--
--     local function fade_in()
--         if not c.valid then return false end
--
--         c.opacity = c.opacity + step_size
--
--         if c.opacity >= target_opacity then
--             c.opacity = target_opacity
--             return false  -- stop timer
--         end
--
--         return true  -- continue timer
--     end
--
--     gears.timer.start_new(tick_rate, fade_in)
-- end
--
-- -- Connect signal
-- client.connect_signal("focus", flash_focus)
-- FLASH FOCUS AKTIVIEREN
--
-- bling.module.flash_focus.enable {
--     client_opacity = true,           -- ob opacity geändert wird
--     opacity_step = 0.3,             -- wie schnell (höher = schneller)
--     opacity_min = 0.4,               -- start opacity (niedriger = subtiler)
-- }
-- Window Switcher
bling.signal.playerctl.enable()
bling.widget.window_switcher.enable {
    type = "thumbnail",  -- or "thumbnail", "titlebar"
    hide_window_switcher_key = "Escape",
    minimize_key = "n",
    unminimize_key = "N",
    kill_client_key = "q",
    cycle_key = "Tab",
    previous_key = "Left",
    next_key = "Right",
    vim_previous_key = "h",
    vim_next_key = "l",
}

-- Import Keybinds
local keys = require("keys")
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

-- Import rules
local create_rules = require("rules").create
awful.rules.rules = create_rules(keys.clientkeys, keys.clientbuttons)

-- Define layouts
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.max
  -- awful.layout.suit.max.fullscreen
  -- awful.layout.suit.magnifier
  -- awful.layout.suit.floating,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle
  bling.layout.mstab,
  bling.layout.centered,
  bling.layout.vertical,
  bling.layout.horizontal,
  bling.layout.equalarea,
  bling.layout.deck
}

-- remove gaps if layout is set to max
tag.connect_signal('property::layout', function(t)
   local current_layout = awful.tag.getproperty(t, 'layout')
   if (current_layout == awful.layout.suit.max) then
      t.gap = 0
   else
      t.gap = beautiful.useless_gap
   end
end)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
   -- Set the window as a slave (put it at the end of others instead of setting it as master)
   if not awesome.startup then
      awful.client.setslave(c)
   end

   if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
   end
end)


-- ===================================================================
-- Client Focusing
-- ===================================================================


-- Autofocus a new client when previously focused one is closed
require("awful.autofocus")

-- Focus clients under mouse
client.connect_signal("mouse::enter", function(c)
   c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)



-- ===================================================================
-- screen xrandr init
-- ===================================================================
-- awful.spawn.with_shell("~/.config/awesome/scripts/xrandr-setup.sh")

-- ===================================================================
-- Screen Change Functions (ie multi monitor)
-- ===================================================================


-- Reload config when screen geometry changes
screen.connect_signal("property::geometry", awesome.restart)


-- ===================================================================
-- Garbage collection (allows for lower memory consumption)
-- ===================================================================


collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)



--local naughty = require("naughty")
-- Keybinding to open the wallpaper switcher

