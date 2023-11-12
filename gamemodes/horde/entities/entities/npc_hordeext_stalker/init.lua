if(!file.Exists("lua/entities/kf_ai/init.lua","THIRDPARTY")) then
	
	return
end

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
include("KFNPCBaseVars.lua")
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE", "CLASS_XEN"}
ENT.AutoChangeActivityWhenHeadless = false

ENT.StunInStun = true

ENT.GoreHead.model = "models/Tripwire/Killing Floor/Zeds/KFStalkerGoreHead.mdl"
ENT.GoreRArm.model = "models/Tripwire/Killing Floor/Zeds/KFStalkerGoreRHand.mdl"
ENT.GoreLArm.model = "models/Tripwire/Killing Floor/Zeds/KFStalkerGoreLHand.mdl"
ENT.GoreRLeg.model = "models/Tripwire/Killing Floor/Zeds/KFStalkerGoreRLeg.mdl"
ENT.GoreLLeg.model = "models/Tripwire/Killing Floor/Zeds/KFStalkerGoreLLeg.mdl"

ENT.PainSoundEnabled = true
ENT.PainSound.name = "KFMod.Stalker.Pain"
ENT.PainSound.min = 1
ENT.PainSound.max = 4

ENT.DieSoundEnabled = true
ENT.DieSound.name = "KFMod.Stalker.Die"
ENT.DieSound.min = 1
ENT.DieSound.max = 1

ENT.ChasingSoundEnabled = true
ENT.ChasingSound.name = "KFMod.Stalker.Chase"
ENT.ChasingSound.min = 1
ENT.ChasingSound.max = 6

ENT.IdlingSoundEnabled = true
ENT.IdlingSound.name = "KFMod.Siren.Idle"
ENT.IdlingSound.min = 1
ENT.IdlingSound.max = 1

ENT.MeleeSoundEnabled = false

ENT.InvisWay = 2

ENT.MeleeAttackDistance = 14

if CLIENT then
    language.Add("npc_hordeext_stalker", "Stalker")
end

function ENT:Initialize()
	self.Model = "models/Tripwire/Killing Floor/Zeds/KFStalker.mdl"
	self:KFNPCInit(Vector(-16,-16,70),MOVETYPE_STEP,nil,80,"0","/2")
	
	self:DropToFloor()
	
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	local TEMP_MeleeHitTable = {}
	for S=1,12 do
		TEMP_MeleeHitTable[S] = "KFMod.ClawHit"..S
	end
	
	local TEMP_MeleeMissTable = {}
	for S=1,4 do
		TEMP_MeleeMissTable[S] = "KFMod.LightSwing"..S
	end
	
	local TEMP_MeleeTable = self:KFNPCCreateMeleeTable()
	TEMP_MeleeTable.damage[1] = 9
	TEMP_MeleeTable.damagetype[1] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[1] = 23
	TEMP_MeleeTable.radius[1] = 50
	TEMP_MeleeTable.time[1] = 0.9
	TEMP_MeleeTable.bone[1] = "CHR_LArmPalm"
	TEMP_MeleeTable.damage[2] = 9
	TEMP_MeleeTable.damagetype[2] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[2] = 23
	TEMP_MeleeTable.radius[2] = 50
	TEMP_MeleeTable.time[2] = 1.8
	TEMP_MeleeTable.bone[2] = "CHR_RArmPalm"
	self:KFNPCSetMeleeParams(1,"S_Melee1",2, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	
	TEMP_MeleeTable.damage[1] = 4.5
	TEMP_MeleeTable.damagetype[1] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[1] = 23
	TEMP_MeleeTable.radius[1] = 50
	TEMP_MeleeTable.time[1] = 0.75
	TEMP_MeleeTable.bone[1] = "CHR_LArmPalm"
	TEMP_MeleeTable.damage[2] = 4.5
	TEMP_MeleeTable.damagetype[2] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[2] = 23
	TEMP_MeleeTable.radius[2] = 50
	TEMP_MeleeTable.time[2] = 0.75
	TEMP_MeleeTable.bone[2] = "CHR_RArmPalm"
	self:KFNPCSetMeleeParams(2,"S_Melee2",2, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
	
	TEMP_MeleeTable.damage[1] = 4.5
	TEMP_MeleeTable.damagetype[1] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[1] = 23
	TEMP_MeleeTable.radius[1] = 50
	TEMP_MeleeTable.time[1] = 0.8
	TEMP_MeleeTable.bone[1] = "CHR_LArmPalm"
	TEMP_MeleeTable.damage[2] = 4.5
	TEMP_MeleeTable.damagetype[2] = bit.bor(DMG_SLASH, DMG_CLUB)
	TEMP_MeleeTable.distance[2] = 23
	TEMP_MeleeTable.radius[2] = 50
	TEMP_MeleeTable.time[2] = 0.8
	TEMP_MeleeTable.bone[2] = "CHR_RArmPalm"
	self:KFNPCSetMeleeParams(3,"S_Melee3",2, TEMP_MeleeTable,TEMP_MeleeHitTable,TEMP_MeleeMissTable)
end

function ENT:KFNPCFlinchCondition() 
	if(self.Animation!=self.StunSequence) then
		return true
	end
	return false
end

ENT.Next_AssaultInvisThink = 0

function ENT:KFNPCThink()
	if(self:IsMoving()&&self.CanManipulateActivity==true) then
		if(self:GetMovementActivity()!=self.RunAct) then
			self:SetMovementActivity(self.RunAct)
		end
	end

	if(self.PlayingAnimation==true&&string.sub(self.Animation,1,7)=="S_Melee") then
		self:SetMaterial("")
		self:SetColor(Color(255,255,255,255))
		self.InvisWay = 4
	else
		if(self.InvisWay>2) then
			self.InvisWay = self.InvisWay-0.5
		elseif(self.InvisWay>0) then
			self.InvisWay = self.InvisWay-0.5
			
			if(math.floor(self.InvisWay)==self.InvisWay) then
				self:SetMaterial("models/tripwire/killing floor/zeds/stalker/stalker_spec",true)
			else
				self:SetMaterial("")
				self:SetColor(Color(255,255,255,60))
			end
		else
			local CT = CurTime()
			
			if self.Next_AssaultInvisThink < CT then
				self.Next_AssaultInvisThink = CT + .25

				local revelead = false

				for _, ply in pairs(player.GetAll()) do
					if ply:Alive() and ply:Horde_GetSubclass(ply:Horde_GetClass().name) == "Assault" and ply:GetPos():Distance(self:GetPos()) < 450 then
						self:SetMaterial("models/tripwire/killing floor/zeds/stalker/stalker_spec_show",true)
						self:SetColor(Color(255,255,255,210))
						revelead = true
					end
				end

				if !revelead then
					self:SetColor(Color(255,255,255,60))
					self:SetMaterial("models/tripwire/killing floor/zeds/stalker/stalker_spec",true)
				end
			end
		end
	end
end