-- scripts/autotracking/debug_scan.lua
TERRA_AT = TERRA_AT or {}
TERRA_AT.oneshot = TERRA_AT.oneshot or {}

local function snap_range(base, len)
    local t = {}
    for i=0, len-1 do t[i] = terranigma_read_u8_abs(base+i) end
    return t
end

local function diff_range(tag, base, oldb, newb, len, max)
    max = max or 60
    local n = 0
    for i=0, len-1 do
        local o = oldb[i] or 0
        local v = newb[i] or 0
        if o ~= v then
            n = n + 1
            if n <= max then
                dbg("ONESHOT %s @%06X %02X->%02X", tag, base+i, o, v)
            end
        end
    end
    if n > 0 then
        dbg("ONESHOT %s total=%d changes", tag, n)
    end
    return n
end

-- konfigurierbare Bereiche: starte “nah dran” und erweitere nur wenn nötig
DEBUG_ONESHOT_RANGES = DEBUG_ONESHOT_RANGES or {
    { name="CHEST_FLAGS", base=0x7E0760, len=0x20 },
    { name="EVENT_FLAGS", base=EVENT_FLAGS_ADDR, len=EVENT_FLAGS_LEN },
    { name="INV",         base=0x7F8000, len=0x100 },
    --{ name="WRAM_7E0600", base=0x7E0600, len=0x300 }, -- misc/event-ish zone
    --{ name="WRAM_7E0760", base=0x7E0760, len=0x080 }, -- chest flags area
    --{ name="INV_7F8000",  base=0x7F8000, len=0x120 }, -- inventory + etwas extra
}

function terranigma_oneshot_capture(tag)
    TERRA_AT.oneshot[tag] = {}
    for _, r in ipairs(DEBUG_ONESHOT_RANGES) do
        TERRA_AT.oneshot[tag][r.name] = snap_range(r.base, r.len)
    end
    dbg("ONESHOT %s captured", tag)
end

function terranigma_oneshot_diff(tag)
    local prev = TERRA_AT.oneshot[tag]
    if not prev then return end
    for _, r in ipairs(DEBUG_ONESHOT_RANGES) do
        local now = snap_range(r.base, r.len)
        diff_range(tag .. "/" .. r.name, r.base, prev[r.name], now, r.len)
    end
    TERRA_AT.oneshot[tag] = nil
    dbg("ONESHOT %s done", tag)
end

TERRA_AT = TERRA_AT or {}
TERRA_AT.oneshot_pending = TERRA_AT.oneshot_pending or nil
TERRA_AT.oneshot_delay   = TERRA_AT.oneshot_delay or 0

function terranigma_oneshot_schedule(tag, delay_ticks)
    TERRA_AT.oneshot_pending = tag
    TERRA_AT.oneshot_delay = delay_ticks or 1
    dbg("ONESHOT %s scheduled in %d ticks", tag, TERRA_AT.oneshot_delay)
end

function terranigma_oneshot_pump()
    local tag = TERRA_AT.oneshot_pending
    if not tag then return end

    local d = TERRA_AT.oneshot_delay or 0
    if d > 0 then
        TERRA_AT.oneshot_delay = d - 1
        return
    end

    terranigma_oneshot_diff(tag)
    TERRA_AT.oneshot_pending = nil
end
