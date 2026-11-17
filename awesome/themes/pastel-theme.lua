--      ████████╗██╗  ██╗███████╗███╗   ███╗███████╗
--      ╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝
--         ██║   ███████║█████╗  ██╔████╔██║█████╗
--         ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝
--         ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗
--         ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================


local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- define module table
local theme = {}


-- ===================================================================
-- Theme Variables
-- ===================================================================


theme.name = "pastel"

-- Font
theme.font = "SF Pro Text 9"
theme.title_font = "SF Pro Display Medium 10"

-- Background
-- theme.bg_normal = "#1f2430"
theme.bg_normal = "#141C25"
theme.bg_dark = "#000000"
--theme.bg_focus = "#151821"
theme.bg_focus = "#243242"
theme.bg_urgent = "#ed8274"
--theme.bg_minimize = "#444444"
theme.bg_minimize = "#315E5C"

-- Foreground
theme.fg_normal = "#ffffff"
theme.fg_focus = "#e4e4e4"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

-- Window Gap Distance
theme.useless_gap = dpi(4)

-- Show Gaps if Only One Client is Visible
theme.gap_single_client = true

-- Window Borders
theme.border_width = dpi(4)
theme.border_normal = theme.bg_normal
theme.border_focus = "#ff8a65"
theme.border_marked = theme.fg_urgent

-- Taglist
theme.taglist_bg_empty = theme.bg_normal
theme.taglist_bg_occupied = "#00ff002F"
theme.taglist_bg_urgent = "#e91e6399"
theme.taglist_bg_focus = theme.bg_focus

-- Tasklist
theme.tasklist_font = theme.font

theme.tasklist_bg_normal = theme.bg_normal
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_bg_urgent = theme.bg_urgent

theme.tasklist_fg_focus = theme.fg_focus
theme.tasklist_fg_urgent = theme.fg_urgent
theme.tasklist_fg_normal = theme.fg_normal

-- Panel Sizing
theme.left_panel_width = dpi(50)
theme.top_panel_height = dpi(32)

-- Notification Sizing
theme.notification_max_width = dpi(350)

-- System Tray
theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = dpi(5)

-- Titlebars
theme.titlebars_enabled = false


-- ===================================================================
-- Icons
-- ===================================================================


-- Define layout icons
theme.layout_tile = "~/.config/awesome/icons/layouts/tiled.png"
theme.layout_floating = "~/.config/awesome/icons/layouts/floating.png"
theme.layout_max = "~/.config/awesome/icons/layouts/maximized.png"

theme.icon_theme = "Tela-dark"


-- ===================================================================
-- Flash Focus (bling) - Multi-Monitor optimiert
-- ===================================================================
theme.flash_focus_start_opacity = 0.4   -- Startopacity (niedriger = subtiler)
theme.flash_focus_step = 0.04          -- Animationsgeschwindigkeit (höher = schneller)
theme.flash_focus_color = "#A6E3A1"  -- sanftes grün
-- mstab
-- ===================================================================
-- Layout (bling) - no idea i copied it from the wiki xd
-- ===================================================================
theme.mstab_bar_disable = false        -- disable the tabbar
theme.mstab_bar_ontop = false          -- whether you want to allow the bar to be ontop of clients
theme.mstab_dont_resize_slaves = false -- whether the tabbed stack windows should be smaller than the
                                       -- currently focused stack window (set it to true if you use
                                       -- transparent terminals. False if you use shadows on solid ones
theme.mstab_bar_padding = "default"    -- how much padding there should be between clients and your tabbar
                                       -- by default it will adjust based on your useless gaps.
                                       -- If you want a custom value. Set it to the number of pixels (int)
theme.mstab_border_radius = 0          -- border radius of the tabbar
theme.mstab_bar_height = 40            -- height of the tabbar
theme.mstab_tabbar_position = "top"    -- position of the tabbar (mstab currently does not support left,right)
theme.mstab_tabbar_style = "default"   -- style of the tabbar ("default", "boxes" or "modern")
                                       -- defaults to the tabbar_style so only change if you want a
                                       -- different style for mstab and tabbed
return theme
