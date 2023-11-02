AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

ENT.m_fMaxYawSpeed = 240
ENT.m_iClass = CLASS_NONE

AccessorFunc( ENT, "m_iClass", "NPCClass", FORCE_NUMBER )
AccessorFunc( ENT, "m_fMaxYawSpeed", "MaxYawSpeed", FORCE_NUMBER )

//Initialize
function ENT:KFNPCInit(VEC,MTYPE,CAPS,HP,HPAdd,HHP,HHPAdd,HHPAHP)
	
	if(!CAPS) then
		CAPS = {}
	end
	
	if(!HPAdd) then
		HPAdd = "0"
	end
	
	if(!HHP) then
		HHP = "0"
	end
	
	if(!HHPAHP) then
		HHPAHP = 0
	end
	
	if(!HHPAdd) then
		HHPAdd = "0"
	end
	
	--local TEMP_HPPE = 1
	local TEMP_PNum = 1
	
	
	self.FlinchDamage = 5
	
	self.NeedStun = false
	self.NeedFlinch = false
	
	local TEMP_Diff = HORDE.difficulty
	
	self.DMGMult = 1
	self.HPMult = 1
	self.RunAct = ACT_RUN
	self.WalkAct = ACT_WALK
	
	--if (TEMP_Diff==0) then
	--	self.DMGMult = 0.3
	--	self.HPMult = 0.5
		self.WalkAct = ACT_WALK_CROUCH
		self.RunAct = ACT_RUN_CROUCH
	--elseif (TEMP_Diff==2) then
	--	self.DMGMult = 1.25
	--	self.HPMult = 1.35
		--self.WalkAct = ACT_WALK_AIM_RELAXED
		--self.RunAct = ACT_RUN_AIM_RELAXED
	--elseif (TEMP_Diff==3) then
	--self.WalkAct = ACT_WALK_AIM_STIMULATED
	--self.RunAct = ACT_RUN_AIM_STIMULATED
	--elseif (TEMP_Diff==4) then
		--self.WalkAct = ACT_WALK_AIM_AGITATED
		--self.RunAct = ACT_RUN_AIM_AGITATED
	--end

	local enemy_wave = ((HORDE.current_wave - 1) % HORDE.max_max_waves) + 1

	local enemy_data = HORDE.enemies[self:GetClass() .. tostring(enemy_wave)]

	if enemy_data and enemy_data.is_elite and enemy_data.is_elite == true then
		local players_count = table.Count(player.GetAll())

        local scale
        local add
        if enemy_data.boss_properties and enemy_data.boss_properties.is_boss == true then
            scale = players_count
            add = 0.75
        else
            scale = math.min(8, players_count)
            add = 0.60
            if scale > 4 then
                add = 0.55
            end
        end
        self.HPMult = self.HPMult *
		math.max(
			HORDE.difficulty_elite_health_scale_multiplier[HORDE.difficulty],
			scale * HORDE.difficulty_elite_health_scale_multiplier[HORDE.difficulty] * (add + HORDE.difficulty_elite_health_scale_add[HORDE.difficulty])
		)
    end

	if HORDE.endless == 1 then
        self.HPMult = self.HPMult * HORDE.endless_health_multiplier
    end
	self.HPMult = self.HPMult * HORDE.difficulty_health_multiplier[TEMP_Diff]
	
	self.Difficulty = TEMP_Diff
	
	local TEMP_Health = HP * self.HPMult
	
	if(HPAdd!="0") then
		local TEMP_Symb = string.sub(HPAdd,1,1)
		local TEMP_Num = tonumber(string.sub(HPAdd,2,string.len(HPAdd)))
		
		if(TEMP_Symb=="*") then
			TEMP_Health = TEMP_Health+((TEMP_Health*(TEMP_PNum-1))*TEMP_Num)
		elseif(TEMP_Symb=="/") then
			TEMP_Health = TEMP_Health+((TEMP_Health*(TEMP_PNum-1))/TEMP_Num)
		end
	end
	
	if HHPAHP == 0 and HHP != "0" then
		local TEMP_Symb = string.sub(HHP,1,1)
		local TEMP_Num = tonumber(string.sub(HHP,2,string.len(HHP)))
		
		if(TEMP_Symb=="*") then
			self.HeadHealth = TEMP_Health*TEMP_Num
		elseif(TEMP_Symb=="/") then
			self.HeadHealth = TEMP_Health/TEMP_Num
		elseif(TEMP_Symb=="=") then
			self.HeadHealth = TEMP_Num
		end
	end
	
	self:SetHealth(TEMP_Health / self.HPMult)
	self.StunDamage = TEMP_Health / 1.5
	self:SetMaxHealth(self:Health())
	
	if(HHPAHP==1) then
		if(HHP!="0") then
			local TEMP_Symb = string.sub(HHP,1,1)
			local TEMP_Num = tonumber(string.sub(HHP,2,string.len(HHP)))
			
			if(TEMP_Symb=="*") then
				self.HeadHealth = self:Health()*TEMP_Num
			elseif(TEMP_Symb=="/") then
				self.HeadHealth = self:Health()/TEMP_Num
			elseif(TEMP_Symb=="=") then
				self.HeadHealth = TEMP_Num
			end
		end
	end
	
	if(HHPAdd!="0") then
		local TEMP_Symb = string.sub(HHPAdd,1,1)
		local TEMP_Num = tonumber(string.sub(HHPAdd,2,string.len(HHPAdd)))
		
		if(TEMP_Symb=="*") then
			self.HeadHealth = self.HeadHealth+((self.HeadHealth*(TEMP_PNum-1))*TEMP_Num)
		elseif(TEMP_Symb=="/") then
			self.HeadHealth = self.HeadHealth+((self.HeadHealth*(TEMP_PNum-1))/TEMP_Num)
		end
	end
	
	self.MaxHeadHealth = self.HeadHealth
	
	self:SetModel( self.Model )
	
	self:SetCustomCollisionCheck()
	
	self:SetHullSizeNormal()
	if(isvector(VEC)) then
		VEC = Vector(math.abs(VEC.x),math.abs(VEC.y),math.abs(VEC.z))
		
		self:SetCollisionBounds(Vector(-VEC.x,-VEC.y,0),VEC)
	elseif(istable(VEC)) then
		self:SetCollisionBounds(VEC[1],VEC[2])
	end
	
	self:SetSolid(SOLID_BBOX)
	
	self:SetCollisionGroup(COLLISION_GROUP_NPC)

	self:SetUseType(SIMPLE_USE)
	
	self:SetMoveType( MTYPE )
	self:CapabilitiesAdd( bit.bor(CAP_MOVE_GROUND, CAP_AUTO_DOORS, CAP_USE, CAP_SQUAD, CAP_OPEN_DOORS, CAP_SKIP_NAV_GROUND_CHECK) )
	
	self:SetSaveValue("m_bCheckContacts",true)
	self:SetSaveValue("m_takedamage",2)
	self:SetSaveValue("squadname","Zeds")
	
	if(#CAPS>0) then
		for C=1,#CAPS do
			self:CapabilitiesAdd( CAPS[C] )
		end
	end
	
	self:SetBloodColor(DONT_BLEED)
	
	self:AddEFlags(EFL_NO_DISSOLVE)

	if(IsValid(self:GetActiveWeapon())) then
		self:GetActiveWeapon():Remove()
	end
	
	self:SetEnemy(nil)
	
	self:DropToFloor()
	
	
	self.Hard = GetConVar("kf_npc_hardmode"):GetInt()
	self.Gore = GetConVar("kf_npc_gore"):GetInt()
	
	self:Activate()
	
	
	duplicator.RegisterEntityClass( self:GetClass(), function( ply, data )
		duplicator.GenericDuplicatorFunction( ply, data )
	end, "Data" )
	
	
	
	self.FollowPosTime = 0
	self.LastPositionFails = 0
	self.LastPosition = self:GetPos()
	self.CantChaseTargetTimes = 0
	self.FollowLen = 99
	
	self.TakenDamageMultiplier = GetConVar("kf_npc_taken_dmg_scale"):GetInt()
	self:KFNPCAfterInit()
end

function ENT:KFNPCCanAttackThis(ENT2)
	if(IsValid(ENT2)&&self:KFNPCIsEnemyNPC(ENT2)||self:KFNPCIsEnemyPlayer(ENT2)||KFNPCIsProp(ENT2)) then
		return true
	end
end

function ENT:KFNPCIsEnemyNPC(ENT2)
	if(IsValid(ENT2)&&((ENT2:IsNPC()&&ENT2:GetNPCState()!=NPC_STATE_DEAD)||
	(ENT2:IsNextBot()&&(!ENT2.IsDrGNextbot||(!ENT2:IsDown()&&!ENT2:IsDead()))))&&
	(!KFNPCIsZombie(ENT2)||(ENT2==self:GetEnemy()||self==ENT2:GetEnemy()))) then
		return true
	end
	
	return false
end
	
function ENT:KFNPCIsEnemyPlayer(ENT2)
	if(IsValid(ENT2)&&ENT2:IsPlayer()&&ENT2:Alive()&&((ENT2:GetNWBool("BeZed_IsZed",false)==false||GetConVar("kf_pill_zed_friendly"):GetInt()==0)||
	ENT2==self:GetEnemy())&&GetConVar("ai_ignoreplayers"):GetInt()==0) then
		return true
	end
	
	return false
end

function KFNPCIsProp(ENT2)
	if(IsValid(ENT2)&&((IsValid(ENT2:GetPhysicsObject())&&ENT2:GetCollisionGroup()!=COLLISION_GROUP_DEBRIS
	&&ENT2:GetCollisionGroup()!=COLLISION_GROUP_DEBRIS_TRIGGER&&ENT2:GetCollisionGroup()!=COLLISION_GROUP_VEHICLE_CLIP
	&&ENT2:GetCollisionGroup()!=COLLISION_GROUP_DISSOLVING&&ENT2:GetCollisionGroup()!=COLLISION_GROUP_PUSHAWAY
	&&ENT2:GetCollisionGroup()!=COLLISION_GROUP_WORLD)||
	KFNPCIsWeldedDoor(ENT2))&&!ENT2:IsPlayer()&&!ENT2:IsNPC()&&!ENT2:IsNextBot()) then
		return true
	end
	return false
end
function KFNPCIsZombie(NPC)
	if(IsValid(NPC)&&NPC:IsNPC()&&(NPC:Classify()==CLASS_ZOMBIE||NPC:Classify()==CLASS_HEADCRAB||
	NPC.SNPCClass=="C_ZOMBIE"||NPC.SNPCClass=="C_MONSTER_CAT"||
	NPC.SNPCClass=="C_MONSTER_SAVAGE"||NPC.SNPCClass=="C_MONSTER_LAB"||NPC.SNPCClass=="C_MONSTER_CONTROLLER")) then
		return true
	end
		
	return false
end

function ENT:KFNPCRotateCorrectly(YAW,SPD)
	if(!SPD) then
		SPD = 30
	end
	
	local TEMP_DIFF = (YAW)-self:GetAngles().Yaw
	local TEMP_YAW = math.NormalizeAngle(TEMP_DIFF)
	TEMP_YAW = math.Clamp(TEMP_YAW,-SPD,SPD)
	
	if(math.abs(TEMP_DIFF)>179&&TEMP_YAW==0) then
		TEMP_YAW = math.Clamp(TEMP_DIFF,-0.2,0.2)
	end
	
	self:SetAngles(Angle(0,self:GetAngles().Yaw+TEMP_YAW,0))
end

//Think
function ENT:KFNPCAnimEnemyIsValid()
	if(self.PlayingAnimation==true&&self.AttackIndex==1&&!self:IsMoving()) then
		self:KFNPCRotateCorrectly((self:GetEnemy():GetPos()-self:GetPos()):Angle().Yaw)
	end
end

function ENT:KFNPCTryToFindEnemy()
	local TEMP_VisibleTargets = {}
	local TEMP_NearEnemyCount = 0
	local TEMP_PossibleTarget = NULL
	
	
	local TEMP_NearestNpcDistance = 7000
	local TEMP_NearestNpc = self
	

	local TEMP_MyNearbyTargets = ents.FindByClass("npc_*")
	local TEMP_MyNearbyTargetsAdd = ents.FindByClass("drg_*")

	table.Add(TEMP_MyNearbyTargets,TEMP_MyNearbyTargetsAdd)
	
	if (#TEMP_MyNearbyTargets>0) then 
		for T=1, #TEMP_MyNearbyTargets do
			local TEMP_NPC = TEMP_MyNearbyTargets[T]
			
			if(IsValid(TEMP_NPC)&&TEMP_NPC!=nil&&TEMP_NPC!=NULL&&TEMP_NPC!=self) then
				if(TEMP_NPC:IsNPC()||TEMP_NPC:IsNextBot()) then
					if(KFNPCIsZombie(TEMP_NPC)&&TEMP_NPC:Disposition(self)!=D_HT) then
						self:AddEntityRelationship(TEMP_NPC,D_LI,self.Hate)
						TEMP_NPC:AddEntityRelationship(self,D_LI,self.Hate)
					else
						if(TEMP_NPC:Disposition(self)!=D_HT&&TEMP_NPC:Disposition(self)!=D_LI) then
							self:AddEntityRelationship(TEMP_NPC,D_HT,self.Hate)
							TEMP_NPC:AddEntityRelationship(self,D_HT,self.Hate)
						end
					
						if(TEMP_NPC:Disposition(self)==D_HT&&self:KFNPCIsEnemyNPC(TEMP_NPC)) then
							if(T==1) then
								TEMP_NearestNpcDistance = self:GetPos():Distance(TEMP_NPC:GetPos())
								TEMP_NearestNpc = TEMP_NPC
							else
								if(self:GetPos():Distance(TEMP_NPC:GetPos())<TEMP_NearestNpcDistance) then
									TEMP_NearestNpcDistance = self:GetPos():Distance(TEMP_NPC:GetPos())
									TEMP_NearestNpc = TEMP_NPC
								end
							end
							
							if(self.NearestEnemyFindDistance>0) then
								if(self:KFNPCEnemyInMeleeRange(TEMP_NPC,0,self.NearestEnemyFindDistance)==2) then
									TEMP_NearEnemyCount = TEMP_NearEnemyCount+1
								end
							end
							
							if(TEMP_NPC:Visible(self)) then
								table.insert(TEMP_VisibleTargets, TEMP_NPC)
							end
						end
						
					end
				end
			end
		end
	end
	
	
	
	local TEMP_NearestPlayerDistance = 32000
	local TEMP_NearestPlayer = NULL
	
	if(GetConVar("ai_ignoreplayers"):GetInt()!=1) then
		for P=1, #player.GetAll() do
			local TEMP_PL = player.GetAll()[P]
			
			if(self:KFNPCIsEnemyPlayer(TEMP_PL)) then
				if(P==1) then
					TEMP_NearestPlayerDistance = self:GetPos():Distance(TEMP_PL:GetPos())
					TEMP_NearestPlayer = TEMP_PL
				else
					if(self:GetPos():Distance(TEMP_PL:GetPos())<TEMP_NearestPlayerDistance) then
						TEMP_NearestPlayerDistance = self:GetPos():Distance(TEMP_PL:GetPos())
						TEMP_NearestPlayer = TEMP_PL
					end
				end
				
				if(self.NearestEnemyFindDistance>0) then
					if(self:KFNPCEnemyInMeleeRange(TEMP_PL,0,self.NearestEnemyFindDistance)==2) then
						TEMP_NearEnemyCount = TEMP_NearEnemyCount+1
					end
				end
				
				if(TEMP_PL:Visible(self)) then
					table.insert(TEMP_VisibleTargets, TEMP_PL)
				end
			end
		end
	end
	
	local TEMP_NearestTargetVisDistance = 0
	local TEMP_NearestTargetVis = NULL
	
	if(#TEMP_VisibleTargets>0) then
		for T=1, #TEMP_VisibleTargets do
			local TEMP_TG = TEMP_VisibleTargets[T]
			
			if(T==1) then
				TEMP_NearestTargetVisDistance = self:GetPos():Distance(TEMP_TG:GetPos())
				TEMP_NearestTargetVis = TEMP_TG
			else
				if(self:GetPos():Distance(TEMP_TG:GetPos())<TEMP_NearestTargetVisDistance) then
					TEMP_NearestTargetVisDistance = self:GetPos():Distance(TEMP_TG:GetPos())
					TEMP_NearestTargetVis = TEMP_TG
				end
			end
		end
	end
	
	if(TEMP_NearestTargetVis!=NULL) then
		TEMP_PossibleEnemy = TEMP_NearestTargetVis
	else
		if(TEMP_NearestNpc!=NULL&&TEMP_NearestPlayer!=NULL) then
			if(TEMP_NearestNpcDistance<TEMP_NearestPlayerDistance) then
				TEMP_PossibleEnemy = TEMP_NearestNpc
			else
				TEMP_PossibleEnemy = TEMP_NearestPlayer
			end
		elseif(TEMP_NearestPlayer!=NULL) then
			TEMP_PossibleEnemy = TEMP_NearestPlayer
		elseif(TEMP_NearestNpc!=NULL) then
			TEMP_PossibleEnemy = TEMP_NearestNpc
		end
	end
	
	if(IsValid(TEMP_PossibleEnemy)&&TEMP_PossibleEnemy!=nil&&TEMP_PossibleEnemy!=NULL&&TEMP_PossibleEnemy!=self) then
		if(!IsValid(self:GetEnemy())||self:GetEnemy()==nil||self:GetEnemy()==NULL||
		(TEMP_PossibleEnemy:GetPos():Distance(self:GetPos())<self:GetEnemy():GetPos():Distance(self:GetPos())&&
		((!TEMP_PossibleEnemy:Visible(self)&&!self:GetEnemy():Visible(self))||
		(TEMP_PossibleEnemy:Visible(self)&&!self:GetEnemy():Visible(self))||
		(TEMP_PossibleEnemy:Visible(self)&&self:GetEnemy():Visible(self))))) then
			local TEMP_LastEnemy = self:GetEnemy()
			
			self:AddEntityRelationship( TEMP_PossibleEnemy, D_HT, self.Hate )
			self:SetEnemy(TEMP_PossibleEnemy)
			self.RegEnemy = TEMP_PossibleEnemy
			self:UpdateEnemyMemory(TEMP_PossibleEnemy,TEMP_PossibleEnemy:GetPos())
			
			if(TEMP_PossibleEnemy!=TEMP_LastEnemy) then
				self:SelectSchedule()
			end
		end
	end
	
	return TEMP_NearEnemyCount
end

function ENT:KFNPCIsOnFire()
	if((self.AutoChangeActivityWhenOnFire==true&&(self.BurnTime<self.BurnTimeToPanic||self.BurnTime>self.BurnTimeToPanic+3))||
	self.AutoChangeActivityWhenOnFire==false) then
		return false
	end
	return true
end

function ENT:KFNPCIsHeadless()
	if((self.AutoChangeActivityWhenHeadless==true&&self.HeadLess==true)) then
		return true
	end
	return false
end

function KFNPCIsWeldedDoor(ENT2)
	if(IsValid(ENT2)&&ENT2:GetClass()=="prop_door_rotating"&&ENT2:GetSaveTable( ).m_bLocked==true&&ENT2:GetNWFloat("Welded",0)>0) then
		return true
	end
	
	return false
end

function ENT:KFNPCTestForJump()
	local TEMP_JumpMinZ = 18
	local TEMP_JumpForward = self:GetForward()*18
	
	local TEMP_ForwardTracer = util.TraceHull( {
		start = self:GetPos(),
		endpos = self:GetPos()+TEMP_JumpForward,
		filter = {self, self:GetEnemy()},
		mins = self:OBBMins()+Vector(0,0,TEMP_JumpMinZ),
		maxs = self:OBBMaxs(),
		mask = MASK_NPCSOLID
	} )
	
	if(TEMP_ForwardTracer.Hit) then
		if(TEMP_ForwardTracer.Entity:IsNPC()||TEMP_ForwardTracer.Entity:IsNextBot()) then
			if(!self.NPCTrHits) then
				self.NPCTrHits = 0
			end
			
			self.NPCTrHits = self.NPCTrHits+1
				
			if(self.NPCTrHits>=5) then
				self.NPCWalkAround = true
			end
		end
		
		if(IsValid(TEMP_ForwardTracer.Entity)&&(TEMP_ForwardTracer.Entity:IsNPC()||TEMP_ForwardTracer.Entity:IsPlayer()||
		TEMP_ForwardTracer.Entity:IsNextBot()||KFNPCIsWeldedDoor(TEMP_ForwardTracer.Entity))) then
			if((KFNPCIsWeldedDoor(TEMP_ForwardTracer.Entity)&&
			self:KFNPCEnemyInMeleeRange(TEMP_ForwardTracer.Entity,0,self.MeleeAttackDistance))
			||self:KFNPCIsEnemyNPC(TEMP_ForwardTracer.Entity)||self:KFNPCIsEnemyPlayer(TEMP_ForwardTracer.Entity)) then
				local TEMP_IND = self:KFNPCSelectMeleeAttack()
				self:KFNPCMeleePlay(TEMP_IND)
			end
			
			return
		end
		
		local TEMP_UpTracer = util.TraceHull( {
			start = self:GetPos(),
			endpos = self:GetPos()+Vector(0,0,self.JumpHeight*0.8),
			filter = self,
			mins = self:OBBMins(),
			maxs = self:OBBMaxs(),
			mask = MASK_NPCSOLID
		} )
		
		if((TEMP_UpTracer.StartPos-TEMP_UpTracer.HitPos):Length()>2) then
			local TEMP_JumpUpTracer = util.TraceHull( {
				start = Vector(self:GetPos().x,self:GetPos().y,TEMP_UpTracer.HitPos.z-self:OBBMaxs().z),
				endpos = Vector(self:GetPos().x,self:GetPos().y,TEMP_UpTracer.HitPos.z-self:OBBMaxs().z)+(TEMP_JumpForward*1.3),
				filter = {self, self:GetEnemy()},
				mins = self:OBBMins(),
				maxs = self:OBBMaxs(),
				mask = MASK_NPCSOLID
			} )
			
			if(!TEMP_JumpUpTracer.Hit) then
				self:KFNPCJump()
			end
		end
	end
end


//Another Functions
function KFNPCStringAdd(STR,STR2)
	if(#STR>0&&string.sub( STR, #STR, #STR )!=",") then
		STR = STR..","
	end
	
	return STR..STR2
end



//Gore
function ENT:KFNPCSetBodygoup(BG)
	if(isstring(BG)) then
		local TEMP_BGSTR = string.Explode(",",BG)
		
		if(#TEMP_BGSTR>0) then
			for B=1, #TEMP_BGSTR do
				self:SetBodygroup(tonumber(TEMP_BGSTR[B]),1)
			end
		end
	else
		self:SetBodygroup(BG,1)
	end
end

function KFNPCRemovePhysBonesByBones(PHYSENT,PHYS)
	local TEMP_STR = string.Explode(",",PHYS)
	
	for P=1, #TEMP_STR do
		if(isnumber(PHYSENT:LookupBone(TEMP_STR[P]))) then
			local TEMP_PhysBone = PHYSENT:GetPhysicsObjectNum(PHYSENT:TranslateBoneToPhysBone(PHYSENT:LookupBone(TEMP_STR[P])))
		
			if(TEMP_PhysBone:IsValid()) then
				TEMP_PhysBone:EnableCollisions(false)
				TEMP_PhysBone:SetMass(0.1)
			end
		end
	end
end

function ENT:KFNPCKillHead(DMGPOP,FORCE,DMG)
	local TEMP_FirstBone = string.Explode(",",self.GoreHead.bone)[1]
	local TEMP_FirstBoneMat = self:GetBoneMatrix(self:LookupBone(TEMP_FirstBone))
	local TEMP_FirstBonePos = TEMP_FirstBoneMat:GetTranslation()
		
	if(DMGPOP==true) then	
		for G=1,3 do
			self:KFNPCCreateGib(self.GoreHead.bone,"models/Tripwire/Killing Floor/Zeds/KFGoreBrain"..G..".mdl",FORCE,DMG,false)
		end
		
		for G=1,2 do
			self:KFNPCCreateGib(self.GoreHead.bone,"models/Tripwire/Killing Floor/Zeds/KFGoreEye.mdl",FORCE,DMG,false)
		end
	else
		self:KFNPCCreateGib(self.GoreHead.bone,self.GoreHead.model,FORCE,DMG,true)
		KFNPCBleed(self,math.random(130,150),TEMP_FirstBonePos,AngleRand())
	end
	
	self:KFNPCSetBodygoup(self.GoreHead.bodygroup1)
	sound.Play("KFMod.GoreDecap"..math.random(1,4),TEMP_FirstBonePos)
	self.HeadLess = true
	
	local TEMP_NECK = self:LookupBone("CHR_Neck")
	
	if(TEMP_NECK) then
		local TEMP_NeckPos, TEMP_NeckAng = self:GetBonePosition(TEMP_NECK)
		
		local CEffectData = EffectData()
		CEffectData:SetOrigin(TEMP_NeckPos)
		CEffectData:SetFlags(3)
		CEffectData:SetScale(math.random(7,9))
		CEffectData:SetColor(0)
		CEffectData:SetNormal(Vector(0,0,1))
		CEffectData:SetEntity(self)
		CEffectData:SetAngles(TEMP_NeckAng)
		util.Effect( "bloodspray", CEffectData, false,true )
	end
	
	self:KFNPCOnHeadLoss()
end

function KFNPCBleed(Ent,INT,Pos,Ang)
	ParticleEffect("kfmod_particle_blood",Ent:NearestPoint(Pos),Ang)
	/*local TEMP_CEffectData = EffectData()
	TEMP_CEffectData:SetOrigin(Pos)
	TEMP_CEffectData:SetFlags(3)
	TEMP_CEffectData:SetScale(INT)
	TEMP_CEffectData:SetColor(0)
	TEMP_CEffectData:SetNormal(Ang:Forward())
	TEMP_CEffectData:SetEntity(Ent)
	TEMP_CEffectData:SetAngles(Ang)
	util.Effect( "BloodImpact", TEMP_CEffectData, false )*/
end

function ENT:KFNPCCreateGib(BONE, MDL, FORCE, DMG, Bleed)
	local TEMP_Mat = self:GetBoneMatrix(self:LookupBone(BONE))
	local TEMP_Pos, TEMP_Ang = TEMP_Mat:GetTranslation(), TEMP_Mat:GetAngles()
	
	if(!DMG) then
		DMG = 100
	end
	
	local TEMP_Gib = ents.Create("ent_kf_bloody_gib")
	TEMP_Gib:SetModel(MDL)
	TEMP_Gib:SetPos(TEMP_Pos)
	TEMP_Gib:SetAngles(TEMP_Ang)
	TEMP_Gib:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	TEMP_Gib:Spawn()
	TEMP_Gib:Activate()
	
	TEMP_Gib:SetOwner(self)
	
	//TEMP_Gib:Fire("kill","",30)
	
	if(!isvector(FORCE)||!isnumber(FORCE.x)||!isnumber(FORCE.y)||!isnumber(FORCE.z)) then
		FORCE = Vector(math.random(-50,50),math.random(-50,50),math.random(-50,50)):GetNormalized()*(DMG*(math.random(70,130)/500))
	else
		FORCE = (FORCE:GetNormalized()+(Vector(math.random(-20,20),math.random(-20,20),math.random(-20,20))/100)):GetNormalized()*(DMG*((math.random(10,15)/1000)*FORCE:Length()))
	end
	
	local TEMP_GIBMINS, TEMP_GIBMAXS = TEMP_Gib:GetCollisionBounds()
	
	local TEMP_GIBTR = util.TraceHull( {
		start = TEMP_Gib:GetPos(),
		endpos = TEMP_Gib:GetPos(),
		filter = function(ent) if(!ent) then return true end end,
		mins = TEMP_GIBMINS,
		maxs = TEMP_GIBMAXS,
		mask = MASK_NPCSOLID
	} )
	
	if(TEMP_GIBTR.Hit) then
		KFNPCBleed(self,1,TEMP_Pos,AngleRand())
					
		local CEffectData = EffectData()
		CEffectData:SetOrigin(TEMP_Pos)
		CEffectData:SetFlags(3)
		CEffectData:SetScale(math.random(5,7))
		CEffectData:SetColor(0)
		CEffectData:SetNormal(-FORCE)
		CEffectData:SetAngles(TEMP_Ang)
		util.Effect( "bloodspray", CEffectData, false, true )
		
		TEMP_Gib:Remove()
		return
	end
	
	
	if(IsValid(TEMP_Gib)&&TEMP_Gib!=nil&&TEMP_Gib!=NULL) then
		local TEMP_GibPhys = TEMP_Gib:GetPhysicsObject()
		TEMP_GibPhys:SetVelocity(FORCE)
	end
			
	if(Bleed==true) then
		for T=1, 4 do
			timer.Simple(0.2*T,function()
				if(IsValid(TEMP_Gib)&&TEMP_Gib!=nil&&TEMP_Gib!=NULL) then
					KFNPCBleed(TEMP_Gib,1,TEMP_Gib:GetPos(),AngleRand())
					
					local CEffectData = EffectData()
					CEffectData:SetOrigin(TEMP_Gib:GetPos())
					CEffectData:SetFlags(3)
					CEffectData:SetScale(math.random(5,7))
					CEffectData:SetColor(0)
					CEffectData:SetNormal(-TEMP_Gib:GetVelocity())
					CEffectData:SetEntity(TEMP_Gib)
					CEffectData:SetAngles(TEMP_Gib:GetAngles())
					util.Effect( "bloodspray", CEffectData, false )
				end
			end)
		end
	end
	
	self:KFNPCGibCreated(TEMP_Gib)
end

function ENT:KFNPCKill(dmginfo,PHYSTABLE,BoomDamage)
	
	if(self.IsAlive==true) then
		self.IsAlive = false
		
		self:KFNPCStopAllTimers()
		self.Animation = ""
		self.AttackIndex = 0
		
		if(!PHYSTABLE) then
			PHYSTABLE = ""
		end
		
		if(BoomDamage==nil) then
			BoomDamage = dmginfo:IsExplosionDamage()
		end
		
		local TEMP_KillTime = 2
		
		if(self.DieSoundEnabled==true) then
			self:KFNPCStopPreviousSound()
			self:KFNPCPlaySoundRandom(100,self.DieSound.name,self.DieSound.min,self.DieSound.max)
		end

		local TEMP_ATTACKER = dmginfo:GetAttacker()
		local TEMP_INFLICTOR = dmginfo:GetInflictor()
		
		local TEMP_IsRagdollSpawn, TEMP_DMGTODESTROY = self:KFNPCOnCreateRagdoll(dmginfo,BoomDamage)
		
		if(!isnumber(TEMP_DMGTODESTROY)) then
			TEMP_DMGTODESTROY = dmginfo:GetDamage()
		end
		
		local TEMP_OWNERVEL = self:GetVelocity()
		
		if(TEMP_ATTACKER:IsPlayer()) then
			if(GetConVar("kf_npc_count_kills"):GetInt()==1) then
				TEMP_ATTACKER:AddFrags(1)
			end
		end
		
		if((GetConVar("kf_npc_death_messages"):GetInt()==1&&self.BigZed==true)||GetConVar("kf_npc_death_messages"):GetInt()==2) then
			if(TEMP_ATTACKER:IsPlayer()) then
				net.Start( "PlayerKilledNPC" )
					net.WriteString( self:GetClass() )
					net.WriteString( TEMP_INFLICTOR:GetClass() )
					net.WriteEntity( TEMP_ATTACKER )
				net.Broadcast()
			else
				net.Start( "NPCKilledNPC" )
					net.WriteString( self:GetClass() )
					net.WriteString( TEMP_INFLICTOR:GetClass() )
					net.WriteString( TEMP_ATTACKER:GetClass() )
				net.Broadcast()
			end
		end
		
		self:SetMaterial("")
		self:ClearSchedule()
		self:SetNPCState(NPC_STATE_DEAD)
		
		local TEMP_BodyString = ""
			
		for B=0, self:GetNumBodyGroups() do
			TEMP_BodyString = TEMP_BodyString..self:GetBodygroup(B)
		end

		if(!(IsValid(TEMP_ATTACKER)&&TEMP_ATTACKER!=nil&&TEMP_ATTACKER!=NULL&&TEMP_ATTACKER:GetClass()=="npc_barnacle")) then
			if(TEMP_IsRagdollSpawn==true&&!(BoomDamage==true&&TEMP_DMGTODESTROY>300)) then
				local TEMP_Ragdoll = ents.Create("prop_ragdoll")
				TEMP_Ragdoll:SetModel(self:GetModel())
				TEMP_Ragdoll:SetPos(self:GetPos())
				TEMP_Ragdoll:SetAngles(self:GetAngles())
				TEMP_Ragdoll:Spawn()
				
				TEMP_Ragdoll:SetMaterial(self:GetMaterial())
				TEMP_Ragdoll:SetBodyGroups(TEMP_BodyString)
				TEMP_Ragdoll:SetColor(self:GetColor())
				TEMP_Ragdoll:SetSkin(self:GetSkin())
				TEMP_Ragdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
				TEMP_Ragdoll:SetTrigger(false)
				

				for P=0, TEMP_Ragdoll:GetPhysicsObjectCount()-1 do
					local TEMP_Phys = TEMP_Ragdoll:GetPhysicsObjectNum(P)
					
					if(IsValid(TEMP_Phys)) then
						local TEMP_BoneMat = self:GetBoneMatrix(TEMP_Ragdoll:TranslatePhysBoneToBone(P))
						
						if(ismatrix(TEMP_BoneMat)) then
							local TEMP_BonePos, TEMP_BoneAng = TEMP_BoneMat:GetTranslation(), TEMP_BoneMat:GetAngles()
							
							TEMP_Phys:SetPos(TEMP_BonePos)
							TEMP_Phys:SetAngles(TEMP_BoneAng)
						end
						
						if(bit.band(dmginfo:GetDamageType(),DMG_DISSOLVE)!=0) then
							TEMP_Phys:EnableGravity(false)
						end
					end
				end
				
				for B=0, self:GetBoneCount()-1 do
					TEMP_Ragdoll:ManipulateBoneScale(B,self:GetManipulateBoneScale(B))
					TEMP_Ragdoll:ManipulateBonePosition(B,self:GetManipulateBonePosition(B))
					TEMP_Ragdoll:ManipulateBoneAngles(B,self:GetManipulateBoneAngles(B))
				end
				timer.Simple(0.01,function()
					if(IsValid(TEMP_Ragdoll)&&TEMP_Ragdoll!=nil&&TEMP_Ragdoll!=NULL) then
						TEMP_Ragdoll:SetVelocity(TEMP_OWNERVEL)
					end
				end)
				
				TEMP_Ragdoll:TakeDamageInfo(dmginfo)
				
				if(PHYSTABLE!="") then
					KFNPCRemovePhysBonesByBones(TEMP_Ragdoll,PHYSTABLE)
				end
				
				self:KFNPCRagdollCreated(TEMP_Ragdoll)
				
				if(GetConVar("kf_npc_corpse_dietime"):GetInt()>0) then
					TEMP_Ragdoll:Fire("kill","",GetConVar("kf_npc_corpse_dietime"):GetInt())
				end
				
				
				if(bit.band(dmginfo:GetDamageType(),DMG_DISSOLVE)!=0) then
					local TEMP_Dissolver = ents.Create("env_entity_dissolver")
					TEMP_Dissolver:SetPos(self:GetPos())
					TEMP_Dissolver:Spawn()
					
					local TEMP_Name = "KFRagdollToDissolve"..tostring(TEMP_Ragdoll)
					
					TEMP_Ragdoll:SetName(TEMP_Name)
				
					TEMP_Dissolver:Fire("dissolve",TEMP_Name,0)
					TEMP_Dissolver:Fire("kill","",0.1)
				end
				
				if(bit.band(dmginfo:GetDamageType(),DMG_REMOVENORAGDOLL)!=0) then
					TEMP_Ragdoll:Fire("kill","",0.1)
				end
				
				TEMP_KillTime = 0.1
				
			else
				local TEMP_BoxMin = self:GetPos()+self:OBBMins()
				local TEMP_BoxMax = self:GetPos()+self:OBBMaxs()
				
				ParticleEffect("kfmod_particle_blood_explosion",self:GetPos()+self:OBBCenter(),Angle(0,0,0))
				ParticleEffectAttach("kfmod_particle_blood_explosion_attach",PATTACH_ABSORIGIN,self,0)
					
				for P=1, 8 do
					local TEMP_RandomPos = Vector(math.random(TEMP_BoxMin.x,TEMP_BoxMax.x),math.random(TEMP_BoxMin.y,TEMP_BoxMax.y),math.random(TEMP_BoxMin.z,TEMP_BoxMax.z))
					
					if(P<6) then
						local TEMP_Prop = ents.Create("prop_physics")
						TEMP_Prop:SetModel("models/Tripwire/Killing Floor/Zeds/KFGoreChunk"..math.random(1,2)..".mdl")
						TEMP_Prop:SetPos(TEMP_RandomPos)
						TEMP_Prop:SetAngles(Angle(math.random(1,360),math.random(1,360),math.random(1,360)))
						TEMP_Prop:Spawn()
						
						TEMP_Prop:GetPhysicsObject():SetVelocity(Vector(math.random(-50,50),math.random(-50,50),math.random(-5,95)):GetNormalized()*(TEMP_DMGTODESTROY*(math.random(70,130)/100)))
						TEMP_Prop:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
						TEMP_Prop:Fire("kill","",30)
						
						TEMP_Prop:TakeDamageInfo(dmginfo)
					end
				end
				TEMP_KillTime = 0.1
			end
		else
			TEMP_KillTime = 0.1
		end
		
		if(self:IsOnFire()) then
			self:Extinguish()
		end
		
			
		self:KFNPCStopAllTimers()
		
		self:SetCollisionBounds(Vector(0,0,0),Vector(0,0,0))
		self:SetNoDraw(true)
		self:DrawShadow(false)
		self:SetSolid(SOLID_NONE)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetCondition(67)
		self:SetNPCState(NPC_STATE_DEAD)
		self:SetSchedule(SCHED_IDLE_STAND)
		
		self:Fire("kill","",TEMP_KillTime)
	end
end



//Melee
function ENT:KFNPCCreateMeleeTable()
	local TBL = {}
	TBL.damage = {}
	TBL.distance = {}
	TBL.radius = {}
	TBL.time = {}
	TBL.bone = {}
	TBL.damage = {}
	TBL.damagetype = {}
	TBL.distance = {}
	TBL.radius = {}
	TBL.time = {}
	TBL.bone = {}
	
	return TBL
end

function ENT:KFNPCRemoveMeleeTable(IND)
	self.MeleeDamageTime[IND] = {}
	self.MeleeDamageDamage[IND] = {}
	self.MeleeDamageType[IND] = {}
	self.MeleeDamageDistance[IND] = {}
	self.MeleeDamageBone[IND] = {}
	self.MeleeDamageRadius[IND] = {}
	
	self.MeleeAttackSequence[IND] = nil
	self.MeleeAttackGesture[IND] = nil
	self.MeleeDamageCount[IND] = nil
end

function ENT:KFNPCSetMeleeParams(NUM,SEQ,CNT,TBL,TBLH,TBLM)
	self.MeleeAttackSequence[NUM] = SEQ
	self.MeleeDamageCount[NUM] = CNT
	
	if(!self.MeleeHitSound[NUM]) then
		self.MeleeHitSound[NUM] = {}
	end
	
	if(!self.MeleeMissSound[NUM]) then
		self.MeleeMissSound[NUM] = {}
	end
	
	table.Add(self.MeleeHitSound[NUM],TBLH)
	table.Add(self.MeleeMissSound[NUM],TBLM)

	for N=1,CNT do
		if(!self.MeleeDamageTime[NUM]) then
			self.MeleeDamageTime[NUM] = {}
		end
		if(!self.MeleeDamageDamage[NUM]) then
			self.MeleeDamageDamage[NUM] = {}
		end
		if(!self.MeleeDamageType[NUM]) then
			self.MeleeDamageType[NUM] = {}
		end
		if(!self.MeleeDamageDistance[NUM]) then
			self.MeleeDamageDistance[NUM] = {}
		end
		if(!self.MeleeDamageRadius[NUM]) then
			self.MeleeDamageRadius[NUM] = {}
		end
		if(!self.MeleeDamageBone[NUM]) then
			self.MeleeDamageBone[NUM] = {}
		end
		
		self.MeleeDamageTime[NUM][N] = TBL.time[N]
		self.MeleeDamageDamage[NUM][N] = TBL.damage[N]
		self.MeleeDamageType[NUM][N] = TBL.damagetype[N]
		self.MeleeDamageDistance[NUM][N] = TBL.distance[N]
		self.MeleeDamageRadius[NUM][N] = TBL.radius[N]
		self.MeleeDamageBone[NUM][N] = TBL.bone[N]
	end
end

function ENT:KFNPCSetMeleeParamsGesture(NUM,SEQ,CNT,TBL,TBLH,TBLM)
	self.MeleeAttackSequence[NUM] = SEQ
	self.MeleeAttackGesture[NUM] = true
	self.MeleeDamageCount[NUM] = CNT
	
	if(!self.MeleeHitSound[NUM]) then
		self.MeleeHitSound[NUM] = {}
	end
	
	if(!self.MeleeMissSound[NUM]) then
		self.MeleeMissSound[NUM] = {}
	end
	
	table.Add(self.MeleeHitSound[NUM],TBLH)
	table.Add(self.MeleeMissSound[NUM],TBLM)
	
	for N=1,CNT do
		if(!self.MeleeDamageTime[NUM]) then
			self.MeleeDamageTime[NUM] = {}
		end
		if(!self.MeleeDamageDamage[NUM]) then
			self.MeleeDamageDamage[NUM] = {}
		end
		if(!self.MeleeDamageType[NUM]) then
			self.MeleeDamageType[NUM] = {}
		end
		if(!self.MeleeDamageDistance[NUM]) then
			self.MeleeDamageDistance[NUM] = {}
		end
		if(!self.MeleeDamageRadius[NUM]) then
			self.MeleeDamageRadius[NUM] = {}
		end
		if(!self.MeleeDamageBone[NUM]) then
			self.MeleeDamageBone[NUM] = {}
		end
		
		self.MeleeDamageTime[NUM][N] = TBL.time[N]
		self.MeleeDamageDamage[NUM][N] = TBL.damage[N]
		self.MeleeDamageType[NUM][N] = TBL.damagetype[N]
		self.MeleeDamageDistance[NUM][N] = TBL.distance[N]
		self.MeleeDamageRadius[NUM][N] = TBL.radius[N]
		self.MeleeDamageBone[NUM][N] = TBL.bone[N]
	end
end

function ENT:KFNPCMakeMeleeAttack(IND)
	if( self.PlayingAnimation == true ) then

		local TEMP_MeleeAttackSequenceName = self.Animation

		local TEMP_TargetTakeDamage = false
		local TEMP_SomeoneTakeDamage = false
		local TEMP_DamagesCount = 0
		
		for i=1, self.MeleeDamageCount[IND] do
			timer.Create("DamageAttack"..tostring(self)..i,self.MeleeDamageTime[IND][i]-0.2,1,function()
				if(IsValid(self)&&self!=nil&&self!=NULL) then
					if(istable(self.MeleeDamageDamage[IND])&&isnumber(self.MeleeDamageDamage[IND][i])) then
						local TEMP_TARGETDMG, TEMP_SOMEONEDMG, TEMP_DMGCNT = self:KFNPCDoMeleeDamage(self.MeleeDamageDamage[IND][i],
						self.MeleeDamageType[IND][i],self.MeleeDamageDistance[IND][i]+7,self.MeleeDamageRadius[IND][i],
						self.MeleeDamageBone[IND][i],self.MeleeHitSound[IND],self.MeleeMissSound[IND])
					
					
						if(TEMP_TARGETDMG==true) then
							TEMP_TargetTakeDamage = true
						end
						
						if(TEMP_SOMEONEDMG==true) then
							TEMP_SomeoneTakeDamage = true
						end
						
						TEMP_DamagesCount = TEMP_DamagesCount+TEMP_DMGCNT
						
						if(i==self.MeleeDamageCount[IND]) then
							self:KFNPCMeleeDamagesEnd(TEMP_TargetTakeDamage,TEMP_SomeoneTakeDamage,TEMP_DamagesCount==self.MeleeDamageCount[IND])
						end
					end
				end
			end )
		end
		
		TEMP_AnimDur = self:SequenceDuration(self:LookupSequence(self.Animation))
		
		if(self.PlayingGesture==true) then
			TEMP_AnimDur = (self:SequenceDuration(self:LookupSequence(self.Animation))/2)
		end
		
		timer.Create("EndAttack"..tostring(self),TEMP_AnimDur+0.1,1,function()
			if(IsValid(self)&&self!=nil&&self!=NULL) then
				self:KFNPCMeleeSequenceEnd(self.Animation)
				self:KFNPCClearAnimation()
			end
		end)
		
		
	end

end

function ENT:KFNPCDoMeleeDamage(DMG,TYPE,DIST,RAD,BONE,HITSND,MISSSND)
	local TEMP_TargetTakeDamage = false
	local TEMP_SomeoneTakeDamage = false
	local TEMP_DamagesCount = 0
	
	if(DIST!=nil) then
		local TEMP_OBBSize = (Vector(math.abs(self:OBBMins().x),math.abs(self:OBBMins().y),0)+
		Vector(math.abs(self:OBBMaxs().x),math.abs(self:OBBMaxs().y),0))/2
		local TEMP_PossibleDamageTargets = ents.FindInSphere(self:GetPos(), DIST+TEMP_OBBSize:Length()+15)
		local TEMP_DMGMAT = self:GetBoneMatrix(self:LookupBone(BONE))
		local TEMP_DMGPOS, TEMP_DMGANG = TEMP_DMGMAT:GetTranslation(), TEMP_DMGMAT:GetAngles()
		local TEMP_DamageApplied = false
			
		if(#TEMP_PossibleDamageTargets>0) then
			for _,v in pairs(TEMP_PossibleDamageTargets) do
				if(self:KFNPCCanAttackThis(v)&&self:Visible(v)) then

					local TEMP_DistanceForMelee = self:KFNPCEnemyInMeleeRange(v,0,DIST)
					
					local TEMP_DotVector = v:GetPos()
					local TEMP_DotDir = TEMP_DotVector - self:GetPos()
					TEMP_DotDir:Normalize()
					local TEMP_Dot = Vector(self:GetForward().x,self:GetForward().y,0):Dot(Vector(TEMP_DotDir.x,TEMP_DotDir.y,0))
					
					if(TEMP_DistanceForMelee==2&&(TEMP_Dot>math.cos(RAD)||RAD==360)) then
						TEMP_DamageApplied = true
						
						local TEMP_FMOD = 100
						local TEMP_ZMOD = 0.4
						
						local TEMP_FlySpeed = (math.abs(v:OBBMins().x)+math.abs(v:OBBMins().y)+math.abs(v:OBBMins().z)+
						math.abs(v:OBBMaxs().x)+math.abs(v:OBBMaxs().y)+math.abs(v:OBBMaxs().z))
						
						local TEMP_FlyDir = 
						(((((v:GetPos()+v:OBBCenter())-(self:GetPos()+self:OBBCenter())):GetNormalized()+Vector(0,0,TEMP_ZMOD))/
						TEMP_FlySpeed)*(100*self.MeleeFlySpeed))*(DMG/1000)
						
						local TEMP_DAMAGEPOSITION = v:NearestPoint(TEMP_DMGPOS)
						local TEMP_DAMAGEFORCE = (TEMP_DAMAGEPOSITION-TEMP_DMGPOS):GetNormalized()*TEMP_FlyDir:Length()
						
						local TEMP_PlyDMG = 1
						
						if(v:IsPlayer()&&#player.GetAll()<2) then
							TEMP_PlyDMG = 0.7
						end
						
						
						local TEMP_RealDamage = (DMG*self:KFNPCMeleeAttackDamageMultiple())*self.DMGMult
						local TEMP_RandomDamage = (TEMP_RealDamage - (TEMP_RealDamage * 0.05)) + (TEMP_RealDamage * (math.Rand(0,1) * 0.1))
						TEMP_RandomDamage = self:KFNPCCalculateMeleeRandomDamage(TEMP_RealDamage,TEMP_RandomDamage)
						
						local TEMP_TargetDamage = DamageInfo()
						
						TEMP_TargetDamage:SetDamage(TEMP_RandomDamage*TEMP_PlyDMG)
						TEMP_TargetDamage:SetInflictor(self)
						TEMP_TargetDamage:SetDamageType(TYPE)
						TEMP_TargetDamage:SetAttacker(self)
						TEMP_TargetDamage:SetDamagePosition(TEMP_DAMAGEPOSITION)
						TEMP_TargetDamage:SetDamageForce(TEMP_DAMAGEFORCE)
						v:TakeDamageInfo(TEMP_TargetDamage)
						
						if(v==self:GetEnemy()) then
							TEMP_TargetTakeDamage = true
						end
						
						if(v:IsNPC()||v:IsPlayer()||v:IsNextBot()) then
							TEMP_SomeoneTakeDamage = true
							TEMP_DamagesCount = 1
							self:KFNPCMakeDamageToCreature(v)
						end
						
						if(TEMP_FlyDir.z>250||!v:IsOnGround()) then
							TEMP_FMOD = 25
						end
						
						if(v:IsPlayer()) then
							v:ViewPunch(Angle(math.random(-1,1)*TEMP_FlyDir:Length(),math.random(-1,1)*TEMP_FlyDir:Length(),math.random(-1,1)*TEMP_FlyDir:Length()))
							TEMP_ZMOD = 0.4
						end
						
						TEMP_FlyDir = TEMP_FlyDir*TEMP_FMOD
						
						v:SetVelocity(TEMP_FlyDir)
					end
				end
			end
		end
		
		if(TEMP_DamageApplied==true) then
			self:KFNPCHitSomething()
			
			sound.Play( table.Random(HITSND),TEMP_DMGPOS)
		else
			sound.Play( table.Random(MISSSND),TEMP_DMGPOS)
		end
	end
	
	
	
	return TEMP_TargetTakeDamage,TEMP_SomeoneTakeDamage,TEMP_DamagesCount
end



function ENT:KFNPCEnemyInMeleeRange(ENT2,DIST1,DIST2)
	if(self:KFNPCIsEnemyNPC(ENT2)||self:KFNPCIsEnemyPlayer(ENT2)||KFNPCIsWeldedDoor(ENT2)||KFNPCIsProp(ENT2)) then
		local TEMP_Point1 = ENT2:NearestPoint(self:GetPos()+self:OBBCenter())
		local TEMP_Point2 = self:NearestPoint(TEMP_Point1)

		local TEMP_DistanceBetween = TEMP_Point1:Distance(TEMP_Point2)

		if(TEMP_Point2.z<(self:GetPos()+self:OBBMaxs()).z&&
		TEMP_Point2.z>((self:GetPos()+self:OBBMins()).z)) then

			if(TEMP_DistanceBetween<DIST2) then
				if(TEMP_DistanceBetween>DIST1||DIST1==0) then
					return 2
				else
					return 1
				end
			end
		end
	end

	return 0
end

function ENT:KFNPCMeleePlay(TEMP_RandomMelee)
	if(self.MeleeSoundEnabled==true) then
		self:KFNPCPlaySoundRandom(60,self.MeleeSound.name,self.MeleeSound.min,self.MeleeSound.max)
	end
	self:KFNPCStopAllTimers()
	
	if(!isnumber(TEMP_RandomMelee)) then
		TEMP_RandomMelee = math.random(1,#self.MeleeAttackSequence)
	end

	if(!self.MeleeAttackGesture[TEMP_RandomMelee]) then
		self:KFNPCPlayAnimation(self.MeleeAttackSequence[TEMP_RandomMelee],1)
		self:KFNPCMakeMeleeAttack(TEMP_RandomMelee)
	else
		self:KFNPCPlayGesture(self.MeleeAttackSequence[TEMP_RandomMelee],1)
		self:KFNPCMakeMeleeAttack(TEMP_RandomMelee)
	end
	
	self:KFNPCMeleeAttackEvent()
end



//Sounds
function ENT:KFNPCPlaySoundRandom(CH,SNDNM,IMIN,IMAX,CHAN)
	if(self.NextSoundCanPlayTime<CurTime()&&self.HeadLess==false) then
		local TEMP_SoundChance = math.random(1,100)
	
		if(TEMP_SoundChance<CH) then
			local TEMP_SND = SNDNM..math.random(IMIN,IMAX)
				
			self:EmitSound( TEMP_SND )
			self.NextSoundCanPlayTime = CurTime()+SoundDuration(TEMP_SND)+0.1
			self.LastPlayedSound = TEMP_SND
			
			if(CHAN=="Chase") then
				self:KFNPCOnChaseSound()
			end
		end
	end
end

function ENT:KFNPCStopPreviousSound()
	self:StopSound(self.LastPlayedSound)
	self.LastPlayedSound = ""
	self.NextSoundCanPlayTime = -1
end
	



//Animations
function ENT:KFNPCPlayAnimation(ANM,IND,RESETCYCLE)
	self.PlayingAnimation = true
	self.PlayingGesture = false
	self.AttackIndex = IND
	self:ClearSchedule()
	
	self.CantChaseTargetTimes = 0
	self.MustJumpTimes = 0
	
	if(RESETCYCLE==nil||RESETCYCLE==true) then
		self:ResetSequenceInfo()
		self:SetCycle(0)
	end
	
	self.Animation = ANM
	self:StopMoving()


	self:SetNPCState(NPC_STATE_SCRIPT)
	self:ResetSequence(self:LookupSequence(self.Animation))

end

function ENT:KFNPCPlayGesture(ANM,IND,PRIOR)
	if(PRIOR==nil) then
		PRIOR = 2
	end
	
	self.CantChaseTargetTimes = 0
	self.MustJumpTimes = 0
	
	local TEMP_Gesture = self:AddGestureSequence(self:LookupSequence(ANM))
	self:SetLayerPriority(TEMP_Gesture,PRIOR)
	self:SetLayerPlaybackRate(TEMP_Gesture,1)
	self:SetLayerCycle(TEMP_Gesture,0)
	
	if(ANM==self.FlinchSequence) then
		self.FlinchGestureIndex = TEMP_Gesture
	else
		self.AttackGestureIndex = TEMP_Gesture
	end
	
	self.Animation = ANM
	self.AttackIndex = IND
	self.PlayingAnimation = true
	self.PlayingGesture = true
	
end

function ENT:KFNPCStun(ANM)
	if(self.Animation!=self.StunSequence||self.StunInStun==true) then
		if(self.PlayingGesture==true) then
			self:KFNPCClearAnimation()
		end
		
		self:KFNPCPlayAnimation(ANM,-1,true)
		
		self:KFNPCStopAllTimers()
			
		self:KFNPCStunEvent()
		timer.Create("EndAttack"..tostring(self),self:SequenceDuration(self:LookupSequence(ANM)),1,function()
			if(IsValid(self)&&self!=nil&&self!=NULL) then
				self:KFNPCClearAnimation()
			end
		end)
	end
end

function ENT:KFNPCFlinch(ANM,JUSTANM)
	if(self.Animation!=self.FlinchSequence) then
		if(JUSTANM!=true) then
			if(self.AttackIndex!=-2&&self.AttackIndex!=-1) then
				self:KFNPCClearAnimation()
				self:KFNPCStopAllTimers()

				self:KFNPCPlayGesture(ANM,-1,1,JUSTANM)

				timer.Create("EndAttack"..tostring(self),(self:SequenceDuration(self:LookupSequence(ANM))/2)+0.2,1,function()
					if(IsValid(self)&&self!=nil&&self!=NULL) then
						self:KFNPCClearAnimation()
					end
				end)
			end
		else
			local TEMP_Gesture = self:AddGestureSequence(self:LookupSequence(self.FlinchSequence))
			self:SetLayerPriority(TEMP_Gesture,2)
			self:SetLayerPlaybackRate(TEMP_Gesture,1)
			self:SetLayerCycle(TEMP_Gesture,0)
		end
	end
end

function ENT:KFNPCClearAnimation()
	self:KFNPCAnimationCleared(self.Animation)
	
	self.MustNotMove = false
	self.Animation = ""
	self.AttackIndex = 0
	
	if(self.PlayingGesture==false) then
		self:ClearSchedule()
		self:ResetSequenceInfo()
		self:SetNPCState(NPC_STATE_COMBAT)
		
		if(GetConVar("ai_disabled"):GetInt()==1 or self.DisableAI) then
			self:ResetSequence(self:LookupSequence(self.IdleSequence))
		end
	else
		if(self.AttackGestureIndex!=nil&&self:IsValidLayer(self.AttackGestureIndex)) then
			self:SetLayerCycle(self.AttackGestureIndex,1)
		end
		
		self.AttackGestureIndex = nil
		self.FlinchGestureIndex = nil
	end

	self.PlayingGesture = false
	self.PlayingAnimation = false
end

function ENT:KFNPCJump()
	if(self.PlayingAnimation==false&&self.InJump!=true) then
		self:KFNPCPlayAnimation("S_Jump",0)
		
		self.LastPositionFails = 0
		self.FollowPosTime = 0
		self.FollowLen = 99
		
		
		self.InJump = true
		

		timer.Create("StartAttack"..tostring(self),0.2,1,function()
			if(IsValid(self)&&self!=nil&&self!=NULL) then
				self:SetLocalVelocity(((self:GetForward()*700)+Vector(0,0,self.JumpHeight+60)))
				
				timer.Create("Attack"..tostring(self),0.1,10,function()
					if(IsValid(self)&&self!=nil&&self!=NULL) then
						self:SetVelocity(self:GetForward()*5)
					end
				end)
				
				timer.Create("MidAttack"..tostring(self),self:SequenceDuration(self.Animation)-0.2,1,function()
					if(IsValid(self)&&self!=nil&&self!=NULL) then
						self:KFNPCPlayAnimation("S_Fly",0)
					end
				end)
			end
		end)
	end
end


//Timers
function ENT:KFNPCStopAllTimers()
	timer.Remove("StartAttack"..tostring(self))
	timer.Remove("PreMidAttack"..tostring(self))
	timer.Remove("MidAttack"..tostring(self))
	timer.Remove("PreAttack"..tostring(self))
	timer.Remove("Attack"..tostring(self))
	timer.Remove("EndAttack"..tostring(self))
	timer.Remove("Anim"..tostring(self))
	timer.Remove("JustPlayAnimation"..tostring(self))
	timer.Remove("JustPlayAnimation2"..tostring(self))
	timer.Remove("AllowAttack"..tostring(self))
	for i=1, 10 do
		timer.Remove("Attack"..tostring(self)..i)
		timer.Remove("DamageAttack"..tostring(self)..i)
	end
end













//Base functions
function ENT:OnRemove()
	self:KFNPCStopAllTimers()
	self:KFNPCRemove()
end

function ENT:Use( activator, caller, type, value )
end

function ENT:StartTouch( entity )
end

function ENT:EndTouch( entity )
end

function ENT:Touch( entity )
end

function ENT:GetRelationship( entity )
end

function ENT:ExpressionFinished( strExp )
end

function ENT:Think()
	
	self:KFNPCThinkAnyway()
	
	if(GetConVar("ai_disabled"):GetInt()==0 and self.IsAlive==true and !self.DisableAI) then
		self:KFNPCThink()
		
		
		if(self.PlayingAnimation==true) then
			self:KFNPCAnimationIsPlaying()
		end
		
		if(self.NeedFlinch==true&&self.AttackIndex!=-2) then
			if(self.NeedStun==false) then
				local TEMP_FlinchRule = self:KFNPCFlinchCondition()
				
				if(TEMP_FlinchRule==true) then
					self:KFNPCFlinch(self.FlinchSequence)
				end
				
				self.NeedFlinch = false
			else
				local TEMP_StunRule = self:KFNPCStunCondition()
				
				if(TEMP_StunRule==true) then
					self:KFNPCStun(self.StunSequence)
				end
				
				
				
				local TEMP_FlinchRule = self:KFNPCFlinchCondition()
				
				if(TEMP_FlinchRule==true) then
					self:KFNPCFlinch(self.FlinchSequence,true)
				end
				self.NeedFlinch = false
				self.NeedStun = false
			end
		elseif(self.NeedStun==true) then
			local TEMP_StunRule = self:KFNPCStunCondition()
				
			if(TEMP_StunRule==true) then
				self:KFNPCStun(self.StunSequence)
			end

			self.NeedStun = false
		end
		
		if(self.NextTryingFindEnemy<CurTime()) then
			self.NextTryingFindEnemy = CurTime()+1.5
			local TEMP_NearEnemyCount = self:KFNPCTryToFindEnemy()
			
			self:KFNPCOnEnemyCountFinded(TEMP_NearEnemyCount)
		end
		
		if(self.PlayingAnimation==false) then
			if(self.HeadLess&&self.AutoChangeActivityWhenHeadless) then
				self.CanManipulateActivity = false
				if(self:GetMovementActivity()!=ACT_WALK_RELAXED) then
					self:SetMovementActivity(ACT_WALK_RELAXED)
				end
			elseif(self:IsOnFire()) then
				self.BurnTime = self.BurnTime+0.1
				if(self.BurnTime>self.BurnTimeToPanic&&self.AutoChangeActivityWhenOnFire&&self.BurnTime<self.BurnTimeToPanic+3) then
					self.CanManipulateActivity = false
					if(self:GetMovementActivity()!=ACT_WALK_AGITATED) then
						self:SetMovementActivity(ACT_WALK_AGITATED)
					end
				end
			else
				self.CanManipulateActivity = true
				self.BurnTime = 0
			end
		end

		if(self:GetEnemy()&&IsValid(self:GetEnemy())&&self:GetEnemy()!=nil&&self:GetEnemy()!=NULL&&
		(self:KFNPCIsEnemyNPC(self:GetEnemy())||self:KFNPCIsEnemyPlayer(self:GetEnemy()))) then
			if(self:IsOnGround()) then
				if(self.PlayingAnimation==false) then
				
					if(!self:IsMoving()) then
						self:KFNPCRotateCorrectly((self:GetEnemy():GetPos()-self:GetPos()):Angle().Yaw)
					end
					
					if((self:IsCurrentSchedule(SCHED_CHASE_ENEMY)||self:IsCurrentSchedule(SCHED_RUN_RANDOM)||
					self:IsCurrentSchedule(SCHED_FORCED_GO_RUN)||self:IsCurrentSchedule(SCHED_CHASE_ENEMY_FAILED))) then
						local TEMP_DistToPrevPos = self:GetPos():Distance(self.LastPosition)
						
						
						if(TEMP_DistToPrevPos<6) then
							if(self.MustJumpTimes<CurTime()) then
								self.MustJumpTimes = CurTime()
							end
							
							self.MustJumpTimes = math.Clamp(self.MustJumpTimes+0.4,CurTime(),CurTime()+100)
						end
					end

					
					if(self:GetEnemy():Visible(self)) then
						local TEMP_PosToTarg = self:GetEnemy():GetPos()-self:GetPos()
						local TEMP_PosToTargAng = Vector(TEMP_PosToTarg.x,TEMP_PosToTarg.y,0):Angle().Yaw
								
						local TEMP_AngToEn = math.abs(math.NormalizeAngle(TEMP_PosToTargAng-self:GetAngles().Yaw))
						
						local TEMP_MaxMeleeDistance = self.MeleeAttackDistance
						
						if(self:IsMoving()) then
							TEMP_MaxMeleeDistance = self.MeleeAttackDistance+5
						end

						local TEMP_DistanceForMelee = self:KFNPCEnemyInMeleeRange(self:GetEnemy(),self.MeleeAttackDistanceMin,TEMP_MaxMeleeDistance)

						if(TEMP_DistanceForMelee==2) then
							if(TEMP_AngToEn<90) then
								local TEMP_IND = self:KFNPCSelectMeleeAttack()
								if(TEMP_IND!=false) then
									self:KFNPCMeleePlay(TEMP_IND)
								end
							else
								self:KFNPCRotateForMeleeTooBig()
							end
						elseif(TEMP_DistanceForMelee==1) then
							self:KFNPCDistanceForMeleeTooSmall()
						else
							self:KFNPCDistanceForMeleeTooBig()
						end
						
					end
					
					if(self.PlayingAnimation==false&&self.MustJumpTimes-CurTime()>1) then
						local TEMP_MustJump = false
						
						if(self.MustJumpTimes-CurTime()>3) then
							local TEMP_JumpForward = (self:GetForward()*40)
							
							local TEMP_JumpTracer = util.TraceHull( {
								start = self:GetPos(),
								endpos = self:GetPos()+TEMP_JumpForward,
								filter = self,
								mins = self:OBBMins()+Vector(0,0,15),
								maxs = self:OBBMaxs(),
								mask = MASK_NPCSOLID
							} )
							
							if(!TEMP_JumpTracer.Hit) then
								
								local TEMP_JumpDownTracer = util.TraceHull( {
									start = self:GetPos()+TEMP_JumpForward,
									endpos = self:GetPos()+TEMP_JumpForward+Vector(0,0,-999999),
									filter = self,
									mins = self:OBBMins(),
									maxs = self:OBBMaxs(),
									mask = MASK_NPCSOLID
								} )
								
								local TEMP_JumpDownDist = TEMP_JumpDownTracer.HitPos.z
								local TEMP_JumpDownSelfPos = (self:GetPos()+self:OBBMins()).z
								
								if(TEMP_JumpDownDist<TEMP_JumpDownSelfPos-18) then
									TEMP_MustJump = true
								else
									local TEMP_JumpForward = (self:GetForward()*10)
									
									local TEMP_JumpDownTracer = util.TraceHull( {
										start = self:GetPos()+TEMP_JumpForward,
										endpos = self:GetPos()+TEMP_JumpForward+Vector(0,0,-999999),
										filter = self,
										mins = self:OBBMins(),
										maxs = self:OBBMaxs(),
										mask = MASK_NPCSOLID
									} )
									
									local TEMP_JumpDownDist = TEMP_JumpDownTracer.HitPos.z
									local TEMP_JumpDownSelfPos = (self:GetPos()+self:OBBMins()).z
									
									if(TEMP_JumpDownDist<TEMP_JumpDownSelfPos-10) then
										TEMP_MustJump = true
									end
								end
								
								if(TEMP_MustJump==true) then
									self:KFNPCJump()
								end
							end
						end
						
						if(self.PlayingAnimation==false&&!self:IsUnreachable(self:GetEnemy())&&!self:IsMoving()) then
							self:KFNPCTestForJump()
						end
					end
				end
				
				if(self.PlayingAnimation==false) then
					self:KFNPCThinkEnemyValid()
					
					if(self.ChasingSoundEnabled==true&&self:IsCurrentSchedule(SCHED_CHASE_ENEMY)) then
						self:KFNPCPlaySoundRandom(self.ChasingSound.chance,self.ChasingSound.name,self.ChasingSound.min,self.ChasingSound.max,"Chase")
					end
						
				else
					if(self.Animation!="S_Jump"&&self.Animation!="S_Fly"&&self.Animation!="S_Land") then
						self:KFNPCAnimEnemyIsValid()
					end
				end
			elseif(!self:IsOnGround()&&self.Animation=="S_Fly") then
				if(self:GetPos()==self.LastPosition) then
					local TEMP_TBL = { -1, 1 }
					
					self:SetVelocity(Vector(TEMP_TBL[math.random(1,2)],TEMP_TBL[math.random(1,2)],math.random(100,170)/100)*math.random(78,102))
				end
			end
		else
			if(IsValid(self:GetEnemy())&&self:GetEnemy():IsPlayer()&&!self:GetEnemy():Alive()) then
				self:SetEnemy(nil)
			end
			
			if(self.IdlingSoundEnabled==true&&self.PlayingAnimation==false&&self:IsCurrentSchedule(SCHED_IDLE_WANDER)) then
				self:KFNPCPlaySoundRandom(15,self.IdlingSound.name,self.IdlingSound.min,self.IdlingSound.max)
			end
		end
	end
	
	if(self.PlayingAnimation==true&&self:IsOnGround()&&self.InJump==true&&self.Animation!="S_Jump") then
		self.InJump = false
		
		self:KFNPCStopAllTimers()
		
		self:KFNPCPlayAnimation("S_Land",0)
		
		timer.Create("EndAttack"..tostring(self),0.4,1,function()
			if(IsValid(self)&&self!=nil&&self!=NULL) then
				self:KFNPCClearAnimation()
				self:KFNPCStopAllTimers()
			end
		end)
			
	end
end

function ENT:OnTakeDamage(dmginfo)
	if(self.IsAlive==false) then return 0 end
	
	local TEMP_DMGMUL = 1
	
	local TEMP_RealAttacker = dmginfo:GetAttacker()
	local TEMP_RealInflictor = dmginfo:GetInflictor()
	

	dmginfo:SetDamage(dmginfo:GetDamage()*self.TakenDamageMultiplier)
	
	if(self.Hard==1) then
		dmginfo:SetDamage(dmginfo:GetDamage()-1)
	end
		
		
	
			
	if(!IsValid(TEMP_RealAttacker)&&IsValid(TEMP_RealInflictor)) then
		TEMP_RealAttacker = TEMP_RealInflictor
	end
	
	if(IsValid(TEMP_RealAttacker)&&!IsValid(TEMP_RealInflictor)) then
		TEMP_RealInflictor = TEMP_RealAttacker
	end
	
	if(IsValid(TEMP_RealAttacker)&&TEMP_RealAttacker:IsVehicle()&&IsValid(TEMP_RealAttacker:GetDriver())) then
		TEMP_RealAttacker = TEMP_RealAttacker:GetDriver()
	end

	
	if(IsValid(TEMP_RealInflictor)&&IsValid(TEMP_RealAttacker)&&TEMP_RealAttacker==TEMP_RealInflictor&&
	(TEMP_RealInflictor:IsPlayer()||TEMP_RealInflictor:IsNPC()||TEMP_RealInflictor:IsNextBot())) then
		if(IsValid(TEMP_RealInflictor:GetActiveWeapon())) then
			TEMP_RealAttacker = TEMP_RealInflictor
			TEMP_RealInflictor = TEMP_RealInflictor:GetActiveWeapon()
		end
	end
	
	if(!IsValid(TEMP_RealInflictor)&&!IsValid(TEMP_RealAttacker)) then
		TEMP_RealInflictor = self
		TEMP_RealAttacker = self
	end
	
	dmginfo:SetInflictor(TEMP_RealInflictor)
	dmginfo:SetAttacker(TEMP_RealAttacker)
	
	local TEMP_DMGHEADPOP = false
	
	if(isnumber(self.DamageTypeMult[dmginfo:GetDamageType()])) then
		TEMP_DMGMUL = self.DamageTypeMult[dmginfo:GetDamageType()]
		
		if(dmginfo:GetDamageType()==DMG_BLAST) then TEMP_DMGHEADPOP = true end
		if(dmginfo:GetDamageType()==DMG_CRUSH) then TEMP_DMGHEADPOP = true end
		if(dmginfo:GetDamageType()==DMG_GENERIC) then TEMP_DMGHEADPOP = true end
		if(dmginfo:GetDamageType()==DMG_BULLET) then TEMP_DMGHEADPOP = true end
		if(dmginfo:GetDamageType()==DMG_VEHICLE) then TEMP_DMGHEADPOP = true end
		if(dmginfo:GetDamageType()==DMG_FALL) then TEMP_DMGHEADPOP = true end
		if(dmginfo:GetDamageType()==DMG_CLUB) then TEMP_DMGHEADPOP = true end
		if(dmginfo:GetDamageType()==DMG_SONIC) then TEMP_DMGHEADPOP = true end
		if(dmginfo:GetDamageType()==DMG_ALWAYSGIB) then TEMP_DMGHEADPOP = true end
		if(dmginfo:GetDamageType()==DMG_AIRBOAT) then TEMP_DMGHEADPOP = true end
		if(dmginfo:GetDamageType()==DMG_BLAST_SURFACE) then TEMP_DMGHEADPOP = true end
		if(dmginfo:GetDamageType()==DMG_BUCKSHOT) then TEMP_DMGHEADPOP = true end
		if(dmginfo:GetDamageType()==DMG_DIRECT) then TEMP_DMGHEADPOP = true end
		if(dmginfo:GetDamageType()==DMG_DISSOLVE) then TEMP_DMGHEADPOP = true end
		if(dmginfo:GetDamageType()==DMG_PLASMA) then TEMP_DMGHEADPOP = true end
	else
		if(!dmginfo:IsDamageType(dmginfo:GetDamageType())) then
			TEMP_DMGMUL = self.DamageMultOther
		else
			local TEMP_DmgtypeCount = 0
			
			if(bit.band(dmginfo:GetDamageType(),DMG_BLAST)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1  TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_BLAST] TEMP_DMGHEADPOP = true end
			if(bit.band(dmginfo:GetDamageType(),DMG_CRUSH)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_CRUSH] TEMP_DMGHEADPOP = true end
			if(bit.band(dmginfo:GetDamageType(),DMG_GENERIC)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_GENERIC] TEMP_DMGHEADPOP = true end
			if(bit.band(dmginfo:GetDamageType(),DMG_BULLET)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_BULLET] TEMP_DMGHEADPOP = true end
			if(bit.band(dmginfo:GetDamageType(),DMG_SLASH)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_SLASH] end
			if(bit.band(dmginfo:GetDamageType(),DMG_BURN)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_BURN] end
			if(bit.band(dmginfo:GetDamageType(),DMG_VEHICLE)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_VEHICLE] TEMP_DMGHEADPOP = true end
			if(bit.band(dmginfo:GetDamageType(),DMG_FALL)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_FALL] TEMP_DMGHEADPOP = true end
			if(bit.band(dmginfo:GetDamageType(),DMG_CLUB)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_CLUB] TEMP_DMGHEADPOP = true end
			if(bit.band(dmginfo:GetDamageType(),DMG_SHOCK)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_SHOCK] end
			if(bit.band(dmginfo:GetDamageType(),DMG_SONIC)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_SONIC] TEMP_DMGHEADPOP = true end
			if(bit.band(dmginfo:GetDamageType(),DMG_ENERGYBEAM)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_ENERGYBEAM] end
			if(bit.band(dmginfo:GetDamageType(),DMG_NEVERGIB)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_NEVERGIB] end
			if(bit.band(dmginfo:GetDamageType(),DMG_ALWAYSGIB)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_ALWAYSGIB] TEMP_DMGHEADPOP = true end
			if(bit.band(dmginfo:GetDamageType(),DMG_DROWN)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_DROWN] end
			if(bit.band(dmginfo:GetDamageType(),DMG_PARALYZE)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_PARALYZE] end
			if(bit.band(dmginfo:GetDamageType(),DMG_NERVEGAS)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_NERVEGAS] end
			if(bit.band(dmginfo:GetDamageType(),DMG_POISON)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_POISON] end
			if(bit.band(dmginfo:GetDamageType(),DMG_ACID)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_ACID] end
			if(bit.band(dmginfo:GetDamageType(),DMG_AIRBOAT)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_AIRBOAT] TEMP_DMGHEADPOP = true end
			if(bit.band(dmginfo:GetDamageType(),DMG_BLAST_SURFACE)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_BLAST_SURFACE] TEMP_DMGHEADPOP = true end
			if(bit.band(dmginfo:GetDamageType(),DMG_BUCKSHOT)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_BUCKSHOT] TEMP_DMGHEADPOP = true end
			if(bit.band(dmginfo:GetDamageType(),DMG_DIRECT)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_DIRECT] TEMP_DMGHEADPOP = true end
			if(bit.band(dmginfo:GetDamageType(),DMG_DISSOLVE)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_DISSOLVE] TEMP_DMGHEADPOP = true end
			if(bit.band(dmginfo:GetDamageType(),DMG_DROWNRECOVER)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_DROWNRECOVER] end
			if(bit.band(dmginfo:GetDamageType(),DMG_PHYSGUN)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_PHYSGUN] end
			if(bit.band(dmginfo:GetDamageType(),DMG_PLASMA)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_PLASMA] TEMP_DMGHEADPOP = true end
			if(bit.band(dmginfo:GetDamageType(),DMG_PREVENT_PHYSICS_FORCE)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_PREVENT_PHYSICS_FORCE] end
			if(bit.band(dmginfo:GetDamageType(),DMG_RADIATION)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1 TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_RADIATION] end
			if(bit.band(dmginfo:GetDamageType(),DMG_REMOVENORAGDOLL)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1  TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_REMOVENORAGDOLL] end
			if(bit.band(dmginfo:GetDamageType(),DMG_SLOWBURN)!=0) then TEMP_DmgtypeCount = TEMP_DmgtypeCount+1  TEMP_DMGMUL = TEMP_DMGMUL+self.DamageTypeMult[DMG_SLOWBURN] end
			
			if(TEMP_DmgtypeCount>0) then
				TEMP_DMGMUL = TEMP_DMGMUL/TEMP_DmgtypeCount
			end
		end
	end
	
	TEMP_DMGMUL = TEMP_DMGMUL*self.DamageMultAll
	
	if(self.LastDamageHitgroup==-1||self.LastDamageHitgroup==0) then
		local TEMP_NearestPoint = self:NearestPoint(dmginfo:GetDamagePosition())
		
		local TEMP_HitTracer = util.TraceHull( {
			start = TEMP_NearestPoint,
			endpos = TEMP_NearestPoint,
			ignoreworld = true,
			mins = Vector(100,100,100),
			maxs = Vector(100,100,100),
			filter = function( ent ) if ( ent==self ) then return true end end
		} )
		
		if(TEMP_HitTracer.Hit) then
			self.LastDamageHitgroup = TEMP_HitTracer.HitGroup
		end
	end

	if(self.LastDamageHitgroup==-1||self.LastDamageHitgroup==0) then
		
		local TEMP_HitTracer = util.TraceLine( {
			start = dmginfo:GetDamagePosition(),
			endpos = dmginfo:GetDamagePosition()+(dmginfo:GetDamageForce()*100),
			ignoreworld = true,
			filter = function( ent ) if ( ent==self ) then return true end end
		} )
	
		
		if(TEMP_HitTracer.Hit) then
			self.LastDamageHitgroup = TEMP_HitTracer.HitGroup
		end
	end
	
	if(self.LastDamageHitgroup==-1||self.LastDamageHitgroup==0) then
		if(IsValid(TEMP_RealInflictor)&&isentity(TEMP_RealInflictor)&&!TEMP_RealInflictor:IsWeapon()) then
			local TEMP_InflictorHullMin, TEMP_InflictorHullMax = TEMP_RealInflictor:GetCollisionBounds()
			
			local TEMP_HitTracer = util.TraceHull( {
				start = TEMP_RealInflictor:GetPos(),
				endpos = TEMP_RealInflictor:GetPos()+(TEMP_RealInflictor:GetForward()*100),
				ignoreworld = true,
				mins = TEMP_InflictorHullMin*1.3,
				maxs = TEMP_InflictorHullMax*1.3,
				filter = function( ent ) if ( ent==self ) then return true end end
			} )
		
			if(TEMP_HitTracer.Hit) then
				self.LastDamageHitgroup = TEMP_HitTracer.HitGroup
			end
		end
	end

	if self.HeadLess==false and self.LastDamageHitgroup == 8 then
		TEMP_DMGMUL = TEMP_DMGMUL * (TEMP_RealInflictor.BodyDamageMults and TEMP_RealInflictor.BodyDamageMults[HITGROUP_HEAD] or 2)
	end

	if (self.LastDamageHitgroup!=0||self.LastDamageHitgroup!=-1) then
		self.HitBoxLastDamage[self.LastDamageHitgroup] = CurTime()+0.1
	end
	
	
	TEMP_DMGMUL = self:KFNPCDamageTake(dmginfo,dmginfo:GetDamage()*TEMP_DMGMUL,TEMP_DMGMUL,
	TEMP_RealAttacker,TEMP_RealInflictor)
	
	
	if(self.HeadLess==false&&self.LastDamageHitgroup==8) then
		if(self.GoreEnabled[HITGROUP_KFHEAD]) then
			self.HeadHealth = self.HeadHealth-(dmginfo:GetDamage()*TEMP_DMGMUL)
			
			if(self.HeadHealth<1) then
				if(self.Gore==1) then
					self:KFNPCKillHead(TEMP_DMGHEADPOP,dmginfo:GetDamageForce(),dmginfo:GetDamage())
				else
					local TEMP_FirstBone = string.Explode(",",self.GoreHead.bone)[1]
					
					sound.Play("KFMod.GoreDecap"..math.random(1,4),self:GetBonePosition(self:LookupBone(TEMP_FirstBone)))
					self.HeadLess = true
					
					self:KFNPCOnHeadLoss()
				end
				
				if(self.DieOnHeadLoss==false) then
					local TEMP_HeadLossDamage = DamageInfo()
					TEMP_HeadLossDamage:SetDamageForce(dmginfo:GetDamageForce())
					TEMP_HeadLossDamage:SetDamagePosition(dmginfo:GetDamagePosition())
					TEMP_HeadLossDamage:SetDamageType(dmginfo:GetDamageType())
					TEMP_HeadLossDamage:SetDamage((0.25*self:GetMaxHealth()))
					TEMP_HeadLossDamage:SetAttacker(dmginfo:GetAttacker())
					TEMP_HeadLossDamage:SetInflictor(dmginfo:GetInflictor())
					self:TakeDamageInfo(TEMP_HeadLossDamage)
				else
					self:KFNPCKill(dmginfo)
				end
				
				self:RemoveAllDecals()
				
				if(self.StunOnHeadLoss) then
					self.NeedStun = true
				end
				
				local TEMP_BleedDeathAttacker = dmginfo:GetAttacker()
				local TEMP_BleedDeathInflictor = dmginfo:GetInflictor()
				
				timer.Simple(7,function()
					if(IsValid(self)&&self!=nil&&self!=NULL) then
						self:SetHealth(-1)
						
						if(!IsValid(TEMP_BleedDeathAttacker)||TEMP_BleedDeathAttacker==nil||TEMP_BleedDeathAttacker==NULL) then
							TEMP_BleedDeathAttacker = self
						end
						
						if(!IsValid(TEMP_BleedDeathInflictor)||TEMP_BleedDeathInflictor==nil||TEMP_BleedDeathInflictor==NULL) then
							TEMP_BleedDeathInflictor = TEMP_BleedDeathAttacker
						end
						
						local TEMP_DMG = DamageInfo()
						
						TEMP_DMG:SetDamageType(DMG_POISON)
						TEMP_DMG:SetDamage(self:GetMaxHealth())
						TEMP_DMG:SetDamageForce(self:GetVelocity())
						TEMP_DMG:SetDamagePosition(self:GetPos())
						TEMP_DMG:SetAttacker(TEMP_BleedDeathAttacker)
						TEMP_DMG:SetInflictor(TEMP_BleedDeathInflictor)
						self:TakeDamageInfo(TEMP_DMG)
					end
				end)
			end
		end
		
		local TEMP_DMGSND = "KFMod.ImpactSkull"..math.random(1,5)
		sound.Play( Sound(TEMP_DMGSND), self:GetPos() )		
	end
	dmginfo:SetDamage(dmginfo:GetDamage()*TEMP_DMGMUL)
	self:SetHealth(self:Health() - dmginfo:GetDamage())

	local cur_health = self:Health() - dmginfo:GetDamage()
	
	
	if(dmginfo:GetDamagePosition():WithinAABox(self:GetPos()+self:OBBMins(),self:GetPos()+self:OBBMaxs())&&
	dmginfo:GetDamageType()!=DMG_SONIC&&dmginfo:GetDamageType()!=DMG_POISON) then
		KFNPCBleed(self,dmginfo:GetDamage()/5,dmginfo:GetDamagePosition(),Angle(math.random(1,360),math.random(1,360),math.random(1,360)))
	end
	
	
	self.LastDamageType = dmginfo:GetDamageType()
	self.LastAttacker = TEMP_RealAttacker
	
	if(cur_health>0) then
		if(dmginfo:GetDamage()*TEMP_DMGMUL>self.FlinchDamage-1&&self.FlinchDamage>0&&!self:IsOnFire()) then
			self.NeedFlinch = true
		end
		
		if(dmginfo:GetDamage()*TEMP_DMGMUL>self.StunDamage-1&&self.StunDamage>0&&self.HeadLess==false) then
			self.NeedStun = true
		end

		if(self.PainSoundEnabled==true) then
			self:KFNPCPlaySoundRandom(33,self.PainSound.name,self.PainSound.min,self.PainSound.max)
		end
	elseif(cur_health<1&&self.IsAlive==true) then
		local TEMP_MeatList = ""
		local TEMP_BoomDamage = dmginfo:IsExplosionDamage()
		
		
		
		
		local TEMP_ExpDamage, TEMP_ExpDamageFullDestroy = self:KFNPCSetExplosionDamage(dmginfo:GetDamageType())
		
		if(TEMP_BoomDamage==false&&TEMP_ExpDamage==true) then
			TEMP_BoomDamage = true
		end
		
		local TEMP_ExplosionRadius = (self:GetPos()-dmginfo:GetDamagePosition()):Length()
		TEMP_ExplosionRadius = ((TEMP_ExplosionRadius*dmginfo:GetDamage())/(TEMP_ExplosionRadius*0.8))*0.3

		
		if(self.Gore==1) then

			if(self.GoreEnabled[HITGROUP_KFHEAD]&&((self.HeadLess==false&&(TEMP_BoomDamage||
			(isnumber(self.HitBoxLastDamage[HITGROUP_KFHEAD])&&self.HitBoxLastDamage[HITGROUP_KFHEAD]>CurTime())))||
			self.HeadLess==true)) then
				if(self.HeadLess==false) then
					local TEMP_FirstBone = string.Explode(",",self.GoreHead.bone)[1]
					local TEMP_FirstBonePos = self:GetBonePosition(self:LookupBone(TEMP_FirstBone))
					local TEMP_FirstBonePosSmall = TEMP_FirstBonePos:Distance(dmginfo:GetDamagePosition())<TEMP_ExplosionRadius
					
					
					if((TEMP_BoomDamage&&TEMP_FirstBonePosSmall)||TEMP_ExpDamageFullDestroy||!TEMP_BoomDamage) then
						self:KFNPCKillHead(TEMP_DMGHEADPOP,dmginfo:GetDamageForce(),dmginfo:GetDamage())
						sound.Play("KFMod.Gore"..math.random(1,8),self:GetBonePosition(self:LookupBone(TEMP_FirstBone)))
					end
				end
				
				TEMP_MeatList = KFNPCStringAdd(TEMP_MeatList,self.GoreHead.bone)
			end
		
			if(self.GoreEnabled[HITGROUP_LEFTLEG]&&(TEMP_BoomDamage||
			(isnumber(self.HitBoxLastDamage[HITGROUP_LEFTLEG])&&self.HitBoxLastDamage[HITGROUP_LEFTLEG]>CurTime()))) then
				local TEMP_FirstBone = string.Explode(",",self.GoreLLeg.bone)[1]
				local TEMP_FirstBonePos = self:GetBonePosition(self:LookupBone(TEMP_FirstBone))
				local TEMP_FirstBonePosSmall = TEMP_FirstBonePos:Distance(dmginfo:GetDamagePosition())<TEMP_ExplosionRadius
				
				if((TEMP_BoomDamage&&TEMP_FirstBonePosSmall)||TEMP_ExpDamageFullDestroy||!TEMP_BoomDamage) then
					TEMP_MeatList = KFNPCStringAdd(TEMP_MeatList,self.GoreLLeg.bone)
					self:KFNPCSetBodygoup(self.GoreLLeg.bodygroup1)
					self:KFNPCCreateGib(TEMP_FirstBone, self.GoreLLeg.model,dmginfo:GetDamageForce(),dmginfo:GetDamage(),true)
					KFNPCBleed(self,math.random(13,15),TEMP_FirstBonePos,AngleRand())
					sound.Play("KFMod.Gore"..math.random(1,8),self:GetBonePosition(self:LookupBone(TEMP_FirstBone)))
				end
			end
			
			if(self.GoreEnabled[HITGROUP_RIGHTLEG]&&(TEMP_BoomDamage||
			(isnumber(self.HitBoxLastDamage[HITGROUP_RIGHTLEG])&&self.HitBoxLastDamage[HITGROUP_RIGHTLEG]>CurTime()))) then
				local TEMP_FirstBone = string.Explode(",",self.GoreRLeg.bone)[1]
				local TEMP_FirstBonePos = self:GetBonePosition(self:LookupBone(TEMP_FirstBone))
				local TEMP_FirstBonePosSmall = TEMP_FirstBonePos:Distance(dmginfo:GetDamagePosition())<TEMP_ExplosionRadius
				
				if((TEMP_BoomDamage&&TEMP_FirstBonePosSmall)||TEMP_ExpDamageFullDestroy||!TEMP_BoomDamage) then
					TEMP_MeatList = KFNPCStringAdd(TEMP_MeatList,self.GoreRLeg.bone)
					self:KFNPCSetBodygoup(self.GoreRLeg.bodygroup1)
					self:KFNPCCreateGib(TEMP_FirstBone,self.GoreRLeg.model,dmginfo:GetDamageForce(),dmginfo:GetDamage(),true)
					KFNPCBleed(self,math.random(13,15),TEMP_FirstBonePos,AngleRand())
					sound.Play("KFMod.Gore"..math.random(1,8),self:GetBonePosition(self:LookupBone(TEMP_FirstBone)))
				end
			end
			
			if(self.GoreEnabled[HITGROUP_LEFTARM]&&(TEMP_BoomDamage||
			(isnumber(self.HitBoxLastDamage[HITGROUP_LEFTARM])&&self.HitBoxLastDamage[HITGROUP_LEFTARM]>CurTime()))) then
				local TEMP_FirstBone = string.Explode(",",self.GoreLArm.bone)[1]
				local TEMP_FirstBonePos = self:GetBonePosition(self:LookupBone(TEMP_FirstBone))
				local TEMP_FirstBonePosSmall = TEMP_FirstBonePos:Distance(dmginfo:GetDamagePosition())<TEMP_ExplosionRadius
				
				if((TEMP_BoomDamage&&TEMP_FirstBonePosSmall)||TEMP_ExpDamageFullDestroy||!TEMP_BoomDamage) then
					TEMP_MeatList = KFNPCStringAdd(TEMP_MeatList,self.GoreLArm.bone)
					self:KFNPCSetBodygoup(self.GoreLArm.bodygroup1)
					self:KFNPCCreateGib(TEMP_FirstBone,self.GoreLArm.model,dmginfo:GetDamageForce(),dmginfo:GetDamage(),true)
					KFNPCBleed(self,math.random(13,15),TEMP_FirstBonePos,AngleRand())
					sound.Play("KFMod.Gore"..math.random(1,8),self:GetBonePosition(self:LookupBone(TEMP_FirstBone)))
				end
			end
			
			if(self.GoreEnabled[HITGROUP_RIGHTARM]&&(TEMP_BoomDamage||
			(isnumber(self.HitBoxLastDamage[HITGROUP_RIGHTARM])&&self.HitBoxLastDamage[HITGROUP_RIGHTARM]>CurTime()))) then
				local TEMP_FirstBone = string.Explode(",",self.GoreRArm.bone)[1]
				local TEMP_FirstBonePos = self:GetBonePosition(self:LookupBone(TEMP_FirstBone))
				local TEMP_FirstBonePosSmall = TEMP_FirstBonePos:Distance(dmginfo:GetDamagePosition())<TEMP_ExplosionRadius
				
				if((TEMP_BoomDamage&&TEMP_FirstBonePosSmall)||TEMP_ExpDamageFullDestroy||!TEMP_BoomDamage) then
					TEMP_MeatList = KFNPCStringAdd(TEMP_MeatList,self.GoreRArm.bone)
					self:KFNPCSetBodygoup(self.GoreRArm.bodygroup1)
					self:KFNPCCreateGib(TEMP_FirstBone,self.GoreRArm.model,dmginfo:GetDamageForce(),dmginfo:GetDamage(),true)
					KFNPCBleed(self,math.random(13,15),TEMP_FirstBonePos,AngleRand())
					sound.Play("KFMod.Gore"..math.random(1,8),self:GetBonePosition(self:LookupBone(TEMP_FirstBone)))
				end
			end
		end
		
		if(#TEMP_MeatList==0) then
			TEMP_MeatList = false
		end
		
		
		self:KFNPCKill(dmginfo,TEMP_MeatList,TEMP_BoomDamage)
	end
	
	if(self.PlayingAnimation==false) then
		if(TEMP_RealAttacker!=game.GetWorld()&&IsValid(TEMP_RealAttacker)&&TEMP_RealAttacker!=nil&&TEMP_RealAttacker!=NULL&&
		TEMP_RealAttacker!=self&&(!IsValid(self:GetEnemy())||self:GetEnemy()==nil||self:GetEnemy()==NULL||
		self:GetEnemy():GetPos():Distance(self:GetPos())>TEMP_RealAttacker:GetPos():Distance(self:GetPos())*1.25)) then
			if(TEMP_RealAttacker:IsPlayer()||TEMP_RealAttacker:IsNPC()||TEMP_RealAttacker:IsNextBot()) then
				
				if((self:Disposition(TEMP_RealAttacker)==D_LI&&GetConVar("kf_npc_friendly_attack"):GetInt()==1)||
				self:Disposition(TEMP_RealAttacker)==D_HT) then
					local TEMP_Rand = math.random(1,5)
					
					if(TEMP_Rand==1) then
						local TEMP_LastEnemy = self:GetEnemy()
						self:AddEntityRelationship( TEMP_RealAttacker, D_HT, self.Hate )
						self:SetEnemy(TEMP_RealAttacker)
						self.RegEnemy = TEMP_RealAttacker
						self:UpdateEnemyMemory(TEMP_RealAttacker,TEMP_RealAttacker:GetPos())
						
						if(TEMP_LastEnemy!=TEMP_RealAttacker) then
							self:SelectSchedule()
						end
					end
				end
			end
		end
	end
	
	self.LastDamageHitgroup = -1

	return 1
end

function ENT:GetAttackSpread( Weapon, Target )
	return 0.1
end