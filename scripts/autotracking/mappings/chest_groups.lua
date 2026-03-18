CHEST_GROUP_MAPPING = {
    {
        id = "berugas_lab",
        name = "Berugas Lab",
        progress_code = "berugaslabchest",
        checks = {
            { addr=0x7E0778, mask=0x01, codes={"@Berugas Lab/1F/Chest", "@Overworld_dungeons/Berugas Lab/1F Chest"} },
            { addr=0x7E077F, mask=0x10, codes={"@Berugas Lab/B2F/Chest", "@Overworld_dungeons/Berugas Lab/B2F Chest"} },
            { addr=0x7E06F4, mask=0x20, codes={"@Berugas Lab/Security Robot/Boss", "@Overworld_dungeons/Berugas Lab/Security Robot (Starstone only)"}, reward_codes={"robot"} } -- oder addr=0x7E0718, mask=0x04
        },
    },
    {
        id = "dragoon_castle",
        name = "Dragoon Castle",
        progress_code = "dragoonchest",
        checks = {
            { addr=0x7E0778, mask=0x02, codes={"@Dragoon Castle/Right Side 1/Chest"}, section_codes={"@Overworld_dungeons/Dragoon Castle/Dungeon (Right)"} },
            { addr=0x7E0778, mask=0x08, codes={"@Dragoon Castle/Right Side 2/Chest"}, section_codes={"@Overworld_dungeons/Dragoon Castle/Dungeon (Right)"} },
            { addr=0x7E0778, mask=0x04, codes={"@Dragoon Castle/Right Side 3/Chest"}, section_codes={"@Overworld_dungeons/Dragoon Castle/Dungeon (Right)"} },
            { addr=0x7E0778, mask=0x10, codes={"@Dragoon Castle/Right Side 4/Chest"}, section_codes={"@Overworld_dungeons/Dragoon Castle/Dungeon (Right)"} },
            { addr=0x7E0773, mask=0x10, codes={"@Dragoon Castle/Rando Room/Chest 1"}, section_codes={"@Overworld_dungeons/Dragoon Castle/Dungeon (Left)"} },
            { addr=0x7E0773, mask=0x08, codes={"@Dragoon Castle/Rando Room/Chest 2"}, section_codes={"@Overworld_dungeons/Dragoon Castle/Dungeon (Left)"} },
            { addr=0x7E077A, mask=0x40, codes={"@Dragoon Castle/Rando Room/Chest 3"}, section_codes={"@Overworld_dungeons/Dragoon Castle/Dungeon (Left)"}, reward_codes={"dragooncastle"} }
        },
    },
    {
        id = "eklamata",
        name = "Eklamata",
        progress_code = "eklamatachest",
        checks = {
            { addr=0x7E0775, mask=0x40, codes={"@Eklamata/Smash the wall/Chest"}, section_codes={"@Overworld_dungeons/Eklamata/Dungeon (Without Snowgrass Leaf)"} },
            { addr=0x7E0776, mask=0x01, codes={"@Eklamata/Drop down the hole/Chest"}, section_codes={"@Overworld_dungeons/Eklamata/Dungeon (Without Snowgrass Leaf)"} },
            { addr=0x7E0760, mask=0x40, codes={"@Eklamata/Snowgrass Leaf/Chest"}, section_codes={"@Overworld_dungeons/Eklamata/Dungeon (Without Snowgrass Leaf)"} },
            { addr=0x7E0775, mask=0x02, codes={"@Eklamata/Outside Leaf 1/Chest"}, section_codes={"@Overworld_dungeons/Eklamata/Dungeon (With Snowgrass Leaf)"} },
            { addr=0x7E0775, mask=0x80, codes={"@Eklamata/Rando Cave/Chest 1"}, section_codes={"@Overworld_dungeons/Eklamata/Dungeon (With Snowgrass Leaf)"} },
            { addr=0x7E0776, mask=0x08, codes={"@Eklamata/Rando Cave/Chest 2"}, section_codes={"@Overworld_dungeons/Eklamata/Dungeon (With Snowgrass Leaf)"} },
            { addr=0x7E0776, mask=0x02, codes={"@Eklamata/Rando Cave/Chest 3"}, section_codes={"@Overworld_dungeons/Eklamata/Dungeon (With Snowgrass Leaf)"} },
            { addr=0x7E0775, mask=0x04, codes={"@Eklamata/Outside Leaf 2/Chest"}, section_codes={"@Overworld_dungeons/Eklamata/Dungeon (With Snowgrass Leaf)"} },
            { addr=0x7E0775, mask=0x08, codes={"@Eklamata/Inside Leaf 1/Chest"}, section_codes={"@Overworld_dungeons/Eklamata/Dungeon (With Snowgrass Leaf)"} },
            { addr=0x7E0775, mask=0x20, codes={"@Eklamata/Inside Leaf 2/Chest"}, section_codes={"@Overworld_dungeons/Eklamata/Dungeon (With Snowgrass Leaf)"} },
            { addr=0x7E06EC, mask=0x02, codes={"@Eklamata/Dark Morph/Boss"}, section_codes={"@Overworld_dungeons/Eklamata/Dark Morph (Starstone only)"}, reward_codes={"darkmorph"} }
        },
    },
    {
        id = "great_cliff",
        name = "Great Cliff",
        progress_code = "greatcliffchest",
        checks = {
            { addr=0x7E0773, mask=0x20, codes={"@Great Cliff/First Caves/Chest"}, section_codes={"@Overworld_dungeons/Great Cliff/Dungeon (Without Claws)"} },
            { addr=0x7E0774, mask=0x08, codes={"@Great Cliff/Outside (Before Roc Spear Cave)/Chest"}, section_codes={"@Overworld_dungeons/Great Cliff/Dungeon (Without Claws)"} },
            { addr=0x7E0774, mask=0x02, codes={"@Great Cliff/Hold Left for final drop/Chest"}, section_codes={"@Overworld_dungeons/Great Cliff/Dungeon (Without Claws)"} },
            { addr=0x7E0771, mask=0x40, codes={"@Great Cliff/Roc Spear/Chest"}, section_codes={"@Overworld_dungeons/Great Cliff/Dungeon (With Claws)"} },
            { addr=0x7E0774, mask=0x01, codes={"@Great Cliff/Claw climb after Sharp Claws/Chest"}, section_codes={"@Overworld_dungeons/Great Cliff/Dungeon (With Claws)"} },
            { addr=0x7E0774, mask=0x04, codes={"@Great Cliff/Claw Climb before final drop/Chest"}, section_codes={"@Overworld_dungeons/Great Cliff/Dungeon (With Claws)"} },
            { addr=0x7E0773, mask=0x40, codes={"@Great Cliff/Cave to left of final drop/Chest"}, section_codes={"@Overworld_dungeons/Great Cliff/Dungeon (With Claws)"} },
            { addr=0x7E06EB, mask=0x80, codes={"@Great Cliff/Dark Twins/Boss"}, section_codes={"@Overworld_dungeons/Great Cliff/Dark Twins (Starstone only)"}, reward_codes={"darktwins"} }
        },
    },
    {
        id = "great_lakes",
        name = "Great Lakes",
        progress_code = "greatlakeschest",
        checks = {
            { addr=0x7E0779, mask=0x40, codes={"@Great Lakes/Air Herb/Chest"}, section_codes={"@Overworld_dungeons/Great Lakes/Air Herb (With Mermaid Ring)"} },
            { addr=0x7E0773, mask=0x01, codes={"@Great Lakes/Magic Anchor/Chest"}, section_codes={"@Overworld_dungeons/Great Lakes/Dungeon (With Ring, Air Herb, Giant Leaves)"} },
            { addr=0x7E0779, mask=0x20, codes={"@Great Lakes/Waterfall/Chest"}, section_codes={"@Overworld_dungeons/Great Lakes/Dungeon (With Ring, Air Herb, Giant Leaves)"} },
            { addr=0x7E0779, mask=0x80, codes={"@Great Lakes/Stairs/Chest"}, section_codes={"@Overworld_dungeons/Great Lakes/Dungeon (With Ring, Air Herb, Giant Leaves)"} },
            { addr=0x7E077B, mask=0x08, codes={"@Great Lakes/Diving/Chest"}, section_codes={"@Overworld_dungeons/Great Lakes/Dungeon (With Ring, Air Herb, Giant Leaves, Magicanchor)"} },
            { addr=0x7E06F4, mask=0x02, codes={"@Great Lakes/Hitoderon/Boss"}, section_codes={"@Overworld_dungeons/Great Lakes/Hitoderon (Starstone only)"}, reward_codes={"hitoderon"} },
        },
    },
    {
        id = "louran",
        name = "Louran",
        progress_code = "louranchest",
        checks = {
            { addr=0x7E0772, mask=0x01, codes={"@Louran/Inn/Chest"}, section_codes={"@Overworld_dungeons/Louran/Dungeon (Without Holy Seal)"} },
            { addr=0x7E0771, mask=0x80, codes={"@Louran/Red Scarf/Scarf"}, section_codes={"@Overworld_dungeons/Louran/Dungeon (Without Holy Seal)"} },
            { addr=0x7E0777, mask=0x10, codes={"@Louran/Storage Chests/Chest 1"}, section_codes={"@Overworld_dungeons/Louran/Dungeon (Without Holy Seal)"} },
            { addr=0x7E0777, mask=0x08, codes={"@Louran/Storage Chests/Chest 2"}, section_codes={"@Overworld_dungeons/Louran/Dungeon (Without Holy Seal)"} },
            { addr=0x7E0772, mask=0x04, codes={"@Louran/Light Rod/Chest"}, section_codes={"@Overworld_dungeons/Louran/Dungeon (Without Holy Seal)"} },
            { addr=0x7E0772, mask=0x02, codes={"@Louran/Holy Seal/Chest"}, section_codes={"@Overworld_dungeons/Louran/Dungeon (Without Holy Seal)"} },
            { addr=0x7E0777, mask=0x80, codes={"@Louran/North House 1/Chest"}, section_codes={"@Overworld_dungeons/Louran/Dungeon (With Holy Seal)"} },
            { addr=0x7E0777, mask=0x40, codes={"@Louran/North House 2/Chest"}, section_codes={"@Overworld_dungeons/Louran/Dungeon (With Holy Seal)"} },
            { addr=0x7E077F, mask=0x08, codes={"@Louran/Outside/Chest"}, section_codes={"@Overworld_dungeons/Louran/Dungeon (With Holy Seal)"} },
            { addr=0x7E06EA, mask=0x04, codes={"@Louran/Talk to/Meilin"}, section_codes={"@Overworld_dungeons/Louran/Talk to Meilin (Starstone only)"}, reward_codes={"louran"} } -- oder addr=0x7E06E6, mask=0x08 oder addr=0x7E06E8, mask=0x80
        },
    },
    {
        id = "mermaid_tower",
        name = "Mermaid Tower",
        progress_code = "mermaidschest",
        checks = {
            { addr=0x7E0718, mask=0x40, codes={"@Overworld_dungeons/Mermaid Tower/Boss (Starstone only)"}, reward_codes={"mermaidtower"} },
            { addr=0x7E06ED, mask=0x04, codes={"@Overworld_dungeons/Mermaid Tower/Talk to the mermaid"} },
            { addr=0x7E077F, mask=0x80, codes={"@Overworld_dungeons/Mermaid Tower/Chest"} }
        },
    },
    {
        id = "neotokio_sewers",
        name = "Neotokio Sewers",
        progress_code = "neotokiochest",
        checks = {
            { addr=0x7E0773, mask=0x02, codes={"@Neotokio Sewers/Sewer Key/Chest"}, section_codes={"@Overworld_dungeons/Neotokio Sewers/Dungeon"} },
            { addr=0x7E0778, mask=0x40, codes={"@Neotokio Sewers/After sewer key door/Chest"}, section_codes={"@Overworld_dungeons/Neotokio Sewers/Dungeon (With sewerkey)"} },
            { addr=0x7E0779, mask=0x01, codes={"@Neotokio Sewers/Sewers 2 Chest 1/Chest"}, section_codes={"@Overworld_dungeons/Neotokio Sewers/Dungeon (With sewerkey)"} },
            { addr=0x7E0778, mask=0x80, codes={"@Neotokio Sewers/Sewers 2 Chest 2/Chest"}, section_codes={"@Overworld_dungeons/Neotokio Sewers/Dungeon (With sewerkey)"} },
            { addr=0x7E077A, mask=0x02, codes={"@Neotokio Sewers/Sewers 3/Chest"}, section_codes={"@Overworld_dungeons/Neotokio Sewers/Dungeon (With sewerkey)"} },
            { addr=0x7E06EE, mask=0x04, codes={"@Neotokio Sewers/Save the girl/Starstone"}, section_codes={"@Overworld_dungeons/Neotokio Sewers/Save the girl"}, reward_codes={"neotokio"} },
        },
    },
    {
        id = "norfest_forest",
        name = "Norfest Forest",
        progress_code = "forestchest",
        checks = {
            { addr=0x7E0776, mask=0x10, codes={"@Norfest Forest/Ring Mail/Chest"}, section_codes={"@Overworld_dungeons/Norfest Forest/Ring Mail"} },
            { addr=0x7E0779, mask=0x02, codes={"@Norfest Forest/Behind Tree/Chest"}, section_codes={"@Overworld_dungeons/Norfest Forest/Throughout the forest"} },
            { addr=0x7E0779, mask=0x04, codes={"@Norfest Forest/Dark Place/Chest"}, section_codes={"@Overworld_dungeons/Norfest Forest/Throughout the forest"} },
            { addr=0x7E0779, mask=0x08, codes={"@Norfest Forest/Dog Whistle/Chest"}, section_codes={"@Overworld_dungeons/Norfest Forest/Throughout the forest"} },
            { addr=0x7E0779, mask=0x10, codes={"@Norfest Forest/Before Bridge/Chest"}, section_codes={"@Overworld_dungeons/Norfest Forest/Throughout the forest"} },
            { addr=0x7E0772, mask=0x80, codes={"@Norfest Forest/Storkolm/Chest"}, section_codes={"@Overworld_dungeons/Norfest Forest/Storkolm"} },
            { addr=0x7E0772, mask=0x40, codes={"@Norfest Forest/Storkolm/Portrait"}, section_codes={"@Overworld_dungeons/Norfest Forest/Storkolm"}, reward_codes={"norfest"} }
        },
    },
    {
        id = "overworld_airs_rock",
        name = "Airs Rock",
        checks = {
            { addr=0x7E06EF, mask=0x01, codes={"@Overworld/Airs Rock/Old Man (Starstone only)"}, reward_codes={"airsrock"}}
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
        progress_code = "astarikachest",
        checks = {
            { addr=0x7E077F, mask=0x40, codes={"@Overworld_dungeons/Astarika/Chest"} },
            { addr=0x7E0778, mask=0x20, codes={"@Overworld_dungeons/Astarika/Spirit Trip"}, reward_codes={"astarika"} }
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
            { addr=0x7E077C, mask=0x04, codes={"@Overworld/Australia Mountain/Chest 2"} }
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
            { addr=0x7E077B, mask=0x80, codes={"@Overworld/Colorado Forest/Chest 2"} }
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
        progress_code = "castle",
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
            { addr=0x7E0762, mask=0x02, codes={"@Overworld/Nirlake/Down Left House Chest"} },
            { addr=0x7E0761, mask=0x10, codes={"@Overworld/Nirlake/Metal piece"} }
        },
    },
    {
        id = "overworld_penguinea_starstone",
        name = "Penguinea Starstone",
        checks = {
            { addr=0x7E06DC, mask=0x01, codes={"@Overworld/Penguinea/Penguin (Starstone only)"}, reward_codes={"penguinea"} }
        },
    },
    {
        id = "overworld_sahara_skeleton",
        name = "Sahara (Skeleton)",
        checks = {
            { addr=0x7E06F0, mask=0x01, codes={"@Overworld/Sahara (Skeleton)/Skeleton"}}
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
        progress_code = "rachests",
        checks = {
            { addr=0x7E0762, mask=0x08, codes={"@Ra Tree/Before Tree/Chest"}, section_codes={"@Overworld_dungeons/Ra Tree/Before and Cave 1"} },
            { addr=0x7E0776, mask=0x04, codes={"@Ra Tree/Cave 1 1/Chest"}, section_codes={"@Overworld_dungeons/Ra Tree/Before and Cave 1"} },
            { addr=0x7E077D, mask=0x20, codes={"@Ra Tree/Cave 1 2/Chest"}, section_codes={"@Overworld_dungeons/Ra Tree/Before and Cave 1"} },
            { addr=0x7E077D, mask=0x10, codes={"@Ra Tree/Cave 1 3/Chest"}, section_codes={"@Overworld_dungeons/Ra Tree/Before and Cave 1"} },
            { addr=0x7E0775, mask=0x10, codes={"@Ra Tree/Cave 1 4/Chest"}, section_codes={"@Overworld_dungeons/Ra Tree/Before and Cave 1"} },
            { addr=0x7E0774, mask=0x10, codes={"@Ra Tree/Cave 1 5/Chest"}, section_codes={"@Overworld_dungeons/Ra Tree/Before and Cave 1"} },
            { addr=0x7E0773, mask=0x04, codes={"@Ra Tree/Cave 2 6_7/Chest 6"}, section_codes={"@Overworld_dungeons/Ra Tree/Cave 2"} },
            { addr=0x7E0771, mask=0x04, codes={"@Ra Tree/Cave 2 6_7/Chest 7"}, section_codes={"@Overworld_dungeons/Ra Tree/Cave 2"} },
            { addr=0x7E077A, mask=0x20, codes={"@Ra Tree/Cave 2 8/Chest"}, section_codes={"@Overworld_dungeons/Ra Tree/Cave 2"} },
            { addr=0x7E077A, mask=0x08, codes={"@Ra Tree/Cave 3 9/Chest"}, section_codes={"@Overworld_dungeons/Ra Tree/Cave 3"} },
            { addr=0x7E0771, mask=0x08, codes={"@Ra Tree/Cave 3 10/Chest"}, section_codes={"@Overworld_dungeons/Ra Tree/Cave 3"} },
            { addr=0x7E077A, mask=0x10, codes={"@Ra Tree/Cave 3 11/Chest"}, section_codes={"@Overworld_dungeons/Ra Tree/Cave 3"} },
            { addr=0x7E0771, mask=0x10, codes={"@Ra Tree/Cave 4/Giant Leaves"}, section_codes={"@Overworld_dungeons/Ra Tree/Cave 5 and Giant Leaves"} },
            { addr=0x7E0760, mask=0x80, codes={"@Ra Tree/Cave 5 12/Chest"}, section_codes={"@Overworld_dungeons/Ra Tree/Cave 5 and Giant Leaves"} },
            { addr=0x7E0771, mask=0x20, codes={"@Ra Tree/Cave 5 13/Chest"}, section_codes={"@Overworld_dungeons/Ra Tree/Cave 5 and Giant Leaves"} },
            { addr=0x7E06F4, mask=0x02, codes={"@Ra Tree/Parasite/Boss"}, section_codes={"@Overworld_dungeons/Ra Tree/Parasite (Starstone only)"}, reward_codes={"parasite"} }
        },
    },
    {
        id = "sylvain_casle",
        name = "Sylvain Castle",
        progress_code = "sylvainchest",
        checks = {
            { addr=0x7E0776, mask=0x20, codes={"@Sylvain Castle/Basement/Chest"}, section_codes={"@Overworld_dungeons/Sylvain Castle/Dungeon (Without Tower Key)"} },
            { addr=0x7E0777, mask=0x04, codes={"@Sylvain Castle/Outside/Chest"}, section_codes={"@Overworld_dungeons/Sylvain Castle/Dungeon (Without Tower Key)"} },
            { addr=0x7E0777, mask=0x02, codes={"@Sylvain Castle/1st Floor West Side/Chest"}, section_codes={"@Overworld_dungeons/Sylvain Castle/Dungeon (Without Tower Key)"} },
            { addr=0x7E0776, mask=0x40, codes={"@Sylvain Castle/1st Floor North Side/Chest"}, section_codes={"@Overworld_dungeons/Sylvain Castle/Dungeon (Without Tower Key)"} },
            { addr=0x7E0772, mask=0x10, codes={"@Sylvain Castle/Back Room 1 Guard Left/Chest"}, section_codes={"@Overworld_dungeons/Sylvain Castle/Dungeon (Without Tower Key)"} },
            { addr=0x7E0772, mask=0x08, codes={"@Sylvain Castle/Back Room 1 Guard Top/Chest"}, section_codes={"@Overworld_dungeons/Sylvain Castle/Dungeon (Without Tower Key)"} },
            { addr=0x7E06E7, mask=0x02, codes={"@Sylvain Castle/Back Room 1 Black Opal/Chest"}, section_codes={"@Overworld_dungeons/Sylvain Castle/Dungeon (Without Tower Key)"} },
            { addr=0x7E06E7, mask=0x08, codes={"@Sylvain Castle/Outside (Topaz)/Topaz"}, section_codes={"@Overworld_dungeons/Sylvain Castle/Dungeon (Without Tower Key)"} },
            { addr=0x7E0777, mask=0x01, codes={"@Sylvain Castle/Back Room 2/Chest"}, section_codes={"@Overworld_dungeons/Sylvain Castle/Dungeon (Without Tower Key)"} },
            { addr=0x7E06E7, mask=0x01, codes={"@Sylvain Castle/Courtyard/Sapphire"}, section_codes={"@Overworld_dungeons/Sylvain Castle/Dungeon (With Tower Key)"} },
            { addr=0x7E0772, mask=0x20, codes={"@Sylvain Castle/1st Floor South Side/Chest 1"}, section_codes={"@Overworld_dungeons/Sylvain Castle/Dungeon (With Tower Key)"} },
            { addr=0x7E0776, mask=0x80, codes={"@Sylvain Castle/1st Floor South Side/Chest 2"}, section_codes={"@Overworld_dungeons/Sylvain Castle/Dungeon (With Tower Key)"} },
            { addr=0x7E06EC, mask=0x08, codes={"@Sylvain Castle/Bloody Mary/Boss"}, section_codes={"@Overworld_dungeons/Sylvain Castle/Bloody Mary (Starstone only)"}, reward_codes={"bloodymary"} }
        },
    },
    {
        id = "zue",
        name = "Zue",
        progress_code = "zuechest",
        checks = {
            { addr=0x7E077B, mask=0x01, codes={"@Zue/Chests by Rocks/Chest 1"}, section_codes={"@Overworld_dungeons/Zue/Dungeon (Without Giant Leaves)"} },
            { addr=0x7E077B, mask=0x02, codes={"@Zue/Chests by Rocks/Chest 2"}, section_codes={"@Overworld_dungeons/Zue/Dungeon (Without Giant Leaves)"} },
            { addr=0x7E077A, mask=0x80, codes={"@Zue/Swimming after Giant Leaves/Chest"}, section_codes={"@Overworld_dungeons/Zue/Dungeon (With Giant Leaves and Sharp Claws)"} },
            { addr=0x7E077B, mask=0x04, codes={"@Zue/Crawl space/Chest 1"}, section_codes={"@Overworld_dungeons/Zue/Dungeon (With Giant Leaves and Sharp Claws)"} },
            { addr=0x7E077F, mask=0x04, codes={"@Zue/Crawl space/Chest 2"}, section_codes={"@Overworld_dungeons/Zue/Dungeon (With Giant Leaves and Sharp Claws)"} },
            { addr=0x7E0774, mask=0x20, codes={"@Zue/North of swimming/Chest"}, section_codes={"@Overworld_dungeons/Zue/Dungeon (With Giant Leaves and Sharp Claws)"} },
            { addr=0x7E0775, mask=0x01, codes={"@Zue/Crawl space after swimming/Chest"}, section_codes={"@Overworld_dungeons/Zue/Dungeon (With Giant Leaves and Sharp Claws)"} },
            { addr=0x7E0774, mask=0x40, codes={"@Zue/Swimming After Second Altar/Chest 1"}, section_codes={"@Overworld_dungeons/Zue/Dungeon (With Giant Leaves and Sharp Claws)"} },
            { addr=0x7E0774, mask=0x80, codes={"@Zue/Swimming After Second Altar/Chest 2"}, section_codes={"@Overworld_dungeons/Zue/Dungeon (With Giant Leaves and Sharp Claws)"} },
            { addr=0x7E076C, mask=0x08, codes={"@Zue/Swimming Near Start/Chest"}, section_codes={"@Overworld_dungeons/Zue/Dungeon (With Giant Leaves and Sharp Claws)"} },
            { addr=0x7E0718, mask=0x10, codes={"@Zue/Storm Keeper/Boss"}, section_codes={"@Overworld_dungeons/Zue/Storm Keeper (Starstone only)"}, reward_codes={"stormkeeper"} }
        },
    }
}
