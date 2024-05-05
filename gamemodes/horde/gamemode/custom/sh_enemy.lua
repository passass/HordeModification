function KFNPCIsZombie(NPC)
	if(IsValid(NPC) and NPC:IsNPC() and
    (NPC:Classify() == CLASS_ZOMBIE or NPC:Classify()==CLASS_HEADCRAB or
	NPC.SNPCClass == "C_ZOMBIE" or NPC.SNPCClass=="C_MONSTER_CAT" or
	NPC.SNPCClass == "C_MONSTER_SAVAGE" or NPC.SNPCClass=="C_MONSTER_LAB" or NPC.SNPCClass=="C_MONSTER_CONTROLLER" or 
    NPC.VJ_NPC_Class and (istable(NPC.VJ_NPC_Class) and table.HasValue(NPC.VJ_NPC_Class, "CLASS_ZOMBIE") or NPC.VJ_NPC_Class == "CLASS_ZOMBIE"))) then
		return true
	end
		
	return false
end

local old_enemies = HORDE.GetDefaultEnemiesData

local names = {
    ["Subject: Wallace Breen"] = "npc_vj_horde_breen",
    ["Gamma Gonome"] = "npc_vj_horde_gamma_gonome",
    ["Lesion"] = "npc_vj_horde_lesion",
    ["Screecher"] = "npc_vj_horde_screecher",
    ["Vomitter"] = "npc_vj_horde_vomitter",
    ["Xen Destroyer Unit"] = "npc_vj_horde_xen_destroyer_unit",
    ["Xen Host Unit"] = "npc_vj_horde_xen_host_unit",
    ["Xen Psychic Unit"] = "npc_vj_horde_xen_psychic_unit",
}

local standart_to_ext = {
    ["npc_vj_horde_breen"] = "npc_vj_hordeext_breen",
    ["npc_vj_horde_gamma_gonome"] = "npc_vj_hordeext_gamma_gonome",
    ["npc_vj_horde_lesion"] = "npc_vj_hordeext_lesion",
    ["npc_vj_horde_screecher"] = "npc_vj_hordeext_screecher",
    ["npc_vj_horde_vomitter"] = "npc_vj_hordeext_vomitter",
    ["npc_vj_horde_xen_destroyer_unit"] = "npc_vj_hordeext_xen_destroyer_unit",
    ["npc_vj_horde_xen_host_unit"] = "npc_vj_hordeext_xen_host_unit",
    ["npc_vj_horde_xen_psychic_unit"] = "npc_vj_hordeext_xen_psychic_unit",
}

local delete_npcs = {
    "Headcrab Zombie Torso",
    "Zombie Torso",
    "npc_vj_horde_sprinter"
}

local news_npcs = {
    {
        name = "Husk",
        class = "npc_hordeext_husk",
        weight = 0.15,
        wave = {
            [10] = {3, 10},
            [7] = {3, 7},
            [4] = {2, 4},
        },
        elite = true,
        health_scale = 1,
        damage_scale = 1,
        reward_scale = 1.25,
        model_scale = 1,
    },
    {
        name = "Brute",
        class = "npc_hordeext_brute",
        weight = 0.05,
        wave = {
            [10] = {6, 9},
            [7] = {5, 6},
            [4] = {3, 3},
        },
        elite = true,
        health_scale = 1,
        damage_scale = 1,
        reward_scale = 2,
        model_scale = 1,
    },
    {
        name = "Crawler",
        class = "npc_hordeext_crawler",
        weight = 0.45,
        wave = {
            [10] = {1, 10},
            [7] = {1, 7},
            [4] = {1, 4},
        },
        elite = false,
        health_scale = 1,
        damage_scale = 1,
        reward_scale = 1,
        model_scale = 1,
    },
    {
        name = "Siren",
        class = "npc_hordeext_siren",
        weight = 0.25,
        wave = {
            [10] = {3, 10},
            [7] = {2, 7},
            [4] = {2, 4},
        },
        elite = false,
        health_scale = 1,
        damage_scale = 1,
        reward_scale = 1.25,
        model_scale = 1,
    },
    {
        name = "Stalker",
        class = "npc_hordeext_stalker",
        weight = 0.5,
        wave = {
            [10] = {2, 10},
            [7] = {1, 7},
            [4] = {1, 4},
        },
        elite = false,
        health_scale = 1,
        damage_scale = 1,
        reward_scale = 1,
        model_scale = 1,
    },
    {
        name = "Gorefast",
        class = "npc_hordeext_gorefast",
        weight = 0.6,
        wave = {
            [10] = {1, 10},
            [7] = {1, 7},
            [4] = {1, 4},
        },
        elite = false,
        health_scale = 1,
        damage_scale = 1,
        reward_scale = 1,
        model_scale = 1,
    },
    {
        name = "Bloat",
        class = "npc_hordeext_bloat",
        weight = {
            [10] = {
                {w=.25, from=1, to=1},
                {w=.2, from=2, to=10},
            },
            [7] = {
                {w=.25, from=1, to=1},
                {w=.2, from=2, to=7},
            },
            [4] = {
                {w=.2, from=1, to=4},
            },
        },
        wave = {
            [10] = {1, 9},
            [7] = {1, 6},
            [4] = {1, 3},
        },
        elite = true,
        health_scale = 1,
        damage_scale = 1,
        reward_scale = 1.25,
        model_scale = 1,
    },
    {
        name = "Scrake",
        class = "npc_hordeext_scrake",
        weight = .05,
        wave = {
            [10] = {6, 9},
            [7] = {5, 6},
            [4] = {3, 3},
        },
        elite = true,
        health_scale = 1,
        damage_scale = 1,
        reward_scale = 2,
        model_scale = 1,
    },
}



function HORDE:GetDefaultEnemiesData_7Waves()

    -- name, class, weight, wave, elite, health_scale, damage_scale, reward_scale, model_scale, color
    HORDE:CreateEnemy("Walker", "npc_vj_horde_walker",                      1.00,  1, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Sprinter", "npc_vj_horde_sprinter",                  0.85,  1, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Headcrab Zombie Torso", "npc_zombie_torso",          0.30,  1, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Zombie Torso", "npc_vj_zss_czombietors",             0.30,  1, false, 0.5, 1, 1, 1)
    HORDE:CreateEnemy("Exploder", "npc_vj_horde_exploder",                  0.25,  1, true, 1, 1, 1.25, 1)

    HORDE:CreateEnemy("Walker", "npc_vj_horde_walker",                      1.00,  2, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Sprinter", "npc_vj_horde_sprinter",                  0.80,  2, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Crawler",    "npc_vj_horde_crawler",                 0.40,  2, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Fast Zombie",      "npc_fastzombie",                 0.20,  2, false, 0.75, 1, 1, 1)
    HORDE:CreateEnemy("Poison Zombie",  "npc_poisonzombie",                 0.20,  2, false, 1, 1, 1.1, 1)
    HORDE:CreateEnemy("Exploder", "npc_vj_horde_exploder",                  0.20,  2, true, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Vomitter", "npc_vj_horde_vomitter",                  0.15,  2, true, 1, 1, 1.25, 1, nil,nil,nil,nil,nil,nil,nil,1)

    HORDE:CreateEnemy("Walker", "npc_vj_horde_walker",                      1.00,  3, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Sprinter", "npc_vj_horde_sprinter",                  0.80,  3, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Crawler",    "npc_vj_horde_crawler",                 0.40,  3, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Fast Zombie",      "npc_fastzombie",                 0.20,  3, false, 0.75, 1, 1, 1)
    HORDE:CreateEnemy("Poison Zombie",  "npc_poisonzombie",                 0.20,  3, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Exploder", "npc_vj_horde_exploder",                  0.20,  3, true, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Vomitter", "npc_vj_horde_vomitter",                  0.15,  3, true, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Vomitter", "npc_hordeext_husk",                  0.15,  3, true, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Screecher","npc_vj_horde_screecher",                 0.15,  3, true, 1, 1, 1.25, 1, nil,nil,nil,nil,nil,nil,nil,1)
    

    HORDE:CreateEnemy("Walker", "npc_vj_horde_walker",                      1.00,  4, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Sprinter", "npc_vj_horde_sprinter",                  0.80,  4, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Crawler",    "npc_vj_horde_crawler",                 0.40,  4, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Fast Zombie",      "npc_fastzombie",                 0.20,  4, false, 0.75, 1, 1, 1)
    HORDE:CreateEnemy("Poison Zombie",  "npc_poisonzombie",                 0.20,  4, false, 1, 1.1, 1, 1)
    HORDE:CreateEnemy("Zombine", "npc_vj_horde_zombine",                    0.15,  4, false, 1, 1.1, 1, 1)
    HORDE:CreateEnemy("Exploder", "npc_vj_horde_exploder",                  0.20,  4, true, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Vomitter", "npc_vj_horde_vomitter",                  0.15,  4, true, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Screecher","npc_vj_horde_screecher",                 0.15,  4, true, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Mutated Hulk",  "npc_vj_mutated_hulk",       1, 4, true,  1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=false, enemies_spawn_threshold=1.0, music="music/hl2_song20_submix0.mp3", music_duration=104}, nil, nil, nil, nil, {gadget="gadget_unstable_injection", drop_rate=0.5})
    --HORDE:CreateEnemy("Subject: Grigori","npc_vj_horde_grigori",    1, 5, true,  1, 1, 10, 1, nil, nil, nil,
    --{is_boss=true, end_wave=true, unlimited_enemies_spawn=false, enemies_spawn_threshold=0.75, music="music/hl2_song19.mp3", music_duration=115}, "none")
    HORDE:CreateEnemy("Plague Berserker","npc_vj_horde_platoon_berserker",    0.35, 4, true,  1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=false, enemies_spawn_threshold=0.75, music="music/hl2_song19.mp3", music_duration=115})
    HORDE:CreateEnemy("Plague Heavy","npc_vj_horde_platoon_heavy",    0.35, 4, true,  1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=false, enemies_spawn_threshold=0.75, music="music/hl2_song3.mp3", music_duration=91})
    HORDE:CreateEnemy("Plague Demolition","npc_vj_horde_platoon_demolitionist",    0.35, 4, true,  1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=false, enemies_spawn_threshold=0.75, music="music/hl2_song19.mp3", music_duration=115})
    HORDE:CreateEnemy("Hell Knight",  "npc_vj_horde_hellknight",    1, 4, true, 1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=false, enemies_spawn_threshold=0.5, music="music/hl2_song3.mp3", music_duration=91}, "none", nil, nil, nil, {gadget="gadget_hellfire_tincture", drop_rate=0.5})
    HORDE:CreateEnemy("Xen Host Unit","npc_vj_horde_xen_host_unit", 1, 4, true, 1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=false, enemies_spawn_threshold=0.5, music="music/hl2_song20_submix0.mp3", music_duration=104}, "none", nil, nil, nil, {gadget="gadget_matriarch_womb", drop_rate=0.5})

    HORDE:CreateEnemy("Walker", "npc_vj_horde_walker",                      1.00,  5, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Sprinter", "npc_vj_horde_sprinter",                  0.80,  5, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Crawler",    "npc_vj_horde_crawler",                 0.40,  5, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Fast Zombie",      "npc_fastzombie",                 0.20,  5, false, 0.75, 1, 1, 1)
    HORDE:CreateEnemy("Poison Zombie",  "npc_poisonzombie",                 0.20,  5, false, 1, 1, 1.1, 1)
    HORDE:CreateEnemy("Zombine", "npc_vj_horde_zombine",                    0.10,  5, false, 1, 1, 1.1, 1, nil,nil,nil,nil,nil,nil,nil,1)
    HORDE:CreateEnemy("Charred Zombine", "npc_vj_horde_charred_zombine",    0.05,  5, false, 1, 1, 1.1, 1, nil,nil,nil,nil,nil,nil,nil,1)
    HORDE:CreateEnemy("Exploder", "npc_vj_horde_exploder",                  0.20,  5, true, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Vomitter", "npc_vj_horde_vomitter",                  0.10,  5, true, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Scorcher", "npc_vj_horde_scorcher",                  0.05,  5, true, 1, 1, 1.5, 1)
    HORDE:CreateEnemy("Screecher","npc_vj_horde_screecher",                 0.15,  5, true, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Hulk",   "npc_vj_horde_hulk",                        0.05,  5, true, 1, 1, 2, 1, nil,nil,nil,nil,nil,nil,nil,1)

    HORDE:CreateEnemy("Walker", "npc_vj_horde_walker",                      1.00,  6, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Sprinter", "npc_vj_horde_sprinter",                  0.80,  6, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Crawler",    "npc_vj_horde_crawler",                 0.40,  6, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Fast Zombie",      "npc_fastzombie",                 0.20,  6, false, 0.75, 1, 1, 1)
    HORDE:CreateEnemy("Poison Zombie",  "npc_poisonzombie",                 0.15,  6, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Zombine", "npc_vj_horde_zombine",                    0.08,  6, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Charred Zombine", "npc_vj_horde_charred_zombine",    0.06,  6, false, 1, 1, 1.1, 1)
    HORDE:CreateEnemy("Plague Soldier", "npc_vj_horde_plague_soldier",      0.05,  6, false, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Exploder", "npc_vj_horde_exploder",                  0.15,  6, true, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Blight", "npc_vj_horde_blight",                      0.05,  6, true, 1, 1, 1.5, 1)
    HORDE:CreateEnemy("Vomitter", "npc_vj_horde_vomitter",                  0.10,  6, true, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Scorcher", "npc_vj_horde_scorcher",                  0.05,  6, true, 1, 1, 1.5, 1)
    HORDE:CreateEnemy("Screecher","npc_vj_horde_screecher",                 0.10,  6, true, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Weeper","npc_vj_horde_weeper",                       0.05,  6, true, 1, 1, 1.5, 1)
    HORDE:CreateEnemy("Hulk",   "npc_vj_horde_hulk",                        0.03,  6, true, 1, 1, 2, 1, nil,nil,nil,nil,nil,nil,nil,1)
    HORDE:CreateEnemy("Yeti",   "npc_vj_horde_yeti",                        0.02,  6, true, 1, 1, 3, 1, nil,nil,nil,nil,nil,nil,nil,1)
    HORDE:CreateEnemy("Lesion", "npc_vj_horde_lesion",                      0.02,  6, true, 1, 1, 2, 1, nil,nil,nil,nil,nil,nil,nil,1)
    HORDE:CreateEnemy("Plague Elite", "npc_vj_horde_plague_elite",          0.015,  6, true, 1, 1, 3, 1, nil,nil,nil,nil,nil,nil,nil,1)

    HORDE:CreateEnemy("zombie vj",        "npc_vj_zss_czombie",      1,    7, false, 1, 1, 1, 1, nil)
    HORDE:CreateEnemy("zombie fast",      "npc_fastzombie",          1,    7, false, 1, 1, 1, 1, nil)
    HORDE:CreateEnemy("zombie poison",    "npc_poisonzombie",        0.5,  7, false, 1, 1, 1, 1, nil)
    HORDE:CreateEnemy("Alpha Gonome",     "npc_vj_alpha_gonome",     1,    7, true,  1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=true, enemies_spawn_threshold=0.5, music="music/hl1_song24.mp3", music_duration=77}, "fume")
    HORDE:CreateEnemy("Gamma Gonome",     "npc_vj_horde_gamma_gonome",     1,    7, true,  1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=true, enemies_spawn_threshold=0.5, music="music/hl1_song15.mp3", music_duration=120}, "none")
    HORDE:CreateEnemy("Subject: Wallace Breen",    "npc_vj_horde_breen",     1,    7, true,  1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=true, enemies_spawn_threshold=0.5, music="music/hl1_song21.mp3", music_duration=84}, "decay")
    HORDE:CreateEnemy("Xen Destroyer Unit","npc_vj_horde_xen_destroyer_unit",     1,    7, true,  1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=true, enemies_spawn_threshold=0.5, music="music/hl1_song15.mp3", music_duration=120}, "none")
    HORDE:CreateEnemy("Xen Psychic Unit","npc_vj_horde_xen_psychic_unit",     1,    7, true,  1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=true, enemies_spawn_threshold=0.5, music="music/hl1_song21.mp3", music_duration=84}, "regenerator")
    HORDE:CreateEnemy("Plague Platoon","npc_vj_horde_plague_platoon",     1,    7, true,  1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=true, enemies_spawn_threshold=0.5, music="music/hl1_song24.mp3", music_duration=84}, "none")

    HORDE:NormalizeEnemiesWeight()

    print("[HORDE] - Loaded default enemy config.")
end

function HORDE:GetDefaultEnemiesData_4Waves()

    -- name, class, weight, wave, elite, health_scale, damage_scale, reward_scale, model_scale, color
    HORDE:CreateEnemy("Walker", "npc_vj_horde_walker",                      1.00,  1, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Sprinter", "npc_vj_horde_sprinter",                  0.85,  1, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Headcrab Zombie Torso", "npc_zombie_torso",          0.30,  1, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Zombie Torso", "npc_vj_zss_czombietors",             0.30,  1, false, 0.5, 1, 1, 1)
    HORDE:CreateEnemy("Exploder", "npc_vj_horde_exploder",                  0.25,  1, true, 1, 1, 1.25, 1)

    HORDE:CreateEnemy("Walker", "npc_vj_horde_walker",                      1.00,  2, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Sprinter", "npc_vj_horde_sprinter",                  0.80,  2, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Crawler",    "npc_vj_horde_crawler",                 0.40,  2, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Fast Zombie",      "npc_fastzombie",                 0.20,  2, false, 0.75, 1, 1, 1)
    HORDE:CreateEnemy("Poison Zombie",  "npc_poisonzombie",                 0.20,  2, false, 1, 1.1, 1, 1)
    HORDE:CreateEnemy("Zombine", "npc_vj_horde_zombine",                    0.15,  2, false, 1, 1.1, 1, 1)
    HORDE:CreateEnemy("Exploder", "npc_vj_horde_exploder",                  0.20,  2, true, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Vomitter", "npc_vj_horde_vomitter",                  0.15,  2, true, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Screecher","npc_vj_horde_screecher",                 0.15,  2, true, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Mutated Hulk",  "npc_vj_mutated_hulk",       1, 2, true,  1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=false, enemies_spawn_threshold=1.0, music="music/hl2_song20_submix0.mp3", music_duration=104}, nil, nil, nil, nil, {gadget="gadget_unstable_injection", drop_rate=0.5})
    --HORDE:CreateEnemy("Subject: Grigori","npc_vj_horde_grigori",    1, 5, true,  1, 1, 10, 1, nil, nil, nil,
    --{is_boss=true, end_wave=true, unlimited_enemies_spawn=false, enemies_spawn_threshold=0.75, music="music/hl2_song19.mp3", music_duration=115}, "none")
    HORDE:CreateEnemy("Plague Berserker","npc_vj_horde_platoon_berserker",    0.35, 2, true,  1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=false, enemies_spawn_threshold=0.75, music="music/hl2_song19.mp3", music_duration=115})
    HORDE:CreateEnemy("Plague Heavy","npc_vj_horde_platoon_heavy",    0.35, 2, true,  1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=false, enemies_spawn_threshold=0.75, music="music/hl2_song3.mp3", music_duration=91})
    HORDE:CreateEnemy("Plague Demolition","npc_vj_horde_platoon_demolitionist",    0.35, 2, true,  1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=false, enemies_spawn_threshold=0.75, music="music/hl2_song19.mp3", music_duration=115})
    HORDE:CreateEnemy("Hell Knight",  "npc_vj_horde_hellknight",    1, 2, true, 1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=false, enemies_spawn_threshold=0.5, music="music/hl2_song3.mp3", music_duration=91}, "none", nil, nil, nil, {gadget="gadget_hellfire_tincture", drop_rate=0.5})
    HORDE:CreateEnemy("Xen Host Unit","npc_vj_horde_xen_host_unit", 1, 2, true, 1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=false, enemies_spawn_threshold=0.5, music="music/hl2_song20_submix0.mp3", music_duration=104}, "none", nil, nil, nil, {gadget="gadget_matriarch_womb", drop_rate=0.5})

    HORDE:CreateEnemy("Walker", "npc_vj_horde_walker",                      1.00,  3, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Sprinter", "npc_vj_horde_sprinter",                  0.80,  3, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Crawler",    "npc_vj_horde_crawler",                 0.40,  3, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Fast Zombie",      "npc_fastzombie",                 0.20,  3, false, 0.75, 1, 1, 1)
    HORDE:CreateEnemy("Poison Zombie",  "npc_poisonzombie",                 0.15,  3, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Zombine", "npc_vj_horde_zombine",                    0.08,  3, false, 1, 1, 1, 1)
    HORDE:CreateEnemy("Charred Zombine", "npc_vj_horde_charred_zombine",    0.06,  3, false, 1, 1, 1.1, 1)
    HORDE:CreateEnemy("Plague Soldier", "npc_vj_horde_plague_soldier",      0.05,  3, false, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Exploder", "npc_vj_horde_exploder",                  0.15,  3, true, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Blight", "npc_vj_horde_blight",                      0.05,  3, true, 1, 1, 1.5, 1)
    HORDE:CreateEnemy("Vomitter", "npc_vj_horde_vomitter",                  0.10,  3, true, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Scorcher", "npc_vj_horde_scorcher",                  0.05,  3, true, 1, 1, 1.5, 1)
    HORDE:CreateEnemy("Screecher","npc_vj_horde_screecher",                 0.10,  3, true, 1, 1, 1.25, 1)
    HORDE:CreateEnemy("Weeper","npc_vj_horde_weeper",                       0.05,  3, true, 1, 1, 1.5, 1)
    HORDE:CreateEnemy("Hulk",   "npc_vj_horde_hulk",                        0.03,  3, true, 1, 1, 2, 1, nil,nil,nil,nil,nil,nil,nil,1)
    HORDE:CreateEnemy("Yeti",   "npc_vj_horde_yeti",                        0.02,  3, true, 1, 1, 3, 1, nil,nil,nil,nil,nil,nil,nil,1)
    HORDE:CreateEnemy("Lesion", "npc_vj_horde_lesion",                      0.02,  3, true, 1, 1, 2, 1, nil,nil,nil,nil,nil,nil,nil,1)
    HORDE:CreateEnemy("Plague Elite", "npc_vj_horde_plague_elite",          0.015,  3, true, 1, 1, 3, 1, nil,nil,nil,nil,nil,nil,nil,1)

    HORDE:CreateEnemy("zombie vj",        "npc_vj_zss_czombie",      1,    4, false, 1, 1, 1, 1, nil)
    HORDE:CreateEnemy("zombie fast",      "npc_fastzombie",          1,    4, false, 1, 1, 1, 1, nil)
    HORDE:CreateEnemy("zombie poison",    "npc_poisonzombie",        0.5,  4, false, 1, 1, 1, 1, nil)
    HORDE:CreateEnemy("Alpha Gonome",     "npc_vj_alpha_gonome",     1,    4, true,  1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=true, enemies_spawn_threshold=0.5, music="music/hl1_song24.mp3", music_duration=77}, "fume")
    HORDE:CreateEnemy("Gamma Gonome",     "npc_vj_horde_gamma_gonome",     1,    4, true,  1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=true, enemies_spawn_threshold=0.5, music="music/hl1_song15.mp3", music_duration=120}, "none")
    HORDE:CreateEnemy("Subject: Wallace Breen",    "npc_vj_horde_breen",     1,    4, true,  1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=true, enemies_spawn_threshold=0.5, music="music/hl1_song21.mp3", music_duration=84}, "decay")
    HORDE:CreateEnemy("Xen Destroyer Unit","npc_vj_horde_xen_destroyer_unit",     1,    4, true,  1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=true, enemies_spawn_threshold=0.5, music="music/hl1_song15.mp3", music_duration=120}, "none")
    HORDE:CreateEnemy("Xen Psychic Unit","npc_vj_horde_xen_psychic_unit",     1,    4, true,  1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=true, enemies_spawn_threshold=0.5, music="music/hl1_song21.mp3", music_duration=84}, "regenerator")
    HORDE:CreateEnemy("Plague Platoon","npc_vj_horde_plague_platoon",     1,    4, true,  1, 1, 10, 1, nil, nil, nil,
    {is_boss=true, end_wave=true, unlimited_enemies_spawn=true, enemies_spawn_threshold=0.5, music="music/hl1_song24.mp3", music_duration=84}, "none")
    
    HORDE:NormalizeEnemiesWeight()

    print("[HORDE] - Loaded default enemy config.")
end

local waves_type = GetConVar("horde_waves_type"):GetInt()

local GetDefaultEnemiesData_funcs = {
    old_enemies,
    HORDE.GetDefaultEnemiesData_7Waves,
    HORDE.GetDefaultEnemiesData_4Waves
}

local GetDefaultEnemiesData_func = GetDefaultEnemiesData_funcs[waves_type]

function HORDE:GetDefaultEnemiesData()
    --[[if waves_type == 1 then
        old_enemies()
    elseif waves_type == 2 then
        HORDE:GetDefaultEnemiesData_7Waves()
    elseif waves_type == 3 then
        HORDE:GetDefaultEnemiesData_4Waves()
    end]]
    GetDefaultEnemiesData_func(HORDE)
    for name, id in pairs(names) do
        for i = 1, HORDE.max_max_waves do
            local enemy = HORDE.enemies[name .. i]
            
            if enemy then
                enemy.class = standart_to_ext[id]
            end
        end
    end

    local round_counts = 10 - 3 * (waves_type - 1)
    for round = 1, round_counts do
        for _, npcdata in pairs(news_npcs) do
            if istable(npcdata.wave) then
                local is_round_condition = false
                for i = 1, (#npcdata.wave[round_counts] / 2) do
                    local rel = (i - 1) * 2
                    is_round_condition = npcdata.wave[round_counts][1 + rel] <= round and round <= npcdata.wave[round_counts][2 + rel]
                    if is_round_condition then
                        break
                    end
                end

                if !is_round_condition then
                    continue
                end
            elseif !(!istable(npcdata.wave) and round >= npcdata.wave) then
                continue
            end

            local weight = npcdata.weight

            if istable(weight) then
                for _, w_rounds in pairs(weight[round_counts]) do
                    if w_rounds.from <= round and round <= w_rounds.to then
                        weight = w_rounds.w
                        break
                    end
                end
            end
            
            HORDE:CreateEnemy(
                npcdata.name,
                npcdata.class,
                weight,
                round,
                npcdata.elite,
                npcdata.health_scale,
                npcdata.damage_scale,
                npcdata.reward_scale,
                npcdata.model_scale
            )
        end

        for _, enemy in pairs(delete_npcs) do
            HORDE.enemies[enemy .. tostring(round)] = nil
        end
    end

    HORDE:NormalizeEnemiesWeight()
end

if SERVER and GetConVarNumber("horde_default_enemy_config") == 0 then
    if not file.IsDir("horde", "DATA") then
        file.CreateDir("horde")
    else
        local enemies_file = file.Read("horde/enemies.txt", "DATA")
        if enemies_file then
            local t = util.JSONToTable(enemies_file)
            -- Integrity
            for _, enemy in pairs(t) do
                if enemy.name == nil or enemy.name == "" or enemy.class == nil or enemy.class == "" or enemy.weight == nil or enemy.wave == nil then
                    HORDE:SendNotification("Enemy config file validation failed! Please update your file or delete it.", 0)
                    return
                else
                    if not enemy.weapon then
                        enemy.weapon = ""
                    end
                end
            end

            -- Be careful of backwards compataiblity
            CONFIG.enemies = t
            HORDE.enemies = CONFIG.enemies
            HORDE:NormalizeEnemiesWeight()

            print("[HORDE] - Loaded custom enemy config.")
        end
    end
end