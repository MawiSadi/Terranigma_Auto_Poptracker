# Terranigma Randomizer – PopTracker Package (mit Auto-Tracking)

Dieses Repository enthält ein **PopTracker**-Package für den **Terranigma Randomizer** inkl. **Auto-Tracking** (Inventar/Keyitems + Locations/Checks über Flags).

> PopTracker selbst ist ein separates Projekt von **black-sliver**: https://github.com/black-sliver/PopTracker

---

## Features

- **Overworld & Dungeons** als Tabs/Maps (je nach Package-Layout)
- **Locations/Checks** nach Bereichen strukturiert (Overworld-Spots, Dungeon-Abschnitte, Bosse/Events)
- **Auto-Tracking (SNI / Memory-Watches)**
    - erkennt **Key Items** über **Inventory-Diff** (u16-Werte in WRAM)
    - setzt **Chest-Checks** über **Flag-Auswertung** (addr + mask aus `chest_groups.lua`)
    - setzt **Event-Checks** über **Event-Flags** (addr + mask → eventId) und kann daraus ebenfalls Items erkennen
    - unterstützt “aufgeteilte” Checks oder **progressive Sections** (item_count) – je nachdem, wie du deine JSON/Map strukturierst

---

## Aktueller Stand / Einschränkungen

- ✅ **Inventory-Diff Auto-Tracking** funktioniert stabil (keine „1 Chest später“ Zuordnung mehr), weil wir:
    - Inventory als eigenen Watch cachen und
    - “pending pickup” finalisieren, sobald der Inventory-Cache aktualisiert wird.
- ✅ **Chest-Items** (Key Items) werden zuverlässig erkannt (inkl. **Starstones** als Stage/Qty).
- ✅ **Event-Pickups** sind vom System her unterstützt (Pending-Mechanismus funktioniert auch für Events).
- ⚠️ **Boss-Events / Boss-Flags** sind noch **nicht vollständig gemappt** (d. h. es fehlen addr/mask → Boss-Check Einträge).  
  → Das System kann’s tracken, sobald die korrekten Flags bekannt sind.
- ⚠️ Einige Spezialfälle brauchen ggf. eigene Logik (z. B. Items, die nicht in den beobachteten Inventory-Bereich geschrieben werden, oder mehrfach/komplex getriggerte Events).
- ⚠️ **Parasite / Ra Tree**: Boss/Flag-Mapping noch offen (Beispiel: falsche ID im Mapping).

---

## Voraussetzungen

- PopTracker installiert
- Emulator/Bridge mit Memory-Read via PopTracker (**SNI / kompatible Verbindung**)
- Package liegt im PopTracker Packages-Ordner (siehe Installation)

---

## Installation

1. **PopTracker installieren**
    - https://github.com/black-sliver/PopTracker

2. Dieses Package herunterladen/klonen und in den PopTracker-Packages-Ordner legen  
   (typisch: `PopTracker/packages/`)

3. PopTracker starten und das Package auswählen.

---

## Auto-Tracking Setup (kurz)

Das Package nutzt Memory-Watches (addr/length) + Mapping-Skripte, um:
- Inventory-Änderungen (Items) zu erkennen
- Flag-Rising-Edges (Chests/Events) zu erkennen
- daraus Locations/Sections im Tracker zu aktualisieren

### Wichtige Watches
- Chest-Flags (`CHEST_FLAGS_ADDR`, `CHEST_FLAGS_LEN`)
- Event-Flags (`EVENT_FLAGS_ADDR`, `EVENT_FLAGS_LEN`)
- Misc-Flags (`CHEST_MISC_FLAGS_ADDR`, `CHEST_MISC_FLAGS_LEN`)
- **Inventory-Cache** (`INVENTORY_BASE_ADDR`, `INVENTORY_WATCH_LEN`)  
  → läuft bewusst schneller (z. B. 50ms), damit Item-Pickups zeitnah finalisiert werden.

---

## Entwickler-Notizen

### Wichtige Dateien / Struktur
- `scripts/autotracking.lua`  
  Einstieg: lädt Module, registriert Memory-Watches.
- `scripts/autotracking/mappings/inventory_items.lua`  
  Inventory-Parser + Mapping `INVENTORY_ID_TO_CODE` (ItemID → Tracker-Code).
- `scripts/autotracking/flags.lua`  
  Watcher für Chest/Event-Flags, Rising-Edges, **Pending-Pickup-Mechanismus** (gegen Timing).
- `scripts/autotracking/mappings/chest_groups.lua`  
  `CHEST_GROUP_MAPPING`: addr+mask → Tracker-Codes (Locations/Sections/Bosse).

### Wie die Item-Erkennung funktioniert (Kurzfassung)
- Bei **Chest/Event Flag-Rising** wird ein Pickup „pending“ gestartet (mit `prev` Inventory-Snapshot).
- Sobald der **Inventory-Cache** aktualisiert wird, wird das Pending automatisch finalisiert:
    - Diff `prev → cur` wird analysiert
    - bekannte ItemIDs werden über `INVENTORY_ID_TO_CODE` gemappt
    - Tracker-Objekte werden gesetzt (Toggle/Stage)
- TTL (z. B. 2s) verhindert Hänger und resynct Baseline, damit nichts „nachklingelt“.

### Debugging / Logs
- `AUTOTRACKER_ENABLE_DEBUG_LOGGING=true` aktiviert ausführliche Logs.
- Missing Tracker Codes werden (einmalig) geloggt, wenn ein Objekt nicht gefunden wurde.

---

## Mapping: Chests / Events / Bosse

### Chest-Checks
- in `chest_groups.lua` via `{ addr=..., mask=..., codes={...} }`
- Codes können auf einzelne Locations oder auf **Sections** zeigen (z. B. `@Overworld_dungeons/.../Dungeon (Without Tower Key)`)

### Event-Checks (Boss/Story)
- Event-Flags werden ebenfalls als Rising-Edge gesehen.
- Um Boss-Checks zu mappen, brauchst du die **addr+mask** des Boss-Events.  
  Vorgehen:
    1) Debug-Logging an
    2) Boss killen / Event auslösen
    3) Log-Zeile `EVENT SEEN ... -> paste: { addr=0x..., mask=0x.. }` übernehmen
    4) in `CHEST_GROUP_MAPPING` als Boss-Check eintragen

---

## Troubleshooting (häufig)

- **„Item wird 1 Chest später erkannt“**  
  → sollte durch Inventory-Cache + Pending-Finalize behoben sein.  
  Prüfe, ob der Inventory-Watch aktiv ist (`terra_inventory_cache`) und ausreichend schnell tickt (z. B. 50ms).

- **Section/Overworld-Map zählt nicht runter, aber Itemgrid schon**  
  → Meist zeigt ein Code auf ein anderes Objekt als gedacht (Location vs Section vs falscher Pfad),
  oder das Zielobjekt hat keine `Available*Count` Felder.  
  Debug: Missing-Code Logs prüfen + sicherstellen, dass die `@Overworld_dungeons/.../Section` exakt existiert.

---

## Credits

- **RoodyOh**
- **Darknesslink81**
- **Wrex**
- **PopTracker** von **black-sliver**: https://github.com/black-sliver/PopTracker

Danke an alle, die getestet, geloggt und beim Reverse-Engineering geholfen haben. ❤️