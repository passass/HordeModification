SWEP.Gun							= ("rw_sw_dc15a")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "horde_tfa_gun_base"
SWEP.Category						= "Destiny Weapons"
SWEP.Manufacturer 					= ""
SWEP.Author							= "Delta"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "Deathbringer"
SWEP.Type							= "Sing them a lullaby of death and nothing more."
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 1
SWEP.Secondary.IronFOV				= 70
SWEP.Slot							= 2
SWEP.SlotPos						= 100

SWEP.FiresUnderwater 				= true

SWEP.IronInSound 					= nil
SWEP.IronOutSound 					= nil
SWEP.CanBeSilenced					= false
SWEP.Silenced 						= false
SWEP.DoMuzzleFlash 					= true
SWEP.SelectiveFire					= false
SWEP.DisableBurstFire				= true
SWEP.OnlyBurstFire					= false
SWEP.DefaultFireMode 				= nil
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 1
SWEP.Primary.DefaultClip			= 20
SWEP.Primary.RPM					= 15
game.AddAmmoType( {
	name = "ammo_deathbringer",
	dmgtype = DMG_BLAST,
} )
SWEP.Primary.Ammo					= "ammo_deathbringer"
if SERVER then
	for k, v in pairs(game.GetAmmoTypes()) do
		if (v == "d2_heavy") then
			print("Destiny 2 Ammo Types detected: Changing default ammo to Heavy")
			SWEP.Primary.Ammo = "d2_heavy"
		end
	end
end

SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 40000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= false
SWEP.Primary.RPM_Semi				= 150
SWEP.Primary.Delay				    = 0
SWEP.Primary.Sound 					= Sound ("TFA_DEATHBRINGER_FIRE.1");
SWEP.Primary.ReloadSound 			= Sound ("TFA_DEATHBRINGER_RELOAD.1");
SWEP.Primary.PenetrationMultiplier 	= 1
SWEP.Primary.Damage					= 100
SWEP.Primary.HullSize 				= 1
SWEP.DamageType 					= DMG_GENERIC
SWEP.Knockback = 10

SWEP.DoMuzzleFlash 					= true

SWEP.FireModes = {
	"FullAuto",
}


SWEP.IronRecoilMultiplier			= 0.75
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
if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/killicons/destiny_deathbringer.vtf")
    killicon.Add("horde_deathbringer", "vgui/killicons/destiny_deathbringer", Color(255, 255, 255, 255))
end
SWEP.Horde_MaxMags = 20
--[[PROJECTILES]]--
SWEP.Primary.ProjectileDelay = 0 --Entity to shoot
SWEP.Primary.Projectile = "horde_deathbringer_projectile" --Entity to shoot
SWEP.Primary.ProjectileVelocity = 1000  --Entity to shoot's velocity
SWEP.Primary.ProjectileModel = nil --Entity to shoot's model


SWEP.ViewModel						= "models/weapons/c_deathbringer.mdl"
--SWEP.WorldModel						= "models/weapons/c_thorn.mdl"
SWEP.ViewModelFOV					= 54
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "smg"
SWEP.ReloadHoldTypeOverride 		= "smg"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= false
SWEP.BlowbackVector 				= Vector(0, math.random(-6, -7), 0)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 1.3
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= true
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= "None"

SWEP.Tracer							= 0
SWEP.TracerName 					= ""
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0
SWEP.ImpactEffect 					= "impact"


SWEP.VMPos = Vector(0, 0, 0)
SWEP.VMAng = Vector(0, 0, 0)

SWEP.IronSightTime 					= 0.4
SWEP.Primary.KickUp					= 0.8
SWEP.Primary.KickDown				= 0.8
SWEP.Primary.KickHorizontal			= 0.2
SWEP.Primary.StaticRecoilFactor 	= 0.6
SWEP.Primary.Spread					= 0.09
SWEP.Primary.IronAccuracy 			= 0.005
SWEP.Primary.SpreadMultiplierMax 	= 1.5
SWEP.Primary.SpreadIncrement 		= 0.35
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 0.85
SWEP.IronSightsMoveSpeed 			= 0.75

SWEP.IronSightsPos = Vector(-4.1735, -12.462, 1.706)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(5.226, -2, 0)
SWEP.RunSightsAng = Vector(-18, 36, -13.5)
SWEP.InspectPos = Vector(3.417, -6.633, -2.211)
SWEP.InspectAng = Vector(18.995, 28.141, 8.442)

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_Spine4"] = { scale = Vector(1, 1, 1), pos = Vector(0.925, -0.556, 0.925), angle = Angle(0, 0, 0) }
}

SWEP.WElements = {
	["world"] = { type = "Model", model = "models/weapons/c_deathbringer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-15.065, 7.791, -5.715), angle = Angle(-12.858, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.ThirdPersonReloadDisable		= false
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "" 
SWEP.Secondary.ScopeZoom 			= 3
SWEP.ScopeReticule_Scale 			= {0.875,0.875}
if surface then
	SWEP.Secondary.ScopeTable = nil --[[
		{
			scopetex = surface.GetTextureID("scope/gdcw_closedsight"),
			reticletex = surface.GetTextureID("scope/gdcw_acogchevron"),
			dottex = surface.GetTextureID("scope/gdcw_acogcross")
		}
	]]--
end

DEFINE_BASECLASS( SWEP.Base )

function SWEP:Initialize(...)
	self:ClearStatCache("Primary.Ammo")
	return BaseClass.Initialize(self, ...)
end

function SWEP:ShootBullet()
	if SERVER then
		timer.Simple( 0, function()
			if ( not IsValid(self) ) or ( not self:OwnerIsValid() ) then return end
			local aimcone = 0--self:CalculateConeRecoil()
			local ent = ents.Create(self:GetStat("Primary.Projectile"))
			local dir
			local ang = self.Owner:EyeAngles()
			local attachmentID=self:LookupAttachment("muzzle");
  			//PrintTable(self:GetAttachment(attachmentID))
			dir = ang:Forward()
			ent:SetPos(self.Owner:GetShootPos() + ang:Forward() + ang:Right()*17)
			ent.Owner = self.Owner
			//ent:SetAngles(self.Owner:EyeAngles())
			ent.damage = self:GetStat("Primary.Damage")
			ent.mydamage = self:GetStat("Primary.Damage")
			local trail = util.SpriteTrail(ent, 0, Color(162,0,255,200), true, 13, 2, .5, 1/(15+1)*0.5, "trails/smoke.vmt")
			if self:GetStat("Primary.ProjectileModel") then
				ent:SetModel(self:GetStat("Primary.ProjectileModel"))
			end

			ent:Spawn()
			ent:SetVelocity(dir * self:GetStat("Primary.ProjectileVelocity"))
			local phys = ent:GetPhysicsObject()

			if IsValid(phys) then
				phys:SetVelocity(dir * self:GetStat("Primary.ProjectileVelocity"))
				phys:EnableGravity( false )
				phys:EnableDrag(false)
			end

			if self.ProjectileModel then
				ent:SetModel(self:GetStat("Primary.ProjectileModel"))
			end

			ent:SetOwner(self.Owner)
			ent.Owner = self.Owner
			ent.WeaponClass = self:GetClass()
		end)
	end
end
