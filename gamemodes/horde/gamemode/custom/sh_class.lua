
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


local GetDefaultClassesData_old = HORDE.GetDefaultClassesData

function HORDE:GetDefaultClassesData()
    GetDefaultClassesData_old(HORDE)
    HORDE.classes[HORDE.Class_Survivor].perks = {
        [1] = {title = "Survival", choices = {"berserker_breathing_technique", "medic_antibiotics", "swat_berserker"}},
        [2] = {title = "Imprinting", choices = {"survivor_damagemaster", "swat_rapidfire", "assault_speedreload"}},
        [3] = {title = "Improvise", choices = {"heavy_liquid_armor", "heavy_floating_carrier", "swat_bandolier"}}, -- {"heavy_liquid_armor", "heavy_floating_carrier"}},
        [4] = {title = "Inspired Learning", choices = {"ghost_headhunter", "specops_flare", "survivor_rapidslomo"}},
    }

    HORDE.classes[HORDE.Class_Assault].perks[1].choices = {"assault_ambush", "assault_charge", "assault_speedreload"}

    HORDE.classes[HORDE.Class_Medic].perks[1].choices = {"medic_antibiotics", "medic_painkillers", "medic_speedy"}
    HORDE.classes[HORDE.Class_Medic].perks[2].choices = {"medic_berserk", "medic_fortify", "medic_syringefaster"}
    HORDE.classes[HORDE.Class_Medic].perks[4].choices = {"medic_cellular_implosion", "medic_xcele", "engineer_rapidandreloadslomo"}

    HORDE.classes[HORDE.Class_Demolition].perks[2].choices = {"demolition_direct_hit", "demolition_seismic_wave", "assault_speedreload"}
    HORDE.classes[HORDE.Class_Engineer].perks[3].choices = {"engineer_antimatter_shield", "engineer_displacer", "engineer_rapidandreloadslomo"}
    HORDE.classes[HORDE.Class_Engineer].perks[4].choices = {"engineer_symbiosis", "engineer_kamikaze", "engineer_welderslomo"}

    HORDE.classes[HORDE.Class_Warden].perks[4].choices = {"warden_ex_machina", "warden_resonance_cascade", "engineer_rapidandreloadslomo"}

    HORDE.classes[HORDE.Class_Cremator].perks[4].choices = {"cremator_firestorm", "cremator_incineration", "engineer_rapidandreloadslomo"}


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

    local f1_exists, f2_exists = file.Exists("horde/subclass_choices.txt", "DATA"), file.Exists("horde/horde_ext/subclass_choices.txt", "DATA")

    if not f1_exists and not f2_exists then
        for class_name, _ in pairs(HORDE.classes_to_subclasses) do
            MySelf.Horde_subclass_choices[class_name] = class_name
        end
        HORDE:SaveSubclassChoices()
    else
        local f
        if f2_exists then
            f = file.Open("horde/horde_ext/subclass_choices.txt", "rb", "DATA")
        else
            f = file.Open("horde/subclass_choices.txt", "rb", "DATA")
        end
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

function HORDE:SaveSubclassChoices()
    local f = file.Open("horde/horde_ext/subclass_choices.txt", "wb", "DATA")
    if f then
        for class, subclass in pairs(MySelf.Horde_subclass_choices) do
            f:WriteULong(HORDE.classes_to_order[class])
            f:WriteULong(HORDE.subclass_name_to_crc[subclass])
        end
        f:Close()
    end
end

if CLIENT then
    local player_init = false
    local player_initclass = false

    hook.Add("InitPostEntity", "Horde_PlayerInit", function()
        timer.Simple(0, function ()
            HORDE:LoadSubclassChoices()
            local f = file.Read("horde/horde_ext/class_choices.txt", "DATA")
            if !f then
                f = file.Read("horde/class_choices.txt", "DATA")
            end
            if f then
                local class = f
                if not HORDE.subclasses[class] then
                    class = HORDE.Class_Survivor
                end
            -- I Seriously don't understand what it's supposed to do.
                --[[if HORDE.subclasses_to_classes[f2] then
                    f2 = HORDE.subclasses_to_classes[f2]
                end]]--
    
                HORDE:SendSavedPerkChoices(f)
                player_initclass = true
                net.Start("Horde_InitClass")
                net.WriteString(class)
                net.SendToServer()
            end
            player_init = true
            net.Start("Horde_PlayerInit")
            net.SendToServer()
        end)
    end)

    hook.Add("InitPostEntity", "Horde_PlayerInit_2", function()
        timer.Simple(1, function()
            if !player_init then
                net.Start("Horde_PlayerInit")
                net.SendToServer()
            end
            if !player_initclass then
                net.Start("Horde_InitClass")
                net.WriteString(HORDE.Class_Survivor)
                net.SendToServer()
            end
        end)
	end)
end
