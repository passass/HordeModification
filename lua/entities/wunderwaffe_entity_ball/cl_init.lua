AddCSLuaFile()
include("shared.lua")

ENT.TrailPCF = "tesla_beam"
function ENT:Initialize()
	if self:GetUpgraded() then
		self.TrailPCF = "tesla_beam_pap"
	end	
	ParticleEffectAttach( self.TrailPCF, PATTACH_ABSORIGIN_FOLLOW, self, 0 )
end

function ENT:Think()
	if self:GetMoveType() == MOVETYPE_NONE then return end
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		dlight.pos = self:GetPos()
		dlight.dir = self:GetPos()
		dlight.r = 255
		dlight.g = 255
		dlight.b = 255
		dlight.brightness = 5
		dlight.Decay = 1000
		dlight.Size = 100
		dlight.DieTime = CurTime() + 1
	end
	
	--[[local eff1 = EffectData()
	eff1:SetEntity(self)
	eff1:SetOrigin(self:GetPos())
	eff1:SetStart(self:GetPos())
	eff1:SetMagnitude(2)
	util.Effect("TeslaHitboxes", eff1)
	]]
	--self:SetNextClientThink(CurTime() + 0.12)
	--return true
end