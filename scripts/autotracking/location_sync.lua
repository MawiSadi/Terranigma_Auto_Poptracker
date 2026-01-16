function terranigma_sync_chest_groups()
    if type(CHEST_GROUP_MAPPING) ~= "table" then return end

    TERRA_AT = TERRA_AT or {}
    TERRA_AT.loc_cache = TERRA_AT.loc_cache or {}
    TERRA_AT.missing_codes = TERRA_AT.missing_codes or {} -- Warn nur einmal

    local function set_done_cached(code, done)
        if type(code) ~= "string" then return false end
        local prev = TERRA_AT.loc_cache[code]
        if prev == done then return false end
        TERRA_AT.loc_cache[code] = done
        terranigma_set_done_for_code(code, done)
        return true
    end

    for _, g in ipairs(CHEST_GROUP_MAPPING) do
        local opened = 0

        for _, e in ipairs(g.checks or {}) do
            local v = terranigma_read_u8_abs(e.addr)
            local isOpen = terranigma_is_flag_set(v, e.mask)

            -- ✅ unified: e.codes (neu) oder fallback e.map/e.loc (alt)
            local list = nil
            if type(e.codes) == "string" then
                list = { e.codes }
            elseif type(e.codes) == "table" then
                list = e.codes
            else
                list = {}
                if type(e.map) == "string" then list[#list+1] = e.map end
                if type(e.map) == "table" then for _, c in ipairs(e.map) do list[#list+1] = c end end
                if type(e.loc) == "string" then list[#list+1] = e.loc end
            end

            local any = false
            for _, code in ipairs(list) do
                if type(code) == "string" and Tracker:FindObjectForCode(code) then
                    set_done_cached(code, isOpen) -- ✅ KEIN break → alle Codes setzen
                    any = true
                end
            end

            if not any then
                local k = string.format("%s:%06X:%02X", tostring(g.id), tonumber(e.addr) or 0, tonumber(e.mask) or 0)
                if not TERRA_AT.missing_codes[k] then
                    TERRA_AT.missing_codes[k] = true
                    dbg("WARN: chest_group codes nicht gefunden (group=%s addr=%06X mask=%02X)",
                            tostring(g.id), tonumber(e.addr) or 0, tonumber(e.mask) or 0)
                end
            end

            if isOpen then opened = opened + 1 end
        end

        -- stage/progress overlay
        if g.item_code then
            if type(g.item_code) == "table" then
                for _, code in ipairs(g.item_code) do terranigma_set_stage(code, opened) end
            else
                terranigma_set_stage(g.item_code, opened)
            end
        end
    end
end
