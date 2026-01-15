# Terranigma Randomizer – PopTracker Package (mit Auto-Tracking)

Dieses Repository enthält ein **PopTracker**-Package für den **Terranigma Randomizer** inklusive **Auto-Tracking** (Inventar/Progress + Locations über Flags).

> PopTracker selbst ist ein separates Projekt von **black-sliver**: https://github.com/black-sliver/PopTracker

---

## Features

- **Overworld & Dungeons als Tabs/Maps** (je nach Package-Layout)
- **Locations/Checks** nach Bereichen strukturiert (z. B. Overworld-Spots, Dungeon-Abschnitte)
- **Auto-Tracking**
  - liest **Inventory-Slots** und setzt Items im Tracker automatisch
  - setzt **Chest-Checks** über Flag-Auswertung (addr + mask aus `chest_groups.lua`)
  - unterstützt “aufgeteilte” Checks (einzelne Truhen statt Sammel-Checks), damit das Grid sauber bleibt

---

## Aktueller Stand / Einschränkungen

- ✅ **Dungeon-Kisten** werden im Itemgrid automatisch getrackt.
- ⚠️ **Boss-Drops werden aktuell NICHT im Itemgrid getrackt** (nur die Kisten, nicht Boss-Checks).
- ⚠️ **Parasite Event** (z. B. Ra Tree / Parasite) ist **noch nicht implementiert**.
- Items, die **nicht** im normalen Inventory liegen (oder anders geschrieben werden), brauchen ggf. eigene Watch/Mapping-Logik.

---

## Installation

1. **PopTracker installieren**
   - Download / Setup siehe PopTracker Repo: https://github.com/black-sliver/PopTracker

2. Dieses Package herunterladen/klonen und in den PopTracker-Packages-Ordner legen  
   (typischerweise `PopTracker/packages/`).

3. PopTracker starten und das Package auswählen.

---

## Auto-Tracking Setup (kurz)

Das Package nutzt Memory-Watches (addr/length) + Mapping-Skripte, um:
- Inventory-Items zu erkennen
- Chest-Flags auszuwerten
- daraus Locations/Items im Tracker zu setzen

> Je nach Emulator/Bridge muss PopTracker korrekt mit der laufenden ROM verbunden sein (siehe PopTracker-Doku).

---

## Entwickler-Notizen

### Wichtige Dateien / Struktur (Beispiel)
- `scripts/autotracking.lua`  
  Einstieg: lädt Module, registriert Memory Watches.
- `scripts/autotracking/inventory_items.lua`  
  Inventory-Parser + Mapping `INVENTORY_ID_TO_CODE`.
- `scripts/autotracking/flags.lua`  
  Watcher für Chest/Event-Flags, Rising-Edges, Sync-Logik.
- `scripts/autotracking/mappings/chest_groups.lua`  
  `CHEST_GROUP_MAPPING`: addr+mask → Tracker-Codes.

### Checks “aufteilen”
Wenn du statt Sammelchecks lieber einzelne Kisten willst:  
- im JSON `item_count` entsprechend splitten  
- in `chest_groups.lua` pro Kiste ein eigener Eintrag (addr/mask + codes)

---

## Roadmap / TODO

- [ ] Boss-Checks ins Itemgrid aufnehmen (Boss-Drops / Boss-Events)
- [ ] Parasite Event implementieren
- [ ] ggf. weitere Spezialfälle (nicht-Inventory Items / One-shot Events) sauber integrieren
- [ ] Docs: kurze Tabelle „Item → Inventory-ID → Tracker-Code“

---

## Credits

- **RoodyOh**
- **Darknesslink81**
- **Wrex**
- **PopTracker** von **black-sliver**: https://github.com/black-sliver/PopTracker

Danke an alle, die getestet, geloggt und beim Reverse-Engineering geholfen haben. ❤️
