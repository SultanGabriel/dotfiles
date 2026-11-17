local M = {}

M.mod = "SUPER"
-- M.mod = "ALT"

local HOME_DIR = os.getenv("HOME") 

M.apps = {
    terminal = "alacritty",
    file_manager = "dolphin",
    launcher = HOME_DIR .. "/.config/hypr/scripts/rofi-launcher.sh 2 3", -- 2 3 also i liked
    launcher_big = HOME_DIR .. "/.config/hypr/scripts/rofi-launcher.sh 1 15",
    dock = HOME_DIR .. "/.config/hypr/scripts/sx-taskbar.sh start",
    sx_settings =  HOME_DIR .. "/.config/hypr/scripts/sx-settings-open.sh",
}

M.workspace_count = 5

M.monitors = {
    left = {
        output = "DP-3",
        mode = "1920x1080@60",
        position = "0x0",
        scale = 1,

        workspace_first = 1,
    },

    center = {
        output = "DP-1",
        mode = "1920x1080@100",
        position = "1920x0",
        scale = 1,

        workspace_first = 6,
    },

    right = {
        output = "HDMI-A-1",
        mode = "1920x1080@59.94",
        position = "3840x0",
        scale = 1,

        workspace_first = 11,
    },
}

M.monitor_order = {
    "left",
    "center",
    "right",
}

return M