INVENTORY_ITEMS_ADDR = 0x7F8000
INVENTORY_ITEMS_LEN  = 0x60

-- Welche IDs sollen auf welche Tracker-Codes gemappt werden?
INVENTORY_ID_TO_CODE = {
    [0x30] = "ruby",
    [0x33] = "snowleaf",
    [0x34] = "scarf",
    [0x35] = "seal",
    [0x36] = "protectbell",
    [0x37] = "sapphire",
    [0x38] = "blackopal",
    [0x3A] = "topaz",
    [0x3E] = "towerkey",
    [0x3F] = "dewdrop",
    --[0x40] = "letter",
    [0x43] = "flute",
    [0x44] = "airplane",
    [0x49] = "anchor",
    [0x4A] = "ring",
    [0x4B] = "sewerkey",
    [0x4C] = "starstones",
    [0x5A] = "flower",
    --[0x59] = "sleepless seal",
    [0x7B] = "boots",
    [0x7C] = "flippers",
    [0x7D] = "claws",
    [0x7F] = "airherb",
}

TERRA_AT = TERRA_AT or {}
TERRA_AT.inv_have = TERRA_AT.inv_have or { }
TERRA_AT.inv_armed = TERRA_AT.inv_armed or false

local _seen_unknown_inv_ids = _seen_unknown_inv_ids or {}
INVENTORY_ITEMS_DEBUG_LEN = INVENTORY_ITEMS_DEBUG_LEN or 0x60

local function terranigma_inv_read_abs_bytes(addr, len)
    local t = {}
    for i = 0, (len or 0) - 1 do
        t[i] = terranigma_read_u8_abs(addr + i)
    end
    return t
end

local function terranigma_inv_log_byte_diffs(mapId, oldb, newb, len)
    if not oldb or not newb then return 0 end
    local n = 0
    local paste = {}
    for off = 0, (len or 0) - 1 do
        local o = oldb[off] or 0
        local v = newb[off] or 0
        if o ~= v then
            n = n + 1
            dbg("INV BYTES map=%04X off=%02X %02X->%02X", mapId, off, o, v)
            paste[#paste+1] = string.format("%02X=%02X", off, v)
        end
    end
    if n > 0 then
        dbg("INV PASTE map=%04X %s", mapId, table.concat(paste, " "))
    end
    return n
end

local function terranigma_inv_log_pair_diffs(mapId, oldb, newb, len)
    if not newb then return end
    local maxlen = len or 0
    if maxlen < 2 then return end

    for off = 0, maxlen - 2, 2 do
        local oid = (oldb and oldb[off]) or 0
        local oq  = (oldb and oldb[off + 1]) or 0
        local nid = newb[off] or 0
        local nq  = newb[off + 1] or 0

        if oid ~= nid or oq ~= nq then
            dbg("INV SLOT map=%04X off=%02X id %02X->%02X qty %02X->%02X", mapId, off, oid, nid, oq, nq)

            -- Letter Debug: Auftauchen / Verschwinden triggert Diff-Scan
            if nid == LETTER_ID and nq ~= 0 and (oid == 0 or oq == 0) then
                dbg("LETTER detected (GOT) map=%04X off=%02X qty %02X->%02X", mapId, off, oq, nq)
                terranigma_letter_debug_scan(mapId, "LETTER_GOT")
            elseif oid == LETTER_ID and oq ~= 0 and nid == 0 and nq == 0 then
                dbg("LETTER detected (READ/CLEARED) map=%04X off=%02X qty %02X->%02X", mapId, off, oq, nq)
                terranigma_letter_debug_scan(mapId, "LETTER_READ")
            end

            if nid ~= 0 and nq ~= 0 and (nq > oq or oid == 0 or oq == 0) then
                dbg("INV GOT map=%04X off=%02X id=%02X qty %02X->%02X", mapId, off, nid, oq, nq)

                local code = INVENTORY_ID_TO_CODE and INVENTORY_ID_TO_CODE[nid]
                if code then
                    terranigma_set_done_for_code(code, true)
                else
                    if not _seen_unknown_inv_ids[nid] then
                        _seen_unknown_inv_ids[nid] = true
                        dbg("INV UNKNOWN id=%02X (kein Mapping in INVENTORY_ID_TO_CODE)", nid)
                    end
                end
            end
        end
    end
end

LETTER_DEBUG_ENABLE = LETTER_DEBUG_ENABLE or true
LETTER_ID = LETTER_ID or 0x40

-- Bitte NICHT raten: du kannst diese Ranges später anpassen, sobald Logs Hinweise geben.
-- Start klein, dann gezielt erweitern.
LETTER_DEBUG_RANGES = LETTER_DEBUG_RANGES or {
    { name = "INV_7F8000",   base = INVENTORY_ITEMS_ADDR, len = 0x100 },
    { name = "EVENT_FLAGS",  base = EVENT_FLAGS_ADDR or 0, len = EVENT_FLAGS_LEN or 0 },
    { name = "CHEST_FLAGS",  base = CHEST_FLAGS_ADDR or 0, len = CHEST_FLAGS_LEN or 0 },
}

local function _log_diffs(tag, name, base, oldb, newb, len)
    local n = 0
    local paste = {}
    for off = 0, (len or 0) - 1 do
        local o = oldb and oldb[off] or 0
        local v = newb[off] or 0
        if o ~= v then
            n = n + 1
            dbg("LETTER %s %s off=%04X @%06X %02X->%02X", tag, name, off, base+off, o, v)
            paste[#paste+1] = string.format("%06X=%02X", base+off, v)
        end
    end
    if n > 0 then
        dbg("LETTER PASTE %s %s %s", tag, name, table.concat(paste, " "))
    end
    return n
end

local function letter_scan_range(mapId, tag, r)
    if not r or (r.len or 0) <= 0 or (r.base or 0) <= 0 then return end

    TERRA_AT = TERRA_AT or {}
    TERRA_AT.letter_prev = TERRA_AT.letter_prev or {}

    local key = r.name or string.format("%06X_%d", r.base, r.len)
    local prev = TERRA_AT.letter_prev[key]

    local cur = {}
    for i = 0, r.len - 1 do
        cur[i] = terranigma_read_u8_abs(r.base + i) or 0
    end

    if prev == nil then
        TERRA_AT.letter_prev[key] = cur
        dbg("LETTERSCAN baseline map=%04X tag=%s range=%s @%06X len=%02X",
                mapId, tostring(tag), tostring(key), r.base, r.len)
        return
    end

    local max = 40
    local n = 0
    local paste = {}

    for off = 0, r.len - 1 do
        local o = prev[off] or 0
        local v = cur[off] or 0
        if o ~= v then
            n = n + 1
            if n <= max then
                dbg("LETTERSCAN map=%04X tag=%s %s off=%02X %02X->%02X",
                        mapId, tostring(tag), tostring(key), off, o, v)
                paste[#paste+1] = string.format("%s:%02X=%02X", tostring(key), off, v)
            end
        end
    end

    if n > 0 then
        dbg("LETTERSCAN PASTE map=%04X tag=%s %s", mapId, tostring(tag), table.concat(paste, " "))
    end

    TERRA_AT.letter_prev[key] = cur
end

function terranigma_letter_debug_scan(mapId, tag)
    if not LETTER_DEBUG_ENABLE then return end
    for _, r in ipairs(LETTER_DEBUG_RANGES) do
        letter_scan_range(mapId, tag, r)
    end
end

local function find_in_itemroom(seg, wantedId)
    for off = 0, INVENTORY_ITEMS_LEN - 2, 2 do
        local id  = terranigma_seg_u8(seg, off)
        local val = terranigma_seg_u8(seg, off + 1)
        if id == wantedId and val ~= 0 then
            return true, val, off
        end
    end
    return false, 0, nil
end

function terranigma_reset_inventory_snapshot()
    TERRA_AT.inv_have = {}
    TERRA_AT.inv_armed = false
    TERRA_AT.inv_last_bytes = nil
    dbg("inventory snapshot RESET")
end

function autotracker_update_inventory_items(seg)
    if not seg then return end

    TERRA_AT = TERRA_AT or {}
    TERRA_AT.inv_have = TERRA_AT.inv_have or {}
    TERRA_AT.inv_last_bytes = TERRA_AT.inv_last_bytes or nil

    local mapId = AutoTracker:ReadU16(CURRENT_MAP_ID_ADDR) or 0

    -- Debug: RAW-Diff der Bytes (empirisch, ohne Annahmen über Layout)
    local dbg_len = INVENTORY_ITEMS_DEBUG_LEN or (INVENTORY_ITEMS_LEN or 0)
    local cur_bytes = terranigma_inv_read_abs_bytes(INVENTORY_ITEMS_ADDR, dbg_len)
    if TERRA_AT.inv_last_bytes then
        local changed = terranigma_inv_log_byte_diffs(mapId, TERRA_AT.inv_last_bytes, cur_bytes, dbg_len)
        if changed > 0 then
            local pair_len = INVENTORY_ITEMS_LEN or 0
            if pair_len > dbg_len then pair_len = dbg_len end
            terranigma_inv_log_pair_diffs(mapId, TERRA_AT.inv_last_bytes, cur_bytes, pair_len)
        end
    end
    TERRA_AT.inv_last_bytes = cur_bytes

    -- baseline
    if not TERRA_AT.inv_armed then
        TERRA_AT.inv_armed = true
        dbg("inventory ARMED (baseline gesetzt)")
        terranigma_letter_debug_scan(mapId, "BASELINE")

        for itemId, code in pairs(INVENTORY_ID_TO_CODE) do
            local have, val, off = find_in_itemroom(seg, itemId)
            TERRA_AT.inv_have[itemId] = have

            terranigma_set_done_for_code(code, have)

            dbg("INV init id=%02X have=%s off=%s val=%02X",
                    itemId,
                    tostring(have),
                    off and string.format("%02X", off) or "nil",
                    val
            )
        end
        return
    end

    -- updates
    for itemId, code in pairs(INVENTORY_ID_TO_CODE) do
        local have, val, off = find_in_itemroom(seg, itemId)
        local prev = (TERRA_AT.inv_have[itemId] == true)

        if have and not prev then
            dbg("INV GOT map=%04X id=%02X off=%s val=%02X -> %s",
                    mapId,
                    itemId,
                    off and string.format("%02X", off) or "nil",
                    val,
                    code
            )
            terranigma_set_done_for_code(code, true)

            if itemId == 0x40 then
                terranigma_letter_debug_scan(mapId, "GOT_LETTER")
            end
        end

        TERRA_AT.inv_have[itemId] = have
    end
end