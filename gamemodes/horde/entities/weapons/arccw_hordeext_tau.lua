if not ArcCWInstalled then return end
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID( "vgui/hud/horde_tau" )
    SWEP.DrawWeaponInfoBox = false
    SWEP.BounceWeaponIcon = false
    killicon.Add( "arccw_hordeext_tau", "vgui/hud/horde_tau", Color( 255, 255, 255, 255 ) )
end
SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Tau Cannon"

SWEP.Slot = 3

SWEP.UseHands = false

SWEP.ViewModel = "models/horde/weapons/v_gauss.mdl"
SWEP.WorldModel = "models/horde/weapons/w_gauss.mdl"
SWEP.ViewModelFOV = 85

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
SWEP.Primary.ClipSize = 30 -- DefaultClip is automatically set.

SWEP.PhysBulletMuzzleVelocity = 400

SWEP.Recoil = 0.25
SWEP.RecoilSide = 0.125
SWEP.RecoilRise = 0.1
SWEP.RecoilPunch = 2

SWEP.Delay = .2 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.AccuracyMOA = 12 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 300 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 75

SWEP.Primary.Ammo = "GaussEnergy" -- what ammo type the gun uses

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = Sound( "Weapon_Horde_Tau_Cannon.Single" )

SWEP.MeleeSwingSound = "arccw_go/m249/m249_draw.wav"
SWEP.MeleeMissSound = "weapons/iceaxe/iceaxe_swing1.wav"
SWEP.MeleeHitSound = "arccw_go/knife/knife_hitwall1.wav"
SWEP.MeleeHitNPCSound = "physics/body/body_medium_break2.wav"

SWEP.MuzzleEffect = "muzzleflash_smg"
SWEP.ShellModel = "models/shells/shell_9mm.mdl"
SWEP.ShellPitch = 100
SWEP.ShellScale = 1.25
SWEP.ShellRotateAngle = Angle(0, 180, 0)

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
	["spin"] = {
        Source = "spin",
    },
	["spinup"] = {
        Source = "spinup",
    },
	["fire"] = {
		Source = "fire",
    },
}

SWEP.sec_sound = Sound( "Weapon_Horde_Tau_Cannon.Double" )

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Initialize()
    BaseClass.Initialize( self )
    self.Idle = 0
    self.IdleTimer = CurTime() + 1
end

function SWEP:Deploy()
    self.Spin = 0
    self.SpinTimer = CurTime()
    self.Idle = 0
    self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
    self.Recoil = 0
    self.RecoilTimer = CurTime()
    return BaseClass.Deploy( self )
end

function SWEP:Hook_OnHolsterEnd()
    self.Spin = 0
    self.SpinTimer = CurTime()
    self.Idle = 0
    self.IdleTimer = CurTime()
    self.Recoil = 0
    self.RecoilTimer = CurTime()
    self:StopSound( self.sec_sound )
    if SERVER then
        self.Owner:StopSound( "Weapon_Horde_Tau_Cannon.Double_2" )
        self.Owner:StopSound( "Weapon_Horde_Tau_Cannon.Double_3" )
    end
end

function SWEP:PrimaryAttack()
    if (not self:CanPrimaryAttack()) then return end
    if self.Spin == 1 then return end
    if self.Weapon:Ammo1() <= 0 then
        self.Weapon:EmitSound( "Weapon_Horde_Tau_Cannon.DryFire" )
        self:SetNextPrimaryFire( CurTime() + 0.2 )
        self:SetNextSecondaryFire( CurTime() + 0.2 )
    end
    if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then
        self.Weapon:EmitSound( "Weapon_Horde_Tau_Cannon.DryFire" )
        self:SetNextPrimaryFire( CurTime() + 0.2 )
        self:SetNextSecondaryFire( CurTime() + 0.2 )
    end
    if self.Weapon:Ammo1() <= 0 then return end
    if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then return end
    local tr = self.Owner:GetEyeTrace()
    local effectdata = EffectData()
    effectdata:SetOrigin( tr.HitPos )
    effectdata:SetNormal( tr.HitNormal )
    effectdata:SetStart( self.Owner:GetShootPos() )
    effectdata:SetAttachment( 1 )
    effectdata:SetEntity( self.Weapon )
    util.Effect( "tau_beam", effectdata )
    local bullet = {}
    bullet.Callback = function (attacker, ttt, dmginfo)
        dmginfo:SetDamageType(DMG_BURN)
    end
    bullet.Num = self.Primary.NumberofShots
    bullet.Src = self.Owner:GetShootPos()
    bullet.Dir = self.Owner:GetAimVector()
    bullet.Spread = Vector( 1 * 0, 1 * 0, 0 )
    bullet.Tracer = 0
    bullet.Force = self.Primary.Force
    bullet.Damage = self.Damage
    bullet.AmmoType = self.Primary.Ammo
    self.Owner:FireBullets( bullet )
    self:EmitSound( self.ShootSound )
    self:PlayAnimationWithSync("fire", nil, nil, nil, nil, nil, true)
    self.Owner:MuzzleFlash()
    self:TakePrimaryAmmo( 1 )

	local firedelay = self:GetFiringDelay()

    self:SetNextPrimaryFire( CurTime() + firedelay )
    self:SetNextSecondaryFire( CurTime() + firedelay )
    self.Idle = 0
    self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
    if ( CLIENT || game.SinglePlayer() ) and IsFirstTimePredicted() then
        self.Recoil = 1
        self.RecoilTimer = CurTime() + firedelay
        self.Owner:SetEyeAngles( self.Owner:EyeAngles() + Angle( -3, 0, 0 ) )
    end
end

function SWEP:SecondaryAttack()
    if (not self:CanPrimaryAttack()) then return end
    if self.Spin == 1 then return end
    if self.Weapon:Ammo1() < 5 then
        self.Weapon:EmitSound( "Weapon_Horde_Tau_Cannon.DryFire" )
        self:SetNextPrimaryFire( CurTime() + 0.2 )
        self:SetNextSecondaryFire( CurTime() + 0.2 )
    end
    if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then
        self.Weapon:EmitSound( "Weapon_Horde_Tau_Cannon.DryFire" )
        self:SetNextPrimaryFire( CurTime() + 0.2 )
        self:SetNextSecondaryFire( CurTime() + 0.2 )
    end
    if self.Weapon:Ammo1() < 5 then return end
    if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then return end
    self:EmitSound( self.sec_sound )
	self:SetPriorityAnim(0)
    self:PlayAnimationWithSync( "spinup" )

	

	local firedelay = self:GetFiringDelay()

    self:SetNextPrimaryFire( CurTime() + firedelay )
    self:SetNextSecondaryFire( CurTime() + firedelay )
    self.Spin = 1
    self.SpinTimer = CurTime() + 7
    self.Idle = 0
    self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:Hook_Think()
    if self.Spin == 1 then
        if self.SpinTimer < CurTime() + 6.5 and self.SpinTimer > CurTime() + 6.48 then
            self:StopSound( self.sec_sound )
            if SERVER then
                self.Owner:EmitSound( "Weapon_Horde_Tau_Cannon.Double_2" )
            end
        end
        if self.SpinTimer < CurTime() + 6 and self.SpinTimer > CurTime() + 5.98 then
            if SERVER then
                self.Owner:StopSound( "Weapon_Horde_Tau_Cannon.Double_2" )
                self.Owner:EmitSound( "Weapon_Horde_Tau_Cannon.Double_3" )
            end
        end
    end
    if self.Spin == 1 and !self.Owner:KeyDown( IN_ATTACK2 ) then
        local tr = self.Owner:GetEyeTrace()
        local effectdata = EffectData()
        effectdata:SetOrigin( tr.HitPos )
        effectdata:SetNormal( tr.HitNormal )
        effectdata:SetStart( self.Owner:GetShootPos() )
        effectdata:SetAttachment( 1 )
        effectdata:SetEntity( self.Weapon )
        util.Effect( "tau_beam", effectdata )
        local bullet = {}
        bullet.Callback = function (attacker, ttt, dmginfo)
            dmginfo:SetDamageType(DMG_BURN)
        end
        bullet.Num = 1
        bullet.Src = self.Owner:GetShootPos()
        bullet.Dir = self.Owner:GetAimVector()
        bullet.Spread = Vector( 0, 0, 0 )
        bullet.Tracer = 0
        bullet.Force = self.Primary.Force
        if self.SpinTimer > CurTime() + 6.5 and self.SpinTimer <= CurTime() + 7 then
            bullet.Damage = 60
        end
        if self.SpinTimer > CurTime() + 6 and self.SpinTimer <= CurTime() + 6.5 then
            bullet.Damage = 60 * 5
        end
        if self.SpinTimer <= CurTime() + 6 then
            bullet.Damage = 60 * 10
        end
        bullet.AmmoType = self.Primary.Ammo
        self.Owner:FireBullets( bullet )
        self:EmitSound( self.ShootSound )
        self:StopSound( self.sec_sound )
        if SERVER then
            self.Owner:StopSound( "Weapon_Horde_Tau_Cannon.Double_2" )
            self.Owner:StopSound( "Weapon_Horde_Tau_Cannon.Double_3" )
            self.Owner:EmitSound( "Weapon_Horde_Tau.Electro" )
        end
		self:SetPriorityAnim(0)
        self:PlayAnimationWithSync("fire", nil, nil, nil, nil, nil, true)
		
        self.Owner:MuzzleFlash()
        if self.SpinTimer > CurTime() + 6.5 and self.SpinTimer <= CurTime() + 7 then
            self:TakePrimaryAmmo(math.min(self.Weapon:Clip1(), 5 ))
        end
        if self.SpinTimer > CurTime() + 6 and self.SpinTimer <= CurTime() + 6.5 then
            self:TakePrimaryAmmo( math.min(self.Weapon:Clip1(), 5 ) )
        end
        if self.SpinTimer <= CurTime() + 6 then
            self:TakePrimaryAmmo( math.min(self.Weapon:Clip1(), 10 ) )
        end

		local firedelay = self:GetFiringDelay()

        self:SetNextPrimaryFire( CurTime() + firedelay )
        self:SetNextSecondaryFire( CurTime() + firedelay )
        self.Spin = 0
        self.Idle = 0
        self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
        self.Recoil = 1
        self.RecoilTimer = CurTime() + firedelay
        self.Owner:SetEyeAngles( self.Owner:EyeAngles() + Angle( -3, 0, 0 ) )
        if self.SpinTimer > CurTime() + 6.5 and self.SpinTimer <= CurTime() + 7 then
            self.Owner:SetVelocity( self.Owner:GetForward() * -200 )
        end
        if self.SpinTimer > CurTime() + 6 and self.SpinTimer <= CurTime() + 6.5 then
            self.Owner:SetVelocity( self.Owner:GetForward() * -300 )
        end
        if self.SpinTimer <= CurTime() + 6 then
            self.Owner:SetVelocity( self.Owner:GetForward() * -400 )
        end
    end
    if ( CLIENT || game.SinglePlayer() ) and IsFirstTimePredicted() then
        if self.Recoil == 1 and self.RecoilTimer <= CurTime() then
            self.Recoil = 0
        end
        if self.Recoil == 1 then
            self.Owner:SetEyeAngles( self.Owner:EyeAngles() + Angle( 0.23, 0, 0 ) )
        end
    end

	if SERVER and self.Spin == 1 and !self:GetPriorityAnim() then
		self:PlayAnimationWithSync( "spin" )
		self:SetPriorityAnim(CurTime() + self:GetAnimKeyTime("spin"))
	end
	
    if self.Spin == 1 and self.SpinTimer <= CurTime() then
        if SERVER then
            local explode = ents.Create( "env_explosion" )
            explode:SetOwner( self.Owner )
            explode:SetPos( self:GetPos() )
            explode:Spawn()
            explode:Fire( "Explode", 0, 0 )
            self.Owner:StopSound( "Weapon_Horde_Tau_Cannon.Double_2" )
            self.Owner:StopSound( "Weapon_Horde_Tau_Cannon.Double_3" )
            self.Owner:EmitSound( "Weapon_Horde_Tau_Cannon.Explode" )
        end
        self:StopSound( Sound( "Weapon_Horde_Tau_Cannon.Double" ) )
        util.BlastDamage( self, self.Owner, self:GetPos(), 256, 50 )
    end
end