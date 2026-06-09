local hs = require("lib.hyprsplit")

---@class Hyprswap
local hyprswap = {
    dsp = {},
}

---@param formatString string
local function log(formatString, ...)
    print(string.format("[hyprswap] " .. formatString, ...))
end

---@param formatString string
local function notify_error(formatString, ...)
    local err = string.format("[hyprswap] error: " .. formatString, ...)
    log(err)
    hl.notification.create({
        text     = err,
        duration = "10000",
        icon     = 3,
        color    = "rgb(ff0000)",
    })
end

---For workspace slots where one side exists and the other does not, pins the
---missing workspace to the correct monitor via workspace_rule so that when
---window.move triggers its creation, it lands on the right monitor.
---No focus changes — no visible side effects.
---@param range1   table
---@param range2   table
---@param monitor1 HL.Monitor
---@param monitor2 HL.Monitor
---@param num_ws   integer
local function pin_missing_workspaces(range1, range2, monitor1, monitor2, num_ws)
    for i = 0, num_ws - 1 do
        local ws1_id = range1.min + i
        local ws2_id = range2.min + i
        local ws1    = hl.get_workspace(ws1_id)
        local ws2    = hl.get_workspace(ws2_id)

        if ws1 and not ws2 then
            hl.workspace_rule({ workspace = tostring(ws2_id), monitor = monitor2.name })
        elseif ws2 and not ws1 then
            hl.workspace_rule({ workspace = tostring(ws1_id), monitor = monitor1.name })
        end
    end
end

---Reads the complete set of window moves needed for the swap without writing
---anything. Separating read from write prevents live-reference issues.
---@param range1 table
---@param range2 table
---@param num_ws integer
---@return { window: HL.Window, target: integer }[]
local function build_move_plan(range1, range2, num_ws)
    local plan = {}

    for i = 0, num_ws - 1 do
        local ws1_id = range1.min + i
        local ws2_id = range2.min + i
        local ws1    = hl.get_workspace(ws1_id)
        local ws2    = hl.get_workspace(ws2_id)

        if ws1 then
            for _, win in ipairs(hl.get_workspace_windows(ws1)) do
                if win.mapped then
                    table.insert(plan, { window = win, target = ws2_id })
                end
            end
        end

        if ws2 then
            for _, win in ipairs(hl.get_workspace_windows(ws2)) do
                if win.mapped then
                    table.insert(plan, { window = win, target = ws1_id })
                end
            end
        end
    end

    return plan
end

---Swaps window content between two monitors across all hyprsplit workspace pairs.
---@param monitor1 HL.Monitor
---@param monitor2 HL.Monitor
local function swap_decks(monitor1, monitor2)
    local range1 = hs.MonitorRange:new(monitor1)
    local range2 = hs.MonitorRange:new(monitor2)
    local num_ws = hs.get_config("num_workspaces")

    -- Phase 1: guarantee missing target workspaces go to the right monitor on creation.
    pin_missing_workspaces(range1, range2, monitor1, monitor2, num_ws)

    -- Phase 2: read complete state — no writes yet.
    local plan = build_move_plan(range1, range2, num_ws)

    log("swap: %s <-> %s (%d windows)", monitor1.name, monitor2.name, #plan)

    -- Phase 3: execute all moves.
    for _, entry in ipairs(plan) do
        hl.dispatch(hl.dsp.window.move({ workspace = entry.target, window = entry.window, follow = false }))
    end
end

---Swap the entire workspace deck between two monitors.
---@param args table  { monitor1: HL.MonitorSelector, monitor2: HL.MonitorSelector }
---@return function
function hyprswap.dsp.swap(args)
    if args == nil or args.monitor1 == nil or args.monitor2 == nil then
        notify_error("dsp.swap: monitor1 and monitor2 are required")
        return function() end
    end

    return function()
        local cursor_no_warps_orig    = hl.get_config("cursor.no_warps")
        local animations_enabled_orig = hl.get_config("animations.enabled")
        hl.config({ cursor = { no_warps = true }, animations = { enabled = false } })

        local function restore_configs()
            hl.config({
                cursor     = { no_warps = cursor_no_warps_orig },
                animations = { enabled  = animations_enabled_orig },
            })
        end

        local monitor1 = hl.get_monitor(args.monitor1)
        local monitor2 = hl.get_monitor(args.monitor2)

        if monitor1 == nil or monitor1.is_mirror or monitor1.id == -1
        or monitor2 == nil or monitor2.is_mirror or monitor2.id == -1 then
            notify_error("dsp.swap: could not resolve monitor1 or monitor2")
            restore_configs()
            return
        end

        if monitor1.id == monitor2.id then
            log("dsp.swap: both monitors are the same, skipping")
            restore_configs()
            return
        end

        local orig_focused  = hl.get_active_monitor()

        -- Identify the other monitor relative to the user and snapshot its
        -- active workspace before any state changes.
        local other_monitor = orig_focused and (
            (orig_focused.id == monitor1.id and monitor2) or
            (orig_focused.id == monitor2.id and monitor1)
        ) or nil
        local active_other  = other_monitor
            and other_monitor.active_workspace
            and other_monitor.active_workspace.id

        swap_decks(monitor1, monitor2)

        -- Restore animations before focus so the workspace reveal animates.
        restore_configs()

        if orig_focused then
            hl.dispatch(hl.dsp.focus({ monitor = orig_focused }))

            -- Focus the workspace that corresponds to what was active on the
            -- other monitor: same slot offset, different range base.
            if active_other and other_monitor then
                local range_orig  = hs.MonitorRange:new(orig_focused)
                local range_other = hs.MonitorRange:new(other_monitor)
                local target_ws   = range_orig.min + (active_other - range_other.min)
                hl.dispatch(hl.dsp.focus({ workspace = target_ws, on_current_monitor = true }))
            end
        end
    end
end

return hyprswap
