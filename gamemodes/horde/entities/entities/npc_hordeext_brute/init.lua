if(!file.Exists("lua/entities/kf_ai/init.lua","THIRDPARTY")) then
	return
end

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
include("KFNPCBaseVars.lua")
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE", "CLASS_XEN"}
VJ.AddNPC("Brute","npc_hordeext_brute", "Zombies")
ENT.StunOnHeadLoss = false

ENT.GoreHead.model = "models/Tripwire/Killing Floor/Zeds/KFBruteGoreHead.mdl"
ENT.GoreRArm.model = "models/Tripwire/Killing Floor/Zeds/KFBruteGoreRHand.mdl"
ENT.GoreLArm.model = "models/Tripwire/Killing Floor/Zeds/KFBruteGoreLHand.mdl"
ENT.GoreRLeg.model = "models/Tripwire/Killing Floor/Zeds/KFBruteGoreRLeg.mdl"
ENT.GoreLLeg.model = "models/Tripwire/Killing Floor/Zeds/KFBruteGoreLLeg.mdl"


ENT.PainSoundEnabled = false
ENT.PainSound.name = "KFMod.Brute.Pain"
ENT.PainSound.min = 1
ENT.PainSound.max = 6

ENT.DieSoundEnabled = false
ENT.DieSound.name = "KFMod.Brute.Die"
ENT.DieSound.min = 1
ENT.DieSound.max = 5

ENT.MeleeSoundEnabled = false
ENT.MeleeSound.name = "KFMod.Brute.Attack"
ENT.MeleeSound.min = 1
ENT.MeleeSound.max = 5

ENT.ChasingSoundEnabled = false
ENT.ChasingSound.name = "KFMod.Brute.Chase"
ENT.ChasingSound.min = 1
ENT.ChasingSound.max = 4

ENT.IdlingSoundEnabled = false
ENT.IdlingSound.name = "KFMod.Brute.Idle"
ENT.IdlingSound.min = 1
ENT.IdlingSound.max = 9

ENT.MeleeAttackDistance = 25

ENT.Rage = 0
ENT.RageTime = 0
ENT.RageTimeMax = math.random(10,15)
ENT.Raged = false
ENT.BurnTimeToPanic = 7

ENT.MeleeFlySpeed = 320

ENT.DamageTypeMult[DMG_SLASH] = 0.75
ENT.DamageTypeMult[DMG_CLUB] = 0.75

ENT.DPSToRage = 50

ENT.PoundRageBumpDamScale = 0.01


ENT.BigZed = true

if CLIENT then
    language.Add("npc_hordeext_brute", "Brute")
end

function ENT:Initialize()
	self.Model = "models/Tripwire/Killing Floor/Zeds/KFBrute.mdl"
	self:KFNPCInit(Vector(-19,-19,95),MOVETYPE_STEP,nil,750,"/4","/1.2","/4")
	self.StunDamage = 0
	self.FlinchDamage = 0
	
	local TEMP_MeleeHitTable = {}
	
	for S=1,6 do
		TEMP_MeleeHitTable[S] = "KFMod.StrongHit"..S
	end
	
	local TEMP_MeleeMissTable = {}
	
	for S=1,4 do
		TEMP_MeleeMissTable[S] = "KFMod.LightSwing"..S
	end
						
	local TEMP_MeleeTable = self:KFNPCCreateMeleeTable()
	
	TEMP_MeleeTable.damage[1] = 20
	TEMP_MeleeTable.damagetype[1] = DMG_CLUB
	TEMP_MeleeTable.distance[1] = 30
	TEMP_MeleeTable.radius[1] = 40
	TEMP_MeleeTable.time[1] = 0.4
	TEMP_MeleeTable.bone[1] = "CHR_LArmForearm"
	self:KFNPCSetMeleeParamsGesture(1,"S_Melee1",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	
	for S=1,6 do
		TEMP_MeleeHitTable[S] = "KFMod.StrongHit"..S
	end
	
	local TEMP_MeleeMissTable = {}
	
	for S=1,4 do
		TEMP_MeleeMissTable[S] = "KFMod.HeavySwing"..S
	end
			
			
	local TEMP_MeleeTable = self:KFNPCCreateMeleeTable()
	
	TEMP_MeleeTable.damage[1] = 20
	TEMP_MeleeTable.damagetype[1] = DMG_CLUB
	TEMP_MeleeTable.distance[1] = 30
	TEMP_MeleeTable.radius[1] = 50
	TEMP_MeleeTable.time[1] = 0.9
	TEMP_MeleeTable.bone[1] = "CHR_RArmForearm"
	TEMP_MeleeTable.damage[2] = 20
	TEMP_MeleeTable.damagetype[2] = DMG_CLUB
	TEMP_MeleeTable.distance[2] = 30
	TEMP_MeleeTable.radius[2] = 50
	TEMP_MeleeTable.time[2] = 1.8
	TEMP_MeleeTable.bone[2] = "CHR_LArmForearm"
	self:KFNPCSetMeleeParamsGesture(2,"S_Melee2",2, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	TEMP_MeleeTable.damage[1] = 20
	TEMP_MeleeTable.damagetype[1] = DMG_CLUB
	TEMP_MeleeTable.distance[1] = 30
	TEMP_MeleeTable.radius[1] = 50
	TEMP_MeleeTable.time[1] = 1.0
	TEMP_MeleeTable.bone[1] = "CHR_RArmForearm"
	TEMP_MeleeTable.damage[2] = 20
	TEMP_MeleeTable.damagetype[2] = DMG_CLUB
	TEMP_MeleeTable.distance[2] = 30
	TEMP_MeleeTable.radius[2] = 50
	TEMP_MeleeTable.time[2] = 1.0
	TEMP_MeleeTable.bone[2] = "CHR_LArmForearm"
	self:KFNPCSetMeleeParamsGesture(3,"S_Melee3",2, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
end

function ENT:KFNPCSelectMeleeAttack()
	if(self.Raged==true) then
		return math.random(2,3)
	else
		return 1
	end
end

function ENT:KFNPCDamageTake(dmginfo,dmg,mul)
	if(self.LastHitgroup==HITGROUP_KFHEAD) then
		if(self.PlayingAnimation==false) then
			mul = mul*0.9
		end
		
		if(bit.band(dmginfo:GetDamage(),DMG_BURN)||bit.band(dmginfo:GetDamage(),DMG_SLOWBURN)) then
			mul = mul*0.7
		else
			mul = mul*0.9
		end
	elseif(self.LastHitgroup==HITGROUP_LEFTARM||self.LastHitgroup==HITGROUP_RIGHTARM) then
		mul = mul*0.1
	end
	
	if(self.Raged==false&&self.HeadLess==false&&(self.BurnTime<self.BurnTimeToPanic||
	self.BurnTime>self.BurnTimeToPanic+3)) then
		self.Rage = self.Rage + (dmginfo:GetDamage()*mul)
		
		if(self.Rage>self.DPSToRage) then
			self:BruteRage()
		end
	end
	
	return mul
end



function ENT:KFNPCThinkEnemyValid()
	if(self.Raged==false&&!self:KFNPCIsOnFire()&&!self:KFNPCIsHeadless()) then
		if(self:Visible(self:GetEnemy())) then
			self.RageTime = self.RageTime+0.1
			
			if(self.RageTime>self.RageTimeMax) then
				self:BruteRage()
			end
		else
			if(self.Hard==0&&self.RageTime>0.1) then
				self.RageTime = self.RageTime-0.1
			end
		end
	end
end

function ENT:KFNPCThink()
	if(self.PlayingAnimation==false&&self.CanManipulateActivity==true) then
		if(self.Raged==false) then
			if(self:GetMovementActivity()!=self.WalkAct) then
				self:SetMovementActivity(self.WalkAct)
			end
		else
			if(self:GetMovementActivity()!=self.RunAct) then
				self:SetMovementActivity(self.RunAct)
			end
		end
	end
	
	if(self.Hard==0) then
		if(self.Rage>0) then
			self.Rage = math.max(self.Rage-(self.DPSToRage/30),0)
		end
	end
end

function ENT:KFNPCMeleeDamagesEnd(hittarget,damageapllied,alldamages)
	if(self.Raged==true) then
		if(self.Hard==0) then
			if(damageapllied==true) then
				self:BruteUnrage()
			end
		else
			if(alldamages==true) then
				self:BruteUnrage()
			end
		end
	end
end

function ENT:BruteRage()
	self.Raged = true
end

function ENT:BruteUnrage()
	self.RageTime = 0
	self.Rage = 0
	self.RageTimeMax = math.random(10,15)
	
	self.Raged = false
end

function ENT:KFNPCMeleeAttackEvent()
	self.RageTime = 0
	self.RageTimeMax = math.random(10,15)
end