if(!file.Exists("lua/entities/kf_ai/init.lua","THIRDPARTY")) then
	
	return
end

ENT.VJ_NPC_Class = {"CLASS_ZOMBIE", "CLASS_XEN"}
VJ.AddNPC("Husk","npc_hordeext_husk", "Zombies")

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
include("KFNPCBaseVars.lua")

ENT.PrevEnemyPos = Vector(0,0,0)

ENT.HeadHealth = 250

ENT.HeadLess = false

ENT.StunInStun = true

ENT.PainSoundEnabled = true
ENT.PainSound.name = "KFMod.Husk.Pain"
ENT.PainSound.min = 1
ENT.PainSound.max = 16

ENT.DieSoundEnabled = true
ENT.DieSound.name = "KFMod.Husk.Die"
ENT.DieSound.min = 1
ENT.DieSound.max = 7

ENT.MeleeSoundEnabled = true
ENT.MeleeSound.name = "KFMod.Husk.Attack"
ENT.MeleeSound.min = 1
ENT.MeleeSound.max = 4

ENT.ChasingSoundEnabled = true
ENT.ChasingSound.name = "KFMod.Husk.Chase"
ENT.ChasingSound.min = 1
ENT.ChasingSound.max = 26

ENT.IdlingSoundEnabled = true
ENT.IdlingSound.name = "KFMod.Husk.Idle"
ENT.IdlingSound.min = 1
ENT.IdlingSound.max = 6

ENT.MeleeAttackDistance = 19


ENT.AutoChangeActivityWhenOnFire = false


ENT.NextShoot = 0

function ENT:Initialize()
	self.Model = "models/Tripwire/Killing Floor/Zeds/KFHusk.mdl"
	self:KFNPCInit(Vector(18,18,75),MOVETYPE_STEP,nil,600,"*0.1","/3","*0.05")
	self.FlinchDamage = 0
	
	
	self:DropToFloor()
	
	
	local TEMP_MeleeHitTable = {}
	for S=1,6 do
		TEMP_MeleeHitTable[S] = "KFMod.StrongHit"..S
	end
	
	local TEMP_MeleeMissTable = {}
	for S=1,4 do
		TEMP_MeleeMissTable[S] = "KFMod.Gorefast.SwordMiss"..S
	end
	
	local TEMP_MeleeTable = self:KFNPCCreateMeleeTable()
	TEMP_MeleeTable.damage[1] = 15
	TEMP_MeleeTable.damagetype[1] = DMG_CLUB
	TEMP_MeleeTable.distance[1] = 25
	TEMP_MeleeTable.radius[1] = 50
	TEMP_MeleeTable.time[1] = 1.0
	TEMP_MeleeTable.bone[1] = "Barrel"
	self:KFNPCSetMeleeParams(1,"S_Melee1",1, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)

	
	self.ShootInterval = 5.5
	local BurnDamageScale = 0.25
	
	 if(self.Difficulty==0) then
         self.ShootInterval = self.ShootInterval * 1.25;
         BurnDamageScale = BurnDamageScale * 2.0;
     elseif( self.Difficulty<3 ) then
         self.ShootInterval = self.ShootInterval * 1.0;
         BurnDamageScale = BurnDamageScale * 1.0;
     elseif( self.Difficulty==3 ) then
         self.ShootInterval = self.ShootInterval * 0.75;
         BurnDamageScale = BurnDamageScale * 0.75;
     else
         self.ShootInterval = self.ShootInterval * 0.60;
         BurnDamageScale = BurnDamageScale * 0.5;
     end
	 
	self.DamageTypeMult[DMG_BURN] = BurnDamageScale
	self.DamageTypeMult[DMG_SLOWBURN] = BurnDamageScale
	 
	self.NextShoot = CurTime()+1
end

function ENT:KFNPCAnimEnemyIsValid()
	if(self.PlayingAnimation==true&&(self.AttackIndex==1||self.AttackIndex==2)) then
		if(self.AttackIndex==3) then
			
			local TEMP_EnemyTracer = util.TraceHull( {
				start = self:GetAttachment( self:LookupAttachment("HuskgunShoot") ).Pos,
				endpos = self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter(),
				filter = self,
				mins = Vector( -2, -2, -2 ),
				maxs = Vector( 2, 2, 2 ),
				mask = MASK_NPCSOLID_BRUSHONLY
			} )
			
			if(TEMP_EnemyTracer.Entity==self:GetEnemy()) then
				self.PrevEnemyPos = self:GetEnemy():GetPos()
			end
		end
		
		self:SetAngles(Angle(0,(self:GetEnemy():GetPos()-self:GetPos()):Angle().Yaw,0))
	end
end

function ENT:KFNPCThink()
	if(self.Animation=="S_RangedHuskGun_Npc") then
		if(IsValid(self:GetEnemy())&&self:GetEnemy()!=NULL) then
			local TEMP_Dif = (self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter())-(self:GetPos()+Vector(0,0,30))
			local TEMP_AngP = TEMP_Dif:Angle().Pitch
			local TEMP_AngY = TEMP_Dif:Angle().Yaw-self:GetAngles().Yaw
			local TEMP_AngP = math.NormalizeAngle(TEMP_AngP)*2.1
			
			self:SetPoseParameter("aim_pitch_npc",TEMP_AngP)
			self:SetPoseParameter("aim_yaw",math.Clamp(TEMP_AngY,-30,30))
		end
	end
	
	if(self.Animation=="S_RangedFlamethrower") then
		if(IsValid(self:GetEnemy())&&self:GetEnemy()!=NULL) then
			self:KFNPCRotateCorrectly((self:GetEnemy():GetPos()-self:GetPos()):Angle().Yaw,20)
		end
	else
		self:StopSound("KFMod.Flamethrower.Fire")
	end
	
	if(self:IsMoving()&&self.CanManipulateActivity==true) then
		if(self:GetMovementActivity()!=self.WalkAct) then
			self:SetMovementActivity(self.WalkAct)
		end
	end
end



function ENT:KFNPCDistanceForMeleeTooBig()
	if(self.PlayingAnimation==false&&self.NextShoot<CurTime()&&!self:KFNPCIsHeadless()&&self:GetEnemy():VisibleVec(self:GetPos()+self:OBBCenter())) then
		local TEMP_ShootInterval = self.ShootInterval
		
		self.PlayingAnimation = true	
		self:KFNPCStopAllTimers()
		
		
		
		if(self.Hard==1&&(self:GetPos()+self:OBBCenter()):Distance(self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter())<350) then
			self:KFNPCPlayAnimation("S_RangedFlamethrower",0)
			
			timer.Create("StartAttack"..tostring(self),0.5,1,function()
				if(IsValid(self)&&self!=nil&&self!=NULL) then
					self:EmitSound("KFMod.Flamethrower.Fire")
					
					timer.Create("Attack"..tostring(self).."1",0.05,70,function()
						if(IsValid(self)&&self!=nil&&self!=NULL) then
							local TEMP_Att = self:GetAttachment( self:LookupAttachment("HuskgunShoot") )
							local TEMP_SpawnPos = TEMP_Att.Pos
							local TEMP_SpawnAng = TEMP_Att.Ang
							TEMP_SpawnAng = TEMP_SpawnAng:RotateAroundAxis(-TEMP_SpawnAng:Right(),90)
							
							
							local TEMP_Dir = ((TEMP_Att.Ang:Forward()*1600)+
							(Vector(math.random(-200,200),math.random(-200,200),math.random(-200,200)))):GetNormalized()
							
							local TEMP_Flame = ents.Create("ent_kf_flame")
							TEMP_Flame:SetPos(TEMP_SpawnPos)
							TEMP_Flame:SetAngles(TEMP_Dir:Angle())
							TEMP_Flame:SetOwner(self)
							TEMP_Flame:Spawn()
							
							TEMP_Flame.Damage  = self.DMGMult*3
							
							TEMP_Flame:GetPhysicsObject():SetVelocity(TEMP_Dir*2000)
							TEMP_Flame:SetOwner(self)
							TEMP_Flame:SetCreator(self)
							
							TEMP_Flame:Fire("kill","",0.25)
							
							if(timer.RepsLeft("Attack"..tostring(self).."1")<2) then
								self:StopSound("KFMod.Flamethrower.Fire")
							end
						end
					end)
				end
			end)
		
			timer.Create("EndAttack"..tostring(self),5,1,function()
				if(IsValid(self)&&self!=nil&&self!=NULL) then
					self:KFNPCStopAllTimers()
					self:KFNPCClearAnimation()
					self:StopSound("KFMod.Flamethrower.Fire")
				end
			end)
			
			
			self.NextShoot = CurTime()+4+TEMP_ShootInterval
		else
			
			self:KFNPCPlayAnimation("S_RangedHuskGun_Npc",2)
			
			
			self:KFNPCPlaySoundRandom(70,"KFMod.Husk.RAttack",1,6)
			
			local TEMP_ShootPos = self:GetAttachment( self:LookupAttachment("HuskgunShoot") )
			
			sound.Play("KFMod.HuskGun.Charge",self:GetAttachment( self:LookupAttachment("Huskgunshoot") ).Pos)
			
			if(IsValid(self:GetEnemy())&&self:GetEnemy()!=nil&&self:GetEnemy()!=NULL) then
				self.PrevEnemyPos = self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()
			else
				self.PrevEnemyPos = self:GetPos()+(self:GetForward()*1000)
			end
			
			timer.Create("StartAttack"..tostring(self),1.1,1,function()
				if(IsValid(self)&&self!=nil&&self!=NULL) then
					local TEMP_BDamage = 18
					local TEMP_FireBallSpeed =	1950
					
					if(self.Hard>1) then
						TEMP_ShootInterval = TEMP_ShootInterval*0.8
						TEMP_BDamage = 24
						TEMP_FireBallSpeed = 2400
					end
			
					local TEMP_WeaponPos = self:GetAttachment( self:LookupAttachment("Huskgunshoot") )
					
					sound.Play("KFMod.HuskGun.Shoot",TEMP_WeaponPos.Pos)
					
					local TEMP_FireBall = ents.Create("ent_huskfireball")
					TEMP_FireBall:SetPos(TEMP_WeaponPos.Pos)
					TEMP_FireBall:SetAngles(self:GetForward():Angle())
					TEMP_FireBall:Spawn()
					TEMP_FireBall:SetOwner(self)
					
					TEMP_FireBall.Damage = self.DMGMult*20
					
					local TEMP_EPOS = self:GetPos()+(self:GetForward()*TEMP_FireBallSpeed)
					
					if(IsValid(self:GetEnemy())&&self:GetEnemy()!=nil&&self:GetEnemy()!=NULL&&(self:GetEnemy():IsNPC()||
					self:GetEnemy():IsNextBot()||(self:GetEnemy():IsPlayer()&&self:GetEnemy():Alive()))) then
						TEMP_EPOS = self:GetEnemy():GetPos()+self:GetEnemy():OBBMins()
						
						local TEMP_EnemySpeed = self:GetEnemy():GetVelocity()
						
						if(self:GetEnemy():IsNPC()||self:GetEnemy():IsNextBot()) then
							TEMP_EnemySpeed = TEMP_EnemySpeed+self:GetEnemy():GetGroundSpeedVelocity()
						end
						
						if(TEMP_EnemySpeed.Z!=0) then
							TEMP_EPOS = self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()
						end
							
						local TEMP_DST = TEMP_FireBall:GetPos():Distance(TEMP_EPOS+TEMP_EnemySpeed)
						local TEMP_NEWPOS = TEMP_EPOS+(TEMP_EnemySpeed/
						(TEMP_FireBallSpeed/TEMP_DST))
						
						local TEMP_Tracer = util.TraceHull( {
							start = Vector(TEMP_NEWPOS.X,TEMP_NEWPOS.Y,TEMP_EPOS.Z),
							endpos = TEMP_NEWPOS,
							filter = {TEMP_FireBall,self:GetEnemy()},
							mins = Vector( -5, -5, -5 ),
							maxs = Vector( 5, 5, 5 ),
							mask = MASK_NPCSOLID_BRUSHONLY
						} )
						
						if(TEMP_FireBall:VisibleVec(TEMP_Tracer.HitPos)) then
							TEMP_EPOS = TEMP_Tracer.HitPos+Vector(0,0,math.min(((TEMP_DST*0.001)*(TEMP_DST*0.001))*2,7.25))
						else
							TEMP_EPOS = self:GetEnemy():GetPos()+self:GetEnemy():OBBMins()
							
							if(!TEMP_FireBall:VisibleVec(TEMP_EPOS)) then
								TEMP_EPOS = self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()
								
								if(!TEMP_FireBall:VisibleVec(TEMP_EPOS)) then
									TEMP_EPOS = self:GetEnemy():GetPos()+self:GetEnemy():OBBMaxs()
									
									if(!TEMP_FireBall:VisibleVec(TEMP_EPOS)) then
										TEMP_EPOS = self.PrevEnemyPos
									end
								end
							end
						end
						
						
						/*
						
						if(TEMP_FireBall:VisibleVec(self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter())) then
							TEMP_EPOS = self:GetEnemy():GetPos()+self:GetEnemy():OBBMins()
							
							local TEMP_EnemySpeed = self:GetEnemy():GetVelocity()
							
							if(self:GetEnemy():IsNPC()||self:GetEnemy():IsNextBot()) then
								TEMP_EnemySpeed = TEMP_EnemySpeed+self:GetEnemy():GetGroundSpeedVelocity()
							end
							
							
							local TEMP_DST = TEMP_FireBall:GetPos():Distance(TEMP_EPOS+TEMP_EnemySpeed)
							local TEMP_NEWPOS = TEMP_EPOS+TEMP_EnemySpeed/
							(TEMP_FireBallSpeed/TEMP_DST)
							local TEMP_ZAdd = 1+((TEMP_DST*0.0008)*(TEMP_DST*0.0008))				
							
							if(TEMP_EnemySpeed.Z<=0) then
								local TEMP_Tracer = util.TraceHull( {
									start = TEMP_NEWPOS,
									endpos = TEMP_NEWPOS+Vector(0,0,-5000),
									filter = {TEMP_FireBall,self:GetEnemy()},
									mins = Vector( -5, -5, -5 ),
									maxs = Vector( 5, 5, 5 ),
									mask = MASK_NPCSOLID_BRUSHONLY
								} )
							
								if(TEMP_FireBall:VisibleVec(TEMP_Tracer.HitPos+Vector(0,0,TEMP_ZAdd))&&
								self:GetEnemy():VisibleVec(TEMP_Tracer.HitPos+Vector(0,0,TEMP_ZAdd))&&
								Vector(TEMP_EPOS.X,TEMP_EPOS.Y,TEMP_EPOS.Z):Distance(Vector(TEMP_EPOS.X,TEMP_EPOS.Y,TEMP_Tracer.HitPos.Z))<100) then
									TEMP_EPOS = TEMP_Tracer.HitPos+Vector(0,0,math.min(TEMP_ZAdd,6))
								else
									local TEMP_Tracer = util.TraceHull( {
										start = Vector(TEMP_NEWPOS.X,TEMP_NEWPOS.Y,TEMP_EPOS.Z),
										endpos = Vector(TEMP_NEWPOS.X,TEMP_NEWPOS.Y,TEMP_EPOS.Z)+Vector(0,0,-5000),
										filter = {TEMP_FireBall,self:GetEnemy()},
										mins = Vector( -5, -5, -5 ),
										maxs = Vector( 5, 5, 5 ),
										mask = MASK_NPCSOLID_BRUSHONLY
									} )
									
									if(TEMP_FireBall:VisibleVec(TEMP_Tracer.HitPos+Vector(0,0,TEMP_ZAdd))&&
									self:GetEnemy():VisibleVec(TEMP_Tracer.HitPos+Vector(0,0,TEMP_ZAdd))&&
									(TEMP_Tracer.HitPos+Vector(0,0,TEMP_ZAdd)):Distance(self:GetEnemy():NearestPoint(TEMP_Tracer.HitPos+Vector(0,0,2)))<70) then
										TEMP_DST = TEMP_FireBall:GetPos():Distance(TEMP_Tracer.HitPos)
										TEMP_ZAdd = 1+((TEMP_DST*0.0008)*(TEMP_DST*0.0008))		
										TEMP_EPOS = TEMP_Tracer.HitPos+Vector(0,0,math.min(TEMP_ZAdd,6))
									end
								end
							else
								if(TEMP_FireBall:VisibleVec(TEMP_NEWPOS)) then
									TEMP_EPOS = TEMP_NEWPOS
								end
							end
						else
							TEMP_EPOS = self.PrevEnemyPos
							
							local TEMP_GroundTR = util.TraceLine( {
								start = self.PrevEnemyPos,
								endpos = self.PrevEnemyPos+Vector(0,0,-5000),
								filter = {TEMP_FireBall,self:GetEnemy()},
								mins = Vector( -5, -5, -5 ),
								maxs = Vector( 5, 5, 5 ),
								mask = MASK_NPCSOLID_BRUSHONLY
							} )
							
							if(TEMP_FireBall:VisibleVec(TEMP_GroundTR.HitPos)) then
								TEMP_DST = TEMP_FireBall:GetPos():Distance(TEMP_GroundTR.HitPos)
								TEMP_ZAdd = 1+((TEMP_DST*0.0008)*(TEMP_DST*0.0008))	
								TEMP_EPOS = TEMP_GroundTR.HitPos+Vector(0,0,math.min(TEMP_ZAdd,6))
							end
						end*/
					else
						TEMP_EPOS = TEMP_WeaponPos.Pos+(self:GetForward()*100)
					end
					
					TEMP_FireBall:SetAngles((TEMP_EPOS-TEMP_FireBall:GetPos()):Angle())
						
					local TEMP_GrenPhys = TEMP_FireBall:GetPhysicsObject()
					TEMP_GrenPhys:EnableGravity(false)
					TEMP_GrenPhys:SetVelocity(TEMP_FireBall:GetForward()*TEMP_FireBallSpeed)
					
					local TEMP_CEffectData = EffectData()
					TEMP_CEffectData:SetOrigin(TEMP_WeaponPos.Pos)
					TEMP_CEffectData:SetColor(0)
					TEMP_CEffectData:SetEntity(self)
					TEMP_CEffectData:SetAngles(TEMP_WeaponPos.Ang)
					util.Effect( "MuzzleFlash", TEMP_CEffectData, false )
					
					timer.Create("MidAttack"..tostring(self),0.5,1,function()
						if(IsValid(self)&&self!=nil&&self!=NULL) then
							sound.Play("KFMod.HuskGun.Uncharge",self:GetAttachment( self:LookupAttachment("Huskgunshoot") ).Pos)
						end
					end)
					
					timer.Create("EndAttack"..tostring(self),1.3,1,function()
						if(IsValid(self)&&self!=nil&&self!=NULL) then
							self:KFNPCStopAllTimers()
							self:KFNPCClearAnimation()
						end
					end)
				end
			end)
			
			self.NextShoot = CurTime()+2+TEMP_ShootInterval
		end
	end
end

function ENT:KFNPCRemove()
	self:StopSound("KFMod.Flamethrower.Fire")
end

