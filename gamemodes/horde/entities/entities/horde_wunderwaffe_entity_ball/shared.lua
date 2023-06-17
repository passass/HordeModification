ENT.Type			= "anim"
ENT.PrintName		= "Lightning ball"
ENT.Author			= "Hidden"
ENT.Spawnable		= false
ENT.RenderGroup		= RENDERGROUP_TRANSLUCENT

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Upgraded")
end

function ENT:OnRemove()
	self:StopSound("weapons/tesla_gun/projectile/proj_loop.wav")
end