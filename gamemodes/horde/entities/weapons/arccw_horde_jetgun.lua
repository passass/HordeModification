SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Wonder Weapons" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Thrustodyne Aeronautics Model 23"

SWEP.Slot = 1

SWEP.UseHands = true
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("arccw/weaponicons/arccw_horde_jetgun.vtf")
    killicon.Add("arccw_horde_jetgun", "arccw/weaponicons/arccw_horde_jetgun", Color(255, 255, 255, 255))
end
SWEP.ViewModel =  "models/weapons/jetgun/v_jetgun.mdl"
SWEP.WorldModel = "models/weapons/jetgun/w_jetgun.mdl"
SWEP.MirrorVMWM = false
--[[SWEP.WorldModelOffset = {
    pos        =    Vector(0, 0, 0),
    ang        =    Angle(-1, 178, 178),
    bone    =    "ValveBiped.Bip01_R_Hand",
}
]]
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/entities/tfa_jetgun.vtf")
    killicon.Add("arccw_horde_jetgun", "vgui/entities/tfa_jetgun", Color(0, 0, 0, 255))
end
SWEP.ViewModelFOV = 65

SWEP.Damage = 26
SWEP.DamageMin = 20 -- damage done at maximum range
SWEP.Range = 50 -- in METRES
SWEP.Penetration = 20
SWEP.DamageType = DMG_BULLET -- entity to fire, if any
SWEP.MuzzleVelocity = 8000 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.CanFireUnderwater = false

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3

SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = -1 -- DefaultClip is automatically set.
SWEP.Primary.DefaultClip = 150
SWEP.ExtendedClipSize = -1
SWEP.ReducedClipSize = -1

SWEP.Recoil = 6.8
SWEP.RecoilSide = 1
SWEP.VisualRecoilMult = 0.1
SWEP.RecoilRise = 6

SWEP.Delay = 60 / 600-- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2
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
SWEP.Primary.Ammo = "Coolant"
--SWEP.Primary.Ammo = "tesla_bulbs" -- what ammo type the gun uses

SWEP.ShootVol = 100 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = Sound("weapons/tesla_gun/new/wpn_tesla_flux.mp3")
SWEP.DistantShootSound = SWEP.ShootSoun


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

SWEP.IronSightStruct = {
    Pos = Vector(-4.85, -3.75, -1.45),
    Ang = Vector(-1.55, 0, 0),
    Magnification = 1.3,
    CrosshairInSights = true,
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "crossbow"
SWEP.HoldtypeSights = "crossbow"

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
    ["holster"] = {
        Source = "holster",
        --[[Time = 0.75,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.25,]]
    },
    ["draw"] = {
        Source = "draw",
    },
    ["fire"] = {
        Source = "shoot",
        Time = 1.5,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "shoot",
        Time = 1,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Source = "reload",
    },
}

--[[function SWEP:Hook_PostFireRocket(ent)
    local ply = self:GetOwner()
    local pos = ply:GetShootPos()
    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then
        phys:SetMass( 1 )
        phys:SetBuoyancyRatio(0)
        phys:EnableGravity( false )
        phys:EnableDrag( false )
        phys:Wake()
        phys:ApplyForceCenter((ply:GetEyeTrace().HitPos - pos):GetNormalized()*3000)
    else
        ent:Remove()
    end
end]]

DEFINE_BASECLASS( SWEP.Base )
SWEP.TotalRPM = 0

function SWEP:Initialize()
	BaseClass.Initialize( self )
	timer.Simple(0, function()
		if self.Owner then
			self.Owner:SetAmmo(150, "Coolant")
		end
	end)
end

if CLIENT then
	function SWEP:GetHUDData()
		local huddata = BaseClass.GetHUDData(self)
		huddata.clip = LocalPlayer():GetAmmoCount("Coolant")
		return huddata
	end
end

function SWEP:PrimaryAttack()
	if self:GetHolster_Time() > 0 or self:GetWeaponOpDelay() > CurTime() or self:GetNextPrimaryFire() >= CurTime() then return end
    if self:Ammo1() < 2 then
		self:SetNextPrimaryFire(CurTime() + 1)
		return
	end
	local own = self:GetOwner()
	self.Owner = own
	
	self:TakePrimaryAmmo(2)
	--self:SetRPM(math.Clamp(self:GetRPM() + 4, 0, 150)) -- Start warming and spinning up
    self.TotalRPM = self.TotalRPM + 4
    if self.TotalRPM > 150 then
        self.TotalRPM = 150
    end

	if timer.Exists(own:EntIndex().."jetgun_reload") then -- Stop cooling down
		timer.Pause(own:EntIndex().."jetgun_reload")
	end
	
	local shootpos = own:GetShootPos()
	local aimvec = own:GetAimVector()
	
	self:CallOnClient("RenderIntakeParticles")
    --print(self.TotalRPM)
	if self.TotalRPM > 64 then -- We're spinning fast enough, pull 'em in and shred 'em!
		for k, v in pairs(ents.FindInCone( shootpos, aimvec, 200, 0.75 )) do
			v:SetVelocity((own:GetPos() - v:GetPos()) * 4)
		end
		own:SetVelocity(aimvec*16)
		
		
		local bullet = {
			Attacker = own,
			Damage = 50,
			Force = Vector(0,0,0),
			Distance = 8,
			Num = 8,
			Tracer = 0,
			AmmoType = "Coolant",
			Spread = Vector(8, 8, 0),
			Src = shootpos,
			Dir = aimvec*4,
			IgnoreEntity = own
		}
		self:FireBullets(bullet)
	end
	self:SetNextPrimaryFire(CurTime() + 0.1)
	timer.Pause(own:EntIndex().."jetgun_reload")
end

function SWEP:Think()
	BaseClass.Think(self)
	local own = self:GetOwner()
	local index = own:EntIndex()
	
	if own:KeyPressed(IN_ATTACK) then
	
		self:SendWeaponAnim(ACT_VM_PULLBACK)
		self:EmitSound("weapons/jetgun/rattle/jetgun_rattle_start.mp3", 75, 100, 1, CHAN_WEAPON)
		timer.Simple(1, function()
			if IsValid(self) and own:KeyDown(IN_ATTACK) and own:GetActiveWeapon() == self then
				self:EmitSound("weapons/jetgun/jetgun_on.mp3", 75, 100, 1, CHAN_ITEM)
				--self:LoopingSoundStart()
				own:EmitSound("Weapon_Jetgun.FullLoop")
				self:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)
				self:CallOnClient("RenderExaustParticles")
			end
		end)
		
	end
	
	if own:KeyReleased(IN_ATTACK) then
		if SERVER then
			if timer.Exists(index.."jetgun_reload") then
				timer.UnPause(index.."jetgun_reload")
			else
				timer.Create(index.."jetgun_reload", 0.15, 0, function()
					if self:Ammo1() == 150 and self.TotalRPM == 0 then -- We're done here, pause the timer
						timer.Pause(index.."jetgun_reload")
					end
					self.TotalRPM = self.TotalRPM - 8
					if self.TotalRPM < 0 then
						self.TotalRPM = 0
					end
					--self:SetRPM(math.Clamp(self:GetRPM() - 8, 0, 150)) -- Slow down
					own:SetAmmo(math.Clamp(self:Ammo1() + 1, 0, 150), "Coolant", true) -- Cool down
				end)
			end
		end
		
		own:StopSound("Weapon_Jetgun.FullLoop")
		self:SendWeaponAnim(ACT_VM_PULLBACK_LOW)
		self:StopParticles()
		self:EmitSound("weapons/jetgun/jetgun_off.mp3", 75, 100, 1, CHAN_WEAPON) -- Stop rattling
		self:EmitSound("weapons/jetgun/rattle/jetgun_rattle_stop.mp3", 75, 100, 1, CHAN_ITEM) -- Stop rattling
	end
	
	
end

function SWEP:RenderIntakeParticles()
	local own = self:GetOwner()
	if IsValid(own) then
		if own == LocalPlayer() then
			if own:ShouldDrawLocalPlayer() then
				ParticleEffectAttach( "jetgun_muzzle", PATTACH_POINT_FOLLOW, self, 1 )
				ParticleEffectAttach( "jetgun_mist2", PATTACH_POINT_FOLLOW, self, 1 )
			else
				ParticleEffectAttach( "jetgun_muzzle", PATTACH_POINT_FOLLOW, own:GetViewModel(), 1 )
				--ParticleEffect("jetgun_muzzle", own:GetPos() + Vector(0,0,16), Angle(0, own:GetAngles().y, 0), own)
				ParticleEffect("jetgun_mist2", own:GetPos() + Vector(0,0,16), Angle(0, own:GetAngles().y, 0), own)
			end
		else
			ParticleEffectAttach( "jetgun_muzzle", PATTACH_POINT_FOLLOW, self, 1 )
			ParticleEffectAttach( "jetgun_mist2", PATTACH_POINT_FOLLOW, self, 1 )
		end
	end
end

function SWEP:RenderExaustParticles()
	local own = self:GetOwner()
	if IsValid(own) then
		if own == LocalPlayer() then
			if own:ShouldDrawLocalPlayer() then
				ParticleEffectAttach( "jetgun_exaust", PATTACH_POINT_FOLLOW, self, 2 )
			end
		else
			ParticleEffectAttach( "jetgun_exaust", PATTACH_POINT_FOLLOW, self, 2 )
		end
	end
end

function SWEP:OnRemove()
	local own = self.Owner
    if IsValid(own) then
        own:StopSound("Weapon_Jetgun.FullLoop")
        timer.Remove(own:EntIndex() .. "jetgun_reload")
    end
end