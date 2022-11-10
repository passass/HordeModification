SWEP.Base							= "horde_tfa_gun_base"
SWEP.Category						= "ArcCW - Horde"
SWEP.Manufacturer 					= ""
SWEP.Author							= "Delta"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "Gjallarhorn"
SWEP.Type							= "'If there is beauty in destruction, why not also in its delivery?' - Feizel Crux"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 1
SWEP.Secondary.IronFOV				= 60
SWEP.Slot							= 4
SWEP.SlotPos						= 100

SWEP.Rarity = "Exotic"
SWEP.DisableLUT = true

SWEP.FiresUnderwater 				= true

SWEP.IronInSound 					= nil
SWEP.IronOutSound 					= nil
SWEP.CanBeSilenced					= false
SWEP.DisableChambering 				= true
SWEP.SelectiveFire = false -- Allow selecting your firemode?

if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/killicons/destiny_gjallarhorn.vtf")
    killicon.Add("horde_gjallarhorn", "vgui/killicons/destiny_gjallarhorn", Color(255, 255, 255, 255))
end

SWEP.Primary.ClipSize				= 1
SWEP.Primary.DefaultClip			= 3
SWEP.Primary.RPM					= 50
SWEP.Primary.Ammo					= "RPG_Round"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 40000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.Delay				    = 0
SWEP.Primary.Sound 					= Sound ("TFA_GHORN_FIRE.1")
SWEP.Primary.ReloadSound 			= Sound ("TFA_GHORN_RELOAD.1")
SWEP.Primary.PenetrationMultiplier 	= 1
SWEP.Primary.Damage					= 180
SWEP.Primary.HullSize 				= 1
SWEP.DamageType 					= DMG_BLAST

SWEP.Horde_MaxMags = 35

-- PROJECTILES
SWEP.Primary.Projectile = "horde_ghorn_rocket" -- Entity to shoot
SWEP.Primary.ProjectileVelocity = 50000 -- Entity to shoot's velocity
SWEP.Primary.ProjectileModel = nil -- Entity to shoot's model


SWEP.DoMuzzleFlash 					= true
SWEP.MuzzleFlashEffect 				= "tfa_muzzleflash_rifle"

SWEP.IronRecoilMultiplier			= 0.5
SWEP.CrouchRecoilMultiplier			= 0.85
SWEP.JumpRecoilMultiplier			= 2
SWEP.WallRecoilMultiplier			= 1.1
SWEP.ChangeStateRecoilMultiplier	= 1.2
SWEP.CrouchAccuracyMultiplier		= 0.8
SWEP.ChangeStateAccuracyMultiplier	= 1
SWEP.JumpAccuracyMultiplier			= 10
SWEP.WalkAccuracyMultiplier			= 1.5
SWEP.NearWallTime 					= 0.5
SWEP.SprintFOVOffset 				= 2

SWEP.ViewModel						= "models/weapons/gjallarhorn/c_gjallarhorn.mdl"
--SWEP.WorldModel						= "models/weapons/c_thorn.mdl"
SWEP.ViewModelFOV					= 58
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "smg"
SWEP.ReloadHoldTypeOverride 		= "ar2"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(0, -2, 0)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 1
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= true
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= "None"

SWEP.Tracer							= 0
SWEP.TracerName 					= nil
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0
SWEP.ImpactEffect 					= "impact"

SWEP.IronSightTime 					= 0.4
SWEP.Primary.KickUp					= 1
SWEP.Primary.KickDown				= .7
SWEP.Primary.KickHorizontal			= 0.5
SWEP.Primary.StaticRecoilFactor 	= 0.5
SWEP.Primary.Spread					= 0.03
SWEP.Primary.IronAccuracy 			= 0.001
SWEP.Primary.SpreadMultiplierMax 	= 1.5
SWEP.Primary.SpreadIncrement 		= 0.35
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.75

SWEP.IronSightsPos = Vector(-3.73, -11, 0.231)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.RunSightsPos = Vector(5.226, -6, 0)
SWEP.RunSightsAng = Vector(-18, 36, -13.5)
SWEP.InspectPos = Vector(5.5, -5, -.8) //Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(18.291, 30.954, 17.587)

SWEP.VMPos = Vector(0, -2, -.2) -- The viewmodel positional offset, constantly.  Subtract this from any other modifications to viewmodel position.
SWEP.VMAng = Vector(.5, .5, 0) -- The viewmodel angular offset, constantly.   Subtract this from any other modifications to viewmodel angle.
SWEP.VMPos_Additive = false -- Set to false for an easier time using VMPos. If true, VMPos will act as a constant delta ON TOP OF ironsights, run, whateverelse

//SWEP.CrouchPos = Vector(-.5, -3.9, .2)
//SWEP.CrouchAng = Vector(1.5, .5, 0)

SWEP.MuzzleAttachment           = "muzzle"       -- Should be "1" for CSS models or "muzzle" for hl2 models     -- Should be "2" for CSS models or "shell" for hl2 models
SWEP.LuaShellEject = false --Enable shell ejection through lua?
//SWEP.LuaShellYaw = 180 -- The model yaw rotation ( relative ) to use for ejected shells
SWEP.EjectionSmokeEnabled = false -- Disable automatic ejection smoke

SWEP.Attachments = {
	[1] = { offset = { 0, 0 }, atts = { "irongjallarhorn" }, order = 1 }
}

SWEP.ViewModelBoneMods = {
	//["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 15, 0) },
	//["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 2, 0) },
}

SWEP.VElements = {
	["reticle"] = { type = "Model", model = "models/rtcircle.mdl", bone = "SlideBone", rel = "", pos = Vector(3.5, 6.19, 2.48), angle = Angle(0, -90, 180), size = Vector(0.349, 0.349, 0.349), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {} }
}


SWEP.WElements = {
	["world"] = { type = "Model", model = SWEP.ViewModel, bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-12, 7, -4.4), angle = Angle(-13, 0, 180), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = { [1] = 0 } }
}

SWEP.ThirdPersonReloadDisable = false

SWEP.SequenceRateOverride = {
	[ACT_VM_HOLSTER] = .8   
}

-- [[RENDER TARGET]] --
SWEP.RTDrawEnabled = true
SWEP.RTReticleMaterial = Material("reticle/GjallarhornReticle")
//SWEP.RTShadowMaterial = Material("models/tataragaze/TataraGazeReticleShadow")
SWEP.RTReticleScale = 1
SWEP.RTDotScale = .05
SWEP.RTShadowScale = 2
SWEP.RTMaterialOverride = -1 -- Take the material you want out of print(LocalPlayer():GetViewModel():GetMaterials()), subtract 1 from its index, and set it to this.
SWEP.RTOpaque = true -- Do you want your render target to be opaque?
SWEP.RTScopeFOV = 90 / 1.75 / 2 -- Default FOV / Scope Zoom / screenscale
SWEP.RTBGBlur = false -- Draw background blur when 3D scope is active?


local cd = {}

local fallbackReticle = Material("scope/gdcw_scopesightonly")
local fallbackShadow = Material("vgui/scope_shadowmask_test")

local flipcv = GetConVar("cl_tfa_viewmodel_flip")

SWEP.RTCode = function(self, rt, scrw, scrh)
	if not self.OwnerIsValid or not self:VMIV() then return end

	local rtw, rth = rt:Width(), rt:Height()
	-- clearing view
	render.OverrideAlphaWriteEnable(true, true)
	surface.SetDrawColor(color_white)
	surface.DrawRect(-rtw, -rth, rtw * 2, rth * 2)

	local vm = self.OwnerViewModel

	local ang = vm:GetAngles()
	ang:RotateAroundAxis(ang:Forward(), -self:GetStat("IronSightsAng").z)

	local scopeAtt = self:GetStat("RTScopeAttachment", -1)

	if scopeAtt > 0 then
		local AngPos = vm:GetAttachment(scopeAtt)

		if AngPos then
			ang = AngPos.Ang

			if flipcv:GetBool() then
				ang.y = -ang.y
			end
		end
	end

	cd.angles = ang
	cd.origin = self:GetOwner():GetShootPos()
	cd.x = 0
	cd.y = 0
	cd.w = rtw
	cd.h = rth
	cd.fov = self:GetStat("RTScopeFOV", 90 / self:GetStat("ScopeZoom", 1) / 2)
	cd.drawviewmodel = false
	cd.drawhud = false

	-- main RT render view
	render.Clear(0, 0, 0, 255, true, true)
	render.SetScissorRect(0, 0, rtw, rth, true)

	if self:GetIronSightsProgress() > .75 then
		
		render.RenderView(cd)
	end

	render.SetScissorRect(0, 0, rtw, rth, false)
	render.OverrideAlphaWriteEnable(false, true)

	cam.Start2D()

	-- ADS transition darkening
	draw.NoTexture()
	surface.SetDrawColor(ColorAlpha(color_black, 255 * (1 - self:GetIronSightsProgress())))
	surface.DrawRect(0, 0, rtw, rth)

	//self.RTReticleGlass:SetVector("$envmapmultiplier", Vector(1.5, 0, 0))

	surface.SetMaterial(self:GetStat("RTReticleMaterial", fallbackReticle))
	surface.SetDrawColor(self:GetStat("RTReticleColor", color_white))
	local retScale = self:GetStat("RTReticleScale", 1)
	surface.DrawTexturedRect(rtw / 2 - rtw * retScale / 2, rth / 2 - rth * retScale / 2, rtw * retScale, rth * retScale)

	surface.SetMaterial(self:GetStat("RTShadowMaterial", fallbackShadow))
	surface.SetDrawColor(self:GetStat("RTShadowColor", color_white))
	local shadScale = self:GetStat("RTShadowScale", 2)
	surface.DrawTexturedRect(rtw / 2 - rtw * shadScale / 2, rth / 2 - rth * shadScale / 2, rtw * shadScale, rth * shadScale)

	cam.End2D()
end

DEFINE_BASECLASS( SWEP.Base )

function SWEP:Initialize(...)
	self:GetOwner():SetNWEntity("destiny_ghorn_target", nil)
	self:GetOwner():SetNWEntity("destiny_ghorn_rocket", nil)
	self:SetNWInt("ghorn_lock_on_timer", 0)
	return BaseClass.Initialize(self, ...)
end

--[[
Function Name:  ShootBullet
Syntax: self:ShootBullet(damage, recoil, number of bullets, spray cone, disable ricochet, override the generated self.MainBullet table with this value if you send it).
Returns:   Nothing.
Notes:  Used to shoot a self.MainBullet.
Purpose:  Bullet
]]
--

function SWEP:ShootBullet(damage, recoil, num_bullets, aimcone, disablericochet, bulletoverride)
	if not IsFirstTimePredicted() and not game.SinglePlayer() then return end
	num_bullets = num_bullets or 1
	aimcone = aimcone or 0
	if self:GetStat("Primary.Projectile") then
		if CLIENT then return end

		//for _ = 1, num_bullets do
			local obj = self:LookupAttachment( "muzzle" )
			local muzzlepos = self:GetAttachment( obj ).Pos
			local ent = ents.Create(self:GetStat("Primary.Projectile"))
			
			local ang = self:GetOwner():GetAimVector():Angle()

			ang:RotateAroundAxis(ang:Right(), -aimcone / 2 + math.Rand(0, aimcone))
			ang:RotateAroundAxis(ang:Up(), -aimcone / 2 + math.Rand(0, aimcone))

			ent:SetOwner(self:GetOwner())
			//ent:SetPos(self:GetOwner():GetShootPos() + ang:Forward())
			ent:SetPos(self:GetOwner():GetShootPos() + ang:Forward() + ang:Right()*28+ang:Up()*-4)
			ent.EndPos = self:GetOwner():GetEyeTrace().HitPos
			ent:SetAngles(ang)
			ent.damage = self:GetStat("Primary.Damage")
			ent.mydamage = self:GetStat("Primary.Damage")

			if self:GetStat("Primary.ProjectileModel") then
				ent:SetModel(self:GetStat("Primary.ProjectileModel"))
			end

			self:PreSpawnProjectile(ent)

			ent:Spawn()
			self:GetOwner():SetNWEntity("destiny_ghorn_rocket", ent)

			local distance = self:GetOwner():GetPos():Distance(self:GetOwner():GetEyeTrace().HitPos)
			local remap = math.Remap(distance, 0, 5000, 0, 1)
			//self:GetOwner():PrintMessage(HUD_PRINTTALK, remap)
			//self:GetOwner():PrintMessage(HUD_PRINTTALK, tostring(ang:Right()))
			local dir = ang:Forward() + (ang:Right()*-.005)
			dir:Mul(self:GetStat("Primary.ProjectileVelocity"))

			//ent:SetLocalVelocity(ent:GetVelocity() + self.Owner:GetForward() * self.Owner:GetVelocity():Dot(self.Owner:GetForward()))
			ent:SetVelocity(ang:Forward())
			local phys = ent:GetPhysicsObject()

			if IsValid(phys) then
				phys:EnableGravity( false )
				phys:EnableDrag(false)
				phys:SetVelocity(dir)

			end

			if self.ProjectileModel then
				ent:SetModel(self:GetStat("Primary.ProjectileModel"))
			end

			ent:SetOwner(self:GetOwner())

			self:PostSpawnProjectile(ent)
		//end
		-- Source
		-- Dir of self.MainBullet
		-- Aim Cone X
		-- Aim Cone Y
		-- Show a tracer on every x bullets
		-- Amount of force to give to phys objects

		return
	end
end

--[[
  Returns whether the entity is a non-player-character
  @param {Entity} entity
  @return {boolean} is NPC
]]
local function IsTargetable(entity)
  return IsValid(entity) and (entity:IsNPC() or entity:IsPlayer() or (entity:IsScripted() and entity.Type == "nextbot"));
end

function SWEP:Think2(...)
	local adstimer = math.Clamp(self:GetNWInt("ghorn_lock_on_timer"), 0, 40)
	local tr =self:GetOwner():GetEyeTrace()
	if CLIENT then
		local fadein = math.Clamp(self:GetIronSightsProgress(), 0.4, .8)
		if self:GetIronSightsProgress() > .2 then
			self.VElements["reticle"].color = Color(255, 255, 255, (255*self:GetIronSightsProgress()))
		else
			self.VElements["reticle"].color = Color(255, 255, 255, 0)
		end
		if adstimer > 35 then
			self.RTReticleMaterial:SetVector("$color2", Vector(10, 1, 1))
		end
		if self:GetNWInt("ghorn_lock_on_timer") == 0 then
			if not IsValid(self:GetOwner():GetNWEntity("destiny_ghorn_rocket")) then
				//self:GetOwner():SetNWEntity("destiny_ghorn_target", nil)
				self.RTReticleMaterial:SetVector("$color2", Vector(1, 1, 1))
			end
		end
	end
	if SERVER then
		if self:GetIronSightsProgress() > .95 then
			local ply = self:GetOwner()
			local proxy = ents.FindInSphere( self.Owner:GetEyeTrace().HitPos, 100 )
			local ent = self:GetOwner():GetEyeTrace().Entity
			//for k, v in pairs( proxy ) do 
				//if ( IsValid(v) and (v:IsNPC() or v:IsPlayer()) and v != ply ) then
				if IsTargetable(ent) and ent != ply then
					target = ent
					//print(self.Owner:GetEyeTrace().Entity)
					self:SetNWInt("ghorn_lock_on_timer", math.Clamp(self:GetNWInt("ghorn_lock_on_timer")+1, 0, 50))
				end
			//end

			if adstimer > 35 then
		   		self:GetOwner():SetNWEntity("destiny_ghorn_target", target)
		   		//print(self:GetOwner():GetNWEntity("destiny_ghorn_target"))
		   		//PrintMessage(HUD_PRINTTALK, "LOCKED")
		   	end

		   	if self.Owner:GetEyeTrace().HitWorld then
		   		self:SetNWInt("ghorn_lock_on_timer", math.Clamp(self:GetNWInt("ghorn_lock_on_timer")-1, 0, 50))
		   	end

		   //PrintMessage(HUD_PRINTTALK, adstimer)
		end

		if self:GetNWInt("ghorn_lock_on_timer") == 0 then
			if not IsValid(self:GetOwner():GetNWEntity("destiny_ghorn_rocket")) then
				self:GetOwner():SetNWEntity("destiny_ghorn_target", nil)
				//self.RTReticleMaterial:SetVector("$color2", Vector(1, 1, 1))
			end
		end

		if not self:GetIronSights() then
			self:SetNWInt("ghorn_lock_on_timer", 0)
		end
	end
	//self:GetOwner():PrintMessage(HUD_PRINTTALK, self:GetOwner():GetPos():Distance(self:GetOwner():GetEyeTrace().HitPos))
	return BaseClass.Think2(self, ...)
end

function SWEP:PrimaryAttack(...)
	if self:CanPrimaryAttack(true) then
		ParticleEffectAttach("destiny_ghorn_muzzle", 4, self.OwnerViewModel, self.OwnerViewModel:LookupAttachment("muzzle"))
	end
	return BaseClass.PrimaryAttack(self, ...)
end