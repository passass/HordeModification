SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Wonder Weapons" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Wunderwaffe DG-2"
SWEP.Trivia_Country = "GER"
SWEP.Trivia_Year = 1945

--AddCSLuaFile("autorun/particle_additions.lua")

game.AddParticles("particles/wunderwaffe_fx.pcf")
PrecacheParticleSystem("tesla_vm_glow")
PrecacheParticleSystem("tesla_vm_glow_pap")
PrecacheParticleSystem("tesla_vm_excited")
PrecacheParticleSystem("tesla_vm_excited_pap")
PrecacheParticleSystem("tesla_mflash")
PrecacheParticleSystem("tesla_mflash_pap")
PrecacheParticleSystem("tesla_beam")
PrecacheParticleSystem("tesla_beam_pap")
PrecacheParticleSystem("tesla_jump")
PrecacheParticleSystem("tesla_impact")

PrecacheParticleSystem("tesla_electrocute")
PrecacheParticleSystem("tesla_electrocute1")
PrecacheParticleSystem("tesla_electrocute_pap")
PrecacheParticleSystem("tesla_electrocute1_pap")

--game.AddParticles("particles/lightning_trail.pcf")
--PrecacheParticleSystem("lightning_trail")

-- -tools -nop4
sound.Add(
{
    name = "Weapon_WunderWaffe.Raise",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = 80,
    sound = "weapons/tesla_gun/reload/gr_tesla_start.mp3"
})
sound.Add(
{
    name = "Weapon_WunderWaffe.Loop",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = 80,
    sound = "weapons/tesla_gun/wpn_tesla_idle_d.wav"
})
sound.Add(
{
    name = "Weapon_WunderWaffe.FlipOff",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = 80,
    sound = "weapons/tesla_gun/reload/tesla_switch_flip_off.mp3"
})
sound.Add(
{
    name = "Weapon_WunderWaffe.HandlePull",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = 80,
    sound = "weapons/tesla_gun/reload/tesla_handle_pullback.mp3"
})
sound.Add(
{
    name = "Weapon_WunderWaffe.ClipIn",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = 80,
    sound = "weapons/tesla_gun/reload/tesla_clip_in.mp3"
})
sound.Add(
{
    name = "Weapon_WunderWaffe.HandleRelease",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = 80,
    sound = "weapons/tesla_gun/reload/tesla_handle_release.mp3"
})
sound.Add(
{
    name = "Weapon_WunderWaffe.FlipOn",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = 80,
    sound = "weapons/tesla_gun/reload/tesla_switch_flip_on.mp3"
})
--[[
hook.Add("CreateClientsideRagdoll", "WunderwaffeRagdollParticles", function(owner, ragdoll)
	if owner:GetNWBool("waffeshocked") then
		ParticleEffectAttach( "tesla_electrocute", PATTACH_POINT_FOLLOW, ragdoll, 2)
	elseif owner:GetNWBool("waffeshockedpap") then
		ParticleEffectAttach( "tesla_electrocute_pap", PATTACH_POINT_FOLLOW, ragdoll, 2)
	end
end)]]

SWEP.Slot = 1

SWEP.UseHands = true

SWEP.ViewModel =  "models/weapons/world_at_war/wunderwaffe/v_wunderwaffe.mdl"
SWEP.WorldModel = "models/weapons/world_at_war/wunderwaffe/w_wunderwaffe.mdl"
SWEP.MirrorVMWM = false
--[[SWEP.WorldModelOffset = {
    pos        =    Vector(0, 0, 0),
    ang        =    Angle(-1, 178, 178),
    bone    =    "ValveBiped.Bip01_R_Hand",
}
]]
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/entities/tfa_wunderwaffe.vtf")
    killicon.Add("arccw_horde_wunderwaffe", "vgui/entities/tfa_wunderwaffe", Color(0, 0, 0, 255))
end
SWEP.ViewModelFOV = 45

SWEP.Damage = 26
SWEP.DamageMin = 20 -- damage done at maximum range
SWEP.Range = 50 -- in METRES
SWEP.Penetration = 20
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = "horde_wunderwaffe_entity_ball" -- entity to fire, if any
SWEP.MuzzleVelocity = 8000 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.CanFireUnderwater = false

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3

SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 3 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 3
SWEP.ReducedClipSize = 3

SWEP.Recoil = 6.8
SWEP.RecoilSide = 1
SWEP.VisualRecoilMult = 0.1
SWEP.RecoilRise = 6

SWEP.Delay = 60 / 60-- 60 / RPM.
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
SWEP.Horde_MaxMags = 25
game.AddAmmoType( {
	name = "tesla_bulbs",
} )
SWEP.AccuracyMOA = 10 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 150 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 250
SWEP.Primary.Ammo = "tesla_bulbs"
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

SWEP.SpeedMult = 0.9
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
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

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
        Time = 0,
    },
    ["exit_sight"] = {
        Source = "idle",
        Time = 0,
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
        Time = 0.5,
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.25,
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
        Mult=.8
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

function SWEP:Hook_FireBullets(wep, bullettable)
    local own = self:GetOwner()
    if CLIENT then
        local lightpcf = "tesla_vm_glow"
        local vm = own:GetViewModel()
        local bulb = {2, 3, 4}
        vm:StopParticles()
        ParticleEffectAttach( "tesla_mflash", PATTACH_POINT_FOLLOW, vm, 1)
        if self:Clip1() > 1 then
            for i = 1, self:Clip1() do
                ParticleEffectAttach( lightpcf, PATTACH_POINT_FOLLOW, vm, bulb[i])
            end
            ParticleEffectAttach( lightpcf, PATTACH_POINT_FOLLOW, vm, 5)
        else
            vm:StopParticles()
            self.LoopingSound:Stop()
        end
    else
		local orb1 = ents.Create("horde_wunderwaffe_entity_ball")
		local pos
		if self:GetActiveSights().IronSight then
			pos = own:GetShootPos() + own:GetUp()*-6
		else
			pos = own:GetShootPos() + own:GetUp()*-6 + own:GetRight()*5
		end
		orb1:SetPos(pos)
		orb1:SetUpgraded(self.Ispackapunched)
		orb1.Owner = own
		orb1:Spawn()
		orb1:Activate()
		local phys = orb1:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass( 1 )
			phys:SetBuoyancyRatio(0)
			phys:EnableGravity( false )
			phys:EnableDrag( false )
			phys:Wake()
			phys:ApplyForceCenter((own:GetEyeTrace().HitPos - pos):GetNormalized()*3000)
		else
			orb1:Remove()
		end
    end
    if self:Clip1() > 1 then
		self:EmitSound("weapons/tesla_gun/new/wpn_tesla_fire_st.mp3", 80, 100, 1, CHAN_ITEM)
	else
		self:EmitSound("weapons/tesla_gun/new/wpn_tesla_fire_lst.mp3", 80, 100, 1, CHAN_ITEM)
	end
	self:EmitSound(self.ShootSound, 110, 100, 0.5, CHAN_WEAPON)
    if SERVER then self:CallOnClient("Hook_FireBullets") end
end

DEFINE_BASECLASS( SWEP.Base )

function SWEP:Initialize()
	BaseClass.Initialize(self)
	if CLIENT then
		self.LoopingSound = CreateSound( self, "weapons/tesla_gun/wpn_tesla_idle_d.wav")
	end
end

SWEP.LightNum = 3
function SWEP:FireAnimationEvent(pos, ang, event, options)
	local own = self:GetOwner()
	local lightpcf = "tesla_vm_glow"
	local vm = own:GetViewModel()
	local bulb = {2, 3, 4}
	
	-- First Raise = 9091
	-- Pullout = 9001
	-- Fire = 9061
	-- Finish Reload = 9071
	-- Start Reload = 9081
	
	self.LightNum = math.Clamp(self:Clip1() + self.Owner:GetAmmoCount(self.Primary.Ammo), 0, 3)

	self.FuncList = {
		[9001] = function()
			vm:StopParticles()
			if self:Clip1() > 0 then self.LoopingSound:Play() end
			if self.Ispackapunched then
				for i = 1, math.Round(self:Clip1()/2) do
					ParticleEffectAttach( lightpcf, PATTACH_POINT_FOLLOW, vm, bulb[i]) -- Pullout
				end
			else
				for i = 1, self:Clip1() do
					ParticleEffectAttach( lightpcf, PATTACH_POINT_FOLLOW, vm, bulb[i])
				end
			end
			if self:Clip1() > 0 then
				ParticleEffectAttach( lightpcf, PATTACH_POINT_FOLLOW, vm, 5)
			end
		end,
		[9061] = function()
			vm:StopParticles()
			if self.Ispackapunched then
				for i = 1, math.Round(self:Clip1()/2) do
					ParticleEffectAttach( lightpcf, PATTACH_POINT_FOLLOW, vm, bulb[i])
				end
				ParticleEffectAttach( "tesla_mflash_pap", PATTACH_POINT_FOLLOW, vm, 1) -- Fire
			else
				for i = 1, self:Clip1() do
					ParticleEffectAttach( lightpcf, PATTACH_POINT_FOLLOW, vm, bulb[i])
				end
				ParticleEffectAttach( "tesla_mflash", PATTACH_POINT_FOLLOW, vm, 1)
			end
			if self:Clip1() > 0 then
				ParticleEffectAttach( lightpcf, PATTACH_POINT_FOLLOW, vm, 5)
			else
				self.LoopingSound:Stop()
			end
		end,
		[9071] = function() 
			vm:StopParticles()
			for i = 1, self.LightNum do
				ParticleEffectAttach( lightpcf, PATTACH_POINT_FOLLOW, vm, bulb[i]) --Finish reloading
			end
			if self.LightNum > 0 then
				ParticleEffectAttach( lightpcf, PATTACH_POINT_FOLLOW, vm, 5)
			end
			timer.Simple(0.25, function() 
				if IsValid(self) then
					self.LoopingSound:Play()
				end
			end)
		end,
		[9081] = function() 
			vm:StopParticles()
			self.LoopingSound:Stop()
		end,
		[9091] = function() 
			ParticleEffectAttach( lightpcf, PATTACH_POINT_FOLLOW, vm, 2)
			ParticleEffectAttach( lightpcf, PATTACH_POINT_FOLLOW, vm, 3)
			ParticleEffectAttach( lightpcf, PATTACH_POINT_FOLLOW, vm, 4)
			ParticleEffectAttach( lightpcf, PATTACH_POINT_FOLLOW, vm, 5) -- First raise
			timer.Simple(0.25, function() 
				if IsValid(self) then
					self.LoopingSound:Play()
				end
			end)
		end
	}
	local getfunc = self.FuncList[event]
	if getfunc == nil then
        return
    end
	getfunc()
end

function SWEP:Think()
	BaseClass.Think(self)
	
	if self.NextWave == nil then self.NextWave = CurTime() + math.random(2, 12) end
	if CLIENT and self:Clip1() > 0 and self.NextWave < CurTime() then
		self.NextWave = CurTime() + 12
		local own = self:GetOwner()
		local vm = own:GetViewModel()

		ParticleEffectAttach( "tesla_vm_excited", PATTACH_POINT_FOLLOW, vm, 1)
		surface.PlaySound("weapons/tesla_gun/effects/effects_0"..math.random(0,2)..".mp3")
	end
end

function SWEP:OnRemove()
	if self.LoopingSound then self.LoopingSound:Stop() end
	BaseClass.OnRemove(self)
end

function SWEP:Hook_OnHolster()
	--self:StopSound("weapons/tesla_gun/wpn_tesla_idle_d.wav")
    if SERVER then
        self:CallOnClient("Hook_OnHolster")
        return
    end

    if self.LoopingSound then
        self.LoopingSound:Stop()
    end
end
--[[if self:Clip1() > 1 then
    self:EmitSound("weapons/tesla_gun/new/wpn_tesla_fire_st.mp3", 80, 100, 1, CHAN_ITEM)
else
    self:EmitSound("weapons/tesla_gun/new/wpn_tesla_fire_lst.mp3", 80, 100, 1, CHAN_ITEM)
end
self:EmitSound(self.Primary.Sound, 110, 100, 0.5, CHAN_WEAPON)]]