function EFFECT:Init(data)
	local ent = data:GetEntity()
	local att = data:GetAttachment()

	self.StartPos = data:GetOrigin()
	self.EndPos = data:GetStart()

	self.Element = data:GetFlags()

	//self.Position = data:GetStart()
	//self.EndPos = data:GetOrigin()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	self.StartPos = self:GetTracerShootPos( self.StartPos, self.WeaponEnt, self.Attachment )

	self.Dist = self.StartPos:Distance( self.EndPos )

	self.Timer1 = 0

	self.Mat = Material("tracer/D2Trace_void_tracer")
	self.Mat2 = Material("sprites/light_glow02_add")
	self.Mat3 = Material("effects/combinemuzzle2")

	if self.Element == 1 then
		self.Mat = Material("tracer/D2Trace_void_tracer")
	elseif self.Element == 2 then
		self.Mat = Material("tracer/D2Trace_solar_tracer")
	elseif self.Element == 3 then
		self.Mat = Material("tracer/D2Trace_arc_tracer2")
	elseif self.Element == 4 then
		self.Mat = Material("tracer/D2Trace_stasis_tracer")
	end



	if(ent:IsWeapon() && ent:IsCarriedByLocalPlayer()) then
		local ply = ent:GetOwner()

		if(!ply:ShouldDrawLocalPlayer()) then
			local vm = ply:GetViewModel()
			
			if(IsValid(vm)) then
				ent = vm
			end
		end
		
		
	end

	self.X = 1 * data:GetScale()
	self.Size = 1 * data:GetScale()
	self.Timer1 = CurTime() + self.X

	self:SetRenderBoundsWS(self.StartPos, self.EndPos)

	-- local emitter = ParticleEmitter(data:GetOrigin(), false)

	-- self.Normal = data:GetNormal()
	
	-- for i = 1, 1 do
	-- 	local part = emitter:Add("sprites/light_glow02_add", self.EndPos)
	-- 	part:SetAngleVelocity(AngleRand(0, 90) * math.Rand(-1, 1))
	-- 	part:SetVelocity(data:GetNormal() * 200 + VectorRand() * 300)
	-- 	part:SetDieTime(math.Rand(0.2, 0.4))
	-- 	part:SetMaterial( self.Mat2 )

	-- 	part:SetStartSize(2)
	-- 	part:SetEndSize(0)

	-- 	if self.Element == 1 then
	-- 		part:SetColor(128, 0, 255)
	-- 	elseif self.Element == 2 then
	-- 		part:SetColor(255, 128, 0)
	-- 	elseif self.Element == 3 then
	-- 		part:SetColor(150, 188, 255)
	-- 	elseif self.Element == 4 then
	-- 		part:SetColor(20, 50, 255)
	-- 	end

	-- 	part:SetAirResistance(10)
	-- 	part:SetCollide(true)

	-- 	part:SetStartAlpha(255)
	-- 	part:SetEndAlpha(0)

	-- end

	-- emitter:Finish()

	if CLIENT then
		local mLight = DynamicLight( NULL )
		if ( mLight ) then
			mLight.pos = self.EndPos
			if self.Element == 1 then
				mLight.r = 100
				mLight.g = 70
				mLight.b = 255
			elseif self.Element == 2 then
				mLight.r = 255
				mLight.g = 150
				mLight.b = 0
			elseif self.Element == 3 then
				mLight.r = 100
				mLight.g = 150
				mLight.b = 255
			elseif self.Element == 3 then
				mLight.r = 0
				mLight.g = 0
				mLight.b = 255
			else
				mLight.r = 255
				mLight.g = 255
				mLight.b = 255
			end
			
			mLight.brightness = 2
			mLight.Size = 200 
			mLight.Decay = 1024
			mLight.Style = 1
			mLight.DieTime = CurTime() + 0.5
		end
	end

end

function EFFECT:Render()
	render.SetMaterial(self.Mat)
	render.DrawBeam(self.StartPos, self.EndPos, 8.5, 0, (self.Dist/100), Color( 255, 255, 255, 255 ))
end

function EFFECT:Think()
	
	if(self.Timer1-0.985 <= CurTime()) then
		return false
	end
	
	return true
end