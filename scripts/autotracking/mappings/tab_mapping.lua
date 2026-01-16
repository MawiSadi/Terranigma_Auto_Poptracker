-- scripts/autotracking/tab_mapping.lua
TERRANIGMA_TAB_RANGES = {
    -- Louran
    { from = 0x0060, to = 0x0070, tab = "Dungeons/Louran" },
    { from = 0x01A4, to = 0x01D0, tab = "Dungeons/Louran" },

    -- Ra Tree (Tree cave)
    { from = 0x0047, to = 0x0048, tab = "Dungeons/Ra Tree/Before Tree" },
    { from = 0x012C, to = 0x0131, tab = "Dungeons/Ra Tree/Cave 1" },
    { from = 0x0137, to = 0x0137, tab = "Dungeons/Ra Tree/Cave 1" },
    { from = 0x0132, to = 0x0133, tab = "Dungeons/Ra Tree/Cave 2" },
    { from = 0x0134, to = 0x0136, tab = "Dungeons/Ra Tree/Cave 3" },
    { from = 0x0139, to = 0x0139, tab = "Dungeons/Ra Tree/Cave 3" },
    { from = 0x013A, to = 0x013B, tab = "Dungeons/Ra Tree/Cave 4" },
    { from = 0x013E, to = 0x013F, tab = "Dungeons/Ra Tree/Cave 5" },

    -- Great Cliff (Grecliff)
    { from = 0x0145, to = 0x014E, tab = "Dungeons/Great Cliff/Outside" },
    { from = 0x014F, to = 0x015B, tab = "Dungeons/Great Cliff/Inside" },

    -- Zue
    { from = 0x015E, to = 0x0171, tab = "Dungeons/Zue" },

    -- Eklamata (Eklemata)
    { from = 0x0172, to = 0x0172, tab = "Dungeons/Eklamata/Outside 1" },
    { from = 0x0189, to = 0x018A, tab = "Dungeons/Eklamata/Outside 1" },
    { from = 0x017D, to = 0x0188, tab = "Dungeons/Eklamata/Inside" },
    { from = 0x0173, to = 0x0179, tab = "Dungeons/Eklamata/Outside 2" },
    { from = 0x018B, to = 0x018B, tab = "Dungeons/Eklamata/Outside 2" },

    -- Norfest Forest
    { from = 0x0190, to = 0x0196, tab = "Dungeons/Norfest Forest/Entrance" },
    { from = 0x0197, to = 0x0197, tab = "Dungeons/Norfest Forest/Before Dark Place" },
    { from = 0x0198, to = 0x0199, tab = "Dungeons/Norfest Forest/Dark Place" },
    { from = 0x019A, to = 0x019A, tab = "Dungeons/Norfest Forest/Dark Place 2" },
    { from = 0x019E, to = 0x019F, tab = "Dungeons/Norfest Forest/Before Bridge" },
    { from = 0x01F4, to = 0x01F7, tab = "Dungeons/Norfest Forest/Storkolm" },
    { from = 0x019A, to = 0x019D, tab = "Dungeons/Norfest Forest" },

    -- Beruga's Lab (+ Labtower)
    { from = 0x0226, to = 0x0226, tab = "Dungeons/Berugas Lab" },
    { from = 0x0227, to = 0x0228, tab = "Dungeons/Berugas Lab/1F" },
    { from = 0x0229, to = 0x022D, tab = "Dungeons/Berugas Lab/B1F" },
    { from = 0x022E, to = 0x0230, tab = "Dungeons/Berugas Lab/B2F" },
    { from = 0x0231, to = 0x0231, tab = "Dungeons/Berugas Lab/B99F" },

    -- Great Lakes Cavern
    { from = 0x023A, to = 0x023C, tab = "Dungeons/Great Lakes/Cave 1" },
    { from = 0x023D, to = 0x0241, tab = "Dungeons/Great Lakes/Cave 2" },
    { from = 0x0242, to = 0x0246, tab = "Dungeons/Great Lakes/Cave 3" },
    { from = 0x0247, to = 0x024C, tab = "Dungeons/Great Lakes/Cave 4" },

    -- Neotokio Sewers (erstmal alles auf Sewers 1; später verfeinern)
    { from = 0x024E, to = 0x0253, tab = "Dungeons/Neotokio Sewers/Sewers 1" },
    { from = 0x0254, to = 0x0254, tab = "Dungeons/Neotokio Sewers/Sewers 2" },
    { from = 0x0255, to = 0x0255, tab = "Dungeons/Neotokio Sewers/Sewers 3" },
    { from = 0x0256, to = 0x0256, tab = "Dungeons/Neotokio Sewers/Sewers 4" },

    -- Sylvain Castle (Bloody Mary)
    { from = 0x01D5, to = 0x01D6, tab = "Dungeons/Sylvain Castle/Courtyard" },
    { from = 0x01D7, to = 0x01D7, tab = "Dungeons/Sylvain Castle/Outside" },
    { from = 0x01D8, to = 0x01DB, tab = "Dungeons/Sylvain Castle/Entrance" },
    { from = 0x01DC, to = 0x01E1, tab = "Dungeons/Sylvain Castle/Back Room 1" },
    { from = 0x01E2, to = 0x01EA, tab = "Dungeons/Sylvain Castle/1st Floor" },
    { from = 0x01EB, to = 0x01EB, tab = "Dungeons/Sylvain Castle/Basement" },
    { from = 0x01EF, to = 0x01F2, tab = "Dungeons/Sylvain Castle/Basement" },
    { from = 0x01ED, to = 0x01ED, tab = "Dungeons/Sylvain Castle/Back Room 2" },
    { from = 0x0276, to = 0x0277, tab = "Dungeons/Sylvain Castle" },

    -- Dragoon Castle (Castle 1st/2nd floor cluster)
    { from = 0x041E, to = 0x0421, tab = "Dungeons/Dragoon Castle/1st Floor Room 1" },
    { from = 0x0422, to = 0x0424, tab = "Dungeons/Dragoon Castle/1st Floor Room 2" },
    { from = 0x0425, to = 0x0425, tab = "Dungeons/Dragoon Castle/1st Floor Room 3" },
    { from = 0x0426, to = 0x0434, tab = "Dungeons/Dragoon Castle/Left Side" },
}
