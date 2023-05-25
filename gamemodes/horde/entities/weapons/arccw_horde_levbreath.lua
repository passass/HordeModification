SWEP.Base = "arccw_horde_bowbase"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false
SWEP.PrintName = "Leviathan's Breath"

SWEP.Slot = 2

SWEP.UseHands = true
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/killicons/destiny_leviathans_breath.vtf")
    killicon.Add("arccw_horde_levbreath", "vgui/killicons/destiny_leviathans_breath", Color(255, 255, 255, 255))
end

SWEP.ViewModel						= "models/weapons/LeviathansBreath/c_Leviathans_Breath.mdl"
SWEP.WorldModel			        = "models/weapons/LeviathansBreath/c_Leviathans_Breath.mdl"
SWEP.MirrorVMWM = false
SWEP.WorldModelOffset = {
    pos        =    Vector(-20, 7.5, -3.8),--Vector(-2.5, 4.25, -5.65),
    ang        =    Angle(0, 0, 90),--Angle(-5, -0.25, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
    scale   =   0.899,
    bodygroup = { [1] = 0 }
}
SWEP.ViewModelFOV = 60

SWEP.Damage = 65
SWEP.DamageMin = 155 -- damage done at maximum range
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
SWEP.Primary.ClipSize = 1 -- DefaultClip is automatically set.
SWEP.Horde_MaxMags = 50
SWEP.Recoil = 0.2
SWEP.RecoilSide = 0.2
SWEP.RecoilRise = 0.75
SWEP.VisualRecoilMult = 1

SWEP.Delay = 60 / 950 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
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
SWEP.HipDispersion = 2 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 15
game.AddAmmoType( {
	name = "ammo_lev_breath",
	dmgtype = DMG_BLAST,
} )
SWEP.Primary.Ammo = "ammo_lev_breath" -- what ammo type the gun uses
SWEP.MagID = "levbreath" -- the magazine pool this gun draws from

SWEP.ShootSound = Sound ("TFA_LEVIATHANSBREATH_FIRE.1")

SWEP.MuzzleEffect = "muzzleflash_4"
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellPitch = 90
SWEP.ShellScale = 1.5
SWEP.Horde_MaxMags = 30

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on
--[[SWEP.ProceduralViewBobAttachment = 1
SWEP.CamAttachment = 3]]

SWEP.SpeedMult = 1
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
    Pos = Vector(-1.5, -5, -.5),
    Ang = Angle(0.5, 0, 0),
    Magnification = 1.1,
    CrosshairInSights = true,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "smg"
SWEP.HoldtypeSights = "smg"

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
    { --1
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        Slot = {"optic", "optic_lp"}, -- what kind of attachments can fit here, can be string or table
        Bone = "A_Optic",
        
        VMScale = Vector(1.25, 1.25, 1.25),
        Offset = {
            vpos = Vector(0, 0, 3.6), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, 90),
            wpos = Vector(6, 0, -5),
            wang = Angle(-10, 180, 180),
        },
    },
    { --4
        PrintName = "Underbarrel",
        Slot = {"foregrip"},
        Bone = "A_LaserFlashlight",
        Offset = {
            vpos = Vector(.5, 0, 0),
            vang = Angle(0, 0, 180),
            wpos = Vector(13, 0, -5),
            wang = Angle(170, 180, 0)
        },
    },
    { --7
        PrintName = "Tactical",
        Slot = {"tac"},
        Bone = "A_LaserFlashlight",
        Offset = {
            vpos = Vector(4.6, 0, 0), -- offset that the attachment will be relative to the bone
            vang = Angle(0, 0, 90),
            wpos = Vector(23, 1.42, -7.5),
            wang = Angle(-10, 0, 90)
        },
    },
    { --12
        PrintName = "Perk",
        Slot = {"bo1_perk", "bo1_perk_wolfmg"},
    },
    { --13
        PrintName = "Charm",
        Slot = "charm",
        FreeSlot = true,
        Bone = "tag_weapon",
        Offset = {
            vpos = Vector(2, -0.75, 2), -- offset that the attachment will be relative to the bone
            vang = Angle(0, 0, 0),
            wpos = Vector(6.25, 1.9, -3),
            wang = Angle(-7.5, 0, 180)
        },
    },
}

SWEP.TriggerDelay = 1 -- Set to true to play the "trigger" animation before firing. Delay time is dependent on animation time.
SWEP.TriggerCharge = true -- If TriggerDelay is set, holding trigger will charge and releasing it fires. Also allows premature release of trigger.
SWEP.TriggerPullWhenEmpty = true -- If true, can pull the trigger even if no ammo is left.

SWEP.Animations = {
    ["draw"] = {
        Source = "draw",
    },
    ["holster"] = {
        Source = "base_holster",
    },
    ["reload"] = {
        Source = "reload"
    },
    ["reload_empty"] = {
        Source = "reload"
    },
    ["fire"] = {
        Source = "fire_1",
    },
    ["fire_iron"] = {
        Source = "fire_1_iron",
    },
    ["charging"] = {
        Source = "drawarrow",
        SoundTable = {
            {t = 0, s = Sound ("TFA_LEVIATHANSBREATH_DRAW.1")},
        },
    }
}

-- lev breath

SWEP.Charge_Sounds_HasUnchargedSound = true
SWEP.Charge_ReloadAfter_Timer = 1.2
SWEP.Charge_Speed = 1.4
SWEP.Charge_Sounds_UnchargedSound = Sound ("TFA_LEVIATHANSBREATH_DRYFIRE.1")

SWEP.BowChargeMat = Material("models/LeviathansBreath/LeviathansBreathcharge")

function SWEP:Hook_Charge_Think()
    local charge_progress = self:Charge_Progress()

    local remap = math.Remap(charge_progress, 0, 1, 0, -0.3)
    self.BowChargeMat:SetVector("$translate", Vector(remap, 0, 0))
    self.BowChargeMat:SetVector("$color2", LerpVector(charge_progress, Vector(1, 0, 0), Vector(0.5, 1, 0.5)))
end

function SWEP:Hook_PostBulletHit(bullet)
    if CLIENT then return end
    if bullet.tr and bullet.tr.HitSky or !bullet.dmg then return end
    if self:GetNWFloat("Charge_End") < 0.9 then return end
    local attacker = bullet.dmg:GetAttacker()
    local blast = ents.Create("horde_leviathans_breath_blast")
    blast:SetOwner(attacker)
    blast:SetPos(bullet.tr.HitPos)
    blast:SetAngles(attacker:EyeAngles())
    blast:Spawn()
end