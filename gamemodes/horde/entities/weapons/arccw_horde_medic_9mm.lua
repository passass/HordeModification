if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = Material("items/weapon_medic_9mm.png")
    killicon.AddAlias("arccw_horde_medic_9mm", "weapon_9mm")
end
SWEP.Base = "arccw_mw2_abase"
SWEP.Spawnable = true
SWEP.Category = "ArcCW - Horde"
SWEP.AdminOnly = false
SWEP.WeaponCamBone = tag_camera

SWEP.PrintName = "Medic 9mm (Horde)"
SWEP.Trivia_Class = "Pistol"
SWEP.Trivia_Desc = "Standard issue pistol."

SWEP.Trivia_Manufacturer = "Combine"
SWEP.Trivia_Calibre = "9mm"
SWEP.Trivia_Mechanism = "Semi-Auto"
SWEP.Trivia_Country = "Combine"
SWEP.Trivia_Year = 2007

SWEP.Slot = 1

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.MirrorVMWM = false
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV = 65

SWEP.Damage = 7
SWEP.DamageMin = 5
SWEP.RangeMin = 12.5
SWEP.Range = 31.25
SWEP.Penetration = 2
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any


SWEP.ChamberSize = 0
SWEP.Primary.ClipSize = 18 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 18
SWEP.ReducedClipSize = 18

SWEP.Recoil = 0.400
SWEP.RecoilSide = 0.125
SWEP.RecoilRise = 0.1
SWEP.RecoilPunch = 2.5

SWEP.Delay = 0.08 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = 0,
    }
}

SWEP.NPCWeaponType = {"weapon_ar2", "weapon_smg1"}
SWEP.NPCWeight = 150

SWEP.AccuracyMOA = 0 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 150 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150

SWEP.Primary.Ammo = "Pistol" -- what ammo type the gun uses

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound =			{"weapons/pistol/pistol_fire2.wav"}
--SWEP.DistantShootSound =	"weapons/fesiugmw2/fire_distant/anaconda.wav"
SWEP.ShootSoundSilenced =	"weapons/fesiugmw2/fire/usp45_sil.wav"

SWEP.MuzzleEffect = "muzzleflash_pistol"
SWEP.ShellModel = "models/shells/shell_9mm.mdl"
SWEP.ShellScale = 1

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.8
SWEP.SightTime = 0.125

SWEP.IronSightStruct = {
    Pos = Vector(-5.5, -10, 3.1),
    Ang = Angle(0, 0, 0),
    ViewModelFOV = 65,
    Magnification = 1,
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "pistol"
SWEP.HoldtypeSights = "pistol"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL

SWEP.ActivePos = Vector(0, 0, 1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CustomizePos = Vector(13.92, 1, -1.08)
SWEP.CustomizeAng = Angle(6.8, 37.7, 10.3)

SWEP.HolsterPos = Vector(3, 0, 0)
SWEP.HolsterAng = Angle(-10, 25, 0)

SWEP.SprintPos = Vector(0, 0, 1)
SWEP.SprintAng = Angle(0, 0, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 18

SWEP.ExtraSightDist = 5

-----[ Tactical knife sheet ]------
SWEP.CanBash				= true -- Tac knife will save us
--SWEP.MeleeDamage			= 100
--SWEP.MeleeRange				= 16
--SWEP.MeleeDamageType		= DMG_CLUB
--SWEP.MeleeTime				= 0.8
SWEP.MeleeGesture			= ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
--SWEP.MeleeAttackTime		= 0.079
SWEP.MeleeMissSound			= ""
SWEP.MeleeHitSound			= "MW2Common.Melee.HitWorld"
SWEP.MeleeHitNPCSound		= "MW2Common.Melee.HitFleshy_Slice"

SWEP.AttachmentElements = {
    ["rail"] = {
        VMElements = {
            {
                Model = "models/weapons/arccw_go/atts/pistol_rail.mdl",
                Bone = "v_weapon.223_Parent",
                Offset = {
                    pos = Vector(-0.05, -1.6, 6),
                    ang = Angle(90, 0, -90),
                },
                Scale = Vector(0.95, 0.95, 0.95)
            }
        },
        AttPosMods = {
            [2] = {
                vpos = Vector(-0.05, -1.2, 6),
            }
        }
    },
}

SWEP.Attachments = {
    {
        PrintName = "Ammo Type",
        Slot = "go_ammo",
        DefaultAttName = "Standard Ammo"
    },
    {
        PrintName = "Perk",
        Slot = {"go_perk", "go_perk_pistol"}
    },
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
        Time = 2/30,
        TPAnim = ACT_HL2MP_IDLE_PISTOL,
    },
    ["fire"] = {
        Source = "fire",
        Time = 12/30,
    },
    ["fire_iron"] = {
        Source = "fire",
        Time = 12/30,
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_REVOLVER,
        SoundTable = {
						{s = "weapons/pistol/pistol_reload1.wav", t = 0},
					},
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.6,
        LastClip1OutTime = 1.5,
    },
}

if HORDE then HORDE.Syringe:ApplyMedicSkills(SWEP, 10) end

function SWEP:DrawWeaponSelection(x, y, w, h, a)
    surface.SetDrawColor(255, 255, 255, a)
    surface.SetMaterial(self.WepSelectIcon)

    surface.DrawTexturedRect(x, y, w, w / 2)
end