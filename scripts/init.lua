Tracker:AddMaps("maps/maps.json")

ScriptHost:LoadScript("scripts/logic.lua")

Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/item_grid.json")
Tracker:AddLayouts("layouts/map_tracker.json")
Tracker:AddLayouts("layouts/full.json")

ScriptHost:LoadScript("scripts/loadlocations.lua")
ScriptHost:LoadScript("scripts/loaditems.lua")
ScriptHost:LoadScript("scripts/autotracking.lua")