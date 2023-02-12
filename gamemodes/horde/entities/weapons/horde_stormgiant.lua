SWEP.Base = "horde_tfa_melee_base"
SWEP.Category = "TFA CS:O Melees"
SWEP.PrintName = "Warhammer Storm Giant"
SWEP.Author	= "Kamikaze" --Author Tooltip
SWEP.ViewModel = "models/weapons/tfa_cso/c_stormgiant.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_storm_giant.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 80
SWEP.UseHands = true
SWEP.HoldType = "melee2"
SWEP.DrawCrosshair = true
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("entities/horde_stormgiant.vtf")
    killicon.Add("horde_stormgiant", "entities/horde_stormgiant", Color(0, 0, 0, 255))
end
SWEP.Primary.Directional = false

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.DisableIdleAnimations = false

SWEP.Secondary.CanBash = false
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.Precision = 50

SWEP.Offset = {
		Pos = {
		Up = 0,
		Right = 1,
		Forward = 3,
		},
		Ang = {
		Up = 90,
		Right = 180,
		Forward = 0
		},
		Scale = 1.5
}

sound.Add({
	['name'] = "StormGiant.Draw",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/stormgiant/draw.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "StormGiant.Idle",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/stormgiant/idle.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "StormGiant.Midslash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/stormgiant/midslash1.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "StormGiant.Midslash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/stormgiant/midslash2.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "StormGiant.Midslash1_Hit",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/stormgiant/midslash1_hit.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "StormGiant.Midslash2_Hit",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/stormgiant/midslash2_hit.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "StormGiant.HitFlesh",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/stormgiant/hit_flesh1.wav", "weapons/tfa_cso/stormgiant/hit_flesh2.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "StormGiant.HitWorld",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/stormgiant/hit_world1.wav", "weapons/tfa_cso/stormgiant/hit_world2.wav", "weapons/tfa_cso/stormgiant/hit_world3.wav"},
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 100, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-240,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 300, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_CLUB, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 1, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 1,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.5, --time before next attack
		['hull'] = 256, --Hullsize
		['direction'] = "R", --Swing dir,
		['hitflesh'] = "StormGiant.HitFlesh",
		['hitworld'] = "StormGiant.HitWorld",
		['maxhits'] = 25
	}
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_SECONDARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 125, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,0,-100), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 400, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_CLUB, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 1, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 1,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.3, --time before next attack
		['hull'] = 256, --Hullsize
		['direction'] = "F", --Swing dir
		['hitflesh'] = "StormGiant.HitFlesh",
		['hitworld'] = "StormGiant.HitWorld",
		['maxhits'] = 25
	}
}
