ENT.Base 			= "kf_ai"
ENT.Type 			= "ai"

ENT.PrintName		= "KF SNPC"
ENT.Author			= "ERROR"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.AutomaticFrameAdvance = false

function ENT:OnRemove()
end

function ENT:PhysicsCollide( data, physobj )
end

function ENT:PhysicsUpdate( physobj )
end

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end