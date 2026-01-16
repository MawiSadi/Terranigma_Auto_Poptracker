-- scripts/autotracking.lua
ScriptHost:LoadScript("scripts/autotracking/utils.lua")
ScriptHost:LoadScript("scripts/autotracking/constants.lua")

ScriptHost:LoadScript("scripts/autotracking/mappings/locations_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/mappings/tab_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/mappings/chest_groups.lua")

ScriptHost:LoadScript("scripts/autotracking/inventory_items.lua")
ScriptHost:LoadScript("scripts/autotracking/location_sync.lua")
ScriptHost:LoadScript("scripts/autotracking/flags.lua")
ScriptHost:LoadScript("scripts/autotracking/map_tabs.lua")
ScriptHost:LoadScript("scripts/autotracking/debug_scan.lua")

local WATCHES_REGISTERED = (_G.__TERRANIGMA_WATCHES_REGISTERED == true)

local function register_watch(def)
    local cb = _G[def.callback]
    if type(cb) ~= "function" then
        dbg("WARN: Callback '%s' für Watch '%s' nicht gefunden", tostring(def.callback), tostring(def.name))
        return
    end

    if type(def.addr) ~= "number" or type(def.length) ~= "number" then
        dbg("WARN: Watch '%s' hat ungültige addr/length: addr=%s len=%s",
                tostring(def.name), tostring(def.addr), tostring(def.length))
        return
    end

    local function wrapped(segment)
        local ok, err = pcall(cb, segment, def)
        if not ok then
            dbg("Fehler in Watch '%s': %s", tostring(def.name), tostring(err))
        end
    end

    dbg("register watch: %s addr=%06X len=%d interval=%s cb=%s",
            tostring(def.name), def.addr, def.length, tostring(def.interval_ms), tostring(def.callback))

    if def.interval_ms then
        ScriptHost:AddMemoryWatch(def.name, def.addr, def.length, wrapped, def.interval_ms)
    else
        ScriptHost:AddMemoryWatch(def.name, def.addr, def.length, wrapped)
    end
end

local function register_all_watches_once()
    dbg("AUTOTRACKER_ENABLE=%s, ITEM_WATCHES=%s", tostring(AUTOTRACKER_ENABLE), type(ITEM_WATCHES))

    if WATCHES_REGISTERED then return end
    WATCHES_REGISTERED = true
    _G.__TERRANIGMA_WATCHES_REGISTERED = true

    if AUTOTRACKER_ENABLE and type(ITEM_WATCHES) == "table" then
        for _, def in ipairs(ITEM_WATCHES) do register_watch(def) end
    end

    register_watch({
        name="terranigma_current_map",
        addr=CURRENT_MAP_ID_ADDR,
        length=2,
        callback="updateCurrentMap",
        interval_ms=250
    })

    register_watch({
        name="terra_inventory_items",
        addr=INVENTORY_ITEMS_ADDR,
        length=INVENTORY_ITEMS_LEN,
        callback="autotracker_update_inventory_items",
        interval_ms=250
    })

    if AUTOTRACKER_ENABLE and type(LOCATION_WATCHES) == "table" then
        for _, def in ipairs(LOCATION_WATCHES) do register_watch(def) end
    end

    if AUTOTRACKER_ENABLE_DEBUG_SCAN and type(DEBUG_SCAN_WATCHES) == "table" then
        for _, def in ipairs(DEBUG_SCAN_WATCHES) do register_watch(def) end
    end
end

register_all_watches_once()

function autotracker_started()
    pcall(function()
        if AUTOTRACKER_LOG_TO_FILE then
            local f = io.open(AUTOTRACKER_LOG_FILE, "w")
            if f then f:write("") f:close() end
        end
    end)

    dbg("autotracker_started()")
    dbg("START state snowleaf=%s ruby=%s",
            tostring(Tracker:FindObjectForCode("snowleaf") and Tracker:FindObjectForCode("snowleaf").Active),
            tostring(Tracker:FindObjectForCode("ruby") and Tracker:FindObjectForCode("ruby").Active)
    )

    local mapId = AutoTracker:ReadU16(CURRENT_MAP_ID_ADDR)
    dbg("MapId initial: %s", mapId and string.format("%04X", mapId) or "nil")

    pcall(terranigma_reset_flag_snapshots)
    pcall(terranigma_reset_debug_scan)

    -- Initialer Sync, damit dein Tracker direkt “richtig” ist
    pcall(function() updateCurrentMap(nil) end)
    pcall(function() terranigma_sync_chest_groups() end)
    pcall(terranigma_reset_inventory_snapshot)
end

function autotracker_stopped()
    dbg("autotracker_stopped()")
end
