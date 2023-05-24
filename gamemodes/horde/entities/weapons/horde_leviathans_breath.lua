SWEP.Base							= "horde_destiny_bow_base"
SWEP.Category						= "Destiny Weapons"
SWEP.Manufacturer 					= ""
SWEP.Author							= "Delta"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= true
SWEP.PrintName						= "Leviathan's Breath"
SWEP.FlavorText						= "Cast a Shadow over the wilds of this universe. Return with glorious trophies. —Emperor Calus"
SWEP.Type 							= "Bow"
SWEP.DrawAmmo						= true
SWEP.Secondary.IronFOV				= 75
SWEP.Slot							= 3
SWEP.SlotPos						= 100
SWEP.Horde_MaxMags = 45
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/killicons/destiny_leviathans_breath.vtf")
    killicon.Add("horde_leviathans_breath", "vgui/killicons/destiny_leviathans_breath", Color(255, 255, 255, 255))
end

SWEP.FiresUnderwater 				= true
SWEP.Primary.Spread = 0.07
SWEP.Primary.SpreadShake = 0.01 --when shaking
SWEP.Primary.Velocity = 150 --velocity in m/s
SWEP.Primary.Damage_Charge = {0.25, 1.35} --velocity/damage multiplier between min and max charge
SWEP.Primary.Shake = true --enable shaking
SWEP.Primary.ShakeIntensity = 3 --how much to shake
--options
SWEP.Secondary.Cancel = false --enable cancelling
--bow base shit
SWEP.ChargeRate = .328 --1 is fully charged
SWEP.ChargeThreshold = 0.1 --minimum charge percent to fire
SWEP.ShakeTime = 10 --minimum time to start shaking
SWEP.Secondary.IronSightsEnabled = true
--tfa ballistics integration
SWEP.UseBallistics = true
SWEP.BulletModel = "models/weapons/w_tfa_arrow.mdl"
//SWEP.BulletTracer = "d2_bullet_trail_arc"
SWEP.ImpactParticle = nil


SWEP.Primary.AmmoConsumption = 1
SWEP.Primary.NumShots = 1
game.AddAmmoType( {
	name = "ammo_lev_breath",
	dmgtype = DMG_BLAST,
} )
SWEP.Primary.ClipSize				= 1
SWEP.Primary.DefaultClip			= 15
SWEP.Primary.Ammo					= "ammo_lev_breath"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 40000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.ChargedSound 			= Sound ("TFA_LEVIATHANSBREATH_FIRE.1")
SWEP.Primary.UnchargedSound 		= Sound ("TFA_LEVIATHANSBREATH_DRYFIRE.1")
SWEP.Primary.DrawSound 				= Sound ("TFA_LEVIATHANSBREATH_DRAW.1")
SWEP.IronInSound 					= Sound ("TFA_LEVIATHANSBREATH_IRONIN.1")
SWEP.IronOutSound 					= Sound ("TFA_LEVIATHANSBREATH_IRONOUT.1")

SWEP.Primary.PenetrationMultiplier 	= 2
SWEP.Primary.Damage					= 155
SWEP.Primary.Knockback = 10
SWEP.DisableChambering = true

SWEP.IronRecoilMultiplier			= 0.8
SWEP.CrouchRecoilMultiplier			= 0.85
SWEP.JumpRecoilMultiplier			= 2
SWEP.WallRecoilMultiplier			= 1.1
SWEP.ChangeStateRecoilMultiplier	= 1.2
SWEP.CrouchAccuracyMultiplier		= 0.8
SWEP.ChangeStateAccuracyMultiplier	= 1
SWEP.JumpAccuracyMultiplier			= 10
SWEP.WalkAccuracyMultiplier			= 1.8
SWEP.NearWallTime 					= 0.5
SWEP.ToCrouchTime 					= 0.25
SWEP.WeaponLength 					= 35
SWEP.SprintFOVOffset 				= 2

SWEP.ViewModel						= "models/weapons/LeviathansBreath/c_Leviathans_Breath.mdl"
--SWEP.WorldModel						= "models/weapons/c_thorn.mdl"
SWEP.ViewModelFOV					= 58
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "smg"
SWEP.ReloadHoldTypeOverride 		= "smg"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= false
SWEP.BlowbackVector 				= Vector(0, -2, 0)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 1
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= true
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= "None"

SWEP.ImpactEffect 					= "impact"
SWEP.MuzzleAttachment            = "muzzle"

SWEP.VMPos = Vector(0, -7, 0)
SWEP.VMAng = Vector(0, 0, 0)
SWEP.VMPos_Additive = false -- Set to false for an easier time using VMPos. If true, VMPos will act as a constant delta ON TOP OF ironsights, run, whateverelse

SWEP.CrouchPos = SWEP.VMPos
SWEP.CrouchAng = SWEP.VMAng

SWEP.IronSightTime 					= 0.5
SWEP.Primary.KickUp					= -1
SWEP.Primary.KickDown				= -1
SWEP.Primary.KickHorizontal			= 0.4
SWEP.Primary.StaticRecoilFactor 	= 0.5
SWEP.Primary.IronAccuracy 			= 0.001
SWEP.Primary.SpreadMultiplierMax 	= 1.5
SWEP.Primary.SpreadIncrement 		= 0.35
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.RegularMoveSpeedMultiplier     = .85
SWEP.AimingDownSightsSpeedMultiplier = 0.75

SWEP.IronSightsPos = Vector(-4.85, -15, 6.3)
SWEP.IronSightsAng = Vector(0, -4.901, -78)

SWEP.RunSightsPos = Vector(4, -7, 0)
SWEP.RunSightsAng = Vector(-10, 10, 10)

SWEP.InspectPos = Vector(-2.412, -12.865, -9.447)
SWEP.InspectAng = Vector(30.25, 4.925, -12.664)


-- SWEP.SequenceTimeOverride      = {
-- 	["drawarrow"] = SWEP.ChargeRate,
-- 	["drawarrowiron"] = SWEP.ChargeRate
-- }
SWEP.SequenceRateOverride= { 
	[ACT_VM_PRIMARYATTACK] = 1,
	[ACT_VM_HOLSTER] = 0.7,
	[ACT_VM_DRAW] = 0.7,
	["drawarrow"] = .95
}

SWEP.StatCache_Blacklist = {
	["SequenceLengthOverride"] = true,
	["SequenceTimeOverride"] = true
}
 

--animation
SWEP.BowAnimations = {
	-- ["shake"] = {
	-- 	["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
	-- 	["value"] = "tiredloop",
	-- 	["enabled"] = true --Manually force a sequence to be enabled
	-- },
	["idle_charged"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, 
		["value"] = "idle_charged", 
		["enabled"] = true 
	},
	["shoot"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "fire_1",
		["enabled"] = true --Manually force a sequence to be enabled
	},
	["cancel"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "cancelarrow",
		["enabled"] = true --Manually force a sequence to be enabled
	},
	["draw"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "drawarrow",
		["enabled"] = true --Manually force a sequence to be enabled
	}
}

SWEP.EventTable = {
	[ACT_VM_DRAW] = {															
		{ ["time"] = 0.1, ["type"] = "sound", ["value"] = Sound("TFA_LEVIATHANSBREATH_DEPLOY.1") }
	},
	[ACT_VM_PRIMARYATTACK] = {															
		{ ["time"] = 0.8, ["type"] = "sound", ["value"] = Sound("TFA_LEVIATHANSBREATH_RELOAD.1") }
	}
}

SWEP.Attachments = {
	-- [3] = { offset = { 0, 0 }, atts = { "d2mp_sprint_grip", "d2mp_freehand_grip", "d2mp_icarus_grip", }, order = 3 },
	-- [4] = { offset = { 0, 0 }, atts = { "d2mp_fire_rounds", "d2mp_explosive_rounds"}, order = 4 },
	-- [5] = { offset = { 0, 0 }, atts = { "d2mp_quick_access_sling", "d2mp_counterbalance" }, order = 5 },
	-- [6] = { offset = { 0, 0 }, atts = { "d2mp_dragonfly_spec" }, order = 6 },
}

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0,0,0), angle = Angle(0,0,0) },
	["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0,0,0), angle = Angle(0,0,0) }
}


SWEP.VElements = {
	["reticle"] = { type = "Model", model = "models/hunter/plates/plate1x1.mdl", bone = "Pedestal", rel = "", pos = Vector(7.28,-10, 0.038), angle = Angle(0, 0, -90), size = Vector(.004, .004, 0), color = Color(255, 255, 255, 255), surpresslightning = false, material = "reticle/destiny2_reddot_square", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["world"] = { type = "Model", model = SWEP.ViewModel, bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-19, 5.7, -3.8), angle = Angle(0, 0, 90), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = { [1] = 0 } }
}

SWEP.CustomBulletCallback = function(attacker, trace, dmginfo)
	if ( trace.HitSky ) then return end
	if dmginfo:GetInflictor():GetNWFloat("ChargeFinal") < 0.9 then return end

	if SERVER then
		//PrintMessage(HUD_PRINTTALK, dmginfo:GetInflictor():GetNWFloat("ChargeFinal"))
		local blast = ents.Create("horde_leviathans_breath_blast")
		blast:SetOwner(attacker)
		blast:SetPos(trace.HitPos)
		blast:SetAngles(attacker:EyeAngles())
		blast:Spawn()
		phys = blast:GetPhysicsObject()
		
	end
end
SWEP.DontThrowArrow = true
SWEP.BowChargeMat = Material("models/LeviathansBreath/LeviathansBreathcharge")

DEFINE_BASECLASS( SWEP.Base )

function SWEP:SetupDataTables(...)
	self:SetNWFloat("ChargeFinal", 0)
	BaseClass.SetupDataTables(self, ...)
end

function SWEP:Think2(...)
	
	self.Bodygroups_V["String"] = self:GetIronSightsProgress() < 0.75 and 0 or 1
	if CLIENT then
		self.ViewModelBoneMods["ValveBiped.Bip01_R_Finger0"].angle = Angle(self:GetIronSightsProgress()*-20,self:GetIronSightsProgress()*20,0)
		//self.ViewModelBoneMods["ValveBiped.Bip01_R_Clavicle"].angle = Angle(self:GetIronSightsProgress()*-20,self:GetIronSightsProgress()*20,0)

		self.VElements["reticle"].color = Color(255, 255, 255, self:GetIronSightsProgress()*255)
	end

	local remap = math.Remap(math.Clamp(self:GetCharge(), 0, 1), 0, 1, 0, -0.3)
	self.BowChargeMat:SetVector("$translate", Vector(remap, 0, 0))
	self.BowChargeMat:SetVector("$color2", LerpVector(math.Clamp(self:GetCharge(), 0, 1), Vector(1, 0, 0), Vector(0.5, 1, 0.5)))

	return BaseClass.Think2(self, ...)
end

function SWEP:Shoot(...)
	self:SetNWFloat("ChargeFinal", self:GetCharge())

	self:StopSound(self:GetStatL("Primary.DrawSound"))
	if self:GetStatL("Primary.ChargedSound") and IsFirstTimePredicted()  and not ( sp and CLIENT ) then
		if self:GetCharge() >= 0.9 then
			self:EmitSound(self:GetStatL("Primary.ChargedSound"))
		else
			self:EmitSound(self:GetStatL("Primary.UnchargedSound"))
		end
	end

	self:TakePrimaryAmmo(self:GetStatL("Primary.AmmoConsumption"))
	self:PlayAnimation(self.BowAnimations.shoot)
	self:ShootBulletInformation()
	self:SetCharge(0)
	self:SetShaking(false)
	local rate = 1 / self:GetAnimationRate(self:GetLastSequence())
	self:ScheduleStatus(TFA.Enum.STATUS_BOW_SHOOT, 0.1 * rate)
	local length = self:GetActivityLength() * rate
	self:ScheduleStatus(TFA.Enum.STATUS_RELOADING, length - (length * 0.25))
	self:SetDrawing(false)
end

local ballistics_distcv = GetConVar("sv_tfa_ballistics_mindist")

local function BallisticFirebullet(ply, bul, ovr)
	local wep = ply:GetActiveWeapon()

	if TFA.Ballistics and TFA.Ballistics:ShouldUse(wep) then
		if ballistics_distcv:GetInt() == -1 or ply:GetEyeTrace().HitPos:Distance(ply:GetShootPos()) > (ballistics_distcv:GetFloat() * TFA.Ballistics.UnitScale) then
			bul.SmokeParticle = bul.SmokeParticle or wep.BulletTracer or wep.TracerBallistic or wep.BallisticTracer or wep.BallisticsTracer

			if ovr then
				TFA.Ballistics:FireBullets(wep, bul, angle_zero, true)
			else
				TFA.Ballistics:FireBullets(wep, bul)
			end
		else
			ply:FireBullets(bul)
		end
	else
		ply:FireBullets(bul)
	end
end

local cv_forcemult = GetConVar("sv_tfa_force_multiplier")

function SWEP:ShootBullet(damage, recoil, num_bullets, aimcone, disablericochet, bulletoverride)
	if not IsFirstTimePredicted() and not game.SinglePlayer() then return end
	local chargeTable = self:GetStatL("Primary.Damage_Charge")
	local mult = Lerp(math.Clamp(self:GetCharge() - self.ChargeThreshold, 0, 1 - self.ChargeThreshold) / (1 - self.ChargeThreshold), chargeTable[1], chargeTable[2])
	local unitScale = TFA.Ballistics.UnitScale or TFA.UnitScale or 40
	num_bullets = num_bullets or 1
	aimcone = aimcone or 0
	self.MainBullet.Attacker = self:GetOwner()
	self.MainBullet.Inflictor = self
	self.MainBullet.Num = num_bullets
	self.MainBullet.Src = self:GetOwner():GetShootPos()
	self.MainBullet.Dir = self:GetOwner():EyeAngles():Forward()
	self.MainBullet.HullSize = 2
	self.MainBullet.Spread.x = aimcone
	self.MainBullet.Spread.y = aimcone

	if self.TracerPCF then
		self.MainBullet.Tracer = 0
	else
		self.MainBullet.Tracer = self:GetStatL("TracerCount") or 3
	end

	self.MainBullet.PenetrationCount = 1
	self.MainBullet.AmmoType = self:GetPrimaryAmmoType()
	self.MainBullet.Force = self:GetStatL("Primary.Force") * cv_forcemult:GetFloat() * self:GetAmmoForceMultiplier() * mult
	self.MainBullet.Damage = damage * mult
	self.MainBullet.HasAppliedRange = true
	self.MainBullet.Velocity = self:GetStatL("Primary.Velocity") * mult * unitScale

	self.MainBullet.Callback = function(a, b, c)
		if IsValid(self) then
			c:SetInflictor(self)
			c:SetDamageType(DMG_BLAST)
		end

		if self.MainBullet.Callback2 then
			self.MainBullet.Callback2(a, b, c)
		end

		if self.CustomBulletCallback then
			self.MainBullet.Callback2 = self.CustomBulletCallback
		else
			self.MainBullet.Callback2 = nil
		end
	

		self:CallAttFunc("CustomBulletCallback", a, b, c)

		if SERVER and IsValid(a) and a:IsPlayer() and IsValid(b.Entity) and (b.Entity:IsPlayer() or b.Entity:IsNPC() or type(b.Entity) == "NextBot") then
			self:SendHitMarker(a, b, c)
		end
		--if !self.DontThrowArrow then
		--	AttachArrowModel(a, b, c, self)
		--end
	end

	BallisticFirebullet(self:GetOwner(), self.MainBullet)
end
