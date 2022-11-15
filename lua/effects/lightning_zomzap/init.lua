--Name: Lightning strike using midpoint displacement
--Author: Lolle

--EFFECT.MatCenter = Material( "lightning.png", "unlitgeneric smooth" )
EFFECT.MatEdge = Material( "effects/tool_tracer" )
EFFECT.MatCenter = Material( "sprites/physbeama" )
EFFECT.MatGlow1 = Material( "sprites/zombie_glow1_noz" )
EFFECT.MatGlow2 = Material( "sprites/zombie_glow2_noz" )
EFFECT.MatGlowCenter = Material( "sprites/zombie_glow_actual_noz" )

--[[---------------------------------------------------------
   Init( data table )
-----------------------------------------------------------]]
function EFFECT:Init( data )

	self.Pos = data:GetOrigin() + VectorRand() * 10
	self.Duration = data:GetMagnitude() or 2
	self.Count = self.Duration * 40
	self.Radius = 30
	self.Parent = data:GetEntity()

	self.Alpha = 255
	self.Life = 0
	self.Queue = 1

	self:SetRenderBounds( Vector(0,0,0), Vector(0,0,0), Vector(100,100,100) )

end

--[[---------------------------------------------------------
   THINK
-----------------------------------------------------------]]
function EFFECT:Think()

	if IsValid(self.Parent) then
		self.Pos = self.Parent:GetPos()
		self:SetPos(self.Pos)
	end

	self.Life = self.Life + FrameTime()
	--self.Alpha = 255 * ( 1 - self.Life )


	return ( self.Life < self.Duration )
end


--[[---------------------------------------------------------
   Draw the effect
-----------------------------------------------------------]]
function EFFECT:Render()

	if ( self.Alpha < 1 ) then return end
	
	render.SetMaterial( self.MatGlow1 )
	render.DrawSprite( self.Pos + Vector(0,0,30), math.random(200,600), math.random(200,600), Color(255,255,255,math.random(0,100)))
	
	if math.random(0,10) == 0 then
		render.SetMaterial( self.MatGlow2 )
		render.DrawSprite( self.Pos + Vector(0,0,30), math.random(200,600), math.random(200,600), Color(255,255,255,math.random(0,200)))
	end
	
	render.SetMaterial( self.MatGlowCenter )
	render.DrawSprite( self.Pos + Vector(0,0,30), math.random(75,200), math.random(75,200), Color(255,255,255,math.random(200,250)))
	
end
