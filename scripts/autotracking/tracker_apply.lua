-- scripts/autotracking/tracker_apply.lua

local _missing_codes = _missing_codes or {}

local function split_codes(codes)
    if type(codes) == "table" then return codes end
    if type(codes) ~= "string" then return {} end
    local out = {}
    for part in string.gmatch(codes, "[^,]+") do
        local c = (part:gsub("^%s+", ""):gsub("%s+$", ""))
        if c ~= "" then out[#out+1] = c end
    end
    return out
end

local function get_obj(code)
    if type(code) ~= "string" then return nil end
    local obj = Tracker:FindObjectForCode(code)
    if not obj and AUTOTRACKER_ENABLE_DEBUG_LOGGING and not _missing_codes[code] then
        _missing_codes[code] = true
        dbg("WARN: Object nicht gefunden für Code: %s", tostring(code))
    end
    return obj
end

function terranigma_set_done_for_code(code, done)
    -- table support
    if type(code) == "table" then
        local any = false
        for _, c in ipairs(code) do
            if terranigma_set_done_for_code(c, done) then any = true end
        end
        return any
    end

    -- "a,b,c" support
    if type(code) == "string" and code:find(",") then
        local any = false
        for _, c in ipairs(split_codes(code)) do
            if terranigma_set_done_for_code(c, done) then any = true end
        end
        return any
    end

    local obj = get_obj(code)
    if not obj then return false end

    -- "@..." Location/Section
    if type(code) == "string" and code:sub(1, 1) == "@" then
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
            obj.Active = (done == true)
            changed = true
        end

        if (not changed) and AUTOTRACKER_ENABLE_DEBUG_LOGGING then
            dbg(
                    "WARN: @code '%s' gefunden, aber NICHT setzbar. hasActive=%s ChestCount=%s AvChest=%s ItemCount=%s AvItem=%s Count=%s Av=%s",
                    tostring(code),
                    tostring(obj.Active ~= nil),
                    tostring(obj.ChestCount),
                    tostring(obj.AvailableChestCount),
                    tostring(obj.ItemCount),
                    tostring(obj.AvailableItemCount),
                    tostring(obj.Count),
                    tostring(obj.AvailableCount)
            )
        end

        return changed
    end

    -- Toggle item
    if obj.Active ~= nil then
        obj.Active = (done == true)
        return true
    end

    -- Progressive NICHT hier “hochbumpern”
    return false
end

function terranigma_set_stage(code, stage, opts)
    opts = opts or {}
    local obj = get_obj(code)

    if not obj then return false end
    if obj.CurrentStage == nil then
        dbg("SET STAGE FAIL code=%s -> obj hat KEIN CurrentStage (=> Code zeigt wahrscheinlich auf falschen Objekttyp / Code-Kollision).", tostring(code))
        return false
    end

    local old = obj.CurrentStage or 0
    local s = tonumber(stage) or 0
    if s < 0 then s = 0 end
    if opts.clamp_max then s = math.min(s, opts.clamp_max) end
    if opts.never_decrease then
        s = math.max(old, s)
    end

    if old ~= s then
        obj.CurrentStage = s
        if obj.Active ~= nil then obj.Active = true end
        dbg("SET STAGE OK code=%s %d -> %d", tostring(code), old, s)
        return true
    end

    dbg("SET STAGE NOOP code=%s bleibt bei %d", code, old)
    return true
end

function set_item_by_qty_or_done(code, qty, opts)
    opts = opts or {}

    -- table support
    if type(code) == "table" then
        local any = false
        for _, c in ipairs(code) do
            if set_item_by_qty_or_done(c, qty, opts) then any = true end
        end
        return any
    end

    -- "a,b,c" support
    if type(code) == "string" and code:find(",") then
        local any = false
        for _, c in ipairs(split_codes(code)) do
            if set_item_by_qty_or_done(c, qty, opts) then any = true end
        end
        return any
    end

    local obj = get_obj(code)
    if not obj then return false end

    local q = tonumber(qty) or 0
    local mode = opts.mode -- "toggle" | "stage" | nil

    if mode == "toggle" then
        return terranigma_set_done_for_code(code, q > 0)
    elseif mode == "stage" then
        return terranigma_set_stage(code, q, opts)
    end

    -- AUTO: Toggles FIRST, dann Stage
    if obj.Active ~= nil then
        return terranigma_set_done_for_code(code, q > 0)
    end
    if obj.CurrentStage ~= nil then
        return terranigma_set_stage(code, q, opts)
    end

    return false
end
