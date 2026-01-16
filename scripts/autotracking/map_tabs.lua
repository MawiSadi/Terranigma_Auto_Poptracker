ScriptHost:LoadScript("scripts/autotracking/mappings/tab_mapping.lua")

local _lastTab = nil

local function activateTabPath(path)
    for seg in string.gmatch(path, "[^/]+") do
        Tracker:UiHint("ActivateTab", seg)
    end
end

local function tab_for_mapid(mapId)
    if TERRANIGMA_TAB_RANGES ~= nil then
        for _, r in ipairs(TERRANIGMA_TAB_RANGES) do
            if mapId >= r.from and mapId <= r.to then
                return r.tab
            end
        end
    end
    return "Overworld"
end

function terranigma_tab_for_mapid(mapId)
    return tab_for_mapid(mapId)
end

function updateCurrentMap(_)
    local mapId = AutoTracker:ReadU16(CURRENT_MAP_ID_ADDR)
    if mapId == nil then return end

    local tabPath = tab_for_mapid(mapId)
    dbg("mapId=%04X -> tab=%s", mapId, tabPath)

    if tabPath ~= _lastTab then
        activateTabPath(tabPath)
        _lastTab = tabPath
    end

    if mapId == 0x02CD and not TERRA_AT.litz_capture_armed then
        TERRA_AT.litz_capture_armed = true

        -- misc watcher baseline neu setzen (wichtig!)
        if terranigma_reset_chest_snapshot_misc then terranigma_reset_chest_snapshot_misc() end

        -- seen bucket für misc leeren (damit Rising-Edges wieder kommen)
        TERRA_AT.seen_flags = TERRA_AT.seen_flags or {}
        TERRA_AT.seen_flags["chest_misc"] = {}

        -- jetzt die nächsten X misc-rising logs zulassen
        MISC_CAPTURE_MAP = 0x02CD
        MISC_CAPTURE_LEFT = 30

        dbg("LITZ CAPTURE ARMED: open the chest now")
    end
end
