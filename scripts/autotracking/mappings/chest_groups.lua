CHEST_GROUP_MAPPING = {
    {
        id = "berugas_lab",
        name = "Berugas Lab",
        item_code = "berugaslabchest",
        checks = {
            { addr=0x7E0778, mask=0x01, codes={"@Berugas Lab/1F/Chest", "@Overworld_dungeons/Berugas Lab/1F Chest"} },
            { addr=0x7E077F, mask=0x10, codes={"@Berugas Lab/B2F/Chest", "@Overworld_dungeons/Berugas Lab/B2F Chest"} },
            { addr=0x7E0718, mask=0x04, codes={"@Berugas Lab/Security Robot/Boss", "@Overworld_dungeons/Berugas Lab/Security Robot"} } -- oder addr=0x7E06F4, mask=0x20
        },
    },{
        id = "dragoon_castle",
        name = "Dragoon Castle",
        item_code = "dragoonchest",
        checks = {
            { addr=0x7E0778, mask=0x02, codes={"@Dragoon Castle/Right Side 1/Chest", "@Overworld_dungeons/Dragoon Castle/Right 1"} },
            { addr=0x7E0778, mask=0x08, codes={"@Dragoon Castle/Right Side 2/Chest", "@Overworld_dungeons/Dragoon Castle/Right 2"} },
            { addr=0x7E0778, mask=0x04, codes={"@Dragoon Castle/Right Side 3/Chest", "@Overworld_dungeons/Dragoon Castle/Right 3"} },
            { addr=0x7E0778, mask=0x10, codes={"@Dragoon Castle/Right Side 4/Chest", "@Overworld_dungeons/Dragoon Castle/Right 4"} },
            { addr=0x7E0773, mask=0x10, codes={"@Dragoon Castle/Rando Room/Chest 1", "@Overworld_dungeons/Dragoon Castle/Left 1"} },
            { addr=0x7E0773, mask=0x08, codes={"@Dragoon Castle/Rando Room/Chest 2", "@Overworld_dungeons/Dragoon Castle/Left 2"} },
            { addr=0x7E077A, mask=0x40, codes={"@Dragoon Castle/Rando Room/Chest 3", "@Overworld_dungeons/Dragoon Castle/Left 3"} }
        },
    },
    {
        id = "eklamata",
        name = "Eklamata",
        item_code = "eklamatachest",
        checks = {
            { addr=0x7E0775, mask=0x40, codes={"@Eklamata/Smash the wall/Chest", "@Overworld_dungeons/Eklamata/Smash the wall"} },
            { addr=0x7E0776, mask=0x01, codes={"@Eklamata/Drop down the hole/Chest", "@Overworld_dungeons/Eklamata/Drop down the hole"} },
            { addr=0x7E0760, mask=0x40, codes={"@Eklamata/Snowgrass Leaf/Chest", "@Overworld_dungeons/Eklamata/Snowgrass Leaf"} },
            { addr=0x7E0775, mask=0x02, codes={"@Eklamata/Outside Leaf 1/Chest", "@Overworld_dungeons/Eklamata/Outside Leaf 1"} },
            { addr=0x7E0775, mask=0x80, codes={"@Eklamata/Rando Cave/Chest 1", "@Overworld_dungeons/Eklamata/Rando Cave Chest 1"} },
            { addr=0x7E0776, mask=0x08, codes={"@Eklamata/Rando Cave/Chest 2", "@Overworld_dungeons/Eklamata/Rando Cave Chest 2"} },
            { addr=0x7E0776, mask=0x02, codes={"@Eklamata/Rando Cave/Chest 3", "@Overworld_dungeons/Eklamata/Rando Cave Chest 3"} },
            { addr=0x7E0775, mask=0x04, codes={"@Eklamata/Outside Leaf 2/Chest", "@Overworld_dungeons/Eklamata/Outside Leaf 2"} },
            { addr=0x7E0775, mask=0x08, codes={"@Eklamata/Inside Leaf 1/Chest", "@Overworld_dungeons/Eklamata/Inside Leaf 1"} },
            { addr=0x7E0775, mask=0x20, codes={"@Eklamata/Inside Leaf 2/Chest", "@Overworld_dungeons/Eklamata/Inside Leaf 2"} },
            { addr=0x7E06EC, mask=0x02, codes={"@Eklamata/Dark Morph/Boss", "@Overworld_dungeons/Eklamata/Dark Morph"} }
        },
    },
    {
        id = "great_cliff",
        name = "Great Cliff",
        item_code = "greatcliffchest",
        checks = {
            { addr=0x7E0773, mask=0x20, codes={"@Great Cliff/Cave after climbing vine/Chest", "@Overworld_dungeons/Great Cliff/Cave after climbing vine"} },
            { addr=0x7E0774, mask=0x08, codes={"@Great Cliff/Claw Climb near start/Chest", "@Overworld_dungeons/Great Cliff/Claw Climb near start"} },
            { addr=0x7E0774, mask=0x02, codes={"@Great Cliff/Hold Left for final drop/Chest", "@Overworld_dungeons/Great Cliff/Hold Left for final drop"} },
            { addr=0x7E0771, mask=0x40, codes={"@Great Cliff/Roc Spear/Chest", "@Overworld_dungeons/Great Cliff/Roc Spear"} },
            { addr=0x7E0774, mask=0x01, codes={"@Great Cliff/Claw climb after Sharp Claws/Chest", "@Overworld_dungeons/Great Cliff/Claw climb after Sharp Claws"} },
            { addr=0x7E0774, mask=0x04, codes={"@Great Cliff/Claw Climb before final drop/Chest", "@Overworld_dungeons/Great Cliff/Claw Climb before final drop"} },
            { addr=0x7E0773, mask=0x40, codes={"@Great Cliff/Cave to left of final drop/Chest", "@Overworld_dungeons/Great Cliff/Cave to left of final drop"} },
            { addr=0x7E06EB, mask=0x80, codes={"@Great Cliff/Dark Twins/Boss", "@Overworld_dungeons/Great Cliff/Dark Twins"} }
        },
    },
    {
        id = "great_lakes",
        name = "Great Lakes",
        item_code = "greatlakeschest",
        checks = {
            { addr=0x7E0779, mask=0x40, codes={"@Great Lakes/Air Herb/Chest", "@Overworld_dungeons/Great Lakes/Air Herb"} },
            { addr=0x7E0773, mask=0x01, codes={"@Great Lakes/Magic Anchor/Chest", "@Overworld_dungeons/Great Lakes/Magic Anchor"} },
            { addr=0x7E0779, mask=0x20, codes={"@Great Lakes/Waterfall/Chest", "@Overworld_dungeons/Great Lakes/Waterfall Chest"} },
            { addr=0x7E0779, mask=0x80, codes={"@Great Lakes/Stairs/Chest", "@Overworld_dungeons/Great Lakes/Stairs Chest"} },
            { addr=0x7E077B, mask=0x08, codes={"@Great Lakes/Diving/Chest", "@Overworld_dungeons/Great Lakes/Diving Chest"} },
            { addr=0x7E06F4, mask=0x04, codes={"@Great Lakes/Hitoderon/Boss", "@Overworld_dungeons/Great Lakes/Hitoderon"} },
        },
    },
    {
        id = "louran",
        name = "Louran",
        item_code = "louranchest",
        checks = {
            { addr=0x7E0772, mask=0x01, codes={"@Louran/Inn/Chest", "@Overworld_dungeons/Louran/Inn"} },
            { addr=0x7E0771, mask=0x80, codes={"@Louran/Red Scarf/Scarf", "@Overworld_dungeons/Louran/Red Scarf"} },
            { addr=0x7E076C, mask=0x04, codes={"@Louran/Storage Chests/1", "@Overworld_dungeons/Louran/Storage Chest 1"} },
            { addr=0x7E0777, mask=0x08, codes={"@Louran/Storage Chests/2", "@Overworld_dungeons/Louran/Storage Chest 2"} },
            { addr=0x7E0772, mask=0x04, codes={"@Louran/Light Rod/Chest", "@Overworld_dungeons/Louran/Light Rod"} },
            { addr=0x7E0772, mask=0x02, codes={"@Louran/Holy Seal/Chest", "@Overworld_dungeons/Louran/Holy Seal"} },
            { addr=0x7E0777, mask=0x80, codes={"@Louran/North House 1/Chest", "@Overworld_dungeons/Louran/North House 1"} },
            { addr=0x7E0777, mask=0x40, codes={"@Louran/North House 2/Chest", "@Overworld_dungeons/Louran/North House 2"} },
            { addr=0x7E077F, mask=0x08, codes={"@Louran/Outside/Chest", "@Overworld_dungeons/Louran/Outside Chest"} },
            { addr=0x7E06EA, mask=0x04, codes={"@Louran/Talk to/Meilin", "@Overworld_dungeons/Louran/Talk to Meilin"} } -- oder addr=0x7E06E6, mask=0x08 oder addr=0x7E06E8, mask=0x80
        },
    },
    {
        id = "mermaid_tower",
        name = "Mermaid Tower",
        item_code = "mermaidtower",
        checks = {
            { addr=0x7E0718, mask=0x40, codes={"@Overworld_dungeons/Mermaid Tower/Boss"} }, -- oder addr=0x7E06ED, mask=0x02
            { addr=0x7E06ED, mask=0x04, codes={"@Overworld_dungeons/Mermaid Tower/Talk to the mermaid"} },
            { addr=0x7E077F, mask=0x80, codes={"@Overworld_dungeons/Mermaid Tower/Chest"} }
        },
    },
    {
        id = "neotokio_sewers",
        name = "Neotokio Sewers",
        item_code = "neotokiochest",
        checks = {
            { addr=0x7E0773, mask=0x02, codes={"@Neotokio Sewers/Sewer Key/Chest", "@Overworld_dungeons/Neotokio Sewers/Dungeon"} },
            { addr=0x7E0778, mask=0x40, codes={"@Neotokio Sewers/After sewer key door/Chest", "@Overworld_dungeons/Neotokio Sewers/After sewer key door Chest"} },
            { addr=0x7E0779, mask=0x01, codes={"@Neotokio Sewers/Sewers 2 Chest 1/Chest", "@Overworld_dungeons/Neotokio Sewers/Sewers 2 Chest 1"} },
            { addr=0x7E0778, mask=0x80, codes={"@Neotokio Sewers/Sewers 2 Chest 2/Chest", "@Overworld_dungeons/Neotokio Sewers/Sewers 2 Chest 2"} },
            { addr=0x7E077A, mask=0x02, codes={"@Neotokio Sewers/Sewers 3/Chest", "@Overworld_dungeons/Neotokio Sewers/Sewers 3 Chest"} },
            { addr=0x7E06EE, mask=0x04, codes={"@Neotokio Sewers/Save the girl/Starstone", "@Overworld_dungeons/Neotokio Sewers/Save the girl"} },
        },
    },
    {
        id = "norfest_forest",
        name = "Norfest Forest",
        item_code = "forestchest",
        checks = {
            { addr=0x7E0776, mask=0x10, codes={"@Norfest Forest/Ring Mail/Chest", "@Overworld_dungeons/Norfest Forest/Ring Mail"} },
            { addr=0x7E0779, mask=0x02, codes={"@Norfest Forest/Behind Tree/Chest", "@Overworld_dungeons/Norfest Forest/Chest behind tree"} },
            { addr=0x7E0779, mask=0x04, codes={"@Norfest Forest/Dark Place/Chest", "@Overworld_dungeons/Norfest Forest/Dark Place Chest"} },
            { addr=0x7E0779, mask=0x08, codes={"@Norfest Forest/Dog Whistle/Chest", "@Overworld_dungeons/Norfest Forest/Dog Whistle Chest"} },
            { addr=0x7E0779, mask=0x10, codes={"@Norfest Forest/Before Bridge/Chest", "@Overworld_dungeons/Norfest Forest/Before Bridge Chest"} },
            { addr=0x7E0772, mask=0x80, codes={"@Norfest Forest/Storkolm/Chest", "@Overworld_dungeons/Norfest Forest/Storkolm Chest"} },
            { addr=0x7E0772, mask=0x40, codes={"@Norfest Forest/Storkolm/Portrait", "@Overworld_dungeons/Norfest Forest/Storkolm Portrait"} }
        },
    },
    {
        id = "overworld_airs_rock",
        name = "Airs Rock",
        checks = {
            { addr=0x7E06EF, mask=0x01, codes={"@Overworld/Airs Rock/Old Man (Starstone only)"}}
        },
    },{
        id = "overworld_alaska_cave",
        name = "Alaska Cave",
        checks = {
            { addr=0x7E0762, mask=0x04, codes={"@Overworld/Alaska Cave/Chest"}}
        },
    },
    {
        id = "overworld_alaska_forest",
        name = "Alaska Forest",
        checks = {
            { addr=0x7E077C, mask=0x01, codes={"@Overworld/Alaska Forest/Chest"}}
        },
    },
    {
        id = "overworld_astarika_chests",
        name = "Astarika",

        -- progressive chest overlay (2 -> 1 -> open)
        item_code = "astarikachest",
        checks = {
            { addr=0x7E077F, mask=0x40, codes={"@Overworld_dungeons/Astarika/Chest"} },
            { addr=0x7E0778, mask=0x20, codes={"@Overworld_dungeons/Astarika/Spirit Trip"} }
        },
    },
    {
        id = "overworld_australia_forest",
        name = "Australia Forest",
        checks = {
            { addr=0x7E077E, mask=0x02, codes={"@Overworld/Australia Forest/Chest"} }
        },
    },
    {
        id = "overworld_australia_mountain",
        name = "Australia Mountain",
        checks = {
            { addr=0x7E077C, mask=0x02, codes={"@Overworld/Australia Mountain/Chest 1"} },
            { addr=0x7E077E, mask=0x04, codes={"@Overworld/Australia Mountain/Chest 2"} }
        },
    },
    {
        id = "overworld_baffin_bay",
        name = "Baffin Bay",
        checks = {
            { addr=0x7E077D, mask=0x40, codes={"@Overworld/Baffin Bay/Chest"} }
        },
    },
    {
        id = "overworld_colorado_forest",
        name = "Colorado Forest",
        checks = {
            { addr=0x7E077B, mask=0x40, codes={"@Overworld/Colorado Forest/Chest 1"} },
            { addr=0x7E077D, mask=0x80, codes={"@Overworld/Colorado Forest/Chest 2"} }
        },
    },
    {
        id = "overworld_lab_tower",
        name = "Lab Tower",
        checks = {
            { addr=0x7E077A, mask=0x01, codes={"@Overworld/Lab Tower/Chest"} }
        },
    },
    {
        id = "overworld_litz",
        name = "Litz",
        checks = {
            { addr=0x7E0762, mask=0x01, codes={"@Overworld/Litz/Top Left"} }
        },
    },
    {
        id = "overworld_loire_castle",
        name = "Loire Castle",
        checks = {
            { addr=0x7E06CD, mask=0x01, codes={"@Overworld/Loire Castle/Thief"} },
            { addr=0x7E0761, mask=0x08, codes={"@Overworld/Loire Castle/Protect Bell"} }
        },
    },
    {
        id = "overworld_misc_island_1",
        name = "Misc Island 1",
        checks = {
            { addr=0x7E077A, mask=0x04, codes={"@Overworld/Misc Island 1/Chest 1"} },
            { addr=0x7E077C, mask=0x08, codes={"@Overworld/Misc Island 1/Chest 2"} }
        },
    },
    {
        id = "overworld_misc_island_2",
        name = "Misc Island 2",
        checks = {
            { addr=0x7E077C, mask=0x10, codes={"@Overworld/Misc Island 2/Chest 1"} },
            { addr=0x7E077C, mask=0x20, codes={"@Overworld/Misc Island 2/Chest 2"} }
        },
    },
    {
        id = "overworld_mu",
        name = "Mu",
        checks = {
            { addr=0x7E077D, mask=0x04, codes={"@Overworld/Mu/Chest 1"} },
            { addr=0x7E077D, mask=0x08, codes={"@Overworld/Mu/Chest 2"} }
        },
    },
    {
        id = "overworld_mushroom_forest",
        name = "Mushroom Forest",
        checks = {
            { addr=0x7E0761, mask=0x20, codes={"@Overworld/Mushroom Forest/Chest 1"} },
            { addr=0x7E0761, mask=0x40, codes={"@Overworld/Mushroom Forest/Chest 2"} },
            { addr=0x7E0761, mask=0x80, codes={"@Overworld/Mushroom Forest/Mushroom"} }
        },
    },
    {
        id = "overworld_nirlake",
        name = "Nirlake",
        checks = {
            { addr=0x7E0762, mask=0x02, codes={"@Overworld/Nirlake/Chest in house"} },
            { addr=0x7E0761, mask=0x10, codes={"@Overworld/Nirlake/Metal piece"} }
        },
    },
    {
        id = "overworld_penguinea_starstone",
        name = "Penguinea Starstone",
        checks = {
            { addr=0x7E06DC, mask=0x01, codes={"@Overworld/Penguinea (Starstone only)/Penguin"} }
        },
    },
    {
        id = "overworld_sahara_skeleton",
        name = "Sahara (Skeleton)",
        checks = {
            { addr=0x7E06F0, mask=0x01, codes={"@Overworld/Sahara (Skeleton)/Chest"}}
        },
    },
    {
        id = "overworld_sahara_top_left",
        name = "Sahara (Top Left)",
        checks = {
            { addr=0x7E077D, mask=0x01, codes={"@Overworld/Sahara (Top Left)/Chest 1"}},
            { addr=0x7E077D, mask=0x02, codes={"@Overworld/Sahara (Top Left)/Chest 2"}}
        },
    },
    {
        id = "overworld_santiago_forest",
        name = "Santiago Forest",
        checks = {
            { addr=0x7E077B, mask=0x20, codes={"@Overworld/Santiago Forest/Chest 1"}},
            { addr=0x7E077B, mask=0x10, codes={"@Overworld/Santiago Forest/Chest 2"}}
        },
    },
    {
        id = "overworld_siberia_cave",
        name = "Siberia Cave",
        checks = {
            { addr=0x7E077C, mask=0x80, codes={"@Overworld/Siberia Cave/Chest"}}
        },
    },
    {
        id = "overworld_south_pole",
        name = "South Pole",
        checks = {
            { addr=0x7E077E, mask=0x01, codes={"@Overworld/South Pole/Chest 1"}},
            { addr=0x7E077D, mask=0x80, codes={"@Overworld/South Pole/Chest 2"}}
        },
    },
    {
        id = "ra_tree",
        name = "Ra Tree",
        item_code = "ratree",
        checks = {
            { addr=0x7E0762, mask=0x08, codes={"@Ra Tree/Before Tree/Chest", "@Overworld_dungeons/Ra Tree/Before Tree Chest"} },
            { addr=0x7E0776, mask=0x04, codes={"@Ra Tree/Cave 1 1/Chest", "@Overworld_dungeons/Ra Tree/Cave 1 Chest 1"} },
            { addr=0x7E077D, mask=0x20, codes={"@Ra Tree/Cave 1 2/Chest", "@Overworld_dungeons/Ra Tree/Cave 1 Chest 2"} },
            { addr=0x7E077D, mask=0x10, codes={"@Ra Tree/Cave 1 3/Chest", "@Overworld_dungeons/Ra Tree/Cave 1 Chest 3"} },
            { addr=0x7E0775, mask=0x10, codes={"@Ra Tree/Cave 1 4/Chest", "@Overworld_dungeons/Ra Tree/Cave 1 Chest 4"} },
            { addr=0x7E0773, mask=0x04, codes={"@Ra Tree/Cave 2 6_7/Chest 6", "@Overworld_dungeons/Ra Tree/Cave 2 Chest 6"} },
            { addr=0x7E0771, mask=0x04, codes={"@Ra Tree/Cave 2 6_7/Chest 7", "@Overworld_dungeons/Ra Tree/Cave 2 Chest 7"} },
            { addr=0x7E077A, mask=0x20, codes={"@Ra Tree/Cave 2 8/Chest", "@Overworld_dungeons/Ra Tree/Cave 2 Chest 8"} },
            { addr=0x7E077A, mask=0x08, codes={"@Ra Tree/Cave 3 9/Chest", "@Overworld_dungeons/Ra Tree/Cave 3 Chest 9"} },
            { addr=0x7E0771, mask=0x08, codes={"@Ra Tree/Cave 3 10/Chest", "@Overworld_dungeons/Ra Tree/Cave 3 Chest 10"} },
            { addr=0x7E077A, mask=0x10, codes={"@Ra Tree/Cave 3 11/Chest", "@Overworld_dungeons/Ra Tree/Cave 3 Chest 11"} },
            { addr=0x7E0760, mask=0x80, codes={"@Ra Tree/Cave 5 12/Chest", "@Overworld_dungeons/Ra Tree/Cave 5 Chest 12"} },
            { addr=0x7E0771, mask=0x20, codes={"@Ra Tree/Cave 5 13/Chest", "@Overworld_dungeons/Ra Tree/Cave 5 Chest 13"} },
            { addr=0x7E0771, mask=0x10, codes={"@Ra Tree/Cave 4/Giant Leaves", "@Overworld_dungeons/Ra Tree/Giant Leaves"} },
            { addr=0x7E077A, mask=0x20, codes={"@Ra Tree/Parasite/Boss", "@Overworld_dungeons/Ra Tree/Parasite"} }
        },
    },
    {
        id = "sylvain_casle",
        name = "Sylvain Castle",
        item_code = "sylvainchest",
        checks = {
            { addr=0x7E0776, mask=0x20, codes={"@Sylvain Castle/Basement/Chest", "@Overworld_dungeons/Sylvain Castle/Basement Chest"} },
            { addr=0x7E0777, mask=0x04, codes={"@Sylvain Castle/Outside/Chest", "@Overworld_dungeons/Sylvain Castle/Outside Chest"} },
            { addr=0x7E0777, mask=0x02, codes={"@Sylvain Castle/1st Floor West Side/Chest", "@Overworld_dungeons/Sylvain Castle/1st Floor West Side Chest"} },
            { addr=0x7E0776, mask=0x40, codes={"@Sylvain Castle/1st Floor North Side/Chest", "@Overworld_dungeons/Sylvain Castle/1st Floor North Side Chest"} },
            { addr=0x7E0772, mask=0x10, codes={"@Sylvain Castle/Back Room 1/Guard Left", "@Overworld_dungeons/Sylvain Castle/Back Room 1 Guard Left"} },
            { addr=0x7E0772, mask=0x08, codes={"@Sylvain Castle/Back Room 1/Guard Top", "@Overworld_dungeons/Sylvain Castle/Back Room 1 Guard Top"} },
            { addr=0x7E06E7, mask=0x02, codes={"@Sylvain Castle/Back Room 1/Black Opal", "@Overworld_dungeons/Sylvain Castle/Back Room 1 Black Opal"} },
            { addr=0x7E06E7, mask=0x08, codes={"@Sylvain Castle/Topaz/Outside", "@Overworld_dungeons/Sylvain Castle/Topaz Outside"} },
            { addr=0x7E0777, mask=0x01, codes={"@Sylvain Castle/Back Room 2/Chest", "@Overworld_dungeons/Sylvain Castle/Back Room 2 Chest"} },
            { addr=0x7E06E7, mask=0x01, codes={"@Sylvain Castle/Courtyard/Sapphire", "@Overworld_dungeons/Sylvain Castle/Courtyard Sapphire"} },
            { addr=0x7E0772, mask=0x20, codes={"@Sylvain Castle/1st Floor South Side/Chest 1", "@Overworld_dungeons/Sylvain Castle/1st Floor South Side Chest 1"} },
            { addr=0x7E0776, mask=0x80, codes={"@Sylvain Castle/1st Floor South Side/Chest 2", "@Overworld_dungeons/Sylvain Castle/1st Floor South Side Chest 2"} },
            { addr=0x7E06EC, mask=0x08, codes={"@Sylvain Castle/Bloody Mary/Boss", "@Overworld_dungeons/Sylvain Castle/Bloody Mary"} }
        },
    },
    {
        id = "zue",
        name = "Zue",
        item_code = "zuechest",
        checks = {
            { addr=0x7E077B, mask=0x01, codes={"@Zue/Chests by Rocks/Chest 1", "@Overworld_dungeons/Zue/Without Giant Leaves 1"} },
            { addr=0x7E077B, mask=0x02, codes={"@Zue/Chests by Rocks/Chest 2", "@Overworld_dungeons/Zue/Without Giant Leaves 2"} },
            { addr=0x7E077A, mask=0x80, codes={"@Zue/Swimming after Giant Leaves/Chest", "@Overworld_dungeons/Zue/Swimming after Giant Leaves"} },
            { addr=0x7E077B, mask=0x04, codes={"@Zue/Crawl space/Chest 1", "@Overworld_dungeons/Zue/Crawl space 1"} },
            { addr=0x7E077F, mask=0x04, codes={"@Zue/Crawl space/Chest 2", "@Overworld_dungeons/Zue/Crawl space 2"} },
            { addr=0x7E0774, mask=0x20, codes={"@Zue/North of swimming/Chest", "@Overworld_dungeons/Zue/North of swimming Chest"} },
            { addr=0x7E0775, mask=0x01, codes={"@Zue/Crawl space after swimming/Chest", "@Overworld_dungeons/Zue/Crawl space after swimming"} },
            { addr=0x7E0774, mask=0x40, codes={"@Zue/Swimming before Storm Keeper/Chest 1", "@Overworld_dungeons/Zue/Swimming before Storm Keeper 1"} },
            { addr=0x7E0774, mask=0x80, codes={"@Zue/Swimming before Storm Keeper/Chest 2", "@Overworld_dungeons/Zue/Swimming before Storm Keeper 2"} },
            { addr=0x7E076C, mask=0x08, codes={"@Zue/Swimming near the start/Chest", "@Overworld_dungeons/Zue/Swimming near the start"} },
            { addr=0x7E0718, mask=0x10, codes={"@Zue/Storm Keeper/Boss", "@Overworld_dungeons/Zue/Storm Keeper"} }
        },
    },
    {
        id = "dark_gaia",
        name = "Dark Gaia",
        checks = {
            { addr=0x7E06F6, mask=0x02, codes={} } -- death of dark gaia -> TIME
        }
    }
}
