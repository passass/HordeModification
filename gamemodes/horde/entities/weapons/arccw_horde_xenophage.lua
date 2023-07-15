SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Xenophage"

game.AddParticles( "particles/xenophage_muzzle.pcf" )
PrecacheParticleSystem( "Xenophage_muzzle" )
PrecacheParticleSystem( "Xenophage_muzzle_Glow" )

SWEP.Slot = 3

SWEP.UseHands = true
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/killicons/destiny_xenophage.vtf")
    killicon.Add("arccw_horde_xenophage", "vgui/killicons/destiny_xenophage", Color(255, 255, 255, 255))
end

SWEP.ViewModel			        = "models/weapons/c_xenophage.mdl"
SWEP.WorldModel			        = SWEP.ViewModel
SWEP.MirrorVMWM = false
SWEP.WorldModelOffset = {
    pos        =    Vector(-14, 8, -4.5),--Vector(-2.5, 4.25, -5.65),
    ang        =    Angle(-12.5, 1, 180),--Angle(-5, -0.25, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
    scale   =   0.899,
    bodygroup = { [1] = 0 }
}
SWEP.ViewModelFOV = 60

SWEP.Damage = 120
SWEP.DamageMin = 100 -- damage done at maximum range
SWEP.RangeMin = 150
SWEP.Range = 250 -- in METRES
SWEP.Penetration = 10
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 690 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3

SWEP.ChamberSize = 0-- how many rounds can be chambered.
SWEP.Primary.ClipSize = 13 -- DefaultClip is automatically set.

SWEP.Recoil = 0.6
SWEP.RecoilSide = 0.5
SWEP.RecoilRise = 0.65
SWEP.VisualRecoilMult = 1

SWEP.Delay = 60 / 120 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = {
    "weapon_smg1",
    "weapon_ar2",
}
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 2 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 750 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 300

game.AddAmmoType( {
	name = "ammo_xenophage",
	dmgtype = DMG_BLAST,
} )
SWEP.Primary.Ammo					= "ammo_xenophage"
SWEP.MagID = "xenophage" -- the magazine pool this gun draws from

SWEP.ShootSound = Sound ("TFA_XENOPHAGE_FIRE.1")

SWEP.MuzzleEffect = "muzzleflash_4"
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellPitch = 90
SWEP.ShellScale = 1.5
SWEP.Horde_MaxMags = 11

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on
--[[SWEP.ProceduralViewBobAttachment = 1
SWEP.CamAttachment = 3]]

SWEP.SpeedMult = .875
SWEP.SightedSpeedMult = 0.5
SWEP.SightTime = 0.33

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-7.3, -16, -1),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
    CrosshairInSights = false,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(0, -2, -1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.SprintPos = Vector(3, 3, 0)
SWEP.SprintAng = Angle(-7.036, 30.016, 0)

SWEP.CustomizePos = Vector(16, -3, -2)
SWEP.CustomizeAng = Angle(15, 40, 30)

SWEP.HolsterPos = Vector(8, -3, -1)
SWEP.HolsterAng = Angle(-7.036, 40.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 27

SWEP.ExtraSightDist = 5

SWEP.Attachments = {
    {
        PrintName = "Perk",
        Slot = "perk",
    },
}

function SWEP:DoEffects(att)
    if !game.SinglePlayer() and !IsFirstTimePredicted() then return end

    local ed = EffectData()
    ed:SetStart(self:GetShootSrc())
    ed:SetOrigin(self:GetShootSrc())
    ed:SetScale(1)
    ed:SetEntity(self)
    ed:SetAttachment(att or self:GetBuff_Override("Override_MuzzleEffectAttachment") or self.MuzzleEffectAttachment or 1)

    local efov = {}
    efov.eff = "arccw_horde_twomuzzleeffects"
    efov.fx  = ed

    if self:GetBuff_Hook("Hook_PreDoEffects", efov) == true then return end

    util.Effect("arccw_horde_twomuzzleeffects", ed)
end

function SWEP:Hook_PreDoEffects(efov)
    local ed = efov.fx
    util.Effect("arccw_horde_twomuzzleeffects", ed)
    return true
end

SWEP.MuzzleEffect_first = "tfa_muzzle_sniper"
SWEP.MuzzleEffect_second = "Xenophage_muzzle"

function SWEP:Hook_PostBulletHit(bul)
	if SERVER then
		self:DoXENEffect( bul.tr )
	end
end

SWEP.ExplosiveDamage = 160

function SWEP:DoXENEffect( tr )

	if ( tr.HitSky ) then return end
	ParticleEffect("hl2mmod_muzzleflash_rpg", tr.HitPos, Angle(-90, 0, 0), self)
    util.BlastDamage(self.Owner, self.Owner, tr.HitPos, 135, self.ExplosiveDamage)

end

SWEP.ImpactEffect = "hl2mmod_muzzleflash_rpg"

SWEP.Animations = {
    ["draw"] = {
        Source = "draw",
    },
    ["holster"] = {
        Source = "holster",
    },
    ["reload"] = {
        Source = "reload",
        SoundTable = {
            {t = 0, s = Sound ("TFA_XENOPHAGE_RELOAD.1")},
        },
        MinProgress = 4.55, ForceEnd = true, Mult=0.9,
    },
    ["reload_empty"] = {
        Source = "reload",
        SoundTable = {
            {t = 0, s = Sound ("TFA_XENOPHAGE_RELOAD.1")},
        },
        MinProgress = 4.55, ForceEnd = true, Mult=0.9,
    },
    ["fire"] = {
        Source = "shoot"
    },
    ["fire_iron"] = {
        Source = "shoot"
    },
}