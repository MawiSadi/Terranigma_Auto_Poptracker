Tracker:AddMaps("maps/maps.json")

Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/item_grid.json")
Tracker:AddLayouts("layouts/grouped_items.json")
Tracker:AddLayouts("layouts/settings_popup.json")
Tracker:AddLayouts("layouts/map_tracker.json")

ScriptHost:LoadScript("scripts/loadlocations.lua")
ScriptHost:LoadScript("scripts/loaditems.lua")
ScriptHost:LoadScript("scripts/autotracking.lua")