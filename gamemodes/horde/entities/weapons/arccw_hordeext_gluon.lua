if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID( "vgui/hud/horde_gluon" )
    SWEP.DrawWeaponInfoBox = false
    SWEP.BounceWeaponIcon = false
    killicon.Add( "arccw_hordeext_gluon", "vgui/hud/horde_gluon", Color( 255, 255, 255, 255 ) )
end
SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Gluon Gun"

SWEP.Slot = 3

SWEP.UseHands = false
SWEP.ViewModel = "models/horde/weapons/v_gluon.mdl"
SWEP.WorldModel = "models/horde/weapons/w_gluon.mdl"
SWEP.ViewModelFOV = 85

SWEP.Horde_MaxMags = 35

SWEP.Damage = 15
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 50 -- DefaultClip is automatically set.

SWEP.PhysBulletMuzzleVelocity = 400

SWEP.Recoil = 0.25
SWEP.RecoilSide = 0.125
SWEP.RecoilRise = 0.1
SWEP.RecoilPunch = 2

SWEP.Delay = .1 -- 60 / RPM.
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

SWEP.Primary.Ammo = "GaussEnergy" -- what ammo type the gun uses

SWEP.ShootSound = Sound( "Weapon_HL_Gluon_Gun.Single" )
SWEP.ShootSound2 = Sound( "Weapon_HL_Gluon_Gun.Double" )

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
	["draw"] = {
        Source = "draw",
    },
	["idle"] = {
        Source = "idle",
    },
	["fire"] = {
		Source = {"fire1", "fire2", "fire3", "fire4"},
    },
}

SWEP.sec_sound = Sound( "Weapon_Horde_Tau_Cannon.Double" )

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Deploy()
    self:SetNextPrimaryFire( CurTime() + 0.5 )
    self:SetNextSecondaryFire( CurTime() + 0.5 )
    self.Sound = 0
    self.SoundTimer = CurTime()
    self.Attack = 0
    self.AttackTimer = CurTime()
    self.AttackAnimTime = .45
    self.NextAttackAnim = 0
    return BaseClass.Deploy( self )
end

function SWEP:Hook_OnHolsterEnd()
    self.Sound = 0
    self.SoundTimer = CurTime()
    self.Attack = 0
    self.AttackTimer = CurTime()
    self.Idle = 0
    self.IdleTimer = CurTime()
    if SERVER then
        self.Owner:StopSound( "Weapon_HL_Gluon_Gun.Run" )
    end
    self:StopSound( self.ShootSound )
end

function SWEP:PrimaryAttack()
    if (not self:CanPrimaryAttack()) then return end
    if self.Weapon:Clip1() <= 0 then
        self.Weapon:EmitSound( "HL.DryFire" )
        self:SetNextPrimaryFire( CurTime() + 0.2 )
        self:SetNextSecondaryFire( CurTime() + 0.2 )
        return
    end
    if self.AttacksUnderwater == false and self.Owner:WaterLevel() == 3 then
        self.Weapon:EmitSound( "HL.DryFire" )
        self:SetNextPrimaryFire( CurTime() + 0.2 )
        self:SetNextSecondaryFire( CurTime() + 0.2 )
    end
    local bullet = {}
    bullet.Num = 1
    bullet.Src = self.Owner:GetShootPos()
    bullet.Dir = self.Owner:GetAimVector()
    bullet.Spread = Vector( 0, 0, 0 )
    bullet.Tracer = 0
    bullet.Force = self.Primary.Force
    bullet.Damage = self.Damage
    bullet.AmmoType = self.Primary.Ammo
    bullet.Distance = 1000
    bullet.Callback = function (ent, tr, dmginfo)
        dmginfo:SetDamageType(DMG_BURN)
        local dmg = DamageInfo()
		dmg:SetAttacker(self.Owner)
		dmg:SetInflictor(self)
		dmg:SetDamageType(DMG_BURN)
		dmg:SetDamage(8)
		util.BlastDamageInfo(dmg, tr.HitPos, 100)
        util.Decal("Scorch", tr.StartPos, tr.HitPos - (tr.HitNormal * 16), self)
    end
    self.Owner:FireBullets( bullet )
    if self.Attack == 0 then
        self:EmitSound( self.ShootSound )
        self.Sound = 1
        self.SoundTimer = CurTime() + 2
    end


    local firedelay = self:GetFiringDelay()

    self:TakePrimaryAmmo( 1 )
    self:SetNextPrimaryFire( CurTime() + firedelay )
    self:SetNextSecondaryFire( CurTime() + firedelay )
    self.Attack = 1
    self.AttackTimer = CurTime() + firedelay + 0.05
    
    self.Idle = 1
end

function SWEP:Hook_Think()
    if self.Attack == 1 and self.Sound == 1 and self.SoundTimer <= CurTime() then
        self:StopSound( self.ShootSound )
        if SERVER then
            self.Owner:EmitSound( "Weapon_HL_Gluon_Gun.Run" )
        end
        self.Sound = 0
    end
    if self.Attack == 1 then
        local tr = self.Owner:GetEyeTrace()
        local effectdata = EffectData()
        effectdata:SetOrigin( tr.HitPos )
        effectdata:SetNormal( tr.HitNormal )
        effectdata:SetStart( self.Owner:GetShootPos() )
        effectdata:SetAttachment( 1 )
        effectdata:SetEntity( self.Weapon )
        util.Effect( "gluon_beam", effectdata )

        if self.NextAttackAnim < CurTime() then
            self:PlayAnimationWithSync( "fire" )
            self.NextAttackAnim = CurTime() + self.AttackAnimTime
        end
    end
    if self.Attack == 1 and self.AttackTimer <= CurTime() then
        if SERVER then
            self.Owner:StopSound( "Weapon_HL_Egon.Run" )
        end
        
        self:StopSound( self.ShootSound )
        self:EmitSound( self.ShootSound2 )
        self.Idle = 0
        self.IdleTimer = CurTime()
        self.Attack = 0
    end
    if self.Attack == 1 and self.Weapon:Ammo1() <= 0 then
        if SERVER then
            self.Owner:StopSound( "Weapon_HL_Egon.Run" )
        end
        self:StopSound( self.ShootSound )
        self:EmitSound( self.ShootSound2 )
        self.Idle = 0
        self.IdleTimer = CurTime()
        self.Attack = 0
    end
end