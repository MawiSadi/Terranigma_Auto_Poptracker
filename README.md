# Terranigma_Auto_Poptracker

PopTracker pack + SNES AutoTracker (Lua) for **Terranigma Randomizer**.

This pack supports:
- **Overworld / dungeon locations** (e.g. chest locations) with clickable overlay + automatic clearing
- **WRAM-based inventory tracking** (seed-independent): detects which item was obtained from a chest and marks the matching tracker item

> Status: early / WIP. Contributions via issues are welcome. Push access is restricted to the maintainer.

---

## Features

### Locations / Overlay clicking
- Locations like `@Overworld_dungeons/Astarika/Chest` can be clicked in the tracker.
- When the chest is opened in-game, the location is automatically cleared (AvailableChestCount -> 0).

### Inventory item detection (WRAM)
- The AutoTracker watches a WRAM inventory region and detects **new (id, qty)** pairs.
- On rising edges (new item obtained), it logs the item id and can map it to tracker item codes.
