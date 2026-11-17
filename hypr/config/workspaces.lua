local settings = require("config.settings")

local M = {}

---------------------------------------------------------------------
-- Workspace ownership
---------------------------------------------------------------------

for _, role in ipairs(settings.monitor_order) do
    local monitor = settings.monitors[role]

    for slot = 1, settings.workspace_count do
        local id =
            monitor.workspace_first
            + slot
            - 1

        hl.workspace_rule({
            workspace = tostring(id),
            monitor = monitor.output,
            persistent = true,
            default = slot == 1,
        })
    end
end

---------------------------------------------------------------------
-- Local workspace resolution
---------------------------------------------------------------------

function M.for_monitor(monitor_name, slot)
    if not monitor_name then
        return nil
    end

    for _, role in ipairs(settings.monitor_order) do
        local monitor = settings.monitors[role]

        if monitor.output == monitor_name then
            return
                monitor.workspace_first
                + slot
                - 1
        end
    end

    return nil
end

function M.for_active_monitor(slot)
    local monitor = hl.get_active_monitor()

    if not monitor then
        return nil
    end

    return M.for_monitor(
        monitor.name,
        slot
    )
end

return M