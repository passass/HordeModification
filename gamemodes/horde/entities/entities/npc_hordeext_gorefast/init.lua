if(!file.Exists("lua/entities/kf_ai/init.lua","THIRDPARTY")) then
	
	return
end

ENT.VJ_NPC_Class = {"CLASS_ZOMBIE", "CLASS_XEN"}

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
include("KFNPCBaseVars.lua")

ENT.StunInStun = true


ENT.GoreHead.model = "models/Tripwire/Killing Floor/Zeds/KFGorefastGoreHead.mdl"
ENT.GoreRArm.model = "models/Tripwire/Killing Floor/Zeds/KFGorefastGoreRHand.mdl"
ENT.GoreRLeg.model = "models/Tripwire/Killing Floor/Zeds/KFGorefastGoreRLeg.mdl"
ENT.GoreLLeg.model = "models/Tripwire/Killing Floor/Zeds/KFGorefastGoreLLeg.mdl"

ENT.GoreRArm.bodygroup1 = 2
ENT.GoreLLeg.bodygroup1 = 3
ENT.GoreRLeg.bodygroup1 = 4


ENT.PainSoundEnabled = true
ENT.PainSound.name = "KFMod.Gorefast.Pain"
ENT.PainSound.min = 1
ENT.PainSound.max = 9

ENT.DieSoundEnabled = true
ENT.DieSound.name = "KFMod.Gorefast.Die"
ENT.DieSound.min = 1
ENT.DieSound.max = 4

ENT.MeleeSoundEnabled = true
ENT.MeleeSound.name = "KFMod.Gorefast.Attack"
ENT.MeleeSound.min = 1
ENT.MeleeSound.max = 4

ENT.ChasingSoundEnabled = true
ENT.ChasingSound.name = "KFMod.Gorefast.Chase"
ENT.ChasingSound.min = 1
ENT.ChasingSound.max = 4

ENT.IdlingSoundEnabled = true
ENT.IdlingSound.name = "KFMod.Gorefast.Idle"
ENT.IdlingSound.min = 1
ENT.IdlingSound.max = 8

ENT.MeleeAttackDistance = 23

ENT.GoreEnabled[HITGROUP_LEFTARM] = false

if CLIENT then
    language.Add("npc_hordeext_gorefast", "Gorefast")
end
function ENT:Initialize()
	self.Model = "models/Tripwire/Killing Floor/Zeds/KFGorefast.mdl"
	self:KFNPCInit(Vector(17,17,70),MOVETYPE_STEP,nil, 150, nil, "*0.3")
	
	self:DropToFloor()
	
	local TEMP_MeleeHitTable = {}
	for S=1,6 do
		TEMP_MeleeHitTable[S] = "KFMod.Gorefast.SwordHit"..S
	end
	
	local TEMP_MeleeMissTable = {}
	for S=1,4 do
		TEMP_MeleeMissTable[S] = "KFMod.Gorefast.SwordMiss"..S
	end
						
	local TEMP_MeleeTable = self:KFNPCCreateMeleeTable()
	TEMP_MeleeTable.damage[1] = 15
	TEMP_MeleeTable.damagetype[1] = DMG_SLASH
	TEMP_MeleeTable.distance[1] = 30
	TEMP_MeleeTable.radius[1] = 60
	TEMP_MeleeTable.time[1] = 0.8
	TEMP_MeleeTable.bone[1] = "CHR_FreakPalm"
	TEMP_MeleeTable.damage[2] = 15
	TEMP_MeleeTable.damagetype[2] = DMG_SLASH
	TEMP_MeleeTable.distance[2] = 30
	TEMP_MeleeTable.radius[2] = 60
	TEMP_MeleeTable.time[2] = 1.1
	TEMP_MeleeTable.bone[2] = "CHR_FreakPalm"
	self:KFNPCSetMeleeParamsGesture(1,"S_Melee1",2, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	TEMP_MeleeTable.damage[1] = 15
	TEMP_MeleeTable.damagetype[1] = DMG_SLASH
	TEMP_MeleeTable.distance[1] = 30
	TEMP_MeleeTable.radius[1] = 60
	TEMP_MeleeTable.time[1] = 0.65
	TEMP_MeleeTable.bone[1] = "CHR_FreakPalm"
	TEMP_MeleeTable.damage[2] = 15
	TEMP_MeleeTable.damagetype[2] = DMG_SLASH
	TEMP_MeleeTable.distance[2] = 30
	TEMP_MeleeTable.radius[2] = 60
	TEMP_MeleeTable.time[2] = 0.9
	TEMP_MeleeTable.bone[2] = "CHR_FreakPalm"
	self:KFNPCSetMeleeParamsGesture(2,"S_Melee2",2, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	self.MoveChance = math.max(10,self.Difficulty*10)
end

function ENT:KFNPCFlinchCondition() 
	if(self.Animation!=self.StunSequence) then
		return true
	end
	return false
end



function ENT:KFNPCThink()

	if(self:IsMoving()&&self.CanManipulateActivity==true) then
		if(IsValid(self:GetEnemy())&&self:GetEnemy()!=nil&&self:GetEnemy()!=NULL) then
			if(self:GetEnemy():GetPos():Distance(self:GetPos())>1000||!self:GetEnemy():Visible(self)) then
				
				if(self:GetMovementActivity()!=self.WalkAct) then
					self:SetMovementActivity(self.WalkAct)
				end
			else
				if(self:GetMovementActivity()!=self.RunAct) then
					self:SetMovementActivity(self.RunAct)
				end
			end
		end
	end
end

function ENT:KFNPCMeleeAttackEvent()
	local TEMP_MoveChance = math.random(1,100)
	
	if(TEMP_MoveChance>self.MoveChance) then
		self.MustNotMove = true
		self:StopMoving()
	end
end