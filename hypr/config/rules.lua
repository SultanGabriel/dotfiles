
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

-- Leave out until an application gives us a reason to suppress it.
-- local suppressMaximizeRule = hl.window_rule({
--     -- Ignore maximize requests from all apps. You'll probably like this.
--     name           = "suppress-maximize-events",
--     match          = { class = ".*" },

--     suppress_event = "maximize",
-- })
-- -- suppressMaximizeRule:set_enabled(false)

-- Fix some dragging issues with XWayland
hl.window_rule({
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})


hl.window_rule({
    name = "pycharm-project-tool-window",

    match = {
        class = "^jetbrains-(pycharm|webstorm|idea|clion)$",
        initial_title = "^Project - .+$",
    },

    -- Treat the detached Project view as a floating side panel.
    -- float = true,

    -- Always place it on the left monitor.
    monitor = "DP-3",
    tile=true,

    -- Thin full-height panel.
    -- size = {
    --     300,
    --     980
    -- },
    --
    -- -- Place it against the right edge of the left monitor.
    -- move = {
    --     1600,
    --     60,
    -- },
})

hl.window_rule({
    name = "hyprland-share-picker",

    match = {
        class = "^hyprland-share-picker$",
        initial_title = "^Select what to share$",
    },

    -- Keep it out of the tiling layout.
    float = true,

    -- Give it a sensible default size.
    size = {
        800,
        450,
    },

    -- Center it on whichever monitor it opens on.
    center = true,

    -- Keep it visible across workspace changes.
    pin = true,
})

-- SX Settings window
hl.window_rule({
    name = "sx-settings",

    match = {
        class = "^sx-settings$",
    },


    float = true,
    center = true,
    size = { 720, 480 },
    rounding = 10,
})
