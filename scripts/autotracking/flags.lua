-- scripts/autotracking/flags.lua
local _PENDING_PICKUP = nil  -- { kind="chest"/"event", mapId=..., id=..., ts=..., prev=... }
local _PENDING_TTL_SEC = 2.0
local _SEG_INV = nil

local function terranigma_event_id_from_flag(addr, mask)
    local bit = mask_to_bit(mask)
    if bit == nil then return nil end
    return ((addr - (EVENT_FLAGS_ADDR or 0)) * 8) + bit
end

local function snapshot_inventory_u16()
    local base = INVENTORY_BASE_ADDR
    local len  = INVENTORY_WATCH_LEN
    local t = {}

    for off = 0, len - 2, 2 do
        local addr = base + off
        local v
        if _SEG_INV and type(_SEG_INV.ReadUInt16) == "function" then
            v = _SEG_INV:ReadUInt16(addr)
        else
            v = terranigma_read_u16_abs(addr)
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

    if value <= 0xFF and lo_ok then
        return lo, 0, "u8"
    end

    local strobe = INVENTORY_KEYITEM_META_STROBE
    if strobe ~= nil then
        if lo == strobe and hi_ok then return hi, lo, "hi(strobe)" end
        if hi == strobe and lo_ok then return lo, hi, "lo(strobe)" end
    end

    -- Eindeutig: genau eins ist ein bekanntes Item
    if hi_ok and (not lo_ok) then return hi, lo, "hi" end
    if lo_ok and (not hi_ok) then return lo, hi, "lo" end

    -- Ambiguous: beide Bytes sind bekannte Item-IDs
    -- Default: ID im hi-Byte, Meta/Qty im lo-Byte
    if hi_ok and lo_ok then
        return hi, lo, "ambig->hi"
    end

    return nil
end

local function try_pickup_from_inventory_diff(kind, mapId, id, prev, cur_now)
    local base = INVENTORY_BASE_ADDR or 0
    local candidates = {}

    for idx = 1, #cur_now do
        if cur_now[idx] ~= ((prev and prev[idx]) or 0) then
            local value = cur_now[idx] & 0xFFFF
            local itemId, meta, pick = chest_value_to_item(value)
            local code = itemId and INVENTORY_ID_TO_CODE and INVENTORY_ID_TO_CODE[itemId] or nil
            if code then
                candidates[#candidates+1] = {
                    addr  = base + (idx-1)*2,
                    value = value,
                    itemId = itemId,
                    meta  = meta or 0,
                    pick  = pick,
                    code  = code,
                }
            end
        end
    end

    if #candidates == 0 then
        return false, "no_mapped"
    end
    if #candidates > 1 then
        dbg("%s PICKUP miss map=%04X id=%04X (inv diff ambig, candidates=%d)", string.upper(kind), mapId, id, #candidates)
        return false, "ambig"
    end

    local c = candidates[1]
    dbg("%s PICKUP map=%04X id=%04X inv@%06X value=%04X -> item=%02X meta=%02X pick=%s code=%s",
            string.upper(kind), mapId, id, c.addr & 0xFFFFFF, c.value, c.itemId, c.meta, tostring(c.pick), tostring(c.code))

    if c.code == "starstones" then
        local qty = tonumber(c.meta) or 0
        if qty <= 0 then qty = 1 end
        qty = math.min(qty, 5)
        set_item_by_qty_or_done(c.code, qty, { mode="stage", never_decrease=true, clamp_max=5 })
    else
        set_item_by_qty_or_done(c.code, 1, { mode="toggle" })
    end

    return true, "ok"
end

local function drop_pending(reason, cur_now)
    if not _PENDING_PICKUP then return end
    local AT = terranigma_state()
    local p = _PENDING_PICKUP
    local cur = cur_now or snapshot_inventory_u16()

    dbg("%s PICKUP miss map=%04X id=%04X reason=%s",
            string.upper(p.kind), p.mapId or 0, p.id or 0, tostring(reason))

    AT.inv_prev = cur
    _PENDING_PICKUP = nil
end

local function terranigma_try_finalize_pending()
    if not _PENDING_PICKUP then return end
    local AT = terranigma_state()
    local p = _PENDING_PICKUP
    local cur = snapshot_inventory_u16()

    if (os.clock() - (p.ts or 0)) > _PENDING_TTL_SEC then
        drop_pending("timeout", cur)
        return
    end

    local ok = select(1, try_pickup_from_inventory_diff(p.kind, p.mapId or 0, p.id or 0, p.prev, cur))
    if ok then
        AT.inv_prev = cur
        _PENDING_PICKUP = nil
    end
end

function autotracker_update_inventory_cache(seg, _def)
    _SEG_INV = seg
    terranigma_try_finalize_pending()
    return true
end

local function reset_inventory_snapshot()
    local AT = terranigma_state()
    AT.inv_prev = snapshot_inventory_u16()
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
    -- Versuch: passt evtl. inzwischen
    local p = _PENDING_PICKUP
    local ok_now = select(1, try_pickup_from_inventory_diff(p.kind, p.mapId or 0, p.id or 0, p.prev, cur_now))
    if ok_now then
        terranigma_state().inv_prev = cur_now
        _PENDING_PICKUP = nil
        return
    end

    -- sonst: droppen, aber baseline auf cur_now ziehen (sonst “klingelt’s” später wieder)
    drop_pending("overridden", cur_now)
end

function terranigma_note_flag(kind, mapId, addr, mask, oldByte, newByte, log_seen)
    if oldByte == nil or newByte == nil then return end
    if terranigma_is_flag_set(oldByte, mask) then return end
    if not terranigma_is_flag_set(newByte, mask) then return end
    if log_seen == nil then log_seen = true end

    local AT = terranigma_state()

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

        _PENDING_PICKUP = { kind="chest", mapId=map, id=chestId, ts=os.clock(), prev=AT.inv_prev }

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
        local eventId = terranigma_event_id_from_flag(addr, mask) -- <- das ist genau wofür die Funktion da ist

        if eventId == nil then
            dbg("EVENT SEEN map=%04X @%06X mask=%02X -> eventId=nil (ignored)", map, addr, mask)
            return
        end
        local cur_now = snapshot_inventory_u16()

        finalize_or_drop_pending_on_override("event", map, eventId, cur_now)

        AT.inv_prev = AT.inv_prev or cur_now

        _PENDING_PICKUP = { kind="event", mapId=map, id=eventId, ts=os.clock(), prev=AT.inv_prev }

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
            if kind == "chest" then
                reset_inventory_snapshot()
            end
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
