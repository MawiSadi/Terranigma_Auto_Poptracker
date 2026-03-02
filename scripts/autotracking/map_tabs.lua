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

local function tab_for_mapid(mapId, prevMapId)
    if TERRANIGMA_TAB_RANGES ~= nil then
        for _, r in ipairs(TERRANIGMA_TAB_RANGES) do
            if mapId >= r.from and mapId <= r.to then
                -- 1) prev_any list
                if type(r.prev_any) == "table" then
                    if prevMapId ~= nil then
                        for _, v in ipairs(r.prev_any) do
                            if prevMapId == v then
                                return r.tab
                            end
                        end
                    end
                    -- 2) prev range
                elseif r.prev_from ~= nil then
                    local pto = r.prev_to or r.prev_from  -- single value allowed
                    if prevMapId ~= nil and prevMapId >= r.prev_from and prevMapId <= pto then
                        return r.tab
                    end
                    -- 3) default
                else
                    return r.tab
                end
            end
        end
    end
    return "Overworld"
end

function terranigma_tab_for_mapid(mapId)
    local AT = terranigma_state()
    return tab_for_mapid(mapId, AT and AT.prev_mapId)
end

function updateCurrentMap(_)
    local mapId = AutoTracker:ReadU16(CURRENT_MAP_ID_ADDR)
    if mapId == nil then return end

    -- RUN START debounce (2 Ticks > menu_max)
    if type(terranigma_runstart_tick) == "function" then
        terranigma_runstart_tick(mapId)
    end

    local AT = terranigma_state()
    AT.cur_mapId = AT.cur_mapId or mapId
    AT.prev_mapId = AT.prev_mapId or mapId

    -- prev nur dann updaten, wenn sich mapId ändert
    if mapId ~= AT.cur_mapId then
        AT.prev_mapId = AT.cur_mapId
        AT.cur_mapId = mapId
        dbg("MAP CHANGE prev=%04X cur=%04X", AT.prev_mapId, AT.cur_mapId)
    end

    AT.visited_maps = AT.visited_maps or {}

    if mapId == RA_TREE_ENTRY_MAP and not AT.visited_maps[RA_TREE_ENTRY_MAP] then
        AT.visited_maps[RA_TREE_ENTRY_MAP] = true
        set_item_by_qty_or_done(VISITED_RA_TREE, 1, { mode="toggle" })
    end

    -- UI Tab switching nur wenn Option aktiv
    if not is_auto_map_switch_enabled() then return end

    local tabPath = tab_for_mapid(mapId, AT.prev_mapId)
    dbg("mapId=%04X prev=%04X -> tab=%s", mapId, AT.prev_mapId, tabPath)

    if tabPath ~= _lastTab then
        activateTabPath(tabPath)
        _lastTab = tabPath
    end
end
