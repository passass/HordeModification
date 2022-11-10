
AddCSLuaFile()


ENT.PrintName = "Leviathan's Sigh"
ENT.Base = "base_gmodentity"
ENT.Author = "Delta"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

//sound.Add(CHAN_AUTO, loop1, 100, 100, 75, "blackholeloop1.wav", 1, 100)
//sound.Add(CHAN_AUTO, loop2, 100, 100, 75, "blackholeloop2.wav", 1, 100)

function ENT:Initialize()
	if ( CLIENT ) then return end
	//self.ExplodeTimeOffset = math.random(4,6)

	self.KillTime = CurTime() + 2
	self.beginImplosion = CurTime() + 0.25

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow(false)
	self:SetModelScale(0.8, 0)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	self:SetCollisionGroup(20)
	-- self.effects = EffectData()
	-- self.effects:SetScale(1)
	-- self.effects:SetMagnitude(1)
	-- self.effects:SetEntity(self)
	-- self.effects:SetRadius(30)

	-- self.dissolve = DamageInfo()
	-- self.dissolve:SetDamage(50)
	-- self.dissolve:SetDamageType(DMG_DISSOLVE)
	-- self.SoundPlayed = 0


	-- self.explosioneffects = EffectData()
	-- self.explosioneffects:SetScale(1)
	-- self.explosioneffects:SetMagnitude(1)
	-- self.explosioneffects:SetEntity(self)
	-- self.explosioneffects:SetRadius(64)
	-- self.explosioneffects:SetDamageType(DMG_BLAST)


end

function ENT:Think()
	if CLIENT then return end
	-- self.effects:SetStart(self:GetPos() + Vector(math.random(10),math.random(10),math.random(10)))
	-- self.effects:SetOrigin(self:GetPos())

	if CurTime() > (self.beginImplosion ) then
		if SERVER then
			local dmg = DamageInfo()
			dmg:SetDamageType( DMG_DISSOLVE )
			dmg:SetAttacker( self:GetOwner() )
			dmg:SetInflictor( self )
			//dmg:SetDamageForce( Vector( 0, 0, 0 ) * 1 )
			
			
			for k,v in pairs(ents.FindInSphere(self:GetPos(), 250)) do
				if (v:IsPlayer() == true or v:IsNPC() == true) and v != self:GetOwner() then
					v:SetLocalVelocity(((self:GetPos() - v:GetPos()) * -20) + v:GetUp()*500)
					//Get distance from self to v but invert it so the closer they are the more damage they take
					local dist = (self:GetPos() - v:GetPos()):Length()
					local dmgamt = 1 - (dist / 250)
					dmg:SetDamage( dmgamt*100 )
					v:TakeDamageInfo( dmg )
				end
			end
			
			ParticleEffect( "D2VoidBlast_Main", self:GetPos() + Vector(0, 0, 5), Angle( 0, 0, 0 ))
			//self:EmitSound("TFA_LORENTZ_EXPLODE.1")
			//util.BlastDamageInfo( dmg, self:GetPos(), 225 )
			self:Remove()
		end
	end

	if CurTime() > self.KillTime then
		self:Remove()
	end

	self:NextThink(CurTime() + .1)

	return true
end




function ENT:Draw()
	//self:DrawModel()
	//self:SetMaterial("debug/debugdrawflat" )
	//self:SetColor(Color(0,0,0,1))
end
