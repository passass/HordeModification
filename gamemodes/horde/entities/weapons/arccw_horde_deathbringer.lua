SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Horde" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Deathbringer"

game.AddParticles( "particles/deathbringer_fx.pcf" )
game.AddParticles( "particles/deathbringer_fx2.pcf" )

PrecacheParticleSystem("deathbringer_orb_core")
PrecacheParticleSystem("deathbringer_orb_core2")
PrecacheParticleSystem("deathbringer_orb_trail")
PrecacheParticleSystem("deathbringer_orb_fx")
PrecacheParticleSystem("deathbringer_orb_ring")
PrecacheParticleSystem("deathbringer_orb_sparks")
PrecacheParticleSystem("deathbringer_muzzle_main")
PrecacheParticleSystem("deathbringer_muzzle2")
PrecacheParticleSystem("deathbringer_muzzle3")
PrecacheParticleSystem("deathbringer_muzzle4")
PrecacheParticleSystem("deathbringer_muzzle5")
PrecacheParticleSystem("deathbringer_impact")
PrecacheParticleSystem("deathbringer_impact_glow")
PrecacheParticleSystem("deathbringer_impact_sparks")

SWEP.Slot = 5

SWEP.UseHands = true
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/killicons/destiny_deathbringer.vtf")
    killicon.Add("arccw_horde_deathbringer", "vgui/killicons/destiny_deathbringer", Color(255, 255, 255, 255))
end

SWEP.ViewModel			        = "models/weapons/c_deathbringer.mdl"
SWEP.WorldModel			        = "models/weapons/c_deathbringer.mdl"
SWEP.MirrorVMWM = false
SWEP.WorldModelOffset = {
    pos        =    Vector(-15.065, 7.791, -5.715),--Vector(-15.065, 7.791, -5.715),
    ang        =    Angle(-12.858, 0, 180),--Angle(-5, -0.25, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
    scale   =   1.0
}
SWEP.ViewModelFOV = 60

SWEP.Damage = 65
SWEP.DamageMin = 50 -- damage done at maximum range
SWEP.RangeMin = 150
SWEP.Range = 250 -- in METRES
SWEP.Penetration = 10
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 690 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3

SWEP.ChamberSize = 0-- how many rounds can be chambered.
SWEP.Primary.ClipSize = 1 -- DefaultClip is automatically set.

SWEP.Recoil = 0.4
SWEP.RecoilSide = 0.3
SWEP.RecoilRise = 0.55
SWEP.VisualRecoilMult = 1

SWEP.Delay = 60 / 950 -- 60 / RPM.
SWEP.Num = 0 -- number of shots per trigger pull.
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

SWEP.NPCWeaponType = {
    "weapon_smg1",
    "weapon_ar2",
}
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 2 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 450 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150

game.AddAmmoType( {
	name = "ammo_deathbringer",
	dmgtype = DMG_BLAST,
} )
SWEP.Primary.Ammo					= "ammo_deathbringer"
SWEP.MagID = "deathbr" -- the magazine pool this gun draws from

SWEP.ShootSound = Sound ("TFA_DEATHBRINGER_FIRE.1")

SWEP.MuzzleEffect = "muzzleflash_4"
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellPitch = 90
SWEP.ShellScale = 1.5
SWEP.Horde_MaxMags = 30

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on
--[[SWEP.ProceduralViewBobAttachment = 1
SWEP.CamAttachment = 3]]

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.5
SWEP.SightTime = 0.33

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-3.62, -12.462, 2.606),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
    CrosshairInSights = false,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(0, -2, -1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.SprintPos = Vector(3, 3, 0)
SWEP.SprintAng = Angle(-7.036, 30.016, 0)

SWEP.CustomizePos = Vector(16, -3, -2)
SWEP.CustomizeAng = Angle(15, 40, 30)

SWEP.HolsterPos = Vector(8, -3, -1)
SWEP.HolsterAng = Angle(-7.036, 40.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 27

SWEP.ExtraSightDist = 5

SWEP.Horde_MaxMags = 60
SWEP.ClipsPerAmmoBox = 4

SWEP.Attachments = {
}

--SWEP.ShootEntity = "horde_deathbringer_projectile"

function SWEP:Hook_PostFireBullets(bul)
	if SERVER then
		timer.Simple( 0, function()
			if ( not IsValid(self) ) or ( not IsValid(self:GetOwner()) ) then return end
			local aimcone = 0--self:CalculateConeRecoil()
			local ent = ents.Create("horde_deathbringer_projectile")
			local dir
			local ang = self.Owner:EyeAngles()
			local attachmentID=self:LookupAttachment("muzzle");
  			//PrintTable(self:GetAttachment(attachmentID))
			dir = ang:Forward()
			ent:SetPos(self.Owner:GetShootPos() + ang:Forward() + ang:Right()*17)
			ent.Owner = self:GetOwner()
			//ent:SetAngles(self.Owner:EyeAngles())
			ent.damage = self:GetBuff("Damage")
			ent.mydamage = ent.damage
			local trail = util.SpriteTrail(ent, 0, Color(162,0,255,200), true, 13, 2, .5, 1/(15+1)*0.5, "trails/smoke.vmt")

			ent:Spawn()
			ent:SetVelocity(dir * 1000)
			local phys = ent:GetPhysicsObject()

			if IsValid(phys) then
				phys:SetVelocity(dir * 1000)
				phys:EnableGravity( false )
				phys:EnableDrag(false)
			end

			ent:SetOwner(self.Owner)
			ent.Owner = self.Owner
			ent.WeaponClass = self:GetClass()
		end)
	end
    return true
end

SWEP.Animations = {
    ["draw"] = {
        Source = "draw",
    },
    ["holster"] = {
        Source = "holster",
    },
    ["reload"] = {
        Source = "reload",
        SoundTable = {
            {t = 0, s = Sound ("TFA_DEATHBRINGER_RELOAD.1")},
        },
        MinProgress = 2.5, ForceEnd = true, Mult=0.9,
    },
    ["reload_empty"] = {
        Source = "reload",
        SoundTable = {
            {t = 0, s = Sound ("TFA_DEATHBRINGER_RELOAD.1")},
        },
        MinProgress = 2.5, ForceEnd = true, Mult=0.9,
    },
    ["fire"] = {
        Source = "shoot"
    },
}