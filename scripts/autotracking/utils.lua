if _G.dbg == nil then
    function dbg(fmt, ...)
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
            print(string.format("[autotracker] " .. fmt, ...))
        end
    end
end
MISC_CAPTURE_LEFT = MISC_CAPTURE_LEFT or 0
MISC_CAPTURE_MAP  = MISC_CAPTURE_MAP  or 0
MASKS8 = MASKS8 or {1,2,4,8,16,32,64,128}

local CHEST_FLAGS_BASE = 0x7E0760

local function mask_to_bit_index(mask)
    for i = 0, 7 do
        if MASKS8[i+1] == mask then return i end
    end
    return nil
end

function terranigma_chest_id_from_flag(addr, mask)
    local bit = mask_to_bit_index(mask)
    if not bit then return nil end
    return (addr - CHEST_FLAGS_BASE) * 8 + bit
end

function terranigma_is_flag_set(value, mask)
    return (value & mask) ~= 0
end

function terranigma_read_u8_abs(addr)
    return AutoTracker:ReadU8(addr, 0) or 0
end

function terranigma_read_u16_abs(addr)
    return AutoTracker:ReadU16(addr, 0) or 0
end

-- Segment-Reads: in MemoryWatch-Segments immer OFFSET 0..len-1 lesen
function terranigma_seg_u8(seg, offset)
    if not seg then return 0 end
    return seg:ReadUInt8(offset) or 0
end

-- Location/Map abhaken: kann Location (ChestCount/AvailableChestCount) ODER Toggle (Active) sein
local _missing_codes = _missing_codes or {}

function terranigma_set_done_for_code(code, done)
    if type(code) == "table" then
        local any = false
        for _, c in ipairs(code) do
            if terranigma_set_done_for_code(c, done) then any = true end
        end
        return any
    end

    -- ✅ harte guard
    if type(code) ~= "string" then
        dbg("WARN: set_done_for_code erwartet string/table, got %s", type(code))
        return false
    end

    if code:find(",") then
        local any = false
        for part in string.gmatch(code, "[^,]+") do
            local c = (part:gsub("^%s+", ""):gsub("%s+$", ""))
            if c ~= "" and terranigma_set_done_for_code(c, done) then any = true end
        end
        return any
    end

    local obj = Tracker:FindObjectForCode(code)

    if not obj then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING and not _missing_codes[code] then
            _missing_codes[code] = true
            dbg("WARN: Object nicht gefunden für Code: %s", tostring(code))
        end
        return false
    end

    -- LOCATION SECTION CODES fangen in PopTracker mit "@..." an.
    -- Die werden über AvailableChestCount / ChestCount "gecleared". :contentReference[oaicite:0]{index=0}
    if type(code) == "string" and code:sub(1,1) == "@" then
        -- setze alles, was existiert
        local changed = false

        if obj.AvailableChestCount ~= nil and obj.ChestCount ~= nil then
            obj.AvailableChestCount = done and 0 or obj.ChestCount
            changed = true
        end

        if obj.AvailableItemCount ~= nil and obj.ItemCount ~= nil then
            obj.AvailableItemCount = done and 0 or obj.ItemCount
            changed = true
        end

        if obj.AvailableCount ~= nil and obj.Count ~= nil then
            obj.AvailableCount = done and 0 or obj.Count
            changed = true
        end

        if obj.Active ~= nil then
            obj.Active = done
            changed = true
        end

        return changed
    end

    dbg("OBJ %s type: Active=%s, Stage=%s",
            code, tostring(obj.Active), tostring(obj.CurrentStage))

    -- ITEM / TOGGLE / PROGRESSIVE (kein "@")
    -- TOGGLE
    if obj.Active ~= nil then
        obj.Active = done
        return true
    end

    -- PROGRESSIVE: JsonItem hat CurrentStage, aber oft KEIN MaxStage in Lua
    if obj.CurrentStage ~= nil then
        local cur = obj.CurrentStage or 0

        -- "einmal klicken" (idempotent): wenn done=true, Stage mindestens 1
        -- (damit es nicht bei jedem Apply immer weiter hochzählt)
        local target = done and math.max(cur, 1) or 0

        if target ~= cur then
            dbg("ITEM Stage %s: %d -> %d", tostring(code), cur, target)
            obj.CurrentStage = target
            dbg("ITEM Stage %s now=%s", tostring(code), tostring(obj.CurrentStage))
        end
        return true
    end

    if obj.AvailableCount ~= nil and obj.Count ~= nil then
        obj.AvailableCount = done and 0 or obj.Count
        return true
    end

    dbg("WARN: Code %s gefunden, aber kein passendes Feld (Active/Stage/Count).", tostring(code))
    return false
end

function terranigma_set_stage(code, stage)
    local obj = Tracker:FindObjectForCode(code)
    if not obj then
        dbg("WARN: Stage-Code nicht gefunden: %s", tostring(code))
        return false
    end
    if obj.CurrentStage == nil then
        dbg("WARN: Code %s hat kein CurrentStage (kein progressive item?)", tostring(code))
        return false
    end

    local old = obj.CurrentStage or 0
    if old ~= stage then
        obj.CurrentStage = stage
        dbg("ITEM Stage %s: %d -> %d", tostring(code), old, stage)
        return true
    end
    return false
end

-- Reset-Dispatcher (Module können diese Funktionen definieren)
function terranigma_reset_flag_snapshots()
    if type(terranigma_reset_chest_snapshot) == "function" then terranigma_reset_chest_snapshot() end
    if type(terranigma_reset_event_snapshot) == "function" then terranigma_reset_event_snapshot() end

    TERRA_AT = TERRA_AT or {}
    TERRA_AT.loc_cache = {}
    TERRA_AT.missing_check_warned = {}

    -- ✅ WICHTIG: SEEN FLAGS ebenfalls resetten, sonst kommen keine SEEN/LOOT Logs mehr
    TERRA_AT.seen_flags = { chest = {}, event = {} }

    dbg("flag snapshots RESET")
end

TERRA_AT = TERRA_AT or {}
TERRA_AT.seen_flags = TERRA_AT.seen_flags or { chest = {}, event = {} }

local function terranigma_flag_key(addr, mask)
    return string.format("%06X:%02X", addr, mask)
end

function terranigma_note_flag(kind, mapId, addr, mask, oldByte, newByte)
    if oldByte == nil or newByte == nil then return end

    -- rising edge: 0 -> 1
    if terranigma_is_flag_set(oldByte, mask) then return end
    if not terranigma_is_flag_set(newByte, mask) then return end

    local bucket = TERRA_AT.seen_flags[kind] or {}
    local k = terranigma_flag_key(addr, mask)
    if bucket[k] then return end

    bucket[k] = { mapId = mapId or 0, addr = addr, mask = mask }
    TERRA_AT.seen_flags[kind] = bucket

    local tab = (terranigma_tab_for_mapid and terranigma_tab_for_mapid(mapId or 0)) or "?"
    dbg("%s SEEN map=%04X tab=%s @%06X mask=%02X  -> paste: { addr=0x%06X, mask=0x%02X },",
            string.upper(kind), mapId or 0, tab, addr, mask, addr, mask)

    -- Beispiel: Leaves-Chest (addr/mask ersetzen!)
    local z = terranigma_flag_key(addr, mask)
    if kind == "chest" and z == "7E0762:01" then
        terranigma_oneshot_capture("GIANTLEAVES_CHEST")
        terranigma_oneshot_schedule("GIANTLEAVES_CHEST", 2) -- 2 Ticks Delay (safe)
    end

    if kind == "chest_misc" then
        if MISC_CAPTURE_LEFT <= 0 then
            return
        end
        if MISC_CAPTURE_MAP ~= 0 and mapId ~= MISC_CAPTURE_MAP then
            return
        end
        MISC_CAPTURE_LEFT = MISC_CAPTURE_LEFT - 1
    end

    if kind == "chest" then
        local CHEST_FLAGS_LEN = CHEST_FLAGS_LEN or 0x20
        if addr < CHEST_FLAGS_BASE or addr >= (CHEST_FLAGS_BASE + CHEST_FLAGS_LEN) then
            return
        end

        local chestId = terranigma_chest_id_from_flag(addr, mask)
        if chestId then
            local value = terranigma_read_chest_value(mapId, chestId)
            if value then
                if value >= 0x8000 then
                    dbg("CHEST LOOT map=%04X chestId=%d money=%04X", mapId, chestId, value)
                else
                    dbg("CHEST LOOT map=%04X chestId=%d itemId=%04X", mapId, chestId, value)
                end
            else
                dbg("CHEST LOOT map=%04X chestId=%d: not found in table", mapId, chestId)
            end
        end
    end
end

function terranigma_dump_seen_flags()
    for kind, bucket in pairs(TERRA_AT.seen_flags) do
        dbg("---- SEEN %s ----", string.upper(kind))
        for _, e in pairs(bucket) do
            dbg("map=%04X { addr=0x%06X, mask=0x%02X }", e.mapId, e.addr, e.mask)
        end
    end
end
