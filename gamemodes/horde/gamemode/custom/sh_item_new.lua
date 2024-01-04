if !HORDE.items then HORDE.items = {} end

local function calcTotalLevels(item)
    local levels = item.levels
    if levels.VariousConditions then
        local total_levels = {}
        for class_name, class_levels in pairs(levels) do
            if class_name != "VariousConditions" then
                for _, level in pairs(class_levels) do
                    if !total_levels[class_name] then total_levels[class_name] = 0 end
                    total_levels[class_name] = total_levels[class_name] + level
                end
            end
        end
        item.total_levels = total_levels
    else
        local total_levels = 0
        for _, level in pairs(levels) do
            total_levels = total_levels + level
        end
        item.total_levels = total_levels
    end
end

local function changeLevelRequirement(itemname, level)
    local item = HORDE.items[itemname]
    item.levels = level
    calcTotalLevels(item)
end

local function copyLevelRequirement(from, to)
    local from_item = HORDE.items[from]
    local to_item = HORDE.items[to]
    to_item.levels = from_item.levels
    to_item.total_levels = from_item.total_levels
end

function HORDE:CreateItem(category, name, class, price, weight, description, whitelist, ammo_price, secondary_ammo_price, entity_properties, shop_icon, levels, skull_tokens, dmgtype, infusions, starter_classes, hidden)
    if category == nil or name == nil or class == nil or price == nil or weight == nil or description == nil then return end
    if name == "" or class == "" then return end
    if not table.HasValue(HORDE.categories, category) then return end
    if string.len(name) <= 0 or string.len(class) <= 0 then return end
    if price < 0 or weight < 0 then return end
    local item = {}
    item.category = category
    item.name = name
    item.class = class
    item.price = price
    item.skull_tokens = skull_tokens or 0
    item.weight = weight
	item.starter_classes = starter_classes or nil
    item.hidden = hidden or nil
    item.description = description
    item.whitelist = whitelist
    item.ammo_price = ammo_price
    item.secondary_ammo_price = secondary_ammo_price
    if entity_properties then
        item.entity_properties = entity_properties
    else
        item.entity_properties = {type=HORDE.ENTITY_PROPERTY_WPN}
    end
    if item.class == "_horde_armor_100" then
        item.entity_properties = {type=HORDE.ENTITY_PROPERTY_ARMOR, armor=100}
    end
    if shop_icon and shop_icon ~= "" then
        item.shop_icon = shop_icon
    end
    item.total_levels = 0
    if levels then
        item.levels = levels
        if levels.VariousConditions then
            local total_levels = {}
            for class_name, class_levels in pairs(levels) do
                if class_name != "VariousConditions" then
                    for _, level in pairs(class_levels) do
                        if !total_levels[class_name] then total_levels[class_name] = 0 end
                        total_levels[class_name] = total_levels[class_name] + level
                    end
                end
            end
            item.total_levels = total_levels
        else
            local total_levels = 0
            for _, level in pairs(levels) do
                total_levels = total_levels + level
            end
            item.total_levels = total_levels
        end
    end
    item.dmgtype = dmgtype or nil
    item.infusions = infusions or nil
    HORDE.items[item.class] = item
    --HORDE:SetItemsData()
end

local function GetStarterWeapons()
    for class, item in pairs(HORDE.items) do
        if item.starter_classes then
            for _, starter_subclass in pairs(item.starter_classes) do
                if not HORDE.starter_weapons[starter_subclass] then HORDE.starter_weapons[starter_subclass] = {} end
                table.insert(HORDE.starter_weapons[starter_subclass], class)
            end

        end

        if item.entity_properties.start_grenade then

            for ply_class, _ in pairs(item.whitelist) do
                HORDE.class_grenades[ply_class] = class
            end

        end
    end
end

function HORDE:WeaponLevelGetRequiredLevelClass(ply, levels, RequiredClass)
    if levels.VariousConditions then
        return levels[ply:Horde_GetClass().name][RequiredClass]
    end
    return levels[RequiredClass]
end

function HORDE:WeaponLevelLessThanYour(ply, levels)
    if HORDE.disable_levels_restrictions == 1 or !levels then return true end
    if levels.VariousConditions then
        local levels2 = levels[ply:Horde_GetClass().name]
        if !levels2 then
            levels2 = levels["__Default__"]
            if !levels2 then
                return true
            end
        end
        if isstring(levels2) then
            levels = levels[levels2]
        else
            levels = levels2
        end
    end
    for c, level in pairs(levels) do
        if ply:Horde_GetLevel(c) < level then
            return false
        end
    end
    return true
end
-- ITEMS
    local delete_items = {
        "arccw_go_9mm",
        "arccw_go_glock",
        "arccw_go_usp",
        "arccw_go_p2000",
        "arccw_go_p250",
        "arccw_go_r8",
        "arccw_go_deagle",
        "arccw_go_cz75",
        "arccw_go_m9",
        "arccw_go_fiveseven",
        "arccw_go_mac10","arccw_go_mp9","arccw_go_mp5","arccw_go_ump","arccw_go_bizon","arccw_go_p90",
        "arccw_go_870",
        "arccw_mw2_m1911",
        "item_battery",
        "arccw_horde_medic_9mm", "arccw_horde_9mm"
    }

    local copy_from_to = {
        arccw_horde_knife = "arccw_hordeext_knife",
        weapon_horde_medkit = "weapon_hordeext_medkit",
        arccw_horde_9mm = "arccw_kf2_9mm",

        arccw_horde_crowbar = "arccw_hordeext_crowbar",

        arccw_horde_nade_stun = "arccw_hordeext_nade_stun",
        arccw_horde_nade_shrapnel = "arccw_hordeext_nade_shrapnel",
        arccw_horde_nade_sonar = "arccw_hordeext_nade_sonar",
        arccw_horde_m67 = "arccw_hordeext_m67",
        arccw_nade_medic = "arccw_hordeext_nade_medic",
        arccw_horde_nade_nanobot = "arccw_hordeext_nade_nanobot",
        arccw_horde_nade_hemo = "arccw_hordeext_nade_hemo",
        arccw_horde_nade_emp = "arccw_hordeext_nade_emp",
        arccw_horde_nade_molotov = "arccw_hordeext_nade_molotov",

        arccw_horde_357 = "arccw_hordeext_snubnose",
        arccw_horde_akimbo_deagle = "arccw_hordeext_akimbo_deagle",
        arccw_horde_akimbo_m9 = "arccw_hordeext_akimbo_m9",
        arccw_horde_akimbo_glock17 = "arccw_hordeext_akimbo_glock17",
        arccw_horde_m79 = "arccw_hordeext_m79",
        --arccw_horde_medic_9mm = "arccw_hordeext_medic_9mm",
        arccw_horde_medic_acr = "arccw_hordeext_medic_acr",
        arccw_horde_mp5 = "arccw_hordeext_mp5",
        arccw_horde_mp5k = "arccw_hordeext_mp5k",
        arccw_horde_mp7m = "arccw_hordeext_mp7m",
        arccw_horde_mp9m = "arccw_hordeext_mp9m",
        arccw_horde_mp40 = "arccw_hordeext_mp40",
        
        arccw_horde_shotgun = "arccw_horde_toz34",
        arccw_horde_smg1 = "arccw_kf2_ar15",
        arccw_horde_tmp = "arccw_hordeext_tmp",
        arccw_horde_trenchgun = "arccw_hordeext_trenchgun",
        arccw_horde_vector = "arccw_hordeext_vector",
        
        horde_welder = "hordeext_welder",
        arccw_horde_flaregun = "arccw_hordeext_flaregun",
        arccw_horde_inferno_blade = "arccw_hordeext_inferno_blade",

        horde_m2 = "arccw_hordeext_m2",
        horde_gluon = "arccw_hordeext_gluon",
        horde_tau = "arccw_hordeext_tau",

        horde_spore_launcher = "arccw_hordeext_spore_launcher",

        arccw_horde_gau = "arccw_hordeext_gau",

        arccw_horde_law = "arccw_hordeext_law",
        arccw_horde_m16m203 = "arccw_hordeext_m16m203",
        arccw_horde_javelin = "arccw_hordeext_javelin",
        arccw_horde_rpg7 = "arccw_hordeext_rpg7",
        horde_sticky_launcher = "hordeext_sticky_launcher",
        arccw_horde_heat_crossbow = "arccw_hordeext_heat_crossbow",
    }

    HORDE.class_grenades = {}

    local grenades_classes1 = {
        weapon_frag = "weapon_frag",
        arccw_horde_nade_stun = "arccw_hordeext_nade_stun",
        arccw_horde_nade_shrapnel = "arccw_hordeext_nade_shrapnel",
        arccw_horde_nade_sonar = "arccw_hordeext_nade_sonar",
        arccw_horde_m67 = "arccw_hordeext_m67",
        arccw_nade_medic = "arccw_hordeext_nade_medic",
        arccw_horde_nade_nanobot = "arccw_hordeext_nade_nanobot",
        arccw_horde_nade_hemo = "arccw_hordeext_nade_hemo",
        arccw_horde_nade_emp = "arccw_hordeext_nade_emp",
        arccw_horde_nade_molotov = "arccw_hordeext_nade_molotov",
    }

    function HORDE:GiveClassGrenades(ply, oldclass)
        local yourclass = ply:Horde_GetClass().name
        if !yourclass then return end
        if oldclass then
            ply:StripWeapon(HORDE.class_grenades[oldclass])
        end
        if HORDE.class_grenades[yourclass] then
            ply:Give(HORDE.class_grenades[yourclass])
        end
    end

    -------------------- UPGRADES

    function HORDE:ItemCanUpgrade(ply, item, ...)
        local new_args = false

        for _, arg in pairs(... or {}) do
            if arg == true then new_args = true end
        end

        return ply:HasWeapon(item.class) and
        ((ply:Horde_GetCurrentSubclass() == "Gunslinger" and item.category == "Pistol")
        or item.entity_properties.is_upgradable or new_args)
    end

    function HORDE:ItemIsUpgraded(ply, itemname)
        local upgrade = ply:Horde_GetUpgrade(itemname)
        return upgrade and upgrade > 0
    end
    
    function HORDE:ItemIsUpgradable(ply, itemname, ...)
        local item = HORDE.items[itemname]

        if !item then return false end
        
        if HORDE:ItemCanUpgrade(ply, item, ...) then
            local upgrade = ply:Horde_GetUpgrade(itemname)
            return upgrade < (item.entity_properties.upgrade_count or 10)
        end
        return false
    end

    function HORDE:GetUpgradePrice(class, ply)
        local level
        if CLIENT then
            level = MySelf:Horde_GetUpgrade(class)
        else
            level = ply:Horde_GetUpgrade(class)
        end
        if class == "horde_void_projector" or class == "horde_solar_seal" or class == "horde_astral_relic" or class == "horde_carcass" or class == "horde_pheropod" then
            local price = 800 + 25 * level
            return price
        else
            local item = HORDE.items[class]
            local base_price = item.price
            local price = item.entity_properties.upgrade_price_incby and (item.entity_properties.upgrade_price_base or 0) + item.entity_properties.upgrade_price_incby * level or HORDE:Round2(math.max(100, base_price / 2) + math.max(10, base_price / 64) * level)
            return price
        end
    end

    -------------------- UPGRADES

    local old_itemsdata = HORDE.GetDefaultItemsData
    local new_itemsdata = function()
        
        HORDE.items["arccw_horde_shotgun"].name = "TOZ-34"
        HORDE.items["arccw_horde_357"].name = "Snub Nose"
        HORDE.items["arccw_horde_357"].starter_classes = {"Gunslinger"}
        HORDE.items["arccw_horde_357"].whitelist["Gunslinger"] = true
        HORDE.items["horde_welder"].starter_classes = nil

        table.insert(HORDE.items["arccw_horde_flaregun"].starter_classes, "Survivor")
        table.insert(HORDE.items["arccw_horde_shotgun"].starter_classes, "Survivor")

        local starter_weapons_entity_properties = {type=HORDE.ENTITY_PROPERTY_WPN, sell_forbidden=true, cantdropwep=true}

        local starter_grenades_entity_properties = table.Merge(table.Copy(starter_weapons_entity_properties), {start_grenade = true})

        for class, newclass in pairs(grenades_classes1) do
            local item = HORDE.items[class]
            if item then
                item.entity_properties = starter_grenades_entity_properties
            end
        end

        HORDE.items["arccw_horde_nade_stun"].whitelist["SWAT"] = true
        
        local pistol_properties = table.Merge(table.Copy(starter_weapons_entity_properties),
        {
            upgrade_price_base = 500,
            is_upgradable = true,
            upgrade_damage_mult_incby = .25,
            upgrade_count = 2,
            upgrade_price_incby = 750,
            upgrade_modifiers = {
                Horde_MaxMags = {base = 1, mult = 1},
                Horde_TotalMaxAmmoMult = {base = 1, mult = 1}
            },
            weapons_group = "pistol",
        })
        local melees_properties = table.Copy(pistol_properties)

        melees_properties.upgrade_modifiers = nil
        melees_properties.weapons_group = "knife"
        melees_properties.upgrade_damage_mult_incby = .5

        HORDE:CreateItem("Pistol",     "9mm [Pistol Category]",            "arccw_kf2_9mm",   100,  0, "Combine standard sidearm.",
        nil, 4, -1, pistol_properties, "items/hl2/weapon_pistol.png", nil, nil, {HORDE.DMG_BALLISTIC}, nil, {"All"})
        HORDE:CreateItem("Pistol",     "H-M500 [Pistol Category]",            "arccw_hordeext_hm500",   2000,  0, "Strong Revolver.\nDisappear after death.",
        nil, 5, -1, pistol_properties, nil, nil, nil, {HORDE.DMG_BALLISTIC})
    
        HORDE:CreateItem("Melee",      "Combat Knife [Knife Category]",   "arccw_horde_knife",    100,  0, "A reliable bayonet.\nRMB to deal a heavy slash.",
        nil, 10, -1, melees_properties, nil, nil, nil, {HORDE.DMG_SLASH}, nil, {"All"})
        HORDE:CreateItem("Melee",      "Tomahawk [Knife Category]",   "arccw_hordeext_tomahawk",    2500,  0, "Tomahawk.\nRMB to deal a heavy slash.\nDisappear after death.",
        nil, 10, -1, melees_properties, nil, nil, nil, {HORDE.DMG_SLASH})


        HORDE:CreateItem("Equipment",  "Medkit",         "weapon_horde_medkit",      1500,   1, "Rechargeble medkit.\nRMB to self-heal, LMB to heal others.",
        nil, -1, -1, {type=HORDE.ENTITY_PROPERTY_WPN}, "items/weapon_medkit.png", nil, nil, nil, nil, nil)
        HORDE:CreateItem("Equipment",  "Ammokit",         "hordeext_ammokit",      1750,   1, "Rechargeble Ammokit.\nRMB to give to self ammo, LMB give ammo to teammate.",
        {Medic=true, Survivor=true}, -1, -1, nil, "items/ammo_kit.png", {Medic=2}, nil, nil, nil, nil)
        HORDE:CreateItem("Equipment",  "Armorkit",         "hordeext_armorkit",      2000,   1, "Rechargeble Armorkit.\nRMB to recover your armor, LMB to recover armor of your teammate.",
        {Medic=true, Survivor=true}, -1, -1, nil, "items/armor_refill.png", {Medic=3}, nil, nil, nil, nil)
        HORDE:CreateItem("Equipment",  "Syringe",         "hordeext_syringe",      250,   0, "Syringe.\nRMB to heal others, LMB to self-heal.\nHeals 35 HP.",
        nil, 50, -1, {type=HORDE.ENTITY_PROPERTY_WPN}, nil, nil, nil, nil, nil, {"All"})

        HORDE:CreateItem("SMG",        "Colt M635",           "arccw_horde_smg1",   100, 3, "A compact, shoots burst.",
        {Assault=true, Heavy=true, Survivor=true, SWAT=true}, 3, -1, nil, nil, nil, nil, {HORDE.DMG_BALLISTIC}, nil, {"Assault", "Heavy", "SpecOps", "SWAT"})
        HORDE:CreateItem("Melee",      "Crowbar",        "arccw_horde_crowbar", 300,  3, "A trusty crowbar.\nEasy to use.",
        {Berserker=true, Survivor=true}, 10, -1, nil, "items/hl2/weapon_crowbar.png", nil, nil, {HORDE.DMG_BLUNT}, nil, {"Berserker"})
        HORDE:CreateItem("Pistol",     "HX-25",          "arccw_horde_hx25",   300,  2, "HX-25.\n Compact explosive pistol.",
        {Demolition=true, Survivor=true}, 2, -1, nil, nil, nil, nil, {HORDE.DMG_BLAST}, nil, {"Demolition"})
        HORDE:CreateItem("Pistol",     "HMTech-101 Pistol",          "arccw_kf2_pistol_medic",   300,  2, "HMTech-101 Pistol.\n A modern pistol with heal module.",
        {Medic=true, Survivor=true}, 4, -1, nil, nil, nil, nil, {HORDE.DMG_BALLISTIC, HORDE.DMG_POISON}, nil, {"Medic"})
        HORDE:CreateItem("Pistol",     "Trespasser",          "arccw_horde_trespasser",   300,  2, "Trespasser.\n A modern pistol with electric damage.",
        {Engineer=true, Survivor=true}, 4, -1, nil, nil, nil, nil, {HORDE.DMG_SHOCK}, nil, {"Engineer"})
        HORDE:CreateItem("Rifle",     "Kar98k",          "arccw_horde_k98k",   300,  3, "Mauser Kar98k.\n A old with bolt-action.",
        {Ghost=true, Survivor=true}, 3, -1, nil, nil, nil, nil, {HORDE.DMG_BALLISTIC}, nil, {"Ghost"})

        HORDE:CreateItem("Melee",      "Fireaxe",        "arccw_horde_axe",       1500,  5, "Fireaxe.\nHeavy, but can chops most enemies in half.",
        nil, 10, -1, nil, nil, {Berserker=2}, nil, {HORDE.DMG_SLASH})
        HORDE:CreateItem("Melee",      "Katana",         "arccw_horde_katana",  2000,  5, "Ninja sword.\nLong attack range and fast attack speed.",
        {Survivor=true, Berserker=true}, 10, -1, nil, nil, {
            VariousConditions=true,
            Berserker = {Berserker=6},
            Survivor = {Berserker=6, Survivor=15},
        }, nil, {HORDE.DMG_SLASH})
        HORDE:CreateItem("Melee",      "Bat",            "arccw_horde_bat",     2000,  5, "Sturdy baseball bat.\nHits like a truck.",
        {Survivor=true, Berserker=true}, 10, -1, nil, nil, {
            VariousConditions=true,
            Berserker = {Berserker=10},
            Survivor = {Berserker=10, Survivor=15},
        }, nil, {HORDE.DMG_BLUNT})
        HORDE:CreateItem("Melee",      "Übersaw",        "arccw_horde_ubersaw",     1750,  4, "Übersaw.\nMedic Knife.",
        {Medic=true}, 10, -1, nil, nil, {Berserker=3, Medic=4}, nil, {HORDE.DMG_SLASH})

        changeLevelRequirement("arccw_horde_chainsaw", {Berserker=10})
        copyLevelRequirement("arccw_horde_chainsaw", "arccw_horde_jotuun")
        changeLevelRequirement("arccw_horde_mjollnir", {Berserker=20})
        copyLevelRequirement("arccw_horde_mjollnir", "arccw_horde_zweihander")

        HORDE:CreateItem("Melee",      "Dual Swords",       "arccw_horde_dualsword",  6000, 8, "Dual Swords which hit very quickly or slow and strong",
        {Berserker=true}, 10, -1, nil, nil, {Berserker=30}, 1, {HORDE.DMG_SLASH})
        HORDE:CreateItem("Melee",      "StormGiant",       "arccw_horde_stormgiant",  6000, 10, "A big hammer which hit very slow but strong",
        {Berserker=true}, 10, -1, nil, nil, {Berserker=30}, 1, {HORDE.DMG_BLUNT})
        local common_pistols_reqs = {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Engineer=true, Warden=true, Cremator=true, SWAT=true}
        HORDE:CreateItem("Pistol",     "Glock",          "arccw_horde_glock",    750,  2, "Glock 18.\nSemi-automatic pistols manufactured in Austrian.",
        common_pistols_reqs, 5, -1, nil, nil, nil, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Pistol",     "USP",            "arccw_horde_usp",      450,  2, "Universelle Selbstladepistole.\nA semi-automatic pistol developed in Germany by H&K.",
        common_pistols_reqs, 5, -1, nil, nil, nil, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Pistol",     "P2000",          "arccw_horde_p2000",    750,  2, "Heckler & Koch P2000.\nA serviceable first-round pistol made by H&K.",
        common_pistols_reqs, 5, -1, nil, nil, nil, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Pistol",     "P250",           "arccw_horde_p250",     750,  2, "SIG Sauer P250.\nA low-recoil sidearm with a high rate of fire.",
        common_pistols_reqs, 5, -1, nil, nil, nil, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Pistol",     "R8",             "arccw_horde_r8",       750,  2, "R8 Revolver.\nDelivers a highly accurate and powerful round,\nbut at the expense of a lengthy trigger-pull.",
        {Survivor=true, Ghost=true}, 5, -1, nil, nil, nil, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Pistol",     "Deagle",         "arccw_horde_deagle",   750,  2, "Night Hawk .50C.\nAn iconic pistol that is diffcult to master.",
        {Survivor=true, Ghost=true}, 5, -1, nil, nil, {Ghost=1}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Pistol",     "M1911",          "arccw_horde_m1911",   450,  2, "Colt 1911.\nStandard-issue sidearm for the United States Armed Forces.",
        common_pistols_reqs, 4, -1, nil, nil, nil, nil, {HORDE.DMG_BALLISTIC})
        

        local special_pistol_classes, special_pistol_requir = {Ghost=true, SWAT=true, Survivor=true, Assault=true, Heavy=true}, {Ghost=30, Survivor=30, Assault=30, Heavy=30}
        
        HORDE:CreateItem("Pistol",     "Syringe Gun",          "arccw_horde_syringegun",   1750,  4, "Syringe Gun.\nA medic Syringe gun which have 40 ammo in clip.",
        {Medic=true}, 25, -1, nil, nil, {Medic=4}, nil, {HORDE.DMG_POISON})
        
        HORDE:CreateItem("Pistol",     "Crusader's Crossbow",          "arccw_horde_mediccrossbow",   2000,  4, "Crusader's Crossbow.\nA medic crossbow which have 1 ammo in clip.",
        {Medic=true}, 3, -1, nil, nil, {Medic=5}, nil, {HORDE.DMG_POISON})
        
        HORDE:CreateItem("Pistol",     "TAC45-Special",          "arccw_horde_tac45",   1500,  2, "TAC45-Special.\nStrong modified version of tac45.",
        special_pistol_classes, 5, -1, nil, nil, special_pistol_requir, 1, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Pistol",     "Desert Eagle Mk XIX",          "arccw_horde_deagle_xix",   2000,  4, "Desert Eagle Mk XIX.\nUpgraded version of desert eagle.",
        special_pistol_classes, 20, -1, nil, nil, special_pistol_requir, 1, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Pistol",     "HK USP Tactical",          "arccw_horde_usptac",   1500,  2, "HK USP Tactical.\nmodified HK USP Tactical with knife as melee weapon.",
        special_pistol_classes, 5, -1, nil, nil, special_pistol_requir, 1, {HORDE.DMG_BALLISTIC})
        
        HORDE:CreateItem("Pistol",     "G18",          "arccw_horde_g18",   1750,  3, "G18.\nAutomatic pistol with big mag.",
        special_pistol_classes, 10, -1, nil, nil, special_pistol_requir, 1, {HORDE.DMG_BALLISTIC})
        
        HORDE:CreateItem("Pistol",     "CZ75",           "arccw_horde_cz75",     750,  2, "CZ 75.\nA semi-automatic pistol manufactured in Czech Republic.",
        common_pistols_reqs, 5, -1, nil, nil, nil, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Pistol",     "M9",             "arccw_horde_m9",       750,  2, "Beretta M9.\nSidearm used by the United States Armed Forces.",
        {Survivor=true, Ghost=true}, 5, -1, nil, nil, nil, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Pistol",     "FiveSeven",      "arccw_horde_fiveseven",750,  3, "ES Five-seven.\nA Belgian semi-automatic pistol made by FN Herstal.",
        common_pistols_reqs, 5, -1, nil, nil, {Medic=1, Assault=1, Heavy=1, Demolition=1, Survivor=1, Engineer=1, Warden=1, Cremator=1}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Pistol",     "Tec-9",          "arccw_go_tec9",     1000,  3, "A Swedish-made semi-automatic pistol.\nLethal in close quarters.",
        {Medic=true, Assault=true, Heavy=true, Survivor=true, Engineer=true, Warden=true, SWAT=true}, 8, -1, nil, nil, {Survivor=2}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Pistol",     "Dual Glock17",   "arccw_horde_akimbo_glock17",  1750,  5, "Dual Glock 17.\nWidely used by law enforcements.",
        {Ghost=true}, 5, -1, nil, nil, {Ghost=5}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Pistol",     "Dual M9",        "arccw_horde_akimbo_m9",       1750,  5, "Dual Beretta M9.\nSidearm used by the United States Armed Forces.",
        {Ghost=true}, 5, -1, nil, nil, {Ghost=5}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Pistol",     "Dual Deagle",    "arccw_horde_akimbo_deagle",   2000,  5, "Dual Night Hawk .50C.\nAn iconic pistol that is diffcult to master.",
        {Ghost=true}, 5, -1, nil, nil, {Ghost=5}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("SMG",        "TMP",            "arccw_horde_tmp",   1000, 3, "Steyr TMP.\nA select-fire 9×19mm Parabellum caliber machine pistol.",
        {Medic=true, Assault=true, Heavy=true, Survivor=true, Cremator=true, SWAT=true}, 8, -1, nil, nil, {Survivor=2}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("SMG",        "UZI",            "arccw_horde_uzi",   1250, 3, "UZI Submachine Gun.\nDesigned by Captain (later Major) Uziel Gal of the IDF following the 1948 Arab–Israeli War.",
        {Medic=true, Assault=true, Heavy=true, Survivor=true, Cremator=true, SWAT=true}, 8, -1, nil, nil, {Survivor=3}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("SMG",        "Mac10",          "arccw_horde_mac10",    1500, 4, "Military Armament Corporation Model 10.\nBoasts a high rate of fire,\nwith poor spread accuracy and high recoil as trade-offs.",
        {Medic=true, Assault=true, Heavy=true, Survivor=true, Cremator=true, SWAT=true}, 8, -1, nil, nil, {SWAT=1}, nil, {HORDE.DMG_BALLISTIC})
        --[[HORDE:CreateItem("SMG",        "MP5K",           "arccw_mw2_mp5k",    1500, 4, "Heckler & Koch MP5K.\nA more convert and mobile version of the MP5.",
        {Medic=true, Assault=true, Heavy=true, Survivor=true, Cremator=true}, 8, -1, nil, nil, {Assault=1,Medic=1}, nil, {HORDE.DMG_BALLISTIC})]]
        HORDE:CreateItem("SMG",        "MP5",            "arccw_horde_mp5",      1750, 5, "Heckler & Koch MP5.\nOften imitated but never equaled,\nthe MP5 is perhaps the most versatile SMG in the world.",
        {Medic=true, Assault=true, Heavy=true, Survivor=true, SWAT=true}, 8, -1, nil, nil, {SWAT=3}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("SMG",        "UMP45",          "arccw_horde_ump45",      1750, 5, "KM UMP45.\nA lighter and cheaper successor to the MP5.",
        {Medic=true, Assault=true, Heavy=true, Survivor=true, SWAT=true}, 8, -1, nil, nil, {SWAT=3}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("SMG",        "PP-2000",          "arccw_horde_pp2000",      1750, 5, "PP-2000.\nA small but power gun.",
        {Medic=true, Assault=true, Heavy=true, Survivor=true, SWAT=true}, 8, -1, nil, nil, {SWAT=3}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("SMG",        "MTAR",            "arccw_horde_mtar",      2000, 6, "MTAR.\nMTAR is an Israeli bullpup assault rifle designed and produced by Israel Weapon Industries (IWI) as part of the Tavor rifle family.",
        {Medic=true, Assault=true, Survivor=true, SWAT=true}, 15, -1, nil, nil, {SWAT=5}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("SMG",        "PP Bizon",       "arccw_horde_bizon",    2000, 6, "PP-19 Bizon.\nOffers a high-capacity magazine that reloads quickly.",
        {Medic=true, Assault=true, Survivor=true, SWAT=true}, 15, -1, nil, nil, {Assault=3, SWAT=6}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("SMG",        "P90",            "arccw_horde_p90",      2000, 6, "ES C90.\nA Belgian bullpup PDW with a magazine of 50 rounds.",
        {Medic=true, Assault=true, Survivor=true, SWAT=true}, 15, -1, nil, nil, {SWAT=6}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("SMG",        "MP5K Medic PDW",  "arccw_horde_mp5k",  2000, 5, "MP5K-PDW.\nA lighter solution to MP5 equipped with a healing dart launcher.\n\nPress B or ZOOM to fire healing darts.\nHealing dart heals 10 health and has a 0.8 second cooldown.",
        {Medic=true, Survivor=true}, 8, -1, nil, nil, {
            VariousConditions=true,
            Medic = {Medic=10},
            Survivor = {Medic=10, Survivor=20},
        }, nil, {HORDE.DMG_BALLISTIC, HORDE.DMG_POISON})
        HORDE:CreateItem("SMG",        "MP9 Medic PDW",  "arccw_horde_mp9m",  2500, 6, "Brügger & Thomet MP9.\nManufactured in Switzerland,\nthe MP9 is favored by private security firms world-wide.\n\nPress B or ZOOM to fire healing darts.\nHealing dart heals 10 health and has a 1 second cooldown.",
        {Medic=true, Survivor=true}, 8, -1, nil, nil, {
            VariousConditions=true,
            Medic = {Medic=12},
            Survivor = {Medic=12, Survivor=25},
        }, nil, {HORDE.DMG_BALLISTIC, HORDE.DMG_POISON})
        HORDE:CreateItem("SMG",        "MP7A1 Medic PDW","arccw_horde_mp7m"  ,2500, 6, "A modified version of MP7A1 for medical purposes.\n\nPress B or ZOOM to fire healing darts.",
        {Medic=true, Survivor=true}, 8, -1, nil, nil, {
            VariousConditions=true,
            Medic = {Medic=13},
            Survivor = {Medic=13, Survivor=25},
        }, nil, {HORDE.DMG_BALLISTIC, HORDE.DMG_POISON})

        HORDE:CreateItem("SMG", "PM9","arccw_horde_pm9",2500, 5, "PM9.\n Fast Firerate Small SMG.",
        {SWAT=true, Survivor=true}, 5, -1, nil, nil, {SWAT=10}, nil, {HORDE.DMG_BALLISTIC})

        HORDE:CreateItem("SMG", "MP40","arccw_horde_mp40", 3000, 7, "MP40.\n SMG From World War II.",
        {SWAT=true, Survivor=true}, 10, -1, nil, nil, {
            VariousConditions=true,
            SWAT = {SWAT=15},
            Survivor = {SWAT=15, Survivor=20},
        }, nil, {HORDE.DMG_BALLISTIC})

        HORDE:CreateItem("SMG", "FMG9","arccw_horde_fmg9", 3500, 6, "FMG9.\n Fast Firerate Compact SMG.",
        {SWAT=true}, 8, -1, nil, nil, {SWAT=17}, nil, {HORDE.DMG_BALLISTIC})

        HORDE:CreateItem("SMG", "PP-19 Vityaz","arccw_horde_vityaz", 3500, 7, "PP-19 Vityaz.\n Powerful SMG.",
        {SWAT=true}, 8, -1, nil, nil, {SWAT=17}, nil, {HORDE.DMG_BALLISTIC})

        HORDE:CreateItem("SMG",        "PP-90M1 Medic", "arccw_horde_pp90m1"  ,2500, 6, "PP-90M1 Medic.\nA modified version of PP-90M1 for medical purposes.\n\nPress B or ZOOM to fire healing darts.",
        {Medic=true}, 20, -1, nil, nil, {Medic=18}, nil, {HORDE.DMG_BALLISTIC, HORDE.DMG_POISON})
        HORDE:CreateItem("SMG",        "Vector Medic PDW","arccw_horde_vector",3000, 6, "KRISS Vector Gen I equipped with a medical dart launcher.\nUses an unconventional blowback system that results in its high firerate.\n\nPress B or ZOOM to fire healing darts.\nHealing dart recharges every 1.5 seconds.",
        {Medic=true}, 8, -1, nil, nil, {Medic=15}, nil, {HORDE.DMG_BALLISTIC, HORDE.DMG_POISON})
        
        HORDE:CreateItem("SMG",        "Medic MSMC", "arccw_horde_msmc", 6000, 7, "MSMC - an Elite medic weapon with big power.",
        {Medic=true}, 10, -1, nil, nil, {Medic=30}, 1, {HORDE.DMG_BALLISTIC, HORDE.DMG_POISON})
        HORDE:CreateItem("SMG",        "MP5A2 SUP MedMod", "arccw_horde_mp5_sup_med", 6000, 7, "MP5A2 MedMod\nan rifle with sup mod and attached medic syringe system.",
        {Medic=true}, 10, -1, nil, nil, {Medic=30}, 1, {HORDE.DMG_BALLISTIC, HORDE.DMG_POISON})
        HORDE:CreateItem("SMG",        "MP5A2 SUP SupMod", "arccw_horde_mp5_sup", 6000, 6, "MP5A2 SUP\nan SMG with high firerate and medium damage.",
        {SWAT=true}, 10, -1, nil, nil, {SWAT=30}, 1, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("SMG",        "G36C", "arccw_horde_g36c", 6000, 7, "G36C\nCompact version of G36.",
        {SWAT=true}, 10, -1, nil, nil, {SWAT=30}, 1, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("SMG",        "AKS-74U", "arccw_horde_aks74u", 6000, 7, "AKS-74U - a strong weapon but without medics features.",
        {Medic=true, SWAT=true}, 15, -1, nil, nil, {
            VariousConditions=true,
            Medic = {Medic=30},
            SWAT = {SWAT=30},
        }, 1, {HORDE.DMG_BALLISTIC})
        
        HORDE:CreateItem("SMG",        "Tommi Boom",            "arccw_horde_thompson_expl", 2225, 6, "Tommi Boom.\nA M1921 with explosion module",
        {Demolition=true}, 12, -1, nil, nil, {Demolition=5}, nil, {HORDE.DMG_BLAST})

        HORDE:CreateItem("Shotgun",    "Pump-Action",    "arccw_horde_shotgun",100, 3, "A standard 12-gauge shotgun.",
        {Warden=true, Survivor=true}, 2, -1, nil, "items/hl2/weapon_shotgun.png", nil, nil, {HORDE.DMG_BALLISTIC}, nil, {"Warden"})
        HORDE:CreateItem("Shotgun",    "Sawn-Off",           "arccw_horde_db_sawnoff",     1000, 3, "Sawn-Off.\nBasic double-barrel shotgun manufactured as an entry-level hunting weapon.",
        {Assault=true, SWAT=true, Heavy=true, Survivor=true, Engineer=true, Warden=true}, 3, -1, nil, nil, {Warden=1}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Shotgun",    "Nova",           "arccw_go_nova",     1000, 4, "Benelli Nova.\nItalian pump-action 12-gauge shotgun.",
        {Assault=true, SWAT=true, Heavy=true, Survivor=true, Engineer=true, Warden=true}, 10, -1, nil, nil, {Warden=2}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Shotgun",    "M870",           "arccw_horde_870",      1500, 4, "Remington 870 Shotgun.\nManufactured in the United States.",
        {Assault=true, SWAT=true, Heavy=true, Survivor=true, Engineer=true, Warden=true}, 10, -1, nil, nil, {Engineer=3}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Shotgun",    "MAG7",           "arccw_go_mag7",     1500, 4, "Techno Arms MAG-7.\nFires a specialized 60mm 12 gauge shell.",
        {Assault=true, SWAT=true, Heavy=true, Survivor=true, Engineer=true, Warden=true}, 10, -1, nil, nil, {Warden=3}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Shotgun",    "XM1014",         "arccw_horde_m1014",    2000, 5, "Benelli M4 Super 90.\nFully automatic shotgun.",
        {Assault=true, SWAT=true, Heavy=true, Survivor=true, Engineer=true, Warden=true}, 10, -1, nil, nil, {Warden=5}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Shotgun",    "Model 1887",  "arccw_horde_m1887",    2000, 5, "Model 1887.\nModel 1887 is Lever-Action shotgun.",
        {Assault=true, SWAT=true, Heavy=true, Survivor=true, Engineer=true, Warden=true}, 10, -1, nil, nil, {Warden=5}, nil, {HORDE.DMG_BALLISTIC})

        changeLevelRequirement("arccw_horde_trenchgun", {Warden=3, Cremator=1})
        
        HORDE:CreateItem("Shotgun",    "Executioner",        "arccw_horde_exec",  2250, 6, "Executioner.\nA automatic shotgun like the judge.",
        {Survivor=true, Warden=true}, 15, -1, nil, nil, {Warden=8}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Shotgun",    "Striker",        "arccw_horde_striker", 2500, 8, "Armsel Striker.\nA 12-gauge shotgun with a revolving cylinder from South Africa.",
        {Warden=true, Survivor=true}, 15, -1, nil, nil, {
            VariousConditions=true,
            Warden = {Warden=10},
            Survivor = {Warden=10, Survivor=20},
        }, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Shotgun",    "HMTech-301 Shotgun",           "arccw_kf2_shotgun_medic",  2500, 8, "HMTech-301 Shotgun.\n A modern shotgun with heal module.",
        {Medic=true}, 15, -1, nil, nil, {Medic=5, Warden=10}, nil, {HORDE.DMG_BALLISTIC, HORDE.DMG_POISON})
        HORDE:CreateItem("Shotgun",    "AA12",           "arccw_horde_aa12",  3000, 9, "Atchisson Assault Shotgun.\nDevastating firepower at close to medium range.",
        {
            VariousConditions=true,
            Warden = {Warden=13},
            Survivor = {Warden=13, Survivor=20},
        }, 25, -1, nil, nil, {Warden=13}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Shotgun",    "UZK-BR99",           "arccw_horde_br99",  3000, 10, "UZK-BR99 Full-Auto shotgun.\nGood at destroying strength enemyes.",
        {
            VariousConditions=true,
            Warden = {Warden=14},
            Survivor = {Warden=14, Survivor=20},
        }, 25, -1, nil, nil, {Warden=14}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Shotgun",    "Saiga Spike",           "arccw_horde_spike",  3000, 8, "Saiga Spike.\nStrog weapon, but slow.",
        {Warden=true}, 20, -1, nil, nil, {Warden=15}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Shotgun",    "Typhoon F12 Custom",           "arccw_horde_typhoon12",  3500, 12, "Typhoon F12 Custom Full-Auto shotgun.\nSlow, but shoot strong bullets and have big clip.",
        {Warden=true}, 50, -1, nil, nil, {Warden=18}, nil, {HORDE.DMG_BALLISTIC})


        HORDE:CreateItem("Shotgun",    "BooMer",           "arccw_horde_bymich",  2500, 6, "BooMer.\nA longer version of Sawn-Off that shoots explosive bullets.",
        {Demolition=true}, 8, -1, nil, nil, {Demolition=10, Warden=5}, nil, {HORDE.DMG_BLAST})

        HORDE.items["arccw_horde_ar15"].whitelist["SWAT"] = true
        changeLevelRequirement("arccw_horde_ar15", {Assault=3,Ghost=1})
        
        changeLevelRequirement("arccw_horde_famas", {
            VariousConditions=true,
            Assault = {Assault=5},
            Survivor = {Survivor=8},
        })
        copyLevelRequirement("arccw_horde_famas", "arccw_horde_ace")
        changeLevelRequirement("arccw_horde_ak47", {
            VariousConditions=true,
            Assault = {Assault=8},
            Survivor = {Survivor=12},
        })

        copyLevelRequirement("arccw_horde_ak47", "arccw_horde_m4") -- from to
        copyLevelRequirement("arccw_horde_ak47", "arccw_horde_sg556")
        copyLevelRequirement("arccw_horde_ak47", "arccw_horde_aug")

        HORDE.items["arccw_horde_ak47"].whitelist["Survivor"] = true
        HORDE.items["arccw_horde_m4"].whitelist = HORDE.items["arccw_horde_ak47"].whitelist
        HORDE.items["arccw_horde_sg556"].whitelist = HORDE.items["arccw_horde_ak47"].whitelist
        HORDE.items["arccw_horde_aug"].whitelist = HORDE.items["arccw_horde_ak47"].whitelist
        changeLevelRequirement("arccw_horde_tavor", {Assault=10})
        changeLevelRequirement("arccw_horde_f2000", {
            VariousConditions=true,
            Assault = {Assault=10},
            Survivor = {Survivor=15},
        })
        changeLevelRequirement("arccw_horde_scarl", {Assault=15})

        HORDE:CreateItem("Rifle",      "M14",           "arccw_horde_m14",     2200, 7, "M14.\nA semi-automatic rifle.",
        {Survivor=true, Ghost=true}, 4, -1, nil, nil, {Ghost=3}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Rifle",      "STG-44",          "arccw_horde_stg44", 3000, 8, "STG-44.\nOld but effiency weapon.",
        {Assault=true, Survivor=true}, 10, -1, nil, nil, {
            VariousConditions=true,
            Assault = {Assault=9},
            Survivor = {Assault=9, Survivor=15},
        }, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Rifle",      "AK-117",          "arccw_horde_ak117", 3000, 6, "AK-117.\nNewest weapon of series AK.",
        {Engineer=true}, 10, -1, nil, nil, {Engineer=5, Assault=5}, nil, {HORDE.DMG_SHOCK})
        
        HORDE:CreateItem("Rifle",      "AK12",         "arccw_kf2_ak12", 3500, 8, "AK12.\nA continue of famous rifle. \n Super Power",
        {Assault=true}, 15, -1, nil, nil, {Assault=16}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Rifle",      "AS Val",         "arccw_horde_asval", 3500, 7, "AS Val.\n Strong and fast weapon, but have small clip",
        {Assault=true}, 12, -1, nil, nil, {Assault=18}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Rifle",      "Maverick",         "arccw_horde_maverick", 3500, 8, "Maverick.\n Strong weapon with high caliber",
        {Assault=true}, 12, -1, nil, nil, {Assault=20}, nil, {HORDE.DMG_BALLISTIC})
        
        HORDE:CreateItem("Rifle",      "AN94",         "arccw_horde_an94", 6000, 9, "AN94.\nAn assault rifle with big damage and extended mag.",
        {Assault=true}, 20, -1, nil, nil, {Assault=30}, 1, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Rifle",      "Galil with extended mag",         "arccw_horde_machgungalil", 6000, 9, "Galil with extended mag.\nAn assault rifle with extended mag.",
        {Assault=true}, 30, -1, nil, nil, {Assault=30}, 1, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Rifle",      "AK47 SUP Mod",         "arccw_horde_ak47supmod", 6000, 9, "AK47 SUP Mod.\nAn AK47 with SUP Mod.",
        {Assault=true}, 20, -1, nil, nil, {Assault=30}, 1, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Rifle",    "ACR Medic AR",     "arccw_horde_medic_acr",    3000, 8, "Remington Adaptive Combat Rifle.\nEquipped with healing dart and medic grenade launcher.\n\nPress USE+RELOAD to equip medic grenade launcher.\nPress B or ZOOM to fire healing dart.\nHealing dart heals 15 health and has a 1.5 second cooldown.",
        {Medic=true}, 10, 50, nil, nil, {
            VariousConditions=true,
            Medic = {Medic=25},
            Survivor = {Medic=20, Survivor=20},
        }, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Special",    "Healthrower",     "arccw_hordeext_healthrower", 3000, 7, "Healthrower.\nMedic weapon like flamethrower.",
        {Medic=true}, 10, -1, nil, nil, {
            Medic=15,
        }, nil, {HORDE.DMG_POISON})

        HORDE:CreateItem("Rifle",      "Corrupter Carbine",     "arccw_hordeext_corrupcarb",    3500, 8, "Corrupter Carbine.\nBolt-action weapon with Medic Module.",
        {Medic=true}, 5, -1, nil, nil, {
            Medic=25,
        }, nil, {HORDE.DMG_POISON})

        HORDE:CreateItem("Rifle",      "M40A3",     "arccw_horde_m40a3",    2250, 6, "M40A3.\nBolt-action weapon with big power.",
        {Ghost=true}, 3, -1, nil, nil, {Ghost=2}, nil, {HORDE.DMG_BALLISTIC})

        


        HORDE.items["arccw_horde_awp"].whitelist["Survivor"] = true
        changeLevelRequirement("arccw_horde_awp", {
            VariousConditions=true,
            Ghost = {Ghost=10},
            Survivor = {Ghost=10, Survivor=10},
        })

        changeLevelRequirement("arccw_horde_scarh", {Ghost=7, Assault=3})
        changeLevelRequirement("arccw_horde_g3", {Ghost=8, Assault=7})
        changeLevelRequirement("arccw_horde_fal", { Ghost=10 })
        changeLevelRequirement("arccw_horde_m200", { Ghost=9 })

        HORDE:CreateItem("Rifle",      "HK G28",    "arccw_horde_hkg28",  3500, 8, "HK G28 Semi-Auto Rifle.\nGood weapon for clearing area.",
        {Ghost=true}, 20, -1, nil, nil, {Ghost=15}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Rifle",      "Barrett AMR",    "arccw_horde_barret",  3500, 10, ".50 Cal Anti-Material Sniper Rifle.\nDoes huge amounts of ballistic damage.",
        {Ghost=true}, 50, -1, nil, nil, {Ghost=20}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Rifle",      "Type25",    "arccw_horde_type95",  6000, 7, "Slow but power weapon.",
        {Ghost=true}, 30, -1, nil, nil, {Ghost=30}, 1, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Rifle",      "SVU-AS",    "arccw_horde_svu",  6000, 8, "Semi-Auto sniper rifle.",
        {Ghost=true}, 20, -1, nil, nil, {Ghost=30}, 1, {HORDE.DMG_BALLISTIC})

        HORDE:CreateItem("Rifle",    "M16 M203",         "arccw_horde_m16m203",2250,7, "M16A4 equipped with an M203 underbarrel grenade launcher.\nDouble press B or ZOOM button to equip M203.",
        {Assault=true, Demolition=true, Survivor=true}, 10, 10, nil, nil, {Assault=5, Demolition=5}, nil, {HORDE.DMG_BALLISTIC, HORDE.DMG_BLAST})
        HORDE:CreateItem("Rifle",    "M16 Pyro",         "arccw_horde_m16_pyro", 2500,7, "M16A4 with Fire module and molotov launcher.",
        {Cremator=true}, 10, 80, nil, nil, {Assault=5, Cremator=5}, nil, {HORDE.DMG_BALLISTIC, HORDE.DMG_BURN})

        HORDE:CreateItem("MG",         "Stoner",           "arccw_horde_stoner",  2500, 8, "Stoner.\nA Rifle with 60 rounds in mag.",
        {Heavy=true, Survivor=true}, 20, -1, nil, nil, {Heavy=3}, nil, {HORDE.DMG_BALLISTIC})
        --HORDE:CreateItem("MG",         "RPK",           "arccw_mw2_rpk",   2750, 9, "M249 light machine gun.\nA gas operated and air-cooled weapon of destruction.",
        --{Heavy=true}, 25, -1)

        changeLevelRequirement("arccw_horde_mg4", {
            VariousConditions=true,
            Heavy = {Heavy=10},
            Survivor = {Heavy=10, Survivor=20},
        })
        HORDE.items["arccw_horde_mg4"].whitelist = {Heavy=true, Survivor=true}
        HORDE.items["arccw_horde_l86"].whitelist = HORDE.items["arccw_horde_mg4"].whitelist
        changeLevelRequirement("arccw_horde_l86", {
            VariousConditions=true,
            Heavy = {Heavy=5},
            Survivor = {Heavy=5, Survivor=20},
        })

        HORDE:CreateItem("MG",         "Stoner LMG A1",         "arccw_horde_stonera1",     3500, 10, "Stoner LMG A1 - very strong LMG.\nFires a bit slowly but a strong bullets.",
        {Heavy=true}, 50, -1, nil, nil, {Heavy=15}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("MG",         "M91",         "arccw_horde_m91",     4500, 10, "M91 - very strong LMG.\nFires a bit slowly but a strong bullets.",
        {Heavy=true}, 50, -1, nil, nil, {Heavy=20}, nil, {HORDE.DMG_BALLISTIC})

        HORDE:CreateItem("MG",         "GAU-19",         "arccw_horde_gau",     6000, 15, "GAU-19 rotary heavy machine gun.\nFires .50 BMG catridge at 1,300 rounds per minute.\n\nHold RMB to rev.",
        {Heavy=true}, 50, -1, nil, nil, {Heavy=30}, nil, {HORDE.DMG_BALLISTIC})
    
        changeLevelRequirement("arccw_horde_m79", {Demolition=3})
        changeLevelRequirement("horde_sticky_launcher", {Demolition=7})

        HORDE.items["arccw_horde_m32"].whitelist["Survivor"] = true
        HORDE.items["arccw_horde_rpg7"].whitelist = HORDE.items["arccw_horde_m32"].whitelist
        changeLevelRequirement("arccw_horde_m32", {
            VariousConditions=true,
            Demolition = {Demolition=8},
            Survivor = {Demolition=8, Survivor=15},
        })
        changeLevelRequirement("arccw_horde_rpg7", {
            VariousConditions=true,
            Demolition = {Demolition=10},
            Survivor = {Demolition=10, Survivor=15},
        })

        changeLevelRequirement("arccw_horde_law", {Demolition=13})
        changeLevelRequirement("arccw_horde_javelin", {Demolition=15})
    
        HORDE:CreateItem("Explosive",  "Gjallarhorn",        "arccw_horde_gjallarhorn",   3500,  12, "Gjallarhorn the wonder weapon.\nIt fire rocket which breaks into many pieces of rockets.",
        {Demolition=true}, 25, -1, nil, nil, {Demolition=20}, nil, {HORDE.DMG_BLAST}, {HORDE.Infusion_Quality})
        
        HORDE:CreateItem("Explosive",  "Chain Grenade",        "arccw_hordeext_nade_chain",   3000,  3, "A grenade which explode 3 times.",
        {Demolition=true}, 20, -1, nil, nil, {Demolition=20}, nil, {HORDE.DMG_BLAST}, {HORDE.Infusion_Quality})
        
        HORDE:CreateItem("Explosive",  "Deathbringer",        "arccw_horde_deathbringer",   6000,  10, "Deathbringer.\nIt fire circle of energy which breaks into many circles.",
        {Demolition=true}, 10, -1, nil, nil, {Demolition=30}, 1, {HORDE.DMG_BLAST}, {HORDE.Infusion_Quality})
        
        HORDE:CreateItem("Explosive",  "Leviathan's Breath",        "arccw_horde_levbreath",   6000,  9, "Leviathan's Breath.\nBow that fire a exlopsion arrow.",
        {Demolition=true}, 8, -1, nil, nil, {Demolition=30}, 1, {HORDE.DMG_BLAST}, {HORDE.Infusion_Quality})
        
        HORDE:CreateItem("Explosive",  "Xenophage",        "arccw_horde_xenophage",   6000,  9, "Xenophage.\nShots a small rocket.",
        {Demolition=true}, 15, -1, nil, nil, {Demolition=30}, 1, {HORDE.DMG_BLAST}, {HORDE.Infusion_Quality})

        HORDE:CreateItem("Explosive",      "Crossbow",           "arccw_horde_crossbow",     2625, 7, "Crossbow.\nA Crossbow with explosive arrows.",
        {Demolition=true}, 6, -1, nil, nil, {Demolition=5}, nil, {HORDE.DMG_BALLISTIC})
        --[[HORDE:CreateItem("Explosive",  "Incendiary Grenade",   "arccw_horde_nade_incendiary",        1000,   2, "Generates a pool of fire after some delay.\nSets everything on fire within its effect.",
        {Cremator=true}, 25, -1, nil, nil, {Cremator=2}, nil, {HORDE.DMG_FIRE})]]
        --[[HORDE:CreateItem("Explosive",    "Molotov Cocktail",  "arccw_horde_nade_molotov",     1750,  4, "Molotov Cocktail.",
        {Cremator=true}, 50, -1, nil, nil, {Cremator=5}, nil, {HORDE.DMG_BURN})]]
        --[[HORDE:CreateItem("Explosive",  "Incendiary Launcher",  "arccw_horde_incendiary_launcher", 3000,  8, "Incendiary Grenade Launcher.\nShoots incendiary grenades the erupt into flames on impact.",
        {Cremator=true}, 50, -1, nil, nil, {Cremator=5}, nil, {HORDE.DMG_FIRE})]]
        HORDE:CreateItem("Special",    "Sniper Turret",  "npc_vj_horde_sniper_turret",    1500,  5, "Combine heavy sniper turret.\n\nCovers a long range and deals heavy damage, but with limited sight.\nAims for the head if possible.",
        {Engineer=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_DROP, x=50, z=15, yaw=0, limit=3}, "items/sniper_turret.png", {Engineer=4}, nil, {HORDE.DMG_BALLISTIC})
        HORDE:CreateItem("Special",    "Wunderwaffe DG-2",       "arccw_horde_wunderwaffe",       3500,  7, "Wunderwaffe DG-2.\nA wonder weapon.\nShoots electric balls that kill a zombies.",
        {Engineer=true}, 2, -1, nil, nil, nil, nil, {HORDE.DMG_SHOCK})
        HORDE:CreateItem("Special",    "Throwing Knives", "arccw_go_nade_knife",800, 2, "Ranged throwing knives.\nThrown blades are retrievable.",
        {Berserker=true, Survivor=true}, 10, -1, nil, nil, {Berserker=1}, nil, {HORDE.DMG_SLASH})
        HORDE:CreateItem("Special",    "Ballistic Knife", "arccw_horde_ballistic_knife", 2000, 3, "Ballistic Knife.\nshoots knives that can be picked up.",
        {Berserker=true}, 30, -1, nil, nil, {Berserker=2}, nil, {HORDE.DMG_SLASH})
        HORDE:CreateItem("Special",    "Watchtower MKII",  "horde_watchtower_mk2", 1000,  2, "A watchtower that provides resupply.\nGenerates 1 health vial every 30 seconds.",
        {Warden=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_DROP, x=50, z=15, yaw=0, limit=2}, "items/horde_watchtower.png")
        HORDE:CreateItem("Special",    "Watchtower MKII.V",  "horde_watchtower_bighealth",1600,  3, "A watchtower that provides resupply.\nGenerates 1 health kit every 30 seconds.",
        {Warden=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_DROP, x=50, z=15, yaw=0, limit=2}, "items/horde_watchtower.png", {Warden=2}, nil, {HORDE.DMG_LIGHTNING})
        HORDE:CreateItem("Special",    "Watchtower MKII.I",  "horde_watchtower_armor", 1250,  3, "A watchtower that provides resupply.\nGenerates 1 armor battery every 30 seconds.",
        {Warden=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_DROP, x=50, z=15, yaw=0, limit=1}, "items/horde_watchtower.png", {Warden=2})
        HORDE:CreateItem("Special",    "Watchtower MKIII", "horde_watchtower_mk3",   1500,  3, "A watchtower that deters enemies.\nShocks 1 nearby enemy every 1 second.\nDoes 100 Lightning damage.\n(Entity Class: horde_watchtower_mk3)",
        {Warden=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_DROP, x=50, z=15, yaw=0, limit=2}, "items/horde_watchtower.png", {Warden=5}, nil, {HORDE.DMG_LIGHTNING})
        HORDE:CreateItem("Special",    "Watchtower MKIII.I",  "horde_watchtower_mk3_1",1750,  3, "A watchtower that deters enemies.\nShocks 1 nearby enemy every 1 second.\nDoes 325 Lightning damage.",
        {Warden=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_DROP, x=50, z=15, yaw=0, limit=2}, "items/horde_watchtower.png", {Warden=5}, nil, {HORDE.DMG_LIGHTNING})
        HORDE:CreateItem("Special",    "Barricade Kit",  "horde_barricadekit", 1500,  3, "Barricade Kit.\nKit with barricade that block zombies movement",
        {Engineer=true, Survivor=true}, -1, -1, {type=HORDE.ENTITY_PROPERTY_WPN, wep_that_place=true, limit=1}, nil, {
            VariousConditions=true,
            Engineer = {Engineer=10},
            Survivor = {Survivor=10},
        }, nil)--, {HORDE.DMG_LIGHTNING})

        HORDE:CreateItem("Special",    "C4",  "arccw_hordeext_c4", 1500,  2, "C4.\nThrowable Bomb which explode on press detonator.",
        {Warden=true, Assault=true, Survivor=true, SWAT=true, Heavy=true, Ghost=true, Demolition=true}, 80, -1, nil, "entities/horde_c4.png", {Demolition=20}, nil, {HORDE.DMG_BLAST})
        HORDE:CreateItem("Special",    "Claymore",  "arccw_hordeext_claymore", 1250,  1, "Claymore.\nBomb that explode on approaching enemies.",
        {Warden=true, Assault=true, Survivor=true, SWAT=true, Heavy=true, Ghost=true, Demolition=true}, 60, -1, nil, "entities/horde_claymore.png", {Demolition=10}, nil, {HORDE.DMG_BLAST})

        
        HORDE.items["horde_m2"].whitelist["Survivor"] = true
        HORDE.items["horde_gluon"].whitelist = HORDE.items["horde_m2"].whitelist
        changeLevelRequirement("horde_m2", {
            VariousConditions=true,
            Demolition = {Demolition=6},
            Survivor = {Demolition=6, Survivor=12},
        })
        changeLevelRequirement("horde_gluon", {
            VariousConditions=true,
            Demolition = {Demolition=15},
            Survivor = {Demolition=15, Survivor=20},
        })
        HORDE:CreateItem("Special",    "Thrustodyne Aeronautics Model 23", "arccw_horde_jetgun",            3000,  12, "Thrustodyne Aeronautics Model 23.\nAn experimental weapon that bring enemies and kill they.",
        {Berserker=true, Survivor=true}, -1, -1, nil, nil, {
            VariousConditions=true,
            Berserker = {Berserker=10},
            Survivor = {Berserker=10, Survivor=10},
        }, nil, {HORDE.DMG_SLASH})

        HORDE:CreateItem("Special",    "RiotShield", "arccw_horde_riotshield",            2000,  7, "RiotShield.\nJust a shield.",
        {Berserker=true, Survivor=true}, -1, -1, nil, "entities/horde_riotshield.png", {
            VariousConditions=true,
            Berserker = {Berserker=20},
            Survivor = {Berserker=20, Survivor=10},
        }, nil, {HORDE.DMG_SLASH})

        HORDE:CreateItem("Special",    "Staff of Fire", "arccw_horde_firestaff",            3500,  9, "Staff of Fire.\nA magic rod that shoot a fire balls.",
        {Cremator=true}, 8, -1, nil, nil, {Cremator=15}, nil, {HORDE.DMG_BURN})
        HORDE:CreateItem("Equipment", "Refill Armor", "armorrefill", 10, 0, "Refill Armor.\nFills up max armor of your armor bar.\n10$ Every armor point.",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_ARMOR, armor=0}, "items/armor_refill.png")
        --HORDE:CreateItem("Equipment", "50 Kevlar Armor", "armor50", 500, 0, "50 kevlar armor set.\nFills up 50 of your armor bar.",
        --nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_ARMOR, armor=50}, "items/armor_50.png")
        HORDE:CreateItem("Equipment", "100 Kevlar Armor", "armor100", 1500, 0, "Full kevlar armor set.\nFills up 100 of your armor bar and allows add armor to 100 with armor battery.\nArmor Limit Resets to 50 after death.",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_ARMOR, override_maxarmor=true, armor=100}, "items/armor_100.png", {Survivor=5, Berserker=10, Assault=5, Heavy=5})
        HORDE:CreateItem("Equipment", "150 Kevlar Armor", "armor150", 2000, 0, "Full kevlar armor set.\nFills up 150 of your armor bar and allows add armor to 150 with armor battery.\nArmor Limit Resets to 50 after death.",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_ARMOR, override_maxarmor=true, armor=150}, "items/armor_150.png", {Survivor=5, Berserker=15, Assault=10, Heavy=10})
        HORDE:CreateItem("Equipment", "200 Kevlar Armor", "armor200", 2500, 0, "Full kevlar armor set.\nFills up 200 of your armor bar and allows add armor to 200 with armor battery.\nArmor Limit Resets to 50 after death.",
        {Berserker=true, Heavy=true, Survivor=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_ARMOR, override_maxarmor=true, armor=200}, "items/armor_200.png", {Survivor=5, Berserker=25, Assault=15, Heavy=20})
        
        HORDE:CreateItem("Equipment", "Advanced Kevlar Armor", "armor_survivor", 1000, 0, "Distinguished Survivor armor.\n\nFills up 100 of your armor bar and override if your limit is lower.\nProvides 5% increased damage resistance.",
        {Survivor=true, SWAT=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_ARMOR, armor=100}, "items/armor_survivor.png", {Survivor=30}, 1)
        HORDE:CreateItem("Equipment", "Assault Vest", "armor_assault", 1000, 0, "Distinguished Assault armor.\n\nFills up 100 of your armor bar and override if your limit is lower.\nProvides 8% increased Ballistic damage resistance.",
        {Assault=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_ARMOR, armor=100}, "items/armor_assault.png", {Assault=30}, 1)
        HORDE:CreateItem("Equipment", "Bulldozer Suit", "armor_heavy", 1000, 0, "Distinguished Heavy armor.\n\nFills up 125 of your armor bar and override if your limit is lower.",
        {Heavy=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_ARMOR, armor=125}, "items/armor_heavy.png", {Heavy=30}, 1)
        HORDE:CreateItem("Equipment", "Hazmat Suit", "armor_medic", 1000, 0, "Distinguished Medic armor.\n\nFills up 100 of your armor bar and override if your limit is lower.\nProvides 8% increased Poison damage resistance.",
        {Medic=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_ARMOR, armor=100}, "items/armor_medic.png", {Medic=30}, 1)
        HORDE:CreateItem("Equipment", "Bomb Suit", "armor_demolition", 1000, 0, "Distinguished Demolition armor.\n\nFills up 100 of your armor bar and override if your limit is lower.\nProvides 8% increased Blast damage resistance.",
        {Demolition=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_ARMOR, armor=100}, "items/armor_demolition.png", {Demolition=30}, 1)
        HORDE:CreateItem("Equipment", "Assassin's Cloak", "armor_ghost", 1000, 0, "Distinguished Ghost armor.\n\nFills up 100 of your armor bar and override if your limit is lower.\nProvides 5% increased evasion.",
        {Ghost=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_ARMOR, armor=100}, "items/armor_ghost.png", {Ghost=30}, 1)
        HORDE:CreateItem("Equipment", "Defense Matrix", "armor_engineer", 1000, 0, "Distinguished Engineer armor.\n\nFills up 100 of your armor bar and override if your limit is lower.\nProvides 5% increased damage resistance.",
        {Engineer=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_ARMOR, armor=100}, "items/armor_engineer.png", {Engineer=30}, 1)
        HORDE:CreateItem("Equipment", "Riot Armor", "armor_warden", 1000, 0, "Distinguished Warden armor.\n\nFills up 100 of your armor bar and override if your limit is lower.\nProvides 8% increased Shock and Sonic damage resistance.",
        {Warden=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_ARMOR, armor=100}, "items/armor_warden.png", {Warden=30}, 1)
        HORDE:CreateItem("Equipment", "Molten Armor", "armor_cremator", 1000, 0, "Distinguished Cremator armor.\n\nFills up 100 of your armor bar and override if your limit is lower.\nProvides 8% increased Fire damage resistance.",
        {Cremator=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_ARMOR, armor=100}, "items/armor_cremator.png", {Cremator=30}, 1)
        HORDE:CreateItem("Equipment", "Battle Vest", "armor_berserker", 1000, 0, "Distinguished Berserker armor.\n\nFills up 100 of your armor bar and override if your limit is lower.\nProvides 8% increased Slashing/Blunt damage resistance.",
        {Berserker=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_ARMOR, armor=100}, "items/armor_berserker.png", {Berserker=30}, 1)

        changeLevelRequirement("arccw_horde_doublebarrel", { Warden=6 })
        changeLevelRequirement("arccw_horde_spas12", { Warden=8 })
        changeLevelRequirement("arccw_horde_ssg08", { Ghost=5 })
        changeLevelRequirement("arccw_horde_negev", { Heavy=4 })
        copyLevelRequirement("arccw_horde_negev", "arccw_horde_m249")
        changeLevelRequirement("arccw_horde_mg4", { Heavy=10 })
        copyLevelRequirement("arccw_horde_mg4", "arccw_horde_rpd")
        copyLevelRequirement("arccw_horde_mg4", "arccw_horde_m240")
        changeLevelRequirement("horde_tau", { Cremator=8 })
        changeLevelRequirement("arccw_horde_heat_blaster", { Cremator=5 })
    end

    HORDE.starter_weapons = {}

    function HORDE:GetDefaultItemsData()

        local old_1 = HORDE.GetDefaultGadgets
        local old_2 = HORDE.GetDefaultItemInfusions
        local old_3 = HORDE.GetArcCWAttachments

        HORDE.GetDefaultGadgets = function() end
        HORDE.GetDefaultItemInfusions = function() end
        HORDE.GetArcCWAttachments = function() end

        old_itemsdata()

        HORDE.GetDefaultGadgets = old_1
        HORDE.GetDefaultItemInfusions = old_2
        HORDE.GetArcCWAttachments = old_3

        new_itemsdata()
        
        HORDE:GetDefaultGadgets()
        HORDE:GetDefaultItemInfusions()

        if ArcCWInstalled == true and GetConVar("horde_arccw_attinv_free"):GetInt() == 0 then
            print("[HORDE] ArcCW detected. Loading attachments into shop.")
            HORDE.GetArcCWAttachments()
        end

        for k, v in pairs(delete_items) do 
            HORDE.items[v] = nil
        end

        local atts = {}

        for class, data in pairs(HORDE.items) do
            if 
            data.category != "Attachment" or 
            !data.entity_properties or
            !data.entity_properties.arccw_attachment_wpn
            then continue end
            if !copy_from_to[data.entity_properties.arccw_attachment_wpn] then continue end

            data.entity_properties.arccw_attachment_wpn = copy_from_to[data.entity_properties.arccw_attachment_wpn]
        end

        for from, to in pairs(copy_from_to) do 
            if !HORDE.items[from] then continue end

            HORDE.items[to] = table.Copy(HORDE.items[from])
            HORDE.items[to].class = to
            HORDE.items[from] = nil
        end

        print("[HORDE] - Loaded default item config.")
    end

-- ATTACHTS
    HORDE.GetArcCWAttachments = function ()
        local x1_sightsprice = 500
        local x4_sightsprice = 750
    
        local thermalandothers_sightsprice = 1000
        --test
        local some_sights = {
        {"arccw_1p87", "1P87 (RDS)", x1_sightsprice}, 
        {"arccw_ahos446", "AHOS 446 (RDS)", x1_sightsprice}, 
        {"arccw_compm4s", "CompM4s (RDS)", x1_sightsprice}, 
        {"arccw_compm4_magnifier", "CompM4s w/ Magnifier (x3)", x4_sightsprice}, 
        {"arccw_compm5", "CompM5 (RDS)", x1_sightsprice}, 
        {"arccw_coyote", " Coyote (RDS)", x1_sightsprice}, 
        {"arccw_ekp807", "EKP-8-07 Kobra (RDS)", x1_sightsprice}, 
        {"arccw_ekp807_magnifier", x1_sightsprice}, 
        {"arccw_hd33", "Tru-Brite (RDS)", x1_sightsprice}, 
        {"arccw_kemper", "Kemper XL (RDS)", x1_sightsprice}, 
        {"arccw_lco", "Leupold Carbine Optic (RDS)", x1_sightsprice}, 
        {"arccw_lcodevo", "LCO & D-EVO (Hybrid)", x1_sightsprice}, 
        {"arccw_leomk4cqt", "Leupold Mark 4 CQ/T", x4_sightsprice}, 
        {"arccw_mepro", "Mepro MOR (RDS)", x1_sightsprice}, 
        {"arccw_mosin", "PU Scope", x4_sightsprice}, 
        {"arccw_pilad", "Pilad 'Weaver' (RDS)", x1_sightsprice}, 
        {"arccw_pkas", "PK-AS (RDS)", x1_sightsprice}, 
        {"arccw_pks07", "PKS07", x4_sightsprice}, 
        {"arccw_ps320", "PS320", x4_sightsprice},
        {"arccw_reh", "REH's Custom (RDS)", x1_sightsprice}, 
        {"arccw_romeo4", "SIG Sauer Romeo4 (RDS)", x1_sightsprice}, 
        {"arccw_rusak", "Rusak (RDS)", x1_sightsprice}, 
        {"arccw_trimro", "Trijicon MRO (RDS)", x1_sightsprice}, 
        {"arccw_trirx01", "Trijicon RX01 (RDS)", x1_sightsprice}, 
        {"arccw_trirx34", "Trijicon RX34 (RDS)", x1_sightsprice}, 
        {"arccw_warriort1", "Warrior T1 (RDS)", x1_sightsprice}, 
        {"arccw_x1kobra", "Warriot X1 Kobra (RDS)", x1_sightsprice}, 
        {"arccw_xps", "EOTech XPS (RDS)", x1_sightsprice}, 
        {"arccw_xps_magnifier", "XPS w/ Magnifier", x4_sightsprice}
        }
    
        for k, v in pairs(some_sights) do 
            HORDE:CreateItem("Attachment", v[2], v[1], v[3],  0, "RDS",
            nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Optic"})
        end
    
        -- Optics
        
        HORDE:CreateItem("Attachment", "C-MORE (RDS)",   "go_optic_cmore",  x1_sightsprice,  0, "RDS",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Optic"})
        HORDE:CreateItem("Attachment", "EOTech 553 (RDS)",    "go_optic_eotech",  x1_sightsprice,  0, "RDS",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Optic"})
        HORDE:CreateItem("Attachment", "MRS (RDS)",    "optic_mrs_dot",  x1_sightsprice,  0, "RDS",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Optic"})
        HORDE:CreateItem("Attachment", "Kobra (RDS)",   "go_optic_kobra",  x1_sightsprice,  0, "RDS",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Optic"})
        HORDE:CreateItem("Attachment", "CompM4 (RDS)",   "go_optic_compm4",  x1_sightsprice,  0, "RDS",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Optic"})
        HORDE:CreateItem("Attachment", "MICRO T1 (RDS)",   "go_optic_t1",  x1_sightsprice,  0, "RDS",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Optic"})
        HORDE:CreateItem("Attachment", "MARS (RDS)",   "optic_mw2_mars",  x1_sightsprice,  0, "RDS",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Optic"})
        HORDE:CreateItem("Attachment", "BARSKA (RDS)",   "go_optic_barska",  x1_sightsprice,  0, "RDS",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Optic"})
        HORDE:CreateItem("Attachment", "ADCO SOLO (RDS)",   "optic_bo2_solo",  x1_sightsprice,  0, "RDS",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Optic"})
        
        
    
        
        HORDE:CreateItem("Attachment", "PVS-4 (2x)",   "go_optic_pvs4",  x4_sightsprice,  0, "RDS",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Optic"})
        HORDE:CreateItem("Attachment", "Leupold HAMR (Hybrid)",   "go_optic_hamr",  x4_sightsprice,  0, "RDS",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Optic"})
        HORDE:CreateItem("Attachment", "Hunter Compact (2.5x)",   "go_optic_hunter",  x4_sightsprice,  0, "RDS",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Optic"})
    
        HORDE:CreateItem("Attachment", "ELCAN C79 (3.5x)",   "go_optic_elcan",  x4_sightsprice,  0, "RDS",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Optic"})
        HORDE:CreateItem("Attachment", "ACOG (x4)",   "go_optic_acog",  x4_sightsprice,  0, "RDS",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Optic"})
        HORDE:CreateItem("Attachment", "CheyTac (2-4.3x)",   "optic_cheytacscope",  x4_sightsprice,  0, "RDS",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Optic"})
        
        
        HORDE:CreateItem("Attachment", "Thermal Scope",   "optic_mw2_thermal",  thermalandothers_sightsprice,  0, "RDS",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Optic"})
        
            
        HORDE:CreateItem("Attachment", "PM-II (7x)",   "go_optic_schmidt",  thermalandothers_sightsprice,  0, "RDS",
        {Ghost=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Optic"})
        
        HORDE:CreateItem("Attachment", "LPVO (8x)",   "go_optic_ssr",  thermalandothers_sightsprice,  0, "RDS",
        {Ghost=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Optic"})
        
        HORDE:CreateItem("Attachment", "Arctic Warfare (10x)",   "go_optic_awp",  thermalandothers_sightsprice,  0, "RDS",
        {Ghost=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Optic"})
        local underbarrelprice = 1000
        -- Underbarrel
        HORDE:CreateItem("Attachment", "Pistol Foregrip",   "go_nova_stock_pistol",  underbarrelprice * .4,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Underbarrel"})
        HORDE:CreateItem("Attachment", "Pistol Foregrip",   "foregrip_pistol",  underbarrelprice * .4,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Underbarrel"})
        HORDE:CreateItem("Attachment", "Ergo Foregrip",   "go_foregrip_ergo",  underbarrelprice * .6,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Underbarrel"})
        HORDE:CreateItem("Attachment", "Battle Foregrip",   "go_foregrip",  underbarrelprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Underbarrel"})
        HORDE:CreateItem("Attachment", "Stubby Foregrip",   "go_foregrip_stubby",  underbarrelprice * .75,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Underbarrel"})
        HORDE:CreateItem("Attachment", "Tactical Grip",   "go_ak_grip_tactical",  underbarrelprice * .6,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Underbarrel"})
        HORDE:CreateItem("Attachment", "Snatch Foregrip",   "go_foregrip_snatch",  underbarrelprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Underbarrel"})
        HORDE:CreateItem("Attachment", "Angled Foregrip",   "go_foregrip_angled",  underbarrelprice * .5,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Underbarrel"})
        HORDE:CreateItem("Attachment", "Bipod",             "go_fore_bipod",  underbarrelprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Underbarrel"})
    
        local tactsprice = 800
        -- Tactical
        HORDE:CreateItem("Attachment", "Flashlight",   "go_flashlight",  tactsprice * .4,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Tactical"})
        HORDE:CreateItem("Attachment", "Combo Flashlight",   "go_flashlight_combo",  tactsprice * .5,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Tactical"})
        HORDE:CreateItem("Attachment", "5mW Laser",   "go_laser_peq",  tactsprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Tactical"})
        HORDE:CreateItem("Attachment", "3mW Laser",   "go_laser_surefire",  tactsprice * 0.75,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Tactical"})
        HORDE:CreateItem("Attachment", "1mW Laser",   "go_laser",  tactsprice * 0.25,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Tactical"})
    
        local unicsatts_multprice = 5
        -- Barrel

        HORDE:CreateItem("Attachment", "[MP9] 210mm Plus Barrel",    "go_mp9_barrel_med",  75,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_mp9m"})
        HORDE:CreateItem("Attachment", "[MP9] 350mm Carbine Barrel",    "go_mp9_barrel_long",  75,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_mp9m"})
        HORDE:CreateItem("Attachment", "[MP5] 150mm Kurz Barrel",   "go_mp5_barrel_short",  75 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_mp5"})
        HORDE:CreateItem("Attachment", "[MP5] 500mm Carbine Barrel",   "go_mp5_barrel_long",  75 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_mp5"})
        HORDE:CreateItem("Attachment", "[MP5] 550mm Whisper Barrel",   "go_mp5_barrel_sd",  75 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_mp5"})
        HORDE:CreateItem("Attachment", "[MAC10] 50mm Stub Barrel",   "go_mac10_barrel_stub",  75 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_mac10"})
        HORDE:CreateItem("Attachment", "[MAC10] 200mm Patrol Barrel",   "go_mac10_barrel_med",  75 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_mac10"})
        HORDE:CreateItem("Attachment", "[MAC10] 350mm Carbine Barrel",   "go_mac10_barrel_long",  75 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_mac10"})
        HORDE:CreateItem("Attachment", "[UMP] 220mm HK Barrel",   "go_ump_barrel_med",  100 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_ump45"})
        HORDE:CreateItem("Attachment", "[UMP] 350mm USC Barrel",   "go_ump_barrel_long",  100 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_ump45"})
        HORDE:CreateItem("Attachment", "[PP-Bizon] 230mm FSB Barrel",   "go_bizon_barrel_med",  75 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_bizon"})
        HORDE:CreateItem("Attachment", "[PP-Bizon] 290mm GRU Barrel",   "go_bizon_barrel_long",  75 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_bizon"})
        HORDE:CreateItem("Attachment", "[P90] 410mm PS90 Barrel",   "go_p90_barrel_med",  75 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_p90"})
        HORDE:CreateItem("Attachment", "[P90] 800mm Devolution Barrel",   "go_p90_barrel_long",  75 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_p90"})
    
        HORDE:CreateItem("Attachment", "[M1014] 350mm M1014 Barrel",   "go_m1014_barrel_short",  75 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_m1014"})
        HORDE:CreateItem("Attachment", "[M1014] 750mm M1014 Barrel",   "go_m1014_barrel_long",  75 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_m1014"})
        HORDE:CreateItem("Attachment", "[MAG7] 280mm BodyGuard Barrel",   "go_mag7_barrel_short",  75 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_go_mag7"})
        HORDE:CreateItem("Attachment", "[MAG7] 440mm Longsword Barrel",   "go_mag7_barrel_long",  75 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_go_mag7"})
        HORDE:CreateItem("Attachment", "[Nova] 300mm BodyGuard Barrel",   "go_nova_barrel_short",  75 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_go_nova"})
        HORDE:CreateItem("Attachment", "[Nova] 710mm Longsword Barrel",   "go_nova_barrel_long",  75 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_go_nova"})
        HORDE:CreateItem("Attachment", "[M870] 350mm 870 Barrel",   "go_870_barrel_short",  75 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_870"})
        HORDE:CreateItem("Attachment", "[M870] 750mm 870 Barrel",   "go_870_barrel_long",  75 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=true, Demolition=true, Survivor=true, Ghost=false, Engineer=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_870"})
    
        HORDE:CreateItem("Attachment", "[Galil] 216mm Navy Barrel",   "go_ace_barrel_short",  100 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=false, Demolition=false, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_ace"})
        HORDE:CreateItem("Attachment", "[Galil] 409mm Carbine Barrel",   "go_ace_barrel_med",  100 * unicsatts_multprice, 0, "",
        {Medic=true, Assault=true, Heavy=false, Demolition=false, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_ace"})
        HORDE:CreateItem("Attachment", "[Galil] 510mm SAW Barrel",   "go_ace_barrel_long",  100 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=false, Demolition=false, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_ace"})
        HORDE:CreateItem("Attachment", "[Famas] 405mm Raider Barrel",   "go_famas_barrel_short",  100 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=false, Demolition=false, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_famas"})
        HORDE:CreateItem("Attachment", "[Famas] 620mm Tireur Barrel",   "go_famas_barrel_long",  100 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=false, Demolition=false, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_famas"})
        HORDE:CreateItem("Attachment", "[M4A1] 50mm Stub Barrel",   "go_m4_barrel_stub",  100 * unicsatts_multprice,  0, "",
        {Medic=false, Assault=true, Heavy=false, Demolition=false, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_m4"})
        HORDE:CreateItem("Attachment", "[M4A1] 210mm Compact Barrel",   "go_m4_barrel_short",  100 * unicsatts_multprice,  0, "",
        {Medic=false, Assault=true, Heavy=false, Demolition=false, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_m4"})
        HORDE:CreateItem("Attachment", "[M4A1] 300mm INT-SD Barrel",   "go_m4_barrel_sd",  100 * unicsatts_multprice,  0, "",
        {Medic=false, Assault=true, Heavy=false, Demolition=false, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_m4"})
        HORDE:CreateItem("Attachment", "[M4A1] 370mm Carbine Barrel",   "go_m4_barrel_med",  100 * unicsatts_multprice,  0, "",
        {Medic=false, Assault=true, Heavy=false, Demolition=false, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_m4"})
        HORDE:CreateItem("Attachment", "[AK47] 314mm Ukoro Barrel",   "go_ak_barrel_short",  100 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=false, Demolition=false, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_ak47"})
        HORDE:CreateItem("Attachment", "[AK47] 415mm Spetsnaz Barrel",   "go_ak_barrel_tac",  100 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=false, Demolition=false, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_ak47"})
        HORDE:CreateItem("Attachment", "[AK47] 590mm RPK Barrel",   "go_ak_barrel_long",  100 * unicsatts_multprice,  0, "",
        {Medic=true, Assault=true, Heavy=false, Demolition=false, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_ak47"})
        HORDE:CreateItem("Attachment", "[AUG] 420mm Para Barrel",   "go_aug_barrel_short",  100 * unicsatts_multprice,  0, "",
        {Medic=false, Assault=true, Heavy=false, Demolition=false, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_aug"})
        HORDE:CreateItem("Attachment", "[AUG] 620mm HBAR Barrel",   "go_aug_barrel_long",  100 * unicsatts_multprice,  0, "",
        {Medic=false, Assault=true, Heavy=false, Demolition=false, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_aug"})
        HORDE:CreateItem("Attachment", "[SG556] 390mm Compact Barrel",   "go_sg_barrel_short",  100 * unicsatts_multprice,  0, "",
        {Medic=false, Assault=true, Heavy=false, Demolition=false, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_sg556"})
        HORDE:CreateItem("Attachment", "[SG556] 650mm Sniper Barrel",   "go_sg_barrel_long",  100 * unicsatts_multprice,  0, "",
        {Medic=false, Assault=true, Heavy=false, Demolition=false, Survivor=true, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_horde_sg556"})
    
        HORDE:CreateItem("Attachment", "[SCAR] 250mm PDW Barrel",   "go_scar_barrel_stub",  100 * unicsatts_multprice,  0, "",
        {Medic=false, Assault=false, Heavy=false, Demolition=false, Survivor=false, Ghost=true, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_go_scar"})
        HORDE:CreateItem("Attachment", "[SCAR] 330mm CQC Barrel",   "go_scar_barrel_short",  100 * unicsatts_multprice,  0, "",
        {Medic=false, Assault=false, Heavy=false, Demolition=false, Survivor=false, Ghost=true, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_go_scar"})
        HORDE:CreateItem("Attachment", "[SCAR] 510mm SSR Barrel",   "go_scar_barrel_long",  100 * unicsatts_multprice,  0, "",
        {Medic=false, Assault=false, Heavy=false, Demolition=false, Survivor=false, Ghost=true, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_go_scar"})
        HORDE:CreateItem("Attachment", "[G3] 315mm Kurz Barrel",   "go_g3_barrel_short",  100 * unicsatts_multprice,  0, "",
        {Medic=false, Assault=false, Heavy=false, Demolition=false, Survivor=false, Ghost=true, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_go_g3"})
        HORDE:CreateItem("Attachment", "[G3] 640mm Whisper Barrel",   "go_scar_barrel_sd",  100 * unicsatts_multprice,  0, "",
        {Medic=false, Assault=false, Heavy=false, Demolition=false, Survivor=false, Ghost=true, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_go_g3"})
        HORDE:CreateItem("Attachment", "[G3] 650mm SG1 Barrel",   "go_scar_barrel_long",  100 * unicsatts_multprice,  0, "",
        {Medic=false, Assault=false, Heavy=false, Demolition=false, Survivor=false, Ghost=true, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_go_g3"})
    
        HORDE:CreateItem("Attachment", "[M249] 330mm Para Barrel",   "go_m249_barrel_short",  110 * unicsatts_multprice,  0, "",
        {Medic=false, Assault=false, Heavy=true, Demolition=false, Survivor=false, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_go_m249para"})
        HORDE:CreateItem("Attachment", "[M249] 510mm SAW Barrel",   "go_m249_barrel_long",  110 * unicsatts_multprice,  0, "",
        {Medic=false, Assault=false, Heavy=true, Demolition=false, Survivor=false, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_go_m249para"})
        HORDE:CreateItem("Attachment", "[Negev] 330mm SF Barrel",   "go_negev_barrel_short",  110 * unicsatts_multprice,  0, "",
        {Medic=false, Assault=false, Heavy=true, Demolition=false, Survivor=false, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_go_negev"})
        HORDE:CreateItem("Attachment", "[Negev] 510mm Heavy Barrel",   "go_negev_barrel_long",  110 * unicsatts_multprice,  0, "",
        {Medic=false, Assault=false, Heavy=true, Demolition=false, Survivor=false, Ghost=false, Engineer=false}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Barrel", arccw_attachment_wpn="arccw_go_negev"})
    
        -- Mag
        HORDE:CreateItem("Attachment", "[USP] 20-Round .45",   "go_usp_mag_20",  80 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_usp"})
        HORDE:CreateItem("Attachment", "[USP] 30-Round .45",   "go_usp_mag_30",  80 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_usp"})
        HORDE:CreateItem("Attachment", "[Glock] 31-Round 9mm",   "go_glock_mag_28",  80 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_glock"})
        HORDE:CreateItem("Attachment", "[P250] 21-Round .357",   "go_p250_mag_21",  80 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_p250"})
        HORDE:CreateItem("Attachment", "[M9] 24-Round 9mm",   "go_m9_mag_24",  80 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_m9"})
        HORDE:CreateItem("Attachment", "[P2000] 24-Round 9mm",   "go_p2000_mag_24",  80 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_p2000"})
        HORDE:CreateItem("Attachment", "[CZ75] 30-Round 9mm",   "go_cz75_mag_30",  80 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_cz75"})
        HORDE:CreateItem("Attachment", "[Fiveseven] 30-Round 5.7mm",   "go_fiveseven_mag_30",  80 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_fiveseven"})
        HORDE:CreateItem("Attachment", "[Tec-9] 10-Round 9mm",   "go_tec9_mag_10",  80 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_go_tec9"})
        HORDE:CreateItem("Attachment", "[Tec-9] 32-Round 9mm",   "go_tec9_mag_32",  80 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_go_tec9"})
        
        HORDE:CreateItem("Attachment", "[MP9] 15-Round 9mm",   "go_mp9_mag_15",  90,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_mp9m"})
        HORDE:CreateItem("Attachment", "[MAC10] 16-Round .45 Ingram",   "go_mac10_mag_16",  90 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_mac10"})
        HORDE:CreateItem("Attachment", "[MAC10] 48-Round .45 Grave",   "go_mac10_mag_48",  90 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_mac10"})
        HORDE:CreateItem("Attachment", "[MP5] 15-Round 9mm",   "go_mp5_mag_15",  90 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_mp5"})
        HORDE:CreateItem("Attachment", "[MP5] 40-Round 9mm",   "go_mp5_mag_40",  90 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_mp5"})
        HORDE:CreateItem("Attachment", "[PP-Bizon] 47-Round 9mm",   "go_bizon_mag_47",  90 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_bizon"})
        HORDE:CreateItem("Attachment", "[PP-Bizon] 82-Round 9mm",   "go_bizon_mag_82",  90 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_bizon"})
        HORDE:CreateItem("Attachment", "[UMP] 12-Round .45",   "go_ump_mag_12",  90 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_ump45"})
        HORDE:CreateItem("Attachment", "[UMP] 30-Round 9mm",   "go_ump_mag_30_9mm",  90 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_ump45"})
    
        HORDE:CreateItem("Attachment", "[Nova] 8-Round 12-Gauge",   "go_nova_mag_8",  90 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_go_nova"})
        HORDE:CreateItem("Attachment", "[Mag7] 3-Round 12-Gauge",   "go_mag7_mag_3",  90 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_go_mag7"})
        HORDE:CreateItem("Attachment", "[Mag7] 7-Round 12-Gauge",   "go_mag7_mag_7",  90 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_go_mag7"})
        HORDE:CreateItem("Attachment", "[M870] 4-Round",   "go_870_mag_4",  90 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_870"})
        HORDE:CreateItem("Attachment", "[M870] 8-Round",   "go_870_mag_8",  90 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_870"})
        HORDE:CreateItem("Attachment", "[M1014] 4-Round",   "go_m1014_mag_4",  90 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_m1014"})
        HORDE:CreateItem("Attachment", "[M1014] 7-Round",   "go_m1014_mag_7",  100 * unicsatts_multprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_m1014"})
    
        HORDE:CreateItem("Attachment", "[Famas] 25-Round 5.56mm",   "go_famas_mag_25",  100 * unicsatts_multprice,  0, "",
        {Assault=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_famas"})
        HORDE:CreateItem("Attachment", "[AK47] 10-Round 7.62mm Poly",   "go_ak_mag_10",  100 * unicsatts_multprice,  0, "",
        {Assault=true, Medic=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_ak47"})
        HORDE:CreateItem("Attachment", "[AK47] 10-Round 7.62mm Steel",   "go_ak_mag_10_steel",  100 * unicsatts_multprice,  0, "",
        {Assault=true, Medic=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_ak47"})
        HORDE:CreateItem("Attachment", "[AK47] 15-Round 5.45mm Poly",   "go_ak_mag_15_545",  100 * unicsatts_multprice,  0, "",
        {Assault=true, Medic=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_ak47"})
        HORDE:CreateItem("Attachment", "[AK47] 30-Round 5.45mm Poly",   "go_ak_mag_30_545",  100 * unicsatts_multprice,  0, "",
        {Assault=true, Medic=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_ak47"})
        HORDE:CreateItem("Attachment", "[AK47] 30-Round 7.62mm Poly",   "go_ak_mag_30",  100 * unicsatts_multprice,  0, "",
        {Assault=true, Medic=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_ak47"})
        HORDE:CreateItem("Attachment", "[AK47] 40-Round 7.62mm Poly",   "go_ak_mag_40",  100 * unicsatts_multprice,  0, "",
        {Assault=true, Medic=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_ak47"})
        HORDE:CreateItem("Attachment", "[AK47] 40-Round 7.62mm Steel",   "go_ak_mag_40_steel",  100 * unicsatts_multprice,  0, "",
        {Assault=true, Medic=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_ak47"})
        HORDE:CreateItem("Attachment", "[AK47] 45-Round 5.45mm Poly",   "go_ak_mag_45_545",  100 * unicsatts_multprice,  0, "",
        {Assault=true, Medic=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_ak47"})
        HORDE:CreateItem("Attachment", "[AK47] 60-Round 5.45mm Poly",   "go_ak_mag_60_545",  100 * unicsatts_multprice,  0, "",
        {Assault=true, Medic=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_ak47"})
        HORDE:CreateItem("Attachment", "[M4A1] 10-Round .50 Beowulf",   "go_m4_mag_10_50",  100 * unicsatts_multprice,  0, "",
        {Assault=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_m4"})
        HORDE:CreateItem("Attachment", "[M4A1] 20-Round 5.56mm",   "go_m4_mag_20",  100 * unicsatts_multprice,  0, "",
        {Assault=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_m4"})
        HORDE:CreateItem("Attachment", "[M4A1] 21-Round 9mm",   "go_m4_mag_21_9mm",  100 * unicsatts_multprice,  0, "",
        {Assault=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_m4"})
        HORDE:CreateItem("Attachment", "[M4A1] 30-Round 9mm",   "go_m4_mag_30_9mm",  100 * unicsatts_multprice,  0, "",
        {Assault=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_m4"})
        HORDE:CreateItem("Attachment", "[SG556] 20-Round 5.56mm",   "go_sg_mag_20",  100 * unicsatts_multprice,  0, "",
        {Assault=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_sg556"})
    
        HORDE:CreateItem("Attachment", "[SCAR] 10-Round 7.62mm",   "go_scar_mag_10",  100 * unicsatts_multprice,  0, "",
        {Ghost=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_go_scar"})
        HORDE:CreateItem("Attachment", "[SCAR] 30-Round 7.62mm",   "go_scar_mag_30",  100 * unicsatts_multprice,  0, "",
        {Ghost=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_go_scar"})
        HORDE:CreateItem("Attachment", "[G3] 10-Round 7.62mm Steel",   "go_g3_mag_10",  100 * unicsatts_multprice,  0, "",
        {Ghost=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_g3"})
        HORDE:CreateItem("Attachment", "[G3] 30-Round 5.56mm STANAG",   "go_g3_mag_30_556",  100 * unicsatts_multprice,  0, "",
        {Ghost=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_g3"})
        HORDE:CreateItem("Attachment", "[G3] 30-Round 7.62mm Steel",   "go_g3_mag_30",  100 * unicsatts_multprice,  0, "",
        {Ghost=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_horde_g3"})
    
        HORDE:CreateItem("Attachment", "[Negev] 100-Round 5.56mm",   "go_negev_belt_100",  100 * unicsatts_multprice,  0, "",
        {Heavy=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_go_negev"})
        --HORDE:CreateItem("Attachment", "[M249] 45-Round 12 Gauge",   "go_m249_mag_12g_45",  100,  0, "",
        --{Heavy=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_go_m249para"})
        HORDE:CreateItem("Attachment", "[M249] 200-Round 9mm",   "go_m249_mag_9_200",  50 * unicsatts_multprice,  0, "",
        {Heavy=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Magazine", arccw_attachment_wpn="arccw_go_m249para"})
    
        local stocksprice = 600
        -- Stock
        HORDE:CreateItem("Attachment", "BT-2 Pistol Stock",  "go_stock_pistol_bt",  stocksprice * .5,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Stock"})
        HORDE:CreateItem("Attachment", "Basilisk Stock",     "go_stock_basilisk",  stocksprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Stock"})
        HORDE:CreateItem("Attachment", "MOE Stock",           "go_stock_moe",  stocksprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Stock"})
        HORDE:CreateItem("Attachment", "Contractor Stock",   "go_stock_contractor",  stocksprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Stock"})
        HORDE:CreateItem("Attachment", "Ergonomic Stock",    "go_stock_ergo",  stocksprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Stock"})
        HORDE:CreateItem("Attachment", "Collapsible Stock",    "go_g3_stock_collapsible",  stocksprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Stock"})
        HORDE:CreateItem("Attachment", "Sniper Stock",    "go_scar_stock_sniper",  stocksprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Stock"})
        
        
        HORDE:CreateItem("Attachment", "Sturdy Stock",    "stock_sturdy",  stocksprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Stock"})
        HORDE:CreateItem("Attachment", "Skeleton Stock",    "stock_skeleton",  stocksprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Stock"})
        HORDE:CreateItem("Attachment", "Light Stock",    "stock_light",  stocksprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Stock"})
        HORDE:CreateItem("Attachment", "Heavy Stock",    "stock_heavy",  stocksprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Stock"})
        HORDE:CreateItem("Attachment", "Strafe Stock",    "stock_strafe",  stocksprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Stock"})
        
        -- Grips
        HORDE:CreateItem("Attachment", "Rubberized Grip",    "grip_rubberized",  stocksprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Grip"})
        HORDE:CreateItem("Attachment", "Smooth Grip",    "grip_smooth",  stocksprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Grip"})
        HORDE:CreateItem("Attachment", "Ergo Grip",    "grip_ergo",  stocksprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Grip"})
        HORDE:CreateItem("Attachment", "Sturdy Grip",    "grip_sturdy",  stocksprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Grip"})
    
        local muzzlesprice = 500
        local suppressorsprice = 250
        -- Muzzle
        HORDE:CreateItem("Attachment", "Bayonet",  "go_muzz_bayonet",  400,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Muzzle"})
        HORDE:CreateItem("Attachment", "Flash Hider",  "go_muzz_flashhider",  muzzlesprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Muzzle"})
        HORDE:CreateItem("Attachment", "Muzzle Booster",  "go_muzz_booster",  1000,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Muzzle"})
        HORDE:CreateItem("Attachment", "Muzzle Brake",  "go_muzz_brake",  muzzlesprice,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Muzzle"})
        HORDE:CreateItem("Attachment", "SSQ Suppressor",  "go_supp_ssq",  suppressorsprice,  0, "",
        {Assault=true, Ghost=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Muzzle"})
        HORDE:CreateItem("Attachment", "Rotor43 Suppressor",  "go_supp_rotor43",  suppressorsprice,  0, "",
        {Assault=true, Ghost=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Muzzle"})
        HORDE:CreateItem("Attachment", "PBS-4 Suppressor",  "go_supp_pbs4",  suppressorsprice,  0, "",
        {Assault=true, Ghost=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Muzzle"})
        HORDE:CreateItem("Attachment", "QDSS Suppressor",  "go_supp_qdss",  suppressorsprice,  0, "",
        {Assault=true, Ghost=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Muzzle"})
        HORDE:CreateItem("Attachment", "TGP-A Suppressor",  "go_supp_tgpa",  suppressorsprice,  0, "",
        {Assault=true, Ghost=true}, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Muzzle"})
    
        -- Ammo Type
        HORDE:CreateItem("Attachment", "Tracer Rounds",  "go_ammo_tr",  50,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Ammo Type"})
        HORDE:CreateItem("Attachment", "Match Rounds",  "go_ammo_match",  100,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Ammo Type"})
        HORDE:CreateItem("Attachment", "JHP Rounds",  "go_ammo_jhp",  100,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Ammo Type"})
        HORDE:CreateItem("Attachment", "AP/I Rounds",  "go_ammo_api",  100,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Ammo Type"})
        HORDE:CreateItem("Attachment", "TMJ Rounds",  "go_ammo_tmj",  100,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Ammo Type"})
        HORDE:CreateItem("Attachment", "Subsonic Rounds",  "go_ammo_sub",  100,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Ammo Type"})
        HORDE:CreateItem("Attachment", "[Shotgun] Magnum Shells",  "go_ammo_sg_magnum",  100,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Ammo Type"})
        HORDE:CreateItem("Attachment", "[Shotgun] Sabot Shells",  "go_ammo_sg_sabot",  100,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Ammo Type"})
        HORDE:CreateItem("Attachment", "[Shotgun] Scattershot Shells",  "go_ammo_sg_scatter",  100,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Ammo Type"})
        HORDE:CreateItem("Attachment", "[Shotgun] Slug Shells",  "go_ammo_sg_slug",  100,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Ammo Type"})
        HORDE:CreateItem("Attachment", "[Shotgun] Triple-Hit Shells",  "go_ammo_sg_triple",  100,  0, "",
        nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Ammo Type"})
    
        -- Perks
        local Perks = {
            {"Full Auto", "go_homemade_auto", 1500,},
            {"Enhanced Burst",  "go_perk_burst",  500,},
            {"Surgical Shot",  "perk_headshot",  1500, lvls = 3,
                commoncondition = {
                    class="Ghost",
                    lvl_per_tier=5
                },
            },
            {"Rushed Reloading",  "perk_fastreload",  1000, lvls = 3,
                commoncondition = {
                    class="Assault",
                    lvl_per_tier=5
                },
            },
            {"Frantic Firing Frenzy",  "perk_rapidfire",  500, lvls = 3,
                commoncondition = {
                    class="Heavy",
                    lvl_per_tier=5
                },
            },
            {"OverLoad",  "perk_overload",  1250,},
            {"Endurance",  "perk_fastmovementspeed",  500, lvls = 3,
                commoncondition = {
                    class="Survivor",
                    lvl_per_tier=5
                },
            },
        }
        
        for i, data in pairs(Perks) do
            local name, attid, price = data[1], data[2], data[3]
            if !data.lvls then
                HORDE:CreateItem("Attachment", name,  attid,  price,  0, "",
                nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Perk"}, nil, data["condition"])
                continue
            end
            local pricemult = data["pricemult"] or 1500
            local commoncondition = data["commoncondition"]
            for i=1, data.lvls do
                local str_i = tostring(i)
                HORDE:CreateItem("Attachment", name .. " (level - " .. str_i .. ")",  attid .. "_lvl" .. str_i, 
                i == 1 and price or data["price" .. str_i] or price + pricemult * (i - 1), 0, "",
                nil, 10, -1, {type=HORDE.ENTITY_PROPERTY_GIVE, is_arccw_attachment=true, arccw_attachment_type="Perk"}, nil, 
                i > 1 and (data["condition" .. str_i] or commoncondition and {[commoncondition.class]=commoncondition.lvl_per_tier*(i-1)}))
            end
        end
    end

-- INFUSIONS
    local old_infs = HORDE.GetDefaultItemInfusions
    local new_infs = function()
        
        local melee_slash_infusions = {HORDE.Infusion_Ruination, HORDE.Infusion_Chrono, HORDE.Infusion_Hemo, HORDE.Infusion_Quality, HORDE.Infusion_Quicksilver, HORDE.Infusion_Rejuvenating}
        local ballistic_infusions_sniper_rifles = {HORDE.Infusion_Ruination, HORDE.Infusion_Chrono, HORDE.Infusion_Impaling, HORDE.Infusion_Quality, HORDE.Infusion_Quicksilver, HORDE.Infusion_Siphoning}
        local ballistic_infusions_smgs = {HORDE.Infusion_Ruination, HORDE.Infusion_Chrono, HORDE.Infusion_Impaling, HORDE.Infusion_Quality, HORDE.Infusion_Quicksilver}
        local ballistic_infusions_light = {HORDE.Infusion_Ruination, HORDE.Infusion_Chrono, HORDE.Infusion_Impaling, HORDE.Infusion_Quality, HORDE.Infusion_Quicksilver}
        local ballistic_infusions_rifles = {HORDE.Infusion_Ruination, HORDE.Infusion_Chrono, HORDE.Infusion_Impaling, HORDE.Infusion_Quality, HORDE.Infusion_Quicksilver, HORDE.Infusion_Siphoning}
        local ballistic_infusions_mg_rifles = {HORDE.Infusion_Ruination, HORDE.Infusion_Chrono, HORDE.Infusion_Impaling, HORDE.Infusion_Quality, HORDE.Infusion_Titanium, HORDE.Infusion_Siphoning}
        
        --if !HORDE.items["arccw_horde_cz75"] then 
        --    new_itemsdata()
        --end
        HORDE.items["arccw_horde_cz75"].infusions = ballistic_infusions_light
        HORDE.items["arccw_horde_m9"].infusions = ballistic_infusions_light
        HORDE.items["arccw_horde_fiveseven"].infusions = ballistic_infusions_light
        HORDE.items["arccw_kf2_pistol_medic"].infusions = ballistic_infusions_light
        HORDE.items["arccw_horde_tac45"].infusions = ballistic_infusions_light
        HORDE.items["arccw_horde_usptac"].infusions = ballistic_infusions_light
        HORDE.items["arccw_horde_g18"].infusions = ballistic_infusions_light
        HORDE.items["arccw_horde_deagle_xix"].infusions = ballistic_infusions_light

        HORDE.items["arccw_horde_akimbo_deagle"].infusions = ballistic_infusions_light
        HORDE.items["arccw_horde_mac10"].infusions = ballistic_infusions_smgs
        HORDE.items["arccw_horde_mp5"].infusions = ballistic_infusions_smgs
        HORDE.items["arccw_horde_pp2000"].infusions = ballistic_infusions_smgs
        HORDE.items["arccw_horde_ump45"].infusions = ballistic_infusions_smgs
        HORDE.items["arccw_horde_mtar"].infusions = ballistic_infusions_smgs
        HORDE.items["arccw_horde_bizon"].infusions = ballistic_infusions_smgs
        HORDE.items["arccw_horde_p90"].infusions = ballistic_infusions_smgs
        local med_weps_infs = {HORDE.Infusion_Ruination, HORDE.Infusion_Chrono, HORDE.Infusion_Impaling, HORDE.Infusion_Quality, HORDE.Infusion_Rejuvenating}
        HORDE.items["arccw_horde_pp90m1"].infusions = med_weps_infs
        HORDE.items["arccw_horde_msmc"].infusions = med_weps_infs
        HORDE.items["arccw_horde_aks74u"].infusions = ballistic_infusions_smgs
        HORDE.items["arccw_horde_mp5_sup_med"].infusions = med_weps_infs
        HORDE.items["arccw_horde_mp5_sup"].infusions = ballistic_infusions_smgs
        HORDE.items["arccw_horde_pm9"].infusions = ballistic_infusions_smgs
        HORDE.items["arccw_horde_fmg9"].infusions = ballistic_infusions_smgs
        HORDE.items["arccw_horde_vityaz"].infusions = ballistic_infusions_smgs
        HORDE.items["arccw_horde_mp40"].infusions = ballistic_infusions_smgs
        HORDE.items["arccw_horde_g36c"].infusions = ballistic_infusions_smgs
        HORDE.items["arccw_go_nova"].infusions = ballistic_infusions_light
        HORDE.items["arccw_horde_870"].infusions = ballistic_infusions_light
        local ballistic_infusions_shotgun = {HORDE.Infusion_Ruination, HORDE.Infusion_Chrono, HORDE.Infusion_Impaling, HORDE.Infusion_Quality, HORDE.Infusion_Concussive}
        HORDE.items["arccw_horde_m16_pyro"].infusions = {HORDE.Infusion_Chrono, HORDE.Infusion_Impaling, HORDE.Infusion_Quality, HORDE.Infusion_Flaming}
        HORDE.items["arccw_horde_br99"].infusions = ballistic_infusions_shotgun
        HORDE.items["arccw_horde_spike"].infusions = ballistic_infusions_shotgun
        HORDE.items["arccw_horde_typhoon12"].infusions = ballistic_infusions_shotgun

        HORDE.items["arccw_horde_m1887"].infusions = ballistic_infusions_shotgun
        HORDE.items["arccw_horde_exec"].infusions = ballistic_infusions_shotgun
        HORDE.items["arccw_kf2_ak12"].infusions = ballistic_infusions_rifles
        HORDE.items["arccw_kf2_shotgun_medic"].infusions = ballistic_infusions_light
        HORDE.items["arccw_horde_stg44"].infusions = ballistic_infusions_rifles
        HORDE.items["arccw_horde_ak117"].infusions = ballistic_infusions_rifles

        HORDE.items["arccw_horde_m40a3"].infusions = ballistic_infusions_sniper_rifles
        HORDE.items["arccw_horde_hkg28"].infusions = ballistic_infusions_sniper_rifles
        HORDE.items["arccw_horde_m14"].infusions = ballistic_infusions_sniper_rifles
        HORDE.items["arccw_horde_glock"].infusions = ballistic_infusions_light
        HORDE.items["arccw_horde_usp"].infusions = ballistic_infusions_light
        HORDE.items["arccw_horde_p2000"].infusions = ballistic_infusions_light
        HORDE.items["arccw_horde_p250"].infusions = ballistic_infusions_light
        HORDE.items["arccw_horde_r8"].infusions = ballistic_infusions_light
        HORDE.items["arccw_horde_deagle"].infusions = ballistic_infusions_light
        HORDE.items["arccw_horde_m1911"].infusions = ballistic_infusions_light
        HORDE.items["arccw_horde_stonera1"].infusions = ballistic_infusions_mg_rifles
        HORDE.items["arccw_horde_m91"].infusions = ballistic_infusions_mg_rifles
        HORDE.items["arccw_horde_stoner"].infusions = ballistic_infusions_mg_rifles

        HORDE.items["arccw_kf2_ak12"].infusions = ballistic_infusions_rifles
        HORDE.items["arccw_horde_maverick"].infusions = ballistic_infusions_rifles
        HORDE.items["arccw_horde_asval"].infusions = ballistic_infusions_rifles
        HORDE.items["arccw_horde_an94"].infusions = ballistic_infusions_rifles
        HORDE.items["arccw_horde_machgungalil"].infusions = ballistic_infusions_rifles
        HORDE.items["arccw_horde_ak47supmod"].infusions = ballistic_infusions_rifles
        HORDE.items["arccw_horde_type95"].infusions = ballistic_infusions_rifles
        HORDE.items["arccw_horde_svu"].infusions = ballistic_infusions_sniper_rifles
        HORDE.items["arccw_horde_stormgiant"].infusions = {HORDE.Infusion_Chrono, HORDE.Infusion_Hemo, HORDE.Infusion_Galvanizing, HORDE.Infusion_Quality, HORDE.Infusion_Quicksilver, HORDE.Infusion_Rejuvenating}
        HORDE.items["arccw_horde_dualsword"].infusions = {HORDE.Infusion_Chrono, HORDE.Infusion_Hemo, HORDE.Infusion_Galvanizing, HORDE.Infusion_Quality, HORDE.Infusion_Quicksilver, HORDE.Infusion_Rejuvenating}
        HORDE.items["arccw_horde_riotshield"].infusions = {HORDE.Infusion_Chrono, HORDE.Infusion_Hemo, HORDE.Infusion_Galvanizing, HORDE.Infusion_Quality, HORDE.Infusion_Quicksilver, HORDE.Infusion_Rejuvenating}
        HORDE.items["arccw_horde_ballistic_knife"].infusions = melee_slash_infusions
    end
    function HORDE:GetDefaultItemInfusions() 
        old_infs()
        new_infs()
    end
-- GADGETS
    local old_gadgets = HORDE.GetDefaultGadgets
    local new_gadgets = function() 
        HORDE:CreateGadgetItem("gadget_armored", 3000, 2, {SWAT=true}, {SWAT=15})
        HORDE:CreateGadgetItem("gadget_smgpower", 3500, 3, {SWAT=true}, {SWAT=20})
        HORDE:CreateGadgetItem("gadget_timestop", 4000, 3, {Ghost=true}, {Ghost=30})
        HORDE:CreateGadgetItem("gadget_timeskip", 4000, 3, {Assault=true}, {Ghost=30})
        HORDE:CreateGadgetItem("gadget_iv_injection", 2000, 1, {Assault=true, SWAT=true}, {
            VariousConditions=true,
            Assault={Assault=5},
            SWAT = {SWAT=5},
        })
        HORDE:CreateGadgetItem("gadget_vitality_booster", 2500, 1, {Survivor=true})
        HORDE:CreateGadgetItem("gadget_agility_booster", 2500, 1, {Survivor=true, SWAT=true}, {
            VariousConditions=true,
            Survivor={Survivor=15},
            SWAT = {SWAT=10}
        })
    end
    function HORDE:GetDefaultGadgets()
        old_gadgets()
        new_gadgets()
    end

if SERVER then
    if GetConVarNumber("horde_default_item_config") == 0 then
        local function GetItemsData()
            if not file.IsDir("horde", "DATA") then
                file.CreateDir("horde")
                return
            end
    
            if file.Read("horde/items.txt", "DATA") then
                local t = util.JSONToTable(file.Read("horde/items.txt", "DATA"))

                for _, item in pairs(t) do
                    if item.name == "" or item.class == "" or item.name == nil or item.category == nil or item.class == nil or item.ammo_price == nil or item.secondary_ammo_price == nil then
                        HORDE:SendNotification("Item config file validation failed! Please update your file or delete it.", 1)
                        return
                    end
                end

                print("[HORDE] - Loaded custom item config.")

                return t
            end
        end

        HORDE.items = GetItemsData() or {}
        GetStarterWeapons()

        HORDE:SyncItems()
    else
        HORDE:GetDefaultItemsData()
        GetStarterWeapons()
        HORDE:SyncItems()
    end

    CONFIG.items = HORDE.items
end

--[[if SERVER and not (GetConVar("horde_external_lua_config"):GetString() and GetConVar("horde_external_lua_config"):GetString() ~= "") and GetConVarNumber("horde_default_item_config") != 0 then
    HORDE:GetDefaultItemsData()
    GetStarterWeapons()
    HORDE:SyncItems()
end]]