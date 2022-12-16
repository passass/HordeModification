SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_horde_mediccrossbow")
    killicon.Add("arccw_horde_mediccrossbow", "arccw/weaponicons/arccw_horde_mediccrossbow", Color(0, 0, 0, 255))
end
SWEP.PrintName = "Crusader's Crossbow"

SWEP.Slot = 1

SWEP.UseHands = false

SWEP.ViewModel		= "models/weapons/red/medic/v_syringegun_red.mdl"
SWEP.WorldModel		= "models/weapons/c_models/c_syringegun/c_syringegun.mdl"
SWEP.ViewModelFOV = 60

SWEP.ActivePos = Vector(1, 6, -.5)
SWEP.ActiveAng = Angle(0, 0, 0)
SWEP.ForceDefaultAmmo = 20
SWEP.HolsterPos = Vector(4.8, 6, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)
function SWEP:Hook_ModifyBodygroups(data)
    local vm = data.vm
    if vm and IsValid(vm) then
        vm:SetBodygroup(1, 3)
    end
end

SWEP.Syringe_Damage = 100
SWEP.Syringe_Heal = 50
SWEP.ClipsPerAmmoBox = 5

SWEP.Damage = 15
--[[SWEP.DamageMin = 75 -- damage done at maximum range
SWEP.Range = 90 -- in METRES
SWEP.Penetration = 11]]
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = "horde_syringe_proj" -- entity to fire, if any
SWEP.MuzzleVelocity = 4000 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.CanFireUnderwater = true
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 1 -- DefaultClip is automatically set.

SWEP.Horde_MaxMags = 75

SWEP.Recoil = .2
SWEP.RecoilSide = .4
SWEP.RecoilRise = 1.5

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
	name = "ammo_syringe_2",
} )
SWEP.Primary.Ammo = "ammo_syringe_2" -- what ammo type the gun uses



SWEP.ShootVol = 100 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootSound = "weapons/crusaders_crossbow_shoot.wav"

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
        --MinProgress = 1.25, ForceEnd = true,
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