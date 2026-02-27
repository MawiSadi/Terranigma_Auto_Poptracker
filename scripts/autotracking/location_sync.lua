local function is_overworld_section_code(code)
    return type(code) == "string" and code:sub(1, #("@Overworld_dungeons/")) == "@Overworld_dungeons/"
end

local function add_codes_split(dst_loc, dst_sec, x)
    if type(x) == "string" then
        if is_overworld_section_code(x) then
            dst_sec[#dst_sec+1] = x
        else
            dst_loc[#dst_loc+1] = x
        end
    elseif type(x) == "table" then
        for _, c in ipairs(x) do
            if type(c) == "string" then
                if is_overworld_section_code(c) then
                    dst_sec[#dst_sec+1] = c
                else
                    dst_loc[#dst_loc+1] = c
                end
            end
        end
    end
end

local function set_remaining_cached(code, remaining, total, ctx)
    if type(code) ~= "string" then return false end
    local AT = terranigma_state()
    local key = "rem:" .. code
    local old = AT.loc_cache[key]
    if old == remaining then return false end

    local obj = Tracker:FindObjectForCode(code)
    if not obj then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
            dbg("SYNC WARN: section obj missing code=%s group=%s", tostring(code), tostring(ctx and ctx.group_id or "?"))
        end
        return false
    end

    -- current remaining im Tracker lesen
    local current = nil
    if obj.AvailableChestCount ~= nil then current = tonumber(obj.AvailableChestCount) end
    if current == nil and obj.AvailableItemCount ~= nil then current = tonumber(obj.AvailableItemCount) end
    if current == nil and obj.AvailableCount ~= nil then current = tonumber(obj.AvailableCount) end

    -- NIE remaining erhöhen (sonst revertet UI-Klick)
    if current ~= nil and remaining > current then
        AT.loc_cache[key] = remaining -- wichtig: damit wir nicht jedes Tick wieder versuchen
        return false
    end

    -- Wir setzen "Available..." auf remaining (runterzählend)
    local ok = false
    if obj.AvailableChestCount ~= nil and obj.ChestCount ~= nil then
        local maxv = tonumber(obj.ChestCount) or total or remaining
        local r = math.max(0, math.min(remaining, maxv))
        obj.AvailableChestCount = r
        ok = true
    elseif obj.AvailableItemCount ~= nil and obj.ItemCount ~= nil then
        local maxv = tonumber(obj.ItemCount) or total or remaining
        local r = math.max(0, math.min(remaining, maxv))
        obj.AvailableItemCount = r
        ok = true
    elseif obj.AvailableCount ~= nil and obj.Count ~= nil then
        local maxv = tonumber(obj.Count) or total or remaining
        local r = math.max(0, math.min(remaining, maxv))
        obj.AvailableCount = r
        ok = true
    elseif obj.Active ~= nil then
        -- Fallback: wenn’s nur Active gibt, dann “fertig” erst bei remaining==0
        obj.Active = (remaining == 0)
        ok = true
    end

    if not ok then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
            dbg("SYNC WARN: section obj not countable code=%s group=%s", tostring(code), tostring(ctx and ctx.group_id or "?"))
        end
        return false
    end

    AT.loc_cache[key] = remaining
    return true
end

function terranigma_sync_chest_groups()
    if type(CHEST_GROUP_MAPPING) ~= "table" then return end

    local AT = terranigma_state()
    AT.loc_cache = AT.loc_cache or {}
    AT.chest_stage_cache = AT.chest_stage_cache or {}

    local function set_done_cached(code, done, ctx)
        if type(code) ~= "string" then return false end
        local old = AT.loc_cache[code]
        if old == done then return false end
        if old == true and done == false then return false end

        local ok = set_item_by_qty_or_done(code, done and 1 or 0, { mode="toggle" })
        if not ok then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
                dbg("SYNC WARN: set_done FAILED code=%s done=%s group=%s @%06X mask=%02X",
                        tostring(code),
                        tostring(done),
                        tostring(ctx and ctx.group_id or "?"),
                        tonumber(ctx and ctx.addr or 0) or 0,
                        tonumber(ctx and ctx.mask or 0) or 0
                )
            end
            return false -- NICHT cachen
        end

        AT.loc_cache[code] = done
        return true
    end

    local function set_stage_cached(code, stage, ctx)
        if type(code) ~= "string" then return false end
        local k = "stage:" .. code
        local old = AT.chest_stage_cache[k]
        if old == stage then return false end

        local ok = set_item_by_qty_or_done(code, stage, { mode="stage" })
        if not ok then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
                dbg("SYNC WARN: set_stage FAILED code=%s stage=%s group=%s",
                        tostring(code), tostring(stage), tostring(ctx and ctx.group_id or "?"))
            end
            return false -- NICHT cachen
        end

        AT.chest_stage_cache[k] = stage
        return true
    end

    for _, g in ipairs(CHEST_GROUP_MAPPING) do
        local opened, total = 0, 0
        local sec_stats = {}

        for _, e in ipairs(g.checks or {}) do
            total = total + 1
            local v = terranigma_read_u8_abs(e.addr)
            local isOpen = terranigma_is_flag_set(v, e.mask)
            if isOpen then opened = opened + 1 end

            local loc_list, sec_list = {}, {}
            local function add_codes(dst, x)
                if type(dst) ~= "table" then return end

                if type(x) == "string" then
                    dst[#dst + 1] = x
                elseif type(x) == "table" then
                    for _, c in ipairs(x) do
                        if type(c) == "string" then
                            dst[#dst + 1] = c
                        end
                    end
                end
            end

            add_codes_split(loc_list, sec_list, e.codes)
            add_codes_split(loc_list, sec_list, e.map)
            add_codes_split(loc_list, sec_list, e.loc)
            add_codes_split(loc_list, sec_list, e.section_codes)

            local ctx = { group_id = g.id or g.name or tostring(g.item_code) or "?", addr = e.addr, mask = e.mask }

            for _, code in ipairs(loc_list) do
                set_done_cached(code, isOpen, ctx)
            end

            -- 2) Section: nur Stats sammeln (nicht togglen!)
            -- (wir machen später remaining = total - opened pro Sectioncode)
            sec_stats = sec_stats or {}
            for _, scode in ipairs(sec_list) do
                local st = sec_stats[scode]
                if not st then
                    st = { total = 0, opened = 0 }
                    sec_stats[scode] = st
                end
                st.total = st.total + 1
                if isOpen then st.opened = st.opened + 1 end
            end
        end

        local gctx = { group_id = g.id or g.name or tostring(g.item_code) or "?" }

        for scode, st in pairs(sec_stats) do
            local remaining = math.max(0, st.total - st.opened)
            set_remaining_cached(scode, remaining, st.total, gctx)
        end

        if g.item_code then
            local stage = math.min(opened, total) -- 0..total (bei total => open stage)
            if type(g.item_code) == "table" then
                for _, code in ipairs(g.item_code) do
                    set_stage_cached(code, stage, gctx)
                end
            else
                set_stage_cached(g.item_code, stage, gctx)
            end
        end
    end
end
