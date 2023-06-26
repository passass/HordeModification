SWEP.Base = "horde_c4_base"
SWEP.Category = "TFA CoD MW2R"
SWEP.Spawnable = TFA_BASE_VERSION and TFA_BASE_VERSION >= 4.7
SWEP.AdminSpawnable = true
SWEP.UseHands = true
SWEP.Type_Displayed = "Plastic Explosive"
SWEP.Author = "Olli, Fox, Mav"
SWEP.Slot = 5
SWEP.PrintName = "C4"
SWEP.DrawCrosshair = false
SWEP.DrawCrosshairIS = false
SWEP.AutoSwitchTo = false

TFA.AddWeaponSound("TFA_MW2R_C4.Plant", {"weapons/tfa_mw2r/c4/wpn_h1_c4_bounce_01.wav", "weapons/tfa_mw2r/c4/wpn_h1_c4_bounce_02.wav"})
TFA.AddWeaponSound("TFA_MW2R_C4.Trigger", "weapons/tfa_mw2r/c4/wpn_h1_c4_trigger_plr.wav")
TFA.AddWeaponSound("TFA_MW2R_C4.Draw", "weapons/tfa_mw2r/c4/wpn_h1_c4_safetyoff_plr.wav")
TFA.AddWeaponSound("TFA_MW2R_C4.Holster", "weapons/tfa_mw2r/c4/wpn_h1_c4_safety_plr.wav")
TFA.AddWeaponSound("TFA_MW2R_C4.Toss", "weapons/tfa_mw2r/c4/toss.wav")

--[Model]--
SWEP.ViewModel			= "models/weapons/tfa_mw2cr/c4/c_c4.mdl"
SWEP.ViewModelFOV = 70
SWEP.WorldModel			= "models/weapons/tfa_mw2cr/c4/w_detonator.mdl"
SWEP.HoldType = "slam"
SWEP.CameraAttachmentOffsets = {}
SWEP.CameraAttachmentScale = 2

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = -1.5,
        Right = 2,
        Forward = 3.5,
        },
        Ang = {
		Up = -90,
        Right = 180,
        Forward = -20
        },
		Scale = 1.2
}

game.AddAmmoType( {
	name = "ammo_c4",
	dmgtype = DMG_BLAST,
} )
SWEP.Horde_MaxMags = 12
--[Gun Related]--
SWEP.Primary.Sound = "nil"
SWEP.Primary.Ammo = "ammo_c4"
SWEP.Primary.Automatic = true
SWEP.Primary.RPM = 100
SWEP.Primary.Damage = 155
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 0
SWEP.DisableChambering = true
SWEP.SelectiveFire = false
SWEP.FiresUnderwater = false
SWEP.Delay = 0.15
if CLIENT then
	function SWEP:GetHUDData()
		return {
			ammoname = "C4",
		}
	end
end
--[Range]--
SWEP.Primary.Range = -1
SWEP.Primary.RangeFalloff = -1
SWEP.Primary.DisplayFalloff = false
TFA.AddWeaponSound("TFA_MW2R_CLYMR.Plant", {"weapons/tfa_mw2r/claymore/wpn_h1_claymore_plant_01.wav", "weapons/tfa_mw2r/claymore/wpn_h1_claymore_plant_02.wav"})
TFA.AddWeaponSound("TFA_MW2R_CLYMR.Activate", "weapons/tfa_mw2r/claymore/wpn_h1_claymore_activate.wav")
TFA.AddWeaponSound("TFA_MW2R_CLYMR.Pin", "weapons/tfa_mw2r/claymore/wpn_h1_claymore_pin.wav")
TFA.AddWeaponSound("TFA_MW2R_CLYMR.Look1", "weapons/tfa_mw2r/claymore/wpn_h1_claymore_ins_look_01.wav")
TFA.AddWeaponSound("TFA_MW2R_CLYMR.Look2", "weapons/tfa_mw2r/claymore/wpn_h1_claymore_ins_look_02.wav")
TFA.AddWeaponSound("TFA_MW2R_CLYMR.Rest", "weapons/tfa_mw2r/claymore/wpn_h1_claymore_ins_rest.wav")
--[Projectiles]--
SWEP.Primary.Round = "horde_c4_exp"
SWEP.Primary.ProjectileModel = "models/weapons/tfa_mw2cr/c4/c4_projectile.mdl"
SWEP.Velocity = 600
SWEP.Underhanded = false
SWEP.AllowSprintAttack = false
SWEP.AllowUnderhanded = false
SWEP.DisableIdleAnimations = false

--[Spread Related]--
SWEP.Primary.Spread		  = .001

--[Iron Sights]--
SWEP.data = {}
SWEP.data.ironsights = 0

--[Shells]--
SWEP.LuaShellEject = false
SWEP.EjectionSmokeEnabled = false

--[Misc]--
SWEP.InspectPos = Vector(0, 0, 0)
SWEP.InspectAng = Vector(15, 0, 0)
SWEP.MoveSpeed = 1
SWEP.IronSightsMoveSpeed = SWEP.MoveSpeed * 0.8
SWEP.SafetyPos = Vector(0, 0, 0)
SWEP.SafetyAng = Vector(0, 0, 0)
SWEP.TracerCount = 0

--[DInventory2]--
SWEP.DInv2_GridSizeX = 2
SWEP.DInv2_GridSizeY = 2
SWEP.DInv2_Volume = nil
SWEP.DInv2_Mass = 2

--[Tables]--
SWEP.SequenceRateOverride = {
	["sprint_in"] = 35 / 30,
	["sprint_loop"] = 35 / 30,
}

SWEP.SprintAnimation = {
	["in"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "sprint_in", --Number for act, String/Number for sequence
	},
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "sprint_loop", --Number for act, String/Number for sequence
		["is_idle"] = true
	},
	["out"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "sprint_out", --Number for act, String/Number for sequence
	}
}

SWEP.EventTable = {
[ACT_VM_DRAW] = {
{ ["time"] = 1 / 30, ["type"] = "sound", ["value"] = Sound("TFA_MW2R_SML.Draw") },
{ ["time"] = 10 / 30, ["type"] = "sound", ["value"] = Sound("TFA_MW2R_C4.Draw") },
},
[ACT_VM_HOLSTER] = {
{ ["time"] = 1 / 30, ["type"] = "sound", ["value"] = Sound("TFA_MW2R_C4.Holster") },
},
[ACT_VM_THROW] = {
{ ["time"] = 1 / 30, ["type"] = "sound", ["value"] = Sound("TFA_MW2R_C4.Toss") },
},
[ACT_VM_PRIMARYATTACK] = {
{ ["time"] = 1 / 30, ["type"] = "sound", ["value"] = Sound("TFA_MW2R_C4.Trigger") },
},
}

--[Shit]--
SWEP.AllowViewAttachment = true --Allow the view to sway based on weapon attachment while reloading or drawing, IF THE CLIENT HAS IT ENABLED IN THEIR CONVARS.
SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_ANI -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.Sights_Mode = TFA.Enum.LOCOMOTION_HYBRID -- ANI = mdl, HYBRID = lua but continue idle, Lua = stop mdl animation
SWEP.Idle_Mode = TFA.Enum.IDLE_BOTH --TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
SWEP.Idle_Blend = 0.25 --Start an idle this far early into the end of a transition
SWEP.Idle_Smooth = 0.05 --Start an idle this far early into the end of another animation
SWEP.SprintBobMult = 1

--[C4]--
SWEP.WElements = {
	["c4"] = { type = "Model", model = "models/weapons/tfa_mw2cr/c4/w_c4.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(5, 1.8, 1.5), angle = Angle(0, -20, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = true, bodygroup = {} },
}
