ScriptHost:LoadScript("scripts/autotracking/mappings/tab_mapping.lua")

local _lastTab = nil

local function is_auto_map_switch_enabled()
    local enabled =  Tracker:ProviderCountForCode("opt_auto_map_switch_on") == 1
    return enabled ~= nil and enabled
end

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

    -- RUN START debounce (2 Ticks > menu_max)
    if type(terranigma_runstart_tick) == "function" then
        terranigma_runstart_tick(mapId)
    end

    -- UI Tab switching nur wenn Option aktiv
    if not is_auto_map_switch_enabled() then return end

    local tabPath = tab_for_mapid(mapId)
    dbg("mapId=%04X -> tab=%s", mapId, tabPath)

    if tabPath ~= _lastTab then
        activateTabPath(tabPath)
        _lastTab = tabPath
    end
end
