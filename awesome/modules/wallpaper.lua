-- New GPT generated...
-- modules/wallpaper.lua
-- Handles saving, applying and blurring wallpapers

local awful     = require("awful")
local gears     = require("gears")
local naughty   = require("naughty")
local beautiful = require("beautiful")

local M = {}

local config_dir = gears.filesystem.get_configuration_dir()
local file_saved = config_dir .. "/selected_wallpaper.txt"

-- read saved wallpaper path
local function load_saved()
    local f = io.open(file_saved, "r")
    if not f then return nil end
    local p = f:read("*a")
    f:close()
    return (gears.filesystem.file_readable(p) and p) or nil
end

local function save(path)
    local f = io.open(file_saved, "w")
    if not f then
        naughty.notify({preset=naughty.config.presets.critical, text="Cannot save wallpaper"})
        return
    end
    f:write(path)
    f:close()
end

-- apply wallpaper to all screens
local function apply(path)
    for s in screen do
        gears.wallpaper.maximized(path, s, true)
    end
end

-- generate blurred version (async)
local function blurred_path(path)
    return path:gsub("(/)([^/]+)$", "/blurred/%2")
end

local function ensure_blurred(path)
    local out = blurred_path(path)
    if not gears.filesystem.file_readable(out) then
        awful.spawn.with_shell(string.format(
            "convert -filter Gaussian -blur 0x20 '%s' '%s'",
            path, out
        ))
    end
    return out
end

-- public API
function M.set(path)
    save(path)
    apply(path)
    awesome.emit_signal("wallpaper::changed", path)
end

function M.set_blurred(path)
    local blurred = ensure_blurred(path)
    apply(blurred)
end

M.current = load_saved()

if M.current then apply(M.current) end

return M

