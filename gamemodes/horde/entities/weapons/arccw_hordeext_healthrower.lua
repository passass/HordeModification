if not ArcCWInstalled then return end
SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Healthrower"

SWEP.Slot = 3

SWEP.UseHands = true

SWEP.ViewModel				= 		"models/weapons/v_models/v_medigun_medic.mdl"
SWEP.WorldModel				= "models/weapons/w_models/w_medigun.mdl"
SWEP.ViewModelFOV = 50

SWEP.Horde_MaxMags = 7
HORDE.Syringe:ApplyMedicSkills(SWEP, 10)

SWEP.Damage = 14
SWEP.Penetration = 1
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 1050 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 50 -- DefaultClip is automatically set.
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
game.AddAmmoType( {
	name = "ammo_healthrower",
	dmgtype = DMG_BLAST,
} )
SWEP.Primary.Ammo = "ammo_healthrower" -- what ammo type the gun uses

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
SWEP.GuaranteeLaser = true]]

SWEP.WorldModelOffset = {
    pos = Vector(0, 0, 0),
    ang = Angle(0, 180, 0)
}

SWEP.Attachments = {
    {
        PrintName = "Perk",
        Slot = "perk"
    },
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
    },
    ["draw"] = {
        Source = "draw",
    },
    ["fire"] = {
        Source = "fire_off",
    },
    ["reload"] = {
        SoundTable = {
            {s = "ambient/machines/keyboard2_clicks.wav", t = 0},
        },
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Source = "idle",
        Time = 2,
    },
}

SWEP.sec_sound = Sound( "Weapon_Horde_Tau_Cannon.Double" )

DEFINE_BASECLASS(SWEP.Base)

function SWEP:PrimaryAttack()
    PrintTable(self.REAL_VM:GetSequenceList())
    if (not self:CanPrimaryAttack()) or self:Clip1() == 0 then return end

    self:TakePrimaryAmmo(1)
    self.Owner:MuzzleFlash()

    local firedelay = self:GetFiringDelay()

    self.Weapon:SetNextPrimaryFire( CurTime() + firedelay )
    self:DoPrimaryAnim()
    if (SERVER) then
        local eyetrace = self.Owner:GetEyeTrace()
        local tracedata = {}
        tracedata.start = self.Owner:GetShootPos()
        tracedata.endpos = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 500)
        tracedata.filter = self.Owner
        tracedata.mins = Vector(-25,-25,-25)
        tracedata.maxs = Vector(25,25,25)
        local trace = util.TraceHull(tracedata)
        local Distance = self.Owner:GetPos():Distance(trace.HitPos)
        local Ignite = function()
            if not self:IsValid() then return end
            if not self.Owner:IsValid() then return end
            local dmg = DamageInfo()
            dmg:SetAttacker(self.Owner)
            dmg:SetInflictor(self)
            dmg:SetDamageType(DMG_POISON)
            dmg:SetDamageCustom(HORDE.DMG_PLAYER_FRIENDLY)
            dmg:SetDamage(self:GetBuff("Damage", self.Damage))
            for _, ent in pairs(ents.FindInSphere(trace.HitPos, 128)) do
                if IsValid(ent) and ent:IsNPC() then
                    dmg:SetDamagePosition(ent:GetPos() + Vector(0, 0 ,50))
                    ent:TakeDamageInfo(dmg)
                end
            end
            --util.BlastDamageInfo(dmg, trace.HitPos, 128)

            for _, ent in pairs(ents.FindInSphere(trace.HitPos, 96)) do
                if ent:IsPlayer() then
                    local healinfo = HealInfo:New({amount = 4, healer = self.Owner, immediately = false})
                    HORDE:OnPlayerHeal(ent, healinfo)
                end
            end

            if (SERVER) and trace.Hit then
                local firefx = EffectData()
                firefx:SetOrigin(trace.HitPos)
                firefx:SetScale(1)
                firefx:SetEntity(self.Weapon.Owner)
                util.Effect("healthrower_explosion",firefx,true,true)
            end
        end
        timer.Simple(math.min(500, Distance)/1520, Ignite)
    end
end

function SWEP:Hook_Think()
    if self.Owner:KeyReleased(IN_ATTACK) then
        if (not self:CanPrimaryAttack()) then return end
		if (SERVER) then
			self.Owner:EmitSound("weapons/tfa_cso/poisongun/fire_end.wav", 24, 100 )
            self.Owner:StopSound("weapons/tfa_cso/poisongun/fire.wav")
		end
	end

    if self.Owner:KeyDown(IN_ATTACK) and self:Clip1() != 0 then
        if (not self:CanPrimaryAttack()) then return end
        if (SERVER) then
            self.Owner:EmitSound("weapons/tfa_cso/poisongun/fire.wav", math.random(27,35), math.random(32,152) )
            --self.Owner:EmitSound("ambient/machines/thumper_dust.wav", math.random(27,35), math.random(32,152) )
        end
        local trace = self.Owner:GetEyeTrace()
        if (SERVER) then
            local flamefx = EffectData()
            flamefx:SetOrigin(trace.HitPos)
            flamefx:SetStart(self.Owner:GetShootPos())
            flamefx:SetAttachment(1)
            flamefx:SetEntity(self.Weapon)
            util.Effect("healthrower_fire",flamefx,true,true)
        end
    end
end