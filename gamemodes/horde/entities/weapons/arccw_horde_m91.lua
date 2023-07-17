SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_horde_m91.vtf")
    killicon.Add("arccw_horde_m91", "arccw/weaponicons/arccw_horde_m91", Color(0, 0, 0, 255))
end
SWEP.PrintName = "M91"
--[[SWEP.Trivia_Class = "Pistol"
SWEP.Trivia_Desc = ".40 Caliber semi automatic pistol. Commonly used among police and popular with civilians for its reliability."
SWEP.Trivia_Manufacturer = "Auschen Waffenfabrik"
SWEP.Trivia_Calibre = ".40 S&W"
SWEP.Trivia_Mechanism = "Short Recoil"
SWEP.Trivia_Country = "Austria"
SWEP.Trivia_Year = 1993]]

SWEP.Slot = 1

SWEP.UseHands = true

SWEP.ViewModel				= "models/viper/mw/weapons/v_kilo121.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/viper/mw/weapons/w_kilo121.mdl"
SWEP.ViewModelFOV = 60


SWEP.Damage = 66
SWEP.DamageMin = 54 -- damage done at maximum range
SWEP.Range = 90 -- in METRES
SWEP.Penetration = 11
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 400 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.CanFireUnderwater = true
SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 175

SWEP.Recoil = .3
SWEP.RecoilSide = .45
SWEP.RecoilRise = .5
SWEP.VisualRecoilMult = 0.2

SWEP.RecoilPunch = 1
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 2

SWEP.Sway = 0.6

SWEP.Delay = 60 / 600 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 3,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_pistol"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 20 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 550 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150

SWEP.Primary.Ammo = "ar2" -- what ammo type the gun uses

SWEP.ShootVol = 100 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

sound.Add({
    name =            "Reflection_Shotgun.Inside",
    channel =        CHAN_WEAPON,
volume =      1.0,
    sound = {"viper/shared/reflection/shotgun/weap_refl_shotgun_urb/weap_refl_shotgun_urb_int_close_rear_01.ogg",
            "viper/shared/reflection/shotgun/weap_refl_shotgun_urb/weap_refl_shotgun_urb_int_close_rear_02.ogg",
            "viper/shared/reflection/shotgun/weap_refl_shotgun_urb/weap_refl_shotgun_urb_int_close_rear_03.ogg",
            "viper/shared/reflection/shotgun/weap_refl_shotgun_urb/weap_refl_shotgun_urb_int_close_rear_04.ogg",
            "viper/shared/reflection/shotgun/weap_refl_shotgun_urb/weap_refl_shotgun_urb_int_close_rear_05.ogg",
            "viper/shared/reflection/shotgun/weap_refl_shotgun_urb/weap_refl_shotgun_urb_int_close_rear_06.ogg",
            "viper/shared/reflection/shotgun/weap_refl_shotgun_urb/weap_refl_shotgun_urb_int_close_rear_07.ogg",
            "viper/shared/reflection/shotgun/weap_refl_shotgun_urb/weap_refl_shotgun_urb_int_close_rear_08.ogg"}
})

SWEP.ShootSound = Sound("Reflection_Shotgun.Inside")
SWEP.ShootSound2 = Sound("weap_kilo121_fire_plr")--Reflection_Shotgun.Inside")
SWEP.ShootSoundSilenced = Sound("weap_kilo121_sup_plr")

SWEP.ProceduralIronFire = true

function SWEP:Hook_AddShootSound(data)
    --if data.sound == self.ShootSound then
        self:MyEmitSound(self.ShootSound2, data.volume, data.pitch, 1, CHAN_WEAPON)
    --end
end

SWEP.MuzzleEffect = "muzzleflash_ak47"
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellPitch = 90
SWEP.ShellScale = 1.5
SWEP.ShellRotateAngle = Angle(0, 180, 0)
SWEP.SightTime = 0.4

SWEP.SpeedMult = .9
SWEP.SightedSpeedMult = 0.75

SWEP.BarrelLength = 18

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}
local CHAN_WPNFOLEY = 143
-- Sound: 8
sound.Add({
	name = "weap_kilo121_fire_plr",
	channel = CHAN_WEAPON,
	level = 140,
	volume = 1,
	pitch = {80,100},
	sound = {
		"weapons/kilo121/weap_kilo121_fire_plr_01.ogg",
		}
})
sound.Add({
	name = "weap_kilo121_sup_plr",
	channel = CHAN_WEAPON,
	level = 140,
	volume = 1,
	pitch = {80,100},
	sound = {
		"weapons/kilo121/weap_scharlie_sup_plr_01.ogg",
		}
})
-- Sound: 19
sound.Add({
	name = "wfoly_plr_lm_kilo121_drop_01",
	channel = CHAN_WPNFOLEY + 3,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_drop.ogg",
		}
})
-- Sound: 20
sound.Add({
	name = "wfoly_plr_lm_kilo121_drop_empty_01",
	channel = CHAN_WPNFOLEY + 4,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_drop_empty.ogg",
		}
})

sound.Add({
	name = "wfoly_plr_lm_kilo121_raise_first_01",
	channel = CHAN_WPNFOLEY + 1,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_raise_first_raise.ogg",
		}
})
sound.Add({
	name = "wfoly_plr_lm_kilo121_raise_first_02",
	channel = CHAN_WPNFOLEY + 2,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_raise_first_drop.ogg",
		}
})
sound.Add({
	name = "wfoly_plr_lm_kilo121_raise_first_03",
	channel = CHAN_WPNFOLEY + 3,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_raise_first_cloth02.ogg",
		}
})
sound.Add({
	name = "wfoly_plr_lm_kilo121_raise_first_04",
	channel = CHAN_WPNFOLEY + 4,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_raise_first_cloth01.ogg",
		}
})
sound.Add({
	name = "wfoly_plr_lm_kilo121_raise_first_05",
	channel = CHAN_WPNFOLEY + 5,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_raise_first_boltopen_01.ogg",
		}
})
sound.Add({
	name = "wfoly_plr_lm_kilo121_raise_first_06",
	channel = CHAN_WPNFOLEY + 6,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_raise_first_cloth02.ogg",
		}
})
sound.Add({
	name = "wfoly_plr_lm_kilo121_raise_first_07",
	channel = CHAN_WPNFOLEY + 7,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_raise_first_boltclose_01.ogg",
		}
})
sound.Add({
	name = "wfoly_plr_lm_kilo121_raise_first_08",
	channel = CHAN_WPNFOLEY + 8,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_raise_first_rattle.ogg",
		}
})
sound.Add({
	name = "wfoly_plr_lm_kilo121_raise_first_09",
	channel = CHAN_WPNFOLEY + 9,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_raise_first_end.ogg",
		}
})



-- Sound: 21
sound.Add({
	name = "wfoly_plr_lm_kilo121_drop_fast_01",
	channel = CHAN_WPNFOLEY + 5,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_drop_fast.ogg",
		}
})
-- Sound: 22
sound.Add({
	name = "wfoly_plr_lm_kilo121_hybrid_scope_side_off",
	channel = CHAN_WPNFOLEY + 6,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"foley/hybrid_scope/wfoly_plr_lm_kilo121_hybrid_side_off.ogg",
		}
})
-- Sound: 23
sound.Add({
	name = "wfoly_plr_lm_kilo121_hybrid_scope_side_on",
	channel = CHAN_WPNFOLEY + 7,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"foley/hybrid_scope/wfoly_plr_lm_kilo121_hybrid_side_on.ogg",
		}
})
-- Sound: 24
sound.Add({
	name = "wfoly_plr_lm_kilo121_hybrid_scope_snap_closed",
	channel = CHAN_WPNFOLEY + 8,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"foley/hybrid_scope/wfoly_plr_ar_falpha_hybrid_scope_snap_closed.ogg",
		}
})
-- Sound: 25
sound.Add({
	name = "wfoly_plr_lm_kilo121_hybrid_scope_snap_open",
	channel = CHAN_WPNFOLEY + 9,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"foley/hybrid_scope/wfoly_plr_ar_falpha_hybrid_scope_snap_open.ogg",
		}
})
-- Sound: 26
sound.Add({
	name = "wfoly_plr_lm_kilo121_hybrid_scope_top_in",
	channel = CHAN_WPNFOLEY + 10,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"foley/hybrid_scope/wfoly_plr_lm_kilo121_hybrid_top_in.ogg",
		}
})
-- Sound: 27
sound.Add({
	name = "wfoly_plr_lm_kilo121_hybrid_scope_top_out",
	channel = CHAN_WPNFOLEY + 1,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"foley/hybrid_scope/wfoly_plr_lm_kilo121_hybrid_top_out.ogg",
		}
})
-- Sound: 28
sound.Add({
	name = "wfoly_plr_lm_kilo121_inspect_01",
	channel = CHAN_WPNFOLEY + 2,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_inspect_01.ogg",
		}
})
-- Sound: 29
sound.Add({
	name = "wfoly_plr_lm_kilo121_inspect_02",
	channel = CHAN_WPNFOLEY + 3,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_inspect_02.ogg",
		}
})
-- Sound: 30
sound.Add({
	name = "wfoly_plr_lm_kilo121_inspect_03",
	channel = CHAN_WPNFOLEY + 4,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_inspect_03.ogg",
		}
})
-- Sound: 31
sound.Add({
	name = "wfoly_plr_lm_kilo121_raise_01",
	channel = CHAN_WPNFOLEY + 5,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_raise.ogg",
		}
})
-- Sound: 32
sound.Add({
	name = "wfoly_plr_lm_kilo121_raise_empty_01",
	channel = CHAN_WPNFOLEY + 6,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_raise_empty.ogg",
		}
})
-- Sound: 33
sound.Add({
	name = "wfoly_plr_lm_kilo121_raise_fast_01",
	channel = CHAN_WPNFOLEY + 7,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo98/wfoly_lm_kilo121_raise_fast.ogg",
		}
})
-- Sound: 38
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_01",
	channel = CHAN_WPNFOLEY + 2,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_raise.ogg",
		}
})
-- Sound: 39
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_02",
	channel = CHAN_WPNFOLEY + 3,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_boltopen_01.ogg",
		}
})
-- Sound: 40
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_03",
	channel = CHAN_WPNFOLEY + 4,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_lower.ogg",
		}
})
-- Sound: 41
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_04",
	channel = CHAN_WPNFOLEY + 5,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_boltclose_01.ogg",
		}
})
-- Sound: 42
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_05",
	channel = CHAN_WPNFOLEY + 6,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_coveropen_01.ogg",
		}
})
-- Sound: 43
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_06",
	channel = CHAN_WPNFOLEY + 7,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_magout_01.ogg",
		}
})
-- Sound: 44
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_07",
	channel = CHAN_WPNFOLEY + 8,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_boxmag.ogg",
		}
})
-- Sound: 45
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_08",
	channel = CHAN_WPNFOLEY + 9,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_magin_01.ogg",
		}
})
-- Sound: 46
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_09",
	channel = CHAN_WPNFOLEY + 10,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_click_01.ogg",
		}
})
-- Sound: 47
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_10",
	channel = CHAN_WPNFOLEY + 1,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_coverclose_01.ogg",
		}
})
-- Sound: 48
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_11",
	channel = CHAN_WPNFOLEY + 2,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_end.ogg",
		}
})
-- Sound: 49
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_01",
	channel = CHAN_WPNFOLEY + 3,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_lift.ogg",
		}
})
-- Sound: 50
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_02",
	channel = CHAN_WPNFOLEY + 4,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_raise_01.ogg",
		}
})
-- Sound: 51
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_03",
	channel = CHAN_WPNFOLEY + 5,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_boltopen_01.ogg",
		}
})
-- Sound: 52
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_04",
	channel = CHAN_WPNFOLEY + 6,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_boltclose_01.ogg",
		}
})
-- Sound: 53
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_05",
	channel = CHAN_WPNFOLEY + 7,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_lower.ogg",
		}
})
-- Sound: 54
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_06",
	channel = CHAN_WPNFOLEY + 8,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_mvmnt01.ogg",
		}
})
-- Sound: 55
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_07",
	channel = CHAN_WPNFOLEY + 9,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_coveropen_01.ogg",
		}
})
-- Sound: 56
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_08",
	channel = CHAN_WPNFOLEY + 10,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_clean.ogg",
		}
})
-- Sound: 57
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_09",
	channel = CHAN_WPNFOLEY + 1,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_inspect.ogg",
		}
})
-- Sound: 58
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_10",
	channel = CHAN_WPNFOLEY + 2,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_magout_01.ogg",
		}
})
-- Sound: 59
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_11",
	channel = CHAN_WPNFOLEY + 3,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_beltmvmnt.ogg",
		}
})
-- Sound: 60
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_12",
	channel = CHAN_WPNFOLEY + 4,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_boxmag.ogg",
		}
})
-- Sound: 61
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_13",
	channel = CHAN_WPNFOLEY + 5,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_magin_01.ogg",
		}
})
-- Sound: 62
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_14",
	channel = CHAN_WPNFOLEY + 6,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_mvmnt02.ogg",
		}
})
-- Sound: 63
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_15",
	channel = CHAN_WPNFOLEY + 7,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_click_01.ogg",
		}
})
-- Sound: 64
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_16",
	channel = CHAN_WPNFOLEY + 8,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_coverclose_01.ogg",
		}
})
-- Sound: 65
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_17",
	channel = CHAN_WPNFOLEY + 9,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_end.ogg",
		}
})
-- Sound: 66
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_fast_01",
	channel = CHAN_WPNFOLEY + 10,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_fast_rotate.ogg",
		}
})
-- Sound: 67
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_fast_02",
	channel = CHAN_WPNFOLEY + 1,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_fast_boltopen_01.ogg",
		}
})
-- Sound: 68
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_fast_03",
	channel = CHAN_WPNFOLEY + 2,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_fast_boltclose_01.ogg",
		}
})
-- Sound: 69
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_fast_04",
	channel = CHAN_WPNFOLEY + 3,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_fast_lower.ogg",
		}
})
-- Sound: 70
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_fast_05",
	channel = CHAN_WPNFOLEY + 4,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_fast_mvmnt01.ogg",
		}
})
-- Sound: 71
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_fast_06",
	channel = CHAN_WPNFOLEY + 5,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_fast_coveropen_01.ogg",
		}
})
-- Sound: 72
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_fast_07",
	channel = CHAN_WPNFOLEY + 6,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_fast_magout_01.ogg",
		}
})
-- Sound: 73
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_fast_08",
	channel = CHAN_WPNFOLEY + 7,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_fast_rattle.ogg",
		}
})
-- Sound: 74
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_fast_09",
	channel = CHAN_WPNFOLEY + 8,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_fast_boxmag.ogg",
		}
})
-- Sound: 75
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_fast_10",
	channel = CHAN_WPNFOLEY + 9,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_fast_magin_01.ogg",
		}
})
-- Sound: 76
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_fast_11",
	channel = CHAN_WPNFOLEY + 10,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_fast_mvmnt02.ogg",
		}
})
-- Sound: 77
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_fast_12",
	channel = CHAN_WPNFOLEY + 1,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_fast_clean.ogg",
		}
})
-- Sound: 78
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_fast_13",
	channel = CHAN_WPNFOLEY + 2,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_fast_close.ogg",
		}
})
-- Sound: 79
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_fast_14",
	channel = CHAN_WPNFOLEY + 3,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_fast_cloth.ogg",
		}
})
-- Sound: 80
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_empty_fast_15",
	channel = CHAN_WPNFOLEY + 4,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_empty_fast_end.ogg",
		}
})
-- Sound: 81
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_fast_01",
	channel = CHAN_WPNFOLEY + 5,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_fast_mvmnt.ogg",
		}
})
-- Sound: 82
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_fast_02",
	channel = CHAN_WPNFOLEY + 6,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_fast_boltopen_01.ogg",
		}
})
-- Sound: 83
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_fast_03",
	channel = CHAN_WPNFOLEY + 7,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_fast_boltclose_01.ogg",
		}
})
-- Sound: 84
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_fast_04",
	channel = CHAN_WPNFOLEY + 8,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_fast_coverrelease_01.ogg",
		}
})
-- Sound: 85
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_fast_05",
	channel = CHAN_WPNFOLEY + 9,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_fast_coveropen_01.ogg",
		}
})
-- Sound: 86
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_fast_06",
	channel = CHAN_WPNFOLEY + 10,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_fast_magout_01.ogg",
		}
})
-- Sound: 87
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_fast_07",
	channel = CHAN_WPNFOLEY + 1,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_fast_magin_01.ogg",
		}
})
-- Sound: 88
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_fast_08",
	channel = CHAN_WPNFOLEY + 2,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_fast_ammobelt_01.ogg",
		}
})
-- Sound: 89
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_fast_09",
	channel = CHAN_WPNFOLEY + 3,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_fast_cloth.ogg",
		}
})
-- Sound: 90
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_fast_10",
	channel = CHAN_WPNFOLEY + 4,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_fast_coverclose_01.ogg",
		}
})
-- Sound: 91
sound.Add({
	name = "wfoly_plr_lm_kilo121_reload_fast_11",
	channel = CHAN_WPNFOLEY + 5,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_kilo121/wfoly_lm_kilo121_reload_fast_end.ogg",
		}
})


sound.Add({
    name =            "Reflection_Shotgun.Inside",
    channel =        CHAN_REFLECTION,
    volume =      1.0,
    sound = {"viper/shared/reflection/shotgun/weap_refl_shotgun_urb/weap_refl_shotgun_urb_int_close_rear_01.ogg",
            "viper/shared/reflection/shotgun/weap_refl_shotgun_urb/weap_refl_shotgun_urb_int_close_rear_02.ogg",
            "viper/shared/reflection/shotgun/weap_refl_shotgun_urb/weap_refl_shotgun_urb_int_close_rear_03.ogg",
            "viper/shared/reflection/shotgun/weap_refl_shotgun_urb/weap_refl_shotgun_urb_int_close_rear_04.ogg",
            "viper/shared/reflection/shotgun/weap_refl_shotgun_urb/weap_refl_shotgun_urb_int_close_rear_05.ogg",
            "viper/shared/reflection/shotgun/weap_refl_shotgun_urb/weap_refl_shotgun_urb_int_close_rear_06.ogg",
            "viper/shared/reflection/shotgun/weap_refl_shotgun_urb/weap_refl_shotgun_urb_int_close_rear_07.ogg",
            "viper/shared/reflection/shotgun/weap_refl_shotgun_urb/weap_refl_shotgun_urb_int_close_rear_08.ogg"}
})

SWEP.ProceduralRegularFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-4.06, -12.726683 + 15, .75),
    Ang = Angle(-0.020, -0, -3),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 3 -- which attachment to put the case effect on
--SWEP.ProceduralViewBobAttachment = 1
SWEP.CamAttachment = 3

if CLIENT then
	local cd = 0

    function SWEP:PrePostDrawViewModel()
		local ct = CurTime()
        if cd < ct then
			cd = ct + .12
			local cur_anim = wep.LastAnimKey
			if cur_anim == "idle" then
				local iron    = self:GetState() == ArcCW.STATE_SIGHTS
				if iron then
					local vm = self.REAL_VM
					vm:ResetSequence("reload")
					vm:SetPlaybackRate(0)
					self:SetAnimationProgress(0)
				end
			end
        end
    end
end

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.ExtraSightDist = 7

SWEP.WorldModelOffset = {
    pos = Vector(9.5, 1, -4),
    ang = Angle(0, 10, 180),
}

SWEP.AttachmentElements = {
    ["mag"] = {
        VMElements = {
            {
                Model = "models/viper/mw/attachments/kilo121/attachment_vm_lm_kilo121_mag.mdl",
                Bone = "j_mag1",
                Offset = {
                    pos = Vector(0, 0, 3.5),
                    ang = Angle(0, 0, 0),
                },
            },
        },

        WMElements = {
            {
                Model = "models/viper/mw/attachments/kilo121/attachment_vm_lm_kilo121_mag.mdl",
                Bone = "tag_mag_attach",
                Offset = {
                    pos = Vector(10, 2, -4),
                    ang = Angle(0, 180, 180),
                },
            },
        },

        
    },
    ["mount"] = {
        VMBodygroups = {
            {ind = 1, bg = 1},
        },
    },
}

SWEP.ActivePos = Vector(0, 1, 1.25)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(4.8, 6, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)
SWEP.Attachments = {
    {
        DefaultEles = {"mag"},
        Hidden=true,
    },
    {
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        InstalledEles = {"mount"},
        Slot = {"optic_lp", "optic"}, -- what kind of attachments can fit here, can be string or table
        Bone = "tag_scope", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(0, 0, 0), -- offset that the attachment will be relative to the bone
            vang = Angle(0, 0, 0),
            wpos = Vector(7, 1.476, -6.75),
            wang = Angle(0, 10, 180)
        },
    },
    {
        PrintName = "Tactical",
        Slot = "tac",
        Bone = "tag_weapon",
        Offset = {
            vpos = Vector(13, 0, -.8),
            vang = Angle(0, 0, 0),
            wpos = Vector(17, 1, -3.5),
            wang = Angle(0, 10, 0)
        },
        InstalledEles = {"sidemount"},
    },
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = "muzzle",
        Bone = "tag_barrel_attach",
        Offset = {
            vpos = Vector(13.5, 0, -.6),
            vang = Angle(0, 0, 0),
            wpos = Vector(30, 0, -4),
            wang = Angle(0, 10,  0)
        },
    },
    {
        PrintName = "Underbarrel",
        Slot = {"foregrip"},
        Bone = "tag_grip_attach",
        VMScale = Vector(1.2, 1, 1),
        WMScale = Vector(1.2, 1, 1),
        Offset = {
            vpos = Vector(0, 0, .8), -- offset that the attachment will be relative to the bone
            vang = Angle(0, 0, 0),
            wpos = Vector(9.5, 1.15, -3.5),
            wang = Angle(172, -181, -1.5),
        },
    },
    {
        PrintName = "Grip",
        Slot = "grip",
        DefaultAttName = "Standard Grip"
    },
    {
        PrintName = "Stock",
        Slot = "stock",
        DefaultAttName = "Standard Stock"
    },
    {
        PrintName = "Fire Group",
        Slot = "fcg",
        DefaultAttName = "Standard FCG"
    },
    {
        PrintName = "Ammo Type",
        Slot = "go_ammo",
        DefaultAttName = "Standard Ammo"
    },
    {
        PrintName = "Perk",
        Slot = "go_perk"
    },
    {
        PrintName = "Charm",
        Slot = "charm",
        FreeSlot = true,
        Bone = "tag_weapon", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(-4, -.9, -1), -- offset that the attachment will be relative to the bone
            vang = Angle(0, 0, 0),
            wpos = Vector(8, 2.3, -3.5),
            wang = Angle(-2.829, -4.902, 180)
        },
    },
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
    },
    ["ready"] = {
        Source = "draw_first",
    },
    ["draw"] = {
        Source = "draw",
    },
    ["fire"] = {
		Source = "fire",
	},
    ["reload"] = {
        --MinProgress = 2.2, ForceEnd = true,
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = 1,
        LHIKEaseIn = 1,
        LHIKOut = 1,
        LHIKEaseOut = .4,
    },
    ["reload_empty"] = {
        --MinProgress = 2.75, ForceEnd = true,
        Source = "reload_empty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = 1,
        LHIKEaseIn = 1,
        LHIKOut = .88,
        LHIKEaseOut = .45,
    },
    ["holster"] = {
		Source = "holster",
	},
}