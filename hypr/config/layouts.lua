-- ------------------------------------------------------------------
-- Tiling layouts
-- ------------------------------------------------------------------
--   dwindle
--   master - Default
--   scrolling


hl.config({
    general = {
        -- Default tiling layout for workspaces that do not have
        -- an explicit workspace-specific layout override.
        layout = "dwindle",
    },

    -- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ 
    dwindle = {
        -- Keep split orientation stable once a split has been created.
        preserve_split = true,
    },

    master = {
        -- New windows join the secondary stack instead of replacing
        -- the current master window.
        new_status = "slave",

        -- Fraction of the workspace reserved for the master area.
        mfact = 0.55,
    },

    scrolling = {
        -- New columns occupy half of the monitor by default.
        column_width = 0.5,

        -- Bring the focused column fully into view when possible.
        focus_fit_method = 1,

        -- Keep the focused window visible automatically.
        follow_focus = true,

        -- A workspace containing one scrolling column fills the screen.
        fullscreen_on_one_column = true,
    },
})