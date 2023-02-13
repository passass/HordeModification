
if SERVER then
	AddCSLuaFile( )
end
ENT.Type 				= "anim"
--ENT.Base 				= "base_entity"
ENT.PrintName 			= "Barricade"
ENT.Author 				= ""
ENT.Information 		= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

--[[function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "HP" )

end]]
local default_hp = 300
ENT.VJ_AddEntityToSNPCAttackList = true
ENT.Horde_Immune_Status = {
	[HORDE.Status_Bleeding] = true
}
if CLIENT then

	function ENT:Draw()
		self:DrawModel()
		local angl = self:GetAngles()
		--cam.Start3D2D(self:LocalToWorld(Vector(-2, 0, self:OBBMaxs().z)), Angle(angl[1], angl[2] - 90, angl[3]), 0.05)
		local y = -50
		local percentage = self:Health() / default_hp
		local maxbarwidth = 560
		local barheight = 30
		local barwidth = maxbarwidth
		local startx = barwidth * -0.5
		cam.Start3D2D(self:LocalToWorld(Vector(self:OBBMaxs().x - 5, 0, 25)), Angle(angl[1] - 180, angl[2] - 90, angl[3] - 90), 0.05)
			
			surface.SetDrawColor(0, 0, 0, 220)
			surface.DrawRect(startx, y, barwidth, barheight)
			surface.SetDrawColor(255 - percentage * 255, percentage * 255, 0, 220)
			surface.DrawRect(startx + 4, y + 4, barwidth * percentage - 8, barheight - 8)
			surface.DrawOutlinedRect(startx, y, barwidth, barheight)
		cam.End3D2D()
		cam.Start3D2D(self:LocalToWorld(Vector(-self:OBBMaxs().x + 5, 0, 25)), Angle(angl[1] - 180, angl[2] - 90, angl[3] - 90), 0.05)
			
			surface.SetDrawColor(0, 0, 0, 220)
			surface.DrawRect(startx, y, barwidth, barheight)
			surface.SetDrawColor(255 - percentage * 255, percentage * 255, 0, 220)
			surface.DrawRect(startx + 4, y + 4, barwidth * percentage - 8, barheight - 8)
			surface.DrawOutlinedRect(startx, y, barwidth, barheight)
		cam.End3D2D()
	end
else
	function ENT:TakeDMG(damage)
		local hp = self:Health()
		hp = hp - damage
		
		if hp > 0 then
			self:SetHealth(hp)
		else
			self:EmitSound("physics/concrete/concrete_break" .. math.random(2, 3) .. ".wav")
			self:GetNWEntity("HordeOwner"):Horde_RemoveDropEntity("horde_barricadekit", self:GetCreationID())
			SafeRemoveEntity(self)
		end
	end

	function ENT:Heal(points)
		self:SetHealth(math.Clamp(self:Health() + points, 0, default_hp))
	end

	function ENT:Horde_OnTakeDamage(dmginfo)
		if !dmginfo:GetAttacker():IsNPC() then
			return
		end
		self:TakeDMG(dmginfo:GetDamage())
	end

	function ENT:Horde_OnWelderUse()
		self:Heal(1)
		return true
	end

	hook.Add("EntityTakeDamage", "Horde_OnEntHitHook", function (target, dmg)
		if isentity(target) and target.Horde_OnTakeDamage then
			target:Horde_OnTakeDamage(dmg)
		end
	end)
end

function ENT:Initialize()
	self:SetModel("models/props_c17/concrete_barrier001a.mdl")

	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion( false )
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		phys:Wake()
	end
	self:SetCollisionBounds( Vector(-51, -51, -51), Vector(51, 51, 51) )
	--self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetHealth(default_hp)
	if SERVER then
		self:SetMaxHealth(default_hp)
		local owner = self:GetNWEntity("HordeOwner")
		if IsValid(owner) then
			owner:Horde_AddWeight(-HORDE.items[self.Horde_ItemID].weight)
		end
	end
end

function ENT:Think() end

ENT.Horde_ItemID = "horde_barricadekit"
