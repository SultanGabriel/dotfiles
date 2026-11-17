local apps = require("config.apps")
local settings = require("config.settings")
local workspaces = require("config.workspaces")

local MOD = settings.mod

---------------------------------------------------------------------
-- Bind registration
---------------------------------------------------------------------

-- We keep our own tiny registry for the F1 help menu while also
-- attaching Hyprland's native description metadata to every bind.
local help_entries = {}

local function bind(group, keys, dispatcher, description, flags)
    local options = flags or {}

    options.description = description

    help_entries[#help_entries + 1] = {
        group = group,
        keys = keys,
        description = description,
    }

    return hl.bind(
        keys,
        dispatcher,
        options
    )
end

---------------------------------------------------------------------
-- Applications
---------------------------------------------------------------------

bind(
    "Launcher",
    MOD .. " + RETURN",
    hl.dsp.exec_cmd(settings.apps.terminal),
    "Open terminal"
)

bind(
    "Launcher",
    MOD .. " + D",
    hl.dsp.exec_cmd(settings.apps.launcher),
    "Open application launcher"
)

bind(
    "Launcher",
    MOD .. "+ SHIFT + D",
    hl.dsp.exec_cmd(settings.apps.launcher_big),
    "Open application launcher"
)

bind(
    "Launcher",
    MOD .. "+ S",
    hl.dsp.exec_cmd(settings.apps.sx_settings),
    "Open SX Settings"
)
---------------------------------------------------------------------
-- Hyprland
---------------------------------------------------------------------

-- bind(
--     "Hyprland",
--     MOD .. " + CTRL + R",
--     hl.dsp.exec_cmd("hyprctl reload"),
--     "Reload configuration"
-- )

-- Open / toggle hyprview overview
bind(
    "Window",
    MOD .. " + ESCAPE",
    function()
        if hl.plugin.hyprview then
            hl.plugin.hyprview.toggle("all")
        end
    end,
    "Toggle window overview"
)

-- Close HyprView with plain Escape.
--
-- non_consuming keeps Escape usable normally in applications when
-- the overview is not active.
hl.bind(
    "ESCAPE",
    function()
        if hl.plugin.hyprview then
            hl.plugin.hyprview.toggle("off")
        end
    end,
    {
        non_consuming = true,
        description = "Close window overview",
    }
)

-- Clipboard
bind(
    "Clipboard",
    MOD .. " + V",
    hl.dsp.exec_cmd(
        "sh -lc 'cliphist list "
        .. "| rofi -dmenu -i -p \"Clipboard\" -display-columns 2 "
        .. "| cliphist decode "
        .. "| wl-copy'"
    ),
    "Open clipboard history"
)

-- Clipboard

-- FIXME fancy cliphist but not really working now
bind(
    "Clipboard",
    MOD .. "+ CTRL + V",
    hl.dsp.exec_cmd(apps.clipboard_picker ),
    "Open clipboard history"
)

---------------------------------------------------------------------
-- Screenshots
---------------------------------------------------------------------

bind(
    "Screenshot",
    "Print",
    hl.dsp.exec_cmd(apps.screenshot .. " area"),
    "Screenshot selected area"
)

bind(
    "Screenshot",
    MOD .. " + Print",
    hl.dsp.exec_cmd(apps.screenshot .. " window"),
    "Screenshot active window"
)

bind(
    "Screenshot",
    "SHIFT + Print",
    hl.dsp.exec_cmd(apps.screenshot .. " monitor"),
    "Screenshot current monitor"
)

bind(
    "Screenshot",
    "CTRL + Print",
    hl.dsp.exec_cmd(apps.screenshot .. " all"),
    "Screenshot all monitors"
)

---------------------------------------------------------------------
-- Window state
---------------------------------------------------------------------
bind(
    "Window",
    MOD .. " + SHIFT + Q",
    hl.dsp.window.close(),
    "Close active window"
)

bind(
    "Window",
    MOD .. " + F",
    hl.dsp.window.fullscreen({
        mode = "fullscreen",
        action = "toggle",
    }),
    "Toggle fullscreen"
)


---------------------------------------------------------------------
-- Directional focus
---------------------------------------------------------------------

local directions = {
    {
        name = "left",
        direction = "l",
        keys = { "H", "left" },
    },
    {
        name = "down",
        direction = "d",
        keys = { "J", "down" },
    },
    {
        name = "up",
        direction = "u",
        keys = { "K", "up" },
    },
    {
        name = "right",
        direction = "r",
        keys = { "L", "right" },
    },
}

for _, item in ipairs(directions) do
    for _, key in ipairs(item.keys) do
        bind(
            "Focus",
            MOD .. " + " .. key,
            hl.dsp.focus({
                direction = item.direction,
            }),
            "Focus " .. item.name
        )
    end
end

---------------------------------------------------------------------
-- Directional window movement
---------------------------------------------------------------------

for _, item in ipairs(directions) do
    for _, key in ipairs(item.keys) do
        bind(
            "Movement",
            MOD .. " + SHIFT + " .. key,
            hl.dsp.window.move({
                direction = item.direction,
            }),
            "Move window " .. item.name
        )
    end
end

-- Resize the active window in small keyboard-controlled steps.
local resize_step = 50

bind(
    "Window",
    MOD .. " + CTRL + H",
    hl.dsp.window.resize({
        x = -resize_step,
        y = 0,
        relative = true,
    }),
    "Shrink window horizontally",
    { repeating = true }
)

bind(
    "Window",
    MOD .. " + CTRL + L",
    hl.dsp.window.resize({
        x = resize_step,
        y = 0,
        relative = true,
    }),
    "Grow window horizontally",
    { repeating = true }
)

bind(
    "Window",
    MOD .. " + CTRL + K",
    hl.dsp.window.resize({
        x = 0,
        y = -resize_step,
        relative = true,
    }),
    "Shrink window vertically",
    { repeating = true }
)

bind(
    "Window",
    MOD .. " + CTRL + J",
    hl.dsp.window.resize({
        x = 0,
        y = resize_step,
        relative = true,
    }),
    "Grow window vertically",
    { repeating = true }
)

-- # for arrows
bind(
    "Window",
    MOD .. " + CTRL + left",
    hl.dsp.window.resize({
        x = -resize_step,
        y = 0,
        relative = true,
    }),
    "Shrink window horizontally",
    { repeating = true }
)

bind(
    "Window",
    MOD .. " + CTRL + right",
    hl.dsp.window.resize({
        x = resize_step,
        y = 0,
        relative = true,
    }),
    "Grow window horizontally",
    { repeating = true }
)

bind(
    "Window",
    MOD .. " + CTRL + up",
    hl.dsp.window.resize({
        x = 0,
        y = -resize_step,
        relative = true,
    }),
    "Shrink window vertically",
    { repeating = true }
)

bind(
    "Window",
    MOD .. " + CTRL + down",
    hl.dsp.window.resize({
        x = 0,
        y = resize_step,
        relative = true,
    }),
    "Grow window vertically",
    { repeating = true }
)
---------------------------------------------------------------------
-- Monitor navigation
---------------------------------------------------------------------

local monitor_keys = {
    {
        key = "Y",
        role = "left",
        description = "left",
    },
    {
        key = "X",
        role = "center",
        description = "center",
    },
    {
        key = "C",
        role = "right",
        description = "right",
    },
}

for _, item in ipairs(monitor_keys) do
    local monitor =
        settings.monitors[item.role]

    bind(
        "Monitor",
        MOD .. " + " .. item.key,
        hl.dsp.focus({
            monitor = monitor.output,
        }),
        "Focus " .. item.description .. " monitor"
    )

    bind(
        "Monitor",
        MOD .. " + SHIFT + " .. item.key,
        hl.dsp.window.move({
            monitor = monitor.output,
            follow = true,
        }),
        "Move window to " .. item.description .. " monitor"
    )
end

---------------------------------------------------------------------
-- Monitor-local workspaces
---------------------------------------------------------------------
local function focus_local_workspace(slot)
    return function()
        local workspace = workspaces.for_active_monitor(slot)

        if not workspace then
            return
        end

        hl.dispatch(
            hl.dsp.focus({
                workspace = workspace,
            })
        )
    end
end

local function move_to_local_workspace(slot)
    return function()
        local workspace = workspaces.for_active_monitor(slot)

        if not workspace then
            return
        end

        hl.dispatch(
            hl.dsp.window.move({
                workspace = workspace,
                follow = false,
            })
        )
    end
end

-- Switch every monitor to the same local workspace slot.
--
-- Example:
--   slot 3 -> DP-2:3, DP-1:8, HDMI-A-1:13
--
-- The currently focused monitor is processed last so focus stays there.
local function focus_workspace_on_all_monitors(slot)
    return function()
        local active_monitor = hl.get_active_monitor()
        if not active_monitor then
            return
        end

        -- Switch all other monitors first.
        for _, role in ipairs(settings.monitor_order) do
            local monitor = settings.monitors[role]

            if monitor.output ~= active_monitor.name then
                local workspace =
                    workspaces.for_monitor(monitor.output, slot)

                if workspace then
                    hl.dispatch(
                        hl.dsp.focus({
                            workspace = workspace,
                        })
                    )
                end
            end
        end

        -- Switch the originally focused monitor last.
        -- This also restores keyboard focus to that monitor.
        local workspace =
            workspaces.for_monitor(active_monitor.name, slot)

        if workspace then
            hl.dispatch(
                hl.dsp.focus({
                    workspace = workspace,
                })
            )
        end
    end
end

for slot = 1, settings.workspace_count do
    bind(
        "Workspace",
        MOD .. " + " .. slot,
        focus_local_workspace(slot),
        "Switch to local workspace " .. slot
    )

    bind(
        "Workspace",
        MOD .. " + SHIFT + " .. slot,
        move_to_local_workspace(slot),
        "Move window to local workspace " .. slot
    )

    bind(
        "Workspace",
        MOD .. " + CTRL + " .. slot,
        focus_workspace_on_all_monitors(slot),
        "Switch all monitors to workspace " .. slot
    )
end

-- ------------------------------------------------------------------
-- Workspace layouts
-- ------------------------------------------------------------------

local layouts = {
    "dwindle",
    "master",
    "scrolling",
}

-- Change the tiling engine of only the currently active workspace.
--
-- direction:
--   +1 = next layout
--   -1 = previous layout
local function cycle_workspace_layout(direction)
    return function()
        local workspace =
            hl.get_active_special_workspace() or
            hl.get_active_workspace()

        if not workspace then
            return
        end

        local current = workspace.tiled_layout
        local next_layout = layouts[1]

        for index, layout in ipairs(layouts) do
            if layout == current then
                local next_index =
                    ((index - 1 + direction) % #layouts) + 1

                next_layout = layouts[next_index]
                break
            end
        end

        -- Workspace layouts are workspace-specific. Changing the
        -- layout here does not affect workspaces on the other monitors.
        if workspace.special then
            hl.workspace_rule({
                workspace = tostring(workspace.name),
                layout = next_layout,
            })
        else
            hl.workspace_rule({
                workspace = tostring(workspace.id),
                layout = next_layout,
            })
        end
    end
end

bind(
    "Layout",
    MOD .. " + SPACE",
    cycle_workspace_layout(1),
    "Cycle workspace layout"
)

bind(
    "Layout",
    MOD .. " + SHIFT + SPACE",
    cycle_workspace_layout(-1),
    "Cycle workspace layout backwards"
)
---------------------------------------------------------------------
-- Mouse window movement
---------------------------------------------------------------------

bind(
    "Mouse",
    MOD .. " + mouse:272",
    hl.dsp.window.drag(),
    "Move window with mouse",
    {
        mouse = true,
    }
)

bind(
    "Mouse",
    MOD .. " + mouse:273",
    hl.dsp.window.resize(),
    "Resize window with mouse",
    {
        mouse = true,
    }
)

---------------------------------------------------------------------
-- Volume
---------------------------------------------------------------------

bind(
    "Audio",
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd(
        "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
    ),
    "Volume up",
    {
        locked = true,
        repeating = true,
    }
)

bind(
    "Audio",
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd(
        "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ),
    "Volume down",
    {
        locked = true,
        repeating = true,
    }
)

bind(
    "Audio",
    "XF86AudioMute",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ),
    "Toggle audio mute",
    {
        locked = true,
    }
)

bind(
    "Audio",
    "XF86AudioMicMute",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ),
    "Toggle microphone mute",
    {
        locked = true,
    }
)

---------------------------------------------------------------------
-- Media
---------------------------------------------------------------------

bind(
    "Media",
    "XF86AudioNext",
    hl.dsp.exec_cmd(
        "playerctl next"
    ),
    "Next media track",
    {
        locked = true,
    }
)

bind(
    "Media",
    "XF86AudioPause",
    hl.dsp.exec_cmd(
        "playerctl play-pause"
    ),
    "Play/pause media",
    {
        locked = true,
    }
)

bind(
    "Media",
    "XF86AudioPlay",
    hl.dsp.exec_cmd(
        "playerctl play-pause"
    ),
    "Play/pause media",
    {
        locked = true,
    }
)

bind(
    "Media",
    "XF86AudioPrev",
    hl.dsp.exec_cmd(
        "playerctl previous"
    ),
    "Previous media track",
    {
        locked = true,
    }
)
---------------------------------------------------------------------
-- Brightness
---------------------------------------------------------------------
-- I have no brightness keys soo ... 

-- bind(
--     "Brightness",
--     "XF86MonBrightnessUp",
--     hl.dsp.exec_cmd(
--         "brightnessctl -e4 -n2 set 5%+"
--     ),
--     "Brightness up",
--     {
--         locked = true,
--         repeating = true,
--     }
-- )

-- bind(
--     "Brightness",
--     "XF86MonBrightnessDown",
--     hl.dsp.exec_cmd(
--         "brightnessctl -e4 -n2 set 5%-"
--     ),
--     "Brightness down",
--     {
--         locked = true,
--         repeating = true,
--     }
-- )

---------------------------------------------------------------------
-- Keybind help
---------------------------------------------------------------------

local runtime_dir = os.getenv("XDG_RUNTIME_DIR") or "/tmp"

local help_file = runtime_dir .. "/hyprland-keybinds.txt"

bind(
"Hyprland",
    MOD .. " + F1",
    hl.dsp.exec_cmd(
        "rofi -dmenu -i "
        .. "-p 'Keybindings' "
        .. "< "
        .. help_file
        .. " >/dev/null"
    ),
    "Show keybind help"
)

local file = io.open(
    help_file,
    "w"
)

if file then
    table.sort(
        help_entries,
        function(a, b)
            if a.group == b.group then
                return a.keys < b.keys
            end

            return a.group < b.group
        end
    )

    for _, entry in ipairs(help_entries) do
        file:write(
            string.format(
                "%-12s %-28s %s\n",
                "[" .. entry.group .. "]",
                entry.keys,
                entry.description
            )
        )
    end

    file:close()
end
