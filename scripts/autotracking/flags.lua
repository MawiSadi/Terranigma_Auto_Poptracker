-- scripts/autotracking/flags.lua
local _PENDING_PICKUP = nil  -- { kind="chest"/"event", mapId=..., id=..., ts=..., prev=... }

local function flag_matches(def, addr, mask)
    return def and addr == def.addr and mask == def.mask
end

local function terranigma_event_id_from_flag(addr, mask)
    local bit = mask_to_bit(mask)
    if bit == nil then return nil end
    return ((addr - (EVENT_FLAGS_ADDR or 0)) * 8) + bit
end

local function snapshot_inventory_u16(seg)
    local base = INVENTORY_BASE_ADDR
    local len  = INVENTORY_WATCH_LEN
    local t = {}

    for off = 0, len - 2, 2 do
        local v
        if seg and type(seg.ReadUInt16) == "function" then
            v = terranigma_seg_u16(seg, off)
        else
            v = terranigma_read_u16_abs(base + off)
        end
        t[#t+1] = v or 0
    end

    return t
end

local function chest_value_to_item(value)
    if type(value) ~= "number" then return nil end
    value = value & 0xFFFF

    local lo = value & 0xFF
    local hi = (value >> 8) & 0xFF

    local lo_ok = (INVENTORY_ID_TO_CODE and INVENTORY_ID_TO_CODE[lo]) ~= nil
    local hi_ok = (INVENTORY_ID_TO_CODE and INVENTORY_ID_TO_CODE[hi]) ~= nil

    -- direkter u8-Fall
    if value <= 0xFF and lo_ok then
        return lo, 0, "u8"
    end

    -- konservativer Count-Fall: Item-ID + kleiner Stackcount (0..9)
    -- verhindert alte False Positives wie 0D34, weil 0x0D > 9
    if lo_ok and hi <= 9 then
        return lo, hi, "lo(count)"
    end
    if hi_ok and lo <= 9 then
        return hi, lo, "hi(count)"
    end

    local strobe = INVENTORY_KEYITEM_META_STROBE
    if strobe ~= nil then
        if lo == strobe and hi_ok then return hi, lo, "hi(strobe)" end
        if hi == strobe and lo_ok then return lo, hi, "lo(strobe)" end
    end

    return nil
end

local function fmt_u16(v)
    v = tonumber(v) or 0
    return string.format("%04X(lo=%02X hi=%02X)", v & 0xFFFF, v & 0xFF, (v >> 8) & 0xFF)
end

local function dbg_dump_inventory_diff(label, prev, cur)
    if not AUTOTRACKER_ENABLE_DEBUG_LOGGING then return end

    local maxn = math.max(prev and #prev or 0, cur and #cur or 0)
    local base = INVENTORY_BASE_ADDR or 0
    local changed = 0

    for idx = 1, maxn do
        local oldv = (prev and prev[idx]) or 0
        local newv = (cur and cur[idx]) or 0
        if oldv ~= newv then
            changed = changed + 1

            local lo = newv & 0xFF
            local hi = (newv >> 8) & 0xFF
            local loCode = INVENTORY_ID_TO_CODE and INVENTORY_ID_TO_CODE[lo] or nil
            local hiCode = INVENTORY_ID_TO_CODE and INVENTORY_ID_TO_CODE[hi] or nil

            local addr = base + (idx - 1) * 2
            local itemId, meta, pick = chest_value_to_item(newv)
            local code = itemId and INVENTORY_ID_TO_CODE and INVENTORY_ID_TO_CODE[itemId] or nil

            dbg(
                    "%s diff @%06X %s -> %s item=%s meta=%s pick=%s code=%s lo=%02X loCode=%s hi=%02X hiCode=%s",
                    label,
                    (base + (idx - 1) * 2) & 0xFFFFFF,
                    fmt_u16(oldv),
                    fmt_u16(newv),
                    itemId and string.format("%02X", itemId) or "nil",
                    meta and string.format("%02X", meta & 0xFF) or "nil",
                    tostring(pick),
                    tostring(code),
                    lo,
                    tostring(loCode),
                    hi,
                    tostring(hiCode)
            )
        end
    end

    if changed == 0 then
        dbg("%s diff: <none>", label)
    end
end

local function dbg_pending(label, p)
    if not AUTOTRACKER_ENABLE_DEBUG_LOGGING or not p then return end
    dbg(
            "%s kind=%s map=%04X id=%04X age=%.3f",
            label,
            tostring(p.kind),
            tonumber(p.mapId or 0),
            tonumber(p.id or 0),
            os.clock() - tonumber(p.ts or 0)
    )
end

local function drop_pending(reason, cur_now, preserve_prev)
    if not _PENDING_PICKUP then return end
    local AT = terranigma_state()
    local p = _PENDING_PICKUP
    local cur = cur_now or snapshot_inventory_u16()

    dbg_pending("PENDING DROP", p)
    dbg("%s PICKUP miss map=%04X id=%04X reason=%s",
            string.upper(p.kind), p.mapId or 0, p.id or 0, tostring(reason))
    dbg_dump_inventory_diff(
            string.format("%s/%04X/%04X drop:%s", p.kind, p.mapId or 0, p.id or 0, tostring(reason)),
            p.prev,
            cur
    )

    if not preserve_prev then
        AT.inv_prev = cur
    end
    _PENDING_PICKUP = nil
end

function terranigma_clear_pending_pickup(reason)
    if not _PENDING_PICKUP then return end
    drop_pending(reason or "external_clear", snapshot_inventory_u16(), false)
end

local function make_pending(kind, mapId, id, prev)
    return {
        kind = kind,
        mapId = mapId,
        id = id,
        ts = os.clock(),
        prev = prev,
        candidate_code = nil,
        candidate_addr = nil,
        candidate_pick = nil,
        candidate_hits = 0,
    }
end

local function try_pickup_from_inventory_diff(kind, mapId, id, prev, cur_now)
    local base = INVENTORY_BASE_ADDR or 0
    local candidates = {}
    local changed_words = 0

    for idx = 1, #cur_now do
        local oldv = (prev and prev[idx]) or 0
        local newv = cur_now[idx] or 0
        if newv ~= oldv then
            changed_words = changed_words + 1

            local addr = base + (idx-1)*2
            local value = newv & 0xFFFF
            local itemId, meta, pick = chest_value_to_item(value)
            local code = itemId and INVENTORY_ID_TO_CODE and INVENTORY_ID_TO_CODE[itemId] or nil

            if code then
                candidates[#candidates+1] = {
                    addr   = addr,
                    oldv   = oldv,
                    value  = value,
                    itemId = itemId,
                    meta   = meta or 0,
                    pick   = pick,
                    code   = code,
                }
            end
        end
    end

    if #candidates == 0 then
        dbg("%s PICKUP miss map=%04X id=%04X reason=no_mapped changed_words=%d",
                string.upper(kind), mapId, id, changed_words)
        dbg_dump_inventory_diff(string.format("%s/%04X/%04X no_mapped", kind, mapId, id), prev, cur_now)
        return false, "no_mapped"
    end

    if #candidates > 1 then
        dbg("%s PICKUP miss map=%04X id=%04X reason=ambig candidates=%d changed_words=%d",
                string.upper(kind), mapId, id, #candidates, changed_words)

        for _, c in ipairs(candidates) do
            dbg("%s PICKUP cand @%06X %s -> %s item=%02X meta=%02X pick=%s code=%s",
                    string.upper(kind),
                    c.addr & 0xFFFFFF,
                    fmt_u16(c.oldv),
                    fmt_u16(c.value),
                    c.itemId,
                    c.meta,
                    tostring(c.pick),
                    tostring(c.code))
        end

        dbg_dump_inventory_diff(string.format("%s/%04X/%04X ambig", kind, mapId, id), prev, cur_now)
        return false, "ambig"
    end

    local c = candidates[1]

    local p = _PENDING_PICKUP
    if p and p.kind == kind and p.mapId == mapId and p.id == id then
        if p.candidate_code == c.code and p.candidate_addr == c.addr and p.candidate_pick == c.pick then
            p.candidate_hits = (p.candidate_hits or 0) + 1
        else
            p.candidate_code = c.code
            p.candidate_addr = c.addr
            p.candidate_pick = c.pick
            p.candidate_hits = 1
        end

        local need = (c.pick == "u8") and 2 or 1
        if p.candidate_hits < need then
            dbg("%s PICKUP candidate_wait map=%04X id=%04X inv@%06X item=%02X pick=%s code=%s hits=%d/%d",
                    string.upper(kind), mapId, id, c.addr & 0xFFFFFF, c.itemId, tostring(c.pick), tostring(c.code),
                    p.candidate_hits, need)
            return false, "candidate_wait"
        end
    end

    dbg("%s PICKUP map=%04X id=%04X inv@%06X %s -> item=%02X meta=%02X pick=%s code=%s",
            string.upper(kind), mapId, id, c.addr & 0xFFFFFF, fmt_u16(c.value), c.itemId, c.meta, tostring(c.pick), tostring(c.code))

    if c.code == STARSTONES then
        local qty = tonumber(c.meta) or 0
        if qty <= 0 then qty = 1 end
        qty = math.min(qty, 5)
        set_item_by_qty_or_done(c.code, qty, { mode="stage", never_decrease=true, clamp_max=5 })
    else
        set_item_by_qty_or_done(c.code, 1, { mode="toggle" })
    end

    return true, "ok"
end

local function terranigma_try_finalize_pending(cur_now)
    if not _PENDING_PICKUP then return end

    local AT = terranigma_state()
    local p = _PENDING_PICKUP
    local cur = cur_now or terranigma_snapshot_inventory_u16()

    local ttl = (p.kind == "event") and PENDING_TTL_EVENT or PENDING_TTL_CHEST
    local age = os.clock() - (p.ts or 0)

    local ok, why = try_pickup_from_inventory_diff(
            p.kind,
            p.mapId or 0,
            p.id or 0,
            p.prev,
            cur
    )

    if ok then
        AT.inv_prev = cur
        _PENDING_PICKUP = nil
        return
    end

    if age > ttl then
        dbg("%s PICKUP timeout_final map=%04X id=%04X age=%.3f last_reason=%s",
                string.upper(p.kind),
                p.mapId or 0,
                p.id or 0,
                age,
                tostring(why))
        drop_pending("timeout", cur, false)
        return
    end
end

local function inv_u16_to_item_info(value)
    local itemId, meta, pick = chest_value_to_item(value)
    if not itemId then return nil end

    local code = INVENTORY_ID_TO_CODE and INVENTORY_ID_TO_CODE[itemId] or nil
    if not code then return nil end

    local qty = 1
    if code == STARSTONES then
        qty = tonumber(meta) or 0
        if qty <= 0 then qty = 1 end
        qty = math.min(qty, 5)
    end

    return itemId, code, qty, meta or 0, pick
end

function terranigma_inventory_backfill(cur_now)
    if type(cur_now) ~= "table" then return end
    local AT = terranigma_state()
    AT.inv_present_streak = AT.inv_present_streak or {}

    local present = {} -- [itemId] = { code=..., qty=... }

    -- aktuelles Presence-Set + Qty ermitteln
    for i = 1, #cur_now do
        local itemId, code, qty = inv_u16_to_item_info(cur_now[i])
        if itemId and code then
            local old = present[itemId]
            if not old or qty > old.qty then
                present[itemId] = { code = code, qty = qty }
            end
        end
    end

    -- Streaks pflegen / anwenden
    for itemId, info in pairs(present) do
        local s = (AT.inv_present_streak[itemId] or 0) + 1
        AT.inv_present_streak[itemId] = s

        if info.code == STARSTONES then
            -- Starstones dürfen auch später noch hochgezogen werden
            if s >= 2 then
                local obj = Tracker:FindObjectForCode(info.code)
                local have = (obj and tonumber(obj.CurrentStage)) or 0
                if info.qty > have then
                    set_item_by_qty_or_done(info.code, info.qty, {
                        mode = "stage",
                        never_decrease = true,
                        clamp_max = 5
                    })
                    dbg("INV BACKFILL STAGE: code=%s qty=%d", tostring(info.code), info.qty)
                end
            end
        end
    end

    -- Nicht mehr present => streak reset
    for itemId, _ in pairs(AT.inv_present_streak) do
        if not present[itemId] then
            AT.inv_present_streak[itemId] = 0
        end
    end
end

function terranigma_inventory_reconcile_once(cur_now)
    if type(cur_now) ~= "table" then return end

    for i = 1, #cur_now do
        local itemId, code, qty = inv_u16_to_item_info(cur_now[i])
        if itemId and code then
            if code == STARSTONES then
                set_item_by_qty_or_done(code, qty, {
                    mode = "stage",
                    never_decrease = true,
                    clamp_max = 5
                })
            else
                if Tracker:ProviderCountForCode(code) == 0 then
                    set_item_by_qty_or_done(code, 1, { mode = "toggle" })
                    dbg("INV RECONCILE: set code=%s (id=%02X)", tostring(code), itemId)
                end
            end
        end
    end
end

function autotracker_update_inventory_cache(seg, _def)
    local cur_now = snapshot_inventory_u16()
    local AT = terranigma_state()

    if not AT.inv_ready then
        AT.inv_ready_ticks = (AT.inv_ready_ticks or 0) + 1
        AT.inv_prev = cur_now

        if AT.inv_ready_ticks >= 2 then
            AT.inv_ready = true
            dbg("INV READY after %d ticks", AT.inv_ready_ticks)
        end

        terranigma_inventory_backfill(cur_now)
        return true
    end

    if not AT.inv_reconcile_done then
        terranigma_inventory_reconcile_once(cur_now)
        AT.inv_reconcile_done = true
    end

    terranigma_try_finalize_pending(cur_now)
    terranigma_inventory_backfill(cur_now)
    return true
end

function terranigma_reset_inventory_tracking()
    local AT = terranigma_state()
    _PENDING_PICKUP = nil
    AT.inv_prev = nil
    AT.inv_present_streak = {}
    AT.inv_ready = false
    AT.inv_ready_ticks = 0
    AT.inv_reconcile_done = false
end

function terranigma_reset_flag_snapshots()
    terranigma_reset_inventory_tracking()

    if type(terranigma_reset_chest_snapshot) == "function" then
        terranigma_reset_chest_snapshot()
    end
    if type(terranigma_reset_event_snapshot) == "function" then
        terranigma_reset_event_snapshot()
    end
    if type(terranigma_reset_chest_snapshot_misc) == "function" then
        terranigma_reset_chest_snapshot_misc()
    end
end

local function terranigma_flag_key(addr, mask)
    return string.format("%06X:%02X", addr, mask)
end

local function finalize_or_drop_pending_on_override(newKind, newMap, newId, cur_now)
    if not _PENDING_PICKUP then return end
    if _PENDING_PICKUP.kind == newKind and _PENDING_PICKUP.mapId == newMap and _PENDING_PICKUP.id == newId then
        return
    end

    cur_now = cur_now or snapshot_inventory_u16()

    local p = _PENDING_PICKUP
    local ttl = (p.kind == "event") and PENDING_TTL_EVENT or PENDING_TTL_CHEST
    local age = os.clock() - (p.ts or 0)

    dbg_pending("PENDING OVERRIDE old", p)
    dbg("PENDING OVERRIDE new kind=%s map=%04X id=%04X", tostring(newKind), newMap or 0, newId or 0)

    if age > ttl then
        dbg("PENDING OVERRIDE old expired age=%.3f ttl=%.3f -> drop", age, ttl)
        drop_pending("expired_before_override", cur_now, true)
        return
    end

    local ok_now, why_now = try_pickup_from_inventory_diff(p.kind, p.mapId or 0, p.id or 0, p.prev, cur_now)
    if ok_now then
        terranigma_state().inv_prev = cur_now
        _PENDING_PICKUP = nil
        return
    end

    dbg("PENDING OVERRIDE finalize failed reason=%s", tostring(why_now))
    drop_pending("override", cur_now, true)
end

function terranigma_note_flag(kind, mapId, addr, mask, oldByte, newByte, log_seen)
    if oldByte == nil or newByte == nil then return end
    if terranigma_is_flag_set(oldByte, mask) then return end
    if not terranigma_is_flag_set(newByte, mask) then return end
    if log_seen == nil then log_seen = true end

    local AT = terranigma_state()
    AT.seen_flags = AT.seen_flags or { chest = {}, event = {}, chest_misc = {} }
    local bucket = AT.seen_flags[kind] or {}
    local k = terranigma_flag_key(addr, mask)
    if bucket[k] then return end

    bucket[k] = { mapId = mapId or 0, addr = addr, mask = mask }
    AT.seen_flags[kind] = bucket

    local tab = (terranigma_tab_for_mapid and terranigma_tab_for_mapid(mapId or 0)) or "?"

    local chestId_for_log = nil
    local extra = ""
    if kind == "chest" then
        chestId_for_log = terranigma_chest_id_from_flag(addr, mask)
        extra = string.format(" chestId=%s", chestId_for_log and string.format("%04X", chestId_for_log) or "nil")
    end

    if AUTOTRACKER_ENABLE_DEBUG_LOGGING and log_seen then
        dbg("%s SEEN map=%04X tab=%s @%06X mask=%02X%s  -> paste: { addr=0x%06X, mask=0x%02X },",
                string.upper(kind), mapId or 0, tab, addr, mask, extra, addr, mask)
    end

    if kind == "chest_misc" then
        if MISC_CAPTURE_LEFT <= 0 then return end
        if MISC_CAPTURE_MAP ~= 0 and mapId ~= MISC_CAPTURE_MAP then return end
        MISC_CAPTURE_LEFT = MISC_CAPTURE_LEFT - 1
    end

    if kind == "chest" then
        local map = mapId or 0
        local chestId = terranigma_chest_id_from_flag(addr, mask)
        local cur_now = snapshot_inventory_u16()
        finalize_or_drop_pending_on_override("chest", map, chestId, cur_now)

        AT.inv_prev = AT.inv_prev or cur_now

        _PENDING_PICKUP = make_pending("chest", map, chestId, AT.inv_prev)

        local ok, why = try_pickup_from_inventory_diff(_PENDING_PICKUP.kind, map, chestId, _PENDING_PICKUP.prev, cur_now)
        if ok then
            AT.inv_prev = cur_now
            _PENDING_PICKUP = nil
        else
            dbg("CHEST PICKUP pending map=%04X chestId=%04X reason=%s", map, chestId, tostring(why))
        end
    end

    if kind == "event" then
        local map = mapId or 0
        local eventId = terranigma_event_id_from_flag(addr, mask)

        local menu_max = AUTOTRACKER_RESET_MENU_MAX_MAPID or 0x0010
        if map <= menu_max then
            dbg("EVENT PICKUP skip map=%04X eventId=%04X reason=menuish_map", map, eventId)
            return
        end

        if eventId == nil then
            dbg("EVENT SEEN map=%04X @%06X mask=%02X -> eventId=nil (ignored)", map, addr, mask)
            return
        end

        if  flag_matches(DEFEATED_SYLVAIN_SOUL_GUARD_EVENT, addr, mask) then
            set_item_by_qty_or_done(DEFEATED_SYLVAIN_SOUL_GUARD, 1, { mode="toggle" })
        end

        local cur_now = snapshot_inventory_u16()

        finalize_or_drop_pending_on_override("event", map, eventId, cur_now)

        AT.inv_prev = AT.inv_prev or cur_now

        _PENDING_PICKUP = make_pending("event", map, eventId, AT.inv_prev)

        local ok, why = try_pickup_from_inventory_diff(_PENDING_PICKUP.kind, map, eventId, _PENDING_PICKUP.prev, cur_now)
        if ok then
            AT.inv_prev = cur_now
            _PENDING_PICKUP = nil
        else
            dbg("EVENT PICKUP pending map=%04X eventId=%04X reason=%s", map, eventId, tostring(why))
        end
    end
end

local function make_flag_watcher(kind, base_addr, length, opts)
    opts = opts or {}
    local log_seen = (opts.log_seen ~= false)
    local function snapshot_abs()
        local t = {}
        for i = 0, length-1 do
            t[i] = terranigma_read_u8_abs(base_addr + i) or 0
        end
        return t
    end

    local prev = nil
    local warmup_left = AUTOTRACKER_FLAG_WARMUP_TICKS or 4

    local function reset()
        prev = nil
        warmup_left = AUTOTRACKER_FLAG_WARMUP_TICKS or 4
    end

    local function update(_seg)
        local AT = terranigma_state()

        if not (AT and AT.run_started) then return end

        -- 1) Baseline einmalig setzen
        if prev == nil then
            prev = snapshot_abs()
            dbg("%s flags ARMED (baseline gesetzt)", kind)
            terranigma_sync_chest_groups()
            return
        end

        -- 2) Warmup: keine Rising-Logs, aber trotzdem syncen!
        if warmup_left and warmup_left > 0 then
            warmup_left = warmup_left - 1
            prev = snapshot_abs() -- baseline nachziehen
            terranigma_sync_chest_groups()
            return
        end

        -- 3) Diff gegen aktuellen Zustand
        local cur = snapshot_abs()
        local changed = false
        local rising_count = 0
        local falling_count = 0

        for i=0, length-1 do
            local old = prev[i] or 0
            local new = cur[i] or 0
            if old ~= new then
                changed = true
                for _, m in ipairs(MASKS8) do
                    local was = terranigma_is_flag_set(old, m)
                    local now = terranigma_is_flag_set(new, m)
                    if (not was) and now then
                        rising_count = rising_count + 1
                    elseif was and (not now) then
                        falling_count = falling_count + 1
                    end
                end
            end
        end

        -- 3b) RESET Heuristik: viele fallende Bits + Inventar leer + nicht im Startup-Rauschen
        -- (nur für chest/event, nicht chest_misc)
        if kind ~= "chest_misc" then
            local fall_guard = AUTOTRACKER_FLAG_RESET_FALLING_GUARD_BITS or 80
            if falling_count > fall_guard and type(terranigma_hard_reset) == "function" then
                local age = os.clock() - ((AT.reset and AT.reset.session_clock) or 0)
                local min_age = AUTOTRACKER_RESET_MIN_SESSION_AGE_SEC or 2.0

                if age >= min_age then
                    local mapId = terranigma_read_u16_abs(CURRENT_MAP_ID_ADDR) or 0

                    local menu_max = AUTOTRACKER_RESET_MENU_MAX_MAPID or 0x0010
                    local hard_fall = AUTOTRACKER_FLAG_RESET_FALLING_HARD_BITS or 140

                    if ((mapId <= menu_max) or (falling_count > hard_fall)) then
                        dbg("%s flags: %d falling bits -> HARD RESET (map=%04X)", kind, falling_count, mapId)
                        terranigma_hard_reset(kind .. "_FALLING")
                        return
                    end
                end
            end
        end

        -- 4) Spike-Guard
        local guard = AUTOTRACKER_FLAG_SPIKE_GUARD_BITS or 24
        if rising_count > guard then
            dbg("%s flags: %d rising bits (>%d) -> Log unterdrückt, baseline resync", kind, rising_count, guard)
            prev = cur
            terranigma_sync_chest_groups()
            return
        end

        -- 5) Normalfall: Rising-Edges loggen
        if changed then
            local mapId = terranigma_read_u16_abs(CURRENT_MAP_ID_ADDR) or 0

            for i=0, length-1 do
                local old = prev[i] or 0
                local new = cur[i] or 0
                if old ~= new then
                    if log_seen then
                        for _, m in ipairs(MASKS8) do
                            local was = terranigma_is_flag_set(old, m)
                            local now = terranigma_is_flag_set(new, m)
                            if (not was) and now then
                                terranigma_note_flag(kind, mapId, (base_addr + i), m, old, new, log_seen)
                            end
                        end
                    end
                    prev[i] = new
                end
            end

            terranigma_sync_chest_groups()

            if type(terranigma_oneshot_pump) == "function" then
                terranigma_oneshot_pump()
            end

        end
    end

    return { reset = reset, update = update }
end

local _chest = make_flag_watcher("chest", CHEST_FLAGS_ADDR, CHEST_FLAGS_LEN)
function terranigma_reset_chest_snapshot() _chest.reset() end
function autotracker_update_chest_flags(segment) _chest.update(segment) end

local _event = make_flag_watcher("event", EVENT_FLAGS_ADDR, EVENT_FLAGS_LEN)
function terranigma_reset_event_snapshot() _event.reset() end
function autotracker_update_event_flags(segment) _event.update(segment) end

local _chest_misc = make_flag_watcher("chest_misc", CHEST_MISC_FLAGS_ADDR, CHEST_MISC_FLAGS_LEN,{ log_seen=false })
function terranigma_reset_chest_snapshot_misc() _chest_misc.reset() end
function autotracker_update_chest_flags_misc(segment) _chest_misc.update(segment) end
