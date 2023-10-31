if(!file.Exists("lua/entities/kf_ai/init.lua","THIRDPARTY")) then
	return
end

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
include("KFNPCBaseVars.lua")
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE", "CLASS_XEN"}
VJ.AddNPC("Crawler","npc_hordeext_crawler", "Zombies")
ENT.AutoChangeActivityWhenHeadless = false

ENT.StunInStun = false

ENT.CanJump = true
ENT.DieOnHeadLoss = true

ENT.GoreHead.model = "models/Tripwire/Killing Floor/Zeds/KFCrawlerGoreHead.mdl"
ENT.GoreRArm.model = "models/Tripwire/Killing Floor/Zeds/KFCrawlerGoreRHand.mdl"
ENT.GoreLArm.model = "models/Tripwire/Killing Floor/Zeds/KFCrawlerGoreLHand.mdl"
ENT.GoreRLeg.model = "models/Tripwire/Killing Floor/Zeds/KFCrawlerGoreRLeg.mdl"
ENT.GoreLLeg.model = "models/Tripwire/Killing Floor/Zeds/KFCrawlerGoreLLeg.mdl"
 
ENT.PainSoundEnabled = true
ENT.PainSound.name = "KFMod.Crawler.Pain"
ENT.PainSound.min = 1
ENT.PainSound.max = 7

ENT.DieSoundEnabled = true
ENT.DieSound.name = "KFMod.Crawler.Die"
ENT.DieSound.min = 1
ENT.DieSound.max = 8

ENT.MeleeSoundEnabled = true
ENT.MeleeSound.name = "KFMod.Crawler.Attack"
ENT.MeleeSound.min = 1
ENT.MeleeSound.max = 6

ENT.ChasingSoundEnabled = true
ENT.ChasingSound.name = "KFMod.Crawler.Chase"
ENT.ChasingSound.min = 1
ENT.ChasingSound.max = 11

ENT.IdlingSoundEnabled = true
ENT.IdlingSound.name = "KFMod.Crawler.Idle"
ENT.IdlingSound.min = 1
ENT.IdlingSound.max = 4
if CLIENT then
    language.Add("npc_hordeext_crawler", "Crawler")
end

ENT.CanJump = true

function ENT:KFNPCMakeDamageToCreature(ent)
	if(self.Hard==1) then
		local TEMP_DMG = DamageInfo()
		TEMP_DMG:SetDamageType(DMG_POISON)
		TEMP_DMG:SetDamage(4)
		TEMP_DMG:SetDamageForce(self:GetForward()*2)
		TEMP_DMG:SetDamagePosition(self:GetPos()+self:OBBCenter())
		TEMP_DMG:SetAttacker(self)
		TEMP_DMG:SetInflictor(self)
		ent:TakeDamageInfo(TEMP_DMG)
	end
end

function ENT:KFNPCThink()
	if(self:IsMoving()&&self.CanManipulateActivity==true) then
		if(self:GetMovementActivity()!=self.WalkAct) then
			self:SetMovementActivity(self.WalkAct)
		end
	end
end

function ENT:Initialize()
	self.Model = "models/Tripwire/Killing Floor/Zeds/KFCrawler.mdl"
	self:KFNPCInit({ Vector(-25,-25,0), Vector(25,25,33) },MOVETYPE_STEP,nil,75, "0", "/3")
	
	self.StunDamage = 0
	self.FlinchDamage = 0
	
	
	self:DropToFloor()
	
	
	local TEMP_MeleeHitTable = {}
	for S=1,12 do
		TEMP_MeleeHitTable[S] = "KFMod.ClawHit"..S
	end
	
	local TEMP_MeleeMissTable = {}
	for S=1,4 do
		TEMP_MeleeMissTable[S] = "KFMod.LightSwing"..S
	end
	
	local TEMP_MeleeTable = self:KFNPCCreateMeleeTable()
	TEMP_MeleeTable.damage[1] = 6
	TEMP_MeleeTable.damagetype[1] = DMG_CLUB
	TEMP_MeleeTable.distance[1] = 21
	TEMP_MeleeTable.radius[1] = 43
	TEMP_MeleeTable.time[1] = 1.0
	TEMP_MeleeTable.bone[1] = "CHR_Head"
	self:KFNPCSetMeleeParams(1,"S_Melee1",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	TEMP_MeleeTable.damage[1] = 3
	TEMP_MeleeTable.damagetype[1] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[1] = 21
	TEMP_MeleeTable.radius[1] = 50
	TEMP_MeleeTable.time[1] = 1.0
	TEMP_MeleeTable.bone[1] = "CHR_LArmPalm"
	TEMP_MeleeTable.damage[2] = 3
	TEMP_MeleeTable.damagetype[2] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[2] = 21
	TEMP_MeleeTable.radius[2] = 50
	TEMP_MeleeTable.time[2] = 1.0
	TEMP_MeleeTable.bone[2] = "CHR_RArmPalm"
	self:KFNPCSetMeleeParams(2,"S_Melee2",2, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	
	local TEMP_MeleeMissTable = {""}
	
	TEMP_MeleeTable.damage[1] = 6
	TEMP_MeleeTable.damagetype[1] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[1] = 20
	TEMP_MeleeTable.radius[1] = 40
	TEMP_MeleeTable.time[1] = 0.8
	TEMP_MeleeTable.bone[1] = "CHR_Head"
	TEMP_MeleeTable.damage[2] = 6
	TEMP_MeleeTable.damagetype[2] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[2] = 20
	TEMP_MeleeTable.radius[2] = 40
	TEMP_MeleeTable.time[2] = 1.0
	TEMP_MeleeTable.bone[2] = "CHR_Head"
	TEMP_MeleeTable.damage[3] = 6
	TEMP_MeleeTable.damagetype[3] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[3] = 20
	TEMP_MeleeTable.radius[3] = 40
	TEMP_MeleeTable.time[3] = 1.2
	TEMP_MeleeTable.bone[3] = "CHR_Head"
	self:KFNPCSetMeleeParams(3,"S_RangedJumpAttack1",3, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	self:KFNPCSetMeleeParams(4,"S_RangedJumpAttack2",3, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	self.CanJump = true
end


function ENT:KFNPCDistanceForMeleeTooBig()
	if(self:KFNPCEnemyInMeleeRange(self:GetEnemy(),0,130)==2&&!self:KFNPCIsOnFire()&&!self:KFNPCIsHeadless()&&self.CanJump==true) then
		self:JumpAttack()

		timer.Create("StartAttack"..tostring(self),0.5,1,function()
			if(IsValid(self)&&self!=nil&&self!=NULL) then
				self:SetVelocity((self:GetForward()*2300)+(self:GetUp()*140))
				self:KFNPCPlaySoundRandom(66,"KFMod.Crawler.RAttack",1,6)
				self.AttackIndex = 0
			end
		end)
		
		timer.Create("EndAttack"..tostring(self),1.3,1,function()
			if(IsValid(self)&&self!=nil&&self!=NULL) then
				self:KFNPCStopAllTimers()
				self:KFNPCClearAnimation()
				self.CanJump = false
				
				timer.Create("CrawlerJumpReset"..tostring(self),1.3,1,function()
					if(IsValid(self)&&self!=nil&&self!=NULL) then
						self.CanJump = true
					end
				end)
			end
		end)
	end
end

function ENT:JumpAttack()
	self:KFNPCMeleePlay(math.random(3,4))
end


function ENT:KFNPCRemove()
	timer.Remove("CrawlerJumpReset"..tostring(self))
end

function ENT:KFNPCOnCreateRagdoll()
	return true
end

function ENT:KFNPCSelectMeleeAttack()
	return math.random(1,2)
end