if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_horde_ubersaw")
    killicon.Add("arccw_horde_ubersaw", "arccw/weaponicons/arccw_horde_ubersaw", Color(0, 0, 0, 255))
end
SWEP.Base = "arccw_horde_base_melee"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Übersaw"
SWEP.Trivia_Class = "Melee Weapon"

SWEP.Slot = 0

SWEP.NotForNPCs = true

SWEP.UseHands = false
if CLIENT then
	function SWEP:Hook_ModifyBodygroups(data)
		local vm = data.vm
		if vm and IsValid(vm) then
			vm:SetBodygroup(1, 1)
		end
	end
else
	function SWEP:Hook_PostBash(info)
		if not info.tr.Entity then return end
		local ent = info.tr.Entity
		if IsValid(ent) then
			if ent:IsPlayer() then
				local healinfo = HealInfo:New({amount = 30, healer = self:GetOwner()})
				HORDE:OnPlayerHeal(ent, healinfo)
			elseif ent:IsNPC() then
				local owner = self:GetOwner()
				local healinfo = HealInfo:New({amount = math.Round(info.dmg / 3.25), healer = owner})
				HORDE:OnPlayerHeal(owner, healinfo)
			end
		end
	end
end

SWEP.ViewModel		= "models/weapons/red/medic/v_bonesaw_red.mdl"
SWEP.WorldModel		= "models/weapons/w_models/w_bonesaw.mdl"
SWEP.ViewModelFOV = 70
print("gdsagasd")
SWEP.MeleeDamage = 65

SWEP.PrimaryBash = true
SWEP.CanBash = true
SWEP.MeleeDamageType = DMG_SLASH
SWEP.MeleeRange = 65
SWEP.MeleeAttackTime = .1
SWEP.MeleeTime = 1
SWEP.MeleeGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2

SWEP.Melee2 = false

SWEP.MeleeSwingSound = {
    "weapons/cbar_miss1.wav"
}
SWEP.MeleeMissSound = {
    "weapons/cbar_miss1.wav"
}
SWEP.MeleeHitSound = {"weapons/cbar_hit1.wav","weapons/cbar_hit2.wav"}
SWEP.MeleeHitNPCSound = {"weapons/ubersaw_hit1.wav","weapons/ubersaw_hit2.wav","weapons/ubersaw_hit3.wav","weapons/ubersaw_hit4.wav"}

SWEP.NotForNPCs = true

SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "MELEE"
    },
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "melee2"

SWEP.Primary.ClipSize = -1

SWEP.WorldModelOffset = {
    pos        =    Vector(2, 1.2, 2),
    ang        =    Angle(-90, 0, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
    scale = 1.1,
}

SWEP.AttachmentElements = {
}

SWEP.Attachments = {
}

SWEP.Animations = {
    ["idle"] = {
        Source = "bs_idle",
    },
    ["draw"] = {
        Source = "bs_draw",
    },
    ["bash"] = {
        Source = {"bs_swing_a", "bs_swing_b", "bs_swing_c"},
        Time = 1,
		--[[SoundTable = {
			{s = "weapons/syringegun_reload_air1.wav", 	t = .2},
			{s = "weapons/syringegun_reload_glass2.wav", 	t = .5},
			{s = "weapons/syringegun_reload_air2.wav", 	t = .6},
		},]]
    },
    ["bash2"] = {
        Source = {"bs_swing_a", "bs_swing_b", "bs_swing_c"},
        Time = 1,
		--[[SoundTable = {
			{s = "weapons/syringegun_reload_air1.wav", 	t = .2},
			{s = "weapons/syringegun_reload_glass2.wav", 	t = .5},
			{s = "weapons/syringegun_reload_air2.wav", 	t = .6},
		},]]
    },
}

SWEP.IronSightStruct = false

--[[SWEP.ActivePos = Vector(0, -0, 0)
SWEP.ActiveAng = Angle(0, -90, 0)

SWEP.BashPreparePos = Vector(0, 0, 0)
SWEP.BashPrepareAng = Angle(0, 20, 0)

SWEP.BashPos = Vector(0, 0, 0)
SWEP.BashAng = Angle(35, -30, 0)]]

SWEP.HolsterPos = Vector(0, -3, -2)
SWEP.HolsterAng = Angle(-10, 0, 0)