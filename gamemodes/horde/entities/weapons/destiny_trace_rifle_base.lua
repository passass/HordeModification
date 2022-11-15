
if SERVER then
	AddCSLuaFile()
end

DEFINE_BASECLASS("tfa_gun_base")

SWEP.CountOverride = false

SWEP.ElementTbl = {
	["Void"] = 1,
	["Solar"] = 2,
	["Arc"] = 3,
	["Stasis"] = 4
}

SWEP.Element = "Solar"
SWEP.ParticleTracer = nil
SWEP.ParticleMuzzle = "VoidMuzzleMain"
SWEP.ImpactEffect = nil

SWEP.AttachmentTableOverride = { -- overrides WeaponTable for attachments
	["d2mp_backup_mag"] = { -- attachment id, root of WeaponTable override
		["Primary"] = {
			["ClipSize"] = function(wep,stat) return math.Round(stat*.95) end
		}
	}
}

DEFINE_BASECLASS( SWEP.Base )

local obj
local muzzlepos
local l_CT = CurTime
local rgb
local timer1 = 0
local t = 0
local t2 = 0

function SWEP:Initialize(...)
	obj = self:LookupAttachment( "muzzle" )
	muzzlepos = self:GetAttachment( obj ).Pos
	BaseClass.Initialize(self, ...)
end

function SWEP:Deploy(...)
	self:SetNW2Int("FireCount", 0)
	return BaseClass.Deploy(self, ...)
end

function SWEP:Think2(...)

	if self:GetStatus() == TFA.GetStatus("shooting") then
		self:Beam()
	end

	if self:GetStatus() == TFA.GetStatus("idle") then
		if not self.LastIdleTime then
			self.LastIdleTime = CurTime()
		elseif CurTime() > self.LastIdleTime + 0.1 then
			self:SetNW2Int("FireCount", 0)
		end
	else
		self.LastIdleTime = nil
	end

	return BaseClass.Think2(self, ...)
end

function SWEP:DealAoeDamage( dmgtype, dmgamt, src, range, attacker, forcemul )
	
	if ( !forcemul ) then
		forcemul = 1
	end
	
	local dmg = DamageInfo()
	dmg:SetDamageType( dmgtype )
	if ( !attacker || !IsValid( attacker ) ) then
		dmg:SetAttacker( self:GetOwner() )
	else
		dmg:SetAttacker( attacker )
	end
	dmg:SetInflictor( self )
	dmg:SetDamageForce( Vector( 0, 0, 0 ) * forcemul )
	dmg:SetDamage( dmgamt )
	
	util.BlastDamageInfo( dmg, src, range )

end

function SWEP:TriggerAttack(tableName, clipID)
	local self2 = self:GetTable()
	local ply = self:GetOwner()
	local cnt = self:GetNW2Int("FireCount")

	local fnname = clipID == 2 and "Secondary" or "Primary"

	if TFA.Enum.ShootReadyStatus[self:GetShootStatus()] then
		self:SetShootStatus(TFA.Enum.SHOOT_IDLE)
	end

	self["SetNext" .. fnname .. "Fire"](self, l_CT() + self:GetFireDelay())

	self:SetStatus(TFA.Enum.STATUS_SHOOTING, self["GetNext" .. fnname .. "Fire"](self)+.025)
	
	self:IncreaseRecoilLUT()

	local ifp = IsFirstTimePredicted()

	local _, tanim = self:ChooseShootAnim(ifp)

	if (not sp) or (not self:IsFirstPerson()) then
		ply:SetAnimation(PLAYER_ATTACK1)
	end

	if self:GetStat(tableName .. ".Sound") and ifp and not (sp and CLIENT) then
		local cnt = self:GetNW2Int("FireCount")
		if self.CountOverride then cnt = 2 end
		if ply:IsPlayer() and self:GetStat(tableName .. ".LoopSound") and (not self:GetStat(tableName .. ".LoopSoundAutoOnly", false) or self2.Primary_TFA.Automatic) and cnt > 1 then
			self:EmitGunfireLoop()
		else
			local tgtSound = self:GetStat(tableName .. ".Sound")

			self:EmitGunfireSound(tgtSound)
		end

		self:EmitLowAmmoSound()
	end

	self2["Take" .. fnname .. "Ammo"](self, self:GetStat(tableName .. ".AmmoConsumption"))

	if self["Clip" .. clipID](self) == 0 and self:GetStat(tableName .. ".ClipSize") > 0 then
		self["SetNext" .. fnname .. "Fire"](self, math.max(self["GetNext" .. fnname .. "Fire"](self), l_CT() + (self:GetStat(tableName .. ".DryFireDelay", self:GetActivityLength(tanim, true)))))
	end

	self:UpdateJamFactor()
	local _, CurrentRecoil = self:CalculateConeRecoil()
	self:Recoil(CurrentRecoil, ifp)

	-- shouldn't this be not required since recoil state is completely networked?
	if sp and SERVER then
		self:CallOnClient("Recoil", "")
	end

	if self:GetStat(tableName .. ".MuzzleFlashEnabled", self:GetStat("MuzzleFlashEnabled")) and (not self:IsFirstPerson() or not self:GetStat(tableName .. ".AutoDetectMuzzleAttachment", self:GetStat("AutoDetectMuzzleAttachment"))) then
		self:ShootEffectsCustom()
	end

	self:DoAmmoCheck(clipID)
end

function SWEP:ChooseShootAnim(...)
	local cnt = self:GetNW2Int("FireCount")
	self:SetNW2Int("FireCount", cnt + 1)
	
	return BaseClass.ChooseShootAnim(self,...)
end

local tr
function SWEP:Beam()

	if self:GetStatus() == TFA.GetStatus("shooting") then
		if(IsFirstTimePredicted()) then
			local ply = self:GetOwner()
			local ang = self:GetAimAngle()
			tr = util.QuickTrace(ply:GetShootPos(), ang:Forward()*0x7FFF, ply)

			if GetConVar("sv_tfa_fixed_crosshair"):GetBool() then
				tr = util.QuickTrace(ply:GetShootPos(), ply:EyeAngles():Forward()*0x7FFF, ply)
			else
				tr = util.QuickTrace(ply:GetShootPos(), ang:Forward()*0x7FFF, ply)
			end
			
			if self.ParticleTracer != nil then
				util.ParticleTracerEx( 
					self.ParticleTracer, --particle system
					self:GetAttachment( self:LookupAttachment( "muzzle" ) ).Pos, --startpos
					tr.HitPos, //self:GetAimAngle():Forward(), --endpos
					false, --do whiz effect
					self:EntIndex(), --entity index
					self:LookupAttachment( "muzzle" ) --attachment
					)
			else
				local ef = EffectData()
				ef = EffectData()
				ef:SetOrigin(self.Owner:EyePos())
				ef:SetStart(tr.HitPos)
				ef:SetEntity(self)
				ef:SetFlags(self:GetStat("ElementTbl.".. self.Element)) //1-void 2-solar 3-arc
				ef:SetAttachment(self:LookupAttachment( "muzzle" ))
				ef:SetScale(1)
				ef:SetNormal(tr.HitNormal)
				util.Effect("D2TraceBeam", ef)
			end
			
			if self.ImpactEffect != nil then self:DoImpactEffect(tr) end
			
			if self:GetOwner():IsPlayer() then
				ParticleEffectAttach(self.ParticleMuzzle, 4, self.OwnerViewModel, self.OwnerViewModel:LookupAttachment("muzzle"))
			end

			local traceData = {
				start = ply:GetShootPos() + ply:GetForward() * 50,
				endpos = ply:GetShootPos() + ply:GetForward() * 10000,
				mask = MASK_SOLID,
				collisiongroup = COLLISION_GROUP_PLAYER,
				mins = Vector( -10, -10, -10),
				maxs = Vector( 10, 10, 10),
				filter = function( ent )
					if (ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot()) then
						return true
					end
				end
			}
	
			local tr2 = util.TraceLine(traceData)
			local damageInfo = DamageInfo()
			local dmg = math.Clamp(self.Primary_TFA.Damage / (ply:GetShootPos():Distance(tr.HitPos)/1500), 1, self.Primary_TFA.Damage )
			
			damageInfo:SetDamage(math.Round( dmg, 2 ))
			damageInfo:SetAttacker( ply )
			damageInfo:SetInflictor( self )

			//PrintMessage(HUD_PRINTTALK, damageInfo:GetDamage())

			if(IsValid ( tr.Entity )) then
				if tr.Entity:GetClass() == "npc_strider" then
					self.DamageType = DMG_GENERIC
					damageInfo:SetDamage(damageInfo:GetDamage()*.5)
				elseif tr.Entity:GetClass() == "npc_helicopter" then 
					self.DamageType = DMG_AIRBOAT
				-- elseif tr.Entity:GetClass() == "npc_combinegunship" then 
				-- 	self.DamageType = DMG_BLAST
				-- 	damageInfo:SetDamage(math.Clamp(self.Primary.Damage*20 / (ply:GetShootPos():Distance(tr.HitPos)/150), 1, 100 ))
				else
					self.DamageType = DMG_DISSOLVE
				end
			end
			damageInfo:SetDamageType(self.DamageType)
			damageInfo:ScaleDamage(1)

			if(IsValid ( tr.Entity ) and self.Weapon:Clip1() > 0 ) and self:CanPrimaryAttack() then
				tr.Entity:DispatchTraceAttack(damageInfo, tr, tr.HitNormal)
			end
		end

		if CLIENT then
			local ply = self:GetOwner()
			local ang = self:GetAimAngle()
			local tr

			if GetConVar("sv_tfa_fixed_crosshair"):GetBool() then
				tr = util.QuickTrace(ply:GetShootPos(), ply:EyeAngles():Forward()*0x7FFF, ply)
			else
				tr = util.QuickTrace(ply:GetShootPos(), ang:Forward()*0x7FFF, ply)
			end

			local mLight = DynamicLight( self:EntIndex() )
			if ( mLight ) then
				mLight.pos = tr.HitPos
				if self.Element == "Void" then
					mLight.r = 100
					mLight.g = 50
					mLight.b = 255
				elseif self.Element == "Solar" then
					mLight.r = 255
					mLight.g = 150
					mLight.b = 50
				elseif self.Element == "Arc" then
					mLight.r = 100
					mLight.g = 130
					mLight.b = 255
				else
					mLight.r = 255
					mLight.g = 255
					mLight.b = 255
				end

				mLight.brightness = 2
				mLight.Size = 100
				mLight.Decay = 1024
				mLight.Style = 1
				mLight.DieTime = CurTime() + 1
			end

			local wep = self:GetOwner():GetViewModel()
			local matrix = wep:GetBoneMatrix(wep:LookupBone( "muzzlebone" ))
			if matrix != nil then
				local pos = matrix:GetTranslation()
				local ang = matrix:GetAngles()
				if pos == self:GetPos() then
					pos = wep:GetBoneMatrix(wep:LookupBone( "muzzlebone" )):GetTranslation()
				end

				local muzzleLight = DynamicLight( self:EntIndex()+1 )
				if ( muzzleLight ) then
					muzzleLight.pos = pos
					if self.Element == "Void" then
						muzzleLight.r = 100
						muzzleLight.g = 50
						muzzleLight.b = 255
					elseif self.Element == "Solar" then
						muzzleLight.r = 255
						muzzleLight.g = 150
						muzzleLight.b = 50
					elseif self.Element == "Arc" then
						muzzleLight.r = 150
						muzzleLight.g = 175
						muzzleLight.b = 255
					else
						muzzleLight.r = 255
						muzzleLight.g = 255
						muzzleLight.b = 255
					end
					muzzleLight.brightness = 2
					muzzleLight.Size = 100
					muzzleLight.Decay = 1024
					muzzleLight.Style = 1
					muzzleLight.DieTime = CurTime() + 1
				end 
			end

		end
	end
end



function SWEP:DoImpactEffect( tr, nDamageType )

	if ( tr.HitSky ) then return end -- Do not draw effects vs. the sky.

	local ply = self:GetOwner()
	local ang = self:GetAimAngle()

	ParticleEffect( self.ImpactEffect, tr.HitPos + tr.HitNormal, ply:EyeAngles(), self ) -- draw the particle
	return false

end

function SWEP:OnRemove(...)
	
	self:StopSound(self:GetStat("Primary.LoopSound"))
	
	return BaseClass.OnRemove(self, ...)
end
function SWEP:Holster(...)
	
	self:StopSound(self:GetStat("Primary.LoopSound"))
	
	return BaseClass.Holster(self, ...)
end
