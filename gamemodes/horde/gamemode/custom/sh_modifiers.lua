-- melee attack mults
local arccw_melees_bases = {arccw_horde_base_melee = true, arccw_base_melee = true}
local tfa_melees_base = {horde_tfa_melee_base = true, tfa_melee_base = true}

function HORDE.IsMeleeWeapon(wep)
    return arccw_melees_bases[wep.Base] or tfa_melees_base[wep.Base]
end

-- melee attack mults

local special_conditions = {
    Mult_MeleeTime = {
        postinit =
            function(wep) if wep.ArcCW and arccw_melees_bases[wep.Base] then
                if wep.Animations.bash then
                    wep.Horde_Mult_MeleeTimeMults_bash = wep.Animations.bash.Mult or 1
                end
                
                if wep.Animations.bash2 then
                    wep.Horde_Mult_MeleeTimeMults_bash2 = wep.Animations.bash2.Mult or 1
                end
            elseif wep.IsTFAWeapon and tfa_melees_base[wep.Base] then
                if wep.Primary.Attacks then
                    if !wep.SequenceRateOverride then wep.SequenceRateOverride = {} end
                    if !wep.SequenceRateOverrideScaled then wep.SequenceRateOverrideScaled = {} end
                    for _, attacktable in pairs(wep.Primary.Attacks) do
                        if !attacktable.act then continue end
                        wep["Horde_Mult_MeleeTimeMults_" .. attacktable.act] = wep.SequenceRateOverride[attacktable.act] or 1
                    end
                end
            end
            return true
        end,
        calculate =
        function(wep, total_mult)
            if wep.ArcCW and arccw_melees_bases[wep.Base] then
                wep.ModifiedCache["Mult_MeleeTime"] = true
                wep.TickCache_Mults["Mult_MeleeTime"] = nil
                wep.Mult_MeleeTime = total_mult
        
                wep.ModifiedCache["Mult_MeleeTime"] = true
                if wep.ModifiedCache_Permanent then
                    wep.ModifiedCache_Permanent["Mult_MeleeTime"] = true
                end
                
                if wep.Animations.bash then
                    wep.Animations.bash.Mult = wep.Horde_Mult_MeleeTimeMults_bash * total_mult
                end
                
                if wep.Animations.bash2 then
                    wep.Animations.bash2.Mult = wep.Horde_Mult_MeleeTimeMults_bash2 * total_mult
                end
            elseif wep.IsTFAWeapon and tfa_melees_base[wep.Base] then
                if wep.Primary.Attacks then
                    if !wep.SequenceRateOverride then wep.SequenceRateOverride = {} end
                    if !wep.SequenceRateOverrideScaled then wep.SequenceRateOverrideScaled = {} end
                    for _, attacktable in pairs(wep.Primary.Attacks) do
                    if !attacktable.act then continue end
                        local mult = (wep["Horde_Mult_MeleeTimeMults_" .. attacktable.act] or 1) * (1 / total_mult)
                        if mult == 1 then
                            mult = nil
                        end
                        wep.SequenceRateOverride[attacktable.act] = mult
                        wep.SequenceRateOverrideScaled[attacktable.act] = mult
                        wep.StatCache2["SequenceRateOverrideScaled." .. attacktable.act] = nil
                        wep.StatCache2["SequenceRateOverride." .. attacktable.act] = nil
                    end
                    wep:ClearStatCache()
                end
            end
            return true
        end,
        add_modifier_if = HORDE.IsMeleeWeapon,
    },
    Horde_MaxMags = {
        preinit = function(wep)
            if !wep.Horde_MaxMags then
                wep.Horde_MaxMags = 20
            end
        end,
    },
    Horde_TotalMaxAmmoMult = {
        preinit = function(wep)
            if !wep.Horde_TotalMaxAmmoMult then
                wep.Horde_TotalMaxAmmoMult = 1
            end
        end
    },
    Mult_ReloadTime = {
        preinit = function(wep)
            if wep.IsTFAWeapon and wep.SequenceRateOverride and wep.SequenceRateOverride[ACT_VM_RELOAD] then
                wep.Horde_ModifiersTable["Mult_ReloadTime"] = {}
                wep.Horde_ModifiersTable["Mult_ReloadTime"]["init"] = wep.SequenceRateOverride[ACT_VM_RELOAD]
            elseif wep.ArcCW and wep.ChargeWeapon then
                if wep.Animations["charging"].Mult then
                    wep.Animations["charging"].oldMult = wep.Animations["charging"].Mult
                end

                if wep.Animations["fire"].Mult then
                    wep.Animations["fire"].oldMult = wep.Animations["fire"].Mult
                end

                if wep.Animations["fire_iron"] and wep.Animations["fire_iron"].Mult then
                    wep.Animations["fire_iron"].oldMult = wep.Animations["fire_iron"].Mult
                end
            end
        end,
        calculate = function(wep, total_mult)
            if wep.IsTFAWeapon then
                total_mult = 1 / total_mult
                
                if !wep.SequenceRateOverride then wep.SequenceRateOverride = {} end
                if !wep.SequenceRateOverrideScaled then wep.SequenceRateOverrideScaled = {} end

                if wep.ChargeRate then
                    wep.SequenceRateOverride[174] = total_mult
                    wep.SequenceRateOverrideScaled[174] = total_mult
                    wep.SequenceRateOverride[181] = 1 / total_mult
                    wep.SequenceRateOverrideScaled[181] = 1 / total_mult
                    wep.SequenceRateOverride[6] = total_mult
                    wep.SequenceRateOverrideScaled[6] = total_mult
                    wep.SequenceRateOverride[3] = total_mult ^ .5
                    wep.SequenceRateOverrideScaled[3] = total_mult ^ .5
                    wep.SequenceRateOverride[1] = total_mult
                    wep.SequenceRateOverrideScaled[1] = total_mult

                    wep.StatCache2["SequenceRateOverrideScaled." .. 174] = nil
                    wep.StatCache2["SequenceRateOverride." .. 174] = nil
                    wep.StatCache2["SequenceRateOverrideScaled." .. 181] = nil
                    wep.StatCache2["SequenceRateOverride." .. 181] = nil
                    wep.StatCache2["SequenceRateOverrideScaled." .. 6] = nil
                    wep.StatCache2["SequenceRateOverride." .. 6] = nil
                    wep.StatCache2["SequenceRateOverrideScaled." .. 3] = nil
                    wep.StatCache2["SequenceRateOverride." .. 3] = nil
                    wep.StatCache2["SequenceRateOverrideScaled." .. 1] = nil
                    wep.StatCache2["SequenceRateOverride." .. 1] = nil
                end

                wep.SequenceRateOverride[ACT_VM_RELOAD] = total_mult
                wep.SequenceRateOverrideScaled[ACT_VM_RELOAD] = total_mult
                wep.SequenceRateOverride[ACT_VM_RELOAD_EMPTY] = total_mult
                wep.SequenceRateOverrideScaled[ACT_VM_RELOAD_EMPTY] = total_mult

                wep.StatCache2["SequenceRateOverrideScaled." .. ACT_VM_RELOAD] = nil
                wep.StatCache2["SequenceRateOverride." .. ACT_VM_RELOAD] = nil
                wep.StatCache2["SequenceRateOverrideScaled." .. ACT_VM_RELOAD_EMPTY] = nil
                wep.StatCache2["SequenceRateOverride." .. ACT_VM_RELOAD_EMPTY] = nil
                wep:ClearStatCache()
                return true
            elseif wep.ArcCW and wep.ChargeWeapon then
                total_mult = 1 / total_mult
                wep.Animations["charging"].Mult = (wep.Animations["charging"].oldMult or 1) * (1 / total_mult)
                wep.Animations["fire"].Mult = (wep.Animations["fire"].oldMult or 1) * (1 / total_mult)
                if wep.Animations["fire_iron"] then
                    wep.Animations["fire_iron"].Mult = (wep.Animations["fire_iron"].oldMult or 1) * (1 / total_mult)
                end

                wep:ChangeVar("Mult_Charge_Speed", 1 / total_mult)
                wep:ChangeVar("Mult_Charge_ReloadAfter_Timer", 1 / total_mult)

                return true
            end
        end
    },
    Mult_RPM = {
        preinit = function(wep)
            if wep.IsTFAWeapon then
                if wep.ChargeRate then
                    wep.Horde_ModifiersTable["Mult_RPM"] = {}
                    wep.Horde_ModifiersTable["Mult_RPM"]["init"] = wep.ChargeRate
                elseif wep.Primary and wep.Primary.RPM then
                    wep.Horde_ModifiersTable["Mult_RPM"] = {}
                    wep.Horde_ModifiersTable["Mult_RPM"]["init"] = wep.Primary.RPM
                end
            end
        end,
        calculate = function(wep, total_mult)
            if wep.IsTFAWeapon then
                if wep.ChargeRate then
                    wep.ChargeRate = total_mult
                    wep.StatCache2["ChargeRate"] = nil
                    wep:ClearStatCache()
                elseif wep.Primary and wep.Primary.RPM then
                    wep.Primary_TFA.RPM = total_mult
                    wep:ClearStatCache()
                    return true
                end
            end
        end
    },
}

function HORDE:Modifier_AddSpecialCondition(cond)
    table.insert(special_conditions, cond)
end

local function CanAddModifier(wep, modifier)
    return !special_conditions[modifier] or !special_conditions[modifier].add_modifier_if or special_conditions[modifier].add_modifier_if(wep)
end

local function CalculateTotalMult(wep, modifier)
    local total_mult = 1
    for _, mult in pairs(wep.Horde_ModifiersTable[modifier]) do
        total_mult = total_mult * mult
    end

    if special_conditions[modifier] and special_conditions[modifier].calculate and special_conditions[modifier].calculate(wep, total_mult) then
        return
    end

    wep[modifier] = total_mult

    if wep.ArcCW then
        wep.ModifiedCache[modifier] = true
        wep.TickCache_Mults[modifier] = nil
        if wep.ModifiedCache_Permanent then
            wep.ModifiedCache_Permanent[modifier] = true
        end
    end
end


local function InitModifierTable(wep, modifier)
    if !wep.Horde_ModifiersTable then
        wep.Horde_ModifiersTable = {}
    end

    if special_conditions[modifier] and special_conditions[modifier].preinit and special_conditions[modifier].preinit(wep) then
        return
    end

    local init
    if wep.Horde_ModifiersTable[modifier] and wep.Horde_ModifiersTable[modifier]["init"] then
        init = wep.Horde_ModifiersTable[modifier]["init"]
    end

    wep.Horde_ModifiersTable[modifier] = {}
    if init then
        wep.Horde_ModifiersTable[modifier]["init"] = init
    elseif wep[modifier] then
        wep.Horde_ModifiersTable[modifier]["init"] = wep[modifier]
    end

    if special_conditions[modifier] and special_conditions[modifier].postinit then
        special_conditions[modifier].postinit(wep)
    end
end

function HORDE:Modifier_AddToWeapons(ply, modifier, primarykey, mult)
    if !ply.Horde_ModifiersTable then
        ply.Horde_ModifiersTable = {}
    end
    if !ply.Horde_ModifiersTable[modifier] then
        ply.Horde_ModifiersTable[modifier] = {}
    end
    ply.Horde_ModifiersTable[modifier][primarykey] = mult
    for _, wep in pairs(ply:GetWeapons()) do
        if !CanAddModifier(wep, modifier) then continue end
        if !wep.Horde_ModifiersTable or !wep.Horde_ModifiersTable[modifier] then
            InitModifierTable(wep, modifier)
        end
        wep.Horde_ModifiersTable[modifier][primarykey] = mult

        CalculateTotalMult(wep, modifier)
    end
    if SERVER then
        net.Start("Horde_wepModifierApply")
        net.WriteBool(false)
        net.WriteString(modifier)
        net.WriteString(primarykey)
        if mult then
            net.WriteBool(false)
            net.WriteFloat(mult)
        else
            net.WriteBool(true)
        end
        
        net.Send(ply)
    end
end

function HORDE:LoadToWeaponModifier(wep)
    local ply = SERVER and wep:GetOwner() or MySelf
    if !ply.Horde_ModifiersTable then
        ply.Horde_ModifiersTable = {}
        return
    end
    if SERVER then
        net.Start("Horde_wepModifierApply")
        net.WriteBool(true)
        net.WriteEntity(wep)
        net.Send(ply)
    end
    for modifier, multtable in pairs(ply.Horde_ModifiersTable) do
        if !CanAddModifier(wep, modifier) then continue end
        InitModifierTable(wep, modifier)
        local init = wep.Horde_ModifiersTable[modifier]["init"]
        wep.Horde_ModifiersTable[modifier] = table.Copy(multtable) or {}
        wep.Horde_ModifiersTable[modifier]["init"] = init
        CalculateTotalMult(wep, modifier)
    end
end

if SERVER then
    hook.Add("WeaponEquip", "Horde_ModifiersLoad", function(wep)
        timer.Simple(0, function()
            HORDE:LoadToWeaponModifier(wep)
        end)
    end)
    util.AddNetworkString("Horde_wepModifierApply")
else
    net.Receive("Horde_wepModifierApply", function()
        local loadtowep = net.ReadBool()
        if loadtowep then
            local wep = net.ReadEntity()
            timer.Simple(0.01, function()
                if !IsValid(wep) then
                    return
                end
                HORDE:LoadToWeaponModifier(wep)
            end)
        else
            local ply = MySelf
            local modifier = net.ReadString()
            local primarykey = net.ReadString()
            local need_to_delete = net.ReadBool()
            local mult
            if !need_to_delete then
                mult = net.ReadFloat()
            end
            HORDE:Modifier_AddToWeapons(ply, modifier, primarykey, mult)
        end
    end)
end