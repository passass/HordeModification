
HORDE.Class_SWAT = "SWAT"

local function GetClassData()
    if SERVER then
        if not file.IsDir("horde", "DATA") then
            file.CreateDir("horde")
            return
        end

        if file.Read("horde/class.txt", "DATA") then
            local t = util.JSONToTable(file.Read("horde/class.txt", "DATA"))

            for _, class in pairs(t) do
                if class.display_name then
                    HORDE.classes[class.name].display_name = class.display_name
                end
                if class.extra_description then
                    HORDE.classes[class.name].extra_description = class.extra_description
                end
                if class.model then
                    HORDE.classes[class.name].model = class.model
                end
                if class.base_perk then
                    HORDE.classes[class.name].base_perk = class.base_perk
                end
                if class.perks then
                    HORDE.classes[class.name].perks = class.perks
                end
                if class.icon then
                    HORDE.classes[class.name].icon = class.icon
                end
            end
        end
    end
end


function HORDE:GetDefaultClassesData()
    HORDE:CreateClass(
        HORDE.Class_Survivor,
        "Has access to all weapons except for exclusive and special weapons.\n\nLimited access to attachments.",
        100,
        GetConVar("horde_base_walkspeed"):GetInt(),
        GetConVar("horde_base_runspeed"):GetInt(),
        "survivor_base",
        {
            [1] = {title = "Survival", choices = {"berserker_breathing_technique", "medic_antibiotics", "swat_berserker"}},
            [2] = {title = "Imprinting", choices = {"survivor_damagemaster", "swat_rapidfire", "assault_speedreload"}},
            [3] = {title = "Improvise", choices = {"heavy_liquid_armor", "heavy_floating_carrier", "swat_bandolier"}}, -- {"heavy_liquid_armor", "heavy_floating_carrier"}},
            [4] = {title = "Inspired Learning", choices = {"ghost_headhunter", "specops_flare", "survivor_rapidslomo"}},
        },
        0,nil,nil,nil,
        {HORDE.Class_Survivor}
    )

    HORDE:CreateClass(
        HORDE.Class_Assault,
        "Has full access to assault rifles.",
        100,
        GetConVar("horde_base_walkspeed"):GetInt(),
        GetConVar("horde_base_runspeed"):GetInt(),
        "assault_base",
        {
            [1] = {title = "Maneuverability", choices = {"assault_ambush", "assault_charge", "assault_speedreload"}},--"assault_charge"}},
            [2] = {title = "Adaptability", choices = {"assault_drain", "assault_overclock"}},
            [3] = {title = "Aggression", choices = {"assault_cardiac_resonance", "assault_cardiac_overload"}},
            [4] = {title = "Conditioning", choices = {"assault_heightened_reflex", "assault_merciless_assault"}},
        },
        1,nil,nil,nil,
        {HORDE.Class_Assault}
    )

    HORDE:CreateClass(
        HORDE.Class_Heavy,
        "Has full access to machine guns and high weight weapons.",
        100,
        GetConVar("horde_base_walkspeed"):GetInt(),
        GetConVar("horde_base_runspeed"):GetInt(),
        "heavy_base",
        {
            [1] = {title = "Suppression", choices = {"heavy_sticky_compound", "heavy_crude_casing"}},
            [2] = {title = "Backup", choices = {"heavy_repair_catalyst", "heavy_floating_carrier"}},
            [3] = {title = "Armor Protection", choices = {"heavy_liquid_armor", "heavy_reactive_armor"}},
            [4] = {title = "Technology", choices = {"heavy_nanomachine", "heavy_ballistic_shock"}},
        },
        2,nil,nil,nil,
        {HORDE.Class_Heavy}
    )

    HORDE:CreateClass(
        HORDE.Class_Medic,
        "Has acesss to most light weapons and medical tools.",
        100,
        GetConVar("horde_base_walkspeed"):GetInt(),
        GetConVar("horde_base_runspeed"):GetInt(),
        "medic_base",
        {
            [1] = {title = "Medicine", choices = {"medic_antibiotics", "medic_painkillers", "medic_speedy"}},
            [2] = {title = "Bio-Engineering", choices = {"medic_berserk", "medic_fortify", "medic_syringefaster"}},
            [3] = {title = "Enhancement", choices = {"medic_purify", "medic_haste"}},
            [4] = {title = "Natural Selection", choices = {"medic_cellular_implosion", "medic_xcele", "engineer_rapidandreloadslomo"}},
        },
        3,nil,nil,nil,
        {HORDE.Class_Medic}
    )

    HORDE:CreateClass(
        HORDE.Class_Demolition,
        "Has full access to explosive weapons.",
        100,
        GetConVar("horde_base_walkspeed"):GetInt(),
        GetConVar("horde_base_runspeed"):GetInt(),
        "demolition_base",
        {
            [1] = {title = "Grenade", choices = {"demolition_frag_impact", "demolition_frag_cluster"}},
            [2] = {title = "Weaponry", choices = {"demolition_direct_hit", "demolition_seismic_wave", "assault_speedreload"}},
            [3] = {title = "Approach", choices = {"demolition_fragmentation", "demolition_knockout"}},
            [4] = {title = "Destruction", choices = {"demolition_chain_reaction", "demolition_pressurized_warhead"}},
        },
        4,nil,nil,nil,
        {HORDE.Class_Demolition}
    )

    HORDE:CreateClass(
        HORDE.Class_Ghost,
        "Has access to sniper rifles and selected light weapons.\n\nHave access to suppressors and sniper scopes.",
        100,
        GetConVar("horde_base_walkspeed"):GetInt(),
        GetConVar("horde_base_runspeed"):GetInt(),
        "ghost_base",
        {
            [1] = {title = "Tactics", choices = {"ghost_headhunter", "ghost_sniper"}},
            [2] = {title = "Reposition", choices = {"ghost_phase_walk", "ghost_ghost_veil"}},
            [3] = {title = "Trajectory", choices = {"ghost_brain_snap", "ghost_kinetic_impact"}},
            [4] = {title = "Disposal", choices = {"ghost_coup", "ghost_decapitate"}},
        },
        5,nil,nil,nil,
        {HORDE.Class_Ghost}
    )

    HORDE:CreateClass(
        HORDE.Class_Engineer,
        "Has access to special weapons and equipment.",
        100,
        GetConVar("horde_base_walkspeed"):GetInt(),
        GetConVar("horde_base_runspeed"):GetInt(),
        "engineer_base",
        {
            [1] = {title = "Craftsmanship", choices = {"engineer_tinkerer", "engineer_pioneer"}},
            [2] = {title = "Core", choices = {"engineer_fusion", "engineer_metabolism"}},
            [3] = {title = "Manipulation", choices = {"engineer_antimatter_shield", "engineer_displacer", "engineer_rapidandreloadslomo"}},
            [4] = {title = "Experimental", choices = {"engineer_symbiosis", "engineer_kamikaze", "engineer_welderslomo"}},
        },
        6,nil,nil,nil,
        {HORDE.Class_Engineer}
    )

    HORDE:CreateClass(
        HORDE.Class_Berserker,
        "Only has access to melee weapons.",
        100,
        GetConVar("horde_base_walkspeed"):GetInt(),
        GetConVar("horde_base_runspeed"):GetInt(),
        "berserker_base",
        {
            [1] = {title = "Fundamentals", choices = {"berserker_breathing_technique", "berserker_bloodlust"}},
            [2] = {title = "Technique", choices = {"berserker_bushido", "berserker_savagery"}},
            [3] = {title = "Parry", choices = {"berserker_graceful_guard", "berserker_unwavering_guard"}},
            [4] = {title = "Combat Arts", choices = {"berserker_phalanx", "berserker_rip_and_tear"}},
        },
        7,nil,nil,nil,
        {HORDE.Class_Berserker}
    )

    HORDE:CreateClass(
        HORDE.Class_Warden,
        "Has full access to shotguns and watchtowers (horde_watchtower).",
        100,
        GetConVar("horde_base_walkspeed"):GetInt(),
        GetConVar("horde_base_runspeed"):GetInt(),
        "warden_base",
        {
            [1] = {title = "Sustain", choices = {"warden_bulwark", "warden_vitality"}},
            [2] = {title = "Resource Utilization", choices = {"warden_restock", "warden_inoculation"}},
            [3] = {title = "Escort", choices = {"warden_rejection_pulse", "warden_energize"}},
            [4] = {title = "Coverage", choices = {"warden_ex_machina", "warden_resonance_cascade", "engineer_rapidandreloadslomo"}},
        },
        8,nil,nil,nil,
        {HORDE.Class_Warden}
    )

    HORDE:CreateClass(
        HORDE.Class_Cremator,
        "Has access to heat-based weaponry.",
        100,
        GetConVar("horde_base_walkspeed"):GetInt(),
        GetConVar("horde_base_runspeed"):GetInt(),
        "cremator_base",
        {
            [1] = {title = "Chemicals", choices = {"cremator_methane", "cremator_napalm"}},
            [2] = {title = "Energy Absorption", choices = {"cremator_positron_array", "cremator_entropy_shield"}},
            [3] = {title = "Heat Manipulation", choices = {"cremator_hyperthermia", "cremator_ionization"}},
            [4] = {title = "Energy Discharge", choices = {"cremator_firestorm", "cremator_incineration", "engineer_rapidandreloadslomo"}},
        },
        9,nil,nil,nil,
        {HORDE.Class_Cremator}
    )

    HORDE:CreateClass(
        HORDE.Class_SWAT,
        "Has full access to SMGs.",
        100,
        GetConVar("horde_base_walkspeed"):GetInt(),
        GetConVar("horde_base_runspeed"):GetInt(),
        "swat_base",
        {
            [1] = {title = "Maneuverability", choices = {"assault_ambush", "assault_speedreload"}},--"assault_charge"}},
            [2] = {title = "Adaptability", choices = {"swat_rapidfire", "swat_extendedclipsize"}},
            [3] = {title = "Tank", choices = {"berserker_breathing_technique", "swat_berserker"}},
            [4] = {title = "Conditioning", choices = {"assault_heightened_reflex", "swat_bandolier"}},
        },
        10,nil,nil,nil,
        {HORDE.Class_SWAT}
    )
end

if SERVER then
    HORDE:GetDefaultClassesData()
    if GetConVar("horde_default_class_config"):GetInt() == 1 then
        -- Do nothing
    else
        GetClassData()
    end

    SyncClasses()
end
HORDE.classes_to_subclasses[HORDE.Class_SWAT] = {HORDE.Class_SWAT}
HORDE.classes_to_order[HORDE.Class_SWAT] = 10
HORDE.order_to_class_name[10] = HORDE.Class_SWAT

local prefix = "horde/gamemode/custom/subclasses/"
local function Horde_LoadSubclasses()
    local dev = GetConVar("developer"):GetBool()
    for _, f in ipairs(file.Find(prefix .. "*", "LUA")) do
        SUBCLASS = {}
        AddCSLuaFile(prefix .. f)
        include(prefix .. f)
        if SUBCLASS.Ignore then goto cont end
        SUBCLASS.SortOrder = SUBCLASS.SortOrder or 0
        SUBCLASS.BasePerk = SUBCLASS.BasePerk or (string.lower(SUBCLASS.PrintName).. "_base")

        HORDE.subclasses[SUBCLASS.PrintName] = SUBCLASS
        local crc_val = util.CRC(SUBCLASS.PrintName)
        HORDE.subclass_name_to_crc[SUBCLASS.PrintName] = crc_val
        HORDE.order_to_subclass_name[crc_val] = SUBCLASS.PrintName
        if SUBCLASS.ParentClass then
            table.insert(HORDE.classes_to_subclasses[SUBCLASS.ParentClass], SUBCLASS.PrintName)
            HORDE.subclasses_to_classes[SUBCLASS.PrintName] = SUBCLASS.ParentClass
        else
            HORDE.subclasses_to_classes[SUBCLASS.PrintName] = SUBCLASS.PrintName
    end

        if dev then print("[Horde] Loaded subclass '" .. SUBCLASS.PrintName .. "'.") end
        ::cont::
    end
    PERK = nil
end

Horde_LoadSubclasses()

function HORDE:LoadSubclassChoices()
    MySelf.Horde_subclass_choices = {}
    if not file.Exists("horde/subclass_choices.txt", "DATA") then
        for class_name, _ in pairs(HORDE.classes_to_subclasses) do
            MySelf.Horde_subclass_choices[class_name] = class_name
        end
        HORDE:SaveSubclassChoices()
    else
        local f = file.Open("horde/subclass_choices.txt", "rb", "DATA")
        if not MySelf.Horde_subclasses then MySelf.Horde_subclasses = {} end
        while not f:EndOfFile() do
            local class_order = f:ReadULong()
            local subclass_order = f:ReadULong()
            local class = HORDE.order_to_class_name[class_order]
            if class then
                MySelf.Horde_subclass_choices[class] = HORDE.order_to_subclass_name[tostring(subclass_order)]
                MySelf.Horde_subclasses[class] = HORDE.order_to_subclass_name[tostring(subclass_order)]
            end
        end
        f:Close()

        -- Double check that we have all the subclasses we need
        for class_name, _ in pairs(HORDE.classes_to_subclasses) do
            if not MySelf.Horde_subclass_choices[class_name] then
                MySelf.Horde_subclass_choices[class_name] = class_name
            end
        end
    end
end
