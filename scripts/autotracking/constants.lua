CURRENT_MAP_ID_ADDR = 0x7E047E -- U16: Current location No
AUTOTRACKER_ENABLE = true
AUTOTRACKER_ENABLE_DEBUG_LOGGING = true

AUTOTRACKER_FLAG_WARMUP_TICKS = 0         -- wie viele Watch-Ticks wir still "nachziehen"
AUTOTRACKER_FLAG_SPIKE_GUARD_BITS = 24

DEBUG_SCAN_WARMUP_TICKS = 0
DEBUG_SCAN_MAX_BIT_CHANGES = 80
DEBUG_SCAN_LOG_BYTE_CHANGES = false

DEBUG_SCAN_WATCHES = {
    { name="scan_event_flags", addr=EVENT_FLAGS_ADDR, length=EVENT_FLAGS_LEN, callback="autotracker_debug_scan", interval_ms=250 },
    -- optional, falls Leaves in “misc flags” hängt:
    { name="scan_misc_small",  addr=0x7E0620,         length=0x20,          callback="autotracker_debug_scan", interval_ms=250 },
}