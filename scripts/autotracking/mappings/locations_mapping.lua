-- scripts/autotracking/locations_mapping.lua

-- Flag -> Codes zusammenbauen
LOCATION_FLAG_MAPPING = {}

-- Watches / Adressen
EVENT_FLAGS_ADDR = 0x7E06C4
EVENT_FLAGS_LEN  = 0x7C

CHEST_FLAGS_ADDR = 0x7E0760
CHEST_FLAGS_LEN  = 0x20

CHEST_MISC_FLAGS_ADDR = 0x7E0620
CHEST_MISC_FLAGS_LEN  = 0x20

LOCATION_WATCHES = {
    { name="terra_event_flags", addr=EVENT_FLAGS_ADDR, length=EVENT_FLAGS_LEN, callback="autotracker_update_event_flags", interval_ms=250 },
    { name="terra_chest_flags", addr=CHEST_FLAGS_ADDR, length=CHEST_FLAGS_LEN, callback="autotracker_update_chest_flags", interval_ms=250 },
    { name="terra_misc_flags", addr=CHEST_MISC_FLAGS_ADDR, length=CHEST_MISC_FLAGS_LEN, callback="autotracker_update_chest_flags_misc", interval_ms=250 },
}
