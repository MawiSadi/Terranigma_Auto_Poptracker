function terranigma_sync_chest_groups()
    if type(CHEST_GROUP_MAPPING) ~= "table" then return end

    local AT = terranigma_state()
    AT.loc_cache = AT.loc_cache or {}
    AT.chest_stage_cache = AT.chest_stage_cache or {}

    local function set_done_cached(code, done)
        if type(code) ~= "string" then return false end
        local old = AT.loc_cache[code]
        if old == done then return false end
        AT.loc_cache[code] = done
        set_item_by_qty_or_done(code, done and 1 or 0, { mode="toggle" })
        return true
    end

    local function set_stage_cached(code, stage)
        if type(code) ~= "string" then return false end
        local k = "stage:" .. code
        local old = AT.chest_stage_cache[k]
        if old == stage then return false end
        AT.chest_stage_cache[k] = stage
        return set_item_by_qty_or_done(code, stage, { mode="stage" }) -- WICHTIG: explizit stage
    end

    for _, g in ipairs(CHEST_GROUP_MAPPING) do
        local opened, total = 0, 0

        for _, e in ipairs(g.checks or {}) do
            total = total + 1
            local v = terranigma_read_u8_abs(e.addr)
            local isOpen = terranigma_is_flag_set(v, e.mask)
            if isOpen then opened = opened + 1 end

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

            for _, code in ipairs(list) do
                set_done_cached(code, isOpen)
            end
        end

        if g.item_code then
            local stage = math.min(opened, total) -- 0..total (bei total => open stage)
            if type(g.item_code) == "table" then
                for _, code in ipairs(g.item_code) do
                    set_stage_cached(code, stage)
                end
            else
                set_stage_cached(g.item_code, stage)
            end
        end
    end
end
