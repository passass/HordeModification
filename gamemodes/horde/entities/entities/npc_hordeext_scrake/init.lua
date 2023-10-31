if(!file.Exists("lua/entities/kf_ai/init.lua","THIRDPARTY")) then
	
	return
end

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
include("KFNPCBaseVars.lua")

ENT.StunInStun = true

ENT.VJ_NPC_Class = {"CLASS_ZOMBIE", "CLASS_XEN"}
VJ.AddNPC("Scrake","npc_hordeext_scrake", "Zombies")


ENT.GoreHead.model = "models/Tripwire/Killing Floor/Zeds/KFScrakeGoreHead.mdl"
ENT.GoreRArm.model = "models/Tripwire/Killing Floor/Zeds/KFScrakeGoreRHand.mdl"
ENT.GoreLArm.model = "models/Tripwire/Killing Floor/Zeds/KFScrakeGoreLHand.mdl"
ENT.GoreRLeg.model = "models/Tripwire/Killing Floor/Zeds/KFScrakeGoreRLeg.mdl"
ENT.GoreLLeg.model = "models/Tripwire/Killing Floor/Zeds/KFScrakeGoreLLeg.mdl"

ENT.PainSoundEnabled = true
ENT.PainSound.name = "KFMod.Scrake.Pain"
ENT.PainSound.min = 1
ENT.PainSound.max = 5

ENT.DieSoundEnabled = true
ENT.DieSound.name = "KFMod.Scrake.Die"
ENT.DieSound.min = 1
ENT.DieSound.max = 5

ENT.MeleeSoundEnabled = true
ENT.MeleeSound.name = "KFMod.Scrake.Attack"
ENT.MeleeSound.min = 1
ENT.MeleeSound.max = 4

ENT.ChasingSoundEnabled = true
ENT.ChasingSound.name = "KFMod.Scrake.Chase"
ENT.ChasingSound.min = 1
ENT.ChasingSound.max = 8

ENT.MeleeAttackDistance = 25
ENT.MeleeAttackDistanceMin = 0

ENT.BurnTimeToPanic = 7

ENT.ChainsawLoopIndex = 1
ENT.ChainsawNextPlaySound = CurTime()

ENT.Raged = 0
ENT.RageHealth = 0.5

ENT.BigZed = true

ENT.PoundRageBumpDamScale = 0.01
if CLIENT then
    language.Add("npc_hordeext_scrake", "Scrake")
end
function ENT:KFNPCSelectMeleeAttack()
	if(!self:IsMoving()&&self:KFNPCEnemyInMeleeRange(self:GetEnemy(),0,8)==2) then
		self:KFNPCPlayAnimation("S_Melee3",1)
		
		self.ChainsawLoopIndex = 1
		local TEMP_SawingDamage = 4*self.DMGMult
		
		timer.Create("Attack"..tostring(self),0.5,0,function()
			if(IsValid(self)&&self!=nil&&self!=NULL) then
				local TEMP_OBBSize = (Vector(math.abs(self:OBBMins().x),math.abs(self:OBBMins().y),0)+
				Vector(math.abs(self:OBBMaxs().x),math.abs(self:OBBMaxs().y),0))/2
				local TEMP_PossibleDamageTargets = ents.FindInSphere(self:GetPos(), 50)
				local TEMP_DMGPOS, TEMP_DMGANG = self:GetBonePosition(self:LookupBone("CHR_RArmPalm"))
				local TEMP_DamageApplied = false
				local TEMP_TargetTakeDamage = false
				
				if(#TEMP_PossibleDamageTargets>0) then
					for _,v in pairs(TEMP_PossibleDamageTargets) do
						if(v!=self&&v!=NULL&&v!=nil&&(self:KFNPCIsEnemyNPC(v)||self:KFNPCIsEnemyPlayer(v))) then
							local TEMP_DistanceForMelee = self:KFNPCEnemyInMeleeRange(v,0,12)
							
							local TEMP_DotVector = v:GetPos()
							local TEMP_DotDir = TEMP_DotVector - self:GetPos()
							TEMP_DotDir:Normalize()
							local TEMP_Dot = self:GetForward():Dot(TEMP_DotDir)
							
							if(TEMP_DistanceForMelee==2&&(TEMP_Dot>math.cos(30)||
							20==360)) then
								TEMP_DamageApplied = true
								
								local TEMP_FMOD = 100
								local TEMP_ZMOD = 0.4
								
								local TEMP_FlySpeed = (math.abs(v:OBBMins().x)+math.abs(v:OBBMins().y)+math.abs(v:OBBMins().z)+
								math.abs(v:OBBMaxs().x)+math.abs(v:OBBMaxs().y)+math.abs(v:OBBMaxs().z))
								
								local TEMP_FlyDir = 
								(((((v:GetPos()+v:OBBCenter())-(self:GetPos()+self:OBBCenter())):GetNormalized()+Vector(0,0,TEMP_ZMOD))/
								TEMP_FlySpeed)*(100*self.MeleeFlySpeed))*(TEMP_SawingDamage/1000)
								
								
								local TEMP_TargetDamage = DamageInfo()
								
								TEMP_TargetDamage:SetDamage(TEMP_SawingDamage)
								TEMP_TargetDamage:SetInflictor(self)
								TEMP_TargetDamage:SetDamageType(DMG_SLASH)
								TEMP_TargetDamage:SetAttacker(self)
								TEMP_TargetDamage:SetDamagePosition(TEMP_DMGPOS)
								TEMP_TargetDamage:SetDamageForce(TEMP_FlyDir)
								v:TakeDamageInfo(TEMP_TargetDamage)
								
								if(v==self:GetEnemy()) then
									TEMP_TargetTakeDamage = true
								end
								
								if(TEMP_FlyDir.z>250||!v:IsOnGround()) then
									TEMP_FMOD = 25
								end
								
								if(v:IsPlayer()) then
									v:ViewPunch(Angle(math.random(-1,1)*TEMP_FlyDir:Length(),math.random(-1,1)*TEMP_FlyDir:Length(),math.random(-1,1)*TEMP_FlyDir:Length()))
									TEMP_ZMOD = 0.4
								end
								
								TEMP_FlyDir = TEMP_FlyDir*TEMP_FMOD
								
								v:SetVelocity(-TEMP_FlyDir*2)
							end
						end
					end
				end
				
				if(TEMP_TargetTakeDamage==false) then
					self:KFNPCStopAllTimers()
					self:KFNPCClearAnimation()
				end

				if(TEMP_DamageApplied==true) then
					sound.Play( table.Random(self.MeleeHitSound[1]),TEMP_DMGPOS)
				end
			end
		end)
		
		return false
	end
		
	return math.random(1,2)
end

function ENT:Initialize()
	self.Model = "models/Tripwire/Killing Floor/Zeds/KFScrake.mdl"
	self:KFNPCInit(Vector(20,20,79),MOVETYPE_STEP,nil,1000,"*0.5","*0.95","*0.3")
	
	self.FlinchDamage = 150
	
	local TEMP_MeleeHitTable = {}
	for S=1,3 do
		TEMP_MeleeHitTable[S] = "KFMod.Chainsaw.Hit"..S
	end
	
	local TEMP_MeleeMissTable = {}
	for S=1,4 do
		TEMP_MeleeMissTable[S] = "KFMod.HeavySwing"..S
	end		
	local TEMP_MeleeTable = self:KFNPCCreateMeleeTable()
	
	TEMP_MeleeTable.damage[1] = 40
	TEMP_MeleeTable.damagetype[1] = DMG_SLASH
	TEMP_MeleeTable.distance[1] = 30
	TEMP_MeleeTable.radius[1] = 60
	TEMP_MeleeTable.time[1] = 0.8
	TEMP_MeleeTable.bone[1] = "CHR_RArmPalm"
	self:KFNPCSetMeleeParamsGesture(1,"S_Melee1",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	TEMP_MeleeTable.damage[1] = 20
	TEMP_MeleeTable.damagetype[1] = DMG_SLASH
	TEMP_MeleeTable.distance[1] = 30
	TEMP_MeleeTable.radius[1] = 60
	TEMP_MeleeTable.time[1] = 0.75
	TEMP_MeleeTable.bone[1] = "CHR_RArmPalm"
	TEMP_MeleeTable.damage[2] = 20
	TEMP_MeleeTable.damagetype[2] = DMG_SLASH
	TEMP_MeleeTable.distance[2] = 30
	TEMP_MeleeTable.radius[2] = 60
	TEMP_MeleeTable.time[2] = 1.25
	TEMP_MeleeTable.bone[2] = "CHR_RArmPalm"
	self:KFNPCSetMeleeParamsGesture(2,"S_Melee2",2, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	self:EmitSound( "KFMod.Chainsaw.Idle")
	
	
	self.StunCount = 0
	
	self.MeleeFlinched = false

end

function ENT:KFNPCAfterInit()
	if(self.Difficulty>2) then
		self.RageHealth = 0.7
	else
		self.RageHealth = 0.5
	end
end


function ENT:KFNPCFlinchCondition() 
	if(self.Animation==self.StunSequence) then
		//self.StunCount = self.StunCount+1
		
		if(self.StunCount==1) then
			return false
		end
	//else
	//	self.StunsCont = 0
	end

	if(self.Difficulty>2) then
		if(self.LastDamageType==DMG_SLASH||self.LastDamageType==DMG_CLUB||self.LastDamageType==bit.bor(DMG_SLASH,DMG_CLUB)) then
			if(self.MeleeFlinched==false) then
				self.MeleeFlinched = true
			else
				return false
			end
		end
	end
	
	return true
end

function ENT:KFNPCThink()
	if(self.CanManipulateActivity==true&&self:IsMoving()) then
		if(self:Health()>self:GetMaxHealth()*self.RageHealth&&((self.Raged==0&&self.Hard==1)||self.Hard==0)&&self.AttackIndex<1) then
			if(self:GetMovementActivity()!=self.WalkAct) then
				self:SetMovementActivity(self.WalkAct)
			end
		else
			if(self:GetMovementActivity()!=self.RunAct) then
				self:SetMovementActivity(self.RunAct)
			end
		end
	end
	
	if(self.Animation=="S_Melee3"&&self.ChainsawNextPlaySound<CurTime()) then
		if(self.ChainsawLoopIndex>6) then
			self.ChainsawLoopIndex = 1
		end
			
		sound.Play("KFMod.Chainsaw.Loop"..self.ChainsawLoopIndex,self:GetPos())
		self.ChainsawNextPlaySound = (CurTime()+SoundDuration("KFMod.Chainsaw.Loop"..self.ChainsawLoopIndex))-0.1
		
		self.ChainsawLoopIndex = self.ChainsawLoopIndex+1
	end
		
end

function ENT:KFNPCDamageTake(dmginfo,dmg,mul)
	if(self.Animation!=self.StunSequence) then
		self.StunCount = 0
	else
		self.StunCount = 1
	end
	
	if(self.Hard==1) then
		if(dmg>40&&self:Health()>self:GetMaxHealth()*0.7) then
			if(self.Raged==1) then
				timer.Remove("ScrakeEndRage"..tostring(self))
			end
			
			self.Raged = 1
			
			timer.Create("ScrakeEndRage"..tostring(self),2.5,1,function()
				if(IsValid(self)&&self!=nil&&self!=NULL) then
					self.Raged = 0
				end
			end)
		end
	end
	
	return mul
end
	
function ENT:KFNPCMeleeAttackEvent()
	sound.Play("KFMod.Chainsaw.Swing"..math.random(1,2),self:GetPos()+self:OBBCenter())
end

function ENT:KFNPCRemove()
	timer.Remove("ScrakeEndRage"..tostring(self))
	self:StopSound("KFMod.Chainsaw.Idle")
end