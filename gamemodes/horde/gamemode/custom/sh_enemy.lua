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

local waves_type =  GetConVar("horde_waves_type"):GetInt()
if waves_type != 1 then
    if waves_type == 2 then
        HORDE.kill_reward_base = math.floor(HORDE.kill_reward_base * 1.15)
        HORDE.total_enemies_per_wave = {24, 28, 30, 33, 38, 41, 45}

        HORDE.max_waves = 7
        HORDE.max_max_waves = HORDE.max_waves

        HORDE.waves_for_perk = {
            1,3,4,5
        }
    elseif waves_type == 3 then
        HORDE.kill_reward_base = math.floor(HORDE.kill_reward_base * 1.6)
        HORDE.total_enemies_per_wave = {36, 38, 40, 45}
        HORDE.start_money = math.floor(HORDE.start_money * 1.25)
        HORDE.round_bonus_base = math.floor(HORDE.round_bonus_base * 1.1)

        HORDE.max_waves = 4
        HORDE.max_max_waves = HORDE.max_waves

        HORDE.waves_for_perk = {
            1,2,3,3
        }
    end
end

function HORDE:GetDefaultEnemiesData()
    if waves_type == 1 then
        old_enemies()
    elseif waves_type == 2 then
        HORDE:GetDefaultEnemiesData_7Waves()
    elseif waves_type == 3 then
        HORDE:GetDefaultEnemiesData_4Waves()
    end
    for name, id in pairs(names) do
        for i = 1, HORDE.max_max_waves do
            local enemy = HORDE.enemies[name .. i]
            
            if enemy then
                enemy.class = standart_to_ext[id]
            end
        end
    end
end