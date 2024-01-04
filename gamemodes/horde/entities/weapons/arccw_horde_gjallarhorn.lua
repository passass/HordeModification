SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Gjallarhorn"

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/gjallarhorn/c_gjallarhorn.mdl"
SWEP.WorldModel = "models/weapons/gjallarhorn/c_gjallarhorn.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "000000000000"

SWEP.Damage = 23
SWEP.DamageMin = 16
SWEP.Primary.ClipSize = 1

SWEP.Range = 40 -- in METRES
SWEP.Penetration = 6
SWEP.DamageType = DMG_SHOCK
SWEP.ShootEntity = "horde_ghorn_rocket" -- entity to fire, if any
SWEP.MuzzleVelocity = 8000
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.

SWEP.PhysBulletMuzzleVelocity = 300

SWEP.Recoil = 2.500
SWEP.RecoilSide = 1
SWEP.RecoilRise = 1
SWEP.RecoilPunch = 5.5

SWEP.Delay = 60 / 400 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_pistol"
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 15 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 150 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 35

SWEP.Primary.Ammo = "RPG_Round" -- what ammo type the gun uses
SWEP.MagID = "gjallarhorn" -- the magazine pool this gun draws from

SWEP.ShootVol = 100 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound
SWEP.ShootSound = Sound ("TFA_GHORN_FIRE.1")

--[[SWEP.MuzzleEffect = "muzzleflash_pistol"
SWEP.ShellModel = "models/shells/shell_9mm.mdl"
SWEP.ShellPitch = 100
SWEP.ShellScale = 1.25
SWEP.ShellRotateAngle = Angle(0, 180, 0)]]

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.9
SWEP.SightedSpeedMult = 0.75
SWEP.SightTime = 0.200

SWEP.IronSightStruct = {
    Pos = Vector(-3.73, -11, 0.231),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = false
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "revolver"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG

SWEP.ActivePos = Vector(-1, 2, -1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-4, 0, -1)
SWEP.CrouchAng = Angle(0, 0, -10)

SWEP.HolsterPos = Vector(3, 3, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)
SWEP.BarrelOffsetCrouch = Vector(0, 0, -2)

SWEP.CustomizePos = Vector(8, 0, 1)
SWEP.CustomizeAng = Angle(5, 30, 30)

SWEP.BarrelLength = 24

SWEP.TracerNum = 1 -- tracer every X
SWEP.Tracer = "D2ArcTracer"
SWEP.Horde_MaxMags = 55
SWEP.ClipsPerAmmoBox = 4
SWEP.ExtraSightDist = 10
SWEP.GuaranteeLaser = true

SWEP.WorldModelOffset = {
    pos = Vector(-12, 7, -4.4),
    ang = Angle(-13, 0, 180),
    scale = .899
}


if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/killicons/destiny_gjallarhorn.vtf")
    killicon.Add("arccw_horde_gjallarhorn", "vgui/killicons/destiny_gjallarhorn", Color(255, 255, 255, 255))
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


--SWEP.MirrorVMWM = true

SWEP.Attachments = {
    {
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        Slot = "hordeext_Scopes", -- what kind of attachments can fit here, can be string or table
        Integral = true, Installed = "hordeext_gjallarhorn_scope",
        Bone = "SlideBone",
        --WMScale = Vector(0, 0, 0),
        VMScale = Vector(1.8, 1.8, 1.8),
        Offset = {
            vpos = Vector(3.5, -.4, 5.3), -- 4.6 offset that the attachment will be relative to the bone
            vang = Angle(180, 90, 0),
        },
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 180, 0),
    },
    {
        PrintName = "Perk",
        Slot = {"go_perk", "go_perk_pistol"}
    },
}


SWEP.Animations = {
    ["idle"] = {
        Source = "idle"
    },
    ["draw"] = {
        Source = "draw",
    },
    ["holster"] = {
        Source = "holster",
    },
    --[[["ready"] = {
        Source = "ready",
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.5,
    },]]
    ["fire"] = {
        Source = "shoot1",
        --Time = 0.4,
        --ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "shoot1",
        --Time = 0.4,
        --ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        SoundTable = {
            {s = Sound ("TFA_GHORN_RELOAD.1"), t = 0},
        }, Mult = 1 / .95
    },
    ["reload_empty"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        SoundTable = {
            {s = Sound ("TFA_GHORN_RELOAD.1"), t = 0},
        },
        Mult = 1 / .95
    },
}