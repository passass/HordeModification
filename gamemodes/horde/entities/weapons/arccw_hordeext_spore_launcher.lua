if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID( "vgui/hud/horde_spore_launcher" )
    killicon.Add( "arccw_hordeext_spore_launcher", "vgui/hud/horde_spore_launcher", Color( 255, 255, 255, 255 ) )
end
SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "Arccw - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Spore Launcher"

SWEP.Slot = 5

SWEP.UseHands = false

SWEP.ViewModelFOV = 85
SWEP.ViewModel = "models/horde/weapons/v_spore_launcher.mdl"
SWEP.WorldModel = "models/horde/weapons/w_spore_launcher.mdl"
--[[SWEP.WorldModelOffset = {
    pos = Vector(-20, 10, -10),
    ang = Angle(0, 0, 180),
    scale = 1
}]]

SWEP.DefaultBodygroups = "000000000000"

SWEP.Damage = 8
SWEP.Num = 1
SWEP.ShootEntityAlt = "horde_spore_alt"
SWEP.ShootEntity = "horde_spore" -- entity to fire, if any
SWEP.MuzzleVelocity = 1750
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 5 -- DefaultClip is automatically set.

SWEP.PhysBulletMuzzleVelocity = 350

SWEP.Recoil = 0.25
SWEP.RecoilSide = 0
SWEP.RecoilRise = 0
SWEP.RecoilPunch = 0
SWEP.Horde_MaxMags = 30
SWEP.ShotgunReload = true
SWEP.Delay = .5 -- 60 / RPM.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_shotgun"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 45 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 75 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 25

SWEP.Primary.Ammo = "Gravity" -- what ammo type the gun uses

SWEP.ShootSound = Sound( "Weapon_HLOF_Spore_Launcher.Single" )
SWEP.ShootSound_Alt = Sound( "Weapon_HLOF_Spore_launcher.Double" )

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.75
SWEP.SightTime = 0.30

SWEP.IronSightStruct = false

SWEP.Holdtype = "shotgun"
SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "shotgun"
SWEP.HoldtypeSights = "shotgun"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN

SWEP.CrouchPos = Vector(-4, 0, -1)
SWEP.CrouchAng = Angle(0, 0, -10)

SWEP.HolsterPos = Vector(3, -1, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.CustomizePos = Vector(8, 0, 1)
SWEP.CustomizeAng = Angle(5, 30, 30)

SWEP.BarrelLength = 24

SWEP.ExtraSightDist = 10
SWEP.GuaranteeLaser = true

SWEP.Attachments = {
    {
        PrintName = "Perk",
        Slot = "perk"
    },
}

SWEP.Is_Alt_Attack = false

function SWEP:SecondaryAttack()
    self:SetBurstCount(0)
    if !self:CanPrimaryAttack() then return end
    self.Secondary.Automatic = true
    self.Is_Alt_Attack = true
    self:PrimaryAttack()
end

function SWEP:Hook_GetShootSound(fsound)
    if self.Is_Alt_Attack then
        return self.ShootSound_Alt
    end
end

function SWEP:FireRocket(ent, vel, ang, dontinheritvel)
    if CLIENT then return end
    local rocket = ents.Create(self.Is_Alt_Attack and self.ShootEntityAlt or ent)

    ang = ang or (self:GetOwner():EyeAngles() + self:GetFreeAimOffset())

    local src = self:GetShootSrc()

    if !rocket:IsValid() then print("!!! INVALID ROUND " .. ent) return end

    local rocketAng = Angle(ang.p, ang.y, ang.r)
    if ang and self.ShootEntityAngleCorrection then
        local up = ang:Up()
        local right = ang:Right()
        local forward = ang:Forward()
        rocketAng:RotateAroundAxis(up, self.ShootEntityAngleCorrection.y)
        rocketAng:RotateAroundAxis(right, self.ShootEntityAngleCorrection.p)
        rocketAng:RotateAroundAxis(forward, self.ShootEntityAngleCorrection.r)
    end

    rocket:SetAngles(rocketAng)
    rocket:SetPos(src)

    rocket:SetOwner(self:GetOwner())

    rocket.Inflictor = self

    local randfactor = self:GetBuff("DamageRand")
    local mul = 1
    if randfactor > 0 then
        mul = mul * math.Rand(1 - randfactor, 1 + randfactor)
    end
    rocket.Damage = self:GetBuff("Damage") * mul

    if self.BlastRadius then
        local r_randfactor = self:GetBuff("DamageRand")
        local r_mul = 1
        if r_randfactor > 0 then
            r_mul = r_mul * math.Rand(1 - r_randfactor, 1 + r_randfactor)
        end
        rocket.BlastRadius = self:GetBuff("BlastRadius") * r_mul
    end

    local RealVelocity = (!dontinheritvel and self:GetOwner():GetAbsVelocity() or Vector(0, 0, 0)) + ang:Forward() * (!self.Is_Alt_Attack and vel or 1000)
    rocket.CurVel = RealVelocity -- for non-physical projectiles that move themselves

    rocket:Spawn()
    --rocket:Activate()
    local phys = rocket:GetPhysicsObject()
    if !rocket.NoPhys and phys:IsValid() then
        rocket:SetCollisionGroup(rocket.CollisionGroup or COLLISION_GROUP_DEBRIS)
        phys:SetVelocityInstantaneous(RealVelocity)
        if !self.Is_Alt_Attack then
            phys:SetMass( 1 )
            phys:EnableGravity( false )
        end
    end

    if rocket.Launch and rocket.SetState then
        rocket:SetState(1)
        rocket:Launch()
    end

    if rocket.ArcCW_Killable == nil then
        rocket.ArcCW_Killable = true
    end

    rocket.ArcCWProjectile = true

    self:GetBuff_Hook("Hook_PostFireRocket", rocket)

    return rocket
end

function SWEP:Hook_PostFireBullets()
    self.Is_Alt_Attack = false
end

SWEP.Animations = {
    ["idle"] = {
        Source = {"idle", "idle2"},
    },
    ["draw"] = {
        Source = "draw1",
    },
    ["fire"] = {
        Source = "fire",
    },
    ["sgreload_start"] = {
        Source = "reload_reach",
        Mult = 1 / 1.5,
    },
    ["sgreload_insert"] = {
        Source = "reload_load",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        TPAnimStartTime = 0.3,
        SoundTable = {
            {s = "Weapon_HLOF_Spore_Launcher.Reload", t = 0},
        },
        Mult = 1 / 1.5,
        --Time = 0.5,
    },
    ["sgreload_finish"] = {
        Source = "reload_aim",
        Mult = 1 / 1.5,
    },
    ["sgreload_finish_empty"] = {
        Source = "reload_aim",
        Mult = 1 / 1.5,
    },
}