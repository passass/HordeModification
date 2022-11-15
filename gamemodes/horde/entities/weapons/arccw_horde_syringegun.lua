SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_horde_syringegun")
    killicon.Add("arccw_horde_syringegun", "arccw/weaponicons/arccw_horde_syringegun", Color(0, 0, 0, 255))
end
SWEP.PrintName = "Syringe Gun"
--[[SWEP.Trivia_Class = "Pistol"
SWEP.Trivia_Desc = ".40 Caliber semi automatic pistol. Commonly used among police and popular with civilians for its reliability."
SWEP.Trivia_Manufacturer = "Auschen Waffenfabrik"
SWEP.Trivia_Calibre = ".40 S&W"
SWEP.Trivia_Mechanism = "Short Recoil"
SWEP.Trivia_Country = "Austria"
SWEP.Trivia_Year = 1993]]

SWEP.Slot = 1

SWEP.UseHands = false
--[[
CustomizableWeaponry:addFireSound("CW_SYRINGE_FIRE", "weapons/syringegun_shoot.wav", 1, 100, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_SYRINGEPROTO_FIRE", "weapons/tf_medic_syringe_overdose.wav", 1, 100, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_SYRINGECROSSBOW_FIRE", "weapons/crusaders_crossbow_shoot.wav", 1, 100, CHAN_STATIC)

CustomizableWeaponry:addReloadSound("CW_SYRINGE_AIR1", "weapons/syringegun_reload_air1.wav")
CustomizableWeaponry:addReloadSound("CW_SYRINGE_AIR2", "weapons/syringegun_reload_air2.wav")
CustomizableWeaponry:addReloadSound("CW_SYRINGE_GLASS", "weapons/syringegun_reload_glass2.wav", 1, 100, CHAN_STATIC)]]

SWEP.ViewModel		= "models/weapons/red/medic/v_syringegun_red.mdl"
SWEP.WorldModel		= "models/weapons/c_models/c_syringegun/c_syringegun.mdl"
SWEP.ViewModelFOV = 60

SWEP.ActivePos = Vector(1, 6, -.5)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(4.8, 6, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.Damage = 15
==[[SWEP.DamageMin = 75 -- damage done at maximum range
SWEP.Range = 90 -- in METRES
SWEP.Penetration = 11]]
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = "horde_syringe_proj" -- entity to fire, if any
SWEP.MuzzleVelocity = 1000 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.CanFireUnderwater = true
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 40 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 30
SWEP.ReducedClipSize = 10

SWEP.Horde_MaxMags = 6

SWEP.Recoil = .1
SWEP.RecoilSide = .25
SWEP.RecoilRise = 1

SWEP.Delay = 0.13 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_pistol"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 5 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 180 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 350
game.AddAmmoType( {
	name = "ammo_syringe",
} )
SWEP.Primary.Ammo = "ammo_syringe" -- what ammo type the gun uses



SWEP.ShootVol = 100 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootSound = "weapons/syringegun_shoot.wav"

--[[SWEP.MuzzleEffect = "muzzleflash_ak47"
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellPitch = 90
SWEP.ShellScale = 1.5
SWEP.ShellRotateAngle = Angle(0, 180, 0)]]

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

--SWEP.SightTime = 0.4

SWEP.SpeedMult = 1
--SWEP.SightedSpeedMult = 0.75

SWEP.BarrelLength = 14

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = false

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.ExtraSightDist = 7

SWEP.WorldModelOffset = {
    pos = Vector(13, 1, 2),
    ang = Angle( 0, 0, 180 ),
}

SWEP.Attachments = {
    {
        PrintName = "Perk",
        Slot = "perk"
    },
}

--[[CustomizableWeaponry:addFireSound("CW_SYRINGE_FIRE", "weapons/syringegun_shoot.wav", 1, 100, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_SYRINGEPROTO_FIRE", "weapons/tf_medic_syringe_overdose.wav", 1, 100, CHAN_STATIC)
CustomizableWeaponry:addFireSound("CW_SYRINGECROSSBOW_FIRE", "weapons/crusaders_crossbow_shoot.wav", 1, 100, CHAN_STATIC)

CustomizableWeaponry:addReloadSound("CW_SYRINGE_AIR1", "weapons/syringegun_reload_air1.wav")
CustomizableWeaponry:addReloadSound("CW_SYRINGE_AIR2", "weapons/syringegun_reload_air2.wav")
CustomizableWeaponry:addReloadSound("CW_SYRINGE_GLASS", "weapons/syringegun_reload_glass2.wav", 1, 100, CHAN_STATIC)]]

SWEP.Animations = {
    ["idle"] = {
        Source = "sg_idle",
    },
    ["ready"] = {
        Source = "sg_draw",
		--[[SoundTable = {
			{s = "weapons/draw_primary.wav", t = 0},
		},]]
    },
    ["draw"] = {
        Source = "sg_draw",
		--[[SoundTable = {
			{s = "weapons/draw_primary.wav", t = 0},
		},]]
    },
    ["fire"] = {
		Source = "sg_fire",
	},
    ["reload"] = {
        --MinProgress = 1.4, ForceEnd = true,
        Source = "sg_reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
		SoundTable = {
			--[[{s = "weapons/syringegun_reload_air1.wav", 	t = .2},
			{s = "weapons/syringegun_reload_glass2.wav", 	t = .5},
			{s = "weapons/syringegun_reload_air2.wav", 	t = .6},]]
		},
    },
    --[[["reload_empty"] = {
        MinProgress = 2.75,
        Source = "reload_empty", ForceEnd = true,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = .4, LHIKEaseIn = 1,
        LHIKOut = .7, LHIKEaseOut = .35,
    },
    ["holster"] = {
		Source = "holster",
	},--]]
}