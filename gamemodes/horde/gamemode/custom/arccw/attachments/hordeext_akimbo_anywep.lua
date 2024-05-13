att.PrintName = "G17"
att.Icon = Material("entities/acwatt_mw2_akimbo.png", "smooth")
att.Description = "Wholy."
att.Hidden = false
att.Desc_Pros = {
    "+100% more gun",
}
att.Desc_Cons = {
    "- Cannot use ironsights"
}
att.Desc_Neutrals = {
    "Don't toggle the UBGL"
}
att.AutoStats = true
att.Mult_HipDispersion = 4
att.Slot = "akimbotest"

att.GivesFlags = {"cantuseshitinakimboyet"}

att.SortOrder = 1738

att.MountPositionOverride = 0

att.Model = "models/weapons/arccw/fesiugmw2/akimbo/c_glock17_left_1.mdl"

att.LHIK = true
att.LHIK_Animation = true
att.LHIK_MovementMult = 0

att.UBGL = true

att.UBGL_PrintName = "AKIMBO"
att.UBGL_Automatic = false
att.UBGL_MuzzleEffect = "muzzleflash_4"
att.UBGL_ClipSize = 30
att.UBGL_Ammo = "pistol"
att.UBGL_RPM = 60 / 0.079
att.UBGL_Recoil = .4
att.UBGL_RecoilSide = .2
att.UBGL_RecoilRise = .2
att.UBGL_Capacity = 30
att.UBGL_Icon = Material("")
att.Hook_ShouldNotSight = function(wep)
    return true
end

local function Ammo(wep)
    return wep.Owner:GetAmmoCount(wep:GetPrimaryAmmoType()) -- att.UBGL_Ammo
end

att.Hook_Think = function(wep)
    if wep:GetMW2Masterkey_ShellInsertTime() < CurTime() and wep:GetMW2Masterkey_ShellInsertTime() != 0 then
        wep:SetMW2Masterkey_ShellInsertTime(0)
        local clip = wep:GetMaxClip1()
        if wep:Clip2() >= clip then return end
        if Ammo(wep) <= 0 then return end

        local reserve = Ammo(wep)
        reserve = reserve + wep:Clip2()
        local load = math.Clamp(clip, 0, reserve)
        wep.Owner:SetAmmo(reserve - load, wep:GetPrimaryAmmoType())
        wep:SetClip2(load)
    end

    if !IsFirstTimePredicted() then return end
    local owner = wep:GetOwner()
    local mode = wep:GetCurrentFiremode().Mode
    if owner:KeyPressed(IN_RELOAD) then
        wep:SetInUBGL(false)
        wep:ReloadUBGL()
    elseif owner:KeyPressed(IN_ATTACK) then
        wep:SetInUBGL(false)
    --[[elseif mode == 2 and owner:KeyDown(IN_ATTACK2) or owner:KeyPressed(IN_ATTACK2) then
        wep:SetInUBGL(true)
        wep:ShootUBGL()]]
    end
end

local awesomelist = {
    ["sprint_in_akimbo_right"] = {
        time = 10/30,
        anim = "sprint_in",
    },
    ["sprint_out_akimbo_right"] = {
        time = 10/30,
        anim = "sprint_out",
    },
    ["sprint_loop_akimbo_right"] = {
        time = 30/40,
        anim = "sprint_loop",
    },
    ["pullout_akimbo_right"] = {
        time = 26/30 /4,
        anim = "pullout",
    },
    ["putaway_akimbo_right"] = {
        time = 26/30 /4,
        anim = "putaway",
    },
}

att.Hook_TranslateSequence = function(wep, anim)
    if awesomelist[anim] then
        local bab = awesomelist[anim]
        wep:DoLHIKAnimation(bab.anim, bab.time)
    end
end

att.Hook_LHIK_TranslateAnimation = function(wep, anim)
    if anim == "idle" and wep:Clip2() <= 0 then
        return "idle_empty"
    end
end

att.UBGL_Fire = function(wep, ubgl)
    if wep:Clip2() <= 0 then return end
    local fm = wep:GetCurrentFiremode()

    local mode = fm.Mode

    if mode == 0 then return end

    -- this bitch
    local fixedcone = wep:GetDispersion() / 360 / 60
    local clip = wep:Clip1()
    local tracer = wep:GetBuff_Override("Override_Tracer", wep.Tracer)
    local tracernum = wep:GetBuff_Override("Override_TracerNum", wep.TracerNum)
    local lastout = wep:GetBuff_Override("Override_TracerFinalMag", wep.TracerFinalMag)
    if lastout >= clip then
        tracernum = 1
        tracer = wep:GetBuff_Override("Override_TracerFinal", wep.TracerFinal) or wep:GetBuff_Override("Override_Tracer", wep.Tracer)
    end

    wep:DoRecoil()

    if tracer == "arccw_tracer" then
        tracer = "arccw_tracer_timestop"
    end

    wep.Owner:FireBullets({
		Src = wep.Owner:EyePos(),
		Num = 1,
		Damage = 0,
		Force = 1,
		Attacker = wep.Owner,
		Dir = wep.Owner:EyeAngles():Forward(),
        --Src = wep:GetShootSrc(),
		Spread = Vector(fixedcone, fixedcone, 0),
        Weapon = wep,
        TracerName = tracer,
        Tracer = tracernum or 0,
		Callback = function(att, tr, dmg)
			ArcCW:BulletCallback(att, tr, dmg, wep)
		end
	})
    wep:DoShootSound()
                            -- This is kinda important
                                            -- Wep volume
                                                    -- Weapon pitch (along with the pitch randomizer)




    wep:SetClip2(wep:Clip2() - 1)
    
    if wep:Clip2() > 0 then
        wep:DoLHIKAnimation("fire", 6/30)
    else
        wep:DoLHIKAnimation("fire_last", 6/30)
    end

    wep:DoEffects()
end

att.UBGL_Reload = function(wep, ubgl)
    local clip = wep:GetMaxClip1()
    if wep:Clip2() >= clip then return end
    if Ammo(wep) <= 0 then return end

    wep:SetInUBGL(false)
    wep:Reload()
    local is_empty = wep:Clip2() <= 0
	local mult = wep:GetBuff_Mult("Mult_ReloadTime")
    local reloadtime
    local soundtable
    if is_empty then
        reloadtime = wep:GetAnimKeyTime("reload_empty_akimbo_right", true)

        soundtable = table.Copy(wep.LeftHand_ReloadSoundEmpty)
    else
        reloadtime = wep:GetAnimKeyTime("reload_akimbo_right", false)
        soundtable = table.Copy(wep.LeftHand_ReloadSound)
    end
    reloadtime = reloadtime * mult
    wep:DoLHIKAnimation(is_empty and "reload_empty" or "reload", reloadtime * mult)
    wep:SetNextSecondaryFire(CurTime() + reloadtime * mult)
    wep:SetMagUpIn(CurTime() + reloadtime * mult)
    wep:SetReloading(CurTime() + reloadtime * mult)
    for i, data in pairs(soundtable) do
        data.t = data.t * mult
    end
    wep:SetMW2Masterkey_ShellInsertTime(CurTime() + reloadtime * mult)
    wep:PlaySoundTable(soundtable)
end

att.Hook_GetHUDData = function( wep, data )
    if ArcCW:ShouldDrawHUDElement("CHudAmmo") then
        data.clip = wep:Clip2() .. " / " .. wep:Clip1()
    else
        if BoHU then
            data.clip = wep:Clip1()
        else
            data.clip = wep:Clip1() + wep:Clip2()
        end
    end
    data.ubgl = nil
    return data
end