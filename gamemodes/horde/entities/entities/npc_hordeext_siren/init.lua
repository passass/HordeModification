if(!file.Exists("lua/entities/kf_ai/init.lua","THIRDPARTY")) then
	
	return
end

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
include("KFNPCBaseVars.lua")

ENT.VJ_NPC_Class = {"CLASS_ZOMBIE", "CLASS_XEN"}
VJ.AddNPC("Siren","npc_hordeext_siren", "Zombies")
ENT.StunInStun = true

ENT.GoreEnabled[HITGROUP_LEFTARM] = false
ENT.GoreEnabled[HITGROUP_RIGHTARM] = false


ENT.GoreHead.model = "models/Tripwire/Killing Floor/Zeds/KFSirenGoreHead.mdl"

ENT.GoreLLeg.model = "models/Tripwire/Killing Floor/Zeds/KFSirenGoreLLeg.mdl"
ENT.GoreLLeg.bodygroup1 = 2

ENT.GoreRLeg.model = "models/Tripwire/Killing Floor/Zeds/KFSirenGoreRLeg.mdl"
ENT.GoreRLeg.bodygroup1 = 3


ENT.DieOnHeadLoss = true

ENT.DieSoundEnabled = true
ENT.DieSound.name = "KFMod.Siren.Die"
ENT.DieSound.min = 1
ENT.DieSound.max = 1

ENT.ChasingSoundEnabled = true
ENT.ChasingSound.name = "KFMod.Siren.Chase"
ENT.ChasingSound.min = 1
ENT.ChasingSound.max = 2

ENT.IdlingSoundEnabled = true
ENT.IdlingSound.name = "KFMod.Siren.Idle"
ENT.IdlingSound.min = 1
ENT.IdlingSound.max = 1

ENT.LastScream = nil

if CLIENT then
    language.Add("npc_hordeext_siren", "Siren")
end

function ENT:Initialize()
	self.Model = "models/Tripwire/Killing Floor/Zeds/KFSiren.mdl"
	self:KFNPCInit(Vector(-16,-16,70),MOVETYPE_STEP,nil,200,"*0.75","/1.5","*0.05")
	self.StunDamage = 0
	
	self:DropToFloor()
	
	local TEMP_MeleeHitTable = {}
	for S=1,6 do
		TEMP_MeleeHitTable[S] = "KFMod.BiteHit"..S
	end
	
	local TEMP_MeleeMissTable = {}
	TEMP_MeleeMissTable[1] = ""
						
	local TEMP_MeleeTable = self:KFNPCCreateMeleeTable()
	
	TEMP_MeleeTable.damage[1] = 13
	TEMP_MeleeTable.damagetype[1] = DMG_CLUB
	TEMP_MeleeTable.distance[1] = 20
	TEMP_MeleeTable.radius[1] = 30
	TEMP_MeleeTable.time[1] = 0.5
	TEMP_MeleeTable.bone[1] = "CHR_Head"
	self:KFNPCSetMeleeParamsGesture(1,"S_Melee1",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)

	self:KFNPCSetMeleeParamsGesture(2,"S_Melee2",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
end

local function KF_Siren_IsEnemyNPC(self,ENT2)
	if((ENT2:IsNPC()||ENT2:IsNextBot())&&ENT2:Disposition(self)==D_HT&&ENT2.IsKFZed!=true) then
		return true
	end
	
	return false
end

local function KF_Siren_IsEnemyPlayer(ENT2)
	if(ENT2:IsPlayer()&&ENT2:Alive()&&((ENT2:GetNWBool("BeZed_IsZed",false)==false||GetConVar("kf_pill_zed_friendly"):GetInt()==0))
	&&GetConVar("ai_ignoreplayers"):GetInt()==0) then
		return true
	end
	
	return false
end


local function KF_Siren_CanAttackThis(self,ENT2)
	if(KF_Siren_IsEnemyNPC(self,ENT2)||KF_Siren_IsEnemyPlayer(ENT2)) then
		return true
	end
end

function ENT:KFNPCDistanceForMeleeTooBig()
	if(KF_Siren_CanAttackThis(self,self:GetEnemy())&&(self:GetPos()+self:OBBCenter()):Distance((self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()))<600&&
	self.PlayingAnimation==false&&!self:KFNPCIsOnFire()&&!self:KFNPCIsHeadless()) then
		self:KFNPCPlayGesture("S_RangedScream",2)
		
		local TEMP_FirstScream = true
		
		
		timer.Create("StartAttack"..tostring(self),1.5,1,function()
			if(IsValid(self)&&self!=nil&&self!=NULL) then
				self:EmitSound("KFMod.Siren.Scream")
				
				timer.Create("Attack"..tostring(self),0.2,12,function()
					if(IsValid(self)&&self!=nil&&self!=NULL) then
						local TEMP_Attachment = self:GetAttachment(self:LookupAttachment("eye"))
						
						local TEMP_Siren_Scream = ents.Create("ent_sirenscream")			
						TEMP_Siren_Scream:SetPos(TEMP_Attachment.Pos)
						TEMP_Siren_Scream:SetAngles(TEMP_Attachment.Ang)
						TEMP_Siren_Scream:Spawn()
	
						TEMP_Siren_Scream:SetOwner(self)
	
						TEMP_Siren_Scream:SetModelScale(0)
						
						self.LastScream = TEMP_Siren_Scream
					end
				end) 
				
				timer.Create("MidAttack"..tostring(self),0.5,6,function()
					if(IsValid(self)&&self!=nil&&self!=NULL) then
						local TEMP_Attachment = self:GetAttachment(self:LookupAttachment("eye"))
						local TEMP_MyNearbyTargets = ents.FindInSphere(TEMP_Attachment.Pos,450)
			
						if (#TEMP_MyNearbyTargets>0) then 
							for T=1, #TEMP_MyNearbyTargets do
							
								local TEMP_ENT = TEMP_MyNearbyTargets[T]
								
								if(((TEMP_ENT:IsPlayer()&&self:Disposition(TEMP_ENT)==D_HT&&TEMP_ENT:Alive()&&GetConVar("ai_ignoreplayers"):GetInt()!=1)||
								((TEMP_ENT:IsNPC()||TEMP_ENT:IsNextBot())&&TEMP_ENT:Disposition(self)==D_HT))&&TEMP_ENT:Visible(self)&&TEMP_ENT!=self) then
									local TEMP_TakenDamage = (5*self.DMGMult)*math.Clamp((451-TEMP_ENT:NearestPoint(self:GetPos()):Distance(self:GetPos()))/450,0.01,1)
									
									if((TEMP_ENT:IsPlayer()&&TEMP_ENT:Alive())||TEMP_ENT:IsNPC()||TEMP_ENT:IsNextBot()) then
										local TEMP_SPDMOD = 30
										
										if(TEMP_ENT:IsOnGround()) then
											TEMP_SPDMOD = TEMP_SPDMOD*5
										end
										
										TEMP_ENT:SetVelocity(((self:GetPos()-TEMP_ENT:GetPos()):GetNormalized()*TEMP_SPDMOD)-
										(TEMP_ENT:GetVelocity()/4))
									end
									
									if(TEMP_ENT:IsPlayer()&&TEMP_ENT:Health()>TEMP_TakenDamage) then
										if(TEMP_ENT:HasGodMode()==false&&(game.SinglePlayer()||
										(!game.SinglePlayer()&&GetConVar("sbox_godmode"):GetInt()==0))) then
											TEMP_ENT:SetHealth(TEMP_ENT:Health()-TEMP_TakenDamage)
										end
										
										util.ScreenShake( self:GetPos(), 7, 5, 2, 700 )
									else
										local TEMP_TargetDamage = DamageInfo()
										TEMP_TargetDamage:SetDamage(TEMP_TakenDamage)
										if(IsValid(self.LastScream)) then
											TEMP_TargetDamage:SetInflictor(self.LastScream)
										else
											TEMP_TargetDamage:SetInflictor(self)
										end
										TEMP_TargetDamage:SetDamageType(DMG_SONIC)
										TEMP_TargetDamage:SetAttacker(self)
										TEMP_TargetDamage:SetDamagePosition(self:GetPos())
										TEMP_ENT:TakeDamageInfo(TEMP_TargetDamage, self)
									end
								end
								
								if(TEMP_ENT:GetClass()=="npc_grenade_frag"||TEMP_ENT:GetClass()=="ent_planted_pipebomb"||
								TEMP_ENT:GetClass()=="rpg_missile") then
									TEMP_ENT:Remove()
								end
								
							end
						end
					end
				end) 
				
			end
		end)
		
		timer.Create("EndAttack"..tostring(self),(self:SequenceDuration(self:LookupSequence(self.Animation))/2)+0.1,1,function()
			if(IsValid(self)&&self!=nil&&self!=NULL) then
				self:KFNPCStopAllTimers()
				self:KFNPCClearAnimation()
			end
		end)
	end

end

function ENT:KFNPCThink()
	if(self:IsMoving()&&self.CanManipulateActivity==true) then
		if(self:GetMovementActivity()!=self.WalkAct) then
			self:SetMovementActivity(self.WalkAct)
		end
	end
end