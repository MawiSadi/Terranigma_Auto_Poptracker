CURRENT_MAP_ID_ADDR = 0x7E047E

AUTOTRACKER_ENABLE = true
AUTOTRACKER_ENABLE_DEBUG_LOGGING = false

AUTOTRACKER_FLAG_WARMUP_TICKS = 0         -- wie viele Watch-Ticks wir still "nachziehen"
AUTOTRACKER_FLAG_SPIKE_GUARD_BITS = 24

INVENTORY_BASE_ADDR   = 0x7F8000

INVENTORY_ITEMS_LEN   = 0x30  -- 0x7F8000..0x7F802F
INVENTORY_UNUSED_OFF  = 0x30  -- 0x7F8030..0x7F8035
INVENTORY_UNUSED_LEN  = 0x06
INVENTORY_SPECIAL_OFF = 0x36  -- 0x7F8036..0x7F803F (5x u16)
INVENTORY_SPECIAL_LEN = 0x0A

INVENTORY_WEAPONS_OFF  = 0x40  -- 0x7F8040..0x7F805F
INVENTORY_WEAPONS_LEN  = 0x20
INVENTORY_ARMOR_OFF    = 0x60  -- 0x7F8060..0x7F807F
INVENTORY_ARMOR_LEN    = 0x20

INVENTORY_WATCH_LEN    = 0x80  -- bis 0x7F807F
INVENTORY_KEYITEM_META_STROBE = 0x01

CHEST_FLAGS_BASE = 0x7E0760

-- String constants
STARSTONES = "starstones"
VISITED_RA_TREE = "visited_ra_tree"
DEFEATED_SYLVAIN_SOUL_GUARD = "defeated_sylvain_soul_guard"

RESET_TOGGLE_CODES = {
    VISITED_RA_TREE,
    DEFEATED_SYLVAIN_SOUL_GUARD
}

RESET_STARSTONE_LOCATIONS = {
    "robot", "darkmorph", "darktwins", "hitoderon", "louran",
    "mermaidtower", "neotokio", "parasite", "bloodymary",
    "stormkeeper", "dragooncastle", "norfest", "airsrock",
    "astarika", "penguinea"
}

-- Watches / Adressen
EVENT_FLAGS_ADDR = 0x7E06C4
EVENT_FLAGS_LEN  = 0x7C

CHEST_FLAGS_ADDR = 0x7E0760
CHEST_FLAGS_LEN  = 0x20

CHEST_MISC_FLAGS_ADDR = 0x7E0620
CHEST_MISC_FLAGS_LEN  = 0x20

RA_TREE_ENTRY_MAP = 0x012C
DEFEATED_SYLVAIN_SOUL_GUARD_EVENT = { addr=0x7E0713, mask=0x01}
OPENED_GRECLIFF_CHEST_HOLD_LEFT_FOR_FINAL_DROP = { addr=0x7E0774, mask=0x02}

LOCATION_WATCHES = {
    { name="terra_event_flags", addr=EVENT_FLAGS_ADDR, length=EVENT_FLAGS_LEN, callback="autotracker_update_event_flags", interval_ms=250 },
    { name="terra_chest_flags", addr=CHEST_FLAGS_ADDR, length=CHEST_FLAGS_LEN, callback="autotracker_update_chest_flags", interval_ms=250 },
    { name="terra_misc_flags", addr=CHEST_MISC_FLAGS_ADDR, length=CHEST_MISC_FLAGS_LEN, callback="autotracker_update_chest_flags_misc", interval_ms=250 },
    { name="terra_inventory_cache", addr=INVENTORY_BASE_ADDR, length=INVENTORY_WATCH_LEN, callback="autotracker_update_inventory_cache", interval_ms=50 },
}

AUTOTRACKER_RESET_MIN_SESSION_AGE_SEC = 2.0
PENDING_TTL_CHEST = 4.0
PENDING_TTL_EVENT = 5.0

-- mapId <= menu_max gilt als "Title/Menu/Before gameplay" (bei dir war z.B. 0004)
AUTOTRACKER_RESET_MENU_MAX_MAPID = 0x0010

-- falling-bit thresholds
AUTOTRACKER_FLAG_RESET_FALLING_GUARD_BITS = 80
AUTOTRACKER_FLAG_RESET_FALLING_HARD_BITS  = 140

MISC_CAPTURE_LEFT = MISC_CAPTURE_LEFT or 0
MISC_CAPTURE_MAP  = MISC_CAPTURE_MAP  or 0
MASKS8 = MASKS8 or {1,2,4,8,16,32,64,128}