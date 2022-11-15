SWEP.Base							= "horde_tfa_gun_base"
SWEP.Category						= "Destiny Weapons"
SWEP.Manufacturer 					= ""
SWEP.Author							= "Delta"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "Xenophage"
SWEP.Type							= "This might sting a little."
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 1
SWEP.Secondary.IronFOV				= 70
SWEP.Slot							= 2
SWEP.SlotPos						= 100

game.AddParticles( "particles/xenophage_muzzle.pcf" )
PrecacheParticleSystem( "Xenophage_muzzle" )
PrecacheParticleSystem( "Xenophage_muzzle_Glow" )


if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/killicons/destiny_xenophage.vtf")
    killicon.Add("horde_xenophage", "vgui/killicons/destiny_xenophage", Color(255, 255, 255, 255))
end

SWEP.Rarity = "Exotic"

SWEP.FiresUnderwater 				= true

SWEP.IronInSound 					= Sound ("TFA_XENOPHAGE_IRONIN.1");
SWEP.IronOutSound 					= Sound ("TFA_XENOPHAGE_IRONOUT.1");
SWEP.CanBeSilenced					= false
SWEP.Silenced 						= false
SWEP.DoMuzzleFlash 					= true
SWEP.SelectiveFire					= false
SWEP.DisableBurstFire				= true
SWEP.OnlyBurstFire					= false
SWEP.DefaultFireMode 				= nil
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true
game.AddAmmoType( {
	name = "ammo_xenophage",
	--dmgtype = DMG_BLAST,
} )
SWEP.Primary.ClipSize				= 13
SWEP.Primary.DefaultClip			= 100
SWEP.Primary.RPM					= 120
SWEP.Primary.Ammo					= "ammo_xenophage"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 40000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= 150
SWEP.Primary.Delay				    = 0
SWEP.Primary.Sound 					= Sound ("TFA_XENOPHAGE_FIRE.1");
SWEP.Primary.ReloadSound 			= Sound ("TFA_XENOPHAGE_RELOAD.1");


SWEP.Primary.PenetrationMultiplier 	= .8
SWEP.MaxPenetrationCounter = 4 -- The maximum number of ricochets.  To prevent stack overflows.
SWEP.Primary.Damage					= 150
SWEP.Primary.HullSize 				= 3
SWEP.DamageType 					= DMG_BLAST
SWEP.Primary.DamageTypeHandled = false
SWEP.Knockback = 1

SWEP.DoMuzzleFlash 					= true
SWEP.MuzzleFlashEffect 				= "tfa_muzzleflash_rifle"

SWEP.IronRecoilMultiplier			= 0.9
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
SWEP.ProjectileVelocity 			= 9

SWEP.ProjectileEntity 				= nil
SWEP.ProjectileModel 				= nil


SWEP.ViewModel						= "models/weapons/c_xenophage.mdl"
--SWEP.WorldModel						= "models/weapons/c_thorn.mdl"
SWEP.ViewModelFOV					= 58
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "ar2"
SWEP.ReloadHoldTypeOverride 		= "ar2"
SWEP.Primary.BlastRadius = 0
SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(0, math.random(-1, -3), 0)
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
--SWEP.ImpactEffect 					= "impact"

SWEP.IronSightTime 					= 0.4
SWEP.Primary.KickUp					= 0.7
SWEP.Primary.KickDown				= 0.7
SWEP.Primary.KickHorizontal			= 0.33
SWEP.Primary.StaticRecoilFactor 	= 0.55
SWEP.Primary.Spread					= 0.01
SWEP.Primary.IronAccuracy 			= 0.006
SWEP.Primary.SpreadMultiplierMax 	= 1.5
SWEP.Primary.SpreadIncrement 		= 0.35
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= .8
SWEP.IronSightsMoveSpeed 			= 0.75

SWEP.AllowIronSightsDoF = false

SWEP.IronSightsPos = Vector(-7.3, -16, -1)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(5.226, -2, 0)
SWEP.RunSightsAng = Vector(-18, 36, -13.5)
SWEP.InspectPos = Vector(7.638, -9.046, -5.628)
SWEP.InspectAng = Vector(26.03, 26.03, 14.069)

SWEP.VMPos = Vector(-.6, -2.8, -.4) -- The viewmodel positional offset, constantly.  Subtract this from any other modifications to viewmodel position.
SWEP.VMAng = Vector(1, .5, 0) -- The viewmodel angular offset, constantly.   Subtract this from any other modifications to viewmodel angle.
SWEP.VMPos_Additive = false -- Set to false for an easier time using VMPos. If true, VMPos will act as a constant delta ON TOP OF ironsights, run, whateverelse

SWEP.CrouchPos =  Vector(-.5, -2.8, .4)
SWEP.CrouchAng = Vector(1.2, .5, 0)

SWEP.MuzzleAttachment           = "muzzle"       -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellAttachment            = "shell"       -- Should be "2" for CSS models or "shell" for hl2 models

SWEP.LuaShellEject = true -- Enable shell ejection through lua?
SWEP.LuaShellScale = 1 -- The model scale to use for ejected shells
SWEP.LuaShellYaw = nil -- The model yaw rotation ( relative ) to use for ejected shells

SWEP.ViewModelBoneMods = { //Chain bones, just was too lazy to rename the vertex groups
	//["Pelvis"] = { scale = Vector(1, 1, 1), pos = Vector(-.5, -0.25, 0), angle = Angle(0, 0, 0) }, 
	["Thigh.L"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }, 
	["Thigh.R"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Spine_1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Calf.L"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Calf.R"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 3) },
	["Spine_2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 3) },
	["Foot.L"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Foot.R"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Spine_3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	//["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-9.223, 6.11, 0) }
}

SWEP.WElements = {
	["world"] = { type = "Model", model = SWEP.ViewModel, bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-12.3, 7, -4.5), angle = Angle(-12.5, 1, 180), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = { [1] = 0 } }
}

SWEP.ThirdPersonReloadDisable		= false
SWEP.Idle_Mode = TFA.Enum.IDLE_BOTH -- TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
SWEP.Idle_Blend = 0.5 -- Start an idle this far early into the end of a transition
SWEP.Idle_Smooth = 0.1 -- Start an idle this far early into the end of another animation

SWEP.Walk_Mode = TFA.Enum.LOCOMOTION_HYBRID -- LOCOMOTION_ANI = mdl, LOCOMOTION_HYBRID = ani + lua, LOCOMOTION_LUA = lua only

SWEP.WalkAnimation = {
	
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, -- Sequence or act
		["value"] = "walk", -- Number for act, String/Number for sequence
		["is_idle"] = true
	}
}

SWEP.EventTable = {
	[ACT_VM_RELOAD] = {
																				
		{ ["time"] = 1, ["type"] = "lua", ["value"] = function( wep, viewmodel, ifp ) wep:ResetBones() end, ["client"] = true, ["server"] = true}
	},
	[ACT_VM_DRAW] = {															
		{ ["time"] = 0, ["type"] = "sound", ["value"] = Sound("TFA_XENOPHAGE_DRAW.1") }
	}
}

SWEP.SequenceRateOverride= { 
	[ACT_VM_RELOAD] = 1.12,
	[ACT_VM_DRAW] = .5,
	[ACT_VM_HOLSTER] = .8,
}

DEFINE_BASECLASS( SWEP.Base )

function SWEP:Think2(...)
	if CLIENT then
		--[[
		local fadein = math.Clamp(self:GetIronSightsProgress(), 0, .3)
		if self:GetIronSights() then
			self.VElements["reticle"].color = Color(255, 255, 255, (255*self:GetIronSightsProgress()))
		else
			self.VElements["reticle"].color = Color(255, 255, 255, 0)
		end]]
	end
	if CLIENT then
		if self:GetStatus() != TFA.GetStatus("reloading") then
			if self:Clip1() > 9 then
				self.ViewModelBoneMods["Thigh.L"].scale = Vector(1, 1, 1)
				self.ViewModelBoneMods["Thigh.R"].scale = Vector(1, 1, 1)
				self.ViewModelBoneMods["Spine_1"].scale = Vector(1, 1, 1)
				self.ViewModelBoneMods["Calf.L"].scale = Vector(1, 1, 1)
				self.ViewModelBoneMods["Calf.R"].scale = Vector(1, 1, 1)
				self.ViewModelBoneMods["Spine_2"].scale = Vector(1, 1, 1)
				self.ViewModelBoneMods["Foot.L"].scale = Vector(1, 1, 1)
				self.ViewModelBoneMods["Foot.R"].scale = Vector(1, 1, 1)
				self.ViewModelBoneMods["Spine_3"].scale = Vector(1, 1, 1)
			end

			if self:Clip1() <= 8 then
				self.ViewModelBoneMods["Spine_3"].scale = Vector(0, 0, 0)
			end
			if self:Clip1() <= 7 then
				self.ViewModelBoneMods["Foot.R"].scale = Vector(0, 0, 0)
			end
			if self:Clip1() <= 6 then
				self.ViewModelBoneMods["Foot.L"].scale = Vector(0, 0, 0)
			end
			if self:Clip1() <= 5 then
				self.ViewModelBoneMods["Spine_2"].scale = Vector(0, 0, 0)
			end
			if self:Clip1() <= 4 then
				self.ViewModelBoneMods["Calf.R"].scale = Vector(0, 0, 0)		
			end
			if self:Clip1() <= 3 then
				self.ViewModelBoneMods["Calf.L"].scale = Vector(0, 0, 0)
			end
			if self:Clip1() <= 2 then
				self.ViewModelBoneMods["Spine_1"].scale = Vector(0, 0, 0)				
			end
			if self:Clip1() <= 1 then
				self.ViewModelBoneMods["Thigh.R"].scale = Vector(0, 0, 0)				
			end
			if self:Clip1() <= 0 then
				self.ViewModelBoneMods["Thigh.L"].scale = Vector(0, 0, 0)
			end
			
		end
	end
	return BaseClass.Think2(self, ...)
end

function SWEP:PrePrimaryAttack() print("asd")
	self:ExplosiveBullets()
end

function SWEP:ExplosiveBullets()
	local tr = self.Owner:GetEyeTrace()
	print("explosion")
	util.BlastDamage(self.Owner, self.Owner, tr.HitPos, 100, 120)
	ParticleEffectAttach("tfa_muzzle_sniper", 4, self.OwnerViewModel, self.OwnerViewModel:LookupAttachment("muzzle"))
	ParticleEffectAttach("Xenophage_muzzle", 4, self.OwnerViewModel, self.OwnerViewModel:LookupAttachment("muzzle"))
	--[[
	local explode = ents.Create( "env_explosion" ) -- creates the explosion
	explode:SetPos( tr.HitPos ) -- this creates the explosion where you were looking
	explode:SetOwner( self.Owner ) -- this sets you as the person who made the explosion
	explode:Spawn() -- this actually spawns the explosion
	explode:SetKeyValue( "iMagnitude", "35" ) -- the magnitude
	explode:Fire( "Explode", 0, 0 )
	--explode:EmitSound( "weapon_AWP.Single", 0, 0 )
	]]
end

function SWEP:PostReload(released)
	self:ResetBones()
end

function SWEP:ResetBones()
	if CLIENT then
		self.ViewModelBoneMods["Thigh.L"].scale = Vector(1, 1, 1)
		self.ViewModelBoneMods["Thigh.R"].scale = Vector(1, 1, 1)
		self.ViewModelBoneMods["Spine_1"].scale = Vector(1, 1, 1)
		self.ViewModelBoneMods["Calf.L"].scale = Vector(1, 1, 1)
		self.ViewModelBoneMods["Calf.R"].scale = Vector(1, 1, 1)
		self.ViewModelBoneMods["Spine_2"].scale = Vector(1, 1, 1)
		self.ViewModelBoneMods["Foot.L"].scale = Vector(1, 1, 1)
		self.ViewModelBoneMods["Foot.R"].scale = Vector(1, 1, 1)
		self.ViewModelBoneMods["Spine_3"].scale = Vector(1, 1, 1)
	end
end


function SWEP:DoImpactEffect( tr, nDamageType )

	if ( tr.HitSky ) then return end -- Do not draw effects vs. the sky.
	ParticleEffect("hl2mmod_muzzleflash_rpg", tr.HitPos, Angle(-90, 0, 0), self)
	--print("ads")
	return false

end
