-- New GPT generated...
-- modules/wallpaper_library.lua
-- Provides wallpaper list + searching + metadata

local gears = require("gears")
local lfs   = require("lfs")

local M = {}
local dir  = gears.filesystem.get_configuration_dir() .. "wallpaper/"

-- cache
local list = {}

local function load()
    local t = {}
    for f in lfs.dir(dir) do
        if f:match("%.png$") or f:match("%.jpg$") then
            table.insert(t, f)
        end
    end
    table.sort(t)
    list = t
end

-- search (case-insensitive)
function M.search(query)
    if not query or query == "" then return list end
    local q = query:lower()
    local filtered = {}
    for _, f in ipairs(list) do
        if f:lower():match(q) then
            table.insert(filtered, f)
        end
    end
    return filtered
end

function M.fullpath(file)
    return dir .. file
end

load()
return M

