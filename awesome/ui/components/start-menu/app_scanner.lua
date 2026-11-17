local gears = require("gears")
local lfs = require("lfs")

local app_scanner = {}

local desktop_dirs = {
    "/usr/share/applications",
    "/usr/local/share/applications",
    os.getenv("HOME") .. "/.local/share/applications",
}

local function parse_desktop_file(path)
    local name, exec, icon

    for line in io.lines(path) do
        if line:match("^Name=") then
            name = line:match("^Name=(.*)")
        elseif line:match("^Exec=") then
            exec = line:match("^Exec=(.*)")
            exec = exec:gsub(" %%[fFuUdDnNickvm]", "") -- remove placeholders
        elseif line:match("^Icon=") then
            icon = line:match("^Icon=(.*)")
        end
    end

    if name and exec then
        return {
            name = name,
            exec = exec,
            icon = icon
        }
    end
end

function app_scanner.scan()
    local apps = {}

    for _, dir in ipairs(desktop_dirs) do
        local ok = lfs.attributes(dir)
        if ok then
            for file in lfs.dir(dir) do
                if file:match("%.desktop$") then
                    local entry = parse_desktop_file(dir .. "/" .. file)
                    if entry then table.insert(apps, entry) end
                end
            end
        end
    end

    table.sort(apps, function(a,b) return a.name < b.name end)

    return apps
end

return app_scanner

