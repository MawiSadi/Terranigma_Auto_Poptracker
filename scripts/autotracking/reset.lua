-- scripts/autotracking/reset.lua

-- wird beim Laden des Trackers aufgerufen (autotracker_started -> terranigma_mark_session_start)
function terranigma_mark_session_start()
    local AT = terranigma_state()
    AT.reset = AT.reset or {}

    local r = AT.reset
    r.session_id = (r.session_id or 0) + 1
    r.session_clock = os.clock()

    AT.loc_cache = {}
    AT.chest_stage_cache = {}

    r.above_menu_streak = 0
    r.run_started = false
    AT.run_started = false

    dbg("session start id=%d", r.session_id)

    if type(terranigma_clear_tracker_items) == "function" then
        dbg("FORCE CLEAR tracker items (override loaded state)")
        terranigma_clear_tracker_items()
    end
end

-- Debounce: run_started=true erst nach 2 Ticks > menu_max
function terranigma_runstart_tick(mapId)
    local AT = terranigma_state()
    AT.reset = AT.reset or {}
    local r = AT.reset
    AT.seen_flags = { chest = {}, event = {}, chest_misc = {} }

    local menu_max = AUTOTRACKER_RESET_MENU_MAX_MAPID or 0x0010
    local need = 2

    if type(mapId) ~= "number" then return false end

    if mapId <= menu_max then
        r.above_menu_streak = 0
        -- run_started NICHT automatisch wieder false machen (sonst flackert man bei Übergängen)
        return (AT.run_started == true)
    end

    -- mapId ist gameplay-ish
    r.above_menu_streak = (r.above_menu_streak or 0) + 1

    if not r.run_started and r.above_menu_streak >= need then
        r.run_started = true
        AT.run_started = true

        dbg("RUN START detected at map=%04X -> resetting snapshots", mapId)

        -- harte Baselines neu setzen (damit keine Menü-Spikes als SEEN zählen)
        if type(terranigma_reset_flag_snapshots) == "function" then
            terranigma_reset_flag_snapshots()
        end
    end

    return (AT.run_started == true)
end
