if engine.ActiveGamemode() != "horde" then att.Ignore = true return end
att.PrintName = "M203 (MN)"
att.Icon = Material("entities/acwatt_ubgl_m203.png")
att.Description = "American-made underbarrel grenade launcher. Fires high explosive shells."
att.Desc_Pros = {
    "pro.ubgl",
}
att.Desc_Cons = {
}
att.Desc_Neutrals = {
    "info.toggleubgl"
}
att.AutoStats = true
att.Slot = "ubgl"

att.LHIK = true
att.LHIK_Animation = true

att.ModelOffset = Vector(0, 0, 0.25)

att.MountPositionOverride = 0

att.Model = "models/weapons/arccw/atts/ubgl_m203.mdl"

att.UBGL = true

game.AddAmmoType( {
    name = "Horde_Medic_UBNade",
} )

att.UBGL_PrintName = "Medic Nade"
att.UBGL_Automatic = false
att.UBGL_MuzzleEffect = "muzzleflash_m79"
att.UBGL_ClipSize = 1
att.UBGL_Ammo = "Horde_Medic_UBNade"
att.UBGL_RPM = 300
att.UBGL_Recoil = 2.5
att.UBGL_Capacity = 1

local function Ammo(wep)
    return wep.Owner:GetAmmoCount("Horde_Medic_UBNade")
end

att.Hook_LHIK_TranslateAnimation = function(wep, key)
    if key == "idle" then
        if wep:GetInUBGL() then
            return "idle_ready"
        else
            return "idle"
        end
    end
end

att.UBGL_Fire = function(wep, ubgl)
    if wep:Clip2() <= 0 then return end

    wep:DoLHIKAnimation("fire", 0.5)

    wep:FireRocket("arccw_horde_medic_nade", 30000)

    wep:EmitSound("weapons/grenade_launcher1.wav", 100)

    wep:SetClip2(wep:Clip2() - 1)

    wep:DoEffects()
end

att.UBGL_Reload = function(wep, ubgl)
    if wep:Clip2() >= 1 then return end

    if Ammo(wep) <= 0 then return end

    wep:SetNextSecondaryFire(CurTime() + 2.5)

    wep:DoLHIKAnimation("reload", 2.5)
    wep:PlaySoundTable({
        {s = "weapons/arccw/m203/m203_dooropen.wav", t = 0.25},
        {s = "weapons/arccw/m203/m203_shellin.wav", t = 1.25},
        {s = "weapons/arccw/m203/m203_doorclose.wav", t = 2},
    })

    local reserve = Ammo(wep)

    reserve = reserve + wep:Clip2()

    local clip = 1

    local load = math.Clamp(clip, 0, reserve)

    wep.Owner:SetAmmo(reserve - load, "Horde_Medic_UBNade")

    wep:SetClip2(load)
end

att.Mult_SightTime = 1.25
att.Mult_SpeedMult = 0.8
att.Mult_SightedSpeedMult = 0.85