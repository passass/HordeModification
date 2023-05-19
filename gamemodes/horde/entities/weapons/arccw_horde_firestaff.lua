SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Wonder Weapons" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Staff of Fire"
SWEP.Trivia_Country = "GER"
SWEP.Trivia_Year = 1945

SWEP.Slot = 1

SWEP.UseHands = true

SWEP.ViewModel          = "models/weapons/originstaffs/c_staffoffire.mdl"
SWEP.WorldModel         = "models/weapons/originstaffs/w_staffoffire.mdl"
SWEP.MirrorVMWM = false
--[[SWEP.WorldModelOffset = {
    pos        =    Vector(0, 0, 0),
    ang        =    Angle(-1, 178, 178),
    bone    =    "ValveBiped.Bip01_R_Hand",
}
]]

game.AddAmmoType( {
    name = "FireStaffAmmo",
} )

if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/entities/tfa_staff_fire.vtf")
    killicon.Add("arccw_horde_firestaff", "vgui/entities/tfa_staff_fire", Color(0, 0, 0, 255))
end
SWEP.ViewModelFOV = 65

SWEP.Damage = 50
SWEP.DamageMin = 50 -- damage done at maximum range
SWEP.Range = nil -- in METRES
SWEP.Penetration = 20
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 8000 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.CanFireUnderwater = false

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3

SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 9 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 9
SWEP.ReducedClipSize = 9

SWEP.Recoil = 6.8
SWEP.RecoilSide = 1
SWEP.VisualRecoilMult = 0.1
SWEP.RecoilRise = 6

SWEP.Delay = 60 / 75-- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1
    },
    {
        Mode = 0
    }
    --[[{
        Mode = 1
    },
    {
        Mode = 0
    }]]
}

--[[game.AddAmmoType( {
    name = "tesla_bulbs",
    dmgtype = DMG_SHOCK,
    tracer = TRACER_LINE,
    plydmg = 0,
    npcdmg = 0,
    force = 2000,
    minsplash = 10,
    maxsplash = 5
} )]]

SWEP.NPCWeaponType = "weapon_pistol"
SWEP.NPCWeight = 75

SWEP.AccuracyMOA = 10 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 150 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 250
SWEP.Primary.Ammo = "FireStaffAmmo"
--SWEP.Primary.Ammo = "tesla_bulbs" -- what ammo type the gun uses

SWEP.ShootVol = 100 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = Sound("weapons/tesla_gun/new/wpn_tesla_flux.mp3")
SWEP.DistantShootSound = SWEP.ShootSound


SWEP.MuzzleEffect = "muzzleflash_pistol"
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellScale = 2

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on
SWEP.ProceduralViewBobAttachment = 1
SWEP.SightTime = 0.175

SWEP.SpeedMult = 0.8
SWEP.SightedSpeedMult = 0.8

SWEP.BarrelLength = 20

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = false

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "shotgun"
SWEP.HoldtypeSights = "shotgun"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL

SWEP.ActivePos = Vector(0.25, 2, -0.50)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(-2, -7.145, -11.561)
SWEP.HolsterAng = Angle(36.533, 0, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.CustomizePos = Vector(12, -8, -4.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.AttachmentElements = {

}

SWEP.ExtraSightDist = 5

SWEP.Attachments = {
    {
        PrintName = "Perk",
        Slot = "go_perk"
    },
}

SWEP.Animations = {
    ["idle"] = {
    Source = "idle",
    Time = 10,
    },
    ["enter_sight"] = {
        Source = "idle",
    },
    ["exit_sight"] = {
        Source = "idle",
    },
    ["holster"] = {
        Source = "putaway",
        --[[Time = 0.75,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.25,]]
    },
    ["ready"] = {
        Source = "first raise",
        --[[Time = 1,
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.25,]]
    },
    ["draw"] = {
        Source = "pullout",
    },
    ["fire"] = {
        Source = "fire",
    },
    ["fire_iron"] = {
        Source = "fire",
    },
    ["reload"] = {
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Source = "reload",
    },
}

DEFINE_BASECLASS( SWEP.Base )

function SWEP:PrimaryAttack()

if !self:CanPrimaryAttack() or self:Clip1() == 0 then return end
	local own = self.Owner
	self:SetNextPrimaryFire(CurTime() + self.Delay)
	if SERVER then
		local orb1 = ents.Create("arccw_horde_firestaff_obj")
		
		
		local pos = own:GetShootPos()
		local dir = own:GetAimVector()
		local right = own:EyeAngles():Right()
		--pos = util.TraceLine({start=own:EyePos(),endpos=pos,filter=own}).HitPos
		
		--debugoverlay.Sphere(pos,5) 
		orb1:SetPos(pos + dir * 9)
		orb1:SetAngles(Angle(math.random(1,180), math.random(1,180), math.random(1,180)))
		orb1.Owner = own
		orb1:Spawn()
		orb1:Activate()
		local phys1 = orb1:GetPhysicsObject()
		if IsValid(phys1) then
			phys1:ApplyForceCenter(dir*2000)
		end
		
		timer.Simple(0.1, function()
			local orb2 = ents.Create("arccw_horde_firestaff_obj")
			orb2:SetPos(pos + dir * 9)
			orb2:SetAngles(Angle(math.random(1,180), math.random(1,180), math.random(1,180)))
			orb2.Owner = own
			orb2:Spawn()
			orb2:Activate()
			local phys2 = orb2:GetPhysicsObject()
			if IsValid(phys2) then
				phys2:ApplyForceCenter(dir*2000 + right * 250)
			end
		end)
		
		timer.Simple(0.2, function()
			local orb3 = ents.Create("arccw_horde_firestaff_obj")
			orb3:SetPos(pos + dir * 9)
			orb3:SetAngles(Angle(math.random(1,180), math.random(1,180), math.random(1,180)))
			orb3.Owner = own
			orb3:Spawn()
			orb3:Activate()
			local phys3 = orb3:GetPhysicsObject()
			if IsValid(phys3) then
				phys3:ApplyForceCenter(dir*2000 + right * -250)
			end
		end)
	end
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	own:SetAnimation( PLAYER_ATTACK1 )
	self:TakePrimaryAmmo(1)
	self:EmitSound("weapons/originstaffs/fire/shot/firestaff_shoot.ogg", 75, 100, 1.0, CHAN_ITEM)
	self:EmitSound("weapons/originstaffs/fire/flux/firestaff_flux.ogg", 100, 100, 0.4, CHAN_WEAPON)
	self:CallOnClient( "RenderParticleEffects" )
	self.Owner:ViewPunch( Angle(-2, 0 ))
end

function SWEP:RenderParticleEffects()
	local own = self.Owner
	if IsValid(own) then
		if own == LocalPlayer() then
			if own:ShouldDrawLocalPlayer() then
				ParticleEffect("originstaff_fire_muzzle",own:GetShootPos() + own:GetForward() * 32 + own:GetUp() * -16 + own:GetRight() * 8,own:GetAngles(),own)
			else
				ParticleEffectAttach( "originstaff_fire_muzzle", PATTACH_POINT_FOLLOW, self.Owner:GetViewModel(), 1 )
			end
		else
			ParticleEffect("originstaff_fire_muzzle",own:GetShootPos() + own:GetForward() * 32 + own:GetUp() * -16 + own:GetRight() * 8,own:GetAngles(),own)
		end
	end
end