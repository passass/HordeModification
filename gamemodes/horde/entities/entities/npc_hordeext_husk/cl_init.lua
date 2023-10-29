include('shared.lua')


killicon.Add( "npc_kfmod_husk", "HUD/killicons/husk_gun", Color( 255, 255, 255, 255 ) )
killicon.Add( "#npc_kfmod_husk", "HUD/killicons/husk_gun", Color( 255, 255, 255, 255 ) )

ENT.Lighted = false
ENT.DLight = {}

function ENT:Initialize()
	self.Lighted = (GetConVar("kf_npc_dlight"):GetInt()>0)
	
	if(self.Lighted==true) then
		local TEMP_Glow1 = {}
		TEMP_Glow1.ind = self:LookupAttachment("Glow1")
		TEMP_Glow1 = self:GetAttachment(TEMP_Glow1.ind)
		
		self.DLight = DynamicLight( self:EntIndex() )
		
		if ( self.DLight ) then
			self.DLight.r = 240
			self.DLight.g = 247
			self.DLight.b = 22
		
			self.DLight.pos = TEMP_Glow1.Pos
			self.DLight.brightness = 10
			self.DLight.Size = 13
			self.DLight.DieTime = CurTime() + 1
			self.DLight.style = 0
		end
	end
end

function ENT:Think()
	if(IsValid(self)&&self!=nil&&self!=NULL) then
		if(self.Lighted==true) then
			local TEMP_Glow1 = {}
			TEMP_Glow1.ind = self:LookupAttachment("Glow1")
			TEMP_Glow1 = self:GetAttachment(TEMP_Glow1.ind)
			
			self.DLight.DieTime = CurTime()+1
			self.DLight.pos = TEMP_Glow1.Pos
		end
	end
end