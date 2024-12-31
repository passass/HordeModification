--local wepMeta = FindMetaTable("Weapon")
for i = 1, 20 do
    game.AddAmmoType({
        name = string.format("Horde_AmmoType_%s", i),
    })
end

local function TableIndexing(tbl)
    local tbl2 = {}
    for i, var in pairs(tbl) do
        tbl2[var] = i
    end
    return tbl2
end

local deny_ammo_type = {
    [""] = true,
    ["Grenade"] = true,
    ["ammo_starterweapon"] = true,
}

local function CanChangeAmmoType(wep)
    return wep.Primary and wep.Primary.Ammo and !deny_ammo_type[wep.Primary.Ammo]
end

local function CheckForWeaponsExists(plywep)
    local ply = plywep:GetOwner()
    for wep, i in pairs(ply.Horde_AmmoTypesTable or {}) do
        if !IsValid(wep) or !ply:HasWeapon(wep:GetClass()) then
            ply.Horde_AmmoTypesTable[wep] = nil
        end
    end
end

local function GetFreeAmmoNumber(wep)
    local ply = wep:GetOwner()
    local ammotbl = TableIndexing(ply.Horde_AmmoTypesTable or {})
    for i = 1, 21 do
        if !ammotbl[i] then
            return i
        end
    end
end

local function ChangeAmmoType(wep)
    if !IsValid(wep) or !CanChangeAmmoType(wep) then
        return false
    end

    if wep.Horde_AmmoType then
        wep.Primary.Ammo = wep.Horde_AmmoType
        return false
    end

    local ply = wep:GetOwner()

    if !ply.Horde_AmmoTypesTable then
        ply.Horde_AmmoTypesTable = {}
    end

    CheckForWeaponsExists(wep)

    local ammonumber = GetFreeAmmoNumber(wep)

    if ammonumber <= 20 then
        if !wep.Horde_OrigAmmoType then
            wep.Horde_OrigAmmoType = wep.Primary.Ammo
        end

        local ammotype = string.format("Horde_AmmoType_%s", ammonumber)
        wep.Primary.Ammo = ammotype
        wep.Horde_AmmoType = ammotype

        ply.Horde_AmmoTypesTable[wep] = ammonumber
        return true
    end

    return false
end

function HORDE:WeaponDeleteHordeAmmoType(wep)
    if wep.Horde_AmmoType then
        local ply = wep:GetOwner()

        ply.Horde_AmmoTypesTable[wep] = nil
        wep.Horde_AmmoType = nil
        wep.Primary.Ammo = wep.Horde_OrigAmmoType
        wep.Horde_OrigAmmoType = nil
    end
end

function HORDE:WeaponChangeAmmoType(wep)
    return ChangeAmmoType(wep)
end

if SERVER then
    util.AddNetworkString("Horde_SyncAmmoType")
    function HORDE:WeaponAmmoTypeSync(wep)
        local ply = wep:GetOwner()

        if !wep.Horde_AmmoType or !CanChangeAmmoType(wep) or !ply.Horde_AmmoTypesTable[wep] then
            return
        end

        net.Start("Horde_SyncAmmoType")
        net.WriteEntity(wep)
        net.WriteUInt(ply.Horde_AmmoTypesTable[wep], 5)
        net.Send(ply)
    end
else
    net.Receive("Horde_SyncAmmoType", function()
        local wep = net.ReadEntity()
        local ammonumber = net.ReadUInt(5)
        timer.Simple(0, function()
            if !IsValid(wep) then return end
            local ammotype = string.format("Horde_AmmoType_%s", ammonumber)
    
            if !wep.Horde_OrigAmmoType then
                wep.Horde_OrigAmmoType = wep.Primary.Ammo
            end
    
            wep.Primary.Ammo = ammotype
            wep.Horde_AmmoType = ammotype
    
            MySelf.Horde_AmmoTypesTable[wep] = ammonumber
        end)
    end)
end

--[[local ammosid = {

}

local oldammotype = wepMeta.GetPrimaryAmmoType
function wepMeta:GetPrimaryAmmoType()
	if wep.Horde_AmmoType then
        local ammoid = ammosid[wep.Horde_AmmoType]

        if !ammoid then
            ammoid = game.GetAmmoID(wep.Horde_AmmoType)
            ammosid[wep.Horde_AmmoType] = ammoid
        end

        return ammoid
    end

    return oldammotype(self)
end]]