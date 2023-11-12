if(!file.Exists("lua/entities/kf_ai/init.lua","THIRDPARTY")) then
	return
end

ENT.VJ_NPC_Class = {"CLASS_ZOMBIE", "CLASS_XEN"}

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
include("KFNPCBaseVars.lua")


if CLIENT then
    language.Add("npc_hordeext_bloat", "Bloat")
end

ENT.GoreHead.model = "models/Tripwire/Killing Floor/Zeds/KFBloatGoreHead.mdl"
ENT.GoreRArm.model = "models/Tripwire/Killing Floor/Zeds/KFBloatGoreRHand.mdl"
ENT.GoreLArm.model = "models/Tripwire/Killing Floor/Zeds/KFBloatGoreLHand.mdl"
ENT.GoreRLeg.model = "models/Tripwire/Killing Floor/Zeds/KFBloatGoreRLeg.mdl"
ENT.GoreLLeg.model = "models/Tripwire/Killing Floor/Zeds/KFBloatGoreLLeg.mdl"


ENT.PainSoundEnabled = true
ENT.PainSound.name = "KFMod.Bloat.Pain"
ENT.PainSound.min = 1
ENT.PainSound.max = 6

ENT.DieSoundEnabled = true
ENT.DieSound.name = "KFMod.Bloat.Die"
ENT.DieSound.min = 1
ENT.DieSound.max = 4

ENT.MeleeSoundEnabled = true
ENT.MeleeSound.name = "KFMod.Bloat.Attack"
ENT.MeleeSound.min = 1
ENT.MeleeSound.max = 4

ENT.ChasingSoundEnabled = true
ENT.ChasingSound.name = "KFMod.Bloat.Chase"
ENT.ChasingSound.min = 1
ENT.ChasingSound.max = 9

ENT.IdlingSoundEnabled = true
ENT.IdlingSound.name = "KFMod.Bloat.Idle"
ENT.IdlingSound.min = 1
ENT.IdlingSound.max = 19

ENT.MeleeAttackDistance = 22


ENT.DamageTypeMult[DMG_SLOWBURN] = 1.5
ENT.DamageTypeMult[DMG_BURN] = 1.5

ENT.StunOnHeadLoss = false


function ENT:Initialize()
	self.Model = "models/Tripwire/Killing Floor/Zeds/KFBloat.mdl"
	self:KFNPCInit(Vector(-20,-20,92),MOVETYPE_STEP,nil,350,"/4","/21")
	self.StunDamage = 0
	
	self.StunOnHeadLoss = false
	
	self:DropToFloor()
	
	local TEMP_MeleeHitTable = {}
	for S=1,4 do
		TEMP_MeleeHitTable[S] = "KFMod.Backsword.Hit"..S
	end
	
	local TEMP_MeleeMissTable = {}
	for S=1,4 do
		TEMP_MeleeMissTable[S] = "KFMod.HeavySwing"..S
	end
						
	local TEMP_MeleeTable = self:KFNPCCreateMeleeTable()
	
	TEMP_MeleeTable.damage[1] = 14
	TEMP_MeleeTable.damagetype[1] = DMG_SLASH
	TEMP_MeleeTable.distance[1] = 27
	TEMP_MeleeTable.radius[1] = 50
	TEMP_MeleeTable.time[1] = 1.0
	TEMP_MeleeTable.bone[1] = "CHR_LArmPalm"
	self:KFNPCSetMeleeParams(1,"S_Melee1",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	self.MoveChance = math.max(10,self.Difficulty*10)*2
	self.NextFlinch = CurTime()+0.1
end

function ENT:KFNPCFlinchCondition() 
	if(self.PlayingAnimation==true) then
		return false
	end
	
	if(self.NextFlinch<CurTime()) then
		timer.Create("BloatFlinch"..tostring(self),0.1,1,function()
			if(IsValid(self)&&self!=nil&&self!=NULL) then
				self:KFNPCStopAllTimers()
		
				self.PlayingAnimation = false
				self.PlayingGesture = false
				self.AttackGestureIndex = nil
				self.FlinchGestureIndex = nil
				self.Animation = ""
				self.AttackIndex = 0
			end
		end)
		
		self.NextFlinch = CurTime()+1
	end
	
	return true
end

function ENT:KFNPCThink()
	if(self:IsMoving()&&self.CanManipulateActivity==true) then
		if(self:GetMovementActivity()!=self.WalkAct) then
			self:SetMovementActivity(self.WalkAct)
		end
	end
end

function ENT:KFNPCOnCreateRagdoll(dmginfo,BoomDamage)
	if(BoomDamage) then
		return false
	end
	return true
end

function ENT:KFNPCSetExplosionDamage(dmgtype)
	if(dmgtype!=DMG_POISON&&dmgtype!=DMG_NERVEGAS&&dmgtype!=DMG_DROWN&&dmgtype!=DMG_ACID&&dmgtype!=DMG_RADIATION&&dmgtype!=DMG_NEVERGIB) then
	
		sound.Play( "KFMod.Bloat.Explode"..math.random(1,3),self:GetPos()+self:OBBCenter())
		
		local TEMP_BoxMin = self:OBBMins()
		local TEMP_BoxMax = self:OBBMaxs()
						
		for V=1, 16 do
			local TEMP_RandomPos = self:GetPos()+Vector(math.random(TEMP_BoxMin.x,TEMP_BoxMax.x)/3,math.random(TEMP_BoxMin.y,TEMP_BoxMax.y)/3,math.random(TEMP_BoxMin.z,TEMP_BoxMax.z))
			
			local TEMP_Vomit = ents.Create("ent_bloatvomit")
			TEMP_Vomit:SetPos(TEMP_RandomPos)
			TEMP_Vomit:SetAngles(Angle(math.random(0,359),math.random(0,359),math.random(0,359)))
			TEMP_Vomit:Spawn()
			
			TEMP_Vomit:SetOwner(self)
			
			TEMP_Vomit.Damage = 1*self.DMGMult
			
			local TEMP_VEL = 100

			local TEMP_DirTable = {
				Vector(-TEMP_VEL,-TEMP_VEL,200),
				Vector(TEMP_VEL,-TEMP_VEL,200),
				Vector(-TEMP_VEL,TEMP_VEL,200),
				Vector(TEMP_VEL,TEMP_VEL,200),
				Vector(0,-TEMP_VEL,200),
				Vector(-TEMP_VEL,0,200),
				Vector(TEMP_VEL,0,200),
				Vector(0,TEMP_VEL,200),
				Vector(-TEMP_VEL,-TEMP_VEL,100),
				Vector(TEMP_VEL,-TEMP_VEL,100),
				Vector(-TEMP_VEL,TEMP_VEL,100),
				Vector(TEMP_VEL,TEMP_VEL,100),
				Vector(0,-TEMP_VEL,100),
				Vector(-TEMP_VEL,0,100),
				Vector(TEMP_VEL,0,100),
				Vector(0,TEMP_VEL,100)
			}
			TEMP_Vomit:GetPhysicsObject():SetVelocity(TEMP_DirTable[V])
		end
		
		local TEMP_STARTPOS = self:GetPos()+Vector(0,0,10)
		local TEMP_ENDPOS = self:GetPos()+Vector(0,0,-30)
			
		util.Decal( "KF_BloatExplodeSplat", TEMP_STARTPOS, TEMP_ENDPOS,self)

		return true, true
	end
	return false, false
end


function ENT:KFNPCDistanceForMeleeTooBig()
	if(self:KFNPCEnemyInMeleeRange(self:GetEnemy(),0,130)==2&&self.PlayingAnimation==false&&!self:KFNPCIsOnFire()&&!self:KFNPCIsHeadless()) then
		self:KFNPCPlayGesture("S_Special",1)
		
		
		local TEMP_MoveChance = math.random(1,100)
		self.FlinchDamage = 0
		
	
		if(TEMP_MoveChance>self.MoveChance) then
			self.MustNotMove = true
			self:StopMoving()
		end
	
		timer.Create("StartAttack"..tostring(self),1,1,function()
			if(IsValid(self)&&self!=nil&&self!=NULL) then
				self:KFNPCStopPreviousSound()
				
				self:KFNPCPlaySoundRandom(100,"KFMod.Bloat.Barf",1,9)
				
				local TEMP_Dmg = 36*self.DMGMult
				
				
				timer.Create("Attack"..tostring(self),0.02*(40/TEMP_Dmg),TEMP_Dmg,function()
					if(IsValid(self)&&self!=nil&&self!=NULL) then
						local TEMP_Head = self:GetAttachment(self:LookupAttachment("eye"))
						
						local TEMP_Vomit = ents.Create("ent_bloatvomit")
						
						TEMP_Vomit:SetPos(TEMP_Head.Pos)
						TEMP_Vomit:SetAngles(((self:GetForward()*1000)+(Vector(math.random(-100,100),
						math.random(-100,100),math.random(-100,100))*0.3)):Angle())
						TEMP_Vomit:Spawn()
						
						TEMP_Vomit:SetOwner(self)
						
						TEMP_Vomit:GetPhysicsObject():SetVelocity(TEMP_Vomit:GetForward()*math.random(320,380))
						
						TEMP_Vomit.Damage = 1
					end
				end)
			end
		end)
		
		timer.Create("EndAttack"..tostring(self),2.7,1,function()
			if(IsValid(self)&&self!=nil&&self!=NULL) then
				self.FlinchDamage = 24
				self:KFNPCClearAnimation()
			end
		end)
	end
end

function ENT:KFNPCOnHeadLoss()
	timer.Remove("Attack"..tostring(self))
	timer.Remove("StartAttack"..tostring(self))
	timer.Remove("EndAttack"..tostring(self))
	
	self:KFNPCFlinch(self.FlinchSequence)
end

function ENT:KFNPCRemove()
	timer.Remove("BloatFlinch"..tostring(self))
end