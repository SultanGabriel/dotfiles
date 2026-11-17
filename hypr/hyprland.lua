--=========================================================
-- SXLTXN
--=========================================================

-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

local apps = require("config.apps")

require("config.layouts")

------------------
---- MONITORS ----
------------------

local settings = require("config.settings")

for _, role in ipairs(settings.monitor_order) do
    local monitor = settings.monitors[role]

    hl.monitor({
        output = monitor.output,
        mode = monitor.mode,
        position = monitor.position,
        scale = monitor.scale,
    })
end

-----------------
-- AUTOSTART ----
-----------------
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/


hl.on("hyprland.start", function()
    -- Initialize KDE Wallet in the Hyprland session so applications can
    -- access the same encrypted wallet used by Plasma.
    hl.exec_cmd("/usr/lib/pam_kwallet_init");

    -- Export the current Hyprland session environment to D-Bus and
    -- the systemd user manager. This is the recommended standalone
    -- Hyprland setup.
    hl.exec_cmd(
        "dbus-update-activation-environment --systemd --all"
    )

    -- Bar
    hl.exec_cmd("waybar");

    -- Bottom taskbar
    hl.exec_cmd(settings.apps.dock);

    -- Wallpaper
    hl.exec_cmd("hyprpaper");

    -- Reload Hyprland View 
    hl.exec_cmd("hyprpm reload");

    -- Notifications
    hl.exec_cmd("mako");

    -- Auth thingy
    hl.exec_cmd("systemctl --user start hyprpolkitagent")

    -- Clipboard history
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Later:
    -- notification daemon
    --   hl.exec_cmd("waybar & hyprpaper ")
    -- polkit agent
    -- wallpaper
    -- bar
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-------------
-- INPUT ----
-------------

hl.config({
    input = {
        kb_layout    = "de",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "",
        kb_rules     = "",

        follow_mouse = 1,

        sensitivity  = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad     = {
            natural_scroll = false,
        },
    },
})

-- LOOK AND FEEL
require("config.appearance")

-- KEYBINDINGS 
require("config.keybinds")

-- RULES AND WORKSPACES 
require("config.workspaces")
require("config.rules")