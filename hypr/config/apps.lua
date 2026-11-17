local home_dir = os.getenv("HOME") 
local hypr_scripts = home_dir .. "/.config/hypr/scripts/"


-- $HOME/.config/rofi/sx/clipboard.rasi
return {
    terminal = "alacritty",
    file_manager = "dolphin",

    -- Desktop applications, not arbitrary executables.
    -- launcher = "rofi -show drun  -theme '" .. home_dir .. ".config/rofi/sx/windows11-grid-light.rasi'",
    launcher = "rofi -show drun",

    screenshot = hypr_scripts .. "screenshot.sh",
    clipboard_picker = hypr_scripts .. "cliphist.sh",
}


-- Set programs that you use
-- local menu = "rofi -show run"
