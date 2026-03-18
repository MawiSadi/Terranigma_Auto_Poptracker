if _G.dbg == nil then
    function dbg(fmt, ...)
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
            print(string.format("[autotracker] " .. fmt, ...))
        end
    end
end

function mask_to_bit(mask)
    for i = 0, 7 do
        if MASKS8[i+1] == mask then return i end
    end
    return nil
end

function terranigma_chest_id_from_flag(addr, mask)
    local bit = mask_to_bit(mask)
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

function terranigma_seg_u8(seg, offset)
    if not seg then return 0 end
    return seg:ReadUInt8(offset) or 0
end

function terranigma_seg_u16(seg, offset)
    if not seg then return 0 end
    return seg:ReadUInt16(offset) or 0
end

function terranigma_clear_tracker_items()
    -- Inventory toggles: alles aus
    for _, code in pairs(INVENTORY_ID_TO_CODE or {}) do
        if code ~= STARSTONES then
            set_item_by_qty_or_done(code, 0, { mode="toggle" })
        end
    end

    -- Starstones stage auf 0
    set_item_by_qty_or_done(STARSTONES, 0, { mode="stage" })

    -- Chest-group progressives auf 0 (wenn vorhanden)
    if type(CHEST_GROUP_MAPPING) == "table" then
        for _, g in ipairs(CHEST_GROUP_MAPPING) do
            if g.progress_code then
                if type(g.progress_code) == "table" then
                    for _, c in ipairs(g.progress_code) do
                        terranigma_set_stage(c, 0)
                    end
                else
                    terranigma_set_stage(g.progress_code, 0)
                end
            end
        end
    end

    for _, code in ipairs(RESET_TOGGLE_CODES or {}) do
        if type(code) == "string" then
            set_item_by_qty_or_done(code, 0, { mode="toggle" })
        end
    end

    local AT = terranigma_state()
    AT.visited_maps = {}
    AT.inv_present_streak = {}
end

function terranigma_state()
    TERRA_AT = TERRA_AT or {}

    if TERRA_AT.run_started == nil then TERRA_AT.run_started = false end
    if TERRA_AT.inv_ready == nil then TERRA_AT.inv_ready = false end
    if TERRA_AT.inv_ready_ticks == nil then TERRA_AT.inv_ready_ticks = 0 end
    if TERRA_AT.inv_reconcile_done == nil then TERRA_AT.inv_reconcile_done = false end

    TERRA_AT.reset = TERRA_AT.reset or {
        session_id = 0,
        session_clock = os.clock(),
        above_menu_streak = 0,
        run_started = false,
    }

    TERRA_AT.loc_cache = TERRA_AT.loc_cache or {}
    TERRA_AT.chest_stage_cache = TERRA_AT.chest_stage_cache or {}
    TERRA_AT.seen_flags = TERRA_AT.seen_flags or { chest = {}, event = {}, chest_misc = {} }

    return TERRA_AT
end
