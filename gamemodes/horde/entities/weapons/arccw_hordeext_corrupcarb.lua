if not ArcCWInstalled then return end
SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Corrupter Carbine"

SWEP.Slot = 3

SWEP.UseHands = true

SWEP.Horde_MaxMags = 20

SWEP.Damage = 270
SWEP.DamageMin = 215
SWEP.DamageType = DMG_POISON
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 1050 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 8 -- DefaultClip is automatically set.
SWEP.Recoil = 1
SWEP.RecoilSide = 0.5
SWEP.RecoilRise = 0.1
SWEP.RecoilPunch = 2

SWEP.Delay = 60 / 120 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.AccuracyMOA = 2 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 700 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 75

SWEP.Primary.Ammo = "ar2" -- what ammo type the gun uses

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = .9
SWEP.SightedSpeedMult = 0.75
SWEP.SightTime = 0.275

SWEP.IronSightStruct = {
    Pos = Vector(-3.5175, 0, 0),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
    CrosshairInSights = false,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "smg"
SWEP.HoldtypeSights = "smg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1

SWEP.ActivePos = Vector(0, 0, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-4, 0, -1)
SWEP.CrouchAng = Angle(0, 0, -10)

SWEP.HolsterPos = Vector(3, 0, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.CustomizePos = Vector(8, 0, 1)
SWEP.CustomizeAng = Angle(5, 30, 30)

SWEP.BarrelLength = 18



--[[SWEP.ExtraSightDist = 10
SWEP.GuaranteeLaser = true]]

if CLIENT then
    function SWEP:DoHolosight()

        -- In VRMod, we draw all holosights all the time
        if vrmod and vrmod.IsPlayerInVR(self:GetOwner()) then
            for i, asight in pairs(self.SightTable) do
                local aslot = self.Attachments[asight.Slot] or {}
                local atttbl = asight.HolosightData

                if !atttbl and aslot.Installed then
                    atttbl = ArcCW.AttachmentTable[aslot.Installed]

                    if !atttbl.Holosight then return end
                end

                if atttbl then
                    local hsp = asight.HolosightPiece or self.HSPElement
                    local hsm = asight.HolosightModel

                    if !hsp and !hsm then
                        self:SetupActiveSights()
                        return
                    end

                    self:DrawHolosight(atttbl, hsm, hsp, asight)
                end
            end

            return
        end

        local asight = self:GetActiveSights()
        if !asight then return end
        local aslot = self.Attachments[asight.Slot] or {}

        local atttbl = asight.HolosightData

        if !atttbl and aslot.Installed then
            atttbl = ArcCW.AttachmentTable[aslot.Installed]

            if !atttbl.Holosight then return end
        end

        if atttbl then
            local hsp = asight.HolosightPiece or self.HSPElement
            local hsm = asight.HolosightModel

            if !hsp and !hsm then
                self:SetupActiveSights()
                return
            end
            self:DrawHolosight(atttbl, hsm, hsp)
            self.VM[1].NoDraw = true
            --self.VM[2].NoDraw = true
        end
    end
end

SWEP.Attachments = {
    {
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        Slot = "hordeext_Scopes", -- what kind of attachments can fit here, can be string or table
        Integral = true, Installed = "hordeext_corrcarb_scope",
        Bone = "Utility",
        --WMScale = Vector(0, 0, 0),
        VMScale = Vector(1.6, 1.6, 1.6),
        Offset = {
            vpos = Vector(2.5, -3.23, 0), -- 4.6 offset that the attachment will be relative to the bone
            vang = Angle(0, 180, 90),
        },
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 0, 0),
    },
    {
        PrintName = "Perk",
        Slot = "perk"
    },
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
    },
    ["ready"] = {
        Source = "draw",
        Time = .25
    },
    ["draw_empty"] = {
        Source = "idle_empty",
    },
    ["draw"] = {
        Source = "draw",
        Time = 1
    },
    ["fire"] = {
		Source = "shoot",
	},
    ["fire_iron"] = {
        Source = {"shoot_iron", "shoot_iron2", "shoot_iron3"},
    },
    ["reload"] = {
        Source = "reload",
    },
    ["holster"] = {
		Source = "holster",
	},
}


-- TFA ADAPTIVE
HORDE.Syringe:ApplyMedicSkills(SWEP, 15)

SWEP.PrintName = "Corrupter Carbine"
SWEP.ViewModel						= "models/weapons/locuslocutus/c_locus_locutus.mdl"
SWEP.WorldModel				= SWEP.ViewModel
SWEP.ViewModelFOV = 50
SWEP.Damage = 270
SWEP.DamageMin = 215

--[[if CLIENT then
    DEFINE_BASECLASS(SWEP.Base)
    function SWEP:Initialize()
        timer.Simple(0, function()
            PrintTable(self.REAL_VM:GetSequenceList() )
            local vm = self.REAL_VM
            for i = 0, vm:GetBoneCount() - 1 do
                print( i, vm:GetBoneName( i ) )
            end
        end)
        return BaseClass.Initialize(self)
    end
end]]

local tfa_viewmodel_models = {
}

SWEP.WorldModelOffset = {
    pos = Vector(0, 0, 0),
    ang = Angle(0, 180, 0)
}

SWEP.AttachmentElements = {}

for name, data in pairs(tfa_viewmodel_models) do
    SWEP.AttachmentElements[name] = {
        VMElements = {
            {
                Model = data.model,
                Bone = data.bone,
                Offset = {
                    pos = data.pos,
                    ang = Angle(0, -90, 0),
                },
                Scale = data.size,
            },
        },
    }
end

local reloadsound = {
    [ACT_VM_RELOAD] = {
		{time = 0, type = "sound", value = Sound("TFA_LOCUSLOCUTUS_RELOAD.1")},
		{time = .2, type = "sound", value = Sound("TFA_LOCUSLOCUTUS_RELOAD.2")},
		{time = .8, type = "sound", value = Sound("TFA_LOCUSLOCUTUS_RELOAD.3")},
		{time = 1.6, type = "sound", value = Sound("TFA_LOCUSLOCUTUS_RELOAD.4")},
		{time = 2.6, type = "sound", value = Sound("TFA_LOCUSLOCUTUS_RELOAD.5")}
	}
}

if reloadsound[ACT_VM_RELOAD] then
    SWEP.Animations["reload"].SoundTable = {}
    for _, data in pairs(reloadsound[ACT_VM_RELOAD]) do
        table.insert(SWEP.Animations["reload"].SoundTable, {t=data.time, s=data.value})
    end
end

local sniper = "weapons/LocusLocutus/"

TFA.AddFireSound("TFA_LOCUSLOCUTUS_FIRE.1",  { sniper .. "LocusLocutusFire1.wav", sniper .. "LocusLocutusFire2.wav", sniper .. "LocusLocutusFire3.wav", sniper .. "LocusLocutusFire4.wav" }, true, ")" )

TFA.AddSound("TFA_LOCUSLOCUTUS_RELOAD.1", CHAN_AUTO, 0.6, 80, {97, 103}, { sniper .. "LocusLocutusReload1_1.wav", sniper .. "LocusLocutusReload1_2.wav"}, ")" )
TFA.AddSound("TFA_LOCUSLOCUTUS_RELOAD.2", CHAN_AUTO, 0.6, 80, {97, 103}, { sniper .. "LocusLocutusReload2_1.wav", sniper .. "LocusLocutusReload2_2.wav"}, ")" )
TFA.AddSound("TFA_LOCUSLOCUTUS_RELOAD.3", CHAN_AUTO, 0.6, 80, {97, 103}, { sniper .. "LocusLocutusReload3_1.wav", sniper .. "LocusLocutusReload3_2.wav"}, ")" )
TFA.AddSound("TFA_LOCUSLOCUTUS_RELOAD.4", CHAN_AUTO, 0.6, 80, {97, 103}, { sniper .. "LocusLocutusReload4_1.wav", sniper .. "LocusLocutusReload4_2.wav"}, ")" )
TFA.AddSound("TFA_LOCUSLOCUTUS_RELOAD.5", CHAN_AUTO, 0.6, 80, {97, 103}, { sniper .. "LocusLocutusReload5_1.wav", sniper .. "LocusLocutusReload5_2.wav"}, ")" )
TFA.AddSound("TFA_LOCUSLOCUTUS_RELOAD.6", CHAN_AUTO, 0.6, 80, {97, 103}, { sniper .. "LocusLocutusReload6_1.wav", sniper .. "LocusLocutusReload6_2.wav"}, ")" )

TFA.AddSound("TFA_LOCUSLOCUTUS_DRAW.1", CHAN_AUTO, 0.5, 80, {97, 103}, { sniper .. "LocusLocutusDraw1_1.wav", sniper .. "LocusLocutusDraw1_2.wav"}, ")" )
TFA.AddSound("TFA_LOCUSLOCUTUS_DRAW.2", CHAN_AUTO, 0.5, 80, {97, 103}, { sniper .. "LocusLocutusDraw2_1.wav", sniper .. "LocusLocutusDraw2_2.wav"}, ")" )
SWEP.ShootSound = { sniper .. "LocusLocutusFire1.wav", sniper .. "LocusLocutusFire2.wav", sniper .. "LocusLocutusFire3.wav", sniper .. "LocusLocutusFire4.wav" }
SWEP.ShootSoundSilenced = "ArcCW_BO2.Pistol_Sil"
SWEP.DistantShootSound = "ArcCW_BO2.PistolBurst_RingOff"

-- TFA ADAPTIVE