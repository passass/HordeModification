if not ArcCWInstalled then return end
if (CLIENT) then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/hud/horde_m2")
	killicon.Add("arccw_hordeext_m2", "vgui/hud/horde_m2", color_white)
end
SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "M2 Flamethrower"

SWEP.Slot = 3

SWEP.UseHands = true

SWEP.ViewModel				= "models/horde/weapons/c_m2.mdl"
SWEP.WorldModel				= "models/horde/weapons/w_m2f2.mdl"
SWEP.ViewModelFOV = 50

SWEP.Horde_MaxMags = 35

SWEP.Damage = 55
SWEP.DamageMin = 4 -- damage done at maximum range
SWEP.Range = 31.25 -- in METRES
SWEP.Penetration = 1
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 1050 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 100 -- DefaultClip is automatically set.
SWEP.Recoil = 0.25
SWEP.RecoilSide = 0.125
SWEP.RecoilRise = 0.1
SWEP.RecoilPunch = 2

SWEP.Delay = 0.08 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 0
    }
}

SWEP.AccuracyMOA = 12 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 300 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 75

SWEP.Primary.Ammo = "ar2" -- what ammo type the gun uses

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.75
SWEP.SightTime = 0.275

SWEP.IronSightStruct = false

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
SWEP.GuaranteeLaser = true

SWEP.WorldModelOffset = {
    pos = Vector(-14, 6, -4),
    ang = Angle(-10, 0, 180)
}]]

SWEP.Attachments = {
    {
        PrintName = "Perk",
        Slot = "perk"
    },
}

SWEP.Animations = {
    ["reload"] = {
        SoundTable = {
            {s = "ambient/machines/keyboard2_clicks.wav", t = 0},
        }, Source = "idle",
        Time = 2,
    },
}

SWEP.sec_sound = Sound( "Weapon_Horde_Tau_Cannon.Double" )

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Deploy()
    if (SERVER) then
		self.Owner:EmitSound("ambient/machines/keyboard2_clicks.wav", 42, 100 )
	end
    return BaseClass.Deploy( self )
end

function SWEP:PrimaryAttack()
    if (not self:CanPrimaryAttack()) or self:Clip1() == 0 then return end

    self:TakePrimaryAmmo(1)
    self.Owner:MuzzleFlash()

    local firedelay = self:GetFiringDelay()

    self.Weapon:SetNextPrimaryFire( CurTime() + firedelay )
    if (SERVER) then
        local eyetrace = self.Owner:GetEyeTrace()
        local tracedata = {}
        tracedata.start = self.Owner:GetShootPos()
        tracedata.endpos = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 500)
        tracedata.filter = self.Owner
        tracedata.mins = Vector(-5,-5,-5)
        tracedata.maxs = Vector(5,5,5)
        local trace = util.TraceHull(tracedata)
        HORDE:CreateFloorFire(self, trace.HitPos, 45)
        local Distance = self.Owner:GetPos():Distance(trace.HitPos)
        local Ignite = function()
            if not self:IsValid() then return end
            if not self.Owner:IsValid() then return end
            local dmg = DamageInfo()
            dmg:SetAttacker(self.Owner)
            dmg:SetInflictor(self)
            dmg:SetDamageType(DMG_BURN)
            dmg:SetDamage(8)
            dmg:SetDamageCustom(HORDE.DMG_PLAYER_FRIENDLY)
            util.BlastDamageInfo(dmg, trace.HitPos, 128)
            
            if (SERVER) and trace.Hit then
                local firefx = EffectData()
                firefx:SetOrigin(trace.HitPos)
                firefx:SetScale(1)
                firefx:SetEntity(self.Weapon.Owner)
                util.Effect("m2_flame_explosion",firefx,true,true)
            end
        end
        timer.Simple(math.min(500, Distance)/1520, Ignite)
    end
end

function SWEP:Hook_Think()
    if self.Owner:KeyReleased(IN_ATTACK) then
        if (not self:CanPrimaryAttack()) then return end
		if (SERVER) then
			self.Owner:EmitSound("ambient/fire/mtov_flame2.wav", 24, 100 )
		end
	end

    if self.Owner:KeyDown(IN_ATTACK) and self:Clip1() != 0 then
        if (not self:CanPrimaryAttack()) then return end
        if (SERVER) then
            self.Owner:EmitSound("ambient/fire/mtov_flame2.wav", math.random(27,35), math.random(32,152) )
            self.Owner:EmitSound("ambient/machines/thumper_dust.wav", math.random(27,35), math.random(32,152) )
        end
        local trace = self.Owner:GetEyeTrace()
        if (SERVER) then
            local flamefx = EffectData()
            flamefx:SetOrigin(trace.HitPos)
            flamefx:SetStart(self.Owner:GetShootPos())
            flamefx:SetAttachment(1)
            flamefx:SetEntity(self.Weapon)
            util.Effect("m2_flame",flamefx,true,true)
        end
    end
end