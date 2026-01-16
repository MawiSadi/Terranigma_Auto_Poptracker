-- scripts/autotracking/flags.lua
-- Gemeinsamer Flag-Watcher für CHEST_FLAGS + EVENT_FLAGS
local CHEST_PTR_TABLE = 0xD9D8A0   -- = 0xC00000 + 0x19D8A0
local CHEST_PTR_OR    = 0xD90000   -- = 0xC00000 + 0x190000

local function read_u8_rom(addr)  return AutoTracker:ReadU8(addr, 0) or 0 end
local function read_u16_rom(addr) return AutoTracker:ReadU16(addr, 0) or 0 end

function terranigma_read_chest_value(mapId, wantedChestId)
    local ptr = read_u16_rom(CHEST_PTR_TABLE + mapId * 2)
    local a = CHEST_PTR_OR + ptr

    while true do
        local x = read_u8_rom(a)
        if x == 0xFF then return nil end

        local flags = read_u8_rom(a + 2)
        local off = a + 3

        if flags >= 0x80 then
            -- event flag present
            off = off + 2 -- skip event flag u16
        end

        local value = read_u16_rom(off); off = off + 2
        local chestId = read_u16_rom(off); off = off + 2

        if chestId == wantedChestId then
            return value, flags
        end

        a = a + ((flags >= 0x80) and 9 or 7)
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

        -- 1) Baseline einmalig setzen
        if prev == nil then
            prev = snapshot_abs()
            dbg("%s flags ARMED (baseline gesetzt)", kind)
            terranigma_sync_chest_groups() -- ✅ sofort syncen
            return
        end

        -- 2) Warmup: keine Rising-Logs, aber trotzdem syncen!
        if warmup_left and warmup_left > 0 then
            warmup_left = warmup_left - 1
            prev = snapshot_abs() -- baseline nachziehen
            terranigma_sync_chest_groups() -- ✅ wichtig, sonst "Kiste passiert nix"
            return
        end

        -- 3) Diff gegen aktuellen Zustand
        local cur = snapshot_abs()
        local changed = false
        local rising_count = 0

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
                    if AUTOTRACKER_ENABLE_DEBUG_LOGGING and log_seen then
                        for _, m in ipairs(MASKS8) do
                            local was = terranigma_is_flag_set(old, m)
                            local now = terranigma_is_flag_set(new, m)
                            if (not was) and now then
                                if kind == "chest" and (base_addr + i) == 0x7E0762 and m == 0x01 then
                                    terranigma_oneshot_capture("GIANTLEAVES_CHEST")
                                    terranigma_oneshot_schedule("GIANTLEAVES_CHEST", 2)
                                end
                                terranigma_note_flag(kind, mapId, (base_addr + i), m, old, new)
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

-- Chest
local _chest = make_flag_watcher("chest", CHEST_FLAGS_ADDR, CHEST_FLAGS_LEN)
function terranigma_reset_chest_snapshot() _chest.reset() end
function autotracker_update_chest_flags(segment) _chest.update(segment) end

-- Event
local _event = make_flag_watcher("event", EVENT_FLAGS_ADDR, EVENT_FLAGS_LEN)
function terranigma_reset_event_snapshot() _event.reset() end
function autotracker_update_event_flags(segment) _event.update(segment) end

local _chest_misc = make_flag_watcher("chest_misc", CHEST_MISC_FLAGS_ADDR, CHEST_MISC_FLAGS_LEN,{ log_seen=false })
function terranigma_reset_chest_snapshot_misc() _chest_misc.reset() end
function autotracker_update_chest_flags_misc(segment) _chest_misc.update(segment) end
