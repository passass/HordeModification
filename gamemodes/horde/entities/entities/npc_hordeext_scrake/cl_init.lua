include('shared.lua')

killicon.Add( "npc_kfmod_scrake", "HUD/killicons/scrake_chainsaw", Color( 255, 255, 255, 255 ) )
killicon.Add( "#npc_kfmod_scrake", "HUD/killicons/scrake_chainsaw", Color( 255, 255, 255, 255 ) )

function ENT:Initialize()
	local TEMP_Attachment = self:GetAttachment(self:LookupAttachment("anim_attachment_rh"))
	self.Emitter = ParticleEmitter(TEMP_Attachment.Pos, false)
end

function ENT:Think()
	if(IsValid(self)&&self!=nil&&self!=NULL&&self:GetNoDraw()==false) then
		local TEMP_Smoke = {
			"particle/smokesprites_0001",
			"particle/smokesprites_0002",
			"particle/smokesprites_0003",
			"particle/smokesprites_0004",
			"particle/smokesprites_0005",
			"particle/smokesprites_0006",
			"particle/smokesprites_0007",
			"particle/smokesprites_0008",
			"particle/smokesprites_0009",
			"particle/smokesprites_0010",
			"particle/smokesprites_0012",
			"particle/smokesprites_0013",
			"particle/smokesprites_0014",
			"particle/smokesprites_0015",
			"particle/smokesprites_0016"
		}
		
		local TEMP_Attachment = self:GetAttachment(self:LookupAttachment("anim_attachment_rh"))
		
		local TEMP_Particle = self.Emitter:Add( table.Random(TEMP_Smoke), TEMP_Attachment.Pos)
		TEMP_Particle:SetDieTime( 1.5 )
		TEMP_Particle:SetStartAlpha( 40 )
		TEMP_Particle:SetEndAlpha( 0 )
		TEMP_Particle:SetStartSize( 5 )
		TEMP_Particle:SetEndSize( 2 )
		TEMP_Particle:SetRoll( math.Rand( 60, 120 ) )
		TEMP_Particle:SetRollDelta( math.Rand( -1, 1 ) )
		TEMP_Particle:SetColor( 105, 105, 105 )
		TEMP_Particle:SetVelocity(Vector(0,0,0))
		TEMP_Particle:SetGravity(Vector(math.random(-5,5),math.random(-5,5),100):GetNormalized()*80)
		TEMP_Particle:SetAngleVelocity( Angle(1,1,1))
		TEMP_Particle:SetCollide(true)
	end
end